Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA0FFC61DA4
	for <mm-commits@archiver.kernel.org>; Wed, 15 Mar 2023 20:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbjCOUKy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Mar 2023 16:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbjCOUKx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2023 16:10:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A813D91B68
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 13:10:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26B60B81F1B
        for <mm-commits@vger.kernel.org>; Wed, 15 Mar 2023 20:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC419C433EF;
        Wed, 15 Mar 2023 20:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678911047;
        bh=eKUBoyKr1d2mYiclNfzuQN2eG+vrkQOaJJFjfITeErY=;
        h=Date:To:From:Subject:From;
        b=2f8xRC/3QnW9nuWPbvYobQdBBnuu50LFL9iKc8KWHlGch1LhR5cTfbEyOY5ox6wFx
         7YxX2uzvVQ2gdru2KlVMfiLMb0QlnRnK91hLu1d4lC3knsKqolvacj+Eb4EZ2hfyB2
         4vEGkNnwVJ1WyuuLR0ULkrmiEqsIkSwp47+KKBeA=
Date:   Wed, 15 Mar 2023 13:10:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, shuah@kernel.org, rppt@kernel.org,
        peterx@redhat.com, namit@vmware.com, muchun.song@linux.dev,
        mike.kravetz@oracle.com, Liam.Howlett@oracle.com,
        jthoughton@google.com, jack@suse.cz, hughd@google.com,
        axelrasmussen@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-rename-functions-for-clarity-consistency.patch added to mm-unstable branch
Message-Id: <20230315201047.AC419C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: userfaultfd: rename functions for clarity + consistency
has been added to the -mm mm-unstable branch.  Its filename is
     mm-userfaultfd-rename-functions-for-clarity-consistency.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-rename-functions-for-clarity-consistency.patch

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
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: mm: userfaultfd: rename functions for clarity + consistency
Date: Tue, 14 Mar 2023 15:12:47 -0700

Patch series "mm: userfaultfd: refactor and add UFFDIO_CONTINUE_MODE_WP",
v5.

- Commits 1-3 refactor userfaultfd ioctl code without behavior changes, with the
  main goal of improving consistency and reducing the number of function args.

- Commit 4 adds UFFDIO_CONTINUE_MODE_WP.


This patch (of 4):

The basic problem is, over time we've added new userfaultfd ioctls, and
we've refactored the code so functions which used to handle only one case
are now re-used to deal with several cases.  While this happened, we
didn't bother to rename the functions.

Similarly, as we added new functions, we cargo-culted pieces of the
now-inconsistent naming scheme, so those functions too ended up with names
that don't make a lot of sense.

A key point here is, "copy" in most userfaultfd code refers specifically
to UFFDIO_COPY, where we allocate a new page and copy its contents from
userspace.  There are many functions with "copy" in the name that don't
actually do this (at least in some cases).

So, rename things into a consistent scheme.  The high level idea is that
the call stack for userfaultfd ioctls becomes:

userfaultfd_ioctl
  -> userfaultfd_(particular ioctl)
    -> mfill_atomic_(particular kind of fill operation)
      -> mfill_atomic    /* loops over pages in range */
        -> mfill_atomic_pte    /* deals with single pages */
          -> mfill_atomic_pte_(particular kind of fill operation)
            -> mfill_atomic_install_pte

There are of course some special cases (shmem, hugetlb), but this is the
general structure which all function names now adhere to.

Link: https://lkml.kernel.org/r/20230314221250.682452-1-axelrasmussen@google.com
Link: https://lkml.kernel.org/r/20230314221250.682452-2-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nadav Amit <namit@vmware.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c              |   18 ++---
 include/linux/hugetlb.h       |   30 ++++-----
 include/linux/userfaultfd_k.h |   18 ++---
 mm/hugetlb.c                  |   20 +++---
 mm/userfaultfd.c              |   98 ++++++++++++++++----------------
 5 files changed, 92 insertions(+), 92 deletions(-)

