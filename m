From: akpm@linux-foundation.org
Subject: + mm-fix-madv_-tlb-flush-miss-problem.patch added to -mm tree
Date: Wed, 02 Aug 2017 16:34:13 -0700
Message-ID: <59826175.vb4Kx3Nivq9NqsM3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59944 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751761AbdHBXeO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 19:34:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aarcange@redhat.com, davem@davemloft.net, heiko.carstens@de.ibm.com, hughd@google.com, jdike@addtoit.com, linux@armlinux.org.uk, luto@kernel.org, mgorman@suse.de, mgorman@techsingularity.net, mingo@redhat.com, nadav.amit@gmail.com, namit@vmware.com, riel@redhat.com, schwidefsky@de.ibm.com, sergey.senozhatsky@gmail.com, tony.luck@intel.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix MADV_[FREE|DONTNEED] TLB flush miss problem
has been added to the -mm tree.  Its filename is
     mm-fix-madv_-tlb-flush-miss-problem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-madv_-tlb-flush-miss-problem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-madv_-tlb-flush-miss-problem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix MADV_[FREE|DONTNEED] TLB flush miss problem

Nadav reported parallel MADV_DONTNEED on same range has a stale TLB
problem and Mel fixed it[1] and found same problem on MADV_FREE[2].

Quote from Mel Gorman

"The race in question is CPU 0 running madv_free and updating some PTEs
while CPU 1 is also running madv_free and looking at the same PTEs.  CPU 1
may have writable TLB entries for a page but fail the pte_dirty check
(because CPU 0 has updated it already) and potentially fail to flush. 
Hence, when madv_free on CPU 1 returns, there are still potentially
writable TLB entries and the underlying PTE is still present so that a
subsequent write does not necessarily propagate the dirty bit to the
underlying PTE any more.  Reclaim at some unknown time at the future may
then see that the PTE is still clean and discard the page even though a
write has happened in the meantime.  I think this is possible but I could
have missed some protection in madv_free that prevents it happening."

This patch aims for solving both problems all at once and is ready for
other problem with KSM, MADV_FREE and soft-dirty story[3].

TLB batch API(tlb_[gather|finish]_mmu] uses [inc|dec]_tlb_flush_pending
and mmu_tlb_flush_pending so that when tlb_finish_mmu is called, we can
catch there are parallel threads going on.  In that case, forcefully,
flush TLB to prevent for user to access memory via stale TLB entry
although it fail to gather page table entry.

I confirmed this patch works with [4] test program Nadav gave so this
patch supersedes "mm: Always flush VMA ranges affected by zap_page_range
v2" in current mmotm.

NOTE:

This patch modifies arch-specific TLB gathering interface(x86, ia64, s390,
sh, um).  It seems most of architecture are straightforward but s390 need
to be careful because tlb_flush_mmu works only if mm->context.flush_mm is
set to non-zero which happens only a pte entry really is cleared by
ptep_get_and_clear and friends.  However, this problem never changes the
pte entries but need to flush to prevent memory access from stale tlb.

[1] http://lkml.kernel.org/r/20170725101230.5v7gvnjmcnkzzql3@techsingularity.net
[2] http://lkml.kernel.org/r/20170725100722.2dxnmgypmwnrfawp@suse.de
[3] http://lkml.kernel.org/r/BD3A0EBE-ECF4-41D4-87FA-C755EA9AB6BD@gmail.com
[4] https://patchwork.kernel.org/patch/9861621/

Link: http://lkml.kernel.org/r/20170802000818.4760-7-namit@vmware.com
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Reported-by: Nadav Amit <namit@vmware.com>
Reported-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/tlb.h  |    7 ++++++-
 arch/ia64/include/asm/tlb.h |    4 +++-
 arch/s390/include/asm/tlb.h |    7 ++++++-
 arch/sh/include/asm/tlb.h   |    4 ++--
 arch/um/include/asm/tlb.h   |    7 ++++++-
 include/asm-generic/tlb.h   |    2 +-
 include/linux/mm_types.h    |    8 ++++++++
 mm/memory.c                 |   17 +++++++++++++++--
 8 files changed, 47 insertions(+), 9 deletions(-)

