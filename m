Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A04C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 31 May 2022 17:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344711AbiEaRcj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 May 2022 13:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346565AbiEaRci (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2022 13:32:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EF890CDB
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 10:32:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 663C9B815E8
        for <mm-commits@vger.kernel.org>; Tue, 31 May 2022 17:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162B0C3411D;
        Tue, 31 May 2022 17:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654018354;
        bh=7gNZx+dXuJu1vEbINKDhHo649aCF2sUm9/Ds7IEvgE4=;
        h=Date:To:From:Subject:From;
        b=K4qtNV73FEYtIvWW+lHc28xNe1PNBbIDNzNVpDJavFnQieNgPkrDM8rZzrwG/EWpo
         Ch3ytcgYwAjUwhDTmWkwcmxdGzljSUfuPeZgi/kb5a36YQR1/+Xpu10wVmRQ1DghmD
         zTA2olzAsEPlf7YjwJ3s7AvxuFQ3vh/RZ36T9Kgs=
Date:   Tue, 31 May 2022 10:32:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, david@redhat.com,
        apopple@nvidia.com, alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handling-non-lru-pages-returned-by-vm_normal_pages.patch added to mm-unstable branch
Message-Id: <20220531173234.162B0C3411D@smtp.kernel.org>
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
Date: Tue, 31 May 2022 10:56:18 -0500

With DEVICE_COHERENT, we'll soon have vm_normal_pages() return
device-managed anonymous pages that are not LRU pages.  Although they
behave like normal pages for purposes of mapping in CPU page, and for COW.
They do not support LRU lists, NUMA migration or THP.

We also introduce a FOLL_LRU flag that adds the same behaviour to
follow_page and related APIs, to allow callers to specify that they expect
to put pages on an LRU list.

Link: https://lkml.kernel.org/r/20220531155629.20057-3-alex.sierra@amd.com
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 include/linux/mm.h |    3 ++-
 mm/gup.c           |    6 +++++-
 mm/huge_memory.c   |    2 +-
 mm/khugepaged.c    |    9 ++++++---
 mm/ksm.c           |    6 +++---
 mm/madvise.c       |    4 ++--
 mm/memory.c        |    9 ++++++++-
 mm/mempolicy.c     |    2 +-
 mm/migrate.c       |    4 ++--
 mm/mlock.c         |    2 +-
 mm/mprotect.c      |    2 +-
 12 files changed, 33 insertions(+), 18 deletions(-)

--- a/fs/proc/task_mmu.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/fs/proc/task_mmu.c
@@ -1792,7 +1792,7 @@ static struct page *can_gather_numa_stat
 		return NULL;
 
 	page = vm_normal_page(vma, addr, pte);
-	if (!page)
+	if (!page || is_zone_device_page(page))
 		return NULL;
 
 	if (PageReserved(page))
--- a/include/linux/mm.h~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/include/linux/mm.h
@@ -601,7 +601,7 @@ struct vm_operations_struct {
 #endif
 	/*
 	 * Called by vm_normal_page() for special PTEs to find the
-	 * page for @addr.  This is useful if the default behavior
+	 * page for @addr. This is useful if the default behavior
 	 * (using pte_page()) would not find the correct page.
 	 */
 	struct page *(*find_special_page)(struct vm_area_struct *vma,
@@ -2934,6 +2934,7 @@ struct page *follow_page(struct vm_area_
 #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
 #define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
 #define FOLL_TRIED	0x800	/* a retry, previous pass started an IO */
+#define FOLL_LRU        0x1000  /* return only LRU (anon or page cache) */
 #define FOLL_REMOTE	0x2000	/* we are working on non-current tsk/mm */
 #define FOLL_COW	0x4000	/* internal GUP flag */
 #define FOLL_ANON	0x8000	/* don't do file mappings */
--- a/mm/gup.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/mm/gup.c
@@ -532,7 +532,11 @@ retry:
 	}
 
 	page = vm_normal_page(vma, address, pte);
-	if (!page && pte_devmap(pte) && (flags & (FOLL_GET | FOLL_PIN))) {
+	if ((flags & FOLL_LRU) && ((page && is_zone_device_page(page)) ||
+	    (!page && pte_devmap(pte)))) {
+		page = ERR_PTR(-EEXIST);
+		goto out;
+	} else if (!page && pte_devmap(pte) && (flags & (FOLL_GET | FOLL_PIN))) {
 		/*
 		 * Only return device mapping pages in the FOLL_GET or FOLL_PIN
 		 * case since they are only valid while holding the pgmap
--- a/mm/huge_memory.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/mm/huge_memory.c
@@ -2906,7 +2906,7 @@ static int split_huge_pages_pid(int pid,
 		}
 
 		/* FOLL_DUMP to ignore special (like zero) pages */
-		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
+		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP | FOLL_LRU);
 
 		if (IS_ERR(page))
 			continue;
--- a/mm/khugepaged.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/mm/khugepaged.c
@@ -618,7 +618,7 @@ static int __collapse_huge_page_isolate(
 			goto out;
 		}
 		page = vm_normal_page(vma, address, pteval);
-		if (unlikely(!page)) {
+		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out;
 		}
@@ -1267,7 +1267,7 @@ static int khugepaged_scan_pmd(struct mm
 			writable = true;
 
 		page = vm_normal_page(vma, _address, pteval);
-		if (unlikely(!page)) {
+		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out_unmap;
 		}
@@ -1479,7 +1479,8 @@ void collapse_pte_mapped_thp(struct mm_s
 			goto abort;
 
 		page = vm_normal_page(vma, addr, *pte);
-
+		if (WARN_ON_ONCE(page && is_zone_device_page(page)))
+			page = NULL;
 		/*
 		 * Note that uprobe, debugger, or MAP_PRIVATE may change the
 		 * page table, but the new page will not be a subpage of hpage.
@@ -1497,6 +1498,8 @@ void collapse_pte_mapped_thp(struct mm_s
 		if (pte_none(*pte))
 			continue;
 		page = vm_normal_page(vma, addr, *pte);
+		if (WARN_ON_ONCE(page && is_zone_device_page(page)))
+			goto abort;
 		page_remove_rmap(page, vma, false);
 	}
 
--- a/mm/ksm.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/mm/ksm.c
@@ -474,7 +474,7 @@ static int break_ksm(struct vm_area_stru
 	do {
 		cond_resched();
 		page = follow_page(vma, addr,
-				FOLL_GET | FOLL_MIGRATION | FOLL_REMOTE);
+				FOLL_GET | FOLL_MIGRATION | FOLL_REMOTE | FOLL_LRU);
 		if (IS_ERR_OR_NULL(page))
 			break;
 		if (PageKsm(page))
@@ -559,7 +559,7 @@ static struct page *get_mergeable_page(s
 	if (!vma)
 		goto out;
 
-	page = follow_page(vma, addr, FOLL_GET);
+	page = follow_page(vma, addr, FOLL_GET | FOLL_LRU);
 	if (IS_ERR_OR_NULL(page))
 		goto out;
 	if (PageAnon(page)) {
@@ -2307,7 +2307,7 @@ next_mm:
 		while (ksm_scan.address < vma->vm_end) {
 			if (ksm_test_exit(mm))
 				break;
-			*page = follow_page(vma, ksm_scan.address, FOLL_GET);
+			*page = follow_page(vma, ksm_scan.address, FOLL_GET | FOLL_LRU);
 			if (IS_ERR_OR_NULL(*page)) {
 				ksm_scan.address += PAGE_SIZE;
 				cond_resched();
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
@@ -624,6 +624,13 @@ struct page *vm_normal_page(struct vm_ar
 		if (is_zero_pfn(pfn))
 			return NULL;
 		if (pte_devmap(pte))
+/*
+ * NOTE: New uers of ZONE_DEVICE will not set pte_devmap() and will have
+ * refcounts incremented on their struct pages when they are inserted into
+ * PTEs, thus they are safe to return here. Legacy ZONE_DEVICE pages that set
+ * pte_devmap() do not have refcounts. Example of legacy ZONE_DEVICE is
+ * MEMORY_DEVICE_FS_DAX type in pmem or virtio_fs drivers.
+ */
 			return NULL;
 
 		print_bad_pte(vma, addr, pte, NULL);
@@ -4685,7 +4692,7 @@ static vm_fault_t do_numa_page(struct vm
 	pte = pte_modify(old_pte, vma->vm_page_prot);
 
 	page = vm_normal_page(vma, vmf->address, pte);
-	if (!page)
+	if (!page || is_zone_device_page(page))
 		goto out_map;
 
 	/* TODO: handle PTE-mapped THP */
--- a/mm/mempolicy.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages
+++ a/mm/mempolicy.c
@@ -523,7 +523,7 @@ static int queue_pages_pte_range(pmd_t *
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
@@ -1622,7 +1622,7 @@ static int add_page_for_migration(struct
 		goto out;
 
 	/* FOLL_DUMP to ignore special (like zero) pages */
-	page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
+	page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP | FOLL_LRU);
 
 	err = PTR_ERR(page);
 	if (IS_ERR(page))
@@ -1814,7 +1814,7 @@ static void do_pages_stat_array(struct m
 			goto set_status;
 
 		/* FOLL_DUMP to ignore special (like zero) pages */
-		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP);
+		page = follow_page(vma, addr, FOLL_GET | FOLL_DUMP | FOLL_LRU);
 
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
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
@@ -95,7 +95,7 @@ static unsigned long change_pte_range(st
 					continue;
 
 				page = vm_normal_page(vma, addr, oldpte);
-				if (!page || PageKsm(page))
+				if (!page || is_zone_device_page(page) || PageKsm(page))
 					continue;
 
 				/* Also skip shared copy-on-write pages */
_

Patches currently in -mm which might be from alex.sierra@amd.com are

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

