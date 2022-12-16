Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03819C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 23:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiLPXtb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 18:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiLPXtb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 18:49:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BF22CCA3
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 15:49:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F218D621C4
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 23:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D618C433F0;
        Fri, 16 Dec 2022 23:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671234568;
        bh=9Nx8EUcW76izHjHWACJRhD75sviDLfDl24INOk4ZhpI=;
        h=Date:To:From:Subject:From;
        b=cK7jNVvQbiZD4zyK/Qpi8uBJd9a+XJVc1fGf81pv3VBbFf8fux6VzsfhmMVK15San
         5BZcSa+H36X+NLw3RZhvZg35SXoTTO/tm948A3ZsNRQ2gv81FY7iF00hwnCDX9UpW2
         4RGaNSidFHBgh3eDljLPXUmiUFwUNMKhJ/hJvO8I=
Date:   Fri, 16 Dec 2022 15:49:27 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        tony.luck@intel.com, tongtiangen@huawei.com, shy828301@gmail.com,
        osalvador@suse.de, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jiaqiyan@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-recover-from-poisoned-anonymous-memory.patch added to mm-unstable branch
Message-Id: <20221216234928.4D618C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: recover from poisoned anonymous memory
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-recover-from-poisoned-anonymous-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-recover-from-poisoned-anonymous-memory.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm/khugepaged: recover from poisoned anonymous memory
Date: Mon, 5 Dec 2022 15:40:58 -0800

Patch series "Memory poison recovery in khugepaged collapsing", v9.

Problem
=======

Memory DIMMs are subject to multi-bit flips, i.e.  memory errors.  As
memory size and density increase, the chances of and number of memory
errors increase.  The increasing size and density of server RAM in the
data center and cloud have shown increased uncorrectable memory errors. 
There are already mechanisms in the kernel to recover from uncorrectable
memory errors.  This series of patches provides the recovery mechanism for
the particular kernel agent khugepaged when it collapses memory pages.

Impact
======

The main reason we chose to make khugepaged collapsing tolerant of memory
failures was its high possibility of accessing poisoned memory while
performing functionally optional compaction actions.  Standard
applications typically don't have strict requirements on the size of their
pages.  So they are given 4K pages by the kernel.  The kernel is able to
improve application performance by either

  1) giving applications 2M pages to begin with, or
  2) collapsing 4K pages into 2M pages when possible.

This collapsing operation is done by khugepaged, a kernel agent that is
constantly scanning memory.  When collapsing 4K pages into a 2M page, it
must copy the data from the 4K pages into a physically contiguous 2M page.
Therefore, as long as there exists one poisoned cache line in collapsible
4K pages, khugepaged will eventually access it.  The current impact to
users is a machine check exception triggered kernel panic.  However,
khugepaged’s compaction operations are not functionally required kernel
actions.  Therefore making khugepaged tolerant to poisoned memory will
greatly improve user experience.

This patch series is for cases where khugepaged is the first guy that
detects the memory errors on the poisoned pages.  IOW, the pages are not
known to have memory errors when khugepaged collapsing gets to them.  In
our observation, this happens frequently when the huge page ratio of the
system is relatively low, which is fairly common in virtual machines
running on cloud.

Solution
========

As stated before, it is less desirable to crash the system only because
khugepaged accesses poisoned pages while it is collapsing 4K pages.  The
high level idea of this patch series is to skip the group of pages
(usually 512 4K-size pages) once khugepaged finds one of them is poisoned,
as these pages have become ineligible to be collapsed.

We are also careful to unwind operations khuagepaged has performed before
it detects memory failures.  For example, before copying and collapsing a
group of anonymous pages into a huge page, the source pages will be
isolated and their page table is unlinked from their PMD.  These
operations need to be undone in order to ensure these pages are not
changed/lost from the perspective of other threads (both user and kernel
space).  As for file backed memory pages, there already exists a rollback
case.  This patch just extends it so that khugepaged also correctly rolls
back when it fails to copy poisoned 4K pages.


This patch (of 2):

Make __collapse_huge_page_copy return whether copying anonymous pages
succeeded, and make collapse_huge_page handle the return status.

Break existing PTE scan loop into two for-loops.  The first loop copies
source pages into target huge page, and can fail gracefully when running
into memory errors in source pages.  If copying all pages succeeds, the
second loop releases and clears up these normal pages.  Otherwise, the
second loop rolls back the page table and page states by: -
re-establishing the original PTEs-to-PMD connection.  - releasing source
pages back to their LRU list.

Tested manually:
0. Enable khugepaged on system under test.
1. Start a two-thread application. Each thread allocates a chunk of
   non-huge anonymous memory buffer.
2. Pick 4 random buffer locations (2 in each thread) and inject
   uncorrectable memory errors at corresponding physical addresses.
3. Signal both threads to make their memory buffer collapsible, i.e.
   calling madvise(MADV_HUGEPAGE).
4. Wait and check kernel log: khugepaged is able to recover from poisoned
   pages and skips collapsing them.
