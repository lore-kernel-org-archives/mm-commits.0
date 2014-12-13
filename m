From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mincore-add-hwpoison-page-handle-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 12 Dec 2014 16:39:55 -0800
Message-ID: <548b8adb.2+Fdh3OrmfZj/nsZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaLMAj4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:39:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mincore-add-hwpoison-page-handle-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-mincore-add-hwpoison-page-handle-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-mincore-add-hwpoison-page-handle.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mincore-add-hwpoison-page-handle-checkpatch-fixes

WARNING: suspect code indent for conditional statements (24, 24)
#32: FILE: mm/mincore.c:140:
+			if (non_swap_entry(entry)) {
+			/* migration or hwpoison entries are always uptodate */

total: 0 errors, 1 warnings, 10 lines checked

./patches/mm-mincore-add-hwpoison-page-handle.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Weijie Yang <weijie.yang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/mincore.c~mm-mincore-add-hwpoison-page-handle-checkpatch-fixes mm/mincore.c
--- a/mm/mincore.c~mm-mincore-add-hwpoison-page-handle-checkpatch-fixes
+++ a/mm/mincore.c
@@ -138,7 +138,10 @@ static void mincore_pte_range(struct vm_
 			swp_entry_t entry = pte_to_swp_entry(pte);
 
 			if (non_swap_entry(entry)) {
-			/* migration or hwpoison entries are always uptodate */
+				/*
+				 * migration or hwpoison entries are always
+				 * uptodate
+				 */
 				*vec = 1;
 			} else {
 #ifdef CONFIG_SWAP
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-mincore-add-hwpoison-page-handle.patch
include-linux-kmemleakh-needs-slabh.patch
mm-page_owner-keep-track-of-page-owners.patch
fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size-fix.patch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch

