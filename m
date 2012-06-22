From: akpm@linux-foundation.org
Subject: [nacked] reboot-disable-nonboot-cpus.patch removed from -mm tree
Date: Fri, 22 Jun 2012 14:39:41 -0700
Message-ID: <20120622213941.93AF1A016C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:41377 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab2FVVjm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jun 2012 17:39:42 -0400
Received: by ggeh3 with SMTP id h3so244553gge.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Jun 2012 14:39:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: per.forlin@stericsson.com, gorcunov@openvz.org, hpa@zytor.com, keescook@chromium.org, linus.walleij@linaro.org, mingo@kernel.org, serue@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: reboot: disable nonboot CPUs
has been removed from the -mm tree.  Its filename was
     reboot-disable-nonboot-cpus.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from per.forlin@stericsson.com are


