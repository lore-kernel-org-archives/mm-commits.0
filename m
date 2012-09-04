From: akpm@linux-foundation.org
Subject: + kernel-sysc-call-disable_nonboot_cpus-in-kernel_restart.patch added to -mm tree
Date: Tue, 04 Sep 2012 15:36:29 -0700
Message-ID: <20120904223629.8B3EF100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:59742 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896Ab2IDWgb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 18:36:31 -0400
Received: by vcqp1 with SMTP id p1so676198vcq.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 15:36:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shawn.guo@linaro.org


The patch titled
     Subject: kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()
has been added to the -mm tree.  Its filename is
     kernel-sysc-call-disable_nonboot_cpus-in-kernel_restart.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shawn Guo <shawn.guo@linaro.org>
Subject: kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()

As kernel_power_off() calls disable_nonboot_cpus(), we may also want to
have kernel_restart() call disable_nonboot_cpus().  Doing so can help
machines that require boot cpu be the last alive cpu during reboot to
survive with kernel restart.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
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

linux-next.patch
kernel-sysc-call-disable_nonboot_cpus-in-kernel_restart.patch
rtc-snvs-add-freescale-rtc-snvs-driver.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch

