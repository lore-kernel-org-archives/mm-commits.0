Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADFC20DD1
	for <mm-commits@vger.kernel.org>; Tue, 16 Jan 2024 20:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705435770; cv=none; b=E+rZ9l5MRrp5sVJR9yt7kQ4XiO3YtJfk366q8ZEP0gazYm3mXNu6Mq2+uVJpFrCsit8Nxo87GvByML3N1SWxIRUFAROQlWIOCgj0T694tg+kuA2QBsc5TKMXWh1sp0kODwLxtTOImKgSZKIc+0ZYlPNZDJdjrN07/9PPy44yeUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705435770; c=relaxed/simple;
	bh=5mjG9KobJQrEBFHM//cYozK9v/Z/JpnxwArh7q5MaRM=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=X8jEFHTMBw2VTAhHbN4vihTpaCVbQRvkdXtB40Z92Nlv5Mq+IWACV9e7A3gm6P5YauFRD/nb6FBqMuzGy1523XjVqGDsJQk2UrQPnb61YLIvGpH9zG8acNgP92I9o7SRj5cvzRA0aLSEvfRgJ27nyN3QqcCd4gZYWJjNObY9QVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WiHjpqMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WiHjpqMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2257FC433C7;
	Tue, 16 Jan 2024 20:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705435769;
	bh=5mjG9KobJQrEBFHM//cYozK9v/Z/JpnxwArh7q5MaRM=;
	h=Date:To:From:Subject:From;
	b=WiHjpqMgVNwRTC+dlUJrsTE3eRVtSEkmJ/I3XVmBOSHk/QipWxcAfajv2UA2AYxpL
	 XEp/0s1pQvM94ccQK5tLfBaVUlRKXPzaAqdpRouPAy9E3jetTAYHiooYtHBnERh/hX
	 41w3XnZA1nxDMuaVkBoFPv7J7S7q2AFi9Q18dn6g=
Date: Tue, 16 Jan 2024 12:09:27 -0800
To: mm-commits@vger.kernel.org,lkml@sdf.org,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-sort-optimize-heapsort-with-double-pop-variation.patch added to mm-nonmm-unstable branch
Message-Id: <20240116200929.2257FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/sort: Optimize heapsort with double-pop variation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-sort-optimize-heapsort-with-double-pop-variation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-sort-optimize-heapsort-with-double-pop-variation.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/sort: Optimize heapsort with double-pop variation
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

lib-min_heap-optimize-number-of-calls-to-min_heapify.patch
lib-min_heap-optimize-number-of-comparisons-in-min_heapify.patch
lib-sort-optimize-heapsort-for-equal-elements-in-sift-down-path.patch
lib-sort-optimize-heapsort-with-double-pop-variation.patch

