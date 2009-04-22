From: akpm@linux-foundation.org
Subject: [merged] ipmi-fix-statistics-counting-issues.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:29:35 -0700
Message-ID: <200904221829.n3MITZ4x005735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944AbZDVScO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:32:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, blubkin@vmware.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: fix statistics counting issues
has been removed from the -mm tree.  Its filename was
     ipmi-fix-statistics-counting-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: fix statistics counting issues
From: Corey Minyard <cminyard@mvista.com>

Bela Lubkin noticed that the statistics for send IPMB and LAN commands in
the IPMI driver could be incremented even if an error occurred.  Move the
increments to the proper place to avoid this.

Also add some statistics for retransmissions that failed, and some little
helper functions to neaten up the code a little.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Bela Lubkin <blubkin@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |   73 ++++++++++++++++++--------
 1 file changed, 51 insertions(+), 22 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-statistics-counting-issues drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-fix-statistics-counting-issues
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -285,6 +285,11 @@ enum ipmi_stat_indexes {
 	/* Events that were received with the proper format. */
 	IPMI_STAT_events,
 
+	/* Retransmissions on IPMB that failed. */
+	IPMI_STAT_dropped_rexmit_ipmb_commands,
+
+	/* Retransmissions on LAN that failed. */
+	IPMI_STAT_dropped_rexmit_lan_commands,
 
 	/* This *must* remain last, add new values above this. */
 	IPMI_NUM_STATS
@@ -445,6 +450,20 @@ static DEFINE_MUTEX(smi_watchers_mutex);
 #define ipmi_get_stat(intf, stat) \
 	((unsigned int) atomic_read(&(intf)->stats[IPMI_STAT_ ## stat]))
 
+static int is_lan_addr(struct ipmi_addr *addr)
+{
+	return addr->addr_type == IPMI_LAN_ADDR_TYPE;
+}
+
+static int is_ipmb_addr(struct ipmi_addr *addr)
+{
+	return addr->addr_type == IPMI_IPMB_ADDR_TYPE;
+}
+
+static int is_ipmb_bcast_addr(struct ipmi_addr *addr)
+{
+	return addr->addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE;
+}
 
 static void free_recv_msg_list(struct list_head *q)
 {
@@ -601,8 +620,7 @@ ipmi_addr_equal(struct ipmi_addr *addr1,
 		return (smi_addr1->lun == smi_addr2->lun);
 	}
 
-	if ((addr1->addr_type == IPMI_IPMB_ADDR_TYPE)
-	    || (addr1->addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE)) {
+	if (is_ipmb_addr(addr1) || is_ipmb_bcast_addr(addr1)) {
 		struct ipmi_ipmb_addr *ipmb_addr1
 		    = (struct ipmi_ipmb_addr *) addr1;
 		struct ipmi_ipmb_addr *ipmb_addr2
@@ -612,7 +630,7 @@ ipmi_addr_equal(struct ipmi_addr *addr1,
 			&& (ipmb_addr1->lun == ipmb_addr2->lun));
 	}
 
-	if (addr1->addr_type == IPMI_LAN_ADDR_TYPE) {
+	if (is_lan_addr(addr1)) {
 		struct ipmi_lan_addr *lan_addr1
 			= (struct ipmi_lan_addr *) addr1;
 		struct ipmi_lan_addr *lan_addr2
@@ -644,14 +662,13 @@ int ipmi_validate_addr(struct ipmi_addr 
 	    || (addr->channel < 0))
 		return -EINVAL;
 
-	if ((addr->addr_type == IPMI_IPMB_ADDR_TYPE)
-	    || (addr->addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE)) {
+	if (is_ipmb_addr(addr) || is_ipmb_bcast_addr(addr)) {
 		if (len < sizeof(struct ipmi_ipmb_addr))
 			return -EINVAL;
 		return 0;
 	}
 
-	if (addr->addr_type == IPMI_LAN_ADDR_TYPE) {
+	if (is_lan_addr(addr)) {
 		if (len < sizeof(struct ipmi_lan_addr))
 			return -EINVAL;
 		return 0;
@@ -1503,8 +1520,7 @@ static int i_ipmi_request(ipmi_user_t   
 			memcpy(&(smi_msg->data[2]), msg->data, msg->data_len);
 		smi_msg->data_size = msg->data_len + 2;
 		ipmi_inc_stat(intf, sent_local_commands);
-	} else if ((addr->addr_type == IPMI_IPMB_ADDR_TYPE)
-		   || (addr->addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE)) {
+	} else if (is_ipmb_addr(addr) || is_ipmb_bcast_addr(addr)) {
 		struct ipmi_ipmb_addr *ipmb_addr;
 		unsigned char         ipmb_seq;
 		long                  seqid;
@@ -1583,8 +1599,6 @@ static int i_ipmi_request(ipmi_user_t   
 
 			spin_lock_irqsave(&(intf->seq_lock), flags);
 
-			ipmi_inc_stat(intf, sent_ipmb_commands);
-
 			/*
 			 * Create a sequence number with a 1 second
 			 * timeout and 4 retries.
@@ -1606,6 +1620,8 @@ static int i_ipmi_request(ipmi_user_t   
 				goto out_err;
 			}
 
+			ipmi_inc_stat(intf, sent_ipmb_commands);
+
 			/*
 			 * Store the sequence number in the message,
 			 * so that when the send message response
@@ -1635,7 +1651,7 @@ static int i_ipmi_request(ipmi_user_t   
 			 */
 			spin_unlock_irqrestore(&(intf->seq_lock), flags);
 		}
-	} else if (addr->addr_type == IPMI_LAN_ADDR_TYPE) {
+	} else if (is_lan_addr(addr)) {
 		struct ipmi_lan_addr  *lan_addr;
 		unsigned char         ipmb_seq;
 		long                  seqid;
@@ -1696,8 +1712,6 @@ static int i_ipmi_request(ipmi_user_t   
 
 			spin_lock_irqsave(&(intf->seq_lock), flags);
 
-			ipmi_inc_stat(intf, sent_lan_commands);
-
 			/*
 			 * Create a sequence number with a 1 second
 			 * timeout and 4 retries.
@@ -1719,6 +1733,8 @@ static int i_ipmi_request(ipmi_user_t   
 				goto out_err;
 			}
 
+			ipmi_inc_stat(intf, sent_lan_commands);
+
 			/*
 			 * Store the sequence number in the message,
 			 * so that when the send message response
@@ -1937,6 +1953,10 @@ static int stat_file_read_proc(char *pag
 		       ipmi_get_stat(intf, invalid_events));
 	out += sprintf(out, "events:                      %u\n",
 		       ipmi_get_stat(intf, events));
+	out += sprintf(out, "failed rexmit LAN msgs:      %u\n",
+		       ipmi_get_stat(intf, dropped_rexmit_lan_commands));
+	out += sprintf(out, "failed rexmit IPMB msgs:     %u\n",
+		       ipmi_get_stat(intf, dropped_rexmit_ipmb_commands));
 
 	return (out - ((char *) page));
 }
@@ -3730,7 +3750,7 @@ static void check_msg_timeout(ipmi_smi_t
 		list_add_tail(&msg->link, timeouts);
 		if (ent->broadcast)
 			ipmi_inc_stat(intf, timed_out_ipmb_broadcasts);
-		else if (ent->recv_msg->addr.addr_type == IPMI_LAN_ADDR_TYPE)
+		else if (is_lan_addr(&ent->recv_msg->addr))
 			ipmi_inc_stat(intf, timed_out_lan_commands);
 		else
 			ipmi_inc_stat(intf, timed_out_ipmb_commands);
@@ -3744,15 +3764,17 @@ static void check_msg_timeout(ipmi_smi_t
 		 */
 		ent->timeout = MAX_MSG_TIMEOUT;
 		ent->retries_left--;
-		if (ent->recv_msg->addr.addr_type == IPMI_LAN_ADDR_TYPE)
-			ipmi_inc_stat(intf, retransmitted_lan_commands);
-		else
-			ipmi_inc_stat(intf, retransmitted_ipmb_commands);
-
 		smi_msg = smi_from_recv_msg(intf, ent->recv_msg, slot,
 					    ent->seqid);
-		if (!smi_msg)
+		if (!smi_msg) {
+			if (is_lan_addr(&ent->recv_msg->addr))
+				ipmi_inc_stat(intf,
+					      dropped_rexmit_lan_commands);
+			else
+				ipmi_inc_stat(intf,
+					      dropped_rexmit_ipmb_commands);
 			return;
+		}
 
 		spin_unlock_irqrestore(&intf->seq_lock, *flags);
 
@@ -3764,10 +3786,17 @@ static void check_msg_timeout(ipmi_smi_t
 		 * resent.
 		 */
 		handlers = intf->handlers;
-		if (handlers)
+		if (handlers) {
+			if (is_lan_addr(&ent->recv_msg->addr))
+				ipmi_inc_stat(intf,
+					      retransmitted_lan_commands);
+			else
+				ipmi_inc_stat(intf,
+					      retransmitted_ipmb_commands);
+
 			intf->handlers->sender(intf->send_info,
 					       smi_msg, 0);
-		else
+		} else
 			ipmi_free_smi_msg(smi_msg);
 
 		spin_lock_irqsave(&intf->seq_lock, *flags);
_

Patches currently in -mm which might be from cminyard@mvista.com are


