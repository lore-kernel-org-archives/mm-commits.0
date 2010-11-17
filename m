From: akpm@linux-foundation.org
Subject: + kmsg_dump-constrain-mtdoops-and-ramoops-to-perform-their-actions-only-for-kmsg_dump_panic.patch added to -mm tree
Date: Wed, 17 Nov 2010 12:45:28 -0800
Message-ID: <201011172045.oAHKjS8D004237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933011Ab0KQUqJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Nov 2010 15:46:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: seiji.aguchi@hds.com, dwmw2@infradead.org, marco.stornelli@gmail.com


The patch titled
     kmsg_dump: constrain mtdoops and ramoops to perform their actions only for KMSG_DUMP_PANIC
has been added to the -mm tree.  Its filename is
     kmsg_dump-constrain-mtdoops-and-ramoops-to-perform-their-actions-only-for-kmsg_dump_panic.patch

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
Subject: kmsg_dump: constrain mtdoops and ramoops to perform their actions only for KMSG_DUMP_PANIC
From: Seiji Aguchi <seiji.aguchi@hds.com>

This series aims to develop logging facility for enterprise use.

It is important to save kernel messages reliably on enterprise system
because they are helpful for diagnosing system.

This series add kmsg_dump() to the paths loosing kernel messages.  The use
case is the following.

[Use case of reboot/poweroff/halt/emergency_restart]

 My company has often experienced the followings in our support service.
 - Customer's system suddenly reboots.
 - Customers ask us to investigate the reason of the reboot.

We recognize the fact itself because boot messages remain in
/var/log/messages.  However, we can't investigate the reason why the
system rebooted, because the last messages don't remain.  And off course
we can't explain the reason.

We can solve above problem with this patch as follows.

 Case1: reboot with command 
   - We can see "Restarting system with command:" or ""Restarting system.".

 Case2: halt with command
   - We can see "System halted.".

 Case3: poweroff with command
   - We can see " Power down.".

 Case4: emergency_restart with sysrq.
   - We can see "Sysrq:" outputted in __handle_sysrq().

 Case5: emergency_restart with softdog.
   - We can see "Initiating system reboot" in watchdog_fire().

So, we can distinguish the reason of reboot, poweroff, halt and emergency_restart.

If customer executed reboot command, you may think the customer should
know the fact.  However, they often claim they don't execute the command
when they rebooted system by mistake.

No message remains on the current Linux kernel, so we can't show the proof
to the customer.  This patch improves this situation.


This patch:

Alters mtdoops and ramoops to perform their actions only for
KMSG_DUMP_PANIC, KMSG_DUMP_OOPS and KMSG_DUMP_KEXEC because they would
like to log crashes only.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c |    5 +++++
 drivers/mtd/mtdoops.c  |    5 +++++
 2 files changed, 10 insertions(+)

diff -puN drivers/char/ramoops.c~kmsg_dump-constrain-mtdoops-and-ramoops-to-perform-their-actions-only-for-kmsg_dump_panic drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~kmsg_dump-constrain-mtdoops-and-ramoops-to-perform-their-actions-only-for-kmsg_dump_panic
+++ a/drivers/char/ramoops.c
@@ -69,6 +69,11 @@ static void ramoops_do_dump(struct kmsg_
 	char *buf;
 	struct timeval timestamp;
 
+	if (reason != KMSG_DUMP_OOPS &&
+	    reason != KMSG_DUMP_PANIC &&
+	    reason != KMSG_DUMP_KEXEC)
+		return;
+
 	/* Only dump oopses if dump_oops is set */
 	if (reason == KMSG_DUMP_OOPS && !dump_oops)
 		return;
diff -puN drivers/mtd/mtdoops.c~kmsg_dump-constrain-mtdoops-and-ramoops-to-perform-their-actions-only-for-kmsg_dump_panic drivers/mtd/mtdoops.c
--- a/drivers/mtd/mtdoops.c~kmsg_dump-constrain-mtdoops-and-ramoops-to-perform-their-actions-only-for-kmsg_dump_panic
+++ a/drivers/mtd/mtdoops.c
@@ -307,6 +307,11 @@ static void mtdoops_do_dump(struct kmsg_
 	unsigned long l1_cpy, l2_cpy;
 	char *dst;
 
+	if (reason != KMSG_DUMP_OOPS &&
+	    reason != KMSG_DUMP_PANIC &&
+	    reason != KMSG_DUMP_KEXEC)
+		return;
+
 	/* Only dump oopses if dump_oops is set */
 	if (reason == KMSG_DUMP_OOPS && !dump_oops)
 		return;
_

Patches currently in -mm which might be from seiji.aguchi@hds.com are

kmsg_dump-constrain-mtdoops-and-ramoops-to-perform-their-actions-only-for-kmsg_dump_panic.patch
kmsg_dump-add-kmsg_dump-calls-to-the-reboot-halt-poweroff-and-emergency_restart-paths.patch