5. Signal both threads to inspect their buffer contents and make sure no
   data corruption.

Link: https://lkml.kernel.org/r/20221205234059.42971-1-jiaqiyan@google.com
Link: https://lkml.kernel.org/r/20221205234059.42971-2-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <tongtiangen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    3 
 mm/khugepaged.c                    |  179 ++++++++++++++++++++-------
 2 files changed, 139 insertions(+), 43 deletions(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-recover-from-poisoned-anonymous-memory
+++ a/include/trace/events/huge_memory.h
@@ -36,7 +36,8 @@
 	EM( SCAN_ALLOC_HUGE_PAGE_FAIL,	"alloc_huge_page_failed")	\
 	EM( SCAN_CGROUP_CHARGE_FAIL,	"ccgroup_charge_failed")	\
 	EM( SCAN_TRUNCATED,		"truncated")			\
-	EMe(SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
+	EM( SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
+	EMe(SCAN_COPY_MC,		"copy_poisoned_page")		\
 
 #undef EM
 #undef EMe
--- a/mm/khugepaged.c~mm-khugepaged-recover-from-poisoned-anonymous-memory
+++ a/mm/khugepaged.c
@@ -19,6 +19,7 @@
 #include <linux/page_table_check.h>
 #include <linux/swapops.h>
 #include <linux/shmem_fs.h>
+#include <linux/kmsan.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -55,6 +56,7 @@ enum scan_result {
 	SCAN_CGROUP_CHARGE_FAIL,
 	SCAN_TRUNCATED,
 	SCAN_PAGE_HAS_PRIVATE,
+	SCAN_COPY_MC,
 };
 
 #define CREATE_TRACE_POINTS
@@ -530,6 +532,27 @@ static bool is_refcount_suitable(struct
 	return page_count(page) == expected_refcount;
 }
 
+/*
+ * Copies memory with #MC in source page (@from) handled. Returns number
+ * of bytes not copied if there was an exception; otherwise 0 for success.
+ * Note handling #MC requires arch opt-in.
+ */
+static int copy_mc_page(struct page *to, struct page *from)
+{
+	char *vfrom, *vto;
+	unsigned long ret;
+
+	vfrom = kmap_local_page(from);
+	vto = kmap_local_page(to);
+	ret = copy_mc_to_kernel(vto, vfrom, PAGE_SIZE);
+	if (ret == 0)
+		kmsan_copy_page_meta(to, from);
+	kunmap_local(vto);
+	kunmap_local(vfrom);
+
+	return ret;
+}
+
 static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 					unsigned long address,
 					pte_t *pte,
@@ -670,56 +693,124 @@ out:
 	return result;
 }
 
-static void __collapse_huge_page_copy(pte_t *pte, struct page *page,
-				      struct vm_area_struct *vma,
-				      unsigned long address,
-				      spinlock_t *ptl,
-				      struct list_head *compound_pagelist)
+/*
+ * __collapse_huge_page_copy - attempts to copy memory contents from normal
+ * pages to a hugepage. Cleans up the normal pages if copying succeeds;
+ * otherwise restores the original page table and releases isolated normal pages.
+ * Returns SCAN_SUCCEED if copying succeeds, otherwise returns SCAN_COPY_MC.
+ *
+ * @pte: starting of the PTEs to copy from
+ * @page: the new hugepage to copy contents to
+ * @pmd: pointer to the new hugepage's PMD
+ * @rollback: the original normal pages' PMD
+ * @vma: the original normal pages' virtual memory area
+ * @address: starting address to copy
+ * @pte_ptl: lock on normal pages' PTEs
+ * @compound_pagelist: list that stores compound pages
+ */
+static int __collapse_huge_page_copy(pte_t *pte,
+				     struct page *page,
+				     pmd_t *pmd,
+				     pmd_t rollback,
+				     struct vm_area_struct *vma,
+				     unsigned long address,
+				     spinlock_t *pte_ptl,
+				     struct list_head *compound_pagelist)
 {
 	struct page *src_page, *tmp;
 	pte_t *_pte;
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
-				_pte++, page++, address += PAGE_SIZE) {
-		pte_t pteval = *_pte;
+	pte_t pteval;
+	unsigned long _address;
+	spinlock_t *pmd_ptl;
+	int result = SCAN_SUCCEED;
+
+	/*
+	 * Copying pages' contents is subject to memory poison at any iteration.
+	 */
+	for (_pte = pte, _address = address; _pte < pte + HPAGE_PMD_NR;
+	     _pte++, page++, _address += PAGE_SIZE) {
+		pteval = *_pte;
+
+		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval)))
+			clear_user_highpage(page, _address);
+		else {
+			src_page = pte_page(pteval);
+			if (copy_mc_page(page, src_page) > 0) {
+				result = SCAN_COPY_MC;
+				break;
+			}
+		}
+	}
 
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
-			clear_user_highpage(page, address);
-			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
-			if (is_zero_pfn(pte_pfn(pteval))) {
+	if (likely(result == SCAN_SUCCEED)) {
+		for (_pte = pte, _address = address; _pte < pte + HPAGE_PMD_NR;
+		     _pte++, _address += PAGE_SIZE) {
+			pteval = *_pte;
+			if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+				add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
+				if (is_zero_pfn(pte_pfn(pteval))) {
+					/*
+					 * pte_ptl mostly unnecessary.
+					 */
+					spin_lock(pte_ptl);
+					pte_clear(vma->vm_mm, _address, _pte);
+					spin_unlock(pte_ptl);
+				}
+			} else {
+				src_page = pte_page(pteval);
+				if (!PageCompound(src_page))
+					release_pte_page(src_page);
 				/*
-				 * ptl mostly unnecessary.
+				 * pte_ptl mostly unnecessary, but preempt has
+				 * to be disabled to update the per-cpu stats
+				 * inside page_remove_rmap().
 				 */
-				spin_lock(ptl);
-				ptep_clear(vma->vm_mm, address, _pte);
-				spin_unlock(ptl);
+				spin_lock(pte_ptl);
+				ptep_clear(vma->vm_mm, _address, _pte);
+				page_remove_rmap(src_page, vma, false);
+				spin_unlock(pte_ptl);
+				free_page_and_swap_cache(src_page);
 			}
-		} else {
-			src_page = pte_page(pteval);
-			copy_user_highpage(page, src_page, address, vma);
-			if (!PageCompound(src_page))
-				release_pte_page(src_page);
-			/*
-			 * ptl mostly unnecessary, but preempt has to
-			 * be disabled to update the per-cpu stats
-			 * inside page_remove_rmap().
-			 */
-			spin_lock(ptl);
-			ptep_clear(vma->vm_mm, address, _pte);
-			page_remove_rmap(src_page, vma, false);
-			spin_unlock(ptl);
-			free_page_and_swap_cache(src_page);
+		}
+		list_for_each_entry_safe(src_page, tmp, compound_pagelist, lru) {
+			list_del(&src_page->lru);
+			mod_node_page_state(page_pgdat(src_page),
+					NR_ISOLATED_ANON + page_is_file_lru(src_page),
+					-compound_nr(src_page));
+			unlock_page(src_page);
+			free_swap_cache(src_page);
+			putback_lru_page(src_page);
+		}
+	} else {
+		/*
+		 * Re-establish the regular PMD that points to the regular
+		 * page table. Restoring PMD needs to be done prior to
+		 * releasing pages. Since pages are still isolated and
+		 * locked here, acquiring anon_vma_lock_write is unnecessary.
+		 */
+		pmd_ptl = pmd_lock(vma->vm_mm, pmd);
+		pmd_populate(vma->vm_mm, pmd, pmd_pgtable(rollback));
+		spin_unlock(pmd_ptl);
+		/*
+		 * Release both raw and compound pages isolated
+		 * in __collapse_huge_page_isolate.
+		 */
+		for (_pte = pte, _address = address; _pte < pte + HPAGE_PMD_NR;
+		     _pte++, _address += PAGE_SIZE) {
+			pteval = *_pte;
+			if (!pte_none(pteval) && !is_zero_pfn(pte_pfn(pteval))) {
+				src_page = pte_page(pteval);
+				if (!PageCompound(src_page))
+					release_pte_page(src_page);
+			}
+		}
+		list_for_each_entry_safe(src_page, tmp, compound_pagelist, lru) {
+			list_del(&src_page->lru);
+			release_pte_page(src_page);
 		}
 	}
 
