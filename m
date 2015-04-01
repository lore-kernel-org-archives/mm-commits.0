From: akpm@linux-foundation.org
Subject: + kernel-rebootc-add-orderly_reboot-for-graceful-reboot.patch
 added to -mm tree
Date: Wed, 01 Apr 2015 13:06:15 -0700
Message-ID: <551c4fb7.JbT3ujdZVlDllkf+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbbDAUGQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2015 16:06:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joel@jms.id.au, benh@kernel.crashing.org, davem@davemloft.net, fabf@skynet.be, jk@ozlabs.org, mpe@ellerman.id.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/reboot.c: add orderly_reboot for graceful reboot
has been added to the -mm tree.  Its filename is
     kernel-rebootc-add-orderly_reboot-for-graceful-reboot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-rebootc-add-orderly_reboot-for-graceful-reboot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-rebootc-add-orderly_reboot-for-graceful-reboot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joel Stanley <joel@jms.id.au>
Subject: kernel/reboot.c: add orderly_reboot for graceful reboot

The kernel has orderly_poweroff which allows the kernel to initiate a
graceful shutdown of userspace, by running /sbin/poweroff.  This adds
orderly_reboot that will cause userspace to shut itself down by calling
/sbin/reboot.

This will be used for shutdown initiated by a system controller on
platforms that do not use ACPI.

orderly_reboot() should be used when the system wants to allow userspace
to gracefully shut itself down.  For cases where the system may imminently
catch on fire, the existing emergency_restart() provides an immediate
reboot without involving userspace.

Signed-off-by: Joel Stanley <joel@jms.id.au>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reboot.h |    3 +-
 kernel/reboot.c        |   53 +++++++++++++++++++++++++++++++++++----
 2 files changed, 50 insertions(+), 6 deletions(-)

diff -puN include/linux/reboot.h~kernel-rebootc-add-orderly_reboot-for-graceful-reboot include/linux/reboot.h
--- a/include/linux/reboot.h~kernel-rebootc-add-orderly_reboot-for-graceful-reboot
+++ a/include/linux/reboot.h
@@ -70,7 +70,8 @@ void ctrl_alt_del(void);
 #define POWEROFF_CMD_PATH_LEN	256
 extern char poweroff_cmd[POWEROFF_CMD_PATH_LEN];
 
-extern int orderly_poweroff(bool force);
+extern void orderly_poweroff(bool force);
+extern void orderly_reboot(void);
 
 /*
  * Emergency restart, callable from an interrupt handler.
diff -puN kernel/reboot.c~kernel-rebootc-add-orderly_reboot-for-graceful-reboot kernel/reboot.c
--- a/kernel/reboot.c~kernel-rebootc-add-orderly_reboot-for-graceful-reboot
+++ a/kernel/reboot.c
@@ -387,8 +387,9 @@ void ctrl_alt_del(void)
 }
 
 char poweroff_cmd[POWEROFF_CMD_PATH_LEN] = "/sbin/poweroff";
+static const char reboot_cmd[] = "/sbin/reboot";
 
-static int __orderly_poweroff(bool force)
+static int run_cmd(const char *cmd)
 {
 	char **argv;
 	static char *envp[] = {
@@ -397,8 +398,7 @@ static int __orderly_poweroff(bool force
 		NULL
 	};
 	int ret;
-
-	argv = argv_split(GFP_KERNEL, poweroff_cmd, NULL);
+	argv = argv_split(GFP_KERNEL, cmd, NULL);
 	if (argv) {
 		ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
 		argv_free(argv);
@@ -406,8 +406,33 @@ static int __orderly_poweroff(bool force
 		ret = -ENOMEM;
 	}
 
+	return ret;
+}
+
+static int __orderly_reboot(void)
+{
+	int ret;
+
+	ret = run_cmd(reboot_cmd);
+
+	if (ret) {
+		pr_warn("Failed to start orderly reboot: forcing the issue\n");
+		emergency_sync();
+		kernel_restart(NULL);
+	}
+
+	return ret;
+}
+
+static int __orderly_poweroff(bool force)
+{
+	int ret;
+
+	ret = run_cmd(poweroff_cmd);
+
 	if (ret && force) {
 		pr_warn("Failed to start orderly shutdown: forcing the issue\n");
+
 		/*
 		 * I guess this should try to kick off some daemon to sync and
 		 * poweroff asap.  Or not even bother syncing if we're doing an
@@ -436,15 +461,33 @@ static DECLARE_WORK(poweroff_work, power
  * This may be called from any context to trigger a system shutdown.
  * If the orderly shutdown fails, it will force an immediate shutdown.
  */
-int orderly_poweroff(bool force)
+void orderly_poweroff(bool force)
 {
 	if (force) /* do not override the pending "true" */
 		poweroff_force = true;
 	schedule_work(&poweroff_work);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(orderly_poweroff);
 
+static void reboot_work_func(struct work_struct *work)
+{
+	__orderly_reboot();
+}
+
+static DECLARE_WORK(reboot_work, reboot_work_func);
+
+/**
+ * orderly_reboot - Trigger an orderly system reboot
+ *
+ * This may be called from any context to trigger a system reboot.
+ * If the orderly reboot fails, it will force an immediate reboot.
+ */
+void orderly_reboot(void)
+{
+	schedule_work(&reboot_work);
+}
+EXPORT_SYMBOL_GPL(orderly_reboot);
+
 static int __init reboot_setup(char *str)
 {
 	for (;;) {
_

Patches currently in -mm which might be from joel@jms.id.au are

envctrl-ignore-orderly_poweroff-return-value.patch
kernel-rebootc-add-orderly_reboot-for-graceful-reboot.patch
powerpc-powernv-reboot-when-requested-by-firmware.patch
linux-next.patch

