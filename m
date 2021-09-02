Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43B6C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B72316056B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347968AbhIBV75 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:59:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347550AbhIBV74 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:59:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E76B1603E9;
        Thu,  2 Sep 2021 21:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619937;
        bh=4jLN/T6sdmKKFYCacElav7X0jk6q5cp/hYXH2HmJhqg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Tl9pJnuH+Ocs6oUfIgVQYUGu9q+/HqiGpr25YjeiXKyk7WmprOV3m9TS7LRtAey7n
         iugmWo5o2Ffn7xtF8Kjqg/va+0ykvzmMtCIuoXtdr425xZFOYO93YpCX02DW+kkQHr
         2aAppiJ+QCLBQ0cNr9dijBiPge7Fhhsrh+ITt11k=
Date:   Thu, 02 Sep 2021 14:58:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, axboe@kernel.dk,
        axelrasmussen@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, namit@vmware.com, peterx@redhat.com,
        rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 170/212] userfaultfd: change mmap_changing to
 atomic
Message-ID: <20210902215856.yqhFha5Cz%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nadav Amit <namit@vmware.com>
Subject: userfaultfd: change mmap_changing to atomic

Patch series "userfaultfd: minor bug fixes".

Three unrelated bug fixes. The first two addresses possible issues (not
too theoretical ones), but I did not encounter them in practice.

The third patch addresses a test bug that causes the test to fail on my
system. It has been sent before as part of a bigger RFC. 


This patch (of 3):

mmap_changing is currently a boolean variable, which is set and cleared
without any lock that protects against concurrent modifications.

mmap_changing is supposed to mark whether userfaultfd page-faults handling
should be retried since mappings are undergoing a change.  However,
concurrent calls, for instance to madvise(MADV_DONTNEED), might cause
mmap_changing to be false, although the remove event was still not read
(hence acknowledged) by the user.

Change mmap_changing to atomic_t and increase/decrease appropriately.  Add
a debug assertion to see whether mmap_changing is negative.

Link: https://lkml.kernel.org/r/20210808020724.1022515-1-namit@vmware.com
Link: https://lkml.kernel.org/r/20210808020724.1022515-2-namit@vmware.com
Fixes: df2cc96e77011 ("userfaultfd: prevent non-cooperative events vs mcopy_atomic races")
Signed-off-by: Nadav Amit <namit@vmware.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c              |   25 +++++++++++++------------
 include/linux/userfaultfd_k.h |    8 ++++----
 mm/userfaultfd.c              |   15 ++++++++-------
 3 files changed, 25 insertions(+), 23 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-change-mmap_changing-to-atomic
+++ a/fs/userfaultfd.c
@@ -74,7 +74,7 @@ struct userfaultfd_ctx {
 	/* released */
 	bool released;
 	/* memory mappings are changing because of non-cooperative event */
-	bool mmap_changing;
+	atomic_t mmap_changing;
 	/* mm with one ore more vmas attached to this userfaultfd_ctx */
 	struct mm_struct *mm;
 };
@@ -623,7 +623,8 @@ static void userfaultfd_event_wait_compl
 	 * already released.
 	 */
 out:
-	WRITE_ONCE(ctx->mmap_changing, false);
+	atomic_dec(&ctx->mmap_changing);
+	VM_BUG_ON(atomic_read(&ctx->mmap_changing) < 0);
 	userfaultfd_ctx_put(ctx);
 }
 
