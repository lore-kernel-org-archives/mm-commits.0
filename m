Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57DB9C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 02:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13F6B610FC
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 02:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbhDICkc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Apr 2021 22:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhDICkc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 8 Apr 2021 22:40:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5CF9610C9;
        Fri,  9 Apr 2021 02:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617936018;
        bh=0Tn1p7SZnDc3aQitFigegaqgaAWUG/faYGDDGfaYERs=;
        h=Date:From:To:Subject:From;
        b=Txe9lNVofbWwrFXo/5GNna9gl+MpaVso+cz37vkjCR2BCnXpSYiV82oMlNbx1EfA2
         5fD7ksStRe+OENRUJ25Oz6VY88uqlWnMKC0Fp4f4oac93q9CdUnYmlCzapK9B42y1m
         NpzK/RdbxCqkVWdYBfY//aVISosDnJTATluQ9Z6E=
Date:   Thu, 08 Apr 2021 19:40:17 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, bgeffon@google.com,
        cannonmatthews@google.com, dgilbert@redhat.com, hughd@google.com,
        jglisse@redhat.com, joe@perches.com, lokeshgidra@google.com,
        mm-commits@vger.kernel.org, oupton@google.com, peterx@redhat.com,
        rientjes@google.com, rppt@linux.vnet.ibm.com, shli@fb.com,
        shuah@kernel.org, viro@zeniv.linux.org.uk, walken@google.com,
        wangqing@vivo.com
Subject:  [to-be-updated]
 userfaultfd-support-minor-fault-handling-for-shmem.patch removed from -mm
 tree
Message-ID: <20210409024017.qp3LCQ3NV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: support minor fault handling for shmem
has been removed from the -mm tree.  Its filename was
     userfaultfd-support-minor-fault-handling-for-shmem.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd: support minor fault handling for shmem

Patch series "userfaultfd: support minor fault handling for shmem", v2.

Overview
========

