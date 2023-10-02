Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBEBCE748F8
	for <mm-commits@archiver.kernel.org>; Mon,  2 Oct 2023 17:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238609AbjJBRBG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Oct 2023 13:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238668AbjJBRA6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2023 13:00:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEA5124;
        Mon,  2 Oct 2023 10:00:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E05C433C7;
        Mon,  2 Oct 2023 17:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696266053;
        bh=VsiIVNsqIQtSnF7xs64ASGFa7W0PWXXPzV3FzncPx9U=;
        h=Date:To:From:Subject:From;
        b=JArhRZ8uF7ycmxV86HYvlRO2bYyILIWa/6outlqopmJamxhITT09ViQ7O2qgWBYl+
         CIS3B6xrkyqHKOqfRG3iHg/lzwsEAAx2ZHaYNZsnmMNs/3pwyrJggzEy+ZgjOSUFzJ
         T84sKUfFqGkJemqe+j3NTIs1L12M2k4domVc2Uk8=
Date:   Mon, 02 Oct 2023 10:00:52 -0700
To:     mm-commits@vger.kernel.org, tvrtko.ursulin@linux.intel.com,
        stable@vger.kernel.org, rodrigo.vivi@intel.com,
        oleksandr@natalenko.name, joonas.lahtinen@linux.intel.com,
        jani.nikula@linux.intel.com, andrzej.hajda@intel.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] i915-limit-the-length-of-an-sg-list-to-the-requested-length.patch removed from -mm tree
Message-Id: <20231002170053.A8E05C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: i915: limit the length of an sg list to the requested length
has been removed from the -mm tree.  Its filename was
     i915-limit-the-length-of-an-sg-list-to-the-requested-length.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: i915: limit the length of an sg list to the requested length
Date: Tue, 19 Sep 2023 20:48:55 +0100

The folio conversion changed the behaviour of shmem_sg_alloc_table() to
put the entire length of the last folio into the sg list, even if the sg
list should have been shorter.  gen8_ggtt_insert_entries() relied on the
list being the right length and would overrun the end of the page tables. 
Other functions may also have been affected.

Clamp the length of the last entry in the sg list to be the expected
length.

Link: https://lkml.kernel.org/r/20230919194855.347582-1-willy@infradead.org
Link: https://gitlab.freedesktop.org/drm/intel/-/issues/9256
Fixes: 0b62af28f249 ("i915: convert shmem_sg_free_table() to use a folio_batch")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Closes: https://lore.kernel.org/lkml/6287208.lOV4Wx5bFT@natalenko.name/
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: <stable@vger.kernel.org>	[6.5.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c~i915-limit-the-length-of-an-sg-list-to-the-requested-length
+++ a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -100,6 +100,7 @@ int shmem_sg_alloc_table(struct drm_i915
 	st->nents = 0;
 	for (i = 0; i < page_count; i++) {
 		struct folio *folio;
+		unsigned long nr_pages;
 		const unsigned int shrink[] = {
 			I915_SHRINK_BOUND | I915_SHRINK_UNBOUND,
 			0,
@@ -150,6 +151,8 @@ int shmem_sg_alloc_table(struct drm_i915
 			}
 		} while (1);
 
+		nr_pages = min_t(unsigned long,
+				folio_nr_pages(folio), page_count - i);
 		if (!i ||
 		    sg->length >= max_segment ||
 		    folio_pfn(folio) != next_pfn) {
@@ -157,13 +160,13 @@ int shmem_sg_alloc_table(struct drm_i915
 				sg = sg_next(sg);
 
 			st->nents++;
-			sg_set_folio(sg, folio, folio_size(folio), 0);
+			sg_set_folio(sg, folio, nr_pages * PAGE_SIZE, 0);
 		} else {
 			/* XXX: could overflow? */
-			sg->length += folio_size(folio);
+			sg->length += nr_pages * PAGE_SIZE;
 		}
-		next_pfn = folio_pfn(folio) + folio_nr_pages(folio);
-		i += folio_nr_pages(folio) - 1;
+		next_pfn = folio_pfn(folio) + nr_pages;
+		i += nr_pages - 1;
 
 		/* Check that the i965g/gm workaround works. */
 		GEM_BUG_ON(gfp & __GFP_DMA32 && next_pfn >= 0x00100000UL);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch
buffer-pass-gfp-flags-to-folio_alloc_buffers.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp-fix.patch
ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch
buffer-convert-sb_getblk-to-call-__getblk.patch
ext4-call-bdev_getblk-from-sb_getblk_gfp.patch
buffer-remove-__getblk_gfp.patch
hugetlb-use-a-folio-in-free_hpage_workfn.patch
hugetlb-remove-a-few-calls-to-page_folio.patch
hugetlb-convert-remove_pool_huge_page-to-remove_pool_hugetlb_folio.patch
mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

