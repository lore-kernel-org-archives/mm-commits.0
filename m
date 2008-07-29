From: akpm@linux-foundation.org
Subject: - exec-include-pagemaph-again-to-fix-build.patch removed from -mm tree
Date: Tue, 29 Jul 2008 13:29:30 -0700
Message-ID: <200807292029.m6TKTUi9019707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752422AbYG2U3t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 16:29:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, bunk@kernel.org, haavard.skinnemoen@atmel.com, yoichi_yuasa@tripeaks.co.jp, mm-commits@vger.kernel.org


The patch titled
     exec: include pagemap.h again to fix build
has been removed from the -mm tree.  Its filename was
     exec-include-pagemaph-again-to-fix-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Reported-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Reported-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
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

vfs-increase-pseudo-filesystem-block-size-to-page_size.patch
mm-add-zap_vma_ptes-a-library-function-to-unmap-driver-ptes.patch
gru-driver-v3-resource-management-unmap-driver-ptes-gru.patch
powerpc-lockless-get_user_pages.patch
git-unionfs.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
mlock-mlocked-pages-are-unevictable.patch
vmscan-unevictable-lru-scan-sysctl.patch
mmapc-deinline-a-few-functions.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
prio_tree-debugging-patch.patch

