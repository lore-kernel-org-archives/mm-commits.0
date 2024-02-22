Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEF3FBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645182; cv=none; b=DvWg2DJ+6agUTUEvL5O/z6DAUt8kybKH/icg/wh0AHCRUyjN6MsLIPNks/Xk1nUpHYPSwCXU/dSi2oPah918vHJtrmR8OhTMLMA2fhCtmIRoomfSDx7JzKDpSY0YjOmZqx4hwBko5X5/yxEQVB3tm0V2iOaN7gM5CTvyaSKKIY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645182; c=relaxed/simple;
	bh=oWbRCZgo3lc0tE+4ND+aRYR2engoB/c+LgHu6N4C/+c=;
	h=Date:To:From:Subject:Message-Id; b=ZaoL+/5HPDXS1v22/RpfHtdv01xXsTTDaNbrPmbhLDPKOYroaKo6kKfJRQJDiE05Z1regZcUvXbRBRDO87Rkw4gUBV1pSwBkwWAKgYdEHUqcDgfZuhJe0TuxHOomPvXFmWRUF9kpnuVFTn+aKFIAh25YiYZu9R7N529f+9d+bF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XXBc5fQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XXBc5fQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1008C43390;
	Thu, 22 Feb 2024 23:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645181;
	bh=oWbRCZgo3lc0tE+4ND+aRYR2engoB/c+LgHu6N4C/+c=;
	h=Date:To:From:Subject:From;
	b=XXBc5fQV8T4uqt1E8kw2IoHxnesjBMMcnZj4U9QNWt5U/y5KeeWkXj3SeFp1/NCGs
	 GupQCN8DeciVgTShCnYzBkLAryFWao/E3/zarlVWVogFVSdu17CMNK1lxprSyMOKQi
	 EVgVo4KwW+gHkAYxaBOqQjcjIT1J1jU5wfL3luCY=
Date: Thu, 22 Feb 2024 15:39:41 -0800
To: mm-commits@vger.kernel.org,lkml@sdf.org,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-sort-optimize-heapsort-with-double-pop-variation.patch removed from -mm tree
Message-Id: <20240222233941.B1008C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/sort: optimize heapsort with double-pop variation
has been removed from the -mm tree.  Its filename was
     lib-sort-optimize-heapsort-with-double-pop-variation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/sort: optimize heapsort with double-pop variation
Date: Sat, 13 Jan 2024 11:13:52 +0800

Instead of popping only the maximum element from the heap during each
iteration, we now pop the two largest elements at once.  Although this
introduces an additional comparison to determine the second largest
element, it enables a reduction in the height of the tree by one during
the heapify operations starting from root's left/right child.  This
reduction in tree height by one leads to a decrease of one comparison and
one swap.

This optimization results in saving approximately 0.5 * n swaps without
increasing the number of comparisons.  Additionally, the heap size during
heapify is now one less than the original size, offering a chance for
further reduction in comparisons and swaps.

The following experimental data is based on the array generated using
get_random_u32().

| N     | swaps (old) | swaps (new) | comparisons (old) | comparisons (new) |
|-------|-------------|-------------|-------------------|-------------------|
| 1000  | 9054        | 8569        | 10328             | 10320             |
| 2000  | 20137       | 19182       | 22634             | 22587             |
| 3000  | 32062       | 30623       | 35833             | 35752             |
| 4000  | 44274       | 42282       | 49332             | 49306             |
| 5000  | 57195       | 54676       | 63300             | 63294             |
| 6000  | 70205       | 67202       | 77599             | 77557             |
| 7000  | 83276       | 79831       | 92113             | 92032             |
| 8000  | 96630       | 92678       | 106635            | 106617            |
| 9000  | 110349      | 105883      | 121505            | 121404            |
| 10000 | 124165      | 119202      | 136628            | 136617            |


Link: https://lkml.kernel.org/r/20240113031352.2395118-3-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: George Spelvin <lkml@sdf.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/lib/sort.c~lib-sort-optimize-heapsort-with-double-pop-variation
+++ a/lib/sort.c
@@ -215,6 +215,7 @@ void sort_r(void *base, size_t num, size
 	/* pre-scale counters for performance */
 	size_t n = num * size, a = (num/2) * size;
 	const unsigned int lsbit = size & -size;  /* Used to find parent */
+	size_t shift = 0;
 
 	if (!a)		/* num < 2 || size == 0 */
 		return;
@@ -242,12 +243,21 @@ void sort_r(void *base, size_t num, size
 	for (;;) {
 		size_t b, c, d;
 
-		if (a)			/* Building heap: sift down --a */
-			a -= size;
-		else if (n -= size)	/* Sorting: Extract root to --n */
+		if (a)			/* Building heap: sift down a */
+			a -= size << shift;
+		else if (n > 3 * size) { /* Sorting: Extract two largest elements */
+			n -= size;
 			do_swap(base, base + n, size, swap_func, priv);
-		else			/* Sort complete */
+			shift = do_cmp(base + size, base + 2 * size, cmp_func, priv) <= 0;
+			a = size << shift;
+			n -= size;
+			do_swap(base + a, base + n, size, swap_func, priv);
+		} else if (n > size) {	/* Sorting: Extract root */
+			n -= size;
+			do_swap(base, base + n, size, swap_func, priv);
+		} else	{		/* Sort complete */
 			break;
+		}
 
 		/*
 		 * Sift element at "a" down into heap.  This is the
_

Patches currently in -mm which might be from visitorckw@gmail.com are