--- a/fs/userfaultfd.c~mm-userfaultfd-rename-functions-for-clarity-consistency
+++ a/fs/userfaultfd.c
@@ -1756,9 +1756,9 @@ static int userfaultfd_copy(struct userf
 	if (uffdio_copy.mode & ~(UFFDIO_COPY_MODE_DONTWAKE|UFFDIO_COPY_MODE_WP))
 		goto out;
 	if (mmget_not_zero(ctx->mm)) {
-		ret = mcopy_atomic(ctx->mm, uffdio_copy.dst, uffdio_copy.src,
-				   uffdio_copy.len, &ctx->mmap_changing,
-				   uffdio_copy.mode);
+		ret = mfill_atomic_copy(ctx->mm, uffdio_copy.dst, uffdio_copy.src,
+					uffdio_copy.len, &ctx->mmap_changing,
+					uffdio_copy.mode);
 		mmput(ctx->mm);
 	} else {
 		return -ESRCH;
@@ -1808,9 +1808,9 @@ static int userfaultfd_zeropage(struct u
 		goto out;
 
 	if (mmget_not_zero(ctx->mm)) {
-		ret = mfill_zeropage(ctx->mm, uffdio_zeropage.range.start,
-				     uffdio_zeropage.range.len,
-				     &ctx->mmap_changing);
+		ret = mfill_atomic_zeropage(ctx->mm, uffdio_zeropage.range.start,
+					   uffdio_zeropage.range.len,
+					   &ctx->mmap_changing);
 		mmput(ctx->mm);
 	} else {
 		return -ESRCH;
@@ -1918,9 +1918,9 @@ static int userfaultfd_continue(struct u
 		goto out;
 
 	if (mmget_not_zero(ctx->mm)) {
-		ret = mcopy_continue(ctx->mm, uffdio_continue.range.start,
-				     uffdio_continue.range.len,
-				     &ctx->mmap_changing);
+		ret = mfill_atomic_continue(ctx->mm, uffdio_continue.range.start,
+					    uffdio_continue.range.len,
+					    &ctx->mmap_changing);
 		mmput(ctx->mm);
 	} else {
 		return -ESRCH;
--- a/include/linux/hugetlb.h~mm-userfaultfd-rename-functions-for-clarity-consistency
+++ a/include/linux/hugetlb.h
@@ -158,13 +158,13 @@ unsigned long hugetlb_total_pages(void);
 vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, unsigned int flags);
 #ifdef CONFIG_USERFAULTFD
-int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm, pte_t *dst_pte,
-				struct vm_area_struct *dst_vma,
-				unsigned long dst_addr,
-				unsigned long src_addr,
-				enum mcopy_atomic_mode mode,
-				struct page **pagep,
-				bool wp_copy);
+int hugetlb_mfill_atomic_pte(struct mm_struct *dst_mm, pte_t *dst_pte,
+			     struct vm_area_struct *dst_vma,
+			     unsigned long dst_addr,
+			     unsigned long src_addr,
+			     enum mcopy_atomic_mode mode,
+			     struct page **pagep,
+			     bool wp_copy);
 #endif /* CONFIG_USERFAULTFD */
 bool hugetlb_reserve_pages(struct inode *inode, long from, long to,
 						struct vm_area_struct *vma,
@@ -393,14 +393,14 @@ static inline void hugetlb_free_pgd_rang
 }
 
 #ifdef CONFIG_USERFAULTFD
-static inline int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
-						pte_t *dst_pte,
-						struct vm_area_struct *dst_vma,
-						unsigned long dst_addr,
-						unsigned long src_addr,
-						enum mcopy_atomic_mode mode,
-						struct page **pagep,
-						bool wp_copy)
+static inline int hugetlb_mfill_atomic_pte(struct mm_struct *dst_mm,
+					   pte_t *dst_pte,
+					   struct vm_area_struct *dst_vma,
+					   unsigned long dst_addr,
+					   unsigned long src_addr,
+					   enum mcopy_atomic_mode mode,
+					   struct page **pagep,
+					   bool wp_copy)
 {
 	BUG();
 	return 0;
--- a/include/linux/userfaultfd_k.h~mm-userfaultfd-rename-functions-for-clarity-consistency
+++ a/include/linux/userfaultfd_k.h
@@ -61,15 +61,15 @@ extern int mfill_atomic_install_pte(stru
 				    unsigned long dst_addr, struct page *page,
 				    bool newly_allocated, bool wp_copy);
 
-extern ssize_t mcopy_atomic(struct mm_struct *dst_mm, unsigned long dst_start,
-			    unsigned long src_start, unsigned long len,
-			    atomic_t *mmap_changing, __u64 mode);
-extern ssize_t mfill_zeropage(struct mm_struct *dst_mm,
-			      unsigned long dst_start,
-			      unsigned long len,
-			      atomic_t *mmap_changing);
-extern ssize_t mcopy_continue(struct mm_struct *dst_mm, unsigned long dst_start,
-			      unsigned long len, atomic_t *mmap_changing);
+extern ssize_t mfill_atomic_copy(struct mm_struct *dst_mm, unsigned long dst_start,
+				 unsigned long src_start, unsigned long len,
+				 atomic_t *mmap_changing, __u64 mode);
+extern ssize_t mfill_atomic_zeropage(struct mm_struct *dst_mm,
+				     unsigned long dst_start,
+				     unsigned long len,
+				     atomic_t *mmap_changing);
+extern ssize_t mfill_atomic_continue(struct mm_struct *dst_mm, unsigned long dst_start,
+				     unsigned long len, atomic_t *mmap_changing);
 extern int mwriteprotect_range(struct mm_struct *dst_mm,
 			       unsigned long start, unsigned long len,
 			       bool enable_wp, atomic_t *mmap_changing);
--- a/mm/hugetlb.c~mm-userfaultfd-rename-functions-for-clarity-consistency
+++ a/mm/hugetlb.c
@@ -6156,17 +6156,17 @@ out_mutex:
 
 #ifdef CONFIG_USERFAULTFD
 /*
- * Used by userfaultfd UFFDIO_COPY.  Based on mcopy_atomic_pte with
- * modifications for huge pages.
+ * Used by userfaultfd UFFDIO_* ioctls. Based on userfaultfd's mfill_atomic_pte
+ * with modifications for hugetlb pages.
  */
-int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
-			    pte_t *dst_pte,
-			    struct vm_area_struct *dst_vma,
-			    unsigned long dst_addr,
-			    unsigned long src_addr,
-			    enum mcopy_atomic_mode mode,
-			    struct page **pagep,
-			    bool wp_copy)
+int hugetlb_mfill_atomic_pte(struct mm_struct *dst_mm,
+			     pte_t *dst_pte,
+			     struct vm_area_struct *dst_vma,
+			     unsigned long dst_addr,
+			     unsigned long src_addr,
+			     enum mcopy_atomic_mode mode,
+			     struct page **pagep,
+			     bool wp_copy)
 {
 	bool is_continue = (mode == MCOPY_ATOMIC_CONTINUE);
 	struct hstate *h = hstate_vma(dst_vma);
--- a/mm/userfaultfd.c~mm-userfaultfd-rename-functions-for-clarity-consistency
+++ a/mm/userfaultfd.c
@@ -127,13 +127,13 @@ out_unlock:
 	return ret;
 }
 
-static int mcopy_atomic_pte(struct mm_struct *dst_mm,
-			    pmd_t *dst_pmd,
-			    struct vm_area_struct *dst_vma,
-			    unsigned long dst_addr,
-			    unsigned long src_addr,
-			    struct page **pagep,
-			    bool wp_copy)
+static int mfill_atomic_pte_copy(struct mm_struct *dst_mm,
+				 pmd_t *dst_pmd,
+				 struct vm_area_struct *dst_vma,
+				 unsigned long dst_addr,
+				 unsigned long src_addr,
+				 struct page **pagep,
+				 bool wp_copy)
 {
 	void *page_kaddr;
 	int ret;
@@ -204,10 +204,10 @@ out_release:
 	goto out;
 }
 
-static int mfill_zeropage_pte(struct mm_struct *dst_mm,
-			      pmd_t *dst_pmd,
-			      struct vm_area_struct *dst_vma,
-			      unsigned long dst_addr)
+static int mfill_atomic_pte_zeropage(struct mm_struct *dst_mm,
+				     pmd_t *dst_pmd,
+				     struct vm_area_struct *dst_vma,
+				     unsigned long dst_addr)
 {
 	pte_t _dst_pte, *dst_pte;
 	spinlock_t *ptl;
@@ -240,11 +240,11 @@ out_unlock:
 }
 
 /* Handles UFFDIO_CONTINUE for all shmem VMAs (shared or private). */
-static int mcontinue_atomic_pte(struct mm_struct *dst_mm,
-				pmd_t *dst_pmd,
-				struct vm_area_struct *dst_vma,
-				unsigned long dst_addr,
-				bool wp_copy)
+static int mfill_atomic_pte_continue(struct mm_struct *dst_mm,
+				     pmd_t *dst_pmd,
+				     struct vm_area_struct *dst_vma,
+				     unsigned long dst_addr,
+				     bool wp_copy)
 {
 	struct inode *inode = file_inode(dst_vma->vm_file);
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
@@ -307,10 +307,10 @@ static pmd_t *mm_alloc_pmd(struct mm_str
 
 #ifdef CONFIG_HUGETLB_PAGE
 /*
- * __mcopy_atomic processing for HUGETLB vmas.  Note that this routine is
+ * mfill_atomic processing for HUGETLB vmas.  Note that this routine is
  * called with mmap_lock held, it will release mmap_lock before returning.
  */
-static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
+static __always_inline ssize_t mfill_atomic_hugetlb(struct mm_struct *dst_mm,
 					      struct vm_area_struct *dst_vma,
 					      unsigned long dst_start,
 					      unsigned long src_start,
@@ -411,7 +411,7 @@ retry:
 			goto out_unlock;
 		}
 
-		err = hugetlb_mcopy_atomic_pte(dst_mm, dst_pte, dst_vma,
+		err = hugetlb_mfill_atomic_pte(dst_mm, dst_pte, dst_vma,
 					       dst_addr, src_addr, mode, &page,
 					       wp_copy);
 
@@ -463,7 +463,7 @@ out:
 }
 #else /* !CONFIG_HUGETLB_PAGE */
 /* fail at build time if gcc attempts to use this */
-extern ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
+extern ssize_t mfill_atomic_hugetlb(struct mm_struct *dst_mm,
 				      struct vm_area_struct *dst_vma,
 				      unsigned long dst_start,
 				      unsigned long src_start,
@@ -484,8 +484,8 @@ static __always_inline ssize_t mfill_ato
 	ssize_t err;
 
 	if (mode == MCOPY_ATOMIC_CONTINUE) {
-		return mcontinue_atomic_pte(dst_mm, dst_pmd, dst_vma, dst_addr,
-					    wp_copy);
+		return mfill_atomic_pte_continue(dst_mm, dst_pmd, dst_vma,
+						 dst_addr, wp_copy);
 	}
 
 	/*
@@ -500,11 +500,11 @@ static __always_inline ssize_t mfill_ato
 	 */
 	if (!(dst_vma->vm_flags & VM_SHARED)) {
 		if (mode == MCOPY_ATOMIC_NORMAL)
-			err = mcopy_atomic_pte(dst_mm, dst_pmd, dst_vma,
-					       dst_addr, src_addr, page,
-					       wp_copy);
+			err = mfill_atomic_pte_copy(dst_mm, dst_pmd, dst_vma,
+						    dst_addr, src_addr, page,
+						    wp_copy);
 		else
-			err = mfill_zeropage_pte(dst_mm, dst_pmd,
+			err = mfill_atomic_pte_zeropage(dst_mm, dst_pmd,
 						 dst_vma, dst_addr);
 	} else {
 		err = shmem_mfill_atomic_pte(dst_mm, dst_pmd, dst_vma,
@@ -516,13 +516,13 @@ static __always_inline ssize_t mfill_ato
 	return err;
 }
 
-static __always_inline ssize_t __mcopy_atomic(struct mm_struct *dst_mm,
-					      unsigned long dst_start,
-					      unsigned long src_start,
-					      unsigned long len,
-					      enum mcopy_atomic_mode mcopy_mode,
-					      atomic_t *mmap_changing,
-					      __u64 mode)
+static __always_inline ssize_t mfill_atomic(struct mm_struct *dst_mm,
+					    unsigned long dst_start,
+					    unsigned long src_start,
+					    unsigned long len,
+					    enum mcopy_atomic_mode mcopy_mode,
+					    atomic_t *mmap_changing,
+					    __u64 mode)
 {
 	struct vm_area_struct *dst_vma;
 	ssize_t err;
@@ -588,9 +588,9 @@ retry:
 	 * If this is a HUGETLB vma, pass off to appropriate routine
 	 */
 	if (is_vm_hugetlb_page(dst_vma))
-		return  __mcopy_atomic_hugetlb(dst_mm, dst_vma, dst_start,
-					       src_start, len, mcopy_mode,
-					       wp_copy);
+		return  mfill_atomic_hugetlb(dst_mm, dst_vma, dst_start,
+					     src_start, len, mcopy_mode,
+					     wp_copy);
 
 	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
 		goto out_unlock;
@@ -688,26 +688,26 @@ out:
 	return copied ? copied : err;
 }
 
-ssize_t mcopy_atomic(struct mm_struct *dst_mm, unsigned long dst_start,
-		     unsigned long src_start, unsigned long len,
-		     atomic_t *mmap_changing, __u64 mode)
+ssize_t mfill_atomic_copy(struct mm_struct *dst_mm, unsigned long dst_start,
+			  unsigned long src_start, unsigned long len,
+			  atomic_t *mmap_changing, __u64 mode)
 {
-	return __mcopy_atomic(dst_mm, dst_start, src_start, len,
-			      MCOPY_ATOMIC_NORMAL, mmap_changing, mode);
+	return mfill_atomic(dst_mm, dst_start, src_start, len,
+			    MCOPY_ATOMIC_NORMAL, mmap_changing, mode);
 }
 
-ssize_t mfill_zeropage(struct mm_struct *dst_mm, unsigned long start,
-		       unsigned long len, atomic_t *mmap_changing)
+ssize_t mfill_atomic_zeropage(struct mm_struct *dst_mm, unsigned long start,
+			      unsigned long len, atomic_t *mmap_changing)
 {
-	return __mcopy_atomic(dst_mm, start, 0, len, MCOPY_ATOMIC_ZEROPAGE,
-			      mmap_changing, 0);
+	return mfill_atomic(dst_mm, start, 0, len, MCOPY_ATOMIC_ZEROPAGE,
+			    mmap_changing, 0);
 }
 
-ssize_t mcopy_continue(struct mm_struct *dst_mm, unsigned long start,
-		       unsigned long len, atomic_t *mmap_changing)
+ssize_t mfill_atomic_continue(struct mm_struct *dst_mm, unsigned long start,
+			      unsigned long len, atomic_t *mmap_changing)
 {
-	return __mcopy_atomic(dst_mm, start, 0, len, MCOPY_ATOMIC_CONTINUE,
-			      mmap_changing, 0);
+	return mfill_atomic(dst_mm, start, 0, len, MCOPY_ATOMIC_CONTINUE,
+			    mmap_changing, 0);
 }
 
 long uffd_wp_range(struct mm_struct *dst_mm, struct vm_area_struct *dst_vma,
_

Patches currently in -mm which might be from axelrasmussen@google.com are

mm-userfaultfd-rename-functions-for-clarity-consistency.patch
mm-userfaultfd-dont-pass-around-both-mm-and-vma.patch
mm-userfaultfd-combine-mode-and-wp_copy-arguments.patch
mm-userfaultfd-add-uffdio_continue_mode_wp-to-install-wp-ptes.patch

