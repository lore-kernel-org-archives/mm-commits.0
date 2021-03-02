Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D54C433DB
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C0C164E38
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379586AbhCCN3F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:29:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235032AbhCCADB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 19:03:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EAB964F39;
        Tue,  2 Mar 2021 23:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614728363;
        bh=ZNeJEHGds/JLy1841ZVqwPO22pN2f2LI08EYv+PO8uE=;
        h=Date:From:To:Subject:From;
        b=ytRHQphDZQsVcl2J7KrpgmavPIw2Gue74LD1tA0vps1Zaek4u3GVmCELSI8cRpzEy
         XtqXrYldDMk1/vMfCJzXFSrBUXHs0xmrp1zkRRPYbSynNVqKEkbB2G8iyGLPuVc75A
         08grqOcXfmrNfZpTVgQmaAMqf4oaIasmLx+Tt1cs=
Date:   Tue, 02 Mar 2021 15:39:21 -0800
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
 userfaultfd-support-minor-fault-handling-for-shmem.patch added to -mm tree
Message-ID: <20210302233921.O_X_4N1j9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: support minor fault handling for shmem
has been added to the -mm tree.  Its filename is
     userfaultfd-support-minor-fault-handling-for-shmem.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-support-minor-fault-handling-for-shmem.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-support-minor-fault-handling-for-shmem.patch

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

 fs/userfaultfd.c                 |    6 -
 include/linux/shmem_fs.h         |   26 +++-----
 include/uapi/linux/userfaultfd.h |    4 -
 mm/memory.c                      |    8 +-
 mm/shmem.c                       |   92 +++++++++++++----------------
 mm/userfaultfd.c                 |   27 ++++----
 6 files changed, 79 insertions(+), 84 deletions(-)

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
@@ -3929,9 +3929,11 @@ static vm_fault_t do_read_fault(struct v
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
@@ -1830,6 +1829,12 @@ repeat:
 		return error;
 	}
 
+	if (page && vma && userfaultfd_minor(vma)) {
+		unlock_page(page);
+		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
+		return 0;
+	}
+
 	if (page)
 		hindex = page->index;
 	if (page && sgp == SGP_WRITE)
@@ -2354,14 +2359,12 @@ static struct inode *shmem_get_inode(str
 	return inode;
 }
 
