Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47332C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 00:11:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ED2961108
	for <mm-commits@archiver.kernel.org>; Fri,  2 Apr 2021 00:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbhDBALv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Apr 2021 20:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233677AbhDBALv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 1 Apr 2021 20:11:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 142EE610D1;
        Fri,  2 Apr 2021 00:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617322310;
        bh=FyIqv3jGnxOm9Kpwo2cwYj+hLF8SO1OLU2br3j66gT0=;
        h=Date:From:To:Subject:From;
        b=VxhaCoHvg6jvjXEHKASwmR3T7eJWMY0tyO5xeDR0p16j09qaCfoubnlUQD0ZzBFiE
         ma+figi4xj2emFCFWxVURyLkJdHTTtC+XqKnUaKC+VgT5X8vlkJ+FDpQzguysEZtXv
         9lnyyHBoeoMHfypi/+d+6hMQ0hnTNd3vailSZ7MM=
Date:   Thu, 01 Apr 2021 17:11:49 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, bgeffon@google.com,
        cannonmatthews@google.com, dgilbert@redhat.com, hughd@google.com,
        jglisse@redhat.com, joe@perches.com, lokeshgidra@google.com,
        mm-commits@vger.kernel.org, oupton@google.com, peterx@redhat.com,
        rientjes@google.com, rppt@linux.vnet.ibm.com, shli@fb.com,
        shuah@kernel.org, viro@zeniv.linux.org.uk, walken@google.com,
        wangqing@vivo.com
Subject:  +
 userfaultfd-support-minor-fault-handling-for-shmem-fix-3.patch added to -mm
 tree
Message-ID: <20210402001149.WpDhsxE8R%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd/shmem: fix MCOPY_ATOMIC_CONTINUE behavior
has been added to the -mm tree.  Its filename is
     userfaultfd-support-minor-fault-handling-for-shmem-fix-3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-support-minor-fault-handling-for-shmem-fix-3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-support-minor-fault-handling-for-shmem-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd/shmem: fix MCOPY_ATOMIC_CONTINUE behavior

Previously, the continue implementation in shmem_mcopy_atomic_pte was
incorrect for two main reasons:

- It didn't correctly skip some sections of code which make sense for
  newly allocated pages, but absolutely don't make sense for
  pre-existing page cache pages.

- Because shmem_mcopy_continue_pte is called only if VM_SHARED is
  detected in mm/userfaultd.c, we were incorrectly not supporting the
  case where a tmpfs file had been mmap()-ed with MAP_PRIVATE.

So, this patch does the following:

In mm/userfaultfd.c, break the logic to install PTEs out of
mcopy_atomic_pte, into a separate helper function.

In mfill_atomic_pte, for the MCOPY_ATOMIC_CONTINUE case, simply look
up the existing page in the page cache, and then use the PTE
installation helper to setup the mapping. This addresses the two issues
noted above.

The previous code's bugs manifested clearly in the error handling path.
So, to detect this kind of issue in the future, modify the selftest to
exercise the error handling path as well.

Link: https://lkml.kernel.org/r/20210401183701.1774159-1-axelrasmussen@google.com
Fixes: 00da60b9d0a0 ("userfaultfd: support minor fault handling for shmem")
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wang Qing <wangqing@vivo.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Cannon Matthews <cannonmatthews@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c       |   56 +++++--------
 mm/userfaultfd.c |  183 ++++++++++++++++++++++++++++++++-------------
 2 files changed, 156 insertions(+), 83 deletions(-)

