Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59347C64990
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 20:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240189AbiHXUOM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 16:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240208AbiHXUOJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 16:14:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FA57C50E
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 13:14:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42008B8269F
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 20:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBD9C433C1;
        Wed, 24 Aug 2022 20:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661372045;
        bh=fqdGPmIt39OlScOkeRhGy+ipRydlNuup4z2XjCrGO/8=;
        h=Date:To:From:Subject:From;
        b=Nl8mIK99WBCwiyVIMlzUCDpm1omUpG4Mb6BKp/0Hf/Nl6q//S27Rxgbp8HoJ071Bb
         D9+1tzLR6c7qPVCV48P0NRVCfOc/kCSDV+ujTTQVOAUPtPqy8EPTVwMh16cUyZFgVi
         r+Chwm3Cz5AuqGVlZ80I6nWo9Nl+xbCZEpyyMXvs=
Date:   Wed, 24 Aug 2022 13:14:04 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        prakash.sangappa@oracle.com, peterx@redhat.com,
        pasha.tatashin@soleen.com, naoya.horiguchi@linux.dev,
        mhocko@suse.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jthoughton@google.com,
        david@redhat.com, dave@stgolabs.net, axelrasmussen@google.com,
        aneesh.kumar@linux.vnet.ibm.com, almasrymina@google.com,
        aarcange@redhat.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch added to mm-unstable branch
Message-Id: <20220824201404.EEBD9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: create hugetlb_unmap_file_folio to unmap single file folio
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch

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
Subject: hugetlb: create hugetlb_unmap_file_folio to unmap single file folio
Date: Wed, 24 Aug 2022 10:57:56 -0700

Create the new routine hugetlb_unmap_file_folio that will unmap a single
file folio.  This is refactored code from hugetlb_vmdelete_list.  It is
modified to do locking within the routine itself and check whether the
page is mapped within a specific vma before unmapping.

This refactoring will be put to use and expanded upon in a subsequent
patch adding vma specific locking.

Link: https://lkml.kernel.org/r/20220824175757.20590-8-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |  123 +++++++++++++++++++++++++++++++----------
 1 file changed, 94 insertions(+), 29 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio
+++ a/fs/hugetlbfs/inode.c
@@ -371,6 +371,94 @@ static void hugetlb_delete_from_page_cac
 	delete_from_page_cache(page);
 }
 
+/*
+ * Called with i_mmap_rwsem held for inode based vma maps.  This makes
+ * sure vma (and vm_mm) will not go away.  We also hold the hugetlb fault
+ * mutex for the page in the mapping.  So, we can not race with page being
+ * faulted into the vma.
+ */
+static bool hugetlb_vma_maps_page(struct vm_area_struct *vma,
+				unsigned long addr, struct page *page)
+{
+	pte_t *ptep, pte;
+
+	ptep = huge_pte_offset(vma->vm_mm, addr,
+			huge_page_size(hstate_vma(vma)));
+
+	if (!ptep)
+		return false;
+
+	pte = huge_ptep_get(ptep);
+	if (huge_pte_none(pte) || !pte_present(pte))
+		return false;
+
+	if (pte_page(pte) == page)
+		return true;
+
+	return false;
+}
+
+/*
+ * Can vma_offset_start/vma_offset_end overflow on 32-bit arches?
+ * No, because the interval tree returns us only those vmas
+ * which overlap the truncated area starting at pgoff,
+ * and no vma on a 32-bit arch can span beyond the 4GB.
+ */
+static unsigned long vma_offset_start(struct vm_area_struct *vma, pgoff_t start)
+{
+	if (vma->vm_pgoff < start)
+		return (start - vma->vm_pgoff) << PAGE_SHIFT;
+	else
+		return 0;
+}
+
+static unsigned long vma_offset_end(struct vm_area_struct *vma, pgoff_t end)
+{
+	unsigned long t_end;
+
+	if (!end)
+		return vma->vm_end;
+
+	t_end = ((end - vma->vm_pgoff) << PAGE_SHIFT) + vma->vm_start;
+	if (t_end > vma->vm_end)
+		t_end = vma->vm_end;
+	return t_end;
+}
+
+/*
+ * Called with hugetlb fault mutex held.  Therefore, no more mappings to
+ * this folio can be created while executing the routine.
+ */
+static void hugetlb_unmap_file_folio(struct hstate *h,
+					struct address_space *mapping,
+					struct folio *folio, pgoff_t index)
+{
+	struct rb_root_cached *root = &mapping->i_mmap;
+	struct page *page = &folio->page;
+	struct vm_area_struct *vma;
+	unsigned long v_start;
+	unsigned long v_end;
+	pgoff_t start, end;
+
+	start = index * pages_per_huge_page(h);
+	end = ((index + 1) * pages_per_huge_page(h));
+
+	i_mmap_lock_write(mapping);
+
+	vma_interval_tree_foreach(vma, root, start, end - 1) {
+		v_start = vma_offset_start(vma, start);
+		v_end = vma_offset_end(vma, end);
+
+		if (!hugetlb_vma_maps_page(vma, vma->vm_start + v_start, page))
+			continue;
+
+		unmap_hugepage_range(vma, vma->vm_start + v_start, v_end,
+				NULL, ZAP_FLAG_DROP_MARKER);
+	}
+
+	i_mmap_unlock_write(mapping);
+}
+
 static void
 hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
 		      zap_flags_t zap_flags)
