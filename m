From: akpm@linux-foundation.org
Subject: [alternative-merged]
 arch-um-kernel-sysrqc-rename-print_stack_trace.patch removed from -mm tree
Date: Mon, 02 Dec 2013 12:36:18 -0800
Message-ID: <529cef42.9SplWGAG6ct/GFzz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab3LBUgT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 15:36:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, richrd@nod.at, fengguang.wu@intel.com, akpm@linux-foundation.org

Subject: [alternative-merged] arch-um-kernel-sysrqc-rename-print_stack_trace.patch removed from -mm tree
To: akpm@linux-foundation.org,fengguang.wu@intel.com,richrd@nod.at,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 12:36:18 -0800


The patch titled
     Subject: arch/um/kernel/sysrq.c: rename print_stack_trace()
has been removed from the -mm tree.  Its filename was
     arch-um-kernel-sysrqc-rename-print_stack_trace.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/um/kernel/sysrq.c: rename print_stack_trace()

This symbol conflicts with include/linux/stacktrace.h:print_stack_trace().
If sysrq.c sees stacktrace.h, the build blows up.  I have a local debug
patch whcih triggers this.

So s/print_stack_trace/um_print_stack_trace/

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Richard Weinberger <richrd@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/sysrq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/kernel/sysrq.c~arch-um-kernel-sysrqc-rename-print_stack_trace arch/um/kernel/sysrq.c
--- a/arch/um/kernel/sysrq.c~arch-um-kernel-sysrqc-rename-print_stack_trace
+++ a/arch/um/kernel/sysrq.c
@@ -19,7 +19,7 @@ struct stack_frame {
 	unsigned long return_address;
 };
 
-static void print_stack_trace(unsigned long *sp, unsigned long bp)
+static void um_print_stack_trace(unsigned long *sp, unsigned long bp)
 {
 	int reliable;
 	unsigned long addr;
@@ -94,5 +94,5 @@ void show_stack(struct task_struct *task
 	}
 	printk(KERN_CONT "\n");
 
-	print_stack_trace(sp, bp);
+	um_print_stack_trace(sp, bp);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