-	list_for_each_entry_safe(src_page, tmp, compound_pagelist, lru) {
-		list_del(&src_page->lru);
-		mod_node_page_state(page_pgdat(src_page),
-				    NR_ISOLATED_ANON + page_is_file_lru(src_page),
-				    -compound_nr(src_page));
-		unlock_page(src_page);
-		free_swap_cache(src_page);
-		putback_lru_page(src_page);
-	}
+	return result;
 }
 
 static void khugepaged_alloc_sleep(void)
@@ -1079,9 +1170,13 @@ static int collapse_huge_page(struct mm_
 	 */
 	anon_vma_unlock_write(vma->anon_vma);
 
-	__collapse_huge_page_copy(pte, hpage, vma, address, pte_ptl,
-				  &compound_pagelist);
+	result = __collapse_huge_page_copy(pte, hpage, pmd, _pmd,
+					   vma, address, pte_ptl,
+					   &compound_pagelist);
 	pte_unmap(pte);
+	if (unlikely(result != SCAN_SUCCEED))
+		goto out_up_write;
+
 	/*
 	 * spin_lock() below is not the equivalent of smp_wmb(), but
 	 * the smp_wmb() inside __SetPageUptodate() can be reused to
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-khugepaged-recover-from-poisoned-anonymous-memory.patch
mm-khugepaged-recover-from-poisoned-file-backed-memory.patch

