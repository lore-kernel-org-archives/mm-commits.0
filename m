Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B83C4167E
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1452097AbiDFB5U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380215AbiDEUkv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:40:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97756C4A9
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:20:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EC65619A5
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EAEC385A0;
        Tue,  5 Apr 2022 20:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189822;
        bh=HV6+PSu3Bw/VOAIjErNjf3pc9y/U60NUMC/PgEq+MvI=;
        h=Date:To:From:Subject:From;
        b=rsVZm9TSihNX8AuL6/4prYRVGTf8/zqRyOkgO5IlQOvyQJe5QeKJrgJvdWk9p0CVl
         b1od4cP2sFSXgQMu4eO3J/CjwWMkcNwNF2FCcIV8n0xh2TKQ2Q4yAZQf5BpwuMi43u
         o+yMtVRosG0lb2n9lRtH9DV515/HvcDTjwaTvlpo=
Date:   Tue, 05 Apr 2022 13:17:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-handle-uffdio_writeprotect.patch added to -mm tree
Message-Id: <20220405201702.68EAEC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: handle UFFDIO_WRITEPROTECT
has been added to the -mm tree.  Its filename is
     mm-hugetlb-handle-uffdio_writeprotect.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-handle-uffdio_writeprotect.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-handle-uffdio_writeprotect.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: handle UFFDIO_WRITEPROTECT

This starts from passing cp_flags into hugetlb_change_protection() so
hugetlb will be able to handle MM_CP_UFFD_WP[_RESOLVE] requests.

huge_pte_clear_uffd_wp() is introduced to handle the case where the
UFFDIO_WRITEPROTECT is requested upon migrating huge page entries.

Link: https://lkml.kernel.org/r/20220405014906.14708-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 ++++--
 mm/hugetlb.c            |   13 ++++++++++++-
 mm/mprotect.c           |    3 ++-
 mm/userfaultfd.c        |    8 ++++++++
 4 files changed, 26 insertions(+), 4 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-handle-uffdio_writeprotect
+++ a/include/linux/hugetlb.h
@@ -211,7 +211,8 @@ struct page *follow_huge_pgd(struct mm_s
 int pmd_huge(pmd_t pmd);
 int pud_huge(pud_t pud);
 unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
-		unsigned long address, unsigned long end, pgprot_t newprot);
+		unsigned long address, unsigned long end, pgprot_t newprot,
+		unsigned long cp_flags);
 
 bool is_hugetlb_entry_migration(pte_t pte);
 void hugetlb_unshare_all_pmds(struct vm_area_struct *vma);
@@ -397,7 +398,8 @@ static inline void move_hugetlb_state(st
 
 static inline unsigned long hugetlb_change_protection(
 			struct vm_area_struct *vma, unsigned long address,
-			unsigned long end, pgprot_t newprot)
+			unsigned long end, pgprot_t newprot,
+			unsigned long cp_flags)
 {
 	return 0;
 }
--- a/mm/hugetlb.c~mm-hugetlb-handle-uffdio_writeprotect
+++ a/mm/hugetlb.c
@@ -6207,7 +6207,8 @@ long follow_hugetlb_page(struct mm_struc
 }
 
 unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
-		unsigned long address, unsigned long end, pgprot_t newprot)
+		unsigned long address, unsigned long end,
+		pgprot_t newprot, unsigned long cp_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long start = address;
@@ -6217,6 +6218,8 @@ unsigned long hugetlb_change_protection(
 	unsigned long pages = 0;
 	bool shared_pmd = false;
 	struct mmu_notifier_range range;
+	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
+	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 
 	/*
 	 * In the case of shared PMDs, the area to flush could be beyond
@@ -6263,6 +6266,10 @@ unsigned long hugetlb_change_protection(
 					entry = make_readable_migration_entry(
 								swp_offset(entry));
 				newpte = swp_entry_to_pte(entry);
+				if (uffd_wp)
+					newpte = pte_swp_mkuffd_wp(newpte);
+				else if (uffd_wp_resolve)
+					newpte = pte_swp_clear_uffd_wp(newpte);
 				set_huge_swap_pte_at(mm, address, ptep,
 						     newpte, huge_page_size(h));
 				pages++;
@@ -6277,6 +6284,10 @@ unsigned long hugetlb_change_protection(
 			old_pte = huge_ptep_modify_prot_start(vma, address, ptep);
 			pte = huge_pte_modify(old_pte, newprot);
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
+			if (uffd_wp)
+				pte = huge_pte_mkuffd_wp(huge_pte_wrprotect(pte));
+			else if (uffd_wp_resolve)
+				pte = huge_pte_clear_uffd_wp(pte);
 			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
 			pages++;
 		}
--- a/mm/mprotect.c~mm-hugetlb-handle-uffdio_writeprotect
+++ a/mm/mprotect.c
@@ -460,7 +460,8 @@ unsigned long change_protection(struct m
 	BUG_ON((cp_flags & MM_CP_UFFD_WP_ALL) == MM_CP_UFFD_WP_ALL);
 
 	if (is_vm_hugetlb_page(vma))
-		pages = hugetlb_change_protection(vma, start, end, newprot);
+		pages = hugetlb_change_protection(vma, start, end, newprot,
+						  cp_flags);
 	else
 		pages = change_protection_range(tlb, vma, start, end, newprot,
 						cp_flags);
--- a/mm/userfaultfd.c~mm-hugetlb-handle-uffdio_writeprotect
+++ a/mm/userfaultfd.c
@@ -705,6 +705,7 @@ int mwriteprotect_range(struct mm_struct
 			atomic_t *mmap_changing)
 {
 	struct vm_area_struct *dst_vma;
+	unsigned long page_mask;
 	struct mmu_gather tlb;
 	pgprot_t newprot;
 	int err;
@@ -742,6 +743,13 @@ int mwriteprotect_range(struct mm_struct
 	if (!vma_is_anonymous(dst_vma))
 		goto out_unlock;
 
+	if (is_vm_hugetlb_page(dst_vma)) {
+		err = -EINVAL;
+		page_mask = vma_kernel_pagesize(dst_vma) - 1;
+		if ((start & page_mask) || (len & page_mask))
+			goto out_unlock;
+	}
+
 	if (enable_wp)
 		newprot = vm_get_page_prot(dst_vma->vm_flags & ~(VM_WRITE));
 	else
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-introduce-pte_marker-swap-entry.patch
mm-teach-core-mm-about-pte-markers.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-uffd-pte_marker_uffd_wp.patch
mm-shmem-take-care-of-uffdio_copy_mode_wp.patch
mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler.patch
mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed.patch
mm-shmem-allow-uffd-wr-protect-none-pte-for-file-backed-mem.patch
mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch
mm-shmem-handle-uffd-wp-during-fork.patch
mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch
mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch
mm-hugetlb-take-care-of-uffdio_copy_mode_wp.patch
mm-hugetlb-handle-uffdio_writeprotect.patch
mm-hugetlb-handle-pte-markers-in-page-faults.patch
mm-hugetlb-allow-uffd-wr-protect-none-ptes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch
mm-hugetlb-handle-uffd-wp-during-fork.patch
mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
mm-enable-pte-markers-by-default.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch

