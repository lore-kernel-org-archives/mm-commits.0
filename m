Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD82C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380334AbiEMTVc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383788AbiEMTVF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB02266D
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81985B8313A
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DCEC34100;
        Fri, 13 May 2022 19:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469662;
        bh=nx/fPMYQ/y7UXm4/jj78rHzsd6UgKkAHDQgRXBDYJH4=;
        h=Date:To:From:Subject:From;
        b=DZk2DnkqIlwxpqFTec5XCWwPg40k3u+NxCojYNDxoy6snsyYBNj4JqXs62mRXzMvw
         scAsWAINMTxQ1wIb0e/+d5y03Dd7c7etMc674FhkVoolM1oem1QBtqm3l6Oj22f3TM
         5rvVAvmWnK7DplumWCSxKMU8BTe5yN4JZX/T/TbQ=
Date:   Fri, 13 May 2022 12:21:01 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-take-care-of-uffdio_copy_mode_wp.patch removed from -mm tree
Message-Id: <20220513192102.28DCEC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: take care of UFFDIO_COPY_MODE_WP
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-take-care-of-uffdio_copy_mode_wp.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: take care of UFFDIO_COPY_MODE_WP

Pass the wp_copy variable into hugetlb_mcopy_atomic_pte() thoughout the
stack.  Apply the UFFD_WP bit if UFFDIO_COPY_MODE_WP is with UFFDIO_COPY.

Hugetlb pages are only managed by hugetlbfs, so we're safe even without
setting dirty bit in the huge pte if the page is installed as read-only. 
However we'd better still keep the dirty bit set for a read-only
UFFDIO_COPY pte (when UFFDIO_COPY_MODE_WP bit is set), not only to match
what we do with shmem, but also because the page does contain dirty data
that the kernel just copied from the userspace.

Link: https://lkml.kernel.org/r/20220405014904.14643-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 ++++--
 mm/hugetlb.c            |   29 +++++++++++++++++++++++------
 mm/userfaultfd.c        |   14 +++++++++-----
 3 files changed, 36 insertions(+), 13 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-take-care-of-uffdio_copy_mode_wp
+++ a/include/linux/hugetlb.h
@@ -160,7 +160,8 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 				unsigned long dst_addr,
 				unsigned long src_addr,
 				enum mcopy_atomic_mode mode,
-				struct page **pagep);
+				struct page **pagep,
+				bool wp_copy);
 #endif /* CONFIG_USERFAULTFD */
 bool hugetlb_reserve_pages(struct inode *inode, long from, long to,
 						struct vm_area_struct *vma,
@@ -356,7 +357,8 @@ static inline int hugetlb_mcopy_atomic_p
 						unsigned long dst_addr,
 						unsigned long src_addr,
 						enum mcopy_atomic_mode mode,
-						struct page **pagep)
+						struct page **pagep,
+						bool wp_copy)
 {
 	BUG();
 	return 0;
--- a/mm/hugetlb.c~mm-hugetlb-take-care-of-uffdio_copy_mode_wp
+++ a/mm/hugetlb.c
@@ -5821,7 +5821,8 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			    unsigned long dst_addr,
 			    unsigned long src_addr,
 			    enum mcopy_atomic_mode mode,
-			    struct page **pagep)
+			    struct page **pagep,
+			    bool wp_copy)
 {
 	bool is_continue = (mode == MCOPY_ATOMIC_CONTINUE);
 	struct hstate *h = hstate_vma(dst_vma);
@@ -5951,7 +5952,12 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		goto out_release_unlock;
 
 	ret = -EEXIST;
-	if (!huge_pte_none(huge_ptep_get(dst_pte)))
+	/*
+	 * We allow to overwrite a pte marker: consider when both MISSING|WP
+	 * registered, we firstly wr-protect a none pte which has no page cache
+	 * page backing it, then access the page.
+	 */
+	if (!huge_pte_none_mostly(huge_ptep_get(dst_pte)))
 		goto out_release_unlock;
 
 	if (vm_shared) {
@@ -5961,17 +5967,28 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		hugepage_add_new_anon_rmap(page, dst_vma, dst_addr);
 	}
 
-	/* For CONTINUE on a non-shared VMA, don't set VM_WRITE for CoW. */
-	if (is_continue && !vm_shared)
+	/*
+	 * For either: (1) CONTINUE on a non-shared VMA, or (2) UFFDIO_COPY
+	 * with wp flag set, don't set pte write bit.
+	 */
+	if (wp_copy || (is_continue && !vm_shared))
 		writable = 0;
 	else
 		writable = dst_vma->vm_flags & VM_WRITE;
 
 	_dst_pte = make_huge_pte(dst_vma, page, writable);
-	if (writable)
-		_dst_pte = huge_pte_mkdirty(_dst_pte);
+	/*
+	 * Always mark UFFDIO_COPY page dirty; note that this may not be
+	 * extremely important for hugetlbfs for now since swapping is not
+	 * supported, but we should still be clear in that this page cannot be
+	 * thrown away at will, even if write bit not set.
+	 */
+	_dst_pte = huge_pte_mkdirty(_dst_pte);
 	_dst_pte = pte_mkyoung(_dst_pte);
 
+	if (wp_copy)
+		_dst_pte = huge_pte_mkuffd_wp(_dst_pte);
+
 	set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
 
 	(void)huge_ptep_set_access_flags(dst_vma, dst_addr, dst_pte, _dst_pte,
--- a/mm/userfaultfd.c~mm-hugetlb-take-care-of-uffdio_copy_mode_wp
+++ a/mm/userfaultfd.c
@@ -305,7 +305,8 @@ static __always_inline ssize_t __mcopy_a
 					      unsigned long dst_start,
 					      unsigned long src_start,
 					      unsigned long len,
-					      enum mcopy_atomic_mode mode)
+					      enum mcopy_atomic_mode mode,
+					      bool wp_copy)
 {
 	int vm_shared = dst_vma->vm_flags & VM_SHARED;
 	ssize_t err;
@@ -393,7 +394,7 @@ retry:
 		}
 
 		if (mode != MCOPY_ATOMIC_CONTINUE &&
-		    !huge_pte_none(huge_ptep_get(dst_pte))) {
+		    !huge_pte_none_mostly(huge_ptep_get(dst_pte))) {
 			err = -EEXIST;
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			i_mmap_unlock_read(mapping);
@@ -401,7 +402,8 @@ retry:
 		}
 
 		err = hugetlb_mcopy_atomic_pte(dst_mm, dst_pte, dst_vma,
-					       dst_addr, src_addr, mode, &page);
+					       dst_addr, src_addr, mode, &page,
+					       wp_copy);
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		i_mmap_unlock_read(mapping);
@@ -456,7 +458,8 @@ extern ssize_t __mcopy_atomic_hugetlb(st
 				      unsigned long dst_start,
 				      unsigned long src_start,
 				      unsigned long len,
-				      enum mcopy_atomic_mode mode);
+				      enum mcopy_atomic_mode mode,
+				      bool wp_copy);
 #endif /* CONFIG_HUGETLB_PAGE */
 
 static __always_inline ssize_t mfill_atomic_pte(struct mm_struct *dst_mm,
@@ -576,7 +579,8 @@ retry:
 	 */
 	if (is_vm_hugetlb_page(dst_vma))
 		return  __mcopy_atomic_hugetlb(dst_mm, dst_vma, dst_start,
-						src_start, len, mcopy_mode);
+					       src_start, len, mcopy_mode,
+					       wp_copy);
 
 	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
 		goto out_unlock;
_

Patches currently in -mm which might be from peterx@redhat.com are


