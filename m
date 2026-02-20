Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52DD1D516C
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 00:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771547806; cv=none; b=ei2DqcRAvk4QF9U9sjVTwxQijiDmPHqjCGvpcboKKQIL0J+MsyAe+tndBQBgyzhxtAGSwDxAOeOo7QPH4Q3R3e/ew6TvEiUK5IXbGqsQYPWWiExntNfLf30NzxqdJyYjx/VzFq8FLLmSTSzs1VpcHsXOMZjoy9A9EBlvq42B8KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771547806; c=relaxed/simple;
	bh=w8+DaqgvKIc5D5rS8OP2vFRjpfV8tg9RzEtxPftB6no=;
	h=Date:To:From:Subject:Message-Id; b=dpiA1H6OIk597QR6nnAGCOcwArquO2U79KFpxdHrAKQ8qT3PWPcFFg+wMzc7Hcl+KKQUIIW+9WzGAns8ktZFmkBOtJ+yYgAsMrLW3MOaykNBrrdfrLAq7+LbWiMZKBEj3ICTfMJ42qEA2kI/jIQoch/Rk4Ta8OTizsk8rRhnyP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gxiuo37i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gxiuo37i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8352DC4CEF7;
	Fri, 20 Feb 2026 00:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771547806;
	bh=w8+DaqgvKIc5D5rS8OP2vFRjpfV8tg9RzEtxPftB6no=;
	h=Date:To:From:Subject:From;
	b=gxiuo37iKcoi4+aXoqheQETAZzpHzmoVSNAUiepXN2jhNd68vgTytRljbtfNYKNjW
	 CRXWUnylQUQ4xWKEDKgVqUEcWguCtblDMwIEBeHeNI4gc0oInTEMZLPLcBFZWsVz73
	 FDbysZuJ786Ta1/FVZkb1pjlh4zE71FElBpSEq8Q=
Date: Thu, 19 Feb 2026 16:36:46 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,lkp@intel.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-simplify-swap-table-sanity-range-check.patch added to mm-new branch
Message-Id: <20260220003646.8352DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: simplify swap table sanity range check
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-simplify-swap-table-sanity-range-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-simplify-swap-table-sanity-range-check.patch

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
Subject: mm, swap: simplify swap table sanity range check
Date: Wed, 18 Feb 2026 04:06:33 +0800

The newly introduced helper, which checks bad slots and emptiness of a
cluster, can cover the older sanity check just fine, with a more rigorous
condition check.  So merge them.

Link: https://lkml.kernel.org/r/20260218-swap-table-p3-v3-8-f4e34be021a7@tencent.com
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

 mm/swapfile.c |   35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

--- a/mm/swapfile.c~mm-swap-simplify-swap-table-sanity-range-check
+++ a/mm/swapfile.c
@@ -459,9 +459,11 @@ static void swap_table_free(struct swap_
  * One special case is that bad slots can't be freed, so check the number of
  * bad slots for swapoff, and non-swapoff path must never free bad slots.
  */
-static void swap_cluster_assert_empty(struct swap_cluster_info *ci, bool swapoff)
+static void swap_cluster_assert_empty(struct swap_cluster_info *ci,
+				      unsigned int ci_off, unsigned int nr,
+				      bool swapoff)
 {
-	unsigned int ci_off = 0, ci_end = SWAPFILE_CLUSTER;
+	unsigned int ci_end = ci_off + nr;
 	unsigned long swp_tb;
 	int bad_slots = 0;
 
@@ -588,7 +590,7 @@ static void swap_cluster_schedule_discar
 
 static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info *ci)
 {
-	swap_cluster_assert_empty(ci, false);
+	swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, false);
 	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
@@ -898,26 +900,6 @@ static bool cluster_scan_range(struct sw
 	return true;
 }
 
-/*
- * Currently, the swap table is not used for count tracking, just
- * do a sanity check here to ensure nothing leaked, so the swap
- * table should be empty upon freeing.
- */
-static void swap_cluster_assert_table_empty(struct swap_cluster_info *ci,
-				unsigned int start, unsigned int nr)
-{
-	unsigned int ci_off = start % SWAPFILE_CLUSTER;
-	unsigned int ci_end = ci_off + nr;
-	unsigned long swp_tb;
-
-	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
-		do {
-			swp_tb = __swap_table_get(ci, ci_off);
-			VM_WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
-		} while (++ci_off < ci_end);
-	}
-}
-
 static bool cluster_alloc_range(struct swap_info_struct *si,
 				struct swap_cluster_info *ci,
 				struct folio *folio,
@@ -943,13 +925,14 @@ static bool cluster_alloc_range(struct s
 	if (likely(folio)) {
 		order = folio_order(folio);
 		nr_pages = 1 << order;
+		swap_cluster_assert_empty(ci, offset % SWAPFILE_CLUSTER, nr_pages, false);
 		__swap_cache_add_folio(ci, folio, swp_entry(si->type, offset));
 	} else if (IS_ENABLED(CONFIG_HIBERNATION)) {
 		order = 0;
 		nr_pages = 1;
 		WARN_ON_ONCE(si->swap_map[offset]);
 		si->swap_map[offset] = 1;
-		swap_cluster_assert_table_empty(ci, offset, 1);
+		swap_cluster_assert_empty(ci, offset % SWAPFILE_CLUSTER, 1, false);
 	} else {
 		/* Allocation without folio is only possible with hibernation */
 		WARN_ON_ONCE(1);
@@ -1768,7 +1751,7 @@ void swap_entries_free(struct swap_info_
 
 	mem_cgroup_uncharge_swap(entry, nr_pages);
 	swap_range_free(si, offset, nr_pages);
-	swap_cluster_assert_table_empty(ci, offset, nr_pages);
+	swap_cluster_assert_empty(ci, offset % SWAPFILE_CLUSTER, nr_pages, false);
 
 	if (!ci->count)
 		free_cluster(si, ci);
@@ -2780,7 +2763,7 @@ static void free_swap_cluster_info(struc
 		/* Cluster with bad marks count will have a remaining table */
 		spin_lock(&ci->lock);
 		if (rcu_dereference_protected(ci->table, true)) {
-			swap_cluster_assert_empty(ci, true);
+			swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, true);
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

