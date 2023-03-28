Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F37C76196
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 20:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjC1UTE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 16:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjC1UTD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 16:19:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034BB30DB
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 13:18:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C090F61931
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 20:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E04DC433D2;
        Tue, 28 Mar 2023 20:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680034720;
        bh=JMfkh9jRMIu7kqWHaLPOVae2gCh38MV9r6gcHbU4iyE=;
        h=Date:To:From:Subject:From;
        b=2Im00vsoNiJWYN+9bdWcLyFFPWVcmfp8smLD/X5HOZ7+jEo79joVDIK5tbwhmC3W3
         XBT0IpLjJ1PxdBvUuqS3Whh/V+ArYKQwXQIAaEwRQUGDdrpzRnPqco+FV6jFmvPQAH
         /q16Ktcjc4nt4cD2+1Q6y+wd2HlDZ4Clnb0mFCHE=
Date:   Tue, 28 Mar 2023 13:18:39 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        tony.luck@intel.com, tongtiangen@huawei.com, shy828301@gmail.com,
        osalvador@suse.de, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        kirill@shutemov.name, kirill.shutemov@linux.intel.com,
        jiaqiyan@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-recover-from-poisoned-anonymous-memory.patch added to mm-unstable branch
Message-Id: <20230328201840.1E04DC433D2@smtp.kernel.org>
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
Date: Mon, 27 Mar 2023 14:15:46 -0700

Patch series "Memory poison recovery in khugepaged collapsing", v11.

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
applications typically don't have strict requirements on the size of its
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


This patch (of 11):

Make __collapse_huge_page_copy return whether copying anonymous pages
succeeded, and make collapse_huge_page handle the return status.

Break existing PTE scan loop into two for-loops. The first loop copies
source pages into target huge page, and can fail gracefully when running
into memory errors in source pages. If copying all pages succeeds, the
second loop releases and clears up these normal pages. Otherwise, the
second loop rolls back the page table and page states by:

- re-establishing the original PTEs-to-PMD connection.
- releasing source pages back to their LRU list.

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

Link: https://lkml.kernel.org/r/20230327211548.462509-1-jiaqiyan@google.com
Link: https://lkml.kernel.org/r/20230327211548.462509-2-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tong Tiangen <tongtiangen@huawei.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    3 
 mm/khugepaged.c                    |  114 +++++++++++++++++++++++----
 2 files changed, 103 insertions(+), 14 deletions(-)

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
@@ -55,6 +55,7 @@ enum scan_result {
 	SCAN_CGROUP_CHARGE_FAIL,
 	SCAN_TRUNCATED,
 	SCAN_PAGE_HAS_PRIVATE,
+	SCAN_COPY_MC,
 };
 
 #define CREATE_TRACE_POINTS
@@ -681,20 +682,22 @@ out:
 	return result;
 }
 
