From: akpm@linux-foundation.org
Subject: + sgi-xp-handle-non-fatal-traps.patch added to -mm tree
Date: Tue, 18 Dec 2012 12:01:30 -0800
Message-ID: <20121218200132.A082020004E__22713.5374247611$1355860924$gmane$org@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:33757 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab2LRUBf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:01:35 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so69588lbc.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:01:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, mingo@elte.hu, stable@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: SGI-XP: handle non-fatal traps
has been added to the -mm tree.  Its filename is
     sgi-xp-handle-non-fatal-traps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: SGI-XP: handle non-fatal traps

We found a user code which was raising a divide-by-zero trap.  That trap
would lead to XPC connections between system-partitions being torn down
due to the die_chain notifier callouts it received.

This also revealed a different issue where multiple callers into
xpc_die_deactivate() would all attempt to do the disconnect in parallel
which would sometimes lock up but often overwhelm the console on very
large machines as each would print at least one line of output at the end
of the deactivate.

I reviewed all the users of the die_chain notifier and changed the code to
ignore the notifier callouts for reasons which will not actually lead to a
system to continue on to call die().

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc_main.c |   32 +++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-handle-non-fatal-traps drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-handle-non-fatal-traps
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -53,6 +53,8 @@
 #include <linux/kthread.h>
 #include "xpc.h"
 
+#include <asm/traps.h>
+
 /* define two XPC debug device structures to be used with dev_dbg() et al */
 
 struct device_driver xpc_dbg_name = {
@@ -1079,6 +1081,9 @@ xpc_system_reboot(struct notifier_block 
 	return NOTIFY_DONE;
 }
 
+/* Used to only allow one cpu to complete disconnect */
+static unsigned int xpc_die_disconnecting;
+
 /*
  * Notify other partitions to deactivate from us by first disengaging from all
  * references to our memory.
@@ -1092,6 +1097,9 @@ xpc_die_deactivate(void)
 	long keep_waiting;
 	long wait_to_print;
 
+	if (cmpxchg(&xpc_die_disconnecting, 0, 1))
+		return;
+
 	/* keep xpc_hb_checker thread from doing anything (just in case) */
 	xpc_exiting = 1;
 
@@ -1159,7 +1167,7 @@ xpc_die_deactivate(void)
  * about the lack of a heartbeat.
  */
 static int
-xpc_system_die(struct notifier_block *nb, unsigned long event, void *unused)
+xpc_system_die(struct notifier_block *nb, unsigned long event, void *_die_args)
 {
 #ifdef CONFIG_IA64		/* !!! temporary kludge */
 	switch (event) {
@@ -1191,7 +1199,27 @@ xpc_system_die(struct notifier_block *nb
 		break;
 	}
 #else
-	xpc_die_deactivate();
+	struct die_args *die_args = _die_args;
+
+	switch (event) {
+	case DIE_TRAP:
+		if (die_args->trapnr == X86_TRAP_DF)
+			xpc_die_deactivate();
+
+		if (((die_args->trapnr == X86_TRAP_MF) ||
+		     (die_args->trapnr == X86_TRAP_XF)) &&
+		    !user_mode_vm(die_args->regs))
+			xpc_die_deactivate();
+
+		break;
+	case DIE_INT3:
+	case DIE_DEBUG:
+		break;
+	case DIE_OOPS:
+	case DIE_GPF:
+	default:
+		xpc_die_deactivate();
+	}
 #endif
 
 	return NOTIFY_DONE;
_

Patches currently in -mm which might be from holt@sgi.com are

sgi-xp-handle-non-fatal-traps.patch
sgi-xp-handle-non-fatal-traps-fix.patch

