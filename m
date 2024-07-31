Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5612F16C437
	for <mm-commits@vger.kernel.org>; Wed, 31 Jul 2024 20:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722458497; cv=none; b=dP/SPayQg2JuAqZ1NNlpP//rFy+4g1W9ZWcysCrblw02Om01x+wHz+wK2joyWn+oBMLSEJWR+6HFCH68uTmz/w6APColvD/tFeURdj3Rq0tADeKN1c53GhHyAHl8bmeQN4w5Dw3vFpsKSUQiDPaz702cN2yq3fIAo+5Vdw22MbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722458497; c=relaxed/simple;
	bh=nD8fvSkYtv+KL+JP5R31hNJVnBZmJIqZ7VUQWC89oP4=;
	h=Date:To:From:Subject:Message-Id; b=Rz7Mdk4kNWpwe/7HV1N7uoHDn+QOYtG7Zeike4og9o5hlRqR5gm5EfY89Cj+xRug10te5OTzgKVO+bduehKP19ov0JpC6BpgvBOjl+SMNJIc5PQH+jbIP+RCveJfR4N/9m0+jv9zXw61ROhSFIQJWVDm8CrLCSWb0OcbPT9k3XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MKmsAi82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MKmsAi82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DA6C116B1;
	Wed, 31 Jul 2024 20:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722458497;
	bh=nD8fvSkYtv+KL+JP5R31hNJVnBZmJIqZ7VUQWC89oP4=;
	h=Date:To:From:Subject:From;
	b=MKmsAi82suEA2yEnyaTn8cKoJBc0zIToEbCmxr2f2iNM2SLdVPHhQrsbLyxmxziRe
	 fp7OVm796k8AVYamq7rmrPauR0B6ijhUitXDBqXK/GFKlOKA3uBl5OlMZAtHvGaAr2
	 V7x52BocY66Ldgy6l9+O40QD9V1P1JWvGMqiLBLA=
Date: Wed, 31 Jul 2024 13:41:36 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryan.roberts@arm.com,kaleshsingh@google.com,hughd@google.com,chrisl@kernel.org,21cnbao@gmail.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-skip-slot-cache-on-freeing-for-mthp.patch added to mm-unstable branch
Message-Id: <20240731204137.17DA6C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: skip slot cache on freeing for mTHP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-skip-slot-cache-on-freeing-for-mthp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-skip-slot-cache-on-freeing-for-mthp.patch

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
Subject: mm: swap: skip slot cache on freeing for mTHP
Date: Tue, 30 Jul 2024 23:49:17 -0700

Currently when we are freeing mTHP folios from swap cache, we free then
one by one and put each entry into swap slot cache.  Slot cache is
designed to reduce the overhead by batching the freeing, but mTHP swap
entries are already continuous so they can be batch freed without it
already, it saves litle overhead, or even increase overhead for larger
mTHP.

What's more, mTHP entries could stay in swap cache for a while. 
Contiguous swap entry is an rather rare resource so releasing them
directly can help improve mTHP allocation success rate when under
pressure.

Link: https://lkml.kernel.org/r/20240730-swap-allocator-v5-5-cb9c148b9297@kernel.org
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   59 +++++++++++++++++++++---------------------------
 1 file changed, 26 insertions(+), 33 deletions(-)

--- a/mm/swapfile.c~mm-swap-skip-slot-cache-on-freeing-for-mthp
+++ a/mm/swapfile.c
@@ -479,20 +479,21 @@ static void inc_cluster_info_page(struct
 }
 
 /*
- * The cluster ci decreases one usage. If the usage counter becomes 0,
+ * The cluster ci decreases @nr_pages usage. If the usage counter becomes 0,
  * which means no page in the cluster is in use, we can optionally discard
  * the cluster and add it to free cluster list.
  */
