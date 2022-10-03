Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B44EAC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiJCVOf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiJCVNA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D977340BE5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:08:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA517B8160E
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90353C433B5;
        Mon,  3 Oct 2022 21:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831279;
        bh=YIAwPnKQ2ovJfYk5P7L8LplJqIISAz9/N8rdkUpeNwQ=;
        h=Date:To:From:Subject:From;
        b=jWQPOuzdeuebvWbNyNJD3MVeqry4F5z0FjfqPy/6kfdsblR5QbZuZJJM7fVKAjAQE
         O7ng0QDJzYPDMyUIYZDvuThaIF6lOS+o/A5sA1ME+joYfBlYyVoRRPWcjIHjsjiTwr
         hOSp45B5fj8C3qtl7jSpMqbfWDdI8tBuHpUhVxbQ=
Date:   Mon, 03 Oct 2022 14:07:58 -0700
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com,
        songmuchun@bytedance.com, prakash.sangappa@oracle.com,
        peterx@redhat.com, pasha.tatashin@soleen.com,
        naoya.horiguchi@linux.dev, mhocko@suse.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jthoughton@google.com,
        david@redhat.com, dave@stgolabs.net, axelrasmussen@google.com,
        aneesh.kumar@linux.vnet.ibm.com, almasrymina@google.com,
        aarcange@redhat.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch removed from -mm tree
Message-Id: <20221003210759.90353C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: create hugetlb_unmap_file_folio to unmap single file folio
has been removed from the -mm tree.  Its filename was
     hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: create hugetlb_unmap_file_folio to unmap single file folio
Date: Wed, 14 Sep 2022 15:18:08 -0700

Create the new routine hugetlb_unmap_file_folio that will unmap a single
file folio.  This is refactored code from hugetlb_vmdelete_list.  It is
modified to do locking within the routine itself and check whether the
page is mapped within a specific vma before unmapping.

This refactoring will be put to use and expanded upon in a subsequent
patch adding vma specific locking.

Link: https://lkml.kernel.org/r/20220914221810.95771-8-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
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
+	end = (index + 1) * pages_per_huge_page(h);
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
-			index * pages_per_huge_page(h),
-			(index + 1) * pages_per_huge_page(h),
-			ZAP_FLAG_DROP_MARKER);
-		i_mmap_unlock_write(mapping);
-	}
+	if (unlikely(folio_mapped(folio)))
+		hugetlb_unmap_file_folio(h, mapping, folio, index);
 
 	folio_lock(folio);
 	/*
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

