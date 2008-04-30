From: akpm@linux-foundation.org
Subject: - ipmi-convert-locked-counters-to-atomics.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:41 -0700
Message-ID: <200804300544.m3U5ifRT029434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755847AbYD3Fw6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:52:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kbaidarov@ru.mvista.com, cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: convert locked counters to atomics
has been removed from the -mm tree.  Its filename was
     ipmi-convert-locked-counters-to-atomics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: convert locked counters to atomics
From: Konstantin Baydarov <kbaidarov@ru.mvista.com>

Atomics are a lot more efficient and neat than using a lock.

Signed-off-by: Konstantin Baydarov <kbaidarov@ru.mvista.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |  442 +++++++++++---------------
 1 file changed, 194 insertions(+), 248 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-convert-locked-counters-to-atomics drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-convert-locked-counters-to-atomics
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -67,7 +67,6 @@ static struct proc_dir_entry *proc_ipmi_
    the max message timer.  This is in milliseconds. */
 #define MAX_MSG_TIMEOUT		60000
 
-
 /*
  * The main "user" data structure.
  */
@@ -186,6 +185,96 @@ struct bmc_device
 	struct device_attribute aux_firmware_rev_attr;
 };
 
+/*
+ * Various statistics for IPMI, these index stats[] in the ipmi_smi
+ * structure.
+ */
+/* Commands we got from the user that were invalid. */
+#define IPMI_STAT_sent_invalid_commands			0
+
+/* Commands we sent to the MC. */
+#define IPMI_STAT_sent_local_commands			1
+
+/* Responses from the MC that were delivered to a user. */
+#define IPMI_STAT_handled_local_responses		2
+
+/* Responses from the MC that were not delivered to a user. */
+#define IPMI_STAT_unhandled_local_responses		3
+
+/* Commands we sent out to the IPMB bus. */
+#define IPMI_STAT_sent_ipmb_commands			4
+
+/* Commands sent on the IPMB that had errors on the SEND CMD */
+#define IPMI_STAT_sent_ipmb_command_errs		5
+
+/* Each retransmit increments this count. */
+#define IPMI_STAT_retransmitted_ipmb_commands		6
+
+/* When a message times out (runs out of retransmits) this is incremented. */
+#define IPMI_STAT_timed_out_ipmb_commands		7
+
+/*
+ * This is like above, but for broadcasts.  Broadcasts are
+ * *not* included in the above count (they are expected to
+ * time out).
+ */
+#define IPMI_STAT_timed_out_ipmb_broadcasts		8
+
+/* Responses I have sent to the IPMB bus. */
+#define IPMI_STAT_sent_ipmb_responses			9
+
+/* The response was delivered to the user. */
+#define IPMI_STAT_handled_ipmb_responses		10
+
+/* The response had invalid data in it. */
+#define IPMI_STAT_invalid_ipmb_responses		11
+
+/* The response didn't have anyone waiting for it. */
+#define IPMI_STAT_unhandled_ipmb_responses		12
+
+/* Commands we sent out to the IPMB bus. */
+#define IPMI_STAT_sent_lan_commands			13
+
+/* Commands sent on the IPMB that had errors on the SEND CMD */
+#define IPMI_STAT_sent_lan_command_errs			14
+
+/* Each retransmit increments this count. */
+#define IPMI_STAT_retransmitted_lan_commands		15
+
+/* When a message times out (runs out of retransmits) this is incremented. */
+#define IPMI_STAT_timed_out_lan_commands		16
+
+/* Responses I have sent to the IPMB bus. */
+#define IPMI_STAT_sent_lan_responses			17
+
+/* The response was delivered to the user. */
+#define IPMI_STAT_handled_lan_responses			18
+
+/* The response had invalid data in it. */
+#define IPMI_STAT_invalid_lan_responses			19
+
+/* The response didn't have anyone waiting for it. */
+#define IPMI_STAT_unhandled_lan_responses		20
+
+/* The command was delivered to the user. */
+#define IPMI_STAT_handled_commands			21
+
+/* The command had invalid data in it. */
+#define IPMI_STAT_invalid_commands			22
+
+/* The command didn't have anyone waiting for it. */
+#define IPMI_STAT_unhandled_commands			23
+
+/* Invalid data in an event. */
+#define IPMI_STAT_invalid_events			24
+
+/* Events that were received with the proper format. */
+#define IPMI_STAT_events				25
+
+/* When you add a statistic, you must update this value. */
+#define IPMI_NUM_STATS					26
+
+
 #define IPMI_IPMB_NUM_SEQ	64
 #define IPMI_MAX_CHANNELS       16
 struct ipmi_smi
@@ -286,75 +375,7 @@ struct ipmi_smi
 	struct proc_dir_entry *proc_dir;
 	char                  proc_dir_name[10];
 
