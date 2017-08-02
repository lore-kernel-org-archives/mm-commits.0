From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix.patch removed from -mm tree
Date: Wed, 02 Aug 2017 13:22:42 -0700
Message-ID: <59823492.TvRbzHaCcNAE6K9Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44880 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753197AbdHBUWn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 16:22:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix
has been removed from the -mm tree.  Its filename was
     mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix.patch

This patch was dropped because it was folded into mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix

tweak comments

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/rmap.c~mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix mm/rmap.c
--- a/mm/rmap.c~mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix
+++ a/mm/rmap.c
@@ -605,7 +605,7 @@ static void set_tlb_ubc_flush_pending(st
 	tlb_ubc->flush_required = true;
 
 	/*
-	 * Ensure compiler does not re-order the setting ot tlb_flush_batched
+	 * Ensure compiler does not re-order the setting of tlb_flush_batched
 	 * before the PTE is cleared.
 	 */
 	barrier();
@@ -640,19 +640,19 @@ static bool should_defer_flush(struct mm
 }
 
 /*
- * Reclaim unmaps pages under the PTL but does not flush the TLB prior to
- * releasing the PTL if TLB flushes are batched. It's possible a parallel
+ * Reclaim unmaps pages under the PTL but do not flush the TLB prior to
+ * releasing the PTL if TLB flushes are batched. It's possible for a parallel
  * operation such as mprotect or munmap to race between reclaim unmapping
- * the page and flushing the page If this race occurs, it potentially allows
+ * the page and flushing the page. If this race occurs, it potentially allows
  * access to data via a stale TLB entry. Tracking all mm's that have TLB
  * batching in flight would be expensive during reclaim so instead track
  * whether TLB batching occured in the past and if so then do a flush here
  * if required. This will cost one additional flush per reclaim cycle paid
  * by the first operation at risk such as mprotect and mumap.
  *
- * This must be called under the PTL so that accesses to tlb_flush_batched
- * that is potentially a "reclaim vs mprotect/munmap/etc" race will
- * synchronise via the PTL.
+ * This must be called under the PTL so that an access to tlb_flush_batched
+ * that is potentially a "reclaim vs mprotect/munmap/etc" race will synchronise
+ * via the PTL.
  */
 void flush_tlb_batched_pending(struct mm_struct *mm)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries.patch
mm-mprotect-flush-tlb-if-potentially-racing-with-a-parallel-reclaim-leaving-stale-tlb-entries-fix-fix.patch
fortify-use-warn-instead-of-bug-for-now-fix.patch
swap-fix-oops-during-block-io-poll-in-swapin-path-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

