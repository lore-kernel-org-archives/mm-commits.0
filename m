Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB10257432;
	Thu, 22 May 2025 21:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747950101; cv=none; b=G6GCKHFdMydxuHEx2+gKKQunrZNatNsAsl/VwE6ydb3PI7NCeUmEgWMLP3sQAG9icc7ZZwIkQn7sJVneSHtxVjC9PP472vaJ9WxLuj68gM+yB5oGgFo6+uLCowka7lcO5x/04Fi8Etple4u6TINKre5GIWj3AV7P8w7J/TVHDH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747950101; c=relaxed/simple;
	bh=6hyFGIz42cfkw1dd0ydz5bc+RnSN+F++3aFPrUzsqMY=;
	h=Date:To:From:Subject:Message-Id; b=TnBwMU/L+myLylyJpuaVNU8/TpRHka5N15GMJgJRchLyT+e1ljvZBk80qvJQpf6e5BxixniQgCZ06fj0xybIKSW/ZRZW6F1xuQgo6VroAE2j7HGfgRc70w4OlRwtmLVEJUGOZNobgyZuwQkmC+GO9b6ngCEw3+wG22gAYOMgntw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ThBh4W8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ThBh4W8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41308C4CEE4;
	Thu, 22 May 2025 21:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747950100;
	bh=6hyFGIz42cfkw1dd0ydz5bc+RnSN+F++3aFPrUzsqMY=;
	h=Date:To:From:Subject:From;
	b=ThBh4W8Y5KlteCsWFsoDyFvDwklDVstxAvQMuhaKBI2fFW3RH4Y9oDaqiNQe+oVfq
	 Z0eCfnXb0/mrpbTYA/e5UV8knKESAf/owQbv6gE/jHIO+m2ypI6LrfWS8QS02EkBxr
	 RZoT2IG1GBBbiiKYr235iI7n2c8xZcH+3Jhz7CKw=
Date: Thu, 22 May 2025 14:41:39 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kasong@tencent.com,hannes@cmpxchg.org,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch added to mm-new branch
Message-Id: <20250522214140.41308C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: correctly use maxpages in swapon syscall to avoid potensial deadloop
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: correctly use maxpages in swapon syscall to avoid potensial deadloop
Date: Thu, 22 May 2025 20:25:52 +0800

We use maxpages from read_swap_header() to initialize swap_info_struct,
however the maxpages might be reduced in setup_swap_extents() and the
si->max is assigned with the reduced maxpages from the
setup_swap_extents().

Obviously, this could lead to memory waste as we allocated memory based on
larger maxpages, besides, this could lead to a potensial deadloop as
following:

1) When calling setup_clusters() with larger maxpages, unavailable
   pages within range [si->max, larger maxpages) are not accounted with
   inc_cluster_info_page().  As a result, these pages are assumed
   available but can not be allocated.  The cluster contains these pages
   can be moved to frag_clusters list after it's all available pages were
   allocated.

2) When the cluster mentioned in 1) is the only cluster in
   frag_clusters list, cluster_alloc_swap_entry() assume order 0
   allocation will never failed and will enter a deadloop by keep trying
   to allocate page from the only cluster in frag_clusters which contains
   no actually available page.

Call setup_swap_extents() to get the final maxpages before
swap_info_struct initialization to fix the issue.

Link: https://lkml.kernel.org/r/20250522122554.12209-3-shikemeng@huaweicloud.com
Fixes: 661383c6111a3 ("mm: swap: relaim the cached parts that got scanned")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: <stable@vger.kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   47 ++++++++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 27 deletions(-)

--- a/mm/swapfile.c~mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop
+++ a/mm/swapfile.c
@@ -3141,43 +3141,30 @@ static unsigned long read_swap_header(st
 	return maxpages;
 }
 
-static int setup_swap_map_and_extents(struct swap_info_struct *si,
-					union swap_header *swap_header,
-					unsigned char *swap_map,
-					unsigned long maxpages,
-					sector_t *span)
+static int setup_swap_map(struct swap_info_struct *si,
+			  union swap_header *swap_header,
+			  unsigned char *swap_map,
+			  unsigned long maxpages)
 {
-	unsigned int nr_good_pages;
 	unsigned long i;
-	int nr_extents;
-
-	nr_good_pages = maxpages - 1;	/* omit header page */
 
+	swap_map[0] = SWAP_MAP_BAD; /* omit header page */
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
 		if (page_nr == 0 || page_nr > swap_header->info.last_page)
 			return -EINVAL;
 		if (page_nr < maxpages) {
 			swap_map[page_nr] = SWAP_MAP_BAD;
-			nr_good_pages--;
+			si->pages--;
 		}
 	}
 
-	if (nr_good_pages) {
-		swap_map[0] = SWAP_MAP_BAD;
-		si->max = maxpages;
-		si->pages = nr_good_pages;
-		nr_extents = setup_swap_extents(si, span);
-		if (nr_extents < 0)
-			return nr_extents;
-		nr_good_pages = si->pages;
-	}
-	if (!nr_good_pages) {
+	if (!si->pages) {
 		pr_warn("Empty swap-file\n");
 		return -EINVAL;
 	}
 
-	return nr_extents;
+	return 0;
 }
 
 #define SWAP_CLUSTER_INFO_COLS						\
@@ -3217,7 +3204,7 @@ static struct swap_cluster_info *setup_c
 	 * Mark unusable pages as unavailable. The clusters aren't
 	 * marked free yet, so no list operations are involved yet.
 	 *
-	 * See setup_swap_map_and_extents(): header page, bad pages,
+	 * See setup_swap_map(): header page, bad pages,
 	 * and the EOF part of the last cluster.
 	 */
 	inc_cluster_info_page(si, cluster_info, 0);
@@ -3354,6 +3341,15 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap_unlock_inode;
 	}
 
+	si->max = maxpages;
+	si->pages = maxpages - 1;
+	nr_extents = setup_swap_extents(si, &span);
+	if (nr_extents < 0) {
+		error = nr_extents;
+		goto bad_swap_unlock_inode;
+	}
+	maxpages = si->max;
+
 	/* OK, set up the swap map and apply the bad block list */
 	swap_map = vzalloc(maxpages);
 	if (!swap_map) {
@@ -3365,12 +3361,9 @@ SYSCALL_DEFINE2(swapon, const char __use
 	if (error)
 		goto bad_swap_unlock_inode;
 
-	nr_extents = setup_swap_map_and_extents(si, swap_header, swap_map,
-						maxpages, &span);
-	if (unlikely(nr_extents < 0)) {
-		error = nr_extents;
+	error = setup_swap_map(si, swap_header, swap_map, maxpages);
+	if (error)
 		goto bad_swap_unlock_inode;
-	}
 
 	/*
 	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch
mm-shmem-add-missing-shmem_unacct_size-in-__shmem_file_setup.patch
mm-shmem-fix-potential-dead-loop-in-shmem_unuse.patch
mm-shmem-only-remove-inode-from-swaplist-when-its-swapped-page-count-is-0.patch
mm-shmem-remove-unneeded-xa_is_value-check-in-shmem_unuse_swap_entries.patch
mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc.patch
mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch
mm-swap-fix-potensial-buffer-overflow-in-setup_clusters.patch
mm-swap-remove-stale-comment-stale-comment-in-cluster_alloc_swap_entry.patch