@@ -383,30 +471,13 @@ hugetlb_vmdelete_list(struct rb_root_cac
 	 * an inclusive "last".
 	 */
 	vma_interval_tree_foreach(vma, root, start, end ? end - 1 : ULONG_MAX) {
-		unsigned long v_offset;
+		unsigned long v_start;
 		unsigned long v_end;
 
-		/*
-		 * Can the expression below overflow on 32-bit arches?
-		 * No, because the interval tree returns us only those vmas
-		 * which overlap the truncated area starting at pgoff,
-		 * and no vma on a 32-bit arch can span beyond the 4GB.
-		 */
-		if (vma->vm_pgoff < start)
-			v_offset = (start - vma->vm_pgoff) << PAGE_SHIFT;
-		else
-			v_offset = 0;
-
-		if (!end)
-			v_end = vma->vm_end;
-		else {
-			v_end = ((end - vma->vm_pgoff) << PAGE_SHIFT)
-							+ vma->vm_start;
-			if (v_end > vma->vm_end)
-				v_end = vma->vm_end;
-		}
+		v_start = vma_offset_start(vma, start);
+		v_end = vma_offset_end(vma, end);
 
-		unmap_hugepage_range(vma, vma->vm_start + v_offset, v_end,
+		unmap_hugepage_range(vma, vma->vm_start + v_start, v_end,
 				     NULL, zap_flags);
 	}
 }
@@ -428,14 +499,8 @@ static bool remove_inode_single_folio(st
 	 * the fault mutex.  The mutex will prevent faults
 	 * until we finish removing the folio.
 	 */
-	if (unlikely(folio_mapped(folio))) {
-		i_mmap_lock_write(mapping);
-		hugetlb_vmdelete_list(&mapping->i_mmap,
-					index * pages_per_huge_page(h),
-					(index + 1) * pages_per_huge_page(h),
-					ZAP_FLAG_DROP_MARKER);
-		i_mmap_unlock_write(mapping);
-	}
+	if (unlikely(folio_mapped(folio)))
+		hugetlb_unmap_file_folio(h, mapping, folio, index);
 
 	folio_lock(folio);
 	/*
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-revert-use-i_mmap_rwsem-to-address-page-fault-truncate-race.patch
hugetlbfs-revert-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization.patch
hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache.patch
hugetlb-handle-truncate-racing-with-page-faults.patch
hugetlb-rename-vma_shareable-and-refactor-code.patch
hugetlb-add-vma-based-lock-for-pmd-sharing.patch
hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch
hugetlb-use-new-vma_lock-for-pmd-sharing-synchronization.patch