--- a/mm/shmem.c~userfaultfd-support-minor-fault-handling-for-shmem-fix-3
+++ a/mm/shmem.c
@@ -2366,7 +2366,6 @@ int shmem_mcopy_atomic_pte(struct mm_str
 			   unsigned long dst_addr, unsigned long src_addr,
 			   enum mcopy_atomic_mode mode, struct page **pagep)
 {
-	bool is_continue = (mode == MCOPY_ATOMIC_CONTINUE);
 	struct inode *inode = file_inode(dst_vma->vm_file);
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct address_space *mapping = inode->i_mapping;
@@ -2377,18 +2376,17 @@ int shmem_mcopy_atomic_pte(struct mm_str
 	struct page *page;
 	pte_t _dst_pte, *dst_pte;
 	int ret;
-	pgoff_t offset, max_off;
+	pgoff_t max_off;
+
+	/* Handled by mcontinue_atomic_pte instead. */
+	if (WARN_ON_ONCE(mode == MCOPY_ATOMIC_CONTINUE))
+		return -EINVAL;
 
 	ret = -ENOMEM;
 	if (!shmem_inode_acct_block(inode, 1))
 		goto out;
 
-	if (is_continue) {
-		ret = -EFAULT;
-		page = find_lock_page(mapping, pgoff);
-		if (!page)
-			goto out_unacct_blocks;
-	} else if (!*pagep) {
+	if (!*pagep) {
 		page = shmem_alloc_page(gfp, info, pgoff);
 		if (!page)
 			goto out_unacct_blocks;
@@ -2415,27 +2413,21 @@ int shmem_mcopy_atomic_pte(struct mm_str
 		*pagep = NULL;
 	}
 
-	if (!is_continue) {
-		VM_BUG_ON(PageSwapBacked(page));
-		VM_BUG_ON(PageLocked(page));
-		__SetPageLocked(page);
-		__SetPageSwapBacked(page);
-		__SetPageUptodate(page);
-	}
+	VM_BUG_ON(PageSwapBacked(page));
+	VM_BUG_ON(PageLocked(page));
+	__SetPageLocked(page);
+	__SetPageSwapBacked(page);
+	__SetPageUptodate(page);
 
 	ret = -EFAULT;
-	offset = linear_page_index(dst_vma, dst_addr);
 	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
-	if (unlikely(offset >= max_off))
+	if (unlikely(pgoff >= max_off))
 		goto out_release;
 
-	/* If page wasn't already in the page cache, add it. */
-	if (!is_continue) {
-		ret = shmem_add_to_page_cache(page, mapping, pgoff, NULL,
-					      gfp & GFP_RECLAIM_MASK, dst_mm);
-		if (ret)
-			goto out_release;
-	}
+	ret = shmem_add_to_page_cache(page, mapping, pgoff, NULL,
+				      gfp & GFP_RECLAIM_MASK, dst_mm);
+	if (ret)
+		goto out_release;
 
 	_dst_pte = mk_pte(page, dst_vma->vm_page_prot);
 	if (dst_vma->vm_flags & VM_WRITE)
@@ -2455,22 +2447,20 @@ int shmem_mcopy_atomic_pte(struct mm_str
 
 	ret = -EFAULT;
 	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
-	if (unlikely(offset >= max_off))
+	if (unlikely(pgoff >= max_off))
 		goto out_release_unlock;
 
 	ret = -EEXIST;
 	if (!pte_none(*dst_pte))
 		goto out_release_unlock;
 
-	if (!is_continue) {
-		lru_cache_add(page);
+	lru_cache_add(page);
 
-		spin_lock_irq(&info->lock);
-		info->alloced++;
-		inode->i_blocks += BLOCKS_PER_PAGE;
-		shmem_recalc_inode(inode);
-		spin_unlock_irq(&info->lock);
-	}
+	spin_lock_irq(&info->lock);
+	info->alloced++;
+	inode->i_blocks += BLOCKS_PER_PAGE;
+	shmem_recalc_inode(inode);
+	spin_unlock_irq(&info->lock);
 
 	inc_mm_counter(dst_mm, mm_counter_file(page));
 	page_add_file_rmap(page, false);
--- a/mm/userfaultfd.c~userfaultfd-support-minor-fault-handling-for-shmem-fix-3
+++ a/mm/userfaultfd.c
@@ -48,21 +48,103 @@ struct vm_area_struct *find_dst_vma(stru
 	return dst_vma;
 }
 
+/*
+ * Install PTEs, to map dst_addr (within dst_vma) to page.
+ *
+ * This function handles MCOPY_ATOMIC_CONTINUE (which is always file-backed),
+ * whether or not dst_vma is VM_SHARED. It also handles the more general
+ * MCOPY_ATOMIC_NORMAL case, when dst_vma is *not* VM_SHARED (it may be file
+ * backed, or not).
+ *
+ * Note that MCOPY_ATOMIC_NORMAL for a VM_SHARED dst_vma is handled by
+ * shmem_mcopy_atomic_pte instead.
+ */
+static int mcopy_atomic_install_ptes(struct mm_struct *dst_mm, pmd_t *dst_pmd,
+				     struct vm_area_struct *dst_vma,
+				     unsigned long dst_addr, struct page *page,
+				     enum mcopy_atomic_mode mode, bool wp_copy)
+{
+	int ret;
+	pte_t _dst_pte, *dst_pte;
+	bool is_continue = mode == MCOPY_ATOMIC_CONTINUE;
+	int writable;
+	bool vm_shared = dst_vma->vm_flags & VM_SHARED;
+	bool is_file_backed = dst_vma->vm_file;
+	spinlock_t *ptl;
+	struct inode *inode;
+	pgoff_t offset, max_off;
+
+	_dst_pte = mk_pte(page, dst_vma->vm_page_prot);
+	writable = dst_vma->vm_flags & VM_WRITE;
+	/* For CONTINUE on a non-shared VMA, don't pte_mkwrite for CoW. */
+	if (is_continue && !vm_shared)
+		writable = 0;
+
+	if (writable) {
+		_dst_pte = pte_mkdirty(_dst_pte);
+		if (wp_copy)
+			_dst_pte = pte_mkuffd_wp(_dst_pte);
+		else
+			_dst_pte = pte_mkwrite(_dst_pte);
+	} else if (vm_shared) {
+		/*
+		 * Since we didn't pte_mkdirty(), mark the page dirty or it
+		 * could be freed from under us. We could do this
+		 * unconditionally, but doing it only if !writable is faster.
+		 */
+		set_page_dirty(page);
+	}
+
+	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
+
+	if (is_file_backed) {
+		/* The shmem MAP_PRIVATE case requires checking the i_size */
+		inode = dst_vma->vm_file->f_inode;
+		offset = linear_page_index(dst_vma, dst_addr);
+		max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
+		ret = -EFAULT;
+		if (unlikely(offset >= max_off))
+			goto out_unlock;
+	}
+
+	ret = -EEXIST;
+	if (!pte_none(*dst_pte))
+		goto out_unlock;
+
+	inc_mm_counter(dst_mm, mm_counter(page));
+	if (is_file_backed)
+		page_add_file_rmap(page, false);
+	else
+		page_add_new_anon_rmap(page, dst_vma, dst_addr, false);
+
+	if (!is_continue)
+		lru_cache_add_inactive_or_unevictable(page, dst_vma);
+
+	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
+
+	/* No need to invalidate - it was non-present before */
+	update_mmu_cache(dst_vma, dst_addr, dst_pte);
+	pte_unmap_unlock(dst_pte, ptl);
+	ret = 0;
+out:
+	return ret;
+out_unlock:
+	pte_unmap_unlock(dst_pte, ptl);
+	goto out;
+}
+
 static int mcopy_atomic_pte(struct mm_struct *dst_mm,
 			    pmd_t *dst_pmd,
 			    struct vm_area_struct *dst_vma,
 			    unsigned long dst_addr,
 			    unsigned long src_addr,
 			    struct page **pagep,
+			    enum mcopy_atomic_mode mode,
 			    bool wp_copy)
 {
-	pte_t _dst_pte, *dst_pte;
-	spinlock_t *ptl;
 	void *page_kaddr;
 	int ret;
 	struct page *page;
-	pgoff_t offset, max_off;
-	struct inode *inode;
 
 	if (!*pagep) {
 		ret = -ENOMEM;
@@ -99,43 +181,12 @@ static int mcopy_atomic_pte(struct mm_st
 	if (mem_cgroup_charge(page, dst_mm, GFP_KERNEL))
 		goto out_release;
 
-	_dst_pte = pte_mkdirty(mk_pte(page, dst_vma->vm_page_prot));
-	if (dst_vma->vm_flags & VM_WRITE) {
-		if (wp_copy)
-			_dst_pte = pte_mkuffd_wp(_dst_pte);
-		else
-			_dst_pte = pte_mkwrite(_dst_pte);
-	}
-
-	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
-	if (dst_vma->vm_file) {
-		/* the shmem MAP_PRIVATE case requires checking the i_size */
-		inode = dst_vma->vm_file->f_inode;
-		offset = linear_page_index(dst_vma, dst_addr);
-		max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
-		ret = -EFAULT;
-		if (unlikely(offset >= max_off))
-			goto out_release_uncharge_unlock;
-	}
-	ret = -EEXIST;
-	if (!pte_none(*dst_pte))
-		goto out_release_uncharge_unlock;
-
-	inc_mm_counter(dst_mm, MM_ANONPAGES);
-	page_add_new_anon_rmap(page, dst_vma, dst_addr, false);
-	lru_cache_add_inactive_or_unevictable(page, dst_vma);
-
-	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
-
-	/* No need to invalidate - it was non-present before */
-	update_mmu_cache(dst_vma, dst_addr, dst_pte);
-
-	pte_unmap_unlock(dst_pte, ptl);
-	ret = 0;
+	ret = mcopy_atomic_install_ptes(dst_mm, dst_pmd, dst_vma, dst_addr,
+					page, mode, wp_copy);
+	if (ret)
+		goto out_release;
 out:
 	return ret;
-out_release_uncharge_unlock:
-	pte_unmap_unlock(dst_pte, ptl);
 out_release:
 	put_page(page);
 	goto out;
@@ -176,6 +227,38 @@ out_unlock:
 	return ret;
 }
 
+static int mcontinue_atomic_pte(struct mm_struct *dst_mm,
+				pmd_t *dst_pmd,
+				struct vm_area_struct *dst_vma,
+				unsigned long dst_addr,
+				bool wp_copy)
+{
+	struct inode *inode = file_inode(dst_vma->vm_file);
+	struct address_space *mapping = inode->i_mapping;
+	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
+	struct page *page;
+	int ret;
+
+	ret = -EFAULT;
+	page = find_lock_page(mapping, pgoff);
+	if (!page)
+		goto out;
+
+	ret = mcopy_atomic_install_ptes(dst_mm, dst_pmd, dst_vma, dst_addr,
+					page, MCOPY_ATOMIC_CONTINUE, wp_copy);
+	if (ret)
+		goto out_release;
+
+	unlock_page(page);
+	ret = 0;
+out:
+	return ret;
+out_release:
+	unlock_page(page);
+	put_page(page);
+	goto out;
+}
+
 static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
 {
 	pgd_t *pgd;
@@ -418,7 +501,13 @@ static __always_inline ssize_t mfill_ato
 						enum mcopy_atomic_mode mode,
 						bool wp_copy)
 {
-	ssize_t err;
+	ssize_t err = 0;
+
+	if (mode == MCOPY_ATOMIC_CONTINUE) {
+		err = mcontinue_atomic_pte(dst_mm, dst_pmd, dst_vma, dst_addr,
+					   wp_copy);
+		goto out;
+	}
 
 	/*
 	 * The normal page fault path for a shmem will invoke the
@@ -431,26 +520,20 @@ static __always_inline ssize_t mfill_ato
 	 * and not in the radix tree.
 	 */
 	if (!(dst_vma->vm_flags & VM_SHARED)) {
-		switch (mode) {
-		case MCOPY_ATOMIC_NORMAL:
+		if (mode == MCOPY_ATOMIC_NORMAL)
 			err = mcopy_atomic_pte(dst_mm, dst_pmd, dst_vma,
 					       dst_addr, src_addr, page,
-					       wp_copy);
-			break;
-		case MCOPY_ATOMIC_ZEROPAGE:
+					       mode, wp_copy);
+		else if (mode == MCOPY_ATOMIC_ZEROPAGE)
 			err = mfill_zeropage_pte(dst_mm, dst_pmd,
 						 dst_vma, dst_addr);
-			break;
-		case MCOPY_ATOMIC_CONTINUE:
-			err = -EINVAL;
-			break;
-		}
 	} else {
 		VM_WARN_ON_ONCE(wp_copy);
 		err = shmem_mcopy_atomic_pte(dst_mm, dst_pmd, dst_vma, dst_addr,
 					     src_addr, mode, page);
 	}
 
+out:
 	return err;
 }
 
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-add-minor-fault-registration-mode.patch
userfaultfd-disable-huge-pmd-sharing-for-minor-registered-vmas.patch
userfaultfd-hugetlbfs-only-compile-uffd-helpers-if-config-enabled.patch
userfaultfd-add-uffdio_continue-ioctl.patch
userfaultfd-update-documentation-to-describe-minor-fault-handling.patch
userfaultfd-selftests-add-test-exercising-minor-fault-handling.patch
userfaultfd-support-minor-fault-handling-for-shmem.patch
userfaultfd-support-minor-fault-handling-for-shmem-fix.patch
userfaultfd-support-minor-fault-handling-for-shmem-fix-2.patch
userfaultfd-support-minor-fault-handling-for-shmem-fix-3.patch
userfaultfd-selftests-use-memfd_create-for-shmem-test-type.patch
userfaultfd-selftests-create-alias-mappings-in-the-shmem-test.patch
userfaultfd-selftests-reinitialize-test-context-in-each-test.patch
userfaultfd-selftests-exercise-minor-fault-handling-shmem-support.patch

