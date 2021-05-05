Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8860CC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E81061417
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhEEBgq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230451AbhEEBgq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:36:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E19061408;
        Wed,  5 May 2021 01:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178550;
        bh=LPk0VptcGq3Owi5dC9P445aPV1+csXSi13Qd4Zp1dAw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bHJT4kBBLzuuJFePhqLMhJLXSVc1YVcw6w6t/b/YHmCoe6ACUPorRlGLzLoMGdf7m
         ADYMJNkMKX18NrKUMdXdvQpmo2U9DAi3b+E4L7NSSKSu5tLjrGTpdmT65+PbkC1lVU
         vx50AwN61OjSfOrJEKcF1357Y4IBMwSPGAH7Cngc=
Date:   Tue, 04 May 2021 18:35:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, almasrymina@google.com,
        anshuman.khandual@arm.com, axelrasmussen@google.com,
        cannonmatthews@google.com, catalin.marinas@arm.com,
        chinwen.chang@mediatek.com, dgilbert@redhat.com, jannh@google.com,
        jglisse@redhat.com, kirill@shutemov.name, linux-mm@kvack.org,
        lokeshgidra@google.com, mike.kravetz@oracle.com, mingo@redhat.com,
        mkoutny@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        npiggin@gmail.com, oupton@google.com, peterx@redhat.com,
        rientjes@google.com, rostedt@goodmis.org, rppt@linux.vnet.ibm.com,
        ruprecht@google.com, shawn@anastas.io, shli@fb.com,
        steven.price@arm.com, torvalds@linux-foundation.org,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, walken@google.com,
        willy@infradead.org, ying.huang@intel.com
Subject:  [patch 057/143] userfaultfd: add UFFDIO_CONTINUE ioctl
Message-ID: <20210505013549.XPVKuEiR9%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd: add UFFDIO_CONTINUE ioctl

This ioctl is how userspace ought to resolve "minor" userfaults. The
idea is, userspace is notified that a minor fault has occurred. It might
change the contents of the page using its second non-UFFD mapping, or
not. Then, it calls UFFDIO_CONTINUE to tell the kernel "I have ensured
the page contents are correct, carry on setting up the mapping".

Note that it doesn't make much sense to use UFFDIO_{COPY,ZEROPAGE} for
MINOR registered VMAs. ZEROPAGE maps the VMA to the zero page; but in
the minor fault case, we already have some pre-existing underlying page.
Likewise, UFFDIO_COPY isn't useful if we have a second non-UFFD mapping.
We'd just use memcpy() or similar instead.

It turns out hugetlb_mcopy_atomic_pte() already does very close to what
we want, if an existing page is provided via `struct page **pagep`. We
already special-case the behavior a bit for the UFFDIO_ZEROPAGE case, so
just extend that design: add an enum for the three modes of operation,
and make the small adjustments needed for the MCOPY_ATOMIC_CONTINUE
case. (Basically, look up the existing page, and avoid adding the
existing page to the page cache or calling set_page_huge_active() on
it.)

Link: https://lkml.kernel.org/r/20210301222728.176417-5-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Adam Ruprecht <ruprecht@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Cannon Matthews <cannonmatthews@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michal Koutn" <mkoutny@suse.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shawn Anastasio <shawn@anastas.io>
Cc: Steven Price <steven.price@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c                 |   67 +++++++++++++++++++++++++++++
 include/linux/hugetlb.h          |    3 +
 include/linux/userfaultfd_k.h    |   18 +++++++
 include/uapi/linux/userfaultfd.h |   21 ++++++++-
 mm/hugetlb.c                     |   40 +++++++++++------
 mm/userfaultfd.c                 |   37 +++++++++-------
 6 files changed, 156 insertions(+), 30 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-add-uffdio_continue-ioctl
+++ a/fs/userfaultfd.c
@@ -1487,6 +1487,10 @@ out_unlock:
 		if (!(uffdio_register.mode & UFFDIO_REGISTER_MODE_WP))
 			ioctls_out &= ~((__u64)1 << _UFFDIO_WRITEPROTECT);
 
