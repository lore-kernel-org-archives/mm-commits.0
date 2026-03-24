Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6BC364E92
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388549; cv=none; b=pZWvHUzE6pVfNWtNwIgmKmA6LkpsQswxFRpWqeFsLc/V3B+h5Z+fdoNn02GazcaPzoWeya+oWDcduqTou6D7k2wAq14aM7yspdAVN74j2D1dRKy7x/n/lOLKUWYYzbRPrSpULUy7EC/2ydNi1dxrPbYiDnhaYjj1Misy6h+rh3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388549; c=relaxed/simple;
	bh=Bhk4Y71JTXuu7Rwt6vCtIeLg04+D6wyYc5YPFE1rHNY=;
	h=Date:To:From:Subject:Message-Id; b=fWV2Cc9BoKxNPhXg7Yg04a/sB2wDv33BH2N1CTEfDoF36dLtOK9lDpxoKJF5yJKHYHYxkPn7F5b6chGKWfAqgMRUqA74RNI5BmhNZupoUIQGfL+eu2l7gJHQaKdO21C8xXjqp0WTMwbir2MqoM1b2RaHRWyrR+6EDfPfBJWFIr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JM56p3Pq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JM56p3Pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFEBC19424;
	Tue, 24 Mar 2026 21:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388549;
	bh=Bhk4Y71JTXuu7Rwt6vCtIeLg04+D6wyYc5YPFE1rHNY=;
	h=Date:To:From:Subject:From;
	b=JM56p3Pq/4SC8ekx+sQ0AT+rPheEhXExjXipssTIi+QYcLZzO8RvP3YMvb3TKxR61
	 NaofEXsLbDGnaJGe7jIFntm/IfDtZy+Q1SzO5P6pH0HWmWgJieGqX/xxnqAvVaaHa8
	 cj/5J5WkFY78ZdSolxV6dtvBr8GqzkMZ3xS0cMck=
Date: Tue, 24 Mar 2026 14:42:28 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,lkp@intel.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-simplify-swap-table-sanity-range-check.patch removed from -mm tree
Message-Id: <20260324214229.5CFEBC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: simplify swap table sanity range check
has been removed from the -mm tree.  Its filename was
     mm-swap-simplify-swap-table-sanity-range-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


