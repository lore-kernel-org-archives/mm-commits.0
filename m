Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B0235F5FB
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388544; cv=none; b=ZOTu+PwuLGBHfAo8/rfl++CFJn9MAl1G5gvt2sxX6yLU4TraTmm31/fL+ickpi2+8pM2p+iIKdhuQNC4bRtWjmw9oAxQ34bSX2/ZZzBKAROYYs12p8pPeGvbKPBXIkyJ4MnHmMfzwL85JRAxI+IQ2qECE5H0Hun4GwKTJjC6BeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388544; c=relaxed/simple;
	bh=Wei9R9FqgSXiQAuJz5i0RW0SK1eLdlVu+GrNul8hZvg=;
	h=Date:To:From:Subject:Message-Id; b=QN3q9Gj3bomrmd601qml6oCA/sTuT/pRAloNgCvYW5DuZfwFDblNUYJutvpxHKyy2+QvqoB1yZbDTlhVKbtSwNU/gIqgZt2Cs8xb4Z0mY75NpWFwagGuiCtqaPBU7vgWI8HDu5sKQF7UJsk1NRxQTdznbjdN02mMA8N8kR19F8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p1PhPpbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p1PhPpbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E083CC19424;
	Tue, 24 Mar 2026 21:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388544;
	bh=Wei9R9FqgSXiQAuJz5i0RW0SK1eLdlVu+GrNul8hZvg=;
	h=Date:To:From:Subject:From;
	b=p1PhPpbBrgK5Sqpdsqutl5XQiqsSEAh/hq4NIfzZl6deL8tUV11BiriVkP+mnfJot
	 avHzLuLuwKg8b9BwkCB/essHCtQ8BUoiQlnfeqRfqwOlMtZjkbF/A68VzwXEVfEwfP
	 M6jnS1tDHshT+UtHhEama04Hh4zj+7B8erbFFZVg=
Date: Tue, 24 Mar 2026 14:42:23 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,lkp@intel.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-consolidate-bad-slots-setup-and-make-it-more-robust.patch removed from -mm tree
Message-Id: <20260324214223.E083CC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: consolidate bad slots setup and make it more robust
has been removed from the -mm tree.  Its filename was
     mm-swap-consolidate-bad-slots-setup-and-make-it-more-robust.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: consolidate bad slots setup and make it more robust
Date: Wed, 18 Feb 2026 04:06:29 +0800

In preparation for using the swap table to track bad slots directly, move
the bad slot setup to one place, set up the swap_map mark, and cluster
counter update together.

While at it, provide more informative logs and a more robust fallback if
any bad slot info looks incorrect.

Fixes a potential issue that a malformed swap file may cause the cluster
to be unusable upon swapon, and provides a more verbose warning on a
malformed swap file

Link: https://lkml.kernel.org/r/20260218-swap-table-p3-v3-4-f4e34be021a7@tencent.com
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

 mm/swapfile.c |   68 ++++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

--- a/mm/swapfile.c~mm-swap-consolidate-bad-slots-setup-and-make-it-more-robust
+++ a/mm/swapfile.c
@@ -743,13 +743,37 @@ static void relocate_cluster(struct swap
  * slot. The cluster will not be added to the free cluster list, and its
  * usage counter will be increased by 1. Only used for initialization.
  */
-static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster_info,
-				       unsigned long offset)
+static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
+				       struct swap_cluster_info *cluster_info,
+				       unsigned int offset, bool mask)
 {
 	unsigned long idx = offset / SWAPFILE_CLUSTER;
 	struct swap_table *table;
 	struct swap_cluster_info *ci;
 
+	/* si->max may got shrunk by swap swap_activate() */
+	if (offset >= si->max && !mask) {
+		pr_debug("Ignoring bad slot %u (max: %u)\n", offset, si->max);
+		return 0;
+	}
+	/*
+	 * Account it, skip header slot: si->pages is initiated as
+	 * si->max - 1. Also skip the masking of last cluster,
+	 * si->pages doesn't include that part.
+	 */
+	if (offset && !mask)
+		si->pages -= 1;
+	if (!si->pages) {
+		pr_warn("Empty swap-file\n");
+		return -EINVAL;
+	}
+	/* Check for duplicated bad swap slots. */
+	if (si->swap_map[offset]) {
+		pr_warn("Duplicated bad slot offset %d\n", offset);
+		return -EINVAL;
+	}
+
+	si->swap_map[offset] = SWAP_MAP_BAD;
 	ci = cluster_info + idx;
 	if (!ci->table) {
 		table = swap_table_alloc(GFP_KERNEL);
@@ -3220,30 +3244,12 @@ static int setup_swap_map(struct swap_in
 			  union swap_header *swap_header,
 			  unsigned long maxpages)
 {
-	unsigned long i;
 	unsigned char *swap_map;
 
 	swap_map = vzalloc(maxpages);
 	si->swap_map = swap_map;
 	if (!swap_map)
 		return -ENOMEM;
-
-	swap_map[0] = SWAP_MAP_BAD; /* omit header page */
-	for (i = 0; i < swap_header->info.nr_badpages; i++) {
-		unsigned int page_nr = swap_header->info.badpages[i];
-		if (page_nr == 0 || page_nr > swap_header->info.last_page)
-			return -EINVAL;
-		if (page_nr < maxpages) {
-			swap_map[page_nr] = SWAP_MAP_BAD;
-			si->pages--;
-		}
-	}
-
-	if (!si->pages) {
-		pr_warn("Empty swap-file\n");
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
@@ -3273,26 +3279,28 @@ static int setup_swap_clusters_info(stru
 	}
 
 	/*
-	 * Mark unusable pages as unavailable. The clusters aren't
-	 * marked free yet, so no list operations are involved yet.
-	 *
-	 * See setup_swap_map(): header page, bad pages,
-	 * and the EOF part of the last cluster.
+	 * Mark unusable pages (header page, bad pages, and the EOF part of
+	 * the last cluster) as unavailable. The clusters aren't marked free
+	 * yet, so no list operations are involved yet.
 	 */
-	err = swap_cluster_setup_bad_slot(cluster_info, 0);
+	err = swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
 	if (err)
 		goto err;
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
 
-		if (page_nr >= maxpages)
-			continue;
-		err = swap_cluster_setup_bad_slot(cluster_info, page_nr);
+		if (!page_nr || page_nr > swap_header->info.last_page) {
+			pr_warn("Bad slot offset is out of border: %d (last_page: %d)\n",
+				page_nr, swap_header->info.last_page);
+			err = -EINVAL;
+			goto err;
+		}
+		err = swap_cluster_setup_bad_slot(si, cluster_info, page_nr, false);
 		if (err)
 			goto err;
 	}
 	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
-		err = swap_cluster_setup_bad_slot(cluster_info, i);
+		err = swap_cluster_setup_bad_slot(si, cluster_info, i, true);
 		if (err)
 			goto err;
 	}
_

Patches currently in -mm which might be from kasong@tencent.com are


