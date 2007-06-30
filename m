From: akpm@linux-foundation.org
Subject: - beeping-patch-for-debugging-acpi-sleep.patch removed from -mm tree
Date: Sat, 30 Jun 2007 03:23:06 -0700
Message-ID: <200706301023.l5UAN6qN026078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58419 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755280AbXF3KXj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 30 Jun 2007 06:23:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, pavel@suse.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     beeping patch for debugging acpi sleep
has been removed from the -mm tree.  Its filename was
     beeping-patch-for-debugging-acpi-sleep.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: beeping patch for debugging acpi sleep
From: Pavel Machek <pavel@ucw.cz>

Starting beeper as soon as ACPI sleep returns is very useful in debugging
"apparently dead" machines.  If it beeps at all, it makes sense to start
playing with CMOS tracer.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/wakeup.S |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/acpi/wakeup.S~beeping-patch-for-debugging-acpi-sleep arch/i386/kernel/acpi/wakeup.S
--- a/arch/i386/kernel/acpi/wakeup.S~beeping-patch-for-debugging-acpi-sleep
+++ a/arch/i386/kernel/acpi/wakeup.S
@@ -11,7 +11,22 @@
 #
 # If physical address of wakeup_code is 0x12345, BIOS should call us with
 # cs = 0x1234, eip = 0x05
-# 
+#
+
+#define BEEP \
+	inb	$97, %al; 	\
+	outb	%al, $0x80; 	\
+	movb	$3, %al; 	\
+	outb	%al, $97; 	\
+	outb	%al, $0x80; 	\
+	movb	$-74, %al; 	\
+	outb	%al, $67; 	\
+	outb	%al, $0x80; 	\
+	movb	$-119, %al; 	\
+	outb	%al, $66; 	\
+	outb	%al, $0x80; 	\
+	movb	$15, %al; 	\
+	outb	%al, $66;
 
 ALIGN
 	.align	4096
@@ -20,6 +35,9 @@ wakeup_code:
 	wakeup_code_start = .
 	.code16
 
+# Uncomment this to make your computer start producing ugly noise as soon
+# as BIOS returns to this real-mode entry point.
+#	BEEP
  	movw	$0xb800, %ax
 	movw	%ax,%fs
 	movw	$0x0e00 + 'L', %fs:(0x10)
_

Patches currently in -mm which might be from pavel@ucw.cz are

pm-introduce-set_target-method-in-pm_ops.patch
acpi-do-not-attempt-to-run-s1-standby-workarounds-while-hibernating.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
x86_64-pm_trace-support.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
i386-do-not-restore-reserved-memory-after-hibernation-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-introduce-hibernation-and-suspend-notifiers-fix.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-introduce-hibernation-and-suspend-notifiers-fix-fix.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
pm-disable-usermode-helper-before-hibernation-and-suspend-fix.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
pm-reduce-code-duplication-between-mainc-and-userc-updated.patch
beeping-patch-for-debugging-acpi-sleep.patch
