From: akpm@linux-foundation.org
Subject: + fix-bogus-hotplug-cpu-warning.patch added to -mm tree
Date: Mon, 27 Aug 2007 16:07:26 -0700
Message-ID: <200708272307.l7RN7QgB000803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46560 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbXH0XHe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 19:07:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com


The patch titled
     fix bogus hotplug cpu warning
has been added to the -mm tree.  Its filename is
     fix-bogus-hotplug-cpu-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix bogus hotplug cpu warning
From: Hugh Dickins <hugh@veritas.com>

Fix bogus DEBUG_PREEMPT warning on x86_64, when cpu brought online after
bootup: current_is_keventd is right to note its use of smp_processor_id is
preempt-safe, but should use raw_smp_processor_id to avoid the warning.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/workqueue.c~fix-bogus-hotplug-cpu-warning kernel/workqueue.c
--- a/kernel/workqueue.c~fix-bogus-hotplug-cpu-warning
+++ a/kernel/workqueue.c
@@ -635,7 +635,7 @@ int keventd_up(void)
 int current_is_keventd(void)
 {
 	struct cpu_workqueue_struct *cwq;
-	int cpu = smp_processor_id();	/* preempt-safe: keventd is per-cpu */
+	int cpu = raw_smp_processor_id(); /* preempt-safe: keventd is per-cpu */
 	int ret = 0;
 
 	BUG_ON(!keventd_wq);
_

Patches currently in -mm which might be from hugh@veritas.com are

fix-bogus-hotplug-cpu-warning.patch
check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
mm-clarify-__add_to_swap_cache-locking.patch
mm-clarify-__add_to_swap_cache-locking-fix.patch
radix-tree-use-indirect-bit.patch
introduce-write_begin-write_end-aops-important-fix.patch
reiserfs-convert-to-new-aops-fix.patch
hostfs-convert-to-new-aops-fix.patch
affs-convert-to-new-aops-fix.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
mm-shmemc-make-3-functions-static.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
prio_tree-debugging-patch.patch