diff -puN arch/arm/include/asm/tlb.h~mm-fix-madv_-tlb-flush-miss-problem arch/arm/include/asm/tlb.h
--- a/arch/arm/include/asm/tlb.h~mm-fix-madv_-tlb-flush-miss-problem
+++ a/arch/arm/include/asm/tlb.h
@@ -168,8 +168,13 @@ arch_tlb_gather_mmu(struct mmu_gather *t
 
 static inline void
 arch_tlb_finish_mmu(struct mmu_gather *tlb,
-			unsigned long start, unsigned long end)
+			unsigned long start, unsigned long end, bool force)
 {
+	if (force) {
+		tlb->range_start = start;
+		tlb->range_end = end;
+	}
+
 	tlb_flush_mmu(tlb);
 
 	/* keep the page table cache within bounds */
diff -puN arch/ia64/include/asm/tlb.h~mm-fix-madv_-tlb-flush-miss-problem arch/ia64/include/asm/tlb.h
--- a/arch/ia64/include/asm/tlb.h~mm-fix-madv_-tlb-flush-miss-problem
+++ a/arch/ia64/include/asm/tlb.h
@@ -187,8 +187,10 @@ arch_tlb_gather_mmu(struct mmu_gather *t
  */
 static inline void
 arch_tlb_finish_mmu(struct mmu_gather *tlb,
-			unsigned long start, unsigned long end)
+			unsigned long start, unsigned long end, bool force)
 {
+	if (force)
+		tlb->need_flush = 1;
 	/*
 	 * Note: tlb->nr may be 0 at this point, so we can't rely on tlb->start_addr and
 	 * tlb->end_addr.
diff -puN arch/s390/include/asm/tlb.h~mm-fix-madv_-tlb-flush-miss-problem arch/s390/include/asm/tlb.h
--- a/arch/s390/include/asm/tlb.h~mm-fix-madv_-tlb-flush-miss-problem
+++ a/arch/s390/include/asm/tlb.h
@@ -77,8 +77,13 @@ static inline void tlb_flush_mmu(struct
 
 static inline void
 arch_tlb_finish_mmu(struct mmu_gather *tlb,
-		unsigned long start, unsigned long end)
+		unsigned long start, unsigned long end, bool force)
 {
+	if (force) {
+		tlb->start = start;
+		tlb->end = end;
+	}
+
 	tlb_flush_mmu(tlb);
 }
 
diff -puN arch/sh/include/asm/tlb.h~mm-fix-madv_-tlb-flush-miss-problem arch/sh/include/asm/tlb.h
--- a/arch/sh/include/asm/tlb.h~mm-fix-madv_-tlb-flush-miss-problem
+++ a/arch/sh/include/asm/tlb.h
@@ -49,9 +49,9 @@ arch_tlb_gather_mmu(struct mmu_gather *t
 
 static inline void
 arch_tlb_finish_mmu(struct mmu_gather *tlb,
-		unsigned long start, unsigned long end)
+		unsigned long start, unsigned long end, bool force)
 {
-	if (tlb->fullmm)
+	if (tlb->fullmm || force)
 		flush_tlb_mm(tlb->mm);
 
 	/* keep the page table cache within bounds */
diff -puN arch/um/include/asm/tlb.h~mm-fix-madv_-tlb-flush-miss-problem arch/um/include/asm/tlb.h
--- a/arch/um/include/asm/tlb.h~mm-fix-madv_-tlb-flush-miss-problem
+++ a/arch/um/include/asm/tlb.h
@@ -87,8 +87,13 @@ tlb_flush_mmu(struct mmu_gather *tlb)
  */
 static inline void
 arch_tlb_finish_mmu(struct mmu_gather *tlb,
-		unsigned long start, unsigned long end)
+		unsigned long start, unsigned long end, bool force)
 {
+	if (force) {
+		tlb->start = start;
+		tlb->end = end;
+		tlb->need_flush = 1;
+	}
 	tlb_flush_mmu(tlb);
 
 	/* keep the page table cache within bounds */
diff -puN include/asm-generic/tlb.h~mm-fix-madv_-tlb-flush-miss-problem include/asm-generic/tlb.h
--- a/include/asm-generic/tlb.h~mm-fix-madv_-tlb-flush-miss-problem
+++ a/include/asm-generic/tlb.h
@@ -116,7 +116,7 @@ void arch_tlb_gather_mmu(struct mmu_gath
 	struct mm_struct *mm, unsigned long start, unsigned long end);
 void tlb_flush_mmu(struct mmu_gather *tlb);
 void arch_tlb_finish_mmu(struct mmu_gather *tlb,
-			 unsigned long start, unsigned long end);
+			 unsigned long start, unsigned long end, bool force);
 extern bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
 				   int page_size);
 
