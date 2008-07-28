From: akpm@linux-foundation.org
Subject: - define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch removed from -mm tree
Date: Mon, 28 Jul 2008 16:47:00 -0700
Message-ID: <200807282347.m6SNl0XK002312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619AbYG1Xrl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 19:47:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     splitlru: shmem_getpage SetPageSwapBacked sooner
has been removed from the -mm tree.  Its filename was
     define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch

This patch was dropped because it was folded into define-page_file_cache-function.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: splitlru: shmem_getpage SetPageSwapBacked sooner
From: Hugh Dickins <hugh@veritas.com>

shmem_getpage must SetPageSwapBacked before the mem_cgroup_cache_charge,
otherwise try_to_free_mem_cgroup_pages cannot find the shmem/tmpfs pages
it needs to free, and OOMs or hangs result.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/shmem.c~define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner mm/shmem.c
--- a/mm/shmem.c~define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner
+++ a/mm/shmem.c
@@ -1369,6 +1369,7 @@ repeat:
 				error = -ENOMEM;
 				goto failed;
 			}
+			SetPageSwapBacked(filepage);
 
 			/* Precharge page while we can wait, compensate after */
 			error = mem_cgroup_cache_charge(filepage, current->mm,
@@ -1381,7 +1382,6 @@ repeat:
 				goto failed;
 			}
 
-			SetPageSwapBacked(filepage);
 			spin_lock(&info->lock);
 			entry = shmem_swp_alloc(info, idx, sgp);
 			if (IS_ERR(entry))
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
exec-include-pagemaph-again-to-fix-build.patch
tmpfs-fix-kernel-bug-in-shmem_delete_inode.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
vfs-increase-pseudo-filesystem-block-size-to-page_size.patch
powerpc-lockless-get_user_pages.patch
git-unionfs.patch
define-page_file_cache-function.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable-fix-4.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
mmapc-deinline-a-few-functions.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
prio_tree-debugging-patch.patch

