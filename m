Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0060BC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Dec 2021 00:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242750AbhLHAPQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Dec 2021 19:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbhLHAPO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2021 19:15:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166FCC061574
        for <mm-commits@vger.kernel.org>; Tue,  7 Dec 2021 16:11:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2899ECE1E73
        for <mm-commits@vger.kernel.org>; Wed,  8 Dec 2021 00:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E11C341C3;
        Wed,  8 Dec 2021 00:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638922299;
        bh=HMjlc57UQbSOEqDDbMqXux7r2K/52Px5PkMBfpOP45A=;
        h=Date:From:To:Subject:From;
        b=tW2cvb/dymqATOb7+2+8UI18blmCv2TRbwp2JcLWuQHsVMqKAKjzL5GwOh3dpRIf7
         A69LXG6gelKqxRb1YTUX+yHSpzXFm1T42eQiMZdH4MBo+zXU39bTTIjvuOgHDewgNW
         HcWot+Yufq1mInkICKN7NWX6PQdTv0xSNvchvz2s=
Date:   Tue, 07 Dec 2021 16:11:38 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, ccross@google.com, ebiederm@xmission.com,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        peterx@redhat.com, peterz@infradead.org, sfr@canb.auug.org.au,
        surenb@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk,
        willy@infradead.org, yuzhao@google.com
Subject:  +
 mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh.patch added to -mm
 tree
Message-ID: <20211208001138.pZrzcRX8_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move tlb_flush_pending inline helpers to mm_inline.h
has been added to the -mm tree.  Its filename is
     mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: move tlb_flush_pending inline helpers to mm_inline.h

linux/mm_types.h should only define structure definitions, to make it
cheap to include elsewhere.  The atomic_t helper function definitions are
particularly large, so it's better to move the helpers using those into
the existing linux/mm_inline.h and only include that where needed.

As a follow-up, we may want to go through all the indirect includes in
mm_types.h and reduce them as much as possible.

Link: https://lkml.kernel.org/r/20211207125710.2503446-2-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Colin Cross <ccross@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    2 
 include/linux/mm.h             |   45 ----------
 include/linux/mm_inline.h      |   86 ++++++++++++++++++++
 include/linux/mm_types.h       |  129 ++++++++++---------------------
 mm/ksm.c                       |    1 
 mm/mapping_dirty_helpers.c     |    1 
 mm/memory.c                    |    1 
 mm/mmu_gather.c                |    1 
 mm/pgtable-generic.c           |    1 
 9 files changed, 137 insertions(+), 130 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh
+++ a/arch/x86/include/asm/pgtable.h
@@ -752,7 +752,7 @@ static inline bool pte_accessible(struct
 		return true;
 
 	if ((pte_flags(a) & _PAGE_PROTNONE) &&
-			mm_tlb_flush_pending(mm))
+			atomic_read(&mm->tlb_flush_pending))
 		return true;
 
 	return false;
