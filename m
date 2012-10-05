From: akpm@linux-foundation.org
Subject: [merged] kernel-sysc-call-disable_nonboot_cpus-in-kernel_restart.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:13:59 -0700
Message-ID: <20121005201400.232AA5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:36851 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab2JEUOC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:14:02 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so139794wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:14:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shawn.guo@linaro.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()
has been removed from the -mm tree.  Its filename was
     kernel-sysc-call-disable_nonboot_cpus-in-kernel_restart.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shawn Guo <shawn.guo@linaro.org>
Subject: kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()

As kernel_power_off() calls disable_nonboot_cpus(), we may also want to
have kernel_restart() call disable_nonboot_cpus().  Doing so can help
machines that require boot cpu be the last alive cpu during reboot to
survive with kernel restart.

This fixes one reboot issue seen on imx6q (Cortex-A9 Quad).  The machine
requires that the restart routine be run on the primary cpu rather than
secondary ones.  Otherwise, the secondary core running the restart routine
will fail to come to online after reboot.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/sys.c~kernel-sysc-call-disable_nonboot_cpus-in-kernel_restart kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-call-disable_nonboot_cpus-in-kernel_restart
+++ a/kernel/sys.c
@@ -368,6 +368,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier
 void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
+	disable_nonboot_cpus();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
 	else
_

Patches currently in -mm which might be from shawn.guo@linaro.org are

origin.patch
linux-next.patch

