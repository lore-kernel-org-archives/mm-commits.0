From: akpm@linux-foundation.org
Subject: + x86-apbt-conditionally-register-cpu-hp-notifier-for-apbt.patch added to -mm tree
Date: Tue, 20 Apr 2010 14:26:41 -0700
Message-ID: <201004202126.o3KLQfPU011206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755039Ab0DTV06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Apr 2010 17:26:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacob.jun.pan@linux.intel.com, hpa@zytor.com, jaegerandi@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86/apbt: conditionally register cpu hp notifier for apbt
has been added to the -mm tree.  Its filename is
     x86-apbt-conditionally-register-cpu-hp-notifier-for-apbt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86/apbt: conditionally register cpu hp notifier for apbt
From: Jacob Pan <jacob.jun.pan@linux.intel.com>

APB timer is used on Moorestown platforms but not on a standard PC.
If APB timer code is compiled in but not initialized at run-time due
to lack of FW reported SFI table, kernel would panic when the non-boot
CPUs are offlined and notifier is called.

This patch ensures CPU hotplug notifier for APB timer is only registered
when the APBT timer block is initialized.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=15786

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Reported-by: Andreas Jaeger <jaegerandi@gmail.com>
Tested-by: Andreas Jaeger <jaegerandi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apb_timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/apb_timer.c~x86-apbt-conditionally-register-cpu-hp-notifier-for-apbt arch/x86/kernel/apb_timer.c
--- a/arch/x86/kernel/apb_timer.c~x86-apbt-conditionally-register-cpu-hp-notifier-for-apbt
+++ a/arch/x86/kernel/apb_timer.c
@@ -429,7 +429,7 @@ static int apbt_cpuhp_notify(struct noti
 
 static __init int apbt_late_init(void)
 {
-	if (disable_apbt_percpu)
+	if (disable_apbt_percpu || !apb_timer_block_enabled)
 		return 0;
 	/* This notifier should be called after workqueue is ready */
 	hotcpu_notifier(apbt_cpuhp_notify, -20);
_

Patches currently in -mm which might be from jacob.jun.pan@linux.intel.com are

x86-apbt-conditionally-register-cpu-hp-notifier-for-apbt.patch

