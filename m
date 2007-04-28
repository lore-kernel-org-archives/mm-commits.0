From: akpm@linux-foundation.org
Subject: + uml-virtualized-time-fix.patch added to -mm tree
Date: Fri, 27 Apr 2007 17:09:55 -0700
Message-ID: <200704280009.l3S09tOO011238@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757942AbXD1AJ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 20:09:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: virtualized time fix
has been added to the -mm tree.  Its filename is
     uml-virtualized-time-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: virtualized time fix
From: Jeff Dike <jdike@addtoit.com>

With the current timekeeping, !CONFIG_UML_REAL_TIME_CLOCK has
inconsistent behavior.  Previously, gettimeofday could be (and was)
isolated from the clock ticking.  Now, it's not, so when
CONFIG_UML_REAL_TIME_CLOCK is disabled, gettimeofday must progress in
lockstep with the clock, making it fully virtual.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/time.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff -puN arch/um/kernel/time.c~uml-virtualized-time-fix arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-virtualized-time-fix
+++ a/arch/um/kernel/time.c
@@ -34,8 +34,8 @@ unsigned long long sched_clock(void)
 	return (unsigned long long)jiffies_64 * (1000000000 / HZ);
 }
 
-static unsigned long long prev_nsecs[NR_CPUS];
 #ifdef CONFIG_UML_REAL_TIME_CLOCK
+static unsigned long long prev_nsecs[NR_CPUS];
 static long long delta[NR_CPUS];		/* Deviation per interval */
 #endif
 
@@ -94,7 +94,12 @@ irqreturn_t um_timer(int irq, void *dev)
 
 	do_timer(1);
 
+#ifdef CONFIG_UML_REAL_TIME_CLOCK
 	nsecs = get_time();
+#else
+	nsecs = (unsigned long long) xtime.tv_sec * BILLION + xtime.tv_nsec +
+		BILLION / HZ;
+#endif
 	xtime.tv_sec = nsecs / NSEC_PER_SEC;
 	xtime.tv_nsec = nsecs - xtime.tv_sec * NSEC_PER_SEC;
 
@@ -127,13 +132,18 @@ void time_init(void)
 	nsecs = os_nsecs();
 	set_normalized_timespec(&wall_to_monotonic, -nsecs / BILLION,
 				-nsecs % BILLION);
+	set_normalized_timespec(&xtime, nsecs / BILLION, nsecs % BILLION);
 	late_time_init = register_timer;
 }
 
 void do_gettimeofday(struct timeval *tv)
 {
+#ifdef CONFIG_UML_REAL_TIME_CLOCK
 	unsigned long long nsecs = get_time();
-
+#else
+	unsigned long long nsecs = (unsigned long long) xtime.tv_sec * BILLION +
+		xtime.tv_nsec;
+#endif
 	tv->tv_sec = nsecs / NSEC_PER_SEC;
 	/* Careful about calculations here - this was originally done as
 	 * (nsecs - tv->tv_sec * NSEC_PER_SEC) / NSEC_PER_USEC
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch
uml-no-locking-needed-in-tlsc.patch
uml-tidy-processc.patch
uml-tidy-processc-fix.patch
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
uml-tidy-fault-code.patch
uml-kernel-segfaults-should-dump-proper-registers.patch
uml-comment-early-boot-locking.patch
uml-irq-locking-commentary.patch
uml-delete-host_frame_size.patch
uml-drivers-get-release-methods.patch
uml-dump-registers-on-ptrace-or-wait-failure.patch
uml-speed-up-page-table-walking.patch
uml-remove-unused-x86_64-code.patch
uml-start-fixing-os_read_file-and-os_write_file.patch
uml-tidy-libc-code.patch
uml-convert-libc-layer-to-call-read-and-write.patch
uml-batch-i-o-requests.patch
uml-send-pointers-instead-of-structures-to-i-o-thread.patch
uml-dump-core-on-panic.patch
uml-dont-try-to-handle-signals-on-initial-process-stack.patch
uml-change-remaining-callers-of-os_read_write_file.patch
uml-formatting-fixes-around-os_read_write_file-callers.patch
uml-remove-debugging-remnants.patch
uml-rename-os_read_write_file_k-back-to-os_read_write_file.patch
uml-aio-deadlock-avoidance.patch
uml-speed-page-fault-path.patch
uml-eliminate-a-piece-of-debugging-code.patch
uml-more-page-fault-path-trimming.patch
uml-only-flush-areas-covered-by-vma.patch
uml-out-of-tmpfs-space-error-clarification.patch
uml-virtualized-time-fix.patch
