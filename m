Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD0EC43334
	for <mm-commits@archiver.kernel.org>; Wed, 22 Jun 2022 01:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbiFVBCA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 21:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355607AbiFVBB7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 21:01:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF1E32052
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 18:01:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 003CACE1C42
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 01:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1401EC3411C;
        Wed, 22 Jun 2022 01:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655859714;
        bh=Df2khSnoIbZfQdGIRq6QHtWhyNrTYHboWUWwQILkizk=;
        h=Date:To:From:Subject:From;
        b=ZwVRlxEeFn2PcQhD9gJ6q8GSvU+bwxhIkq83xgzWvKZXgsGZ3xrm/EeRuwUBpum2j
         5C0wJJRZPmtBUjGDNofBylpo4t8emJU1tWw71M0QhXzQqN1STDrxmcSK5MZ8H6l7xe
         0PPOaEch6DwZmeyE6hVAgHuueVWQOxXuNXzCVzmk=
Date:   Tue, 21 Jun 2022 18:01:44 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        songmuchun@bytedance.com, peterx@redhat.com,
        paul.walmsley@sifive.com, naoya.horiguchi@linux.dev,
        mhocko@suse.com, lkp@intel.com, jthoughton@google.com,
        eike-kernel@sf-tec.de, david@redhat.com, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, baolin.wang@linux.alibaba.com,
        anshuman.khandual@arm.com, aneesh.kumar@linux.vnet.ibm.com,
        almasrymina@google.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-skip-to-end-of-pt-page-mapping-when-pte-not-present.patch added to mm-unstable branch
Message-Id: <20220622010152.1401EC3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: skip to end of PT page mapping when pte not present
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-skip-to-end-of-pt-page-mapping-when-pte-not-present.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-skip-to-end-of-pt-page-mapping-when-pte-not-present.patch

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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: skip to end of PT page mapping when pte not present
Date: Tue, 21 Jun 2022 16:56:17 -0700

Patch series "hugetlb: speed up linear address scanning", v2.

At unmap, fork and remap time hugetlb address ranges are linearly scanned.
We can optimize these scans if the ranges are sparsely populated.

Also, enable page table "Lazy copy" for hugetlb at fork.

NOTE: Architectures not defining CONFIG_ARCH_WANT_GENERAL_HUGETLB need to
add an arch specific version hugetlb_mask_last_page() to take advantage of
sparse address scanning improvements.  Baolin Wang added the routine for
arm64.  Other architectures which could be optimized are: ia64, mips,
parisc, powerpc, s390, sh and sparc.


This patch (of 4):

HugeTLB address ranges are linearly scanned during fork, unmap and remap
operations.  If a non-present entry is encountered, the code currently
continues to the next huge page aligned address.  However, a non-present
entry implies that the page table page for that entry is not present. 
Therefore, the linear scan can skip to the end of range mapped by the page
table page.  This can speed operations on large sparsely populated hugetlb
mappings.

Create a new routine hugetlb_mask_last_page() that will return an address
mask.  When the mask is ORed with an address, the result will be the
address of the last huge page mapped by the associated page table page. 
Use this mask to update addresses in routines which linearly scan hugetlb
address ranges when a non-present pte is encountered.

hugetlb_mask_last_page is related to the implementation of huge_pte_offset
as hugetlb_mask_last_page is called when huge_pte_offset returns NULL. 
This patch only provides a complete hugetlb_mask_last_page implementation
when CONFIG_ARCH_WANT_GENERAL_HUGETLB is defined.  Architectures which
provide their own versions of huge_pte_offset can also provide their own
version of hugetlb_mask_last_page.

Link: https://lkml.kernel.org/r/20220621235620.291305-1-mike.kravetz@oracle.com
Link: https://lkml.kernel.org/r/20220621235620.291305-2-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: James Houghton <jthoughton@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 
 mm/hugetlb.c            |   56 ++++++++++++++++++++++++++++++++++----
 2 files changed, 52 insertions(+), 5 deletions(-)

--- a/include/linux/hugetlb.h~hugetlb-skip-to-end-of-pt-page-mapping-when-pte-not-present
+++ a/include/linux/hugetlb.h
@@ -197,6 +197,7 @@ pte_t *huge_pte_alloc(struct mm_struct *
 			unsigned long addr, unsigned long sz);
 pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz);
