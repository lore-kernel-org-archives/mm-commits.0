From: akpm@linux-foundation.org
Subject: + fix-smp-poweroff-hangs.patch added to -mm tree
Date: Fri, 28 Sep 2007 13:12:07 -0700
Message-ID: <200709282012.l8SKC7l8015565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33784 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713AbXI1UNO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 16:13:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lkml@rtr.ca, mlord@pobox.com, rjw@sisk.pl, tglx@linutronix.de


The patch titled
     Fix SMP poweroff hangs
has been added to the -mm tree.  Its filename is
     fix-smp-poweroff-hangs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
diff -puN kernel/sys.c.orig~fix-smp-poweroff-hangs kernel/sys.c.orig
_

Patches currently in -mm which might be from lkml@rtr.ca are

fix-smp-poweroff-hangs.patch
acpi-fix-bdc-handling-in-drivers-acpi-sleep-procc.patch
rtc-fix-readback-from-sys-class-rtc-rtc-wakealarm.patch
