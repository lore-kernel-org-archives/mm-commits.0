From: akpm@linux-foundation.org
Subject: + kmsg_dump-dont-run-on-non-error-paths-by-default.patch added to -mm tree
Date: Tue, 14 Feb 2012 13:09:10 -0800
Message-ID: <20120214210910.8D905A01FC@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:41209 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab2BNVJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 16:09:11 -0500
Received: by ghrr17 with SMTP id r17so53665ghr.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 13:09:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, Artem.Bityutskiy@nokia.com, dwmw2@infradead.org, dzickus@redhat.com, kosaki.motohiro@jp.fujitsu.com, marco.stornelli@gmail.com, seiji.aguchi@hds.com, vgoyal@redhat.com


The patch titled
     Subject: kmsg_dump: don't run on non-error paths by default
has been added to the -mm tree.  Its filename is
     kmsg_dump-dont-run-on-non-error-paths-by-default.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Garrett <mjg@redhat.com>
Subject: kmsg_dump: don't run on non-error paths by default

Since 04c6862c055fb687c9 ("kmsg_dump: add kmsg_dump() calls to the reboot,
halt, poweroff and emergency_restart paths"), kmsg_dump() gets run on
normal paths including poweroff and reboot.  This is less than ideal given
pstore implementations that can only represent single backtraces, since a
reboot may overwrite a stored oops before it's been picked up by
userspace.  In addition, some pstore backends may have low performance and
provide a significant delay in reboot as a result.

This patch adds a printk.always_kmsg_dump kernel parameter (which can also
be changed from userspace).  Without it, the code will only be run on
failure paths rather than on normal paths.  The option can be enabled in
environments where there's a desire to attempt to audit whether or not a
reboot was cleanly requested or not.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 ++++++
 include/linux/kmsg_dump.h           |    9 +++++++--
 kernel/printk.c                     |    6 ++++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff -puN Documentation/kernel-parameters.txt~kmsg_dump-dont-run-on-non-error-paths-by-default Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~kmsg_dump-dont-run-on-non-error-paths-by-default
+++ a/Documentation/kernel-parameters.txt
@@ -2227,6 +2227,12 @@ bytes respectively. Such letter suffixes
 
 			default: off.
 
+	printk.always_kmsg_dump=
+			Trigger kmsg_dump for cases other than kernel oops or
+			panics
+			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
+			default: disabled
+
 	printk.time=	Show timing data prefixed to each printk message line
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 
diff -puN include/linux/kmsg_dump.h~kmsg_dump-dont-run-on-non-error-paths-by-default include/linux/kmsg_dump.h
--- a/include/linux/kmsg_dump.h~kmsg_dump-dont-run-on-non-error-paths-by-default
+++ a/include/linux/kmsg_dump.h
@@ -15,13 +15,18 @@
 #include <linux/errno.h>
 #include <linux/list.h>
 
+/*
+ * Keep this list arranged in rough order of priority. Anything listed after
+ * KMSG_DUMP_OOPS will not be logged by default unless printk.always_kmsg_dump
+ * is passed to the kernel.
+ */
 enum kmsg_dump_reason {
-	KMSG_DUMP_OOPS,
 	KMSG_DUMP_PANIC,
+	KMSG_DUMP_OOPS,
+	KMSG_DUMP_EMERG,
 	KMSG_DUMP_RESTART,
 	KMSG_DUMP_HALT,
 	KMSG_DUMP_POWEROFF,
-	KMSG_DUMP_EMERG,
 };
 
 /**
diff -puN kernel/printk.c~kmsg_dump-dont-run-on-non-error-paths-by-default kernel/printk.c
--- a/kernel/printk.c~kmsg_dump-dont-run-on-non-error-paths-by-default
+++ a/kernel/printk.c
@@ -702,6 +702,9 @@ static bool printk_time = 0;
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
+static bool always_kmsg_dump;
+module_param_named(always_kmsg_dump, always_kmsg_dump, bool, S_IRUGO | S_IWUSR);
+
 /* Check if we have any console registered that can be called early in boot. */
 static int have_callable_console(void)
 {
@@ -1732,6 +1735,9 @@ void kmsg_dump(enum kmsg_dump_reason rea
 	unsigned long l1, l2;
 	unsigned long flags;
 
+	if ((reason > KMSG_DUMP_OOPS) && !always_kmsg_dump)
+		return;
+
 	/* Theoretically, the log could move on after we do this, but
 	   there's not a lot we can do about that. The new messages
 	   will overwrite the start of what we dump. */
_
Subject: Subject: kmsg_dump: don't run on non-error paths by default

Patches currently in -mm which might be from mjg@redhat.com are

linux-next.patch
kmsg_dump-dont-run-on-non-error-paths-by-default.patch
acerhdf-add-support-for-aspire-1410-bios-v13314.patch
acerhdf-add-support-for-new-hardware.patch
acerhdf-lowered-default-temp-fanon-fanoff-values.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
geos-platform-driver-for-geos-and-geos2-single-board-computers.patch
platform-drivers-x86-convert-drivers-platform-x86-to-use-module_platform_driver.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
platform-x86-kill-off-moorestown.patch
intel_scu_ipc-remove-moorestown-support.patch
platform-x86-intel_mid_thermal-add-msic_thermal-alias.patch
platform-x86-intel_mid_thermal-convert-to-use-intel-msic-api.patch
platform-x86-intel_mid_thermal-turn-off-thermistor-voltage-by-default.patch
intel_mid_powerbtn-use-msic-read-write-instead-of-ipc_scu.patch
intel_mid_powerbtn-mark-irq-as-irqf_no_suspend.patch
alix2-supplement-driver-to-include-gpio-button-support.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
hrtimers-special-case-zero-length-sleeps.patch
ipmi-increase-kcs-timeouts.patch