+unsigned long hugetlb_mask_last_page(struct hstate *h);
 int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
 				unsigned long *addr, pte_t *ptep);
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
--- a/mm/hugetlb.c~hugetlb-skip-to-end-of-pt-page-mapping-when-pte-not-present
+++ a/mm/hugetlb.c
@@ -4736,6 +4736,7 @@ int copy_hugetlb_page_range(struct mm_st
 	unsigned long npages = pages_per_huge_page(h);
 	struct address_space *mapping = src_vma->vm_file->f_mapping;
 	struct mmu_notifier_range range;
+	unsigned long last_addr_mask;
 	int ret = 0;
 
 	if (cow) {
@@ -4755,11 +4756,14 @@ int copy_hugetlb_page_range(struct mm_st
 		i_mmap_lock_read(mapping);
 	}
 
+	last_addr_mask = hugetlb_mask_last_page(h);
 	for (addr = src_vma->vm_start; addr < src_vma->vm_end; addr += sz) {
 		spinlock_t *src_ptl, *dst_ptl;
 		src_pte = huge_pte_offset(src, addr, sz);
-		if (!src_pte)
+		if (!src_pte) {
+			addr |= last_addr_mask;
 			continue;
+		}
 		dst_pte = huge_pte_alloc(dst, dst_vma, addr, sz);
 		if (!dst_pte) {
 			ret = -ENOMEM;
@@ -4776,8 +4780,10 @@ int copy_hugetlb_page_range(struct mm_st
 		 * after taking the lock below.
 		 */
 		dst_entry = huge_ptep_get(dst_pte);
-		if ((dst_pte == src_pte) || !huge_pte_none(dst_entry))
+		if ((dst_pte == src_pte) || !huge_pte_none(dst_entry)) {
+			addr |= last_addr_mask;
 			continue;
+		}
 
 		dst_ptl = huge_pte_lock(h, dst, dst_pte);
 		src_ptl = huge_pte_lockptr(h, src, src_pte);
@@ -4938,6 +4944,7 @@ int move_hugetlb_page_tables(struct vm_a
 	unsigned long sz = huge_page_size(h);
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long old_end = old_addr + len;
+	unsigned long last_addr_mask;
 	unsigned long old_addr_copy;
 	pte_t *src_pte, *dst_pte;
 	struct mmu_notifier_range range;
@@ -4953,12 +4960,16 @@ int move_hugetlb_page_tables(struct vm_a
 	flush_cache_range(vma, range.start, range.end);
 
 	mmu_notifier_invalidate_range_start(&range);
+	last_addr_mask = hugetlb_mask_last_page(h);
 	/* Prevent race with file truncation */
 	i_mmap_lock_write(mapping);
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
 		src_pte = huge_pte_offset(mm, old_addr, sz);
-		if (!src_pte)
+		if (!src_pte) {
+			old_addr |= last_addr_mask;
+			new_addr |= last_addr_mask;
 			continue;
+		}
 		if (huge_pte_none(huge_ptep_get(src_pte)))
 			continue;
 
@@ -5003,6 +5014,7 @@ static void __unmap_hugepage_range(struc
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
 	struct mmu_notifier_range range;
+	unsigned long last_addr_mask;
 	bool force_flush = false;
 
 	WARN_ON(!is_vm_hugetlb_page(vma));
@@ -5023,11 +5035,14 @@ static void __unmap_hugepage_range(struc
 				end);
 	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
 	mmu_notifier_invalidate_range_start(&range);
+	last_addr_mask = hugetlb_mask_last_page(h);
 	address = start;
 	for (; address < end; address += sz) {
 		ptep = huge_pte_offset(mm, address, sz);
-		if (!ptep)
+		if (!ptep) {
+			address |= last_addr_mask;
 			continue;
+		}
 
 		ptl = huge_pte_lock(h, mm, ptep);
 		if (huge_pmd_unshare(mm, vma, &address, ptep)) {
@@ -6295,6 +6310,7 @@ unsigned long hugetlb_change_protection(
 	unsigned long pages = 0, psize = huge_page_size(h);
 	bool shared_pmd = false;
 	struct mmu_notifier_range range;
+	unsigned long last_addr_mask;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 
@@ -6311,12 +6327,15 @@ unsigned long hugetlb_change_protection(
 	flush_cache_range(vma, range.start, range.end);
 
 	mmu_notifier_invalidate_range_start(&range);
+	last_addr_mask = hugetlb_mask_last_page(h);
 	i_mmap_lock_write(vma->vm_file->f_mapping);
 	for (; address < end; address += psize) {
 		spinlock_t *ptl;
 		ptep = huge_pte_offset(mm, address, psize);
-		if (!ptep)
+		if (!ptep) {
+			address |= last_addr_mask;
 			continue;
+		}
 		ptl = huge_pte_lock(h, mm, ptep);
 		if (huge_pmd_unshare(mm, vma, &address, ptep)) {
 			/*
@@ -6867,6 +6886,33 @@ pte_t *huge_pte_offset(struct mm_struct
 	return (pte_t *)pmd;
 }
 
+/*
+ * Return a mask that can be used to update an address to the last huge
+ * page in a page table page mapping size.  Used to skip non-present
+ * page table entries when linearly scanning address ranges.  Architectures
+ * with unique huge page to page table relationships can define their own
+ * version of this routine.
+ */
+unsigned long hugetlb_mask_last_page(struct hstate *h)
+{
+	unsigned long hp_size = huge_page_size(h);
+
+	if (hp_size == PUD_SIZE)
+		return P4D_SIZE - PUD_SIZE;
+	else if (hp_size == PMD_SIZE)
+		return PUD_SIZE - PMD_SIZE;
+	else
+		return 0UL;
+}
+
+#else
+
+/* See description above.  Architectures can provide their own version. */
+__weak unsigned long hugetlb_mask_last_page(struct hstate *h)
+{
+	return 0UL;
+}
+
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 
 /*
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-skip-to-end-of-pt-page-mapping-when-pte-not-present.patch
hugetlb-do-not-update-address-in-huge_pmd_unshare.patch
hugetlb-lazy-page-table-copies-in-fork.patch

