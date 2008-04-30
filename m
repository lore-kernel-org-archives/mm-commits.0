From: akpm@linux-foundation.org
Subject: - ipmi-dont-grab-locks-in-run-to-completion-mode.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:35 -0700
Message-ID: <200804300544.m3U5iZfd029425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231AbYD3Fy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:54:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kbaidarov@ru.mvista.com, cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: don't grab locks in run-to-completion mode
has been removed from the -mm tree.  Its filename was
     ipmi-dont-grab-locks-in-run-to-completion-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: don't grab locks in run-to-completion mode
From: Konstantin Baydarov <kbaidarov@ru.mvista.com>

This patch prevents deadlocks in IPMI panic handler caused by msg_lock
in smi_info structure and waiting_msgs_lock in ipmi_smi structure.

[cminyard@mvista.com: remove unnecessary memory barriers]
Signed-off-by: Konstantin Baydarov <kbaidarov@ru.mvista.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |   30 ++++++++++++++++++++------
 drivers/char/ipmi/ipmi_si_intf.c    |    6 +++--
 2 files changed, 28 insertions(+), 8 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-dont-grab-locks-in-run-to-completion-mode drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-dont-grab-locks-in-run-to-completion-mode
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -351,8 +351,16 @@ struct ipmi_smi
 
 	/* Invalid data in an event. */
 	unsigned int invalid_events;
+
 	/* Events that were received with the proper format. */
 	unsigned int events;
+
+	/*
+	 * run_to_completion duplicate of smb_info, smi_info
+	 * and ipmi_serial_info structures. Used to decrease numbers of
+	 * parameters passed by "low" level IPMI code.
+	 */
+	int run_to_completion;
 };
 #define to_si_intf_from_dev(device) container_of(device, struct ipmi_smi, dev)
 
@@ -3451,8 +3459,9 @@ static int handle_new_recv_msg(ipmi_smi_
 void ipmi_smi_msg_received(ipmi_smi_t          intf,
 			   struct ipmi_smi_msg *msg)
 {
-	unsigned long flags;
+	unsigned long flags = 0; /* keep us warning-free. */
 	int           rv;
+	int           run_to_completion;
 
 
 	if ((msg->data_size >= 2)
@@ -3501,21 +3510,28 @@ void ipmi_smi_msg_received(ipmi_smi_t   
 
 	/* To preserve message order, if the list is not empty, we
            tack this message onto the end of the list. */
-	spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
+	run_to_completion = intf->run_to_completion;
+	if (!run_to_completion)
+		spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
 	if (!list_empty(&intf->waiting_msgs)) {
 		list_add_tail(&msg->link, &intf->waiting_msgs);
-		spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
+		if (!run_to_completion)
+			spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
 		goto out;
 	}
-	spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
+	if (!run_to_completion)
+		spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
 		
 	rv = handle_new_recv_msg(intf, msg);
 	if (rv > 0) {
 		/* Could not handle the message now, just add it to a
                    list to handle later. */
-		spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
+		run_to_completion = intf->run_to_completion;
+		if (!run_to_completion)
+			spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
 		list_add_tail(&msg->link, &intf->waiting_msgs);
-		spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
+		if (!run_to_completion)
+			spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
 	} else if (rv == 0) {
 		ipmi_free_smi_msg(msg);
 	}
@@ -3884,6 +3900,7 @@ static void send_panic_events(char *str)
 			/* Interface is not ready. */
 			continue;
 
+		intf->run_to_completion = 1;
 		/* Send the event announcing the panic. */
 		intf->handlers->set_run_to_completion(intf->send_info, 1);
 		i_ipmi_request(NULL,
@@ -4059,6 +4076,7 @@ static int panic_event(struct notifier_b
 			/* Interface is not ready. */
 			continue;
 
+		intf->run_to_completion = 1;
 		intf->handlers->set_run_to_completion(intf->send_info, 1);
 	}
 
diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-dont-grab-locks-in-run-to-completion-mode drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-dont-grab-locks-in-run-to-completion-mode
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -289,7 +289,8 @@ static enum si_sm_result start_next_msg(
 
 	/* No need to save flags, we aleady have interrupts off and we
 	   already hold the SMI lock. */
-	spin_lock(&(smi_info->msg_lock));
+	if (!smi_info->run_to_completion)
+		spin_lock(&(smi_info->msg_lock));
 
 	/* Pick the high priority queue first. */
 	if (!list_empty(&(smi_info->hp_xmit_msgs))) {
@@ -329,7 +330,8 @@ static enum si_sm_result start_next_msg(
 		rv = SI_SM_CALL_WITHOUT_DELAY;
 	}
 	out:
-	spin_unlock(&(smi_info->msg_lock));
+	if (!smi_info->run_to_completion)
+		spin_unlock(&(smi_info->msg_lock));
 
 	return rv;
 }
_

Patches currently in -mm which might be from kbaidarov@ru.mvista.com are

origin.patch

