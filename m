Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E414EE49AD
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbjHXXVs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237741AbjHXXVN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148ABA8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A77E064B19
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04370C433C7;
        Thu, 24 Aug 2023 23:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919270;
        bh=QDNMbgQ56rxiwiSS437w3RIS6q7fR3PO5y/0K6Mssyo=;
        h=Date:To:From:Subject:From;
        b=gBzKya7gIREnK74uKXZ8hXCpQDZq5hUEyK5u9T6P71s9zhyWMctVCKOpRw3uMHewb
         DWGq/8kxTOcCaFwzwn/HyeDTtxQKwsFlitfD2wyRiZLK+Ues7XhVxJ0wUvByX6fHSv
         70fv7sNn707Hsa7t3wVqD5Gg/CmviQVqsh+VOkKY=
Date:   Thu, 24 Aug 2023 16:21:09 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, viro@zeniv.linux.org.uk,
        vbabka@suse.cz, punit.agrawal@bytedance.com, peterx@redhat.com,
        pasha.tatashin@soleen.com, minchan@google.com,
        michel@lespinasse.org, mhocko@suse.com, lstoakes@gmail.com,
        Liam.Howlett@oracle.com, ldufour@linux.ibm.com,
        josef@toxicpanda.com, jack@suse.cz, hughd@google.com,
        hdanton@sina.com, hch@lst.de, hannes@cmpxchg.org,
        dhowells@redhat.com, david@redhat.com, dave@stgolabs.net,
        brauner@kernel.org, apopple@nvidia.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-handle-userfaults-under-vma-lock.patch removed from -mm tree
Message-Id: <20230824232110.04370C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: handle userfaults under VMA lock
has been removed from the -mm tree.  Its filename was
     mm-handle-userfaults-under-vma-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: handle userfaults under VMA lock
Date: Fri, 30 Jun 2023 14:19:57 -0700

Enable handle_userfault to operate under VMA lock by releasing VMA lock
instead of mmap_lock and retrying.  Note that FAULT_FLAG_RETRY_NOWAIT
should never be used when handling faults under per-VMA lock protection
because that would break the assumption that lock is dropped on retry.

[surenb@google.com: fix a lockdep issue in vma_assert_write_locked]
  Link: https://lkml.kernel.org/r/20230712195652.969194-1-surenb@google.com
Link: https://lkml.kernel.org/r/20230630211957.1341547-7-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Minchan Kim <minchan@google.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c   |   34 ++++++++++++++--------------------
 include/linux/mm.h |   20 ++++++++++++++++++++
 mm/memory.c        |    9 +--------
 3 files changed, 35 insertions(+), 28 deletions(-)

--- a/fs/userfaultfd.c~mm-handle-userfaults-under-vma-lock
+++ a/fs/userfaultfd.c
@@ -277,17 +277,16 @@ static inline struct uffd_msg userfault_
  * hugepmd ranges.
  */
 static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
-					 struct vm_area_struct *vma,
-					 unsigned long address,
-					 unsigned long flags,
-					 unsigned long reason)
+					      struct vm_fault *vmf,
+					      unsigned long reason)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	pte_t *ptep, pte;
 	bool ret = true;
 
-	mmap_assert_locked(ctx->mm);
+	assert_fault_locked(vmf);
 
-	ptep = hugetlb_walk(vma, address, vma_mmu_pagesize(vma));
+	ptep = hugetlb_walk(vma, vmf->address, vma_mmu_pagesize(vma));
 	if (!ptep)
 		goto out;
 
@@ -308,10 +307,8 @@ out:
 }
 #else
 static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
-					 struct vm_area_struct *vma,
-					 unsigned long address,
-					 unsigned long flags,
-					 unsigned long reason)
+					      struct vm_fault *vmf,
+					      unsigned long reason)
 {
 	return false;	/* should never get here */
 }
@@ -325,11 +322,11 @@ static inline bool userfaultfd_huge_must
  * threads.
  */
 static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