-static int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
-				  pmd_t *dst_pmd,
-				  struct vm_area_struct *dst_vma,
-				  unsigned long dst_addr,
-				  unsigned long src_addr,
-				  bool zeropage,
-				  struct page **pagep)
+int shmem_mcopy_atomic_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
+			   struct vm_area_struct *dst_vma,
+			   unsigned long dst_addr, unsigned long src_addr,
+			   enum mcopy_atomic_mode mode, struct page **pagep)
 {
+	bool is_continue = (mode == MCOPY_ATOMIC_CONTINUE);
 	struct inode *inode = file_inode(dst_vma->vm_file);
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct address_space *mapping = inode->i_mapping;
@@ -2378,12 +2381,17 @@ static int shmem_mfill_atomic_pte(struct
 	if (!shmem_inode_acct_block(inode, 1))
 		goto out;
 
-	if (!*pagep) {
+	if (is_continue) {
+		ret = -EFAULT;
+		page = find_lock_page(mapping, pgoff);
+		if (!page)
+			goto out_unacct_blocks;
+	} else if (!*pagep) {
 		page = shmem_alloc_page(gfp, info, pgoff);
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
@@ -2405,10 +2413,13 @@ static int shmem_mfill_atomic_pte(struct
 		*pagep = NULL;
 	}
 
-	VM_BUG_ON(PageLocked(page) || PageSwapBacked(page));
-	__SetPageLocked(page);
-	__SetPageSwapBacked(page);
-	__SetPageUptodate(page);
+	if (!is_continue) {
+		VM_BUG_ON(PageSwapBacked(page));
+		VM_BUG_ON(PageLocked(page));
+		__SetPageLocked(page);
+		__SetPageSwapBacked(page);
+		__SetPageUptodate(page);
+	}
 
 	ret = -EFAULT;
 	offset = linear_page_index(dst_vma, dst_addr);
@@ -2416,10 +2427,13 @@ static int shmem_mfill_atomic_pte(struct
 	if (unlikely(offset >= max_off))
 		goto out_release;
 
-	ret = shmem_add_to_page_cache(page, mapping, pgoff, NULL,
-				      gfp & GFP_RECLAIM_MASK, dst_mm);
-	if (ret)
-		goto out_release;
+	/* If page wasn't already in the page cache, add it. */
+	if (!is_continue) {
+		ret = shmem_add_to_page_cache(page, mapping, pgoff, NULL,
+					      gfp & GFP_RECLAIM_MASK, dst_mm);
+		if (ret)
+			goto out_release;
+	}
 
 	_dst_pte = mk_pte(page, dst_vma->vm_page_prot);
 	if (dst_vma->vm_flags & VM_WRITE)
@@ -2446,13 +2460,15 @@ static int shmem_mfill_atomic_pte(struct
 	if (!pte_none(*dst_pte))
 		goto out_release_unlock;
 
-	lru_cache_add(page);
+	if (!is_continue) {
+		lru_cache_add(page);
 
-	spin_lock_irq(&info->lock);
-	info->alloced++;
-	inode->i_blocks += BLOCKS_PER_PAGE;
-	shmem_recalc_inode(inode);
-	spin_unlock_irq(&info->lock);
+		spin_lock_irq(&info->lock);
+		info->alloced++;
+		inode->i_blocks += BLOCKS_PER_PAGE;
+		shmem_recalc_inode(inode);
+		spin_unlock_irq(&info->lock);
+	}
 
 	inc_mm_counter(dst_mm, mm_counter_file(page));
 	page_add_file_rmap(page, false);
@@ -2477,28 +2493,6 @@ out_unacct_blocks:
 	goto out;
 }
 
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
-
 #ifdef CONFIG_TMPFS
 static const struct inode_operations shmem_symlink_inode_operations;
 static const struct inode_operations shmem_short_symlink_operations;
--- a/mm/userfaultfd.c~userfaultfd-support-minor-fault-handling-for-shmem
+++ a/mm/userfaultfd.c
@@ -415,7 +415,7 @@ static __always_inline ssize_t mfill_ato
 						unsigned long dst_addr,
 						unsigned long src_addr,
 						struct page **page,
-						bool zeropage,
+						enum mcopy_atomic_mode mode,
 						bool wp_copy)
 {
 	ssize_t err;
@@ -431,22 +431,24 @@ static __always_inline ssize_t mfill_ato
 	 * and not in the radix tree.
 	 */
 	if (!(dst_vma->vm_flags & VM_SHARED)) {
-		if (!zeropage)
+		switch (mode) {
+		case MCOPY_ATOMIC_NORMAL:
 			err = mcopy_atomic_pte(dst_mm, dst_pmd, dst_vma,
 					       dst_addr, src_addr, page,
 					       wp_copy);
-		else
+			break;
+		case MCOPY_ATOMIC_ZEROPAGE:
 			err = mfill_zeropage_pte(dst_mm, dst_pmd,
 						 dst_vma, dst_addr);
+			break;
+		case MCOPY_ATOMIC_CONTINUE:
+			err = -EINVAL;
+			break;
+		}
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
 
 	return err;
@@ -467,7 +469,6 @@ static __always_inline ssize_t __mcopy_a
 	long copied;
 	struct page *page;
 	bool wp_copy;
-	bool zeropage = (mcopy_mode == MCOPY_ATOMIC_ZEROPAGE);
 
 	/*
 	 * Sanitize the command parameters:
@@ -530,7 +531,7 @@ retry:
 
 	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
 		goto out_unlock;
-	if (mcopy_mode == MCOPY_ATOMIC_CONTINUE)
+	if (!vma_is_shmem(dst_vma) && mcopy_mode == MCOPY_ATOMIC_CONTINUE)
 		goto out_unlock;
 
 	/*
@@ -578,7 +579,7 @@ retry:
 		BUG_ON(pmd_trans_huge(*dst_pmd));
 
 		err = mfill_atomic_pte(dst_mm, dst_pmd, dst_vma, dst_addr,
-				       src_addr, &page, zeropage, wp_copy);
+				       src_addr, &page, mcopy_mode, wp_copy);
 		cond_resched();
 
 		if (unlikely(err == -ENOENT)) {
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-add-minor-fault-registration-mode.patch
userfaultfd-disable-huge-pmd-sharing-for-minor-registered-vmas.patch
userfaultfd-hugetlbfs-only-compile-uffd-helpers-if-config-enabled.patch
userfaultfd-add-uffdio_continue-ioctl.patch
userfaultfd-update-documentation-to-describe-minor-fault-handling.patch
userfaultfd-selftests-add-test-exercising-minor-fault-handling.patch
userfaultfd-support-minor-fault-handling-for-shmem.patch
userfaultfd-selftests-use-memfd_create-for-shmem-test-type.patch
userfaultfd-selftests-create-alias-mappings-in-the-shmem-test.patch
userfaultfd-selftests-reinitialize-test-context-in-each-test.patch
userfaultfd-selftests-exercise-minor-fault-handling-shmem-support.patch

