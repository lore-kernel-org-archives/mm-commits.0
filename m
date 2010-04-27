From: akpm@linux-foundation.org
Subject: [merged] x86-apbt-conditionally-register-cpu-hp-notifier-for-apbt.patch removed from -mm tree
Date: Tue, 27 Apr 2010 11:01:51 -0400
Message-ID: <201004271803.o3RI3OCn010988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756449Ab0D0SE6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 14:04:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacob.jun.pan@linux.intel.com, hpa@zytor.com, jaegerandi@gmail.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86/apbt: conditionally register cpu hp notifier for apbt
has been removed from the -mm tree.  Its filename was
     x86-apbt-conditionally-register-cpu-hp-notifier-for-apbt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

