Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ECBDC43334
	for <mm-commits@archiver.kernel.org>; Fri, 15 Jul 2022 23:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiGOXZT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Jul 2022 19:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiGOXZT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jul 2022 19:25:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C52A1B4
        for <mm-commits@vger.kernel.org>; Fri, 15 Jul 2022 16:25:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65AFBB82EFD
        for <mm-commits@vger.kernel.org>; Fri, 15 Jul 2022 23:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CD2C34115;
        Fri, 15 Jul 2022 23:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657927515;
        bh=hWX/HEHAHCaWfxTWun9MpB9n5+/zF/JupwszkJaJXr8=;
        h=Date:To:From:Subject:From;
        b=mI7nnmEaW1MfIm6IXMi/hJF82Ovid6uWtdbihKKjOzeWvlYeyMLONQ8Vy9cYFXhjM
         7FJ5fhd0jzS8WsC5KBa4WsDB8RadbfBXRnfI3VgRgTXMgcKmFn+jzMVH8lF/JpfLQq
         cCIo7MnYZdUsd7BXRp09b9ThJ5AHgh/YH7Fnds6I=
Date:   Fri, 15 Jul 2022 16:25:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, david@redhat.com,
        apopple@nvidia.com, alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-is_pinnable_pages-to-is_longterm_pinnable_pages.patch added to mm-unstable branch
Message-Id: <20220715232514.F1CD2C34115@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename is_pinnable_page() to is_longterm_pinnable_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rename-is_pinnable_pages-to-is_longterm_pinnable_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-is_pinnable_pages-to-is_longterm_pinnable_pages.patch

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
From: Alex Sierra <alex.sierra@amd.com>
Subject: mm: rename is_pinnable_page() to is_longterm_pinnable_page()
Date: Fri, 15 Jul 2022 10:05:08 -0500

Patch series "Add MEMORY_DEVICE_COHERENT for coherent device memory
mapping", v9.

This patch series introduces MEMORY_DEVICE_COHERENT, a type of memory
owned by a device that can be mapped into CPU page tables like
MEMORY_DEVICE_GENERIC and can also be migrated like MEMORY_DEVICE_PRIVATE.

This patch series is mostly self-contained except for a few places where
it needs to update other subsystems to handle the new memory type.

System stability and performance are not affected according to our ongoing
testing, including xfstests.

How it works: The system BIOS advertises the GPU device memory (aka VRAM)
as SPM (special purpose memory) in the UEFI system address map.

The amdgpu driver registers the memory with devmap as
MEMORY_DEVICE_COHERENT using devm_memremap_pages.  The initial user for
this hardware page migration capability is the Frontier supercomputer
project.  This functionality is not AMD-specific.  We expect other GPU
vendors to find this functionality useful, and possibly other hardware
types in the future.

Our test nodes in the lab are similar to the Frontier configuration, with
.5 TB of system memory plus 256 GB of device memory split across 4 GPUs,
all in a single coherent address space.  Page migration is expected to
improve application efficiency significantly.  We will report empirical
results as they become available.

Coherent device type pages at gup are now migrated back to system memory
if they are being pinned long-term (FOLL_LONGTERM).  The reason is, that
long-term pinning would interfere with the device memory manager owning
the device-coherent pages (e.g.  evictions in TTM).  These series
incorporate Alistair Popple patches to do this migration from
pin_user_pages() calls.  hmm_gup_test has been added to hmm-test to test
different get user pages calls.

This series includes handling of device-managed anonymous pages returned
by vm_normal_pages.  Although they behave like normal pages for purposes
of mapping in CPU page tables and for COW, they do not support LRU lists,
NUMA migration or THP.

We also introduced a FOLL_LRU flag that adds the same behaviour to
follow_page and related APIs, to allow callers to specify that they expect
to put pages on an LRU list.


This patch (of 14):

is_pinnable_page() and folio_is_pinnable() are renamed to
is_longterm_pinnable_page() and folio_is_longterm_pinnable() respectively.
These functions are used in the FOLL_LONGTERM flag context.

