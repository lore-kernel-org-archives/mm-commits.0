From: akpm@linux-foundation.org
Subject: + exec-include-pagemaph-again-to-fix-build.patch added to -mm tree
Date: Sun, 27 Jul 2008 12:18:41 -0700
Message-ID: <200807271918.m6RJIfL1000807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705AbYG0TTA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 15:19:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, bunk@kernel.org, haavard.skinnemoen@atmel.com, yoichi_yuasa@tripeaks.co.jp


The patch titled
     exec: include pagemap.h again to fix build
has been added to the -mm tree.  Its filename is
     exec-include-pagemaph-again-to-fix-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec: include pagemap.h again to fix build
From: Hugh Dickins <hugh@veritas.com>

Fix compilation errors on avr32 and without CONFIG_SWAP, introduced by
ba92a43dbaee339cf5915ef766d3d3ffbaaf103c exec: remove some includes

In file included from include/asm/tlb.h:24,
                 from fs/exec.c:55:
include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
include/asm-generic/tlb.h: In function 'tlb_remove_page':
include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'
make[1]: *** [fs/exec.o] Error 1

This straightforward part-revert is nobody's favourite patch to address
the underlying tlb.h needs swap.h needs pagemap.h (but sparc won't like
that) mess; but appropriate to fix the build now before any overhaul.

Reviewed-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Reviewed-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Tested-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/exec.c~exec-include-pagemaph-again-to-fix-build fs/exec.c
--- a/fs/exec.c~exec-include-pagemaph-again-to-fix-build
+++ a/fs/exec.c
@@ -32,6 +32,7 @@
 #include <linux/swap.h>
 #include <linux/string.h>
 #include <linux/init.h>
+#include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
 #include <linux/key.h>
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
exec-include-pagemaph-again-to-fix-build.patch
tmpfs-fix-kernel-bug-in-shmem_delete_inode.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
netns-fix-ip_rt_frag_needed-rt_is_expired.patch
git-unionfs.patch
vfs-increase-pseudo-filesystem-block-size-to-page_size.patch
mmu-notifiers-add-mm_take_all_locks-operation-fix.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
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
prio_tree-debugging-patch.patch

