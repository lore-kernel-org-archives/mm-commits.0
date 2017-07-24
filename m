From: akpm@linux-foundation.org
Subject: + mm-prevent-racy-access-to-tlb_flush_pending.patch added to -mm
 tree
Date: Mon, 24 Jul 2017 16:56:12 -0700
Message-ID: <5976891c.dr05QYanZ/Faqict%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53488 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbdGXX4N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2017 19:56:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namit@vmware.com, luto@kernel.org, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: prevent racy access to tlb_flush_pending
has been added to the -mm tree.  Its filename is
     mm-prevent-racy-access-to-tlb_flush_pending.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-prevent-racy-access-to-tlb_flush_pending.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-prevent-racy-access-to-tlb_flush_pending.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: mm: prevent racy access to tlb_flush_pending

Setting and clearing mm->tlb_flush_pending can be performed by multiple
threads, since mmap_sem may only be acquired for read in task_numa_work. 
If this happens, tlb_flush_pending may be cleared while one of the threads
still changes PTEs and batches TLB flushes.

As a result, TLB flushes can be skipped because the indication of pending
TLB flushes is lost, for instance due to race between migration and
change_protection_range (just as in the scenario that caused the
introduction of tlb_flush_pending).

The feasibility of such a scenario was confirmed by adding assertion to
check tlb_flush_pending is not set by two threads, adding artificial
latency in change_protection_range() and using sysctl to reduce
kernel.numa_balancing_scan_delay_ms.

Fixes: 20841405940e ("mm: fix TLB flush race between migration, and change_protection_range")
Link: http://lkml.kernel.org/r/20170717180246.62277-1-namit@vmware.com
Signed-off-by: Nadav Amit <namit@vmware.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    8 ++++----
 kernel/fork.c            |    2 +-
 mm/debug.c               |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/mm_types.h~mm-prevent-racy-access-to-tlb_flush_pending include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-prevent-racy-access-to-tlb_flush_pending
+++ a/include/linux/mm_types.h
@@ -493,7 +493,7 @@ struct mm_struct {
 	 * can move process memory needs to flush the TLB when moving a
 	 * PROT_NONE or PROT_NUMA mapped page.
 	 */
-	bool tlb_flush_pending;
+	atomic_t tlb_flush_pending;
 #endif
 #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 	/* See flush_tlb_batched_pending() */
@@ -532,11 +532,11 @@ static inline cpumask_t *mm_cpumask(stru
 static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
 {
 	barrier();
-	return mm->tlb_flush_pending;
+	return atomic_read(&mm->tlb_flush_pending) > 0;
 }
 static inline void set_tlb_flush_pending(struct mm_struct *mm)
 {
-	mm->tlb_flush_pending = true;
+	atomic_inc(&mm->tlb_flush_pending);
 
 	/*
 	 * Guarantee that the tlb_flush_pending store does not leak into the
@@ -548,7 +548,7 @@ static inline void set_tlb_flush_pending
 static inline void clear_tlb_flush_pending(struct mm_struct *mm)
 {
 	barrier();
-	mm->tlb_flush_pending = false;
+	atomic_dec(&mm->tlb_flush_pending);
 }
 #else
 static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
diff -puN kernel/fork.c~mm-prevent-racy-access-to-tlb_flush_pending kernel/fork.c
--- a/kernel/fork.c~mm-prevent-racy-access-to-tlb_flush_pending
+++ a/kernel/fork.c
@@ -807,7 +807,7 @@ static struct mm_struct *mm_init(struct
 	mm_init_aio(mm);
 	mm_init_owner(mm, p);
 	mmu_notifier_mm_init(mm);
-	clear_tlb_flush_pending(mm);
+	atomic_set(&mm->tlb_flush_pending, 0);
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
 	mm->pmd_huge_pte = NULL;
 #endif
diff -puN mm/debug.c~mm-prevent-racy-access-to-tlb_flush_pending mm/debug.c
--- a/mm/debug.c~mm-prevent-racy-access-to-tlb_flush_pending
+++ a/mm/debug.c
@@ -159,7 +159,7 @@ void dump_mm(const struct mm_struct *mm)
 		mm->numa_next_scan, mm->numa_scan_offset, mm->numa_scan_seq,
 #endif
 #if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
-		mm->tlb_flush_pending,
+		atomic_read(&mm->tlb_flush_pending),
 #endif
 		mm->def_flags, &mm->def_flags
 	);
_

Patches currently in -mm which might be from namit@vmware.com are

mm-prevent-racy-access-to-tlb_flush_pending.patch

