From: akpm@linux-foundation.org
Subject: + ipmi-run-to-completion-fixes.patch added to -mm tree
Date: Wed, 13 Feb 2008 15:28:23 -0800
Message-ID: <200802132328.m1DNSNNK019556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52080 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758387AbYBMX3c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 18:29:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cminyard@mvista.com


The patch titled
     ipmi: run to completion fixes
has been added to the -mm tree.  Its filename is
     ipmi-run-to-completion-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: run to completion fixes
From: Corey Minyard <cminyard@mvista.com>

The "run_to_completion" mode was somewhat broken.  Locks need to be avoided in
run_to_completion mode, and it shouldn't be used by normal users, just
internally for panic situations.

This patch removes locks in run_to_completion mode and removes the user call
for setting the mode.  The only user was the poweroff code, but it was easily
converted to use the polling interface.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |    8 ----
 drivers/char/ipmi/ipmi_poweroff.c   |   20 +++++++++---
 drivers/char/ipmi/ipmi_si_intf.c    |   42 +++++++++++---------------
 include/linux/ipmi.h                |   11 +-----
 4 files changed, 37 insertions(+), 44 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-run-to-completion-fixes drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-run-to-completion-fixes
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -1197,13 +1197,6 @@ int ipmi_unregister_for_cmd(ipmi_user_t 
 	return rv;
 }
 
-void ipmi_user_set_run_to_completion(ipmi_user_t user, int val)
-{
-	ipmi_smi_t intf = user->intf;
-	if (intf->handlers)
-		intf->handlers->set_run_to_completion(intf->send_info, val);
-}
-
 static unsigned char
 ipmb_checksum(unsigned char *data, int size)
 {
@@ -4190,5 +4183,4 @@ EXPORT_SYMBOL(ipmi_get_my_address);
 EXPORT_SYMBOL(ipmi_set_my_LUN);
 EXPORT_SYMBOL(ipmi_get_my_LUN);
 EXPORT_SYMBOL(ipmi_smi_add_proc_entry);
-EXPORT_SYMBOL(ipmi_user_set_run_to_completion);
 EXPORT_SYMBOL(ipmi_free_recv_msg);
diff -puN drivers/char/ipmi/ipmi_poweroff.c~ipmi-run-to-completion-fixes drivers/char/ipmi/ipmi_poweroff.c
--- a/drivers/char/ipmi/ipmi_poweroff.c~ipmi-run-to-completion-fixes
+++ a/drivers/char/ipmi/ipmi_poweroff.c
@@ -99,11 +99,14 @@ static unsigned char ipmi_version;
    allocate them, since we may be in a panic situation.  The whole
    thing is single-threaded, anyway, so multiple messages are not
    required. */
+static atomic_t dummy_count = ATOMIC_INIT(0);
 static void dummy_smi_free(struct ipmi_smi_msg *msg)
 {
+	atomic_dec(&dummy_count);
 }
 static void dummy_recv_free(struct ipmi_recv_msg *msg)
 {
+	atomic_dec(&dummy_count);
 }
 static struct ipmi_smi_msg halt_smi_msg =
 {
@@ -152,17 +155,28 @@ static int ipmi_request_wait_for_respons
 	return halt_recv_msg.msg.data[0];
 }
 
-/* We are in run-to-completion mode, no completion is desired. */
+/* Wait for message to complete, spinning. */
 static int ipmi_request_in_rc_mode(ipmi_user_t            user,
 				   struct ipmi_addr       *addr,
 				   struct kernel_ipmi_msg *send_msg)
 {
 	int rv;
 
+	atomic_set(&dummy_count, 2);
 	rv = ipmi_request_supply_msgs(user, addr, 0, send_msg, NULL,
 				      &halt_smi_msg, &halt_recv_msg, 0);
-	if (rv)
+	if (rv) {
+		atomic_set(&dummy_count, 0);
 		return rv;
+	}
+
+	/*
+	 * Spin until our message is done.
+	 */
+	while (atomic_read(&dummy_count) > 0) {
+		ipmi_poll_interface(user);
+		barrier();
+	}
 
 	return halt_recv_msg.msg.data[0];
 }
@@ -531,9 +545,7 @@ static void ipmi_poweroff_function (void
 		return;
 
 	/* Use run-to-completion mode, since interrupts may be off. */
-	ipmi_user_set_run_to_completion(ipmi_user, 1);
 	specific_poweroff_func(ipmi_user);
-	ipmi_user_set_run_to_completion(ipmi_user, 0);
 }
 
 /* Wait for an IPMI interface to be installed, the first one installed
diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-run-to-completion-fixes drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-run-to-completion-fixes
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -806,56 +806,54 @@ static void sender(void                *
 		return;
 	}
 
-	spin_lock_irqsave(&(smi_info->msg_lock), flags);
 #ifdef DEBUG_TIMING
 	do_gettimeofday(&t);
 	printk("**Enqueue: %d.%9.9d\n", t.tv_sec, t.tv_usec);
 #endif
 
 	if (smi_info->run_to_completion) {
-		/* If we are running to completion, then throw it in
-		   the list and run transactions until everything is
-		   clear.  Priority doesn't matter here. */
+		/*
+		 * If we are running to completion, then throw it in
+		 * the list and run transactions until everything is
+		 * clear.  Priority doesn't matter here.
+		 */
+
+		/*
+		 * Run to completion means we are single-threaded, no
+		 * need for locks.
+		 */
 		list_add_tail(&(msg->link), &(smi_info->xmit_msgs));
 
-		/* We have to release the msg lock and claim the smi
-		   lock in this case, because of race conditions. */
-		spin_unlock_irqrestore(&(smi_info->msg_lock), flags);
-
-		spin_lock_irqsave(&(smi_info->si_lock), flags);
 		result = smi_event_handler(smi_info, 0);
 		while (result != SI_SM_IDLE) {
 			udelay(SI_SHORT_TIMEOUT_USEC);
 			result = smi_event_handler(smi_info,
 						   SI_SHORT_TIMEOUT_USEC);
 		}
-		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
 		return;
+	}
+
+	spin_lock_irqsave(&smi_info->msg_lock, flags);
+	if (priority > 0) {
+		list_add_tail(&msg->link, &smi_info->hp_xmit_msgs);
 	} else {
-		if (priority > 0) {
-			list_add_tail(&(msg->link), &(smi_info->hp_xmit_msgs));
-		} else {
-			list_add_tail(&(msg->link), &(smi_info->xmit_msgs));
-		}
+		list_add_tail(&msg->link, &smi_info->xmit_msgs);
 	}
