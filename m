From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-deferred_init_memmap-improvements-fix.patch removed from -mm tree
Date: Thu, 02 Nov 2017 13:32:54 -0700
Message-ID: <59fb80f6.lkF3Jgk+K3BUK1wB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934337AbdKBUc4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 16:32:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, pasha.tatashin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-deferred_init_memmap-improvements-fix
has been removed from the -mm tree.  Its filename was
     mm-deferred_init_memmap-improvements-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-deferred_init_memmap-improvements-fix

__init section fixes

Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-deferred_init_memmap-improvements-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-deferred_init_memmap-improvements-fix
+++ a/mm/page_alloc.c
@@ -1448,7 +1448,7 @@ static inline void __init pgdat_init_rep
  * Helper for deferred_init_range, free the given range, reset the counters, and
  * return number of pages freed.
  */
-static inline unsigned long __def_free(unsigned long *nr_free,
+static unsigned long __init __def_free(unsigned long *nr_free,
 				       unsigned long *free_base_pfn,
 				       struct page **page)
 {
@@ -1462,8 +1462,8 @@ static inline unsigned long __def_free(u
 	return nr;
 }
 
-static unsigned long deferred_init_range(int nid, int zid, unsigned long pfn,
-					 unsigned long end_pfn)
+static unsigned long __init deferred_init_range(int nid, int zid,
+				unsigned long pfn, unsigned long end_pfn)
 {
 	struct mminit_pfnnid_cache nid_init_state = { };
 	unsigned long nr_pgmask = pageblock_nr_pages - 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
support-resetting-warn_once-for-all-architectures-v2-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

