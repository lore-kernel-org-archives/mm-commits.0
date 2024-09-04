Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D20E679E5
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423404; cv=none; b=JxpkogmAsA8rsrfS37be7Jt+1jKYb5aFtImmGRABD2SocXvYqz8EA6ZB47J8RAqS2DPjFWRhske97vFK/H8krbCtS4SBMrLWmyj753iNhp8mWmLngp9vrUKZhqJ1HTMOyqdEZp2PPPJY7sG0/eATno0ObldNWH/RUisc/zyrW2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423404; c=relaxed/simple;
	bh=P7XCA/OTSOrYRND7+TTu+fBUlgdNdMUFKWMA8hW58xw=;
	h=Date:To:From:Subject:Message-Id; b=To86y0bfTIAiXCvjVWl7P2ovSBiNsZQ1pawFnKUi+YhfS6tqcQ5ASi6jN0EnKpa0m3fpUuPvd1z0i8hVyv+jvF4z++ODPoX8g6uvlFU/KEZq7ITSAF/ijwHvvfIl+vMmFxi0KZAkT28MYi/KRTth63Q7F6T/i1wUyt02CsxAS9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TFZKPwey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TFZKPwey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A256C4CEC2;
	Wed,  4 Sep 2024 04:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423404;
	bh=P7XCA/OTSOrYRND7+TTu+fBUlgdNdMUFKWMA8hW58xw=;
	h=Date:To:From:Subject:From;
	b=TFZKPweyDkbNAlVgv39ole5gQs2z03GbB+3gAeYPwNsod5jJSSwsg90EnYwJwRTax
	 1GfofCotGhZetK6UyFs3dRe/mnArjhCJdajD4puhQBuJATvfIG4SCxkvKV0fGAeW1P
	 EhM4a91QWLa9OT2+e432Y6S4elOrHt3dFNdkhWmA=
Date: Tue, 03 Sep 2024 21:16:43 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryan.roberts@arm.com,kaleshsingh@google.com,hughd@google.com,chrisl@kernel.org,21cnbao@gmail.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-clean-up-initialization-helper.patch removed from -mm tree
Message-Id: <20240904041644.1A256C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: clean up initialization helper
has been removed from the -mm tree.  Its filename was
     mm-swap-clean-up-initialization-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm: swap: clean up initialization helper
Date: Tue, 30 Jul 2024 23:49:16 -0700

At this point, alloc_cluster is never called already, and
inc_cluster_info_page is called by initialization only, a lot of dead code
can be dropped.

Link: https://lkml.kernel.org/r/20240730-swap-allocator-v5-4-cb9c148b9297@kernel.org
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   44 ++++++++++----------------------------------
 1 file changed, 10 insertions(+), 34 deletions(-)

--- a/mm/swapfile.c~mm-swap-clean-up-initialization-helper
+++ a/mm/swapfile.c
@@ -438,20 +438,6 @@ static void swap_users_ref_free(struct p
 	complete(&si->comp);
 }
 
-static struct swap_cluster_info *alloc_cluster(struct swap_info_struct *si, unsigned long idx)
-{
-	struct swap_cluster_info *ci = list_first_entry(&si->free_clusters,
-							struct swap_cluster_info, list);
-
-	lockdep_assert_held(&si->lock);
-	lockdep_assert_held(&ci->lock);
-	VM_BUG_ON(cluster_index(si, ci) != idx);
-	VM_BUG_ON(ci->count);
-	list_del(&ci->list);
-	ci->flags = 0;
-	return ci;
-}
-
 static void free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
 	VM_BUG_ON(ci->count != 0);
@@ -472,34 +458,24 @@ static void free_cluster(struct swap_inf
 }
 
 /*
- * The cluster corresponding to page_nr will be used. The cluster will be
- * removed from free cluster list and its usage counter will be increased by
- * count.
+ * The cluster corresponding to page_nr will be used. The cluster will not be
+ * added to free cluster list and its usage counter will be increased by 1.
+ * Only used for initialization.
  */
-static void add_cluster_info_page(struct swap_info_struct *p,
-	struct swap_cluster_info *cluster_info, unsigned long page_nr,
-	unsigned long count)
+static void inc_cluster_info_page(struct swap_info_struct *p,
+	struct swap_cluster_info *cluster_info, unsigned long page_nr)
 {
 	unsigned long idx = page_nr / SWAPFILE_CLUSTER;
-	struct swap_cluster_info *ci = cluster_info + idx;
+	struct swap_cluster_info *ci;
 
 	if (!cluster_info)
 		return;
-	if (cluster_is_free(ci))
-		alloc_cluster(p, idx);
 
-	VM_BUG_ON(ci->count + count > SWAPFILE_CLUSTER);
-	ci->count += count;
-}
+	ci = cluster_info + idx;
+	ci->count++;
 
-/*
- * The cluster corresponding to page_nr will be used. The cluster will be
- * removed from free cluster list and its usage counter will be increased by 1.
- */
-static void inc_cluster_info_page(struct swap_info_struct *p,
-	struct swap_cluster_info *cluster_info, unsigned long page_nr)
-{
-	add_cluster_info_page(p, cluster_info, page_nr, 1);
+	VM_BUG_ON(ci->count > SWAPFILE_CLUSTER);
+	VM_BUG_ON(ci->flags);
 }
 
 /*
_

Patches currently in -mm which might be from kasong@tencent.com are