diff -puN include/linux/mm_types.h~mm-fix-madv_-tlb-flush-miss-problem include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-fix-madv_-tlb-flush-miss-problem
+++ a/include/linux/mm_types.h
@@ -538,6 +538,14 @@ static inline bool mm_tlb_flush_pending(
 	return atomic_read(&mm->tlb_flush_pending) > 0;
 }
 
+/*
+ * Returns true if there are two above TLB batching threads in parallel.
+ */
+static inline bool mm_tlb_flush_nested(struct mm_struct *mm)
+{
+	return atomic_read(&mm->tlb_flush_pending) > 1;
+}
+
 static inline void init_tlb_flush_pending(struct mm_struct *mm)
 {
 	atomic_set(&mm->tlb_flush_pending, 0);
diff -puN mm/memory.c~mm-fix-madv_-tlb-flush-miss-problem mm/memory.c
--- a/mm/memory.c~mm-fix-madv_-tlb-flush-miss-problem
+++ a/mm/memory.c
@@ -272,10 +272,13 @@ void tlb_flush_mmu(struct mmu_gather *tl
  *	that were required.
  */
 void arch_tlb_finish_mmu(struct mmu_gather *tlb,
-		unsigned long start, unsigned long end)
+		unsigned long start, unsigned long end, bool force)
 {
 	struct mmu_gather_batch *batch, *next;
 
+	if (force)
+		__tlb_adjust_range(tlb, start, end - start);
+
 	tlb_flush_mmu(tlb);
 
 	/* keep the page table cache within bounds */
@@ -404,12 +407,22 @@ void tlb_gather_mmu(struct mmu_gather *t
 			unsigned long start, unsigned long end)
 {
 	arch_tlb_gather_mmu(tlb, mm, start, end);
+	inc_tlb_flush_pending(tlb->mm);
 }
 
 void tlb_finish_mmu(struct mmu_gather *tlb,
 		unsigned long start, unsigned long end)
 {
-	arch_tlb_finish_mmu(tlb, start, end);
+	/*
+	 * If there are parallel threads are doing PTE changes on same range
+	 * under non-exclusive lock(e.g., mmap_sem read-side) but defer TLB
+	 * flush by batching, a thread has stable TLB entry can fail to flush
+	 * the TLB by observing pte_none|!pte_dirty, for example so flush TLB
+	 * forcefully if we detect parallel PTE batching threads.
+	 */
+	bool force = mm_tlb_flush_nested(tlb->mm);
+
+	arch_tlb_finish_mmu(tlb, start, end, force);
 }
 
 /*
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-do-not-free-pool-size_class.patch
mm-refactoring-tlb-gathering-api.patch
mm-make-tlb_flush_pending-global.patch
mm-fix-madv_-tlb-flush-miss-problem.patch
mm-fix-ksm-data-corruption.patch
zram-clean-up-duplicated-codes-in-__zram_bvec_write.patch
zram-inlining-zram_compress.patch
zram-rename-zram_decompress_page-with-__zram_bvec_read.patch
zram-add-interface-to-specify-backing-device.patch
zram-add-free-space-management-in-backing-device.patch
zram-identify-asynchronous-ios-return-value.patch
zram-write-incompressible-pages-to-backing-device.patch
zram-read-page-from-backing-device.patch
zram-add-config-and-doc-file-for-writeback-feature.patch

