From: akpm@linux-foundation.org
Subject: - exec-remove-some-includes.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:52 -0700
Message-ID: <200807252254.m6PMsqMx002858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669AbYGYWz1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:55:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     exec: remove some includes
has been removed from the -mm tree.  Its filename was
     exec-remove-some-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec: remove some includes
From: Hugh Dickins <hugh@veritas.com>

fs/exec.c used to need mman.h pagemap.h swap.h and rmap.h when it did
mm-ish stuff in install_arg_page(); but no need for them after 2.6.22.

[akpm@linux-foundation.org: unbreak arm]
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/exec.c~exec-remove-some-includes fs/exec.c
--- a/fs/exec.c~exec-remove-some-includes
+++ a/fs/exec.c
@@ -25,19 +25,18 @@
 #include <linux/slab.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
-#include <linux/mman.h>
+#include <linux/mm.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/smp_lock.h>
+#include <linux/swap.h>
 #include <linux/string.h>
 #include <linux/init.h>
-#include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
 #include <linux/key.h>
 #include <linux/personality.h>
 #include <linux/binfmts.h>
-#include <linux/swap.h>
 #include <linux/utsname.h>
 #include <linux/pid_namespace.h>
 #include <linux/module.h>
@@ -47,7 +46,6 @@
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
-#include <linux/rmap.h>
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix-fix.patch
mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
x86-implement-pte_special-fix.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-fix.patch
mm-speculative-page-references-fix-add_to_page_cache.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
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
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
prio_tree-debugging-patch.patch