See my original series [1] for a detailed overview of minor fault handling
in general.  The feature in this series works exactly like the hugetblfs
version (from userspace's perspective).

I'm sending this as a separate series because:

- The original minor fault handling series has a full set of R-Bs, and seems
  close to being merged. So, it seems reasonable to start looking at this next
  step, which extends the basic functionality.

- shmem is different enough that this series may require some additional work
  before it's ready, and I don't want to delay the original series
  unnecessarily by bundling them together.

Use Case
========

In some cases it is useful to have VM memory backed by tmpfs instead of
hugetlbfs.  So, this feature will be used to support the same VM live
migration use case described in my original series.

Additionally, Android folks (Lokesh Gidra <lokeshgidra@google.com>) hope
to optimize the Android Runtime garbage collector using this feature:

"The plan is to use userfaultfd for concurrently compacting the heap. 
With this feature, the heap can be shared-mapped at another location where
the GC-thread(s) could continue the compaction operation without the need
to invoke userfault ioctl(UFFDIO_COPY) each time.  OTOH, if and when Java
threads get faults on the heap, UFFDIO_CONTINUE can be used to resume
execution.  Furthermore, this feature enables updating references in the
'non-moving' portion of the heap efficiently.  Without this feature,
uneccessary page copying (ioctl(UFFDIO_COPY)) would be required."

[1] https://lore.kernel.org/linux-fsdevel/20210301222728.176417-1-axelrasmussen@google.com/T/#t


This patch (of 5):

Modify the userfaultfd register API to allow registering shmem VMAs in
minor mode.  Modify the shmem mcopy implementation to support
UFFDIO_CONTINUE in order to resolve such faults.

Combine the shmem mcopy handler functions into a single
shmem_mcopy_atomic_pte, which takes a mode parameter.  This matches how
the hugetlbfs implementation is structured, and lets us remove a good
chunk of boilerplate.

[axelrasmussen@google.com: build fix]
  Link: https://lkml.kernel.org/r/20210309225830.2988269-1-axelrasmussen@google.com
[axelrasmussen@google.com: fix minor fault page leak]
  Link: https://lkml.kernel.org/r/20210322204836.1650221-1-axelrasmussen@google.com
[axelrasmussen@google.com: fix MCOPY_ATOMIC_CONTINUE behavior]
  Link: https://lkml.kernel.org/r/20210401183701.1774159-1-axelrasmussen@google.com
[axelrasmussen@google.com: fix MCOPY_ATOMIC_CONTINUE behavior]
  Link: https://lkml.kernel.org/r/20210405171917.2423068-1-axelrasmussen@google.com
Link: https://lkml.kernel.org/r/20210302000133.272579-1-axelrasmussen@google.com
Link: https://lkml.kernel.org/r/20210302000133.272579-2-axelrasmussen@google.com
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

 fs/userfaultfd.c                         |    6 
 include/linux/shmem_fs.h                 |   26 +-
 include/uapi/linux/userfaultfd.h         |    4 
 mm/memory.c                              |    8 
 mm/shmem.c                               |   65 ++-----
 mm/userfaultfd.c                         |  192 +++++++++++++++------
 tools/testing/selftests/vm/userfaultfd.c |   13 +
 7 files changed, 199 insertions(+), 115 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-support-minor-fault-handling-for-shmem
+++ a/fs/userfaultfd.c
@@ -1267,8 +1267,7 @@ static inline bool vma_can_userfault(str
 	}
 
 	if (vm_flags & VM_UFFD_MINOR) {
-		/* FIXME: Add minor fault interception for shmem. */
-		if (!is_vm_hugetlb_page(vma))
+		if (!(is_vm_hugetlb_page(vma) || vma_is_shmem(vma)))
 			return false;
 	}
 
@@ -1941,7 +1940,8 @@ static int userfaultfd_api(struct userfa
 	/* report all available features and ioctls to userland */
 	uffdio_api.features = UFFD_API_FEATURES;
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
-	uffdio_api.features &= ~UFFD_FEATURE_MINOR_HUGETLBFS;
+	uffdio_api.features &=
+		~(UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM);
 #endif
 	uffdio_api.ioctls = UFFD_API_IOCTLS;
 	ret = -EFAULT;
--- a/include/linux/shmem_fs.h~userfaultfd-support-minor-fault-handling-for-shmem
+++ a/include/linux/shmem_fs.h
@@ -9,6 +9,7 @@
 #include <linux/percpu_counter.h>
 #include <linux/xattr.h>
 #include <linux/fs_parser.h>
+#include <linux/userfaultfd_k.h>
 
 /* inode in-kernel data */
 
@@ -122,21 +123,16 @@ static inline bool shmem_file(struct fil
 extern bool shmem_charge(struct inode *inode, long pages);
 extern void shmem_uncharge(struct inode *inode, long pages);
 
+#ifdef CONFIG_USERFAULTFD
 #ifdef CONFIG_SHMEM
-extern int shmem_mcopy_atomic_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
-				  struct vm_area_struct *dst_vma,
-				  unsigned long dst_addr,
-				  unsigned long src_addr,
-				  struct page **pagep);
-extern int shmem_mfill_zeropage_pte(struct mm_struct *dst_mm,
-				    pmd_t *dst_pmd,
-				    struct vm_area_struct *dst_vma,
-				    unsigned long dst_addr);
-#else
-#define shmem_mcopy_atomic_pte(dst_mm, dst_pte, dst_vma, dst_addr, \
-			       src_addr, pagep)        ({ BUG(); 0; })
-#define shmem_mfill_zeropage_pte(dst_mm, dst_pmd, dst_vma, \
-				 dst_addr)      ({ BUG(); 0; })
-#endif
+int shmem_mcopy_atomic_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
+			   struct vm_area_struct *dst_vma,
+			   unsigned long dst_addr, unsigned long src_addr,
+			   enum mcopy_atomic_mode mode, struct page **pagep);
+#else /* !CONFIG_SHMEM */
+#define shmem_mcopy_atomic_pte(dst_mm, dst_pmd, dst_vma, dst_addr, \
+			       src_addr, mode, pagep)        ({ BUG(); 0; })
+#endif /* CONFIG_SHMEM */
+#endif /* CONFIG_USERFAULTFD */
 
 #endif
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-support-minor-fault-handling-for-shmem
+++ a/include/uapi/linux/userfaultfd.h
@@ -31,7 +31,8 @@
 			   UFFD_FEATURE_MISSING_SHMEM |		\
 			   UFFD_FEATURE_SIGBUS |		\
 			   UFFD_FEATURE_THREAD_ID |		\
