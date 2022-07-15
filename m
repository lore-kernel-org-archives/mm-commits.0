Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F58DC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Jul 2022 23:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbiGOXZc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Jul 2022 19:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiGOXZ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jul 2022 19:25:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5FF528A6
        for <mm-commits@vger.kernel.org>; Fri, 15 Jul 2022 16:25:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB62B61EDA
        for <mm-commits@vger.kernel.org>; Fri, 15 Jul 2022 23:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497BFC34115;
        Fri, 15 Jul 2022 23:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657927524;
        bh=A72skYu5sm7CPDMRXP8aQy48fJzjSOqM14w19MHU60I=;
        h=Date:To:From:Subject:From;
        b=G0Iu2heiKscYgvkuHMgHetfz2lFJOnqH8IUVAfiBFtM7Q4Y023xxwQF3Jus4sj8wJ
         4VYZraf+M0md8S8uQbbshxgHaNcrtbXj5/i2hB3IUTeqK9EQLMFnp0mCP4tpujAz0+
         rgcYN7+3yGtWW22S0uZhtAArcN9Y7qdxTVQCS18o=
Date:   Fri, 15 Jul 2022 16:25:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, david@redhat.com,
        apopple@nvidia.com, alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handling-non-lru-pages-returned-by-vm_normal_pages.patch added to mm-unstable branch
Message-Id: <20220715232524.497BFC34115@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: handling Non-LRU pages returned by vm_normal_pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-handling-non-lru-pages-returned-by-vm_normal_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-handling-non-lru-pages-returned-by-vm_normal_pages.patch

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
Subject: mm: handling Non-LRU pages returned by vm_normal_pages
Date: Fri, 15 Jul 2022 10:05:11 -0500

With DEVICE_COHERENT, we'll soon have vm_normal_pages() return
device-managed anonymous pages that are not LRU pages.  Although they
behave like normal pages for purposes of mapping in CPU page, and for COW.
They do not support LRU lists, NUMA migration or THP.

Callers to follow_page() currently don't expect ZONE_DEVICE pages,
however, with DEVICE_COHERENT we might now return ZONE_DEVICE.  Check for
ZONE_DEVICE pages in applicable users of follow_page() as well.

Link: https://lkml.kernel.org/r/20220715150521.18165-5-alex.sierra@amd.com
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>	[v2]
Reviewed-by: Alistair Popple <apopple@nvidia.com>	[v6]
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 mm/huge_memory.c   |    2 +-
 mm/khugepaged.c    |    9 ++++++---
 mm/ksm.c           |    6 +++---
 mm/madvise.c       |    4 ++--
 mm/memory.c        |   10 +++++++++-
 mm/mempolicy.c     |    2 +-
 mm/migrate.c       |    4 ++--
 mm/mlock.c         |    2 +-
 mm/mprotect.c      |    2 +-
 10 files changed, 27 insertions(+), 16 deletions(-)

--- a/fs/proc/task_mmu.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/fs/proc/task_mmu.c
@@ -1803,7 +1803,7 @@ static struct page *can_gather_numa_stat
 		return NULL;
 
 	page = vm_normal_page(vma, addr, pte);
-	if (!page)
+	if (!page || is_zone_device_page(page))
 		return NULL;
 
 	if (PageReserved(page))
--- a/mm/huge_memory.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/mm/huge_memory.c
@@ -2910,7 +2910,7 @@ static int split_huge_pages_pid(int pid,
 
 		if (IS_ERR(page))
 			continue;
-		if (!page)
+		if (!page || is_zone_device_page(page))
 			continue;
 
 		if (!is_transparent_hugepage(page))
--- a/mm/khugepaged.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/mm/khugepaged.c
@@ -611,7 +611,7 @@ static int __collapse_huge_page_isolate(
 			goto out;
 		}
 		page = vm_normal_page(vma, address, pteval);
-		if (unlikely(!page)) {
+		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out;
 		}
@@ -1261,7 +1261,7 @@ static int khugepaged_scan_pmd(struct mm
 			writable = true;
 
 		page = vm_normal_page(vma, _address, pteval);
-		if (unlikely(!page)) {
+		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out_unmap;
 		}
@@ -1472,7 +1472,8 @@ void collapse_pte_mapped_thp(struct mm_s
 			goto abort;
 
 		page = vm_normal_page(vma, addr, *pte);
-
+		if (WARN_ON_ONCE(page && is_zone_device_page(page)))
+			page = NULL;
 		/*
 		 * Note that uprobe, debugger, or MAP_PRIVATE may change the
 		 * page table, but the new page will not be a subpage of hpage.
@@ -1490,6 +1491,8 @@ void collapse_pte_mapped_thp(struct mm_s
 		if (pte_none(*pte))
 			continue;
 		page = vm_normal_page(vma, addr, *pte);
+		if (WARN_ON_ONCE(page && is_zone_device_page(page)))
+			goto abort;
 		page_remove_rmap(page, vma, false);
 	}
 
--- a/mm/ksm.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/mm/ksm.c
@@ -475,7 +475,7 @@ static int break_ksm(struct vm_area_stru
 		cond_resched();
 		page = follow_page(vma, addr,
 				FOLL_GET | FOLL_MIGRATION | FOLL_REMOTE);
-		if (IS_ERR_OR_NULL(page))
+		if (IS_ERR_OR_NULL(page) || is_zone_device_page(page))
 			break;
 		if (PageKsm(page))
 			ret = handle_mm_fault(vma, addr,
@@ -560,7 +560,7 @@ static struct page *get_mergeable_page(s
 		goto out;
 
 	page = follow_page(vma, addr, FOLL_GET);
-	if (IS_ERR_OR_NULL(page))
+	if (IS_ERR_OR_NULL(page) || is_zone_device_page(page))
 		goto out;
 	if (PageAnon(page)) {
 		flush_anon_page(vma, page, addr);
@@ -2311,7 +2311,7 @@ next_mm:
 			if (ksm_test_exit(mm))
 				break;
 			*page = follow_page(vma, ksm_scan.address, FOLL_GET);
-			if (IS_ERR_OR_NULL(*page)) {
+			if (IS_ERR_OR_NULL(*page) || is_zone_device_page(*page)) {
 				ksm_scan.address += PAGE_SIZE;
 				cond_resched();
 				continue;
--- a/mm/madvise.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/mm/madvise.c
@@ -421,7 +421,7 @@ regular_page:
 			continue;
 
 		page = vm_normal_page(vma, addr, ptent);
-		if (!page)
+		if (!page || is_zone_device_page(page))
 			continue;
 
 		/*
@@ -639,7 +639,7 @@ static int madvise_free_pte_range(pmd_t
 		}
 
 		page = vm_normal_page(vma, addr, ptent);
-		if (!page)
+		if (!page || is_zone_device_page(page))
 			continue;
 
 		/*
--- a/mm/memory.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/mm/memory.c
@@ -633,6 +633,14 @@ struct page *vm_normal_page(struct vm_ar
 		if (is_zero_pfn(pfn))
 			return NULL;
 		if (pte_devmap(pte))
+		/*
+		 * NOTE: New users of ZONE_DEVICE will not set pte_devmap()
+		 * and will have refcounts incremented on their struct pages
+		 * when they are inserted into PTEs, thus they are safe to
+		 * return here. Legacy ZONE_DEVICE pages that set pte_devmap()
+		 * do not have refcounts. Example of legacy ZONE_DEVICE is
+		 * MEMORY_DEVICE_FS_DAX type in pmem or virtio_fs drivers.
+		 */
 			return NULL;
 
 		print_bad_pte(vma, addr, pte, NULL);
@@ -4712,7 +4720,7 @@ static vm_fault_t do_numa_page(struct vm
 	pte = pte_modify(old_pte, vma->vm_page_prot);
 
 	page = vm_normal_page(vma, vmf->address, pte);
-	if (!page)
+	if (!page || is_zone_device_page(page))
 		goto out_map;
 
 	/* TODO: handle PTE-mapped THP */
--- a/mm/mempolicy.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/mm/mempolicy.c
@@ -524,7 +524,7 @@ static int queue_pages_pte_range(pmd_t *
 		if (!pte_present(*pte))
 			continue;
 		page = vm_normal_page(vma, addr, *pte);
-		if (!page)
+		if (!page || is_zone_device_page(page))
 			continue;
 		/*
 		 * vm_normal_page() filters out zero pages, but there might
--- a/mm/migrate.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/mm/migrate.c
@@ -1630,7 +1630,7 @@ static int add_page_for_migration(struct
 		goto out;
 
 	err = -ENOENT;
-	if (!page)
+	if (!page || is_zone_device_page(page))
 		goto out;
 
 	err = 0;
@@ -1821,7 +1821,7 @@ static void do_pages_stat_array(struct m
 		if (IS_ERR(page))
 			goto set_status;
 
-		if (page) {
+		if (page && !is_zone_device_page(page)) {
 			err = page_to_nid(page);
 			put_page(page);
 		} else {
--- a/mm/mlock.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/mm/mlock.c
@@ -333,7 +333,7 @@ static int mlock_pte_range(pmd_t *pmd, u
 		if (!pte_present(*pte))
 			continue;
 		page = vm_normal_page(vma, addr, *pte);
-		if (!page)
+		if (!page || is_zone_device_page(page))
 			continue;
 		if (PageTransCompound(page))
 			continue;
--- a/mm/mprotect.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/mm/mprotect.c
@@ -127,7 +127,7 @@ static unsigned long change_pte_range(st
 					continue;
 
 				page = vm_normal_page(vma, addr, oldpte);
-				if (!page || PageKsm(page))
+				if (!page || is_zone_device_page(page) || PageKsm(page))
 					continue;
 
 				/* Also skip shared copy-on-write pages */
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

