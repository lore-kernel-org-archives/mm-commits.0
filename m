From: akpm@linux-foundation.org
Subject: + kernel-panicc-display-reason-at-end-pr_emerg.patch added to -mm tree
Date: Tue, 11 Feb 2014 15:34:54 -0800
Message-ID: <52fab39e.fGFaT2oPLanVoJ0s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaBKXez (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 18:34:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + kernel-panicc-display-reason-at-end-pr_emerg.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 15:34:54 -0800


The patch titled
     Subject: kernel/panic.c: display reason at end + pr_emerg
has been added to the -mm tree.  Its filename is
     kernel-panicc-display-reason-at-end-pr_emerg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-panicc-display-reason-at-end-pr_emerg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-panicc-display-reason-at-end-pr_emerg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/panic.c: display reason at end + pr_emerg

Currently, booting without initrd specified on 80x25 screen gives a call
trace followed by atkbd : Spurious ACK.  Original message ("VFS: Unable to
mount root fs") is not available.  Of course this could happen in other
situations...

This patch displays panic reason after call trace which could help lot of
people even if it's not the very last line on screen.

Also, convert all panic.c printk(KERN_EMERG to pr_emerg(

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/panic.c~kernel-panicc-display-reason-at-end-pr_emerg kernel/panic.c
--- a/kernel/panic.c~kernel-panicc-display-reason-at-end-pr_emerg
+++ a/kernel/panic.c
@@ -100,7 +100,7 @@ void panic(const char *fmt, ...)
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
+	pr_emerg("Kernel panic - not syncing: %s\n", buf);
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 	/*
 	 * Avoid nested stack-dumping if a panic occurs during oops processing
@@ -141,7 +141,7 @@ void panic(const char *fmt, ...)
 		 * Delay timeout seconds before rebooting the machine.
 		 * We can't use the "normal" timers since we just panicked.
 		 */
-		printk(KERN_EMERG "Rebooting in %d seconds..", panic_timeout);
+		pr_emerg("Rebooting in %d seconds..", panic_timeout);
 
 		for (i = 0; i < panic_timeout * 1000; i += PANIC_TIMER_STEP) {
 			touch_nmi_watchdog();
@@ -165,7 +165,7 @@ void panic(const char *fmt, ...)
 		extern int stop_a_enabled;
 		/* Make sure the user can actually press Stop-A (L1-A) */
 		stop_a_enabled = 1;
-		printk(KERN_EMERG "Press Stop-A (L1-A) to return to the boot prom\n");
+		pr_emerg("Press Stop-A (L1-A) to return to the boot prom\n");
 	}
 #endif
 #if defined(CONFIG_S390)
@@ -176,6 +176,7 @@ void panic(const char *fmt, ...)
 		disabled_wait(caller);
 	}
 #endif
+	pr_emerg("---[ end Kernel panic - not syncing: %s\n", buf);
 	local_irq_enable();
 	for (i = 0; ; i += PANIC_TIMER_STEP) {
 		touch_softlockup_watchdog();
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
fs-efs-superc-add-__init-to-init_inodecache.patch
fs-minix-inodec-add-__init-to-init_inodecache.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch
fs-udf-superc-add-__init-to-init_inodecache.patch