Link: https://lkml.kernel.org/r/20220715150521.18165-1-alex.sierra@amd.com
Link: https://lkml.kernel.org/r/20220715150521.18165-2-alex.sierra@amd.com
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 ++++----
 mm/gup.c           |    4 ++--
 mm/gup_test.c      |    2 +-
 mm/hugetlb.c       |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-rename-is_pinnable_pages-to-is_longterm_pinnable_pages
+++ a/include/linux/mm.h
@@ -1642,7 +1642,7 @@ static inline bool page_needs_cow_for_dm
 
 /* MIGRATE_CMA and ZONE_MOVABLE do not allow pin pages */
 #ifdef CONFIG_MIGRATION
-static inline bool is_pinnable_page(struct page *page)
+static inline bool is_longterm_pinnable_page(struct page *page)
 {
 #ifdef CONFIG_CMA
 	int mt = get_pageblock_migratetype(page);
@@ -1653,15 +1653,15 @@ static inline bool is_pinnable_page(stru
 	return !is_zone_movable_page(page) || is_zero_pfn(page_to_pfn(page));
 }
 #else
-static inline bool is_pinnable_page(struct page *page)
+static inline bool is_longterm_pinnable_page(struct page *page)
 {
 	return true;
 }
 #endif
 
-static inline bool folio_is_pinnable(struct folio *folio)
+static inline bool folio_is_longterm_pinnable(struct folio *folio)
 {
-	return is_pinnable_page(&folio->page);
+	return is_longterm_pinnable_page(&folio->page);
 }
 
 static inline void set_page_zone(struct page *page, enum zone_type zone)
--- a/mm/gup.c~mm-rename-is_pinnable_pages-to-is_longterm_pinnable_pages
+++ a/mm/gup.c
@@ -134,7 +134,7 @@ struct folio *try_grab_folio(struct page
 		 * path.
 		 */
 		if (unlikely((flags & FOLL_LONGTERM) &&
-			     !is_pinnable_page(page)))
+			     !is_longterm_pinnable_page(page)))
 			return NULL;
 
 		/*
@@ -1926,7 +1926,7 @@ static long check_and_migrate_movable_pa
 			continue;
 		prev_folio = folio;
 
-		if (folio_is_pinnable(folio))
+		if (folio_is_longterm_pinnable(folio))
 			continue;
 
 		/*
--- a/mm/gup_test.c~mm-rename-is_pinnable_pages-to-is_longterm_pinnable_pages
+++ a/mm/gup_test.c
@@ -53,7 +53,7 @@ static void verify_dma_pinned(unsigned i
 				dump_page(page, "gup_test failure");
 				break;
 			} else if (cmd == PIN_LONGTERM_BENCHMARK &&
-				WARN(!is_pinnable_page(page),
+				WARN(!is_longterm_pinnable_page(page),
 				     "pages[%lu] is NOT pinnable but pinned\n",
 				     i)) {
 				dump_page(page, "gup_test failure");
--- a/mm/hugetlb.c~mm-rename-is_pinnable_pages-to-is_longterm_pinnable_pages
+++ a/mm/hugetlb.c
@@ -1129,7 +1129,7 @@ static struct page *dequeue_huge_page_no
 
 	lockdep_assert_held(&hugetlb_lock);
 	list_for_each_entry(page, &h->hugepage_freelists[nid], lru) {
-		if (pin && !is_pinnable_page(page))
+		if (pin && !is_longterm_pinnable_page(page))
 			continue;
 
 		if (PageHWPoison(page))
_

Patches currently in -mm which might be from alex.sierra@amd.com are

mm-rename-is_pinnable_pages-to-is_longterm_pinnable_pages.patch
mm-move-page-zone-helpers-from-mmh-to-mmzoneh.patch
mm-add-zone-device-coherent-type-memory-support.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages.patch
mm-add-device-coherent-vma-selection-for-memory-migration.patch
drm-amdkfd-add-spm-support-for-svm.patch
lib-test_hmm-add-ioctl-to-get-zone-device-type.patch
lib-test_hmm-add-module-param-for-zone-device-type.patch
lib-add-support-for-device-coherent-type-in-test_hmm.patch
tools-update-hmm-test-to-support-device-coherent-type.patch
tools-update-test_hmm-script-to-support-sp-config.patch
tools-add-hmm-gup-tests-for-device-coherent-type.patch
tools-add-selftests-to-hmm-for-cow-in-device-memory.patch

