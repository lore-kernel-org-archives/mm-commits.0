Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408CC16B390
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 20:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722458496; cv=none; b=dTb1NSOeB1evjIOvSw4Uh5bNL0ZFgL/AUrMcgqynRYERq1eQos7iNt3BQkiJX2wE6y9FhXrKQXGRfR3gJgPGgGEJPgsH4OVbziH4VLcpKmciXLzfBLga2330oRhFQmE1raAmYHgzSLCcAHEIgzuI3njTMC3edAYA8cf8bmg+MtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722458496; c=relaxed/simple;
	bh=QOTFjHUDAVqYfhzWpxjVkqliT3Jo82y4799as49p+Zw=;
	h=Date:To:From:Subject:Message-Id; b=GSPvE0PBmeKLzJm/a1W97uRcHW26klYKPq+TbKTRiXmxslqFQPdP2VRDPqez3/XGJ11W2UNqbUsdRfMIZn9WI+7GSmalr043cG8H9/N0DuC8xymYFLTAi4gzQnOE6KlG5utxYiyIIj0feJf9PZaQ+kzmzH0/Rpc/BfG6Op691AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P0mf37Sv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P0mf37Sv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E711C116B1;
	Wed, 31 Jul 2024 20:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722458495;
	bh=QOTFjHUDAVqYfhzWpxjVkqliT3Jo82y4799as49p+Zw=;
	h=Date:To:From:Subject:From;
	b=P0mf37SvUZOcBFQFRNxzVEBmREPvAUQhfKFEcPSeFfSBBaEKyKjy9EvlRXaQBYKsT
	 lRWGTAFErAE64b2yNVKO6bpJIt6O6I7wEYeldNl1ZSEi81RkOolMHwxm+X22v3h1Vn
	 PFMQsUFE2PnxETWyw6XmwvlhRhXaDU9IahiX9gAo=
Date: Wed, 31 Jul 2024 13:41:34 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryan.roberts@arm.com,kaleshsingh@google.com,hughd@google.com,chrisl@kernel.org,21cnbao@gmail.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-clean-up-initialization-helper.patch added to mm-unstable branch
Message-Id: <20240731204135.4E711C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: clean up initialization helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-clean-up-initialization-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-clean-up-initialization-helper.patch

This patch will later appear in the mm-unstable branch at
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

mm-swap-clean-up-initialization-helper.patch
mm-swap-skip-slot-cache-on-freeing-for-mthp.patch
mm-swap-allow-cache-reclaim-to-skip-slot-cache.patch
mm-swap-add-a-fragment-cluster-list.patch
mm-swap-relaim-the-cached-parts-that-got-scanned.patch
mm-swap-add-a-adaptive-full-cluster-cache-reclaim.patch

