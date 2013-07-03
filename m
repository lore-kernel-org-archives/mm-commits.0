From: akpm@linux-foundation.org
Subject: [folded-merged]
 dump_stack-serialize-the-output-from-dump_stack-fix.patch removed from -mm
 tree
Date: Wed, 03 Jul 2013 14:37:45 -0700
Message-ID: <51d499a9.eTMEj1paOu4TtY1T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933406Ab3GCVhq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:37:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, rkuo@codeaurora.org, rja@sgi.com, jesper.nilsson@axis.com, holt@sgi.com, davem@davemloft.net, athorlton@sgi.com, akpm@linux-foundation.org

Subject: [folded-merged] dump_stack-serialize-the-output-from-dump_stack-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,athorlton@sgi.com,davem@davemloft.net,holt@sgi.com,jesper.nilsson@axis.com,rja@sgi.com,rkuo@codeaurora.org,vgupta@synopsys.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:37:45 -0700


The patch titled
     Subject: dump_stack-serialize-the-output-from-dump_stack-fix
has been removed from the -mm tree.  Its filename was
     dump_stack-serialize-the-output-from-dump_stack-fix.patch

This patch was dropped because it was folded into dump_stack-serialize-the-output-from-dump_stack.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: dump_stack-serialize-the-output-from-dump_stack-fix

- fix comment indenting
- avoid inclusion of <asm/> files - use <linux/> where possible
- fix uniprocessor build (__dump_stack undefined)
- remove unneeded ifdef around smp.h inclusion

Cc: Alex Thorlton <athorlton@sgi.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Robin Holt <holt@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: athorlton@sgi.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dump_stack.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff -puN lib/dump_stack.c~dump_stack-serialize-the-output-from-dump_stack-fix lib/dump_stack.c
--- a/lib/dump_stack.c~dump_stack-serialize-the-output-from-dump_stack-fix
+++ a/lib/dump_stack.c
@@ -6,12 +6,14 @@
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/sched.h>
-#include <asm/processor.h>
-#include <asm/atomic.h>
-
-#ifdef CONFIG_SMP
 #include <linux/smp.h>
-#endif
+#include <linux/atomic.h>
+
+static void __dump_stack(void)
+{
+	dump_stack_print_info(KERN_DEFAULT);
+	show_stack(NULL, NULL);
+}
 
 /**
  * dump_stack - dump the current task information and its stack trace
@@ -27,10 +29,10 @@ void dump_stack(void)
 	int old;
 	int cpu;
 
-        /*
-         * Permit this cpu to perform nested stack dumps while serialising
-         * against other CPUs
-         */
+	/*
+	 * Permit this cpu to perform nested stack dumps while serialising
+	 * against other CPUs
+	 */
 	preempt_disable();
 
 retry:
@@ -59,9 +61,3 @@ void dump_stack(void)
 }
 #endif
 EXPORT_SYMBOL(dump_stack);
-
-static void __dump_stack(void)
-{
-	dump_stack_print_info(KERN_DEFAULT);
-	show_stack(NULL, NULL);
-}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
ocfs2-xattr-remove-useless-free-space-checking.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink.patch
ocfs2-adjust-switch_case-syntax-at-o2net_state_change.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmalloc-introduce-remap_vmalloc_range_partial.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch
vmcore-support-mmap-on-proc-vmcore.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-tune-vm_committed_as-percpu_counter-batching-size.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages.patch
mm-correctly-update-zone-managed_pages.patch
clean-up-scary-strncpydst-src-strlensrc-uses.patch
dump_stack-serialize-the-output-from-dump_stack.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
rtc-add-nxp-pcf2127-support-i2c-fix.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch
dev-oldmem-remove-the-interface-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts.patch

