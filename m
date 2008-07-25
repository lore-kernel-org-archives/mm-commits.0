From: akpm@linux-foundation.org
Subject: - relay-add-buffer-only-channels-useful-for-early-logging-fix.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:50:14 -0700
Message-ID: <200807252350.m6PNoERw005900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659AbYGYXu5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:50:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, eduard.munteanu@linux360.ro, tzanussi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     relay: fix build error
has been removed from the -mm tree.  Its filename was
     relay-add-buffer-only-channels-useful-for-early-logging-fix.patch

This patch was dropped because it was folded into relay-add-buffer-only-channels-useful-for-early-logging.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: relay: fix build error
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

against: mmotm
patchname: relay-add-buffer-only-channels-useful-for-early-logging-fix.patch
applies after: relay-add-buffer-only-channels-useful-for-early-logging.patch

recently, smp_call_function remove retry argument.
it cause following build error on mmotm.

	kernel/relay.c: In function ‘relay_late_setup_files’:
	kernel/relay.c:754: error: too many arguments to function ‘smp_call_function_single’
	make[1]: *** [kernel/relay.o] error 1

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/relay.c~relay-add-buffer-only-channels-useful-for-early-logging-fix kernel/relay.c
--- a/kernel/relay.c~relay-add-buffer-only-channels-useful-for-early-logging-fix
+++ a/kernel/relay.c
@@ -751,7 +751,7 @@ int relay_late_setup_files(struct rchan 
 			/* relay_channels_mutex must be held, so wait. */
 			err = smp_call_function_single(i,
 						       __relay_set_buf_dentry,
-						       &disp, 0, 1);
+						       &disp, 1);
 		}
 		if (unlikely(err))
 			break;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
full-conversion-to-early_initcall-interface-remove-old-interface.patch
relay-add-buffer-only-channels-useful-for-early-logging.patch
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

