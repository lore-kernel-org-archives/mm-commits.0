Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1113819F12D
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 00:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771547797; cv=none; b=MjbjoLvFY27/Jqb+cKjMOGLnB4cYQqCiT61CtZiWtEJMTnkNleQBC9gU0rHY6NeEqRXbU0s0VlgIfylThWD7C91f6HUhnd/16rQNfQ1V7jwvokxcsuQ7MiEja48TynZV9KgX9nI/HmYI7TGbq4OgBJAeGGRpxRAb3n2Wvj0hSDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771547797; c=relaxed/simple;
	bh=U02ty745I0/0z8DIZ8yIQfpjb/TjqD+j6RoktUFzvfg=;
	h=Date:To:From:Subject:Message-Id; b=qpITLZqRCQxyJYIAiAbEPTx2dEf0kXy3Ji1R9mkdkj19HpSuab6/2k4xKLmCqpo2z+0n2fnheSQ0FBUq7QGiOY21D7N0nfAXKXn3epfo1dj8yyBz0w9QVG/cqTEdMcBomFyrTf3zFqqay9XqP10acMw4jgf2gWMrJioVMgKO3+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ItLFVB7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ItLFVB7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7BEC4CEF7;
	Fri, 20 Feb 2026 00:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771547796;
	bh=U02ty745I0/0z8DIZ8yIQfpjb/TjqD+j6RoktUFzvfg=;
	h=Date:To:From:Subject:From;
	b=ItLFVB7vyiO/YsLVhz94FjimPFom/3VxpMHIJKD7zWqyLkZ0n5/Q9K+ohyZ0LWrfO
	 SMcb8XNJL00P6U5/ef1fHulSoy9uPr9LEaEJ8MuC4cH1TRb3/fGB/sxUA9Lzc2MnYC
	 c2DYhsrLGLKs6fC4aZEgV+3JWmRtLZV/2Cg6RRo8=
Date: Thu, 19 Feb 2026 16:36:35 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,lkp@intel.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-consolidate-bad-slots-setup-and-make-it-more-robust.patch added to mm-new branch
Message-Id: <20260220003636.8B7BEC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: consolidate bad slots setup and make it more robust
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-consolidate-bad-slots-setup-and-make-it-more-robust.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-consolidate-bad-slots-setup-and-make-it-more-robust.patch

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
 
@@ -3274,26 +3280,28 @@ static int setup_swap_clusters_info(stru
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

