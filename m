From: akpm@linux-foundation.org
Subject: [merged] ipmi-fix-message-handling-during-panics.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:58 -0700
Message-ID: <20120329191358.5EBFBA01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:61777 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933751Ab2C2TN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:59 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so302652qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipmi: fix message handling during panics
has been removed from the -mm tree.  Its filename was
     ipmi-fix-message-handling-during-panics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Corey Minyard <cminyard@mvista.com>
Subject: ipmi: fix message handling during panics

The part of the IPMI driver that delivered panic information to the event
log and extended the watchdog timeout during a panic was not properly
handling the messages.  It used static messages to avoid allocation, but
wasn't properly waiting for these, or wasn't properly handling the
refcounts.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |  103 +++++++++++---------------
 drivers/char/ipmi/ipmi_watchdog.c   |   17 ++--
 2 files changed, 56 insertions(+), 64 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-message-handling-during-panics drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-message-handling-during-panics
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -2794,16 +2794,18 @@ channel_handler(ipmi_smi_t intf, struct 
 	return;
 }
 
-void ipmi_poll_interface(ipmi_user_t user)
+static void ipmi_poll(ipmi_smi_t intf)
 {
-	ipmi_smi_t intf = user->intf;
-
 	if (intf->handlers->poll)
 		intf->handlers->poll(intf->send_info);
-
 	/* In case something came in */
 	handle_new_recv_msgs(intf);
 }
+
+void ipmi_poll_interface(ipmi_user_t user)
+{
+	ipmi_poll(user->intf);
+}
 EXPORT_SYMBOL(ipmi_poll_interface);
 
 int ipmi_register_smi(struct ipmi_smi_handlers *handlers,
@@ -4204,12 +4206,48 @@ EXPORT_SYMBOL(ipmi_free_recv_msg);
 
 #ifdef CONFIG_IPMI_PANIC_EVENT
 
+static atomic_t panic_done_count = ATOMIC_INIT(0);
+
 static void dummy_smi_done_handler(struct ipmi_smi_msg *msg)
 {
+	atomic_dec(&panic_done_count);
 }
 
 static void dummy_recv_done_handler(struct ipmi_recv_msg *msg)
 {
+	atomic_dec(&panic_done_count);
+}
+
+/*
+ * Inside a panic, send a message and wait for a response.
+ */
+static void ipmi_panic_request_and_wait(ipmi_smi_t           intf,
+					struct ipmi_addr     *addr,
+					struct kernel_ipmi_msg *msg)
+{
+	struct ipmi_smi_msg  smi_msg;
+	struct ipmi_recv_msg recv_msg;
+	int rv;
+
+	smi_msg.done = dummy_smi_done_handler;
+	recv_msg.done = dummy_recv_done_handler;
+	atomic_add(2, &panic_done_count);
+	rv = i_ipmi_request(NULL,
+			    intf,
+			    addr,
+			    0,
+			    msg,
+			    intf,
+			    &smi_msg,
+			    &recv_msg,
+			    0,
+			    intf->channels[0].address,
+			    intf->channels[0].lun,
+			    0, 1); /* Don't retry, and don't wait. */
+	if (rv)
+		atomic_sub(2, &panic_done_count);
+	while (atomic_read(&panic_done_count) != 0)
+		ipmi_poll(intf);
 }
 
 #ifdef CONFIG_IPMI_PANIC_STRING
@@ -4248,8 +4286,6 @@ static void send_panic_events(char *str)
 	unsigned char                     data[16];
 	struct ipmi_system_interface_addr *si;
 	struct ipmi_addr                  addr;
-	struct ipmi_smi_msg               smi_msg;
-	struct ipmi_recv_msg              recv_msg;
 
 	si = (struct ipmi_system_interface_addr *) &addr;
 	si->addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
@@ -4277,9 +4313,6 @@ static void send_panic_events(char *str)
 		data[7] = str[2];
 	}
 
-	smi_msg.done = dummy_smi_done_handler;
-	recv_msg.done = dummy_recv_done_handler;
-
 	/* For every registered interface, send the event. */
 	list_for_each_entry_rcu(intf, &ipmi_interfaces, link) {
 		if (!intf->handlers)
@@ -4289,18 +4322,7 @@ static void send_panic_events(char *str)
 		intf->run_to_completion = 1;
 		/* Send the event announcing the panic. */
 		intf->handlers->set_run_to_completion(intf->send_info, 1);
-		i_ipmi_request(NULL,
-			       intf,
-			       &addr,
-			       0,
-			       &msg,
-			       intf,
-			       &smi_msg,
-			       &recv_msg,
-			       0,
-			       intf->channels[0].address,
-			       intf->channels[0].lun,
-			       0, 1); /* Don't retry, and don't wait. */
+		ipmi_panic_request_and_wait(intf, &addr, &msg);
 	}
 
 #ifdef CONFIG_IPMI_PANIC_STRING
