Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C27DAC433DB
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 749BD64F5C
	for <mm-commits@archiver.kernel.org>; Thu,  4 Feb 2021 00:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbhBDA6n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Feb 2021 19:58:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234349AbhBDA6e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Feb 2021 19:58:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 251F764F6D;
        Thu,  4 Feb 2021 00:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612400257;
        bh=nBM2GJRez2LwEHhR/n6bbuVlQi+l3yIA+A9bFTvZKH4=;
        h=Date:From:To:Subject:From;
        b=K3v1ybAM+Ch3IF7IsT7DbshpoJaCSoEiBUJEiZo99koHIbQrhUNN/N80ym+pasmmr
         pMAv6228+PXb611tFJCpT4xI70SCNxym4r4DMy/CH1qs9gNYKa0/zLi+QkOVSwHG6M
         98ctgr2Qz58z+F8Uk/94Vkopy+InI/CdZerYpmeg=
Date:   Wed, 03 Feb 2021 16:57:35 -0800
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, david@redhat.com, iamjoonsoo.kim@lge.com,
        ira.weiny@intel.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, jmorris@namei.org, mgorman@suse.de,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, peterz@infradead.org,
        rientjes@google.com, rostedt@goodmis.org, sashal@kernel.org,
        tyhicks@linux.microsoft.com, vbabka@suse.cz, willy@infradead.org
Subject:  [to-be-updated] mm-gup-do-not-migrate-zero-page.patch
 removed from -mm tree
Message-ID: <20210204005735.ePoAsnBxT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: do not migrate zero page
has been removed from the -mm tree.  Its filename was
     mm-gup-do-not-migrate-zero-page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: mm/gup: do not migrate zero page

On some platforms ZERO_PAGE(0) might end-up in a movable zone.  Do not
migrate zero page in gup during longterm pinning as migration of zero page
is not allowed.

For example, in x86 QEMU with 16G of memory and kernelcore=5G parameter, I
see the following:

Boot#1: zero_pfn  0x48a8d zero_pfn zone: ZONE_DMA32
Boot#2: zero_pfn 0x20168d zero_pfn zone: ZONE_MOVABLE

On x86, empty_zero_page is declared in .bss and depending on the loader
may end up in different physical locations during boots.

Also, move is_zero_pfn() my_zero_pfn() functions under CONFIG_MMU, because
zero_pfn that they are using is declared in memory.c which is compiled
with CONFIG_MMU.

is_pinnable_page() is needed only when CONFIG_MIGRATION is set, because
without page migration all pages are pinnable, so add a stub version of
is_pinnable_page() for !CONFIG_MIGRATION case.  This also solves issues
where mm.h is included but is_zero_pfn() is not available because of
CONFIG_MMU is not set.

Link: https://lkml.kernel.org/r/20210201153827.444374-9-pasha.tatashin@soleen.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    3 ++-
 include/linux/mmzone.h  |    4 ++++
 include/linux/pgtable.h |    3 +--
 3 files changed, 7 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-gup-do-not-migrate-zero-page
+++ a/include/linux/mm.h
@@ -1124,7 +1124,8 @@ static inline bool is_zone_movable_page(
 /* MIGRATE_CMA and ZONE_MOVABLE do not allow pin pages */
 static inline bool is_pinnable_page(struct page *page)
 {
-	return !is_zone_movable_page(page) && !is_migrate_cma_page(page);
+	return !(is_zone_movable_page(page) || is_migrate_cma_page(page)) ||
+		is_zero_pfn(page_to_pfn(page));
 }
 
 #ifdef CONFIG_DEV_PAGEMAP_OPS
--- a/include/linux/mmzone.h~mm-gup-do-not-migrate-zero-page
+++ a/include/linux/mmzone.h
@@ -407,6 +407,10 @@ enum zone_type {
 	 *    techniques might use alloc_contig_range() to hide previously
 	 *    exposed pages from the buddy again (e.g., to implement some sort
 	 *    of memory unplug in virtio-mem).
+	 * 6. ZERO_PAGE(0), kernelcore/movablecore setups might create
+	 *    situations where ZERO_PAGE(0) which is allocated differently
+	 *    on different platforms may end up in a movable zone. ZERO_PAGE(0)
+	 *    cannot be migrated.
 	 *
 	 * In general, no unmovable allocations that degrade memory offlining
 	 * should end up in ZONE_MOVABLE. Allocators (like alloc_contig_range())
--- a/include/linux/pgtable.h~mm-gup-do-not-migrate-zero-page
+++ a/include/linux/pgtable.h
@@ -1115,6 +1115,7 @@ extern void untrack_pfn(struct vm_area_s
 extern void untrack_pfn_moved(struct vm_area_struct *vma);
 #endif
 
+#ifdef CONFIG_MMU
 #ifdef __HAVE_COLOR_ZERO_PAGE
 static inline int is_zero_pfn(unsigned long pfn)
 {
@@ -1139,8 +1140,6 @@ static inline unsigned long my_zero_pfn(
 }
 #endif
 
-#ifdef CONFIG_MMU
-
 #ifndef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int pmd_trans_huge(pmd_t pmd)
 {
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-gup-do-not-migrate-zero-page-fix.patch
mm-gup-migrate-pinned-pages-out-of-movable-zone.patch
memory-hotplugrst-add-a-note-about-zone_movable-and-page-pinning.patch
mm-gup-change-index-type-to-long-as-it-counts-pages.patch
mm-gup-longterm-pin-migration-cleanup.patch
selftests-vm-gup_test-fix-test-flag.patch
selftests-vm-gup_test-test-faulting-in-kernel-and-verify-pinnable-pages.patch

