From: akpm@linux-foundation.org
Subject: + mm-make-tlb_flush_pending-global.patch added to -mm tree
Date: Wed, 02 Aug 2017 16:34:09 -0700
Message-ID: <59826171.gsNTyE0gy2BMEo+3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59912 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751737AbdHBXeK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 19:34:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aarcange@redhat.com, davem@davemloft.net, heiko.carstens@de.ibm.com, hughd@google.com, jdike@addtoit.com, linux@armlinux.org.uk, luto@kernel.org, mgorman@suse.de, mgorman@techsingularity.net, mingo@redhat.com, nadav.amit@gmail.com, namit@vmware.com, riel@redhat.com, schwidefsky@de.ibm.com, sergey.senozhatsky@gmail.com, tony.luck@intel.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make tlb_flush_pending global
has been added to the -mm tree.  Its filename is
     mm-make-tlb_flush_pending-global.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-tlb_flush_pending-global.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-tlb_flush_pending-global.patch

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
Subject: mm: make tlb_flush_pending global

Currently, tlb_flush_pending is used only for CONFIG_[NUMA_BALANCING|
COMPACTION] but upcoming patches to solve subtle TLB flush batching
problem will use it regardless of compaction/NUMA so this patch doesn't
remove the dependency.

Link: http://lkml.kernel.org/r/20170802000818.4760-6-namit@vmware.com
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   21 ---------------------
 mm/debug.c               |    2 --
 2 files changed, 23 deletions(-)

diff -puN include/linux/mm_types.h~mm-make-tlb_flush_pending-global include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-make-tlb_flush_pending-global
+++ a/include/linux/mm_types.h
@@ -487,14 +487,12 @@ struct mm_struct {
 	/* numa_scan_seq prevents two threads setting pte_numa */
 	int numa_scan_seq;
 #endif
-#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
 	/*
 	 * An operation with batched TLB flushing is going on. Anything that
 	 * can move process memory needs to flush the TLB when moving a
 	 * PROT_NONE or PROT_NUMA mapped page.
 	 */
 	atomic_t tlb_flush_pending;
-#endif
 #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 	/* See flush_tlb_batched_pending() */
 	bool tlb_flush_batched;
@@ -528,7 +526,6 @@ extern void tlb_gather_mmu(struct mmu_ga
 extern void tlb_finish_mmu(struct mmu_gather *tlb,
 				unsigned long start, unsigned long end);
 
-#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
 /*
  * Memory barriers to keep this state in sync are graciously provided by
  * the page table locks, outside of which no page table modifications happen.
@@ -569,24 +566,6 @@ static inline void dec_tlb_flush_pending
 	smp_mb__before_atomic();
 	atomic_dec(&mm->tlb_flush_pending);
 }
-#else
-static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
-{
-	return false;
-}
-
-static inline void init_tlb_flush_pending(struct mm_struct *mm)
-{
-}
-
-static inline void inc_tlb_flush_pending(struct mm_struct *mm)
-{
-}
-
-static inline void dec_tlb_flush_pending(struct mm_struct *mm)
-{
-}
-#endif
 
 struct vm_fault;
 
diff -puN mm/debug.c~mm-make-tlb_flush_pending-global mm/debug.c
--- a/mm/debug.c~mm-make-tlb_flush_pending-global
+++ a/mm/debug.c
@@ -158,9 +158,7 @@ void dump_mm(const struct mm_struct *mm)
 #ifdef CONFIG_NUMA_BALANCING
 		mm->numa_next_scan, mm->numa_scan_offset, mm->numa_scan_seq,
 #endif
-#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
 		atomic_read(&mm->tlb_flush_pending),
-#endif
 		mm->def_flags, &mm->def_flags
 	);
 }
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

