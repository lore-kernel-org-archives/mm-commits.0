From: akpm@linux-foundation.org
Subject: + dump_stack-serialize-the-output-from-dump_stack-fix.patch added to -mm tree
Date: Thu, 09 May 2013 13:59:55 -0700
Message-ID: <20130509205955.DB3945A4282@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:40991 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3EIU75 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:59:57 -0400
Received: by mail-yh0-f74.google.com with SMTP id t59so335575yho.3
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:59:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, athorlton@sgi.com, davem@davemloft.net, holt@sgi.com, jesper.nilsson@axis.com, rja@sgi.com, rkuo@codeaurora.org, vgupta@synopsys.com


The patch titled
     Subject: dump_stack-serialize-the-output-from-dump_stack-fix
has been added to the -mm tree.  Its filename is
     dump_stack-serialize-the-output-from-dump_stack-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
generic-dynamic-per-cpu-refcounting.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

