From: akpm@linux-foundation.org
Subject: - fix-smp-poweroff-hangs.patch removed from -mm tree
Date: Tue, 02 Oct 2007 15:54:55 -0700
Message-ID: <200710022254.l92Mst8T026745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753351AbXJBWzw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2007 18:55:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkml@rtr.ca, mlord@pobox.com, rjw@sisk.pl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Fix SMP poweroff hangs
has been removed from the -mm tree.  Its filename was
     fix-smp-poweroff-hangs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix SMP poweroff hangs
From: Mark Lord <lkml@rtr.ca>

We need to disable all CPUs other than the boot CPU (usually 0) before
attempting to power-off modern SMP machines.  This fixes the
hang-on-poweroff issue on my MythTV SMP box, and also on Thomas Gleixner's
new toybox.

Signed-off-by: Mark Lord <mlord@pobox.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/sys.c~fix-smp-poweroff-hangs kernel/sys.c
--- a/kernel/sys.c~fix-smp-poweroff-hangs
+++ a/kernel/sys.c
@@ -32,6 +32,7 @@
 #include <linux/getcpu.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/seccomp.h>
+#include <linux/cpu.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -878,6 +879,7 @@ void kernel_power_off(void)
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
+	disable_nonboot_cpus();
 	sysdev_shutdown();
 	printk(KERN_EMERG "Power down.\n");
 	machine_power_off();
_

Patches currently in -mm which might be from lkml@rtr.ca are

acpi-fix-bdc-handling-in-drivers-acpi-sleep-procc.patch
rtc-fix-readback-from-sys-class-rtc-rtc-wakealarm.patch