-static void dec_cluster_info_page(struct swap_info_struct *p, struct swap_cluster_info *ci)
+static void dec_cluster_info_page(struct swap_info_struct *p,
+				  struct swap_cluster_info *ci, int nr_pages)
 {
 	if (!p->cluster_info)
 		return;
 
-	VM_BUG_ON(ci->count == 0);
+	VM_BUG_ON(ci->count < nr_pages);
 	VM_BUG_ON(cluster_is_free(ci));
 	lockdep_assert_held(&p->lock);
 	lockdep_assert_held(&ci->lock);
-	ci->count--;
+	ci->count -= nr_pages;
 
 	if (!ci->count) {
 		free_cluster(p, ci);
@@ -990,19 +991,6 @@ no_page:
 	return n_ret;
 }
 
-static void swap_free_cluster(struct swap_info_struct *si, unsigned long idx)
-{
-	unsigned long offset = idx * SWAPFILE_CLUSTER;
-	struct swap_cluster_info *ci;
-
-	ci = lock_cluster(si, offset);
-	memset(si->swap_map + offset, 0, SWAPFILE_CLUSTER);
-	ci->count = 0;
-	free_cluster(si, ci);
-	unlock_cluster(ci);
-	swap_range_free(si, offset, SWAPFILE_CLUSTER);
-}
-
 int get_swap_pages(int n_goal, swp_entry_t swp_entries[], int entry_order)
 {
 	int order = swap_entry_order(entry_order);
@@ -1261,21 +1249,28 @@ static unsigned char __swap_entry_free(s
 	return usage;
 }
 
-static void swap_entry_free(struct swap_info_struct *p, swp_entry_t entry)
+/*
+ * Drop the last HAS_CACHE flag of swap entries, caller have to
+ * ensure all entries belong to the same cgroup.
+ */
+static void swap_entry_range_free(struct swap_info_struct *p, swp_entry_t entry,
+				  unsigned int nr_pages)
 {
-	struct swap_cluster_info *ci;
 	unsigned long offset = swp_offset(entry);
-	unsigned char count;
+	unsigned char *map = p->swap_map + offset;
+	unsigned char *map_end = map + nr_pages;
+	struct swap_cluster_info *ci;
 
 	ci = lock_cluster(p, offset);
-	count = p->swap_map[offset];
-	VM_BUG_ON(count != SWAP_HAS_CACHE);
-	p->swap_map[offset] = 0;
-	dec_cluster_info_page(p, ci);
+	do {
+		VM_BUG_ON(*map != SWAP_HAS_CACHE);
+		*map = 0;
+	} while (++map < map_end);
+	dec_cluster_info_page(p, ci, nr_pages);
 	unlock_cluster(ci);
 
-	mem_cgroup_uncharge_swap(entry, 1);
-	swap_range_free(p, offset, 1);
+	mem_cgroup_uncharge_swap(entry, nr_pages);
+	swap_range_free(p, offset, nr_pages);
 }
 
 static void cluster_swap_free_nr(struct swap_info_struct *sis,
@@ -1336,7 +1331,6 @@ void swap_free_nr(swp_entry_t entry, int
 void put_swap_folio(struct folio *folio, swp_entry_t entry)
 {
 	unsigned long offset = swp_offset(entry);
-	unsigned long idx = offset / SWAPFILE_CLUSTER;
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
 	unsigned char *map;
@@ -1349,19 +1343,18 @@ void put_swap_folio(struct folio *folio,
 		return;
 
 	ci = lock_cluster_or_swap_info(si, offset);
-	if (size == SWAPFILE_CLUSTER) {
+	if (size > 1) {
 		map = si->swap_map + offset;
-		for (i = 0; i < SWAPFILE_CLUSTER; i++) {
+		for (i = 0; i < size; i++) {
 			val = map[i];
 			VM_BUG_ON(!(val & SWAP_HAS_CACHE));
 			if (val == SWAP_HAS_CACHE)
 				free_entries++;
 		}
-		if (free_entries == SWAPFILE_CLUSTER) {
+		if (free_entries == size) {
 			unlock_cluster_or_swap_info(si, ci);
 			spin_lock(&si->lock);
-			mem_cgroup_uncharge_swap(entry, SWAPFILE_CLUSTER);
-			swap_free_cluster(si, idx);
+			swap_entry_range_free(si, entry, size);
 			spin_unlock(&si->lock);
 			return;
 		}
@@ -1406,7 +1399,7 @@ void swapcache_free_entries(swp_entry_t
 	for (i = 0; i < n; ++i) {
 		p = swap_info_get_cont(entries[i], prev);
 		if (p)
-			swap_entry_free(p, entries[i]);
+			swap_entry_range_free(p, entries[i], 1);
 		prev = p;
 	}
 	if (p)
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-clean-up-initialization-helper.patch
mm-swap-skip-slot-cache-on-freeing-for-mthp.patch
mm-swap-allow-cache-reclaim-to-skip-slot-cache.patch
mm-swap-add-a-fragment-cluster-list.patch
mm-swap-relaim-the-cached-parts-that-got-scanned.patch
mm-swap-add-a-adaptive-full-cluster-cache-reclaim.patch