+		/* CONTINUE ioctl is only supported for MINOR ranges. */
+		if (!(uffdio_register.mode & UFFDIO_REGISTER_MODE_MINOR))
+			ioctls_out &= ~((__u64)1 << _UFFDIO_CONTINUE);
+
 		/*
 		 * Now that we scanned all vmas we can already tell
 		 * userland which ioctls methods are guaranteed to
@@ -1840,6 +1844,66 @@ static int userfaultfd_writeprotect(stru
 	return ret;
 }
 
+static int userfaultfd_continue(struct userfaultfd_ctx *ctx, unsigned long arg)
+{
+	__s64 ret;
+	struct uffdio_continue uffdio_continue;
+	struct uffdio_continue __user *user_uffdio_continue;
+	struct userfaultfd_wake_range range;
+
+	user_uffdio_continue = (struct uffdio_continue __user *)arg;
+
+	ret = -EAGAIN;
+	if (READ_ONCE(ctx->mmap_changing))
+		goto out;
+
+	ret = -EFAULT;
+	if (copy_from_user(&uffdio_continue, user_uffdio_continue,
+			   /* don't copy the output fields */
+			   sizeof(uffdio_continue) - (sizeof(__s64))))
+		goto out;
+
+	ret = validate_range(ctx->mm, &uffdio_continue.range.start,
+			     uffdio_continue.range.len);
+	if (ret)
+		goto out;
+
+	ret = -EINVAL;
+	/* double check for wraparound just in case. */
+	if (uffdio_continue.range.start + uffdio_continue.range.len <=
+	    uffdio_continue.range.start) {
+		goto out;
+	}
+	if (uffdio_continue.mode & ~UFFDIO_CONTINUE_MODE_DONTWAKE)
+		goto out;
+
+	if (mmget_not_zero(ctx->mm)) {
+		ret = mcopy_continue(ctx->mm, uffdio_continue.range.start,
+				     uffdio_continue.range.len,
+				     &ctx->mmap_changing);
+		mmput(ctx->mm);
+	} else {
+		return -ESRCH;
+	}
+
+	if (unlikely(put_user(ret, &user_uffdio_continue->mapped)))
+		return -EFAULT;
+	if (ret < 0)
+		goto out;
+
+	/* len == 0 would wake all */
+	BUG_ON(!ret);
+	range.len = ret;
+	if (!(uffdio_continue.mode & UFFDIO_CONTINUE_MODE_DONTWAKE)) {
+		range.start = uffdio_continue.range.start;
+		wake_userfault(ctx, &range);
+	}
+	ret = range.len == uffdio_continue.range.len ? 0 : -EAGAIN;
+
+out:
+	return ret;
+}
+
 static inline unsigned int uffd_ctx_features(__u64 user_features)
 {
 	/*
@@ -1927,6 +1991,9 @@ static long userfaultfd_ioctl(struct fil
 	case UFFDIO_WRITEPROTECT:
 		ret = userfaultfd_writeprotect(ctx, arg);
 		break;
+	case UFFDIO_CONTINUE:
+		ret = userfaultfd_continue(ctx, arg);
+		break;
 	}
 	return ret;
 }
--- a/include/linux/hugetlb.h~userfaultfd-add-uffdio_continue-ioctl
+++ a/include/linux/hugetlb.h
@@ -11,6 +11,7 @@
 #include <linux/kref.h>
 #include <linux/pgtable.h>
 #include <linux/gfp.h>
+#include <linux/userfaultfd_k.h>
 
 struct ctl_table;
 struct user_struct;
@@ -139,6 +140,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 				struct vm_area_struct *dst_vma,
 				unsigned long dst_addr,
 				unsigned long src_addr,
+				enum mcopy_atomic_mode mode,
 				struct page **pagep);
 #endif /* CONFIG_USERFAULTFD */
 bool hugetlb_reserve_pages(struct inode *inode, long from, long to,
@@ -318,6 +320,7 @@ static inline int hugetlb_mcopy_atomic_p
 						struct vm_area_struct *dst_vma,
 						unsigned long dst_addr,
 						unsigned long src_addr,
+						enum mcopy_atomic_mode mode,
 						struct page **pagep)
 {
 	BUG();
--- a/include/linux/userfaultfd_k.h~userfaultfd-add-uffdio_continue-ioctl
+++ a/include/linux/userfaultfd_k.h
@@ -37,6 +37,22 @@ extern int sysctl_unprivileged_userfault
 
 extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
 
+/*
+ * The mode of operation for __mcopy_atomic and its helpers.
+ *
+ * This is almost an implementation detail (mcopy_atomic below doesn't take this
+ * as a parameter), but it's exposed here because memory-kind-specific
+ * implementations (e.g. hugetlbfs) need to know the mode of operation.
+ */
+enum mcopy_atomic_mode {
+	/* A normal copy_from_user into the destination range. */
+	MCOPY_ATOMIC_NORMAL,
+	/* Don't copy; map the destination range to the zero page. */
+	MCOPY_ATOMIC_ZEROPAGE,
+	/* Just install pte(s) with the existing page(s) in the page cache. */
+	MCOPY_ATOMIC_CONTINUE,
+};
+
 extern ssize_t mcopy_atomic(struct mm_struct *dst_mm, unsigned long dst_start,
 			    unsigned long src_start, unsigned long len,
 			    bool *mmap_changing, __u64 mode);
@@ -44,6 +60,8 @@ extern ssize_t mfill_zeropage(struct mm_
 			      unsigned long dst_start,
 			      unsigned long len,
 			      bool *mmap_changing);
+extern ssize_t mcopy_continue(struct mm_struct *dst_mm, unsigned long dst_start,
+			      unsigned long len, bool *mmap_changing);
 extern int mwriteprotect_range(struct mm_struct *dst_mm,
 			       unsigned long start, unsigned long len,
 			       bool enable_wp, bool *mmap_changing);
--- a/include/uapi/linux/userfaultfd.h~userfaultfd-add-uffdio_continue-ioctl
+++ a/include/uapi/linux/userfaultfd.h
@@ -40,10 +40,12 @@
 	((__u64)1 << _UFFDIO_WAKE |		\
 	 (__u64)1 << _UFFDIO_COPY |		\
 	 (__u64)1 << _UFFDIO_ZEROPAGE |		\
-	 (__u64)1 << _UFFDIO_WRITEPROTECT)
+	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
+	 (__u64)1 << _UFFDIO_CONTINUE)
 #define UFFD_API_RANGE_IOCTLS_BASIC		\
 	((__u64)1 << _UFFDIO_WAKE |		\
-	 (__u64)1 << _UFFDIO_COPY)
+	 (__u64)1 << _UFFDIO_COPY |		\
+	 (__u64)1 << _UFFDIO_CONTINUE)
 
 /*
  * Valid ioctl command number range with this API is from 0x00 to
@@ -59,6 +61,7 @@
 #define _UFFDIO_COPY			(0x03)
 #define _UFFDIO_ZEROPAGE		(0x04)
 #define _UFFDIO_WRITEPROTECT		(0x06)
+#define _UFFDIO_CONTINUE		(0x07)
 #define _UFFDIO_API			(0x3F)
 
 /* userfaultfd ioctl ids */
