From: akpm@linux-foundation.org
Subject: [folded-dropped] atomic-implement-generic-atomic_dec_if_positive-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:10:00 -0700
Message-ID: <20121008231000.8F6BD100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:49245 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2JHXKC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:10:02 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so395878qae.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:10:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, davem@davemloft.net, hpa@zytor.com, mingo@elte.hu, monstr@monstr.eu, riel@redhat.com, sfr@canb.auug.org.au, shli@fusionio.com, shli@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: atomic-implement-generic-atomic_dec_if_positive-fix
has been removed from the -mm tree.  Its filename was
     atomic-implement-generic-atomic_dec_if_positive-fix.patch

This patch was dropped because it was folded into atomic-implement-generic-atomic_dec_if_positive.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: atomic-implement-generic-atomic_dec_if_positive-fix

do the "#define foo foo" trick in the conventional manner

Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/atomic.h |    4 ++--
 arch/powerpc/include/asm/atomic.h    |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/microblaze/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive-fix arch/microblaze/include/asm/atomic.h
--- a/arch/microblaze/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive-fix
+++ a/arch/microblaze/include/asm/atomic.h
@@ -9,7 +9,7 @@
  * Atomically test *v and decrement if it is greater than 0.
  * The function returns the old value of *v minus 1.
  */
-static inline int __atomic_dec_if_positive(atomic_t *v)
+static inline int atomic_dec_if_positive(atomic_t *v)
 {
 	unsigned long flags;
 	int res;
@@ -22,6 +22,6 @@ static inline int __atomic_dec_if_positi
 
 	return res;
 }
-#define atomic_dec_if_positive __atomic_dec_if_positive
+#define atomic_dec_if_positive atomic_dec_if_positive
 
 #endif /* _ASM_MICROBLAZE_ATOMIC_H */
diff -puN arch/powerpc/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive-fix arch/powerpc/include/asm/atomic.h
--- a/arch/powerpc/include/asm/atomic.h~atomic-implement-generic-atomic_dec_if_positive-fix
+++ a/arch/powerpc/include/asm/atomic.h
@@ -247,7 +247,7 @@ static __inline__ int atomic_inc_not_zer
  * The function returns the old value of *v minus 1, even if
  * the atomic variable, v, was not decremented.
  */
-static __inline__ int __atomic_dec_if_positive(atomic_t *v)
+static __inline__ int atomic_dec_if_positive(atomic_t *v)
 {
 	int t;
 
@@ -268,7 +268,7 @@ static __inline__ int __atomic_dec_if_po
 
 	return t;
 }
-#define atomic_dec_if_positive __atomic_dec_if_positive
+#define atomic_dec_if_positive atomic_dec_if_positive
 
 #define smp_mb__before_atomic_dec()     smp_mb()
 #define smp_mb__after_atomic_dec()      smp_mb()
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
rbtree-performance-and-correctness-test.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
cma-count-free-cma-pages.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
atomic-implement-generic-atomic_dec_if_positive.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
cma-migrate-mlocked-pages-fix.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name-fix.patch
mm-document-pagehuge-somewhat.patch
mm-memcg-clean-up-mm_match_cgroup-signature-fix.patch
memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch

