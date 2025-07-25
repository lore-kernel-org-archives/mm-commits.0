Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE258218592;
	Fri, 25 Jul 2025 02:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409692; cv=none; b=HhCaGono0UlW5kS10pR4cBzMLaRv0wDZ8cm9sC2DWT9rTiK9g08Yn45lDvY0IJouE6ihBl1PGVCkanPPDG4CLjUZkmxfRa91O19PrnAHgAcMoR0vnp1PTchQIM8Ka9Ml/2Npr+ohwLySXf581zUBe5xMefm8n4UeufdyhwwxVxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409692; c=relaxed/simple;
	bh=RsGCxpHDMASvUFv206kHt+KFdM2RGhGEy7+eWiHYYNY=;
	h=Date:To:From:Subject:Message-Id; b=h4e2qEF9//vzphizKrD97KJl03JVXjHlGGCAnYeAcuKTUnMFmmMVrJVTSoDCSD1Ci7DUFWflvhNP0tnO7xytZC5DCTkZf1iJGmoeJF32MfGtgs7xaOLQZ3d6fBRNiZ6ISy7pbGY8s1w2Cpda5F6u0sFbaTQysRAPrSK9s2XL+2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P0OFTcNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P0OFTcNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28FFC4CEF5;
	Fri, 25 Jul 2025 02:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409692;
	bh=RsGCxpHDMASvUFv206kHt+KFdM2RGhGEy7+eWiHYYNY=;
	h=Date:To:From:Subject:From;
	b=P0OFTcNfjRGAkDdC0fonFeBJI8k3Cx5EzkOGFwGTBfuhCNoRzvV42kbC5vBikXQyd
	 Fj3tQmtNKAi+9GmrHXkDJKjRh0OjWKq4U8vh1eDd9gc3qScVmgyyCh1Hd1DJ/Ciq2Q
	 FyNV3iRQqlMXJrij6DiICSyW6RKpe710byDh8RZ0=
Date: Thu, 24 Jul 2025 19:14:52 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kasong@tencent.com,hannes@cmpxchg.org,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch removed from -mm tree
Message-Id: <20250725021452.A28FFC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: correctly use maxpages in swapon syscall to avoid potential deadloop
has been removed from the -mm tree.  Its filename was
     mm-swap-correctly-use-maxpages-in-swapon-syscall-to-avoid-potensial-deadloop.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: correctly use maxpages in swapon syscall to avoid potential deadloop
Date: Thu, 22 May 2025 20:25:52 +0800

We use maxpages from read_swap_header() to initialize swap_info_struct,
however the maxpages might be reduced in setup_swap_extents() and the
si->max is assigned with the reduced maxpages from the
setup_swap_extents().

Obviously, this could lead to memory waste as we allocated memory based on
larger maxpages, besides, this could lead to a potential deadloop as
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

After this change, span will include badblocks and will become large
value which I think is correct value:
In summary, there are two kinds of swapfile_activate operations.

1. Filesystem style: Treat all blocks logical continuity and find
   usable physical extents in logical range.  In this way, si->pages will
   be actual usable physical blocks and span will be "1 + highest_block -
   lowest_block".

2. Block device style: Treat all blocks physically continue and only
   one single extent is added.  In this way, si->pages will be si->max and
   span will be "si->pages - 1".  Actually, si->pages and si->max is only
   used in block device style and span value is set with si->pages.  As a
   result, span value in block device style will become a larger value as
   you mentioned.

I think larger value is correct based on:

1. Span value in filesystem style is "1 + highest_block -
   lowest_block" which is the range cover all possible phisical blocks
   including the badblocks.

2. For block device style, si->pages is the actual usable block number
   and is already in pr_info.  The original span value before this patch
   is also refer to usable block number which is redundant in pr_info.

[shikemeng@huaweicloud.com: ensure si->pages == si->max - 1 after setup_swap_extents()]
  Link: https://lkml.kernel.org/r/20250522122554.12209-3-shikemeng@huaweicloud.com
  Link: https://lkml.kernel.org/r/20250718065139.61989-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20250522122554.12209-3-shikemeng@huaweicloud.com
Fixes: 661383c6111a ("mm: swap: relaim the cached parts that got scanned")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   53 +++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

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
@@ -3363,6 +3350,21 @@ SYSCALL_DEFINE2(swapon, const char __use
 		goto bad_swap_unlock_inode;
 	}
 
+	si->max = maxpages;
+	si->pages = maxpages - 1;
+	nr_extents = setup_swap_extents(si, &span);
+	if (nr_extents < 0) {
+		error = nr_extents;
+		goto bad_swap_unlock_inode;
+	}
+	if (si->pages != si->max - 1) {
+		pr_err("swap:%u != (max:%u - 1)\n", si->pages, si->max);
+		error = -EINVAL;
+		goto bad_swap_unlock_inode;
+	}
+
+	maxpages = si->max;
+
 	/* OK, set up the swap map and apply the bad block list */
 	swap_map = vzalloc(maxpages);
 	if (!swap_map) {
@@ -3374,12 +3376,9 @@ SYSCALL_DEFINE2(swapon, const char __use
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