-	spinlock_t   counter_lock; /* For making counters atomic. */
-
-	/* Commands we got that were invalid. */
-	unsigned int sent_invalid_commands;
-
-	/* Commands we sent to the MC. */
-	unsigned int sent_local_commands;
-	/* Responses from the MC that were delivered to a user. */
-	unsigned int handled_local_responses;
-	/* Responses from the MC that were not delivered to a user. */
-	unsigned int unhandled_local_responses;
-
-	/* Commands we sent out to the IPMB bus. */
-	unsigned int sent_ipmb_commands;
-	/* Commands sent on the IPMB that had errors on the SEND CMD */
-	unsigned int sent_ipmb_command_errs;
-	/* Each retransmit increments this count. */
-	unsigned int retransmitted_ipmb_commands;
-	/* When a message times out (runs out of retransmits) this is
-           incremented. */
-	unsigned int timed_out_ipmb_commands;
-
-	/* This is like above, but for broadcasts.  Broadcasts are
-           *not* included in the above count (they are expected to
-           time out). */
-	unsigned int timed_out_ipmb_broadcasts;
-
-	/* Responses I have sent to the IPMB bus. */
-	unsigned int sent_ipmb_responses;
-
-	/* The response was delivered to the user. */
-	unsigned int handled_ipmb_responses;
-	/* The response had invalid data in it. */
-	unsigned int invalid_ipmb_responses;
-	/* The response didn't have anyone waiting for it. */
-	unsigned int unhandled_ipmb_responses;
-
-	/* Commands we sent out to the IPMB bus. */
-	unsigned int sent_lan_commands;
-	/* Commands sent on the IPMB that had errors on the SEND CMD */
-	unsigned int sent_lan_command_errs;
-	/* Each retransmit increments this count. */
-	unsigned int retransmitted_lan_commands;
-	/* When a message times out (runs out of retransmits) this is
-           incremented. */
-	unsigned int timed_out_lan_commands;
-
-	/* Responses I have sent to the IPMB bus. */
-	unsigned int sent_lan_responses;
-
-	/* The response was delivered to the user. */
-	unsigned int handled_lan_responses;
-	/* The response had invalid data in it. */
-	unsigned int invalid_lan_responses;
-	/* The response didn't have anyone waiting for it. */
-	unsigned int unhandled_lan_responses;
-
-	/* The command was delivered to the user. */
-	unsigned int handled_commands;
-	/* The command had invalid data in it. */
-	unsigned int invalid_commands;
-	/* The command didn't have anyone waiting for it. */
-	unsigned int unhandled_commands;
-
-	/* Invalid data in an event. */
-	unsigned int invalid_events;
-
-	/* Events that were received with the proper format. */
-	unsigned int events;
+	atomic_t stats[IPMI_NUM_STATS];
 
 	/*
 	 * run_to_completion duplicate of smb_info, smi_info
@@ -383,6 +404,12 @@ static LIST_HEAD(smi_watchers);
 static DEFINE_MUTEX(smi_watchers_mutex);
 
 
+#define ipmi_inc_stat(intf, stat) \
+	atomic_inc(&(intf)->stats[IPMI_STAT_ ## stat])
+#define ipmi_get_stat(intf, stat) \
+	((unsigned int) atomic_read(&(intf)->stats[IPMI_STAT_ ## stat]))
+
+
 static void free_recv_msg_list(struct list_head *q)
 {
 	struct ipmi_recv_msg *msg, *msg2;
@@ -623,19 +650,14 @@ static void deliver_response(struct ipmi
 {
 	if (!msg->user) {
 		ipmi_smi_t    intf = msg->user_msg_data;
-		unsigned long flags;
 
 		/* Special handling for NULL users. */
 		if (intf->null_user_handler) {
 			intf->null_user_handler(intf, msg);
-			spin_lock_irqsave(&intf->counter_lock, flags);
-			intf->handled_local_responses++;
-			spin_unlock_irqrestore(&intf->counter_lock, flags);
+			ipmi_inc_stat(intf, handled_local_responses);
 		} else {
 			/* No handler, so give up. */
-			spin_lock_irqsave(&intf->counter_lock, flags);
-			intf->unhandled_local_responses++;
-			spin_unlock_irqrestore(&intf->counter_lock, flags);
+			ipmi_inc_stat(intf, unhandled_local_responses);
 		}
 		ipmi_free_recv_msg(msg);
 	} else {
@@ -1372,9 +1394,7 @@ static int i_ipmi_request(ipmi_user_t   
 
 		smi_addr = (struct ipmi_system_interface_addr *) addr;
 		if (smi_addr->lun > 3) {
-			spin_lock_irqsave(&intf->counter_lock, flags);
-			intf->sent_invalid_commands++;
-			spin_unlock_irqrestore(&intf->counter_lock, flags);
+			ipmi_inc_stat(intf, sent_invalid_commands);
 			rv = -EINVAL;
 			goto out_err;
 		}
@@ -1388,9 +1408,7 @@ static int i_ipmi_request(ipmi_user_t   
 		{
 			/* We don't let the user do these, since we manage
 			   the sequence numbers. */
-			spin_lock_irqsave(&intf->counter_lock, flags);
-			intf->sent_invalid_commands++;
-			spin_unlock_irqrestore(&intf->counter_lock, flags);
+			ipmi_inc_stat(intf, sent_invalid_commands);
 			rv = -EINVAL;
 			goto out_err;
 		}
@@ -1414,9 +1432,7 @@ static int i_ipmi_request(ipmi_user_t   
 		}
 
 		if ((msg->data_len + 2) > IPMI_MAX_MSG_LENGTH) {
-			spin_lock_irqsave(&intf->counter_lock, flags);
-			intf->sent_invalid_commands++;
-			spin_unlock_irqrestore(&intf->counter_lock, flags);
+			ipmi_inc_stat(intf, sent_invalid_commands);
 			rv = -EMSGSIZE;
 			goto out_err;
 		}
@@ -1428,9 +1444,7 @@ static int i_ipmi_request(ipmi_user_t   
 		if (msg->data_len > 0)
 			memcpy(&(smi_msg->data[2]), msg->data, msg->data_len);
 		smi_msg->data_size = msg->data_len + 2;
-		spin_lock_irqsave(&intf->counter_lock, flags);
-		intf->sent_local_commands++;
-		spin_unlock_irqrestore(&intf->counter_lock, flags);
+		ipmi_inc_stat(intf, sent_local_commands);
 	} else if ((addr->addr_type == IPMI_IPMB_ADDR_TYPE)
 		   || (addr->addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE))
 	{
@@ -1440,9 +1454,7 @@ static int i_ipmi_request(ipmi_user_t   
 		int                   broadcast = 0;
 
 		if (addr->channel >= IPMI_MAX_CHANNELS) {
-		        spin_lock_irqsave(&intf->counter_lock, flags);
-			intf->sent_invalid_commands++;
-			spin_unlock_irqrestore(&intf->counter_lock, flags);
+			ipmi_inc_stat(intf, sent_invalid_commands);
 			rv = -EINVAL;
 			goto out_err;
 		}
@@ -1450,9 +1462,7 @@ static int i_ipmi_request(ipmi_user_t   
 		if (intf->channels[addr->channel].medium
 		    != IPMI_CHANNEL_MEDIUM_IPMB)
 		{
-			spin_lock_irqsave(&intf->counter_lock, flags);
-			intf->sent_invalid_commands++;
-			spin_unlock_irqrestore(&intf->counter_lock, flags);
+			ipmi_inc_stat(intf, sent_invalid_commands);
 			rv = -EINVAL;
 			goto out_err;
 		}
@@ -1479,18 +1489,14 @@ static int i_ipmi_request(ipmi_user_t   
 		/* 9 for the header and 1 for the checksum, plus
                    possibly one for the broadcast. */
 		if ((msg->data_len + 10 + broadcast) > IPMI_MAX_MSG_LENGTH) {
-			spin_lock_irqsave(&intf->counter_lock, flags);
-			intf->sent_invalid_commands++;
-			spin_unlock_irqrestore(&intf->counter_lock, flags);
+			ipmi_inc_stat(intf, sent_invalid_commands);
 			rv = -EMSGSIZE;
 			goto out_err;
 		}
 
 		ipmb_addr = (struct ipmi_ipmb_addr *) addr;
 		if (ipmb_addr->lun > 3) {
-			spin_lock_irqsave(&intf->counter_lock, flags);
-			intf->sent_invalid_commands++;
-			spin_unlock_irqrestore(&intf->counter_lock, flags);
+			ipmi_inc_stat(intf, sent_invalid_commands);
 			rv = -EINVAL;
 			goto out_err;
 		}
@@ -1500,9 +1506,7 @@ static int i_ipmi_request(ipmi_user_t   
 		if (recv_msg->msg.netfn & 0x1) {
 			/* It's a response, so use the user's sequence
                            from msgid. */
-			spin_lock_irqsave(&intf->counter_lock, flags);
-			intf->sent_ipmb_responses++;
-			spin_unlock_irqrestore(&intf->counter_lock, flags);
+			ipmi_inc_stat(intf, sent_ipmb_responses);
 			format_ipmb_msg(smi_msg, msg, ipmb_addr, msgid,
 					msgid, broadcast,
 					source_address, source_lun);
@@ -1515,9 +1519,7 @@ static int i_ipmi_request(ipmi_user_t   
 
 			spin_lock_irqsave(&(intf->seq_lock), flags);
 
-			spin_lock(&intf->counter_lock);
-			intf->sent_ipmb_commands++;
-			spin_unlock(&intf->counter_lock);
+			ipmi_inc_stat(intf, sent_ipmb_commands);
 
 			/* Create a sequence number with a 1 second
                            timeout and 4 retries. */
@@ -1565,9 +1567,7 @@ static int i_ipmi_request(ipmi_user_t   
 		long                  seqid;
 
 		if (addr->channel >= IPMI_MAX_CHANNELS) {
-			spin_lock_irqsave(&intf->counter_lock, flags);
-			intf->sent_invalid_commands++;
-			spin_unlock_irqrestore(&intf->counter_lock, flags);
+			ipmi_inc_stat(intf, sent_invalid_commands);
 			rv = -EINVAL;
 			goto out_err;
 		}
@@ -1577,9 +1577,7 @@ static int i_ipmi_request(ipmi_user_t   
 		    && (intf->channels[addr->channel].medium
 			!= IPMI_CHANNEL_MEDIUM_ASYNC))
 		{
-			spin_lock_irqsave(&intf->counter_lock, flags);
-			intf->sent_invalid_commands++;
-			spin_unlock_irqrestore(&intf->counter_lock, flags);
+			ipmi_inc_stat(intf, sent_invalid_commands);
 			rv = -EINVAL;
 			goto out_err;
 		}
@@ -1592,18 +1590,14 @@ static int i_ipmi_request(ipmi_user_t   
 
 		/* 11 for the header and 1 for the checksum. */
 		if ((msg->data_len + 12) > IPMI_MAX_MSG_LENGTH) {
-			spin_lock_irqsave(&intf->counter_lock, flags);
-			intf->sent_invalid_commands++;
-			spin_unlock_irqrestore(&intf->counter_lock, flags);
+			ipmi_inc_stat(intf, sent_invalid_commands);
 			rv = -EMSGSIZE;
 			goto out_err;
 		}
 
 		lan_addr = (struct ipmi_lan_addr *) addr;
 		if (lan_addr->lun > 3) {
-			spin_lock_irqsave(&intf->counter_lock, flags);
-			intf->sent_invalid_commands++;
-			spin_unlock_irqrestore(&intf->counter_lock, flags);
+			ipmi_inc_stat(intf, sent_invalid_commands);
 			rv = -EINVAL;
 			goto out_err;
 		}
@@ -1613,9 +1607,7 @@ static int i_ipmi_request(ipmi_user_t   
 		if (recv_msg->msg.netfn & 0x1) {
 			/* It's a response, so use the user's sequence
                            from msgid. */
-			spin_lock_irqsave(&intf->counter_lock, flags);
-			intf->sent_lan_responses++;
-			spin_unlock_irqrestore(&intf->counter_lock, flags);
+			ipmi_inc_stat(intf, sent_lan_responses);
 			format_lan_msg(smi_msg, msg, lan_addr, msgid,
 				       msgid, source_lun);
 
@@ -1627,9 +1619,7 @@ static int i_ipmi_request(ipmi_user_t   
 
 			spin_lock_irqsave(&(intf->seq_lock), flags);
 
-			spin_lock(&intf->counter_lock);
-			intf->sent_lan_commands++;
-			spin_unlock(&intf->counter_lock);
+			ipmi_inc_stat(intf, sent_lan_commands);
 
 			/* Create a sequence number with a 1 second
                            timeout and 4 retries. */
@@ -1672,9 +1662,7 @@ static int i_ipmi_request(ipmi_user_t   
 		}
 	} else {
 	    /* Unknown address type. */
-		spin_lock_irqsave(&intf->counter_lock, flags);
-		intf->sent_invalid_commands++;
-		spin_unlock_irqrestore(&intf->counter_lock, flags);
+		ipmi_inc_stat(intf, sent_invalid_commands);
 		rv = -EINVAL;
 		goto out_err;
 	}
@@ -1797,7 +1785,7 @@ static int version_file_read_proc(char *
 	char       *out = (char *) page;
 	ipmi_smi_t intf = data;
 
-	return sprintf(out, "%d.%d\n",
+	return sprintf(out, "%u.%u\n",
 		       ipmi_version_major(&intf->bmc->id),
 		       ipmi_version_minor(&intf->bmc->id));
 }
@@ -1808,58 +1796,58 @@ static int stat_file_read_proc(char *pag
 	char       *out = (char *) page;
 	ipmi_smi_t intf = data;
 
-	out += sprintf(out, "sent_invalid_commands:       %d\n",
-		       intf->sent_invalid_commands);
-	out += sprintf(out, "sent_local_commands:         %d\n",
-		       intf->sent_local_commands);
-	out += sprintf(out, "handled_local_responses:     %d\n",
-		       intf->handled_local_responses);
-	out += sprintf(out, "unhandled_local_responses:   %d\n",
-		       intf->unhandled_local_responses);
-	out += sprintf(out, "sent_ipmb_commands:          %d\n",
-		       intf->sent_ipmb_commands);
-	out += sprintf(out, "sent_ipmb_command_errs:      %d\n",
-		       intf->sent_ipmb_command_errs);
-	out += sprintf(out, "retransmitted_ipmb_commands: %d\n",
-		       intf->retransmitted_ipmb_commands);
-	out += sprintf(out, "timed_out_ipmb_commands:     %d\n",
-		       intf->timed_out_ipmb_commands);
-	out += sprintf(out, "timed_out_ipmb_broadcasts:   %d\n",
-		       intf->timed_out_ipmb_broadcasts);
-	out += sprintf(out, "sent_ipmb_responses:         %d\n",
-		       intf->sent_ipmb_responses);
-	out += sprintf(out, "handled_ipmb_responses:      %d\n",
-		       intf->handled_ipmb_responses);
-	out += sprintf(out, "invalid_ipmb_responses:      %d\n",
-		       intf->invalid_ipmb_responses);
-	out += sprintf(out, "unhandled_ipmb_responses:    %d\n",
-		       intf->unhandled_ipmb_responses);
-	out += sprintf(out, "sent_lan_commands:           %d\n",
-		       intf->sent_lan_commands);
-	out += sprintf(out, "sent_lan_command_errs:       %d\n",
-		       intf->sent_lan_command_errs);
-	out += sprintf(out, "retransmitted_lan_commands:  %d\n",
-		       intf->retransmitted_lan_commands);
-	out += sprintf(out, "timed_out_lan_commands:      %d\n",
-		       intf->timed_out_lan_commands);
-	out += sprintf(out, "sent_lan_responses:          %d\n",
-		       intf->sent_lan_responses);
-	out += sprintf(out, "handled_lan_responses:       %d\n",
-		       intf->handled_lan_responses);
-	out += sprintf(out, "invalid_lan_responses:       %d\n",
-		       intf->invalid_lan_responses);
-	out += sprintf(out, "unhandled_lan_responses:     %d\n",
-		       intf->unhandled_lan_responses);
-	out += sprintf(out, "handled_commands:            %d\n",
-		       intf->handled_commands);
-	out += sprintf(out, "invalid_commands:            %d\n",
-		       intf->invalid_commands);
-	out += sprintf(out, "unhandled_commands:          %d\n",
-		       intf->unhandled_commands);
-	out += sprintf(out, "invalid_events:              %d\n",
-		       intf->invalid_events);
-	out += sprintf(out, "events:                      %d\n",
-		       intf->events);
+	out += sprintf(out, "sent_invalid_commands:       %u\n",
+		       ipmi_get_stat(intf, sent_invalid_commands));
+	out += sprintf(out, "sent_local_commands:         %u\n",
+		       ipmi_get_stat(intf, sent_local_commands));
+	out += sprintf(out, "handled_local_responses:     %u\n",
+		       ipmi_get_stat(intf, handled_local_responses));
+	out += sprintf(out, "unhandled_local_responses:   %u\n",
+		       ipmi_get_stat(intf, unhandled_local_responses));
+	out += sprintf(out, "sent_ipmb_commands:          %u\n",
+		       ipmi_get_stat(intf, sent_ipmb_commands));
+	out += sprintf(out, "sent_ipmb_command_errs:      %u\n",
+		       ipmi_get_stat(intf, sent_ipmb_command_errs));
+	out += sprintf(out, "retransmitted_ipmb_commands: %u\n",
+		       ipmi_get_stat(intf, retransmitted_ipmb_commands));
+	out += sprintf(out, "timed_out_ipmb_commands:     %u\n",
+		       ipmi_get_stat(intf, timed_out_ipmb_commands));
+	out += sprintf(out, "timed_out_ipmb_broadcasts:   %u\n",
+		       ipmi_get_stat(intf, timed_out_ipmb_broadcasts));
+	out += sprintf(out, "sent_ipmb_responses:         %u\n",
+		       ipmi_get_stat(intf, sent_ipmb_responses));
+	out += sprintf(out, "handled_ipmb_responses:      %u\n",
+		       ipmi_get_stat(intf, handled_ipmb_responses));
+	out += sprintf(out, "invalid_ipmb_responses:      %u\n",
+		       ipmi_get_stat(intf, invalid_ipmb_responses));
+	out += sprintf(out, "unhandled_ipmb_responses:    %u\n",
+		       ipmi_get_stat(intf, unhandled_ipmb_responses));
+	out += sprintf(out, "sent_lan_commands:           %u\n",
+		       ipmi_get_stat(intf, sent_lan_commands));
+	out += sprintf(out, "sent_lan_command_errs:       %u\n",
+		       ipmi_get_stat(intf, sent_lan_command_errs));
+	out += sprintf(out, "retransmitted_lan_commands:  %u\n",
+		       ipmi_get_stat(intf, retransmitted_lan_commands));
+	out += sprintf(out, "timed_out_lan_commands:      %u\n",
+		       ipmi_get_stat(intf, timed_out_lan_commands));
+	out += sprintf(out, "sent_lan_responses:          %u\n",
+		       ipmi_get_stat(intf, sent_lan_responses));
+	out += sprintf(out, "handled_lan_responses:       %u\n",
+		       ipmi_get_stat(intf, handled_lan_responses));
+	out += sprintf(out, "invalid_lan_responses:       %u\n",
+		       ipmi_get_stat(intf, invalid_lan_responses));
+	out += sprintf(out, "unhandled_lan_responses:     %u\n",
+		       ipmi_get_stat(intf, unhandled_lan_responses));
+	out += sprintf(out, "handled_commands:            %u\n",
+		       ipmi_get_stat(intf, handled_commands));
+	out += sprintf(out, "invalid_commands:            %u\n",
+		       ipmi_get_stat(intf, invalid_commands));
+	out += sprintf(out, "unhandled_commands:          %u\n",
+		       ipmi_get_stat(intf, unhandled_commands));
+	out += sprintf(out, "invalid_events:              %u\n",
+		       ipmi_get_stat(intf, invalid_events));
+	out += sprintf(out, "events:                      %u\n",
+		       ipmi_get_stat(intf, events));
 
 	return (out - ((char *) page));
 }
@@ -2695,8 +2683,9 @@ int ipmi_register_smi(struct ipmi_smi_ha
 	spin_lock_init(&intf->maintenance_mode_lock);
 	INIT_LIST_HEAD(&intf->cmd_rcvrs);
 	init_waitqueue_head(&intf->waitq);
+	for (i = 0; i < IPMI_NUM_STATS; i++)
+		atomic_set(&intf->stats[i], 0);
 
-	spin_lock_init(&intf->counter_lock);
 	intf->proc_dir = NULL;
 
 	mutex_lock(&smi_watchers_mutex);
@@ -2825,16 +2814,13 @@ static int handle_ipmb_get_msg_rsp(ipmi_
 {
 	struct ipmi_ipmb_addr ipmb_addr;
 	struct ipmi_recv_msg  *recv_msg;
-	unsigned long         flags;
 
 	
 	/* This is 11, not 10, because the response must contain a
 	 * completion code. */
 	if (msg->rsp_size < 11) {
 		/* Message not big enough, just ignore it. */
-		spin_lock_irqsave(&intf->counter_lock, flags);
-		intf->invalid_ipmb_responses++;
-		spin_unlock_irqrestore(&intf->counter_lock, flags);
+		ipmi_inc_stat(intf, invalid_ipmb_responses);
 		return 0;
 	}
 
@@ -2860,9 +2846,7 @@ static int handle_ipmb_get_msg_rsp(ipmi_
 	{
 		/* We were unable to find the sequence number,
 		   so just nuke the message. */
-		spin_lock_irqsave(&intf->counter_lock, flags);
-		intf->unhandled_ipmb_responses++;
-		spin_unlock_irqrestore(&intf->counter_lock, flags);
+		ipmi_inc_stat(intf, unhandled_ipmb_responses);
 		return 0;
 	}
 
@@ -2876,9 +2860,7 @@ static int handle_ipmb_get_msg_rsp(ipmi_
 	recv_msg->msg.data = recv_msg->msg_data;
 	recv_msg->msg.data_len = msg->rsp_size - 10;
 	recv_msg->recv_type = IPMI_RESPONSE_RECV_TYPE;
-	spin_lock_irqsave(&intf->counter_lock, flags);
-	intf->handled_ipmb_responses++;
-	spin_unlock_irqrestore(&intf->counter_lock, flags);
+	ipmi_inc_stat(intf, handled_ipmb_responses);
 	deliver_response(recv_msg);
 
 	return 0;
@@ -2895,14 +2877,11 @@ static int handle_ipmb_get_msg_cmd(ipmi_
 	ipmi_user_t              user = NULL;
 	struct ipmi_ipmb_addr    *ipmb_addr;
 	struct ipmi_recv_msg     *recv_msg;
-	unsigned long            flags;
 	struct ipmi_smi_handlers *handlers;
 
 	if (msg->rsp_size < 10) {
 		/* Message not big enough, just ignore it. */
-		spin_lock_irqsave(&intf->counter_lock, flags);
-		intf->invalid_commands++;
-		spin_unlock_irqrestore(&intf->counter_lock, flags);
+		ipmi_inc_stat(intf, invalid_commands);
 		return 0;
 	}
 
@@ -2926,9 +2905,7 @@ static int handle_ipmb_get_msg_cmd(ipmi_
 
 	if (user == NULL) {
 		/* We didn't find a user, deliver an error response. */
-		spin_lock_irqsave(&intf->counter_lock, flags);
-		intf->unhandled_commands++;
-		spin_unlock_irqrestore(&intf->counter_lock, flags);
+		ipmi_inc_stat(intf, unhandled_commands);
 
 		msg->data[0] = (IPMI_NETFN_APP_REQUEST << 2);
 		msg->data[1] = IPMI_SEND_MSG_CMD;
@@ -2965,9 +2942,7 @@ static int handle_ipmb_get_msg_cmd(ipmi_
 		rcu_read_unlock();
 	} else {
 		/* Deliver the message to the user. */
-		spin_lock_irqsave(&intf->counter_lock, flags);
-		intf->handled_commands++;
-		spin_unlock_irqrestore(&intf->counter_lock, flags);
+		ipmi_inc_stat(intf, handled_commands);
 
 		recv_msg = ipmi_alloc_recv_msg();
 		if (!recv_msg) {
@@ -3011,16 +2986,13 @@ static int handle_lan_get_msg_rsp(ipmi_s
 {
 	struct ipmi_lan_addr  lan_addr;
 	struct ipmi_recv_msg  *recv_msg;
-	unsigned long         flags;
 
 
 	/* This is 13, not 12, because the response must contain a
 	 * completion code. */
 	if (msg->rsp_size < 13) {
 		/* Message not big enough, just ignore it. */
-		spin_lock_irqsave(&intf->counter_lock, flags);
-		intf->invalid_lan_responses++;
-		spin_unlock_irqrestore(&intf->counter_lock, flags);
+		ipmi_inc_stat(intf, invalid_lan_responses);
 		return 0;
 	}
 
@@ -3049,9 +3021,7 @@ static int handle_lan_get_msg_rsp(ipmi_s
 	{
 		/* We were unable to find the sequence number,
 		   so just nuke the message. */
-		spin_lock_irqsave(&intf->counter_lock, flags);
-		intf->unhandled_lan_responses++;
-		spin_unlock_irqrestore(&intf->counter_lock, flags);
+		ipmi_inc_stat(intf, unhandled_lan_responses);
 		return 0;
 	}
 
@@ -3065,9 +3035,7 @@ static int handle_lan_get_msg_rsp(ipmi_s
 	recv_msg->msg.data = recv_msg->msg_data;
 	recv_msg->msg.data_len = msg->rsp_size - 12;
 	recv_msg->recv_type = IPMI_RESPONSE_RECV_TYPE;
-	spin_lock_irqsave(&intf->counter_lock, flags);
-	intf->handled_lan_responses++;
-	spin_unlock_irqrestore(&intf->counter_lock, flags);
+	ipmi_inc_stat(intf, handled_lan_responses);
 	deliver_response(recv_msg);
 
 	return 0;
@@ -3084,13 +3052,10 @@ static int handle_lan_get_msg_cmd(ipmi_s
 	ipmi_user_t              user = NULL;
 	struct ipmi_lan_addr     *lan_addr;
 	struct ipmi_recv_msg     *recv_msg;
-	unsigned long            flags;
 
 	if (msg->rsp_size < 12) {
 		/* Message not big enough, just ignore it. */
-		spin_lock_irqsave(&intf->counter_lock, flags);
-		intf->invalid_commands++;
-		spin_unlock_irqrestore(&intf->counter_lock, flags);
+		ipmi_inc_stat(intf, invalid_commands);
 		return 0;
 	}
 
@@ -3114,17 +3079,13 @@ static int handle_lan_get_msg_cmd(ipmi_s
 
 	if (user == NULL) {
 		/* We didn't find a user, just give up. */
-		spin_lock_irqsave(&intf->counter_lock, flags);
-		intf->unhandled_commands++;
-		spin_unlock_irqrestore(&intf->counter_lock, flags);
+		ipmi_inc_stat(intf, unhandled_commands);
 
 		rv = 0; /* Don't do anything with these messages, just
 			   allow them to be freed. */
 	} else {
 		/* Deliver the message to the user. */
-		spin_lock_irqsave(&intf->counter_lock, flags);
-		intf->handled_commands++;
-		spin_unlock_irqrestore(&intf->counter_lock, flags);
+		ipmi_inc_stat(intf, handled_commands);
 
 		recv_msg = ipmi_alloc_recv_msg();
 		if (!recv_msg) {
@@ -3196,9 +3157,7 @@ static int handle_read_event_rsp(ipmi_sm
 
 	if (msg->rsp_size < 19) {
 		/* Message is too small to be an IPMB event. */
-		spin_lock_irqsave(&intf->counter_lock, flags);
-		intf->invalid_events++;
-		spin_unlock_irqrestore(&intf->counter_lock, flags);
+		ipmi_inc_stat(intf, invalid_events);
 		return 0;
 	}
 
@@ -3211,9 +3170,7 @@ static int handle_read_event_rsp(ipmi_sm
 
 	spin_lock_irqsave(&intf->events_lock, flags);
 
-	spin_lock(&intf->counter_lock);
-	intf->events++;
-	spin_unlock(&intf->counter_lock);
+	ipmi_inc_stat(intf, events);
 
 	/* Allocate and fill in one message for every user that is getting
 	   events. */
@@ -3285,7 +3242,6 @@ static int handle_bmc_rsp(ipmi_smi_t    
 			  struct ipmi_smi_msg *msg)
 {
 	struct ipmi_recv_msg *recv_msg;
-	unsigned long        flags;
 	struct ipmi_user     *user;
 
 	recv_msg = (struct ipmi_recv_msg *) msg->user_data;
@@ -3302,16 +3258,12 @@ static int handle_bmc_rsp(ipmi_smi_t    
 	/* Make sure the user still exists. */
 	if (user && !user->valid) {
 		/* The user for the message went away, so give up. */
-		spin_lock_irqsave(&intf->counter_lock, flags);
-		intf->unhandled_local_responses++;
-		spin_unlock_irqrestore(&intf->counter_lock, flags);
+		ipmi_inc_stat(intf, unhandled_local_responses);
 		ipmi_free_recv_msg(recv_msg);
 	} else {
 		struct ipmi_system_interface_addr *smi_addr;
 
-		spin_lock_irqsave(&intf->counter_lock, flags);
-		intf->handled_local_responses++;
-		spin_unlock_irqrestore(&intf->counter_lock, flags);
+		ipmi_inc_stat(intf, handled_local_responses);
 		recv_msg->recv_type = IPMI_RESPONSE_RECV_TYPE;
 		recv_msg->msgid = msg->msgid;
 		smi_addr = ((struct ipmi_system_interface_addr *)
@@ -3494,17 +3446,15 @@ void ipmi_smi_msg_received(ipmi_smi_t   
 			int chan = msg->rsp[3] & 0xf;
 
 			/* Got an error sending the message, handle it. */
-			spin_lock_irqsave(&intf->counter_lock, flags);
 			if (chan >= IPMI_MAX_CHANNELS)
 				; /* This shouldn't happen */
 			else if ((intf->channels[chan].medium
 				  == IPMI_CHANNEL_MEDIUM_8023LAN)
 				 || (intf->channels[chan].medium
 				     == IPMI_CHANNEL_MEDIUM_ASYNC))
-				intf->sent_lan_command_errs++;
+				ipmi_inc_stat(intf, sent_lan_command_errs);
 			else
-				intf->sent_ipmb_command_errs++;
-			spin_unlock_irqrestore(&intf->counter_lock, flags);
+				ipmi_inc_stat(intf, sent_ipmb_command_errs);
 			intf_err_seq(intf, msg->msgid, msg->rsp[2]);
 		} else {
 			/* The message was sent, start the timer. */
@@ -3610,14 +3560,12 @@ static void check_msg_timeout(ipmi_smi_t
 		ent->inuse = 0;
 		msg = ent->recv_msg;
 		list_add_tail(&msg->link, timeouts);
-		spin_lock(&intf->counter_lock);
 		if (ent->broadcast)
-			intf->timed_out_ipmb_broadcasts++;
+			ipmi_inc_stat(intf, timed_out_ipmb_broadcasts);
 		else if (ent->recv_msg->addr.addr_type == IPMI_LAN_ADDR_TYPE)
-			intf->timed_out_lan_commands++;
+			ipmi_inc_stat(intf, timed_out_lan_commands);
 		else
-			intf->timed_out_ipmb_commands++;
-		spin_unlock(&intf->counter_lock);
+			ipmi_inc_stat(intf, timed_out_ipmb_commands);
 	} else {
 		struct ipmi_smi_msg *smi_msg;
 		/* More retries, send again. */
@@ -3626,12 +3574,10 @@ static void check_msg_timeout(ipmi_smi_t
 		   timer after the message is sent. */
 		ent->timeout = MAX_MSG_TIMEOUT;
 		ent->retries_left--;
-		spin_lock(&intf->counter_lock);
 		if (ent->recv_msg->addr.addr_type == IPMI_LAN_ADDR_TYPE)
-			intf->retransmitted_lan_commands++;
+			ipmi_inc_stat(intf, retransmitted_lan_commands);
 		else
-			intf->retransmitted_ipmb_commands++;
-		spin_unlock(&intf->counter_lock);
+			ipmi_inc_stat(intf, retransmitted_ipmb_commands);
 
 		smi_msg = smi_from_recv_msg(intf, ent->recv_msg, slot,
 					    ent->seqid);
_

Patches currently in -mm which might be from kbaidarov@ru.mvista.com are

origin.patch