-static void __collapse_huge_page_copy(pte_t *pte, struct page *page,
-				      struct vm_area_struct *vma,
-				      unsigned long address,
-				      spinlock_t *ptl,
-				      struct list_head *compound_pagelist)
+static void __collapse_huge_page_copy_succeeded(pte_t *pte,
+						pmd_t *pmd,
+						struct vm_area_struct *vma,
+						unsigned long address,
+						spinlock_t *ptl,
+						struct list_head *compound_pagelist)
 {
-	struct page *src_page, *tmp;
+	struct page *src_page;
+	struct page *tmp;
 	pte_t *_pte;
-	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
-				_pte++, page++, address += PAGE_SIZE) {
-		pte_t pteval = *_pte;
+	pte_t pteval;
 
+	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
+	     _pte++, address += PAGE_SIZE) {
+		pteval = *_pte;
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
-			clear_user_highpage(page, address);
 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
 			if (is_zero_pfn(pte_pfn(pteval))) {
 				/*
@@ -706,7 +709,6 @@ static void __collapse_huge_page_copy(pt
 			}
 		} else {
 			src_page = pte_page(pteval);
-			copy_user_highpage(page, src_page, address, vma);
 			if (!PageCompound(src_page))
 				release_pte_page(src_page);
 			/*
@@ -733,6 +735,88 @@ static void __collapse_huge_page_copy(pt
 	}
 }
 
+static void __collapse_huge_page_copy_failed(pte_t *pte,
+					     pmd_t *pmd,
+					     pmd_t orig_pmd,
+					     struct vm_area_struct *vma,
+					     unsigned long address,
+					     struct list_head *compound_pagelist)
+{
+	spinlock_t *pmd_ptl;
+
+	/*
+	 * Re-establish the PMD to point to the original page table
+	 * entry. Restoring PMD needs to be done prior to releasing
+	 * pages. Since pages are still isolated and locked here,
+	 * acquiring anon_vma_lock_write is unnecessary.
+	 */
+	pmd_ptl = pmd_lock(vma->vm_mm, pmd);
+	pmd_populate(vma->vm_mm, pmd, pmd_pgtable(orig_pmd));
+	spin_unlock(pmd_ptl);
+	/*
+	 * Release both raw and compound pages isolated
+	 * in __collapse_huge_page_isolate.
+	 */
+	release_pte_pages(pte, pte + HPAGE_PMD_NR, compound_pagelist);
+}
+
+/*
+ * __collapse_huge_page_copy - attempts to copy memory contents from raw
+ * pages to a hugepage. Cleans up the raw pages if copying succeeds;
+ * otherwise restores the original page table and releases isolated raw pages.
+ * Returns SCAN_SUCCEED if copying succeeds, otherwise returns SCAN_COPY_MC.
+ *
+ * @pte: starting of the PTEs to copy from
+ * @page: the new hugepage to copy contents to
+ * @pmd: pointer to the new hugepage's PMD
+ * @orig_pmd: the original raw pages' PMD
+ * @vma: the original raw pages' virtual memory area
+ * @address: starting address to copy
+ * @pte_ptl: lock on raw pages' PTEs
+ * @compound_pagelist: list that stores compound pages
+ */
+static int __collapse_huge_page_copy(pte_t *pte,
+				     struct page *page,
+				     pmd_t *pmd,
+				     pmd_t orig_pmd,
+				     struct vm_area_struct *vma,
+				     unsigned long address,
+				     spinlock_t *pte_ptl,
+				     struct list_head *compound_pagelist)
+{
+	struct page *src_page;
+	pte_t *_pte;
+	pte_t pteval;
+	unsigned long _address;
+	int result = SCAN_SUCCEED;
+
+	/*
+	 * Copying pages' contents is subject to memory poison at any iteration.
+	 */
+	for (_pte = pte, _address = address; _pte < pte + HPAGE_PMD_NR;
+	     _pte++, page++, _address += PAGE_SIZE) {
+		pteval = *_pte;
+		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+			clear_user_highpage(page, _address);
+			continue;
+		}
+		src_page = pte_page(pteval);
+		if (copy_mc_user_highpage(page, src_page, _address, vma) > 0) {
+			result = SCAN_COPY_MC;
+			break;
+		}
+	}
+
+	if (likely(result == SCAN_SUCCEED))
+		__collapse_huge_page_copy_succeeded(pte, pmd, vma, address,
+						    pte_ptl, compound_pagelist);
+	else
+		__collapse_huge_page_copy_failed(pte, pmd, orig_pmd, vma,
+						 address, compound_pagelist);
+
+	return result;
+}
+
 static void khugepaged_alloc_sleep(void)
 {
 	DEFINE_WAIT(wait);
@@ -1106,9 +1190,13 @@ static int collapse_huge_page(struct mm_
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
mm-hwpoison-introduce-copy_mc_highpage.patch
mm-khugepaged-recover-from-poisoned-file-backed-memory.patch