-	spin_unlock_irqrestore(&(smi_info->msg_lock), flags);
+	spin_unlock_irqrestore(&smi_info->msg_lock, flags);
 
-	spin_lock_irqsave(&(smi_info->si_lock), flags);
+	spin_lock_irqsave(&smi_info->si_lock, flags);
 	if ((smi_info->si_state == SI_NORMAL)
 	    && (smi_info->curr_msg == NULL))
 	{
 		start_next_msg(smi_info);
 	}
-	spin_unlock_irqrestore(&(smi_info->si_lock), flags);
+	spin_unlock_irqrestore(&smi_info->si_lock, flags);
 }
 
 static void set_run_to_completion(void *send_info, int i_run_to_completion)
 {
 	struct smi_info   *smi_info = send_info;
 	enum si_sm_result result;
-	unsigned long     flags;
-
-	spin_lock_irqsave(&(smi_info->si_lock), flags);
 
 	smi_info->run_to_completion = i_run_to_completion;
 	if (i_run_to_completion) {
@@ -866,8 +864,6 @@ static void set_run_to_completion(void *
 						   SI_SHORT_TIMEOUT_USEC);
 		}
 	}
-
-	spin_unlock_irqrestore(&(smi_info->si_lock), flags);
 }
 
 static int ipmi_thread(void *data)
diff -puN include/linux/ipmi.h~ipmi-run-to-completion-fixes include/linux/ipmi.h
--- a/include/linux/ipmi.h~ipmi-run-to-completion-fixes
+++ a/include/linux/ipmi.h
@@ -368,9 +368,8 @@ int ipmi_request_supply_msgs(ipmi_user_t
  * Poll the IPMI interface for the user.  This causes the IPMI code to
  * do an immediate check for information from the driver and handle
  * anything that is immediately pending.  This will not block in any
- * way.  This is useful if you need to implement polling from the user
- * for things like modifying the watchdog timeout when a panic occurs
- * or disabling the watchdog timer on a reboot.
+ * way.  This is useful if you need to spin waiting for something to
+ * happen in the IPMI driver.
  */
 void ipmi_poll_interface(ipmi_user_t user);
 
@@ -422,12 +421,6 @@ int ipmi_get_maintenance_mode(ipmi_user_
 int ipmi_set_maintenance_mode(ipmi_user_t user, int mode);
 
 /*
- * Allow run-to-completion mode to be set for the interface of
- * a specific user.
- */
-void ipmi_user_set_run_to_completion(ipmi_user_t user, int val);
-
-/*
  * When the user is created, it will not receive IPMI events by
  * default.  The user must set this to TRUE to get incoming events.
  * The first user that sets this to TRUE will receive all events that
_

Patches currently in -mm which might be from cminyard@mvista.com are

git-watchdog.patch
ipmi-hold-attn-until-upper-layer-ready.patch
ipmi-change-device-node-ordering-to-reflect-probe-order.patch
ipmi-run-to-completion-fixes.patch
ipmi-dont-grab-locks-in-run-to-completion-mode.patch
ipmi-dont-print-event-queue-full-on-every-event.patch
ipmi-update-driver-version.patch
ipmi-convert-locked-counters-to-atomics.patch
ipmi-convert-locked-counters-to-atomics-in-the-system-interface.patch