@@ -669,12 +670,12 @@ int dup_userfaultfd(struct vm_area_struc
 		ctx->state = UFFD_STATE_RUNNING;
 		ctx->features = octx->features;
 		ctx->released = false;
-		ctx->mmap_changing = false;
+		atomic_set(&ctx->mmap_changing, 0);
 		ctx->mm = vma->vm_mm;
 		mmgrab(ctx->mm);
 
 		userfaultfd_ctx_get(octx);
-		WRITE_ONCE(octx->mmap_changing, true);
+		atomic_inc(&octx->mmap_changing);
 		fctx->orig = octx;
 		fctx->new = ctx;
 		list_add_tail(&fctx->list, fcs);
@@ -721,7 +722,7 @@ void mremap_userfaultfd_prep(struct vm_a
 	if (ctx->features & UFFD_FEATURE_EVENT_REMAP) {
 		vm_ctx->ctx = ctx;
 		userfaultfd_ctx_get(ctx);
-		WRITE_ONCE(ctx->mmap_changing, true);
+		atomic_inc(&ctx->mmap_changing);
 	} else {
 		/* Drop uffd context if remap feature not enabled */
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
@@ -766,7 +767,7 @@ bool userfaultfd_remove(struct vm_area_s
 		return true;
 
 	userfaultfd_ctx_get(ctx);
-	WRITE_ONCE(ctx->mmap_changing, true);
+	atomic_inc(&ctx->mmap_changing);
 	mmap_read_unlock(mm);
 
 	msg_init(&ewq.msg);
@@ -810,7 +811,7 @@ int userfaultfd_unmap_prep(struct vm_are
 			return -ENOMEM;
 
 		userfaultfd_ctx_get(ctx);
-		WRITE_ONCE(ctx->mmap_changing, true);
+		atomic_inc(&ctx->mmap_changing);
 		unmap_ctx->ctx = ctx;
 		unmap_ctx->start = start;
 		unmap_ctx->end = end;
@@ -1700,7 +1701,7 @@ static int userfaultfd_copy(struct userf
 	user_uffdio_copy = (struct uffdio_copy __user *) arg;
 
 	ret = -EAGAIN;
-	if (READ_ONCE(ctx->mmap_changing))
+	if (atomic_read(&ctx->mmap_changing))
 		goto out;
 
 	ret = -EFAULT;
@@ -1757,7 +1758,7 @@ static int userfaultfd_zeropage(struct u
 	user_uffdio_zeropage = (struct uffdio_zeropage __user *) arg;
 
 	ret = -EAGAIN;
-	if (READ_ONCE(ctx->mmap_changing))
+	if (atomic_read(&ctx->mmap_changing))
 		goto out;
 
 	ret = -EFAULT;
@@ -1807,7 +1808,7 @@ static int userfaultfd_writeprotect(stru
 	struct userfaultfd_wake_range range;
 	bool mode_wp, mode_dontwake;
 
-	if (READ_ONCE(ctx->mmap_changing))
+	if (atomic_read(&ctx->mmap_changing))
 		return -EAGAIN;
 
 	user_uffdio_wp = (struct uffdio_writeprotect __user *) arg;
@@ -1855,7 +1856,7 @@ static int userfaultfd_continue(struct u
 	user_uffdio_continue = (struct uffdio_continue __user *)arg;
 
 	ret = -EAGAIN;
-	if (READ_ONCE(ctx->mmap_changing))
+	if (atomic_read(&ctx->mmap_changing))
 		goto out;
 
 	ret = -EFAULT;
@@ -2087,7 +2088,7 @@ SYSCALL_DEFINE1(userfaultfd, int, flags)
 	ctx->features = 0;
 	ctx->state = UFFD_STATE_WAIT_API;
 	ctx->released = false;
-	ctx->mmap_changing = false;
+	atomic_set(&ctx->mmap_changing, 0);
 	ctx->mm = current->mm;
 	/* prevent the mm struct to be freed */
 	mmgrab(ctx->mm);
--- a/include/linux/userfaultfd_k.h~userfaultfd-change-mmap_changing-to-atomic
+++ a/include/linux/userfaultfd_k.h
@@ -60,16 +60,16 @@ extern int mfill_atomic_install_pte(stru
 
 extern ssize_t mcopy_atomic(struct mm_struct *dst_mm, unsigned long dst_start,
 			    unsigned long src_start, unsigned long len,
-			    bool *mmap_changing, __u64 mode);
+			    atomic_t *mmap_changing, __u64 mode);
 extern ssize_t mfill_zeropage(struct mm_struct *dst_mm,
 			      unsigned long dst_start,
 			      unsigned long len,
-			      bool *mmap_changing);
+			      atomic_t *mmap_changing);
 extern ssize_t mcopy_continue(struct mm_struct *dst_mm, unsigned long dst_start,
-			      unsigned long len, bool *mmap_changing);
+			      unsigned long len, atomic_t *mmap_changing);
 extern int mwriteprotect_range(struct mm_struct *dst_mm,
 			       unsigned long start, unsigned long len,
-			       bool enable_wp, bool *mmap_changing);
+			       bool enable_wp, atomic_t *mmap_changing);
 
 /* mm helpers */
 static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
--- a/mm/userfaultfd.c~userfaultfd-change-mmap_changing-to-atomic
+++ a/mm/userfaultfd.c
@@ -483,7 +483,7 @@ static __always_inline ssize_t __mcopy_a
 					      unsigned long src_start,
 					      unsigned long len,
 					      enum mcopy_atomic_mode mcopy_mode,
-					      bool *mmap_changing,
+					      atomic_t *mmap_changing,
 					      __u64 mode)
 {
 	struct vm_area_struct *dst_vma;
@@ -517,7 +517,7 @@ retry:
 	 * request the user to retry later
 	 */
 	err = -EAGAIN;
-	if (mmap_changing && READ_ONCE(*mmap_changing))
+	if (mmap_changing && atomic_read(mmap_changing))
 		goto out_unlock;
 
 	/*
@@ -650,28 +650,29 @@ out:
 
 ssize_t mcopy_atomic(struct mm_struct *dst_mm, unsigned long dst_start,
 		     unsigned long src_start, unsigned long len,
-		     bool *mmap_changing, __u64 mode)
+		     atomic_t *mmap_changing, __u64 mode)
 {
 	return __mcopy_atomic(dst_mm, dst_start, src_start, len,
 			      MCOPY_ATOMIC_NORMAL, mmap_changing, mode);
 }
 
 ssize_t mfill_zeropage(struct mm_struct *dst_mm, unsigned long start,
-		       unsigned long len, bool *mmap_changing)
+		       unsigned long len, atomic_t *mmap_changing)
 {
 	return __mcopy_atomic(dst_mm, start, 0, len, MCOPY_ATOMIC_ZEROPAGE,
 			      mmap_changing, 0);
 }
 
 ssize_t mcopy_continue(struct mm_struct *dst_mm, unsigned long start,
-		       unsigned long len, bool *mmap_changing)
+		       unsigned long len, atomic_t *mmap_changing)
 {
 	return __mcopy_atomic(dst_mm, start, 0, len, MCOPY_ATOMIC_CONTINUE,
 			      mmap_changing, 0);
 }
 
 int mwriteprotect_range(struct mm_struct *dst_mm, unsigned long start,
-			unsigned long len, bool enable_wp, bool *mmap_changing)
+			unsigned long len, bool enable_wp,
+			atomic_t *mmap_changing)
 {
 	struct vm_area_struct *dst_vma;
 	pgprot_t newprot;
@@ -694,7 +695,7 @@ int mwriteprotect_range(struct mm_struct
 	 * request the user to retry later
 	 */
 	err = -EAGAIN;
-	if (mmap_changing && READ_ONCE(*mmap_changing))
+	if (mmap_changing && atomic_read(mmap_changing))
 		goto out_unlock;
 
 	err = -ENOENT;
_