-					 unsigned long address,
-					 unsigned long flags,
+					 struct vm_fault *vmf,
 					 unsigned long reason)
 {
 	struct mm_struct *mm = ctx->mm;
+	unsigned long address = vmf->address;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
@@ -338,7 +335,7 @@ static inline bool userfaultfd_must_wait
 	pte_t ptent;
 	bool ret = true;
 
-	mmap_assert_locked(mm);
+	assert_fault_locked(vmf);
 
 	pgd = pgd_offset(mm, address);
 	if (!pgd_present(*pgd))
@@ -440,7 +437,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	 * Coredumping runs without mmap_lock so we can only check that
 	 * the mmap_lock is held, if PF_DUMPCORE was not set.
 	 */
-	mmap_assert_locked(mm);
+	assert_fault_locked(vmf);
 
 	ctx = vma->vm_userfaultfd_ctx.ctx;
 	if (!ctx)
@@ -556,15 +553,12 @@ vm_fault_t handle_userfault(struct vm_fa
 	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
 
 	if (!is_vm_hugetlb_page(vma))
-		must_wait = userfaultfd_must_wait(ctx, vmf->address, vmf->flags,
-						  reason);
+		must_wait = userfaultfd_must_wait(ctx, vmf, reason);
 	else
-		must_wait = userfaultfd_huge_must_wait(ctx, vma,
-						       vmf->address,
-						       vmf->flags, reason);
+		must_wait = userfaultfd_huge_must_wait(ctx, vmf, reason);
 	if (is_vm_hugetlb_page(vma))
 		hugetlb_vma_unlock_read(vma);
-	mmap_read_unlock(mm);
+	release_fault_lock(vmf);
 
 	if (likely(must_wait && !READ_ONCE(ctx->released))) {
 		wake_up_poll(&ctx->fd_wqh, EPOLLIN);
--- a/include/linux/mm.h~mm-handle-userfaults-under-vma-lock
+++ a/include/linux/mm.h
@@ -679,6 +679,7 @@ static inline void vma_end_read(struct v
 	rcu_read_unlock();
 }
 
+/* WARNING! Can only be used if mmap_lock is expected to be write-locked */
 static bool __is_vma_write_locked(struct vm_area_struct *vma, int *mm_lock_seq)
 {
 	mmap_assert_write_locked(vma->vm_mm);
@@ -721,6 +722,12 @@ static inline void vma_assert_write_lock
 	VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
 
+static inline void vma_assert_locked(struct vm_area_struct *vma)
+{
+	if (!rwsem_is_locked(&vma->vm_lock->lock))
+		vma_assert_write_locked(vma);
+}
+
 static inline void vma_mark_detached(struct vm_area_struct *vma, bool detached)
 {
 	/* When detaching vma should be write-locked */
@@ -737,6 +744,14 @@ static inline void release_fault_lock(st
 		mmap_read_unlock(vmf->vma->vm_mm);
 }
 
+static inline void assert_fault_locked(struct vm_fault *vmf)
+{
+	if (vmf->flags & FAULT_FLAG_VMA_LOCK)
+		vma_assert_locked(vmf->vma);
+	else
+		mmap_assert_locked(vmf->vma->vm_mm);
+}
+
 struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
 					  unsigned long address);
 
@@ -762,6 +777,11 @@ static inline void release_fault_lock(st
 	mmap_read_unlock(vmf->vma->vm_mm);
 }
 
+static inline void assert_fault_locked(struct vm_fault *vmf)
+{
+	mmap_assert_locked(vmf->vma->vm_mm);
+}
+
 #endif /* CONFIG_PER_VMA_LOCK */
 
 extern const struct vm_operations_struct vma_dummy_vm_ops;
--- a/mm/memory.c~mm-handle-userfaults-under-vma-lock
+++ a/mm/memory.c
@@ -5471,14 +5471,7 @@ retry:
 	 * concurrent mremap() with MREMAP_DONTUNMAP could dissociate the VMA
 	 * from its anon_vma.
 	 */
-	if (vma_is_anonymous(vma) && !vma->anon_vma)
-		goto inval_end_read;
-
-	/*
-	 * Due to the possibility of userfault handler dropping mmap_lock, avoid
-	 * it for now and fall back to page fault handling under mmap_lock.
-	 */
-	if (userfaultfd_armed(vma))
+	if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma))
 		goto inval_end_read;
 
 	/* Check since vm_start/vm_end might change before we lock the VMA */
_

Patches currently in -mm which might be from surenb@google.com are