@@ -77,6 +80,8 @@
 				      struct uffdio_zeropage)
 #define UFFDIO_WRITEPROTECT	_IOWR(UFFDIO, _UFFDIO_WRITEPROTECT, \
 				      struct uffdio_writeprotect)
+#define UFFDIO_CONTINUE		_IOR(UFFDIO, _UFFDIO_CONTINUE,	\
+				     struct uffdio_continue)
 
 /* read() structure */
 struct uffd_msg {
@@ -268,6 +273,18 @@ struct uffdio_writeprotect {
 	__u64 mode;
 };
 
+struct uffdio_continue {
+	struct uffdio_range range;
+#define UFFDIO_CONTINUE_MODE_DONTWAKE		((__u64)1<<0)
+	__u64 mode;
+
+	/*
+	 * Fields below here are written by the ioctl and must be at the end:
+	 * the copy_from_user will not read past here.
+	 */
+	__s64 mapped;
+};
+
 /*
  * Flags for the userfaultfd(2) system call itself.
  */
--- a/mm/hugetlb.c~userfaultfd-add-uffdio_continue-ioctl
+++ a/mm/hugetlb.c
@@ -39,7 +39,6 @@
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>
 #include <linux/node.h>
-#include <linux/userfaultfd_k.h>
 #include <linux/page_owner.h>
 #include "internal.h"
 
@@ -4865,8 +4864,10 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			    struct vm_area_struct *dst_vma,
 			    unsigned long dst_addr,
 			    unsigned long src_addr,
+			    enum mcopy_atomic_mode mode,
 			    struct page **pagep)
 {
+	bool is_continue = (mode == MCOPY_ATOMIC_CONTINUE);
 	struct address_space *mapping;
 	pgoff_t idx;
 	unsigned long size;
@@ -4876,8 +4877,17 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	spinlock_t *ptl;
 	int ret;
 	struct page *page;
+	int writable;
 
-	if (!*pagep) {
+	mapping = dst_vma->vm_file->f_mapping;
+	idx = vma_hugecache_offset(h, dst_vma, dst_addr);
+
+	if (is_continue) {
+		ret = -EFAULT;
+		page = find_lock_page(mapping, idx);
+		if (!page)
+			goto out;
+	} else if (!*pagep) {
 		ret = -ENOMEM;
 		page = alloc_huge_page(dst_vma, dst_addr, 0);
 		if (IS_ERR(page))
@@ -4906,13 +4916,8 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	 */
 	__SetPageUptodate(page);
 
-	mapping = dst_vma->vm_file->f_mapping;
-	idx = vma_hugecache_offset(h, dst_vma, dst_addr);
-
-	/*
-	 * If shared, add to page cache
-	 */
-	if (vm_shared) {
+	/* Add shared, newly allocated pages to the page cache. */
+	if (vm_shared && !is_continue) {
 		size = i_size_read(mapping->host) >> huge_page_shift(h);
 		ret = -EFAULT;
 		if (idx >= size)
@@ -4957,8 +4962,14 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		hugepage_add_new_anon_rmap(page, dst_vma, dst_addr);
 	}
 
-	_dst_pte = make_huge_pte(dst_vma, page, dst_vma->vm_flags & VM_WRITE);
-	if (dst_vma->vm_flags & VM_WRITE)
+	/* For CONTINUE on a non-shared VMA, don't set VM_WRITE for CoW. */
+	if (is_continue && !vm_shared)
+		writable = 0;
+	else
+		writable = dst_vma->vm_flags & VM_WRITE;
+
+	_dst_pte = make_huge_pte(dst_vma, page, writable);
+	if (writable)
 		_dst_pte = huge_pte_mkdirty(_dst_pte);
 	_dst_pte = pte_mkyoung(_dst_pte);
 
@@ -4972,15 +4983,16 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 
 	spin_unlock(ptl);
-	SetHPageMigratable(page);
-	if (vm_shared)
+	if (!is_continue)
+		SetHPageMigratable(page);
+	if (vm_shared || is_continue)
 		unlock_page(page);
 	ret = 0;
 out:
 	return ret;
 out_release_unlock:
 	spin_unlock(ptl);
-	if (vm_shared)
+	if (vm_shared || is_continue)
 		unlock_page(page);
 out_release_nounlock:
 	put_page(page);
--- a/mm/userfaultfd.c~userfaultfd-add-uffdio_continue-ioctl
+++ a/mm/userfaultfd.c
@@ -207,7 +207,7 @@ static __always_inline ssize_t __mcopy_a
 					      unsigned long dst_start,
 					      unsigned long src_start,
 					      unsigned long len,
-					      bool zeropage)
+					      enum mcopy_atomic_mode mode)
 {
 	int vm_alloc_shared = dst_vma->vm_flags & VM_SHARED;
 	int vm_shared = dst_vma->vm_flags & VM_SHARED;
@@ -227,7 +227,7 @@ static __always_inline ssize_t __mcopy_a
 	 * by THP.  Since we can not reliably insert a zero page, this
 	 * feature is not supported.
 	 */
-	if (zeropage) {
+	if (mode == MCOPY_ATOMIC_ZEROPAGE) {
 		mmap_read_unlock(dst_mm);
 		return -EINVAL;
 	}
@@ -273,8 +273,6 @@ retry:
 	}
 
 	while (src_addr < src_start + len) {
-		pte_t dst_pteval;
-
 		BUG_ON(dst_addr >= dst_start + len);
 
 		/*
@@ -297,16 +295,16 @@ retry:
 			goto out_unlock;
 		}
 
-		err = -EEXIST;
-		dst_pteval = huge_ptep_get(dst_pte);
-		if (!huge_pte_none(dst_pteval)) {
+		if (mode != MCOPY_ATOMIC_CONTINUE &&
+		    !huge_pte_none(huge_ptep_get(dst_pte))) {
+			err = -EEXIST;
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			i_mmap_unlock_read(mapping);
 			goto out_unlock;
 		}
 
 		err = hugetlb_mcopy_atomic_pte(dst_mm, dst_pte, dst_vma,
-						dst_addr, src_addr, &page);
+					       dst_addr, src_addr, mode, &page);
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		i_mmap_unlock_read(mapping);
@@ -408,7 +406,7 @@ extern ssize_t __mcopy_atomic_hugetlb(st
 				      unsigned long dst_start,
 				      unsigned long src_start,
 				      unsigned long len,
-				      bool zeropage);
+				      enum mcopy_atomic_mode mode);
 #endif /* CONFIG_HUGETLB_PAGE */
 
 static __always_inline ssize_t mfill_atomic_pte(struct mm_struct *dst_mm,
@@ -458,7 +456,7 @@ static __always_inline ssize_t __mcopy_a
 					      unsigned long dst_start,
 					      unsigned long src_start,
 					      unsigned long len,
-					      bool zeropage,
+					      enum mcopy_atomic_mode mcopy_mode,
 					      bool *mmap_changing,
 					      __u64 mode)
 {
@@ -469,6 +467,7 @@ static __always_inline ssize_t __mcopy_a
 	long copied;
 	struct page *page;
 	bool wp_copy;
+	bool zeropage = (mcopy_mode == MCOPY_ATOMIC_ZEROPAGE);
 
 	/*
 	 * Sanitize the command parameters:
@@ -527,10 +526,12 @@ retry:
 	 */
 	if (is_vm_hugetlb_page(dst_vma))
 		return  __mcopy_atomic_hugetlb(dst_mm, dst_vma, dst_start,
-						src_start, len, zeropage);
+						src_start, len, mcopy_mode);
 
 	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
 		goto out_unlock;
+	if (mcopy_mode == MCOPY_ATOMIC_CONTINUE)
+		goto out_unlock;
 
 	/*
 	 * Ensure the dst_vma has a anon_vma or this page
@@ -626,14 +627,22 @@ ssize_t mcopy_atomic(struct mm_struct *d
 		     unsigned long src_start, unsigned long len,
 		     bool *mmap_changing, __u64 mode)
 {
-	return __mcopy_atomic(dst_mm, dst_start, src_start, len, false,
-			      mmap_changing, mode);
+	return __mcopy_atomic(dst_mm, dst_start, src_start, len,
+			      MCOPY_ATOMIC_NORMAL, mmap_changing, mode);
 }
 
 ssize_t mfill_zeropage(struct mm_struct *dst_mm, unsigned long start,
 		       unsigned long len, bool *mmap_changing)
 {
-	return __mcopy_atomic(dst_mm, start, 0, len, true, mmap_changing, 0);
+	return __mcopy_atomic(dst_mm, start, 0, len, MCOPY_ATOMIC_ZEROPAGE,
+			      mmap_changing, 0);
+}
+
+ssize_t mcopy_continue(struct mm_struct *dst_mm, unsigned long start,
+		       unsigned long len, bool *mmap_changing)
+{
+	return __mcopy_atomic(dst_mm, start, 0, len, MCOPY_ATOMIC_CONTINUE,
+			      mmap_changing, 0);
 }
 
 int mwriteprotect_range(struct mm_struct *dst_mm, unsigned long start,
_
