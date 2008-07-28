From: akpm@linux-foundation.org
Subject: - vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch removed from -mm tree
Date: Mon, 28 Jul 2008 16:50:01 -0700
Message-ID: <200807282350.m6SNo1hr002448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064AbYG1Xuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 19:50:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     splitlru: memcg swapbacked pages active
has been removed from the -mm tree.  Its filename was
     vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch

This patch was dropped because it was folded into vmscan-split-lru-lists-into-anon-file-sets.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: splitlru: memcg swapbacked pages active
From: Hugh Dickins <hugh@veritas.com>

add_to_page_cache_lru puts PageSwapBacked pages on the active_anon lru, so
shouldn't mem_cgroup_charge_common mirror that by setting FLAG_ACTIVE?

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memcontrol.c~vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active
+++ a/mm/memcontrol.c
@@ -560,6 +560,8 @@ static int mem_cgroup_charge_common(stru
 		pc->flags = PAGE_CGROUP_FLAG_CACHE;
 		if (page_is_file_cache(page))
 			pc->flags |= PAGE_CGROUP_FLAG_FILE;
+		else
+			pc->flags |= PAGE_CGROUP_FLAG_ACTIVE;
 	} else
 		pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
 
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
vmscan-split-lru-lists-into-anon-file-sets.patch
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