-			   UFFD_FEATURE_MINOR_HUGETLBFS)
+			   UFFD_FEATURE_MINOR_HUGETLBFS |	\
+			   UFFD_FEATURE_MINOR_SHMEM)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -196,6 +197,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_SIGBUS			(1<<7)
 #define UFFD_FEATURE_THREAD_ID			(1<<8)
 #define UFFD_FEATURE_MINOR_HUGETLBFS		(1<<9)
+#define UFFD_FEATURE_MINOR_SHMEM		(1<<10)
 	__u64 features;
 
 	__u64 ioctls;
--- a/mm/memory.c~userfaultfd-support-minor-fault-handling-for-shmem
+++ a/mm/memory.c
@@ -3972,9 +3972,11 @@ static vm_fault_t do_read_fault(struct v
 	 * something).
 	 */
 	if (vma->vm_ops->map_pages && fault_around_bytes >> PAGE_SHIFT > 1) {
-		ret = do_fault_around(vmf);
-		if (ret)
-			return ret;
+		if (likely(!userfaultfd_minor(vmf->vma))) {
+			ret = do_fault_around(vmf);
+			if (ret)
+				return ret;
+		}
 	}
 
 	ret = __do_fault(vmf);
--- a/mm/shmem.c~userfaultfd-support-minor-fault-handling-for-shmem
+++ a/mm/shmem.c
@@ -77,7 +77,6 @@ static struct vfsmount *shm_mnt;
 #include <linux/syscalls.h>
 #include <linux/fcntl.h>
 #include <uapi/linux/memfd.h>
-#include <linux/userfaultfd_k.h>
 #include <linux/rmap.h>
 #include <linux/uuid.h>
 
@@ -1785,8 +1784,8 @@ unlock:
  * vm. If we swap it in we mark it dirty since we also free the swap
  * entry since a page cannot live in both the swap and page cache.
  *
- * vmf and fault_type are only supplied by shmem_fault:
- * otherwise they are NULL.
+ * vma, vmf, and fault_type are only supplied by shmem_fault: otherwise they
+ * are NULL.
  */
 static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
 	struct page **pagep, enum sgp_type sgp, gfp_t gfp,
@@ -1830,6 +1829,13 @@ repeat:
 		return error;
 	}
 
+	if (page && vma && userfaultfd_minor(vma)) {
+		unlock_page(page);
+		put_page(page);
+		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
+		return 0;
+	}
+
 	if (page)
 		hindex = page->index;
 	if (page && sgp == SGP_WRITE)
@@ -2354,13 +2360,11 @@ static struct inode *shmem_get_inode(str
 	return inode;
 }
 
