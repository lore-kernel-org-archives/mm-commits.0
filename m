From: akpm@linux-foundation.org
Subject: - full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:48:56 -0700
Message-ID: <200807252348.m6PNmvew005863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479AbYGYXtt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:49:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, eduard.munteanu@linux360.ro, jens.axboe@oracle.com, tzanussi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     smp.c: fix build error
has been removed from the -mm tree.  Its filename was
     full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix.patch

This patch was dropped because it was folded into full-conversion-to-early_initcall-interface-remove-old-interface.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smp.c: fix build error
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Against: mmotm
Patch name: full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix.patch
Applies after: full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch

--------------------------------

Now, init_call_single_data() is static function.
then redundant declaration cause build error as below.

     kernel/smp.c:36: error: static declaration of ‘init_call_single_data’ follows non-static declaration
     include/linux/smp.h:77: error: previous declaration of ‘init_call_single_data’ was here
     kernel/smp.c:47: warning: initialization from incompatible pointer type
     make[1]: *** [kernel/smp.o] error 1

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/linux/smp.h~full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix include/linux/smp.h
--- a/include/linux/smp.h~full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix
+++ a/include/linux/smp.h
@@ -74,15 +74,10 @@ void __smp_call_function_single(int cpui
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 void generic_smp_call_function_single_interrupt(void);
 void generic_smp_call_function_interrupt(void);
-void init_call_single_data(void);
 void ipi_call_lock(void);
 void ipi_call_unlock(void);
 void ipi_call_lock_irq(void);
 void ipi_call_unlock_irq(void);
-#else
-static inline void init_call_single_data(void)
-{
-}
 #endif
 
 /*
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
full-conversion-to-early_initcall-interface-remove-old-interface.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix-fix.patch
relay-add-buffer-only-channels-useful-for-early-logging-fix.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-collect-lru-meminfo-statistics-from-correct-offset.patch
vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru.patch
vmscan-split-lru-lists-into-anon-file-sets-split_lru-fix-pagevec_move_tail-doesnt-treat-unevictable-page.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-second-chance-replacement-for-anonymous-pages-fix.patch
vmscan-second-chance-replacement-for-anonymous-pages-memcg-lru-scan-fix.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch
unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch
unevictable-lru-infrastructure-kill-unnecessary-lock_page-in-vmscanc.patch
unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
unevictable-lru-page-statistics-fix-printk-in-show_free_areas.patch
unevictable-lru-page-statistics-units-fix.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mlock-mlocked-pages-are-unevictable-restore-patch-failure-hunk-of-mlock-mlocked-pages-are-unevictablepatch.patch
mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmstat-mlocked-pages-statistics-fix.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch

