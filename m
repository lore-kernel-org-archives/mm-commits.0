Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028C6137936
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645181; cv=none; b=uOz+AX7g19xLqEiPwS7sY+2s2QUXmsxiGVJvq4LJBW2NUJo0MrCsNp0Q2j+vG9VCKF4kqb6oplVh60AJvfIuAsBxsUyTG0V2SNzq2Z6jawDmrbxWyZBjwbIiqb6VVhOZxGznFs+q1VhfJr1MhyVZm0KcT8vmtRB+hA8U3BUTFh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645181; c=relaxed/simple;
	bh=Eat+sT1ZRTb2iEklw0sbHkd9ijlCWJr5vnMQZntmoIc=;
	h=Date:To:From:Subject:Message-Id; b=fC3KugvTnYjsok0kirYLb+Ey6gLJEQ1ahBtGuPe+Mx4BgAihlt8yNgfFo2OY+zIGUr3N2OWXEg1gcI0Zce575UwMCiRij7YvUgFDnE1etqnVyGdRm1fdEoLaLC6Nr8kbXs0H6JOvtVPPneiBAXY8lYDFLsZGRcl8pla17vX5E0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SxjUhw6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SxjUhw6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8507C433F1;
	Thu, 22 Feb 2024 23:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645180;
	bh=Eat+sT1ZRTb2iEklw0sbHkd9ijlCWJr5vnMQZntmoIc=;
	h=Date:To:From:Subject:From;
	b=SxjUhw6P+IRdVU82Z5uTSsiVr5enda7KBjzWxCj9CyQn2w8Vl6ai6rons3ToviT6d
	 3oaFzFBvfX8yl9FuGxfJAhdfZJTbZyx7uyIQh6TU5+8ZGlaRb/lmppVzMJzPVtcmql
	 F5I0wlJatC44zERBB8C1ccVLIsEj9DGRx99lndWM=
Date: Thu, 22 Feb 2024 15:39:40 -0800
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-sort-optimize-heapsort-for-equal-elements-in-sift-down-path.patch removed from -mm tree
Message-Id: <20240222233940.C8507C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/sort: optimize heapsort for equal elements in sift-down path
has been removed from the -mm tree.  Its filename was
     lib-sort-optimize-heapsort-for-equal-elements-in-sift-down-path.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/sort: optimize heapsort for equal elements in sift-down path
Date: Sat, 13 Jan 2024 11:13:51 +0800

Patch series "lib/sort: Optimize the number of swaps and comparisons".

This patch series aims to optimize the heapsort algorithm, specifically
targeting a reduction in the number of swaps and comparisons required.


This patch (of 2):

Currently, when searching for the sift-down path and encountering equal
elements, the algorithm chooses the left child.  However, considering that
the height of the right subtree may be one less than that of the left
subtree, selecting the right child in such cases can potentially reduce
the number of comparisons and swaps.

For instance, when sorting an array of 10,000 identical elements, the
current implementation requires 247,209 comparisons.  With this patch, the
number of comparisons can be reduced to 227,241.

Link: https://lkml.kernel.org/r/20240113031352.2395118-1-visitorckw@gmail.com
Link: https://lkml.kernel.org/r/20240113031352.2395118-2-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/sort.c~lib-sort-optimize-heapsort-for-equal-elements-in-sift-down-path
+++ a/lib/sort.c
@@ -262,7 +262,7 @@ void sort_r(void *base, size_t num, size
 		 * average, 3/4 worst-case.)
 		 */
 		for (b = a; c = 2*b + size, (d = c + size) < n;)
-			b = do_cmp(base + c, base + d, cmp_func, priv) >= 0 ? c : d;
+			b = do_cmp(base + c, base + d, cmp_func, priv) > 0 ? c : d;
 		if (d == n)	/* Special case last leaf with no sibling */
 			b = c;
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are