-static int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
-				  pmd_t *dst_pmd,
-				  struct vm_area_struct *dst_vma,
-				  unsigned long dst_addr,
-				  unsigned long src_addr,
-				  bool zeropage,
-				  struct page **pagep)
+#ifdef CONFIG_USERFAULTFD
+int shmem_mcopy_atomic_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
+			   struct vm_area_struct *dst_vma,
+			   unsigned long dst_addr, unsigned long src_addr,
+			   enum mcopy_atomic_mode mode, struct page **pagep)
 {
 	struct inode *inode = file_inode(dst_vma->vm_file);
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -2372,7 +2376,11 @@ static int shmem_mfill_atomic_pte(struct
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
@@ -2383,7 +2391,7 @@ static int shmem_mfill_atomic_pte(struct
 		if (!page)
 			goto out_unacct_blocks;
 
-		if (!zeropage) {	/* mcopy_atomic */
+		if (mode == MCOPY_ATOMIC_NORMAL) {	/* mcopy_atomic */
 			page_kaddr = kmap_atomic(page);
 			ret = copy_from_user(page_kaddr,
 					     (const void __user *)src_addr,
@@ -2397,7 +2405,7 @@ static int shmem_mfill_atomic_pte(struct
 				/* don't free the page */
 				return -ENOENT;
 			}
-		} else {		/* mfill_zeropage_atomic */
+		} else {		/* zeropage */
 			clear_highpage(page);
 		}
 	} else {
@@ -2405,15 +2413,15 @@ static int shmem_mfill_atomic_pte(struct
 		*pagep = NULL;
 	}
 
-	VM_BUG_ON(PageLocked(page) || PageSwapBacked(page));
+	VM_BUG_ON(PageSwapBacked(page));
+	VM_BUG_ON(PageLocked(page));
 	__SetPageLocked(page);
 	__SetPageSwapBacked(page);
 	__SetPageUptodate(page);
 
 	ret = -EFAULT;
-	offset = linear_page_index(dst_vma, dst_addr);
 	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
-	if (unlikely(offset >= max_off))
+	if (unlikely(pgoff >= max_off))
 		goto out_release;
 
 	ret = shmem_add_to_page_cache(page, mapping, pgoff, NULL,
@@ -2439,7 +2447,7 @@ static int shmem_mfill_atomic_pte(struct
 
 	ret = -EFAULT;
 	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
-	if (unlikely(offset >= max_off))
+	if (unlikely(pgoff >= max_off))
 		goto out_release_unlock;
 
 	ret = -EEXIST;
@@ -2476,28 +2484,7 @@ out_unacct_blocks:
 	shmem_inode_unacct_blocks(inode, 1);
 	goto out;
 }
-
-int shmem_mcopy_atomic_pte(struct mm_struct *dst_mm,
-			   pmd_t *dst_pmd,
-			   struct vm_area_struct *dst_vma,
-			   unsigned long dst_addr,
-			   unsigned long src_addr,
-			   struct page **pagep)
-{
-	return shmem_mfill_atomic_pte(dst_mm, dst_pmd, dst_vma,
-				      dst_addr, src_addr, false, pagep);
-}
-
-int shmem_mfill_zeropage_pte(struct mm_struct *dst_mm,
-			     pmd_t *dst_pmd,
-			     struct vm_area_struct *dst_vma,
-			     unsigned long dst_addr)
-{
-	struct page *page = NULL;
-
-	return shmem_mfill_atomic_pte(dst_mm, dst_pmd, dst_vma,
-				      dst_addr, 0, true, &page);
-}
+#endif /* CONFIG_USERFAULTFD */
 
 #ifdef CONFIG_TMPFS
 static const struct inode_operations shmem_symlink_inode_operations;
--- a/mm/userfaultfd.c~userfaultfd-support-minor-fault-handling-for-shmem
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
@@ -415,10 +498,16 @@ static __always_inline ssize_t mfill_ato
 						unsigned long dst_addr,
 						unsigned long src_addr,
 						struct page **page,
-						bool zeropage,
+						enum mcopy_atomic_mode mode,
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
@@ -431,24 +520,20 @@ static __always_inline ssize_t mfill_ato
 	 * and not in the radix tree.
 	 */
 	if (!(dst_vma->vm_flags & VM_SHARED)) {
-		if (!zeropage)
+		if (mode == MCOPY_ATOMIC_NORMAL)
 			err = mcopy_atomic_pte(dst_mm, dst_pmd, dst_vma,
 					       dst_addr, src_addr, page,
-					       wp_copy);
-		else
+					       mode, wp_copy);
+		else if (mode == MCOPY_ATOMIC_ZEROPAGE)
 			err = mfill_zeropage_pte(dst_mm, dst_pmd,
 						 dst_vma, dst_addr);
 	} else {
 		VM_WARN_ON_ONCE(wp_copy);
-		if (!zeropage)
-			err = shmem_mcopy_atomic_pte(dst_mm, dst_pmd,
-						     dst_vma, dst_addr,
-						     src_addr, page);
-		else
-			err = shmem_mfill_zeropage_pte(dst_mm, dst_pmd,
-						       dst_vma, dst_addr);
+		err = shmem_mcopy_atomic_pte(dst_mm, dst_pmd, dst_vma, dst_addr,
+					     src_addr, mode, page);
 	}
 
+out:
 	return err;
 }
 
@@ -467,7 +552,6 @@ static __always_inline ssize_t __mcopy_a
 	long copied;
 	struct page *page;
 	bool wp_copy;
-	bool zeropage = (mcopy_mode == MCOPY_ATOMIC_ZEROPAGE);
 
 	/*
 	 * Sanitize the command parameters:
@@ -530,7 +614,7 @@ retry:
 
 	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
 		goto out_unlock;
-	if (mcopy_mode == MCOPY_ATOMIC_CONTINUE)
+	if (!vma_is_shmem(dst_vma) && mcopy_mode == MCOPY_ATOMIC_CONTINUE)
 		goto out_unlock;
 
 	/*
@@ -578,7 +662,7 @@ retry:
 		BUG_ON(pmd_trans_huge(*dst_pmd));
 
 		err = mfill_atomic_pte(dst_mm, dst_pmd, dst_vma, dst_addr,
-				       src_addr, &page, zeropage, wp_copy);
+				       src_addr, &page, mcopy_mode, wp_copy);
 		cond_resched();
 
 		if (unlikely(err == -ENOENT)) {
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-support-minor-fault-handling-for-shmem
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -368,11 +368,24 @@ static void wp_range(int ufd, __u64 star
 			(uint64_t)start);
 		exit(1);
 	}
+
+	/*
+	 * Error handling within the kernel for continue is subtly different
+	 * from copy or zeropage, so it may be a source of bugs. Trigger an
+	 * error (-EEXIST) on purpose, to verify doing so doesn't cause a BUG.
+	 */
+	req.mapped = 0;
+	ret = ioctl(ufd, UFFDIO_CONTINUE, &req);
+	if (ret >= 0 || req.mapped != -EEXIST) {
+		fprintf(stderr, "failed to exercise UFFDIO_CONTINUE error handling, ret=%d, mapped=%" PRId64, ret, req.mapped);
+		exit(1);
+	}
 }
 
 static void continue_range(int ufd, __u64 start, __u64 len)
 {
 	struct uffdio_continue req;
+	int ret;
 
 	req.range.start = start;
 	req.range.len = len;
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-add-minor-fault-registration-mode.patch
userfaultfd-disable-huge-pmd-sharing-for-minor-registered-vmas.patch
userfaultfd-hugetlbfs-only-compile-uffd-helpers-if-config-enabled.patch
userfaultfd-add-uffdio_continue-ioctl.patch
userfaultfd-update-documentation-to-describe-minor-fault-handling.patch
userfaultfd-selftests-add-test-exercising-minor-fault-handling.patch
userfaultfd-selftests-use-memfd_create-for-shmem-test-type.patch
userfaultfd-selftests-create-alias-mappings-in-the-shmem-test.patch
userfaultfd-selftests-reinitialize-test-context-in-each-test.patch
userfaultfd-selftests-exercise-minor-fault-handling-shmem-support.patch

