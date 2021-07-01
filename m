Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EAD4C11F68
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 391E861466
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238409AbhGABwD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABwC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB6046135C;
        Thu,  1 Jul 2021 01:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104172;
        bh=5i1ZbkF7O2Ww0Cthjyad1KJsaV31GfRDz8sohDiopZI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hsTZuH4JaWLTh47DEvNx4jcDTFAXQRz80KMzry9Mwq3C9ByGAioSyJ6iJ8Hgre7QS
         Jo5t1aexs1VC0g9xUtf7veOUSOqCpfF9LotHmdyrVHy3N+wr3KYQpXPLEtPCUiYPCR
         iecQrkG8WlSd/jj6b1EpcnV00yKnZyU4TCe3oeE8=
Date:   Wed, 30 Jun 2021 18:49:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        almasrymina@google.com, axelrasmussen@google.com,
        bgeffon@google.com, dgilbert@redhat.com, hughd@google.com,
        jglisse@redhat.com, joe@perches.com, kirill@shutemov.name,
        linux-mm@kvack.org, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oupton@google.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shli@fb.com, shuah@kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        wangqing@vivo.com
Subject:  [patch 044/192] userfaultfd/shmem: modify
 shmem_mfill_atomic_pte to use install_pte()
Message-ID: <20210701014931.siUl7ScLk%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd/shmem: modify shmem_mfill_atomic_pte to use install_pte()

In a previous commit, we added the mfill_atomic_install_pte() helper. 
This helper does the job of setting up PTEs for an existing page, to map
it into a given VMA.  It deals with both the anon and shmem cases, as well
as the shared and private cases.

In other words, shmem_mfill_atomic_pte() duplicates a case it already
handles.  So, expose it, and let shmem_mfill_atomic_pte() use it directly,
to reduce code duplication.

This requires that we refactor shmem_mfill_atomic_pte() a bit:

Instead of doing accounting (shmem_recalc_inode() et al) part-way through
the PTE setup, do it afterward.  This frees up mfill_atomic_install_pte()
from having to care about this accounting, and means we don't need to e.g.
shmem_uncharge() in the error path.

A side effect is this switches shmem_mfill_atomic_pte() to use
lru_cache_add_inactive_or_unevictable() instead of just lru_cache_add(). 
This wrapper does some extra accounting in an exceptional case, if
appropriate, so it's actually the more correct thing to use.

Link: https://lkml.kernel.org/r/20210503180737.2487560-7-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/userfaultfd_k.h |    5 ++
 mm/shmem.c                    |   58 ++++++--------------------------
 mm/userfaultfd.c              |   17 +++------
 3 files changed, 23 insertions(+), 57 deletions(-)

--- a/include/linux/userfaultfd_k.h~userfaultfd-shmem-modify-shmem_mfill_atomic_pte-to-use-install_pte
+++ a/include/linux/userfaultfd_k.h
@@ -53,6 +53,11 @@ enum mcopy_atomic_mode {
 	MCOPY_ATOMIC_CONTINUE,
 };
 
+extern int mfill_atomic_install_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
+				    struct vm_area_struct *dst_vma,
+				    unsigned long dst_addr, struct page *page,
+				    bool newly_allocated, bool wp_copy);
+
 extern ssize_t mcopy_atomic(struct mm_struct *dst_mm, unsigned long dst_start,
 			    unsigned long src_start, unsigned long len,
 			    bool *mmap_changing, __u64 mode);
--- a/mm/shmem.c~userfaultfd-shmem-modify-shmem_mfill_atomic_pte-to-use-install_pte
+++ a/mm/shmem.c
@@ -2376,14 +2376,11 @@ int shmem_mfill_atomic_pte(struct mm_str
 	struct address_space *mapping = inode->i_mapping;
 	gfp_t gfp = mapping_gfp_mask(mapping);
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
-	spinlock_t *ptl;
 	void *page_kaddr;
 	struct page *page;
-	pte_t _dst_pte, *dst_pte;
 	int ret;
 	pgoff_t max_off;
 
-	ret = -ENOMEM;
 	if (!shmem_inode_acct_block(inode, 1)) {
 		/*
 		 * We may have got a page, returned -ENOENT triggering a retry,
@@ -2394,10 +2391,11 @@ int shmem_mfill_atomic_pte(struct mm_str
 			put_page(*pagep);
 			*pagep = NULL;
 		}
-		goto out;
+		return -ENOMEM;
 	}
 
 	if (!*pagep) {
+		ret = -ENOMEM;
 		page = shmem_alloc_page(gfp, info, pgoff);
 		if (!page)
 			goto out_unacct_blocks;
@@ -2412,9 +2410,9 @@ int shmem_mfill_atomic_pte(struct mm_str
 			/* fallback to copy_from_user outside mmap_lock */
 			if (unlikely(ret)) {
 				*pagep = page;
-				shmem_inode_unacct_blocks(inode, 1);
+				ret = -ENOENT;
 				/* don't free the page */
-				return -ENOENT;
+				goto out_unacct_blocks;
 			}
 		} else {		/* ZEROPAGE */
 			clear_highpage(page);
@@ -2440,32 +2438,10 @@ int shmem_mfill_atomic_pte(struct mm_str
 	if (ret)
 		goto out_release;
 
-	_dst_pte = mk_pte(page, dst_vma->vm_page_prot);
-	if (dst_vma->vm_flags & VM_WRITE)
-		_dst_pte = pte_mkwrite(pte_mkdirty(_dst_pte));
-	else {
-		/*
-		 * We don't set the pte dirty if the vma has no
-		 * VM_WRITE permission, so mark the page dirty or it
-		 * could be freed from under us. We could do it
-		 * unconditionally before unlock_page(), but doing it
-		 * only if VM_WRITE is not set is faster.
-		 */
-		set_page_dirty(page);
-	}
-
-	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
-
-	ret = -EFAULT;
-	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
-	if (unlikely(pgoff >= max_off))
-		goto out_release_unlock;
-
-	ret = -EEXIST;
-	if (!pte_none(*dst_pte))
-		goto out_release_unlock;
-
-	lru_cache_add(page);
+	ret = mfill_atomic_install_pte(dst_mm, dst_pmd, dst_vma, dst_addr,
+				       page, true, false);
+	if (ret)
+		goto out_delete_from_cache;
 
 	spin_lock_irq(&info->lock);
 	info->alloced++;
@@ -2473,27 +2449,17 @@ int shmem_mfill_atomic_pte(struct mm_str
 	shmem_recalc_inode(inode);
 	spin_unlock_irq(&info->lock);
 
-	inc_mm_counter(dst_mm, mm_counter_file(page));
-	page_add_file_rmap(page, false);
-	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
-
-	/* No need to invalidate - it was non-present before */
-	update_mmu_cache(dst_vma, dst_addr, dst_pte);
-	pte_unmap_unlock(dst_pte, ptl);
+	SetPageDirty(page);
 	unlock_page(page);
-	ret = 0;
-out:
-	return ret;
-out_release_unlock:
-	pte_unmap_unlock(dst_pte, ptl);
-	ClearPageDirty(page);
+	return 0;
+out_delete_from_cache:
 	delete_from_page_cache(page);
 out_release:
 	unlock_page(page);
 	put_page(page);
 out_unacct_blocks:
 	shmem_inode_unacct_blocks(inode, 1);
-	goto out;
+	return ret;
 }
 #endif /* CONFIG_USERFAULTFD */
 
--- a/mm/userfaultfd.c~userfaultfd-shmem-modify-shmem_mfill_atomic_pte-to-use-install_pte
+++ a/mm/userfaultfd.c
@@ -51,18 +51,13 @@ struct vm_area_struct *find_dst_vma(stru
 /*
  * Install PTEs, to map dst_addr (within dst_vma) to page.
  *
- * This function handles MCOPY_ATOMIC_CONTINUE (which is always file-backed),
- * whether or not dst_vma is VM_SHARED. It also handles the more general
- * MCOPY_ATOMIC_NORMAL case, when dst_vma is *not* VM_SHARED (it may be file
- * backed, or not).
- *
- * Note that MCOPY_ATOMIC_NORMAL for a VM_SHARED dst_vma is handled by
- * shmem_mcopy_atomic_pte instead.
+ * This function handles both MCOPY_ATOMIC_NORMAL and _CONTINUE for both shmem
+ * and anon, and for both shared and private VMAs.
  */
-static int mfill_atomic_install_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
-				    struct vm_area_struct *dst_vma,
-				    unsigned long dst_addr, struct page *page,
-				    bool newly_allocated, bool wp_copy)
+int mfill_atomic_install_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
+			     struct vm_area_struct *dst_vma,
+			     unsigned long dst_addr, struct page *page,
+			     bool newly_allocated, bool wp_copy)
 {
 	int ret;
 	pte_t _dst_pte, *dst_pte;
_
