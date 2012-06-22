From: akpm@linux-foundation.org
Subject: + reboot-disable-nonboot-cpus.patch added to -mm tree
Date: Fri, 22 Jun 2012 13:57:09 -0700
Message-ID: <20120622205709.CCA90A0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:34178 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111Ab2FVU5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jun 2012 16:57:11 -0400
Received: by qcha6 with SMTP id a6so269162qch.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Jun 2012 13:57:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: per.forlin@stericsson.com, gorcunov@openvz.org, hpa@zytor.com, keescook@chromium.org, linus.walleij@linaro.org, mingo@kernel.org, serue@us.ibm.com, tglx@linutronix.de


The patch titled
     Subject: reboot: disable nonboot CPUs
has been added to the -mm tree.  Its filename is
     reboot-disable-nonboot-cpus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Per Forlin <per.forlin@stericsson.com>
Subject: reboot: disable nonboot CPUs

I have run into an issue on an ARM platform that prevents reboot unless
the nonboot CPUs are brought down safetly.  

Disable the nonboot CPUs to safely migrate tasks and interrupts to the
boot CPU.  This will prevent the nonboot CPUs to interfer or block the
boot CPU from being able to reboot the system successfully.

Is there a reason for disabling nonboot CPUs for power_off but not reboot?

I could make this patch ARM specific but I thought that other ARCHs may
benefit from this patch too.

Signed-off-by: Per Forlin <per.forlin@stericsson.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/sys.c~reboot-disable-nonboot-cpus kernel/sys.c
--- a/kernel/sys.c~reboot-disable-nonboot-cpus
+++ a/kernel/sys.c
@@ -323,6 +323,7 @@ void kernel_restart_prepare(char *cmd)
 	system_state = SYSTEM_RESTART;
 	usermodehelper_disable();
 	device_shutdown();
+	disable_nonboot_cpus();
 	syscore_shutdown();
 }
 
_
Subject: Subject: reboot: disable nonboot CPUs

Patches currently in -mm which might be from per.forlin@stericsson.com are

reboot-disable-nonboot-cpus.patch

