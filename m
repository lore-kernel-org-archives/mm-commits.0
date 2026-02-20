Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D747C190664
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 00:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771547804; cv=none; b=K4GGC/7y6D+7bLHP/FMcID+PqWrJNO8NpeY2qWcXikhVLMVFB/1xSp4DOqXYch8GIs73NsEvr8eePmOTeZbUEYr/1va0TN+Kfc4JWxzC0mvsZCvNgJCUSiiBncICqSSGVpMKtN9RZQZ77/V6D6SgMuVd9E7tNGqP/xlePWklVnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771547804; c=relaxed/simple;
	bh=JGXtRpXRQe0nB22Zh0U99V8EY2mg3xcZN7ig4r/Ytks=;
	h=Date:To:From:Subject:Message-Id; b=fPysWVLZJXWe/jUgL7aVyD8OumUZw8B5raXTPBmnNgBnGhWcRjfXPGjDwyJlZWxo0QOogJ+DC/wXd8i46pmWxzVRMvjpTeHn/TRSJXniMKO0r3FT9wa7VQ6fOiSKoW+j0h2hdZ3BcZuf2CNyHIjBH+yyErY7PuYno8TjW8Wp1XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JYm5xvcp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JYm5xvcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0E0C4CEF7;
	Fri, 20 Feb 2026 00:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771547804;
	bh=JGXtRpXRQe0nB22Zh0U99V8EY2mg3xcZN7ig4r/Ytks=;
	h=Date:To:From:Subject:From;
	b=JYm5xvcpB0s2ES2VBb6DwkfKWLc34npd5+uoQMbBKu/bbJWu4PlAxvtXxlYyhs/7G
	 yvfbZfvTCgtQsZI0FL9u6P94Ukhxz4eOW8tLOHNftN0XgWTJEa/3k8OShosl6hZcrC
	 YOONjP92aiV2z4PR9PDChOMRdz6QyZ8busFtGbjM=
Date: Thu, 19 Feb 2026 16:36:43 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,lkp@intel.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-mark-bad-slots-in-swap-table-directly.patch added to mm-new branch
Message-Id: <20260220003644.5E0E0C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: mark bad slots in swap table directly
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-mark-bad-slots-in-swap-table-directly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-mark-bad-slots-in-swap-table-directly.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: mark bad slots in swap table directly
Date: Wed, 18 Feb 2026 04:06:32 +0800

In preparing the deprecating swap_map, mark bad slots in the swap table
too when setting SWAP_MAP_BAD in swap_map.  Also, refine the swap table
sanity check on freeing to adapt to the bad slots change.  For swapoff,
the bad slots count must match the cluster usage count, as nothing should
touch them, and they contribute to the cluster usage count on swapon.  For
ordinary swap table freeing, the swap table of clusters with bad slots
should never be freed since the cluster usage count never reaches zero.

Link: https://lkml.kernel.org/r/20260218-swap-table-p3-v3-7-f4e34be021a7@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   56 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 15 deletions(-)

--- a/mm/swapfile.c~mm-swap-mark-bad-slots-in-swap-table-directly
+++ a/mm/swapfile.c
@@ -454,16 +454,37 @@ static void swap_table_free(struct swap_
 		 swap_table_free_folio_rcu_cb);
 }
 
+/*
+ * Sanity check to ensure nothing leaked, and the specified range is empty.
+ * One special case is that bad slots can't be freed, so check the number of
+ * bad slots for swapoff, and non-swapoff path must never free bad slots.
+ */
+static void swap_cluster_assert_empty(struct swap_cluster_info *ci, bool swapoff)
+{
+	unsigned int ci_off = 0, ci_end = SWAPFILE_CLUSTER;
+	unsigned long swp_tb;
+	int bad_slots = 0;
+
+	if (!IS_ENABLED(CONFIG_DEBUG_VM) && !swapoff)
+		return;
+
+	do {
+		swp_tb = __swap_table_get(ci, ci_off);
+		if (swp_tb_is_bad(swp_tb))
+			bad_slots++;
+		else
+			WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
+	} while (++ci_off < ci_end);
+
+	WARN_ON_ONCE(bad_slots != (swapoff ? ci->count : 0));
+}
+
 static void swap_cluster_free_table(struct swap_cluster_info *ci)
 {
-	unsigned int ci_off;
 	struct swap_table *table;
 
 	/* Only empty cluster's table is allow to be freed  */
 	lockdep_assert_held(&ci->lock);
-	VM_WARN_ON_ONCE(!cluster_is_empty(ci));
-	for (ci_off = 0; ci_off < SWAPFILE_CLUSTER; ci_off++)
-		VM_WARN_ON_ONCE(!swp_tb_is_null(__swap_table_get(ci, ci_off)));
 	table = (void *)rcu_dereference_protected(ci->table, true);
 	rcu_assign_pointer(ci->table, NULL);
 
@@ -567,6 +588,7 @@ static void swap_cluster_schedule_discar
 
 static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
+	swap_cluster_assert_empty(ci, false);
 	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
@@ -747,9 +769,11 @@ static int swap_cluster_setup_bad_slot(s
 				       struct swap_cluster_info *cluster_info,
 				       unsigned int offset, bool mask)
 {
+	unsigned int ci_off = offset % SWAPFILE_CLUSTER;
 	unsigned long idx = offset / SWAPFILE_CLUSTER;
-	struct swap_table *table;
 	struct swap_cluster_info *ci;
+	struct swap_table *table;
+	int ret = 0;
 
 	/* si->max may got shrunk by swap swap_activate() */
 	if (offset >= si->max && !mask) {
@@ -767,13 +791,7 @@ static int swap_cluster_setup_bad_slot(s
 		pr_warn("Empty swap-file\n");
 		return -EINVAL;
 	}
-	/* Check for duplicated bad swap slots. */
-	if (si->swap_map[offset]) {
-		pr_warn("Duplicated bad slot offset %d\n", offset);
-		return -EINVAL;
-	}
 
-	si->swap_map[offset] = SWAP_MAP_BAD;
 	ci = cluster_info + idx;
 	if (!ci->table) {
 		table = swap_table_alloc(GFP_KERNEL);
@@ -781,13 +799,21 @@ static int swap_cluster_setup_bad_slot(s
 			return -ENOMEM;
 		rcu_assign_pointer(ci->table, table);
 	}
-
-	ci->count++;
+	spin_lock(&ci->lock);
+	/* Check for duplicated bad swap slots. */
+	if (__swap_table_xchg(ci, ci_off, SWP_TB_BAD) != SWP_TB_NULL) {
+		pr_warn("Duplicated bad slot offset %d\n", offset);
+		ret = -EINVAL;
+	} else {
+		si->swap_map[offset] = SWAP_MAP_BAD;
+		ci->count++;
+	}
+	spin_unlock(&ci->lock);
 
 	WARN_ON(ci->count > SWAPFILE_CLUSTER);
 	WARN_ON(ci->flags);
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -2754,7 +2780,7 @@ static void free_swap_cluster_info(struc
 		/* Cluster with bad marks count will have a remaining table */
 		spin_lock(&ci->lock);
 		if (rcu_dereference_protected(ci->table, true)) {
-			ci->count = 0;
+			swap_cluster_assert_empty(ci, true);
 			swap_cluster_free_table(ci);
 		}
 		spin_unlock(&ci->lock);
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-speed-up-hibernation-allocation-and-writeout.patch
mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator.patch
mm-swap-clean-up-swapon-process-and-locking.patch
mm-swap-remove-redundant-arguments-and-locking-for-enabling-a-device.patch
mm-swap-consolidate-bad-slots-setup-and-make-it-more-robust.patch
mm-workingset-leave-highest-bits-empty-for-anon-shadow.patch
mm-swap-implement-helpers-for-reserving-data-in-the-swap-table.patch
mm-swap-mark-bad-slots-in-swap-table-directly.patch
mm-swap-simplify-swap-table-sanity-range-check.patch
mm-swap-use-the-swap-table-to-track-the-swap-count.patch
mm-swap-no-need-to-truncate-the-scan-border.patch
mm-swap-simplify-checking-if-a-folio-is-swapped.patch
mm-swap-no-need-to-clear-the-shadow-explicitly.patch

