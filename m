From: akpm@linux-foundation.org
Subject: [merged] ipmi-add-oem-message-handling.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:29:37 -0700
Message-ID: <200904221829.n3MITbRV005740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084AbZDVSc2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:32:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dannf@hp.com, cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: add oem message handling
has been removed from the -mm tree.  Its filename was
     ipmi-add-oem-message-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: add oem message handling
From: dann frazier <dannf@hp.com>

Enable userspace to receive messages that a BMC transmits using an OEM
medium.  This is used by the HP iLO2.

Based on code originally written by Patrick Schoeller.

Signed-off-by: dann frazier <dannf@hp.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |  138 +++++++++++++++++++++++++-
 include/linux/ipmi.h                |    2 
 include/linux/ipmi_msgdefs.h        |    2 
 3 files changed, 137 insertions(+), 5 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-add-oem-message-handling drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-add-oem-message-handling
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -3284,6 +3284,114 @@ static int handle_lan_get_msg_cmd(ipmi_s
 	return rv;
 }
 
+/*
+ * This routine will handle "Get Message" command responses with
+ * channels that use an OEM Medium. The message format belongs to
+ * the OEM.  See IPMI 2.0 specification, Chapter 6 and
+ * Chapter 22, sections 22.6 and 22.24 for more details.
+ */
+static int handle_oem_get_msg_cmd(ipmi_smi_t          intf,
+				  struct ipmi_smi_msg *msg)
+{
+	struct cmd_rcvr       *rcvr;
+	int                   rv = 0;
+	unsigned char         netfn;
+	unsigned char         cmd;
+	unsigned char         chan;
+	ipmi_user_t           user = NULL;
+	struct ipmi_system_interface_addr *smi_addr;
+	struct ipmi_recv_msg  *recv_msg;
+
+	/*
+	 * We expect the OEM SW to perform error checking
+	 * so we just do some basic sanity checks
+	 */
+	if (msg->rsp_size < 4) {
+		/* Message not big enough, just ignore it. */
+		ipmi_inc_stat(intf, invalid_commands);
+		return 0;
+	}
+
+	if (msg->rsp[2] != 0) {
+		/* An error getting the response, just ignore it. */
+		return 0;
+	}
+
+	/*
+	 * This is an OEM Message so the OEM needs to know how
+	 * handle the message. We do no interpretation.
+	 */
+	netfn = msg->rsp[0] >> 2;
+	cmd = msg->rsp[1];
+	chan = msg->rsp[3] & 0xf;
+
+	rcu_read_lock();
+	rcvr = find_cmd_rcvr(intf, netfn, cmd, chan);
+	if (rcvr) {
+		user = rcvr->user;
+		kref_get(&user->refcount);
+	} else
+		user = NULL;
+	rcu_read_unlock();
+
+	if (user == NULL) {
+		/* We didn't find a user, just give up. */
+		ipmi_inc_stat(intf, unhandled_commands);
+
+		/*
+		 * Don't do anything with these messages, just allow
+		 * them to be freed.
+		 */
+
+		rv = 0;
+	} else {
+		/* Deliver the message to the user. */
+		ipmi_inc_stat(intf, handled_commands);
+
+		recv_msg = ipmi_alloc_recv_msg();
+		if (!recv_msg) {
+			/*
+			 * We couldn't allocate memory for the
+			 * message, so requeue it for handling
+			 * later.
+			 */
+			rv = 1;
+			kref_put(&user->refcount, free_user);
+		} else {
+			/*
+			 * OEM Messages are expected to be delivered via
+			 * the system interface to SMS software.  We might
+			 * need to visit this again depending on OEM
+			 * requirements
+			 */
+			smi_addr = ((struct ipmi_system_interface_addr *)
+				    &(recv_msg->addr));
+			smi_addr->addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
+			smi_addr->channel = IPMI_BMC_CHANNEL;
+			smi_addr->lun = msg->rsp[0] & 3;
+
+			recv_msg->user = user;
+			recv_msg->user_msg_data = NULL;
+			recv_msg->recv_type = IPMI_OEM_RECV_TYPE;
+			recv_msg->msg.netfn = msg->rsp[0] >> 2;
+			recv_msg->msg.cmd = msg->rsp[1];
+			recv_msg->msg.data = recv_msg->msg_data;
+
+			/*
+			 * The message starts at byte 4 which follows the
+			 * the Channel Byte in the "GET MESSAGE" command
+			 */
+			recv_msg->msg.data_len = msg->rsp_size - 4;
+			memcpy(recv_msg->msg_data,
+			       &(msg->rsp[4]),
+			       msg->rsp_size - 4);
+			deliver_response(recv_msg);
+		}
+	}
+
+	return rv;
+}
+
 static void copy_event_into_recv_msg(struct ipmi_recv_msg *recv_msg,
 				     struct ipmi_smi_msg  *msg)
 {
@@ -3539,6 +3647,17 @@ static int handle_new_recv_msg(ipmi_smi_
 			goto out;
 		}
 
+		/*
+		** We need to make sure the channels have been initialized.
+		** The channel_handler routine will set the "curr_channel"
+		** equal to or greater than IPMI_MAX_CHANNELS when all the
+		** channels for this interface have been initialized.
+		*/
+		if (intf->curr_channel < IPMI_MAX_CHANNELS) {
+			requeue = 1;     /* Just put the message back for now */
+			goto out;
+		}
+
 		switch (intf->channels[chan].medium) {
 		case IPMI_CHANNEL_MEDIUM_IPMB:
 			if (msg->rsp[4] & 0x04) {
@@ -3574,11 +3693,20 @@ static int handle_new_recv_msg(ipmi_smi_
 			break;
 
 		default:
-			/*
-			 * We don't handle the channel type, so just
-			 * free the message.
-			 */
-			requeue = 0;
+			/* Check for OEM Channels.  Clients had better
+			   register for these commands. */
+			if ((intf->channels[chan].medium
+			     >= IPMI_CHANNEL_MEDIUM_OEM_MIN)
+			    && (intf->channels[chan].medium
+				<= IPMI_CHANNEL_MEDIUM_OEM_MAX)) {
+				requeue = handle_oem_get_msg_cmd(intf, msg);
+			} else {
+				/*
+				 * We don't handle the channel type, so just
+				 * free the message.
+				 */
+				requeue = 0;
+			}
 		}
 
 	} else if ((msg->rsp[0] == ((IPMI_NETFN_APP_REQUEST|1) << 2))
diff -puN include/linux/ipmi.h~ipmi-add-oem-message-handling include/linux/ipmi.h
--- a/include/linux/ipmi.h~ipmi-add-oem-message-handling
+++ a/include/linux/ipmi.h
@@ -198,6 +198,8 @@ struct kernel_ipmi_msg {
 					      response.  When you send a
 					      response message, this will
 					      be returned. */
+#define IPMI_OEM_RECV_TYPE		5 /* The response for OEM Channels */
+
 /* Note that async events and received commands do not have a completion
    code as the first byte of the incoming data, unlike a response. */
 
diff -puN include/linux/ipmi_msgdefs.h~ipmi-add-oem-message-handling include/linux/ipmi_msgdefs.h
--- a/include/linux/ipmi_msgdefs.h~ipmi-add-oem-message-handling
+++ a/include/linux/ipmi_msgdefs.h
@@ -115,5 +115,7 @@
 #define IPMI_CHANNEL_MEDIUM_USB1	10
 #define IPMI_CHANNEL_MEDIUM_USB2	11
 #define IPMI_CHANNEL_MEDIUM_SYSINTF	12
+#define IPMI_CHANNEL_MEDIUM_OEM_MIN	0x60
+#define IPMI_CHANNEL_MEDIUM_OEM_MAX	0x7f
 
 #endif /* __LINUX_IPMI_MSGDEFS_H */
_

Patches currently in -mm which might be from dannf@hp.com are