--- a/include/linux/mm.h~mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh
+++ a/include/linux/mm.h
@@ -424,51 +424,6 @@ extern unsigned int kobjsize(const void
  */
 extern pgprot_t protection_map[16];
 
-/**
- * enum fault_flag - Fault flag definitions.
- * @FAULT_FLAG_WRITE: Fault was a write fault.
- * @FAULT_FLAG_MKWRITE: Fault was mkwrite of existing PTE.
- * @FAULT_FLAG_ALLOW_RETRY: Allow to retry the fault if blocked.
- * @FAULT_FLAG_RETRY_NOWAIT: Don't drop mmap_lock and wait when retrying.
- * @FAULT_FLAG_KILLABLE: The fault task is in SIGKILL killable region.
- * @FAULT_FLAG_TRIED: The fault has been tried once.
- * @FAULT_FLAG_USER: The fault originated in userspace.
- * @FAULT_FLAG_REMOTE: The fault is not for current task/mm.
- * @FAULT_FLAG_INSTRUCTION: The fault was during an instruction fetch.
- * @FAULT_FLAG_INTERRUPTIBLE: The fault can be interrupted by non-fatal signals.
- *
- * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
- * whether we would allow page faults to retry by specifying these two
- * fault flags correctly.  Currently there can be three legal combinations:
- *
- * (a) ALLOW_RETRY and !TRIED:  this means the page fault allows retry, and
- *                              this is the first try
- *
- * (b) ALLOW_RETRY and TRIED:   this means the page fault allows retry, and
- *                              we've already tried at least once
- *
- * (c) !ALLOW_RETRY and !TRIED: this means the page fault does not allow retry
- *
- * The unlisted combination (!ALLOW_RETRY && TRIED) is illegal and should never
- * be used.  Note that page faults can be allowed to retry for multiple times,
- * in which case we'll have an initial fault with flags (a) then later on
- * continuous faults with flags (b).  We should always try to detect pending
- * signals before a retry to make sure the continuous page faults can still be
- * interrupted if necessary.
- */
-enum fault_flag {
-	FAULT_FLAG_WRITE =		1 << 0,
-	FAULT_FLAG_MKWRITE =		1 << 1,
-	FAULT_FLAG_ALLOW_RETRY =	1 << 2,
-	FAULT_FLAG_RETRY_NOWAIT = 	1 << 3,
-	FAULT_FLAG_KILLABLE =		1 << 4,
-	FAULT_FLAG_TRIED = 		1 << 5,
-	FAULT_FLAG_USER =		1 << 6,
-	FAULT_FLAG_REMOTE =		1 << 7,
-	FAULT_FLAG_INSTRUCTION =	1 << 8,
-	FAULT_FLAG_INTERRUPTIBLE =	1 << 9,
-};
-
 /*
  * The default fault flags that should be used by most of the
  * arch-specific page fault handlers.
--- a/include/linux/mm_inline.h~mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh
+++ a/include/linux/mm_inline.h
@@ -2,6 +2,7 @@
 #ifndef LINUX_MM_INLINE_H
 #define LINUX_MM_INLINE_H
 
+#include <linux/atomic.h>
 #include <linux/huge_mm.h>
 #include <linux/swap.h>
 #include <linux/string.h>
@@ -185,4 +186,89 @@ static inline bool is_same_vma_anon_name
 }
 #endif  /* CONFIG_ANON_VMA_NAME */
 
+static inline void init_tlb_flush_pending(struct mm_struct *mm)
+{
+	atomic_set(&mm->tlb_flush_pending, 0);
+}
+
+static inline void inc_tlb_flush_pending(struct mm_struct *mm)
+{
+	atomic_inc(&mm->tlb_flush_pending);
+	/*
+	 * The only time this value is relevant is when there are indeed pages
+	 * to flush. And we'll only flush pages after changing them, which
+	 * requires the PTL.
+	 *
+	 * So the ordering here is:
+	 *
+	 *	atomic_inc(&mm->tlb_flush_pending);
+	 *	spin_lock(&ptl);
+	 *	...
+	 *	set_pte_at();
+	 *	spin_unlock(&ptl);
+	 *
+	 *				spin_lock(&ptl)
+	 *				mm_tlb_flush_pending();
+	 *				....
+	 *				spin_unlock(&ptl);
+	 *
+	 *	flush_tlb_range();
+	 *	atomic_dec(&mm->tlb_flush_pending);
+	 *
+	 * Where the increment if constrained by the PTL unlock, it thus
+	 * ensures that the increment is visible if the PTE modification is
+	 * visible. After all, if there is no PTE modification, nobody cares
+	 * about TLB flushes either.
+	 *
+	 * This very much relies on users (mm_tlb_flush_pending() and
+	 * mm_tlb_flush_nested()) only caring about _specific_ PTEs (and
+	 * therefore specific PTLs), because with SPLIT_PTE_PTLOCKS and RCpc
+	 * locks (PPC) the unlock of one doesn't order against the lock of
+	 * another PTL.
+	 *
+	 * The decrement is ordered by the flush_tlb_range(), such that
+	 * mm_tlb_flush_pending() will not return false unless all flushes have
+	 * completed.
+	 */
+}
+
+static inline void dec_tlb_flush_pending(struct mm_struct *mm)
+{
+	/*
+	 * See inc_tlb_flush_pending().
+	 *
+	 * This cannot be smp_mb__before_atomic() because smp_mb() simply does
+	 * not order against TLB invalidate completion, which is what we need.
+	 *
+	 * Therefore we must rely on tlb_flush_*() to guarantee order.
+	 */
+	atomic_dec(&mm->tlb_flush_pending);
+}
+
+static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
+{
+	/*
+	 * Must be called after having acquired the PTL; orders against that
+	 * PTLs release and therefore ensures that if we observe the modified
+	 * PTE we must also observe the increment from inc_tlb_flush_pending().
+	 *
+	 * That is, it only guarantees to return true if there is a flush
+	 * pending for _this_ PTL.
+	 */
+	return atomic_read(&mm->tlb_flush_pending);
+}
+
+static inline bool mm_tlb_flush_nested(struct mm_struct *mm)
+{
+	/*
+	 * Similar to mm_tlb_flush_pending(), we must have acquired the PTL
+	 * for which there is a TLB flush pending in order to guarantee
+	 * we've seen both that PTE modification and the increment.
+	 *
+	 * (no requirement on actually still holding the PTL, that is irrelevant)
+	 */
+	return atomic_read(&mm->tlb_flush_pending) > 1;
+}
+
+
 #endif
--- a/include/linux/mm_types.h~mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh
+++ a/include/linux/mm_types.h
@@ -692,90 +692,6 @@ extern void tlb_gather_mmu(struct mmu_ga
 extern void tlb_gather_mmu_fullmm(struct mmu_gather *tlb, struct mm_struct *mm);
 extern void tlb_finish_mmu(struct mmu_gather *tlb);
 
-static inline void init_tlb_flush_pending(struct mm_struct *mm)
-{
-	atomic_set(&mm->tlb_flush_pending, 0);
-}
-
-static inline void inc_tlb_flush_pending(struct mm_struct *mm)
-{
-	atomic_inc(&mm->tlb_flush_pending);
-	/*
-	 * The only time this value is relevant is when there are indeed pages
-	 * to flush. And we'll only flush pages after changing them, which
-	 * requires the PTL.
-	 *
-	 * So the ordering here is:
-	 *
-	 *	atomic_inc(&mm->tlb_flush_pending);
-	 *	spin_lock(&ptl);
-	 *	...
-	 *	set_pte_at();
-	 *	spin_unlock(&ptl);
-	 *
-	 *				spin_lock(&ptl)
-	 *				mm_tlb_flush_pending();
-	 *				....
-	 *				spin_unlock(&ptl);
-	 *
-	 *	flush_tlb_range();
-	 *	atomic_dec(&mm->tlb_flush_pending);
-	 *
-	 * Where the increment if constrained by the PTL unlock, it thus
-	 * ensures that the increment is visible if the PTE modification is
-	 * visible. After all, if there is no PTE modification, nobody cares
-	 * about TLB flushes either.
-	 *
-	 * This very much relies on users (mm_tlb_flush_pending() and
-	 * mm_tlb_flush_nested()) only caring about _specific_ PTEs (and
-	 * therefore specific PTLs), because with SPLIT_PTE_PTLOCKS and RCpc
-	 * locks (PPC) the unlock of one doesn't order against the lock of
-	 * another PTL.
-	 *
-	 * The decrement is ordered by the flush_tlb_range(), such that
-	 * mm_tlb_flush_pending() will not return false unless all flushes have
-	 * completed.
-	 */
-}
-
-static inline void dec_tlb_flush_pending(struct mm_struct *mm)
-{
-	/*
-	 * See inc_tlb_flush_pending().
-	 *
-	 * This cannot be smp_mb__before_atomic() because smp_mb() simply does
-	 * not order against TLB invalidate completion, which is what we need.
-	 *
-	 * Therefore we must rely on tlb_flush_*() to guarantee order.
-	 */
-	atomic_dec(&mm->tlb_flush_pending);
-}
-
-static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
-{
-	/*
-	 * Must be called after having acquired the PTL; orders against that
-	 * PTLs release and therefore ensures that if we observe the modified
-	 * PTE we must also observe the increment from inc_tlb_flush_pending().
-	 *
-	 * That is, it only guarantees to return true if there is a flush
-	 * pending for _this_ PTL.
-	 */
-	return atomic_read(&mm->tlb_flush_pending);
-}
-
-static inline bool mm_tlb_flush_nested(struct mm_struct *mm)
-{
-	/*
-	 * Similar to mm_tlb_flush_pending(), we must have acquired the PTL
-	 * for which there is a TLB flush pending in order to guarantee
-	 * we've seen both that PTE modification and the increment.
-	 *
-	 * (no requirement on actually still holding the PTL, that is irrelevant)
-	 */
-	return atomic_read(&mm->tlb_flush_pending) > 1;
-}
-
 struct vm_fault;
 
 /**
@@ -890,4 +806,49 @@ typedef struct {
 	unsigned long val;
 } swp_entry_t;
 
+/**
+ * enum fault_flag - Fault flag definitions.
+ * @FAULT_FLAG_WRITE: Fault was a write fault.
+ * @FAULT_FLAG_MKWRITE: Fault was mkwrite of existing PTE.
+ * @FAULT_FLAG_ALLOW_RETRY: Allow to retry the fault if blocked.
+ * @FAULT_FLAG_RETRY_NOWAIT: Don't drop mmap_lock and wait when retrying.
+ * @FAULT_FLAG_KILLABLE: The fault task is in SIGKILL killable region.
+ * @FAULT_FLAG_TRIED: The fault has been tried once.
+ * @FAULT_FLAG_USER: The fault originated in userspace.
+ * @FAULT_FLAG_REMOTE: The fault is not for current task/mm.
+ * @FAULT_FLAG_INSTRUCTION: The fault was during an instruction fetch.
+ * @FAULT_FLAG_INTERRUPTIBLE: The fault can be interrupted by non-fatal signals.
+ *
+ * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
+ * whether we would allow page faults to retry by specifying these two
+ * fault flags correctly.  Currently there can be three legal combinations:
+ *
+ * (a) ALLOW_RETRY and !TRIED:  this means the page fault allows retry, and
+ *                              this is the first try
+ *
+ * (b) ALLOW_RETRY and TRIED:   this means the page fault allows retry, and
+ *                              we've already tried at least once
+ *
+ * (c) !ALLOW_RETRY and !TRIED: this means the page fault does not allow retry
+ *
+ * The unlisted combination (!ALLOW_RETRY && TRIED) is illegal and should never
+ * be used.  Note that page faults can be allowed to retry for multiple times,
+ * in which case we'll have an initial fault with flags (a) then later on
+ * continuous faults with flags (b).  We should always try to detect pending
+ * signals before a retry to make sure the continuous page faults can still be
+ * interrupted if necessary.
+ */
+enum fault_flag {
+	FAULT_FLAG_WRITE =		1 << 0,
+	FAULT_FLAG_MKWRITE =		1 << 1,
+	FAULT_FLAG_ALLOW_RETRY =	1 << 2,
+	FAULT_FLAG_RETRY_NOWAIT = 	1 << 3,
+	FAULT_FLAG_KILLABLE =		1 << 4,
+	FAULT_FLAG_TRIED = 		1 << 5,
+	FAULT_FLAG_USER =		1 << 6,
+	FAULT_FLAG_REMOTE =		1 << 7,
+	FAULT_FLAG_INSTRUCTION =	1 << 8,
+	FAULT_FLAG_INTERRUPTIBLE =	1 << 9,
+};
+
 #endif /* _LINUX_MM_TYPES_H */
--- a/mm/ksm.c~mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh
+++ a/mm/ksm.c
@@ -15,6 +15,7 @@
 
 #include <linux/errno.h>
 #include <linux/mm.h>
+#include <linux/mm_inline.h>
 #include <linux/fs.h>
 #include <linux/mman.h>
 #include <linux/sched.h>
--- a/mm/mapping_dirty_helpers.c~mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh
+++ a/mm/mapping_dirty_helpers.c
@@ -3,6 +3,7 @@
 #include <linux/hugetlb.h>
 #include <linux/bitops.h>
 #include <linux/mmu_notifier.h>
+#include <linux/mm_inline.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
--- a/mm/memory.c~mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh
+++ a/mm/memory.c
@@ -41,6 +41,7 @@
 
 #include <linux/kernel_stat.h>
 #include <linux/mm.h>
+#include <linux/mm_inline.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/coredump.h>
 #include <linux/sched/numa_balancing.h>
--- a/mm/mmu_gather.c~mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh
+++ a/mm/mmu_gather.c
@@ -3,6 +3,7 @@
 #include <linux/kernel.h>
 #include <linux/mmdebug.h>
 #include <linux/mm_types.h>
+#include <linux/mm_inline.h>
 #include <linux/pagemap.h>
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
--- a/mm/pgtable-generic.c~mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh
+++ a/mm/pgtable-generic.c
@@ -10,6 +10,7 @@
 #include <linux/pagemap.h>
 #include <linux/hugetlb.h>
 #include <linux/pgtable.h>
+#include <linux/mm_inline.h>
 #include <asm/tlb.h>
 
 /*
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-move-anon_vma-declarations-to-linux-mm_inlineh.patch
mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh.patch
fs-move-inode-sysctls-to-its-own-file-fix.patch
fs-move-dcache-sysctls-to-its-own-file-fix-2.patch