@@ -4348,18 +4370,7 @@ static void send_panic_events(char *str)
 		msg.data = NULL;
 		msg.data_len = 0;
 		intf->null_user_handler = device_id_fetcher;
-		i_ipmi_request(NULL,
-			       intf,
-			       &addr,
-			       0,
-			       &msg,
-			       intf,
-			       &smi_msg,
-			       &recv_msg,
-			       0,
-			       intf->channels[0].address,
-			       intf->channels[0].lun,
-			       0, 1); /* Don't retry, and don't wait. */
+		ipmi_panic_request_and_wait(intf, &addr, &msg);
 
 		if (intf->local_event_generator) {
 			/* Request the event receiver from the local MC. */
@@ -4368,18 +4379,7 @@ static void send_panic_events(char *str)
 			msg.data = NULL;
 			msg.data_len = 0;
 			intf->null_user_handler = event_receiver_fetcher;
-			i_ipmi_request(NULL,
-				       intf,
-				       &addr,
-				       0,
-				       &msg,
-				       intf,
-				       &smi_msg,
-				       &recv_msg,
-				       0,
-				       intf->channels[0].address,
-				       intf->channels[0].lun,
-				       0, 1); /* no retry, and no wait. */
+			ipmi_panic_request_and_wait(intf, &addr, &msg);
 		}
 		intf->null_user_handler = NULL;
 
@@ -4436,18 +4436,7 @@ static void send_panic_events(char *str)
 			strncpy(data+5, p, 11);
 			p += size;
 
-			i_ipmi_request(NULL,
-				       intf,
-				       &addr,
-				       0,
-				       &msg,
-				       intf,
-				       &smi_msg,
-				       &recv_msg,
-				       0,
-				       intf->channels[0].address,
-				       intf->channels[0].lun,
-				       0, 1); /* no retry, and no wait. */
+			ipmi_panic_request_and_wait(intf, &addr, &msg);
 		}
 	}
 #endif /* CONFIG_IPMI_PANIC_STRING */
diff -puN drivers/char/ipmi/ipmi_watchdog.c~ipmi-fix-message-handling-during-panics drivers/char/ipmi/ipmi_watchdog.c
--- a/drivers/char/ipmi/ipmi_watchdog.c~ipmi-fix-message-handling-during-panics
+++ a/drivers/char/ipmi/ipmi_watchdog.c
@@ -520,6 +520,7 @@ static void panic_halt_ipmi_heartbeat(vo
 	msg.cmd = IPMI_WDOG_RESET_TIMER;
 	msg.data = NULL;
 	msg.data_len = 0;
+	atomic_add(2, &panic_done_count);
 	rv = ipmi_request_supply_msgs(watchdog_user,
 				      (struct ipmi_addr *) &addr,
 				      0,
@@ -528,8 +529,8 @@ static void panic_halt_ipmi_heartbeat(vo
 				      &panic_halt_heartbeat_smi_msg,
 				      &panic_halt_heartbeat_recv_msg,
 				      1);
-	if (!rv)
-		atomic_add(2, &panic_done_count);
+	if (rv)
+		atomic_sub(2, &panic_done_count);
 }
 
 static struct ipmi_smi_msg panic_halt_smi_msg = {
@@ -553,16 +554,18 @@ static void panic_halt_ipmi_set_timeout(
 	/* Wait for the messages to be free. */
 	while (atomic_read(&panic_done_count) != 0)
 		ipmi_poll_interface(watchdog_user);
+	atomic_add(2, &panic_done_count);
 	rv = i_ipmi_set_timeout(&panic_halt_smi_msg,
 				&panic_halt_recv_msg,
 				&send_heartbeat_now);
-	if (!rv) {
-		atomic_add(2, &panic_done_count);
-		if (send_heartbeat_now)
-			panic_halt_ipmi_heartbeat();
-	} else
+	if (rv) {
+		atomic_sub(2, &panic_done_count);
 		printk(KERN_WARNING PFX
 		       "Unable to extend the watchdog timeout.");
+	} else {
+		if (send_heartbeat_now)
+			panic_halt_ipmi_heartbeat();
+	}
 	while (atomic_read(&panic_done_count) != 0)
 		ipmi_poll_interface(watchdog_user);
 }
_

Patches currently in -mm which might be from cminyard@mvista.com are

origin.patch

