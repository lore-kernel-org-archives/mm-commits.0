From: akpm@linux-foundation.org
Subject: [merged]
 kernel-time-tick-commonc-document-tick_do_timer_cpu.patch removed from -mm
 tree
Date: Wed, 27 Nov 2013 12:26:33 -0800
Message-ID: <52965579.app5jSYXd1DTQGOy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab3K0U0d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Nov 2013 15:26:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, akpm@linux-foundation.org

Subject: [merged] kernel-time-tick-commonc-document-tick_do_timer_cpu.patch removed from -mm tree
To: akpm@linux-foundation.org,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 27 Nov 2013 12:26:33 -0800


The patch titled
     Subject: kernel/time/tick-common.c: document tick_do_timer_cpu
has been removed from the -mm tree.  Its filename was
     kernel-time-tick-commonc-document-tick_do_timer_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/time/tick-common.c: document tick_do_timer_cpu

Taken straight from a tglx email ;)

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-common.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN kernel/time/tick-common.c~kernel-time-tick-commonc-document-tick_do_timer_cpu kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~kernel-time-tick-commonc-document-tick_do_timer_cpu
+++ a/kernel/time/tick-common.c
@@ -33,6 +33,21 @@ DEFINE_PER_CPU(struct tick_device, tick_
  */
 ktime_t tick_next_period;
 ktime_t tick_period;
+
+/*
+ * tick_do_timer_cpu is a timer core internal variable which holds the CPU NR
+ * which is responsible for calling do_timer(), i.e. the timekeeping stuff. This
+ * variable has two functions:
+ *
+ * 1) Prevent a thundering herd issue of a gazillion of CPUs trying to grab the
+ *    timekeeping lock all at once. Only the CPU which is assigned to do the
+ *    update is handling it.
+ *
+ * 2) Hand off the duty in the NOHZ idle case by setting the value to
+ *    TICK_DO_TIMER_NONE, i.e. a non existing CPU. So the next cpu which looks
+ *    at it will take over and keep the time keeping alive.  The handover
+ *    procedure also covers cpu hotplug.
+ */
 int tick_do_timer_cpu __read_mostly = TICK_DO_TIMER_BOOT;
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix.patch
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
arch-um-kernel-sysrqc-rename-print_stack_trace.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

