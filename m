Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB248CE79A9
	for <mm-commits@archiver.kernel.org>; Tue, 19 Sep 2023 20:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbjISUT4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Sep 2023 16:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjISUTz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Sep 2023 16:19:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA72393;
        Tue, 19 Sep 2023 13:19:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406FDC433C8;
        Tue, 19 Sep 2023 20:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695154789;
        bh=MFRflf02psEDADtPzRYWjnW+ykkxML+k7Ux7IEy1sDE=;
        h=Date:To:From:Subject:From;
        b=BJ69u5bu7nNj/RWeT6IkHJ01ba02YjCXXxrLOqT7JeaClthTU6UDKij6B9aNtc//h
         P2nixlyXHNxLx1rnF6X7//0Cq35hiVLHSkFx/Wofx6jXdDToBywHg+tfkY2yeuLd3f
         0LLo9dYhZPYPXbdN3AKMCXU5thwKPeeSuQf0DFyM=
Date:   Tue, 19 Sep 2023 13:19:48 -0700
To:     mm-commits@vger.kernel.org, tvrtko.ursulin@linux.intel.com,
        stable@vger.kernel.org, rodrigo.vivi@intel.com,
        oleksandr@natalenko.name, joonas.lahtinen@linux.intel.com,
        jani.nikula@linux.intel.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + i915-limit-the-length-of-an-sg-list-to-the-requested-length.patch added to mm-hotfixes-unstable branch
Message-Id: <20230919201949.406FDC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: i915: limit the length of an sg list to the requested length
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     i915-limit-the-length-of-an-sg-list-to-the-requested-length.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/i915-limit-the-length-of-an-sg-list-to-the-requested-length.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: i915: limit the length of an sg list to the requested length
Date: Tue, 19 Sep 2023 20:48:55 +0100

The folio conversion changed the behaviour of shmem_sg_alloc_table() to
put the entire length of the last folio into the sg list, even if the sg
list should have been shorter.  gen8_ggtt_insert_entries() relied on the
list being the right langth and would overrun the end of the page tables. 
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

i915-limit-the-length-of-an-sg-list-to-the-requested-length.patch
mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch
buffer-pass-gfp-flags-to-folio_alloc_buffers.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch
ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch
buffer-convert-sb_getblk-to-call-__getblk.patch
ext4-call-bdev_getblk-from-sb_getblk_gfp.patch
buffer-remove-__getblk_gfp.patch
hugetlb-use-a-folio-in-free_hpage_workfn.patch
hugetlb-remove-a-few-calls-to-page_folio.patch
hugetlb-convert-remove_pool_huge_page-to-remove_pool_hugetlb_folio.patch

