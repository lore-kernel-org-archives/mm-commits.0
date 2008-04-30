From: akpm@linux-foundation.org
Subject: - ipmi-style-fixes-in-the-base-code.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:49 -0700
Message-ID: <200804300544.m3U5inXU029446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758905AbYD3FuX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: style fixes in the base code
has been removed from the -mm tree.  Its filename was
     ipmi-style-fixes-in-the-base-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: style fixes in the base code
From: Corey Minyard <cminyard@mvista.com>

Lots of style fixes for the base IPMI driver.  No functional changes.
Basically fixes everything reported by checkpatch and fixes the comment
style.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |  995 +++++++++++++++-----------
 include/linux/ipmi.h                |   72 -
 include/linux/ipmi_smi.h            |    8 
 3 files changed, 614 insertions(+), 461 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-style-fixes-in-the-base-code drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-style-fixes-in-the-base-code
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -63,15 +63,16 @@ static struct proc_dir_entry *proc_ipmi_
 
 #define MAX_EVENTS_IN_QUEUE	25
 
-/* Don't let a message sit in a queue forever, always time it with at lest
-   the max message timer.  This is in milliseconds. */
+/*
+ * Don't let a message sit in a queue forever, always time it with at lest
+ * the max message timer.  This is in milliseconds.
+ */
 #define MAX_MSG_TIMEOUT		60000
 
 /*
  * The main "user" data structure.
  */
-struct ipmi_user
-{
+struct ipmi_user {
 	struct list_head link;
 
 	/* Set to "0" when the user is destroyed. */
@@ -90,8 +91,7 @@ struct ipmi_user
 	int gets_events;
 };
 
-struct cmd_rcvr
-{
+struct cmd_rcvr {
 	struct list_head link;
 
 	ipmi_user_t   user;
@@ -105,12 +105,12 @@ struct cmd_rcvr
 	 * or change any data until the RCU period completes.  So we
 	 * use this next variable during mass deletion so we can have
 	 * a list and don't have to wait and restart the search on
-	 * every individual deletion of a command. */
+	 * every individual deletion of a command.
+	 */
 	struct cmd_rcvr *next;
 };
 
-struct seq_table
-{
+struct seq_table {
 	unsigned int         inuse : 1;
 	unsigned int         broadcast : 1;
 
@@ -118,53 +118,60 @@ struct seq_table
 	unsigned long        orig_timeout;
 	unsigned int         retries_left;
 
-	/* To verify on an incoming send message response that this is
-           the message that the response is for, we keep a sequence id
-           and increment it every time we send a message. */
+	/*
+	 * To verify on an incoming send message response that this is
+	 * the message that the response is for, we keep a sequence id
+	 * and increment it every time we send a message.
+	 */
 	long                 seqid;
 
-	/* This is held so we can properly respond to the message on a
-           timeout, and it is used to hold the temporary data for
-           retransmission, too. */
+	/*
+	 * This is held so we can properly respond to the message on a
+	 * timeout, and it is used to hold the temporary data for
+	 * retransmission, too.
+	 */
 	struct ipmi_recv_msg *recv_msg;
 };
 
-/* Store the information in a msgid (long) to allow us to find a
-   sequence table entry from the msgid. */
+/*
+ * Store the information in a msgid (long) to allow us to find a
+ * sequence table entry from the msgid.
+ */
 #define STORE_SEQ_IN_MSGID(seq, seqid) (((seq&0xff)<<26) | (seqid&0x3ffffff))
 
 #define GET_SEQ_FROM_MSGID(msgid, seq, seqid) \
 	do {								\
 		seq = ((msgid >> 26) & 0x3f);				\
 		seqid = (msgid & 0x3fffff);				\
-        } while (0)
+	} while (0)
 
 #define NEXT_SEQID(seqid) (((seqid) + 1) & 0x3fffff)
 
-struct ipmi_channel
-{
+struct ipmi_channel {
 	unsigned char medium;
 	unsigned char protocol;
 
-	/* My slave address.  This is initialized to IPMI_BMC_SLAVE_ADDR,
-	   but may be changed by the user. */
+	/*
+	 * My slave address.  This is initialized to IPMI_BMC_SLAVE_ADDR,
+	 * but may be changed by the user.
+	 */
 	unsigned char address;
 
-	/* My LUN.  This should generally stay the SMS LUN, but just in
-	   case... */
+	/*
+	 * My LUN.  This should generally stay the SMS LUN, but just in
+	 * case...
+	 */
 	unsigned char lun;
 };
 
 #ifdef CONFIG_PROC_FS
-struct ipmi_proc_entry
-{
+struct ipmi_proc_entry {
 	char                   *name;
 	struct ipmi_proc_entry *next;
 };
 #endif
 
-struct bmc_device
-{
+struct bmc_device {
 	struct platform_device *dev;
 	struct ipmi_device_id  id;
 	unsigned char          guid[16];
@@ -286,8 +293,7 @@ enum ipmi_stat_indexes {
 
 #define IPMI_IPMB_NUM_SEQ	64
 #define IPMI_MAX_CHANNELS       16
-struct ipmi_smi
-{
+struct ipmi_smi {
 	/* What interface number are we? */
 	int intf_num;
 
@@ -296,8 +302,10 @@ struct ipmi_smi
 	/* Used for a list of interfaces. */
 	struct list_head link;
 
-	/* The list of upper layers that are using me.  seq_lock
-	 * protects this. */
+	/*
+	 * The list of upper layers that are using me.  seq_lock
+	 * protects this.
+	 */
 	struct list_head users;
 
 	/* Information to supply to users. */
@@ -311,10 +319,12 @@ struct ipmi_smi
 	char *my_dev_name;
 	char *sysfs_name;
 
-	/* This is the lower-layer's sender routine.  Note that you
+	/*
+	 * This is the lower-layer's sender routine.  Note that you
 	 * must either be holding the ipmi_interfaces_mutex or be in
 	 * an umpreemptible region to use this.  You must fetch the
-	 * value into a local variable and make sure it is not NULL. */
+	 * value into a local variable and make sure it is not NULL.
+	 */
 	struct ipmi_smi_handlers *handlers;
 	void                     *send_info;
 
@@ -327,35 +337,45 @@ struct ipmi_smi
 	/* Driver-model device for the system interface. */
 	struct device          *si_dev;
 
-	/* A table of sequence numbers for this interface.  We use the
-           sequence numbers for IPMB messages that go out of the
-           interface to match them up with their responses.  A routine
-           is called periodically to time the items in this list. */
+	/*
+	 * A table of sequence numbers for this interface.  We use the
+	 * sequence numbers for IPMB messages that go out of the
+	 * interface to match them up with their responses.  A routine
+	 * is called periodically to time the items in this list.
+	 */
 	spinlock_t       seq_lock;
 	struct seq_table seq_table[IPMI_IPMB_NUM_SEQ];
 	int curr_seq;
 
-	/* Messages that were delayed for some reason (out of memory,
-           for instance), will go in here to be processed later in a
-           periodic timer interrupt. */
+	/*
+	 * Messages that were delayed for some reason (out of memory,
+	 * for instance), will go in here to be processed later in a
+	 * periodic timer interrupt.
+	 */
 	spinlock_t       waiting_msgs_lock;
 	struct list_head waiting_msgs;
 
-	/* The list of command receivers that are registered for commands
-	   on this interface. */
+	/*
+	 * The list of command receivers that are registered for commands
+	 * on this interface.
+	 */
 	struct mutex     cmd_rcvrs_mutex;
 	struct list_head cmd_rcvrs;
 
-	/* Events that were queues because no one was there to receive
-           them. */
+	/*
+	 * Events that were queues because no one was there to receive
+	 * them.
+	 */
 	spinlock_t       events_lock; /* For dealing with event stuff. */
 	struct list_head waiting_events;
 	unsigned int     waiting_events_count; /* How many events in queue? */
 	char             delivering_events;
 	char             event_msg_printed;
 
-	/* The event receiver for my BMC, only really used at panic
-	   shutdown as a place to store this. */
+	/*
+	 * The event receiver for my BMC, only really used at panic
+	 * shutdown as a place to store this.
+	 */
 	unsigned char event_receiver;
 	unsigned char event_receiver_lun;
 	unsigned char local_sel_device;
@@ -367,14 +387,18 @@ struct ipmi_smi
 	int auto_maintenance_timeout;
 	spinlock_t maintenance_mode_lock; /* Used in a timer... */
 
-	/* A cheap hack, if this is non-null and a message to an
-	   interface comes in with a NULL user, call this routine with
-	   it.  Note that the message will still be freed by the
-	   caller.  This only works on the system interface. */
+	/*
+	 * A cheap hack, if this is non-null and a message to an
+	 * interface comes in with a NULL user, call this routine with
+	 * it.  Note that the message will still be freed by the
+	 * caller.  This only works on the system interface.
+	 */
 	void (*null_user_handler)(ipmi_smi_t intf, struct ipmi_recv_msg *msg);
 
-	/* When we are scanning the channels for an SMI, this will
-	   tell which channel we are scanning. */
+	/*
+	 * When we are scanning the channels for an SMI, this will
+	 * tell which channel we are scanning.
+	 */
 	int curr_channel;
 
 	/* Channel information */
@@ -407,8 +431,9 @@ static DEFINE_MUTEX(ipmidriver_mutex);
 static LIST_HEAD(ipmi_interfaces);
 static DEFINE_MUTEX(ipmi_interfaces_mutex);
 
-/* List of watchers that want to know when smi's are added and
-   deleted. */
+/*
+ * List of watchers that want to know when smi's are added and deleted.
+ */
 static LIST_HEAD(smi_watchers);
 static DEFINE_MUTEX(smi_watchers_mutex);
 
@@ -462,10 +487,8 @@ static void clean_up_interface_data(ipmi
 
 	for (i = 0; i < IPMI_IPMB_NUM_SEQ; i++) {
 		if ((intf->seq_table[i].inuse)
-		    && (intf->seq_table[i].recv_msg))
-		{
+					&& (intf->seq_table[i].recv_msg))
 			ipmi_free_recv_msg(intf->seq_table[i].recv_msg);
-		}
 	}
 }
 
@@ -532,6 +555,7 @@ int ipmi_smi_watcher_register(struct ipm
 	}
 	return -ENOMEM;
 }
+EXPORT_SYMBOL(ipmi_smi_watcher_register);
 
 int ipmi_smi_watcher_unregister(struct ipmi_smi_watcher *watcher)
 {
@@ -540,6 +564,7 @@ int ipmi_smi_watcher_unregister(struct i
 	mutex_unlock(&smi_watchers_mutex);
 	return 0;
 }
+EXPORT_SYMBOL(ipmi_smi_watcher_unregister);
 
 /*
  * Must be called with smi_watchers_mutex held.
@@ -575,8 +600,7 @@ ipmi_addr_equal(struct ipmi_addr *addr1,
 	}
 
 	if ((addr1->addr_type == IPMI_IPMB_ADDR_TYPE)
-	    || (addr1->addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE))
-	{
+	    || (addr1->addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE)) {
 		struct ipmi_ipmb_addr *ipmb_addr1
 		    = (struct ipmi_ipmb_addr *) addr1;
 		struct ipmi_ipmb_addr *ipmb_addr2
@@ -604,9 +628,8 @@ ipmi_addr_equal(struct ipmi_addr *addr1,
 
 int ipmi_validate_addr(struct ipmi_addr *addr, int len)
 {
-	if (len < sizeof(struct ipmi_system_interface_addr)) {
+	if (len < sizeof(struct ipmi_system_interface_addr))
 		return -EINVAL;
-	}
 
 	if (addr->addr_type == IPMI_SYSTEM_INTERFACE_ADDR_TYPE) {
 		if (addr->channel != IPMI_BMC_CHANNEL)
@@ -620,23 +643,21 @@ int ipmi_validate_addr(struct ipmi_addr 
 		return -EINVAL;
 
 	if ((addr->addr_type == IPMI_IPMB_ADDR_TYPE)
-	    || (addr->addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE))
-	{
-		if (len < sizeof(struct ipmi_ipmb_addr)) {
+	    || (addr->addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE)) {
+		if (len < sizeof(struct ipmi_ipmb_addr))
 			return -EINVAL;
-		}
 		return 0;
 	}
 
 	if (addr->addr_type == IPMI_LAN_ADDR_TYPE) {
-		if (len < sizeof(struct ipmi_lan_addr)) {
+		if (len < sizeof(struct ipmi_lan_addr))
 			return -EINVAL;
-		}
 		return 0;
 	}
 
 	return -EINVAL;
 }
+EXPORT_SYMBOL(ipmi_validate_addr);
 
 unsigned int ipmi_addr_length(int addr_type)
 {
@@ -644,16 +665,15 @@ unsigned int ipmi_addr_length(int addr_t
 		return sizeof(struct ipmi_system_interface_addr);
 
 	if ((addr_type == IPMI_IPMB_ADDR_TYPE)
-	    || (addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE))
-	{
+			|| (addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE))
 		return sizeof(struct ipmi_ipmb_addr);
-	}
 
 	if (addr_type == IPMI_LAN_ADDR_TYPE)
 		return sizeof(struct ipmi_lan_addr);
 
 	return 0;
 }
+EXPORT_SYMBOL(ipmi_addr_length);
 
 static void deliver_response(struct ipmi_recv_msg *msg)
 {
@@ -686,9 +706,11 @@ deliver_err_response(struct ipmi_recv_ms
 	deliver_response(msg);
 }
 
-/* Find the next sequence number not being used and add the given
-   message with the given timeout to the sequence table.  This must be
-   called with the interface's seq_lock held. */
+/*
+ * Find the next sequence number not being used and add the given
+ * message with the given timeout to the sequence table.  This must be
+ * called with the interface's seq_lock held.
+ */
 static int intf_next_seq(ipmi_smi_t           intf,
 			 struct ipmi_recv_msg *recv_msg,
 			 unsigned long        timeout,
@@ -700,10 +722,8 @@ static int intf_next_seq(ipmi_smi_t     
 	int          rv = 0;
 	unsigned int i;
 
-	for (i = intf->curr_seq;
-	     (i+1)%IPMI_IPMB_NUM_SEQ != intf->curr_seq;
-	     i = (i+1)%IPMI_IPMB_NUM_SEQ)
-	{
+	for (i = intf->curr_seq; (i+1)%IPMI_IPMB_NUM_SEQ != intf->curr_seq;
+					i = (i+1)%IPMI_IPMB_NUM_SEQ) {
 		if (!intf->seq_table[i].inuse)
 			break;
 	}
@@ -711,8 +731,10 @@ static int intf_next_seq(ipmi_smi_t     
 	if (!intf->seq_table[i].inuse) {
 		intf->seq_table[i].recv_msg = recv_msg;
 
-		/* Start with the maximum timeout, when the send response
-		   comes in we will start the real timer. */
+		/*
+		 * Start with the maximum timeout, when the send response
+		 * comes in we will start the real timer.
+		 */
 		intf->seq_table[i].timeout = MAX_MSG_TIMEOUT;
 		intf->seq_table[i].orig_timeout = timeout;
 		intf->seq_table[i].retries_left = retries;
@@ -725,15 +747,17 @@ static int intf_next_seq(ipmi_smi_t     
 	} else {
 		rv = -EAGAIN;
 	}
-	
+
 	return rv;
 }
 
-/* Return the receive message for the given sequence number and
-   release the sequence number so it can be reused.  Some other data
-   is passed in to be sure the message matches up correctly (to help
-   guard against message coming in after their timeout and the
-   sequence number being reused). */
+/*
+ * Return the receive message for the given sequence number and
+ * release the sequence number so it can be reused.  Some other data
+ * is passed in to be sure the message matches up correctly (to help
+ * guard against message coming in after their timeout and the
+ * sequence number being reused).
+ */
 static int intf_find_seq(ipmi_smi_t           intf,
 			 unsigned char        seq,
 			 short                channel,
@@ -752,11 +776,9 @@ static int intf_find_seq(ipmi_smi_t     
 	if (intf->seq_table[seq].inuse) {
 		struct ipmi_recv_msg *msg = intf->seq_table[seq].recv_msg;
 
-		if ((msg->addr.channel == channel)
-		    && (msg->msg.cmd == cmd)
-		    && (msg->msg.netfn == netfn)
-		    && (ipmi_addr_equal(addr, &(msg->addr))))
-		{
+		if ((msg->addr.channel == channel) && (msg->msg.cmd == cmd)
+				&& (msg->msg.netfn == netfn)
+				&& (ipmi_addr_equal(addr, &(msg->addr)))) {
 			*recv_msg = msg;
 			intf->seq_table[seq].inuse = 0;
 			rv = 0;
@@ -781,11 +803,12 @@ static int intf_start_seq_timer(ipmi_smi
 	GET_SEQ_FROM_MSGID(msgid, seq, seqid);
 
 	spin_lock_irqsave(&(intf->seq_lock), flags);
-	/* We do this verification because the user can be deleted
-           while a message is outstanding. */
+	/*
+	 * We do this verification because the user can be deleted
+	 * while a message is outstanding.
+	 */
 	if ((intf->seq_table[seq].inuse)
-	    && (intf->seq_table[seq].seqid == seqid))
-	{
+				&& (intf->seq_table[seq].seqid == seqid)) {
 		struct seq_table *ent = &(intf->seq_table[seq]);
 		ent->timeout = ent->orig_timeout;
 		rv = 0;
@@ -810,11 +833,12 @@ static int intf_err_seq(ipmi_smi_t   int
 	GET_SEQ_FROM_MSGID(msgid, seq, seqid);
 
 	spin_lock_irqsave(&(intf->seq_lock), flags);
-	/* We do this verification because the user can be deleted
-           while a message is outstanding. */
+	/*
+	 * We do this verification because the user can be deleted
+	 * while a message is outstanding.
+	 */
 	if ((intf->seq_table[seq].inuse)
-	    && (intf->seq_table[seq].seqid == seqid))
-	{
+				&& (intf->seq_table[seq].seqid == seqid)) {
 		struct seq_table *ent = &(intf->seq_table[seq]);
 
 		ent->inuse = 0;
@@ -840,24 +864,30 @@ int ipmi_create_user(unsigned int       
 	int           rv = 0;
 	ipmi_smi_t    intf;
 
-	/* There is no module usecount here, because it's not
-           required.  Since this can only be used by and called from
-           other modules, they will implicitly use this module, and
-           thus this can't be removed unless the other modules are
-           removed. */
+	/*
+	 * There is no module usecount here, because it's not
+	 * required.  Since this can only be used by and called from
+	 * other modules, they will implicitly use this module, and
+	 * thus this can't be removed unless the other modules are
+	 * removed.
+	 */
 
 	if (handler == NULL)
 		return -EINVAL;
 
-	/* Make sure the driver is actually initialized, this handles
-	   problems with initialization order. */
+	/*
+	 * Make sure the driver is actually initialized, this handles
+	 * problems with initialization order.
+	 */
 	if (!initialized) {
 		rv = ipmi_init_msghandler();
 		if (rv)
 			return rv;
 
-		/* The init code doesn't return an error if it was turned
-		   off, but it won't initialize.  Check that. */
+		/*
+		 * The init code doesn't return an error if it was turned
+		 * off, but it won't initialize.  Check that.
+		 */
 		if (!initialized)
 			return -ENODEV;
 	}
@@ -898,8 +928,10 @@ int ipmi_create_user(unsigned int       
 		}
 	}
 
-	/* Hold the lock so intf->handlers is guaranteed to be good
-	 * until now */
+	/*
+	 * Hold the lock so intf->handlers is guaranteed to be good
+	 * until now
+	 */
 	mutex_unlock(&ipmi_interfaces_mutex);
 
 	new_user->valid = 1;
@@ -916,6 +948,7 @@ out_kfree:
 	kfree(new_user);
 	return rv;
 }
+EXPORT_SYMBOL(ipmi_create_user);
 
 static void free_user(struct kref *ref)
 {
@@ -939,8 +972,7 @@ int ipmi_destroy_user(ipmi_user_t user)
 
 	for (i = 0; i < IPMI_IPMB_NUM_SEQ; i++) {
 		if (intf->seq_table[i].inuse
-		    && (intf->seq_table[i].recv_msg->user == user))
-		{
+		    && (intf->seq_table[i].recv_msg->user == user)) {
 			intf->seq_table[i].inuse = 0;
 			ipmi_free_recv_msg(intf->seq_table[i].recv_msg);
 		}
@@ -983,6 +1015,7 @@ int ipmi_destroy_user(ipmi_user_t user)
 
 	return 0;
 }
+EXPORT_SYMBOL(ipmi_destroy_user);
 
 void ipmi_get_version(ipmi_user_t   user,
 		      unsigned char *major,
@@ -991,6 +1024,7 @@ void ipmi_get_version(ipmi_user_t   user
 	*major = user->intf->ipmi_version_major;
 	*minor = user->intf->ipmi_version_minor;
 }
+EXPORT_SYMBOL(ipmi_get_version);
 
 int ipmi_set_my_address(ipmi_user_t   user,
 			unsigned int  channel,
@@ -1001,6 +1035,7 @@ int ipmi_set_my_address(ipmi_user_t   us
 	user->intf->channels[channel].address = address;
 	return 0;
 }
+EXPORT_SYMBOL(ipmi_set_my_address);
 
 int ipmi_get_my_address(ipmi_user_t   user,
 			unsigned int  channel,
@@ -1011,6 +1046,7 @@ int ipmi_get_my_address(ipmi_user_t   us
 	*address = user->intf->channels[channel].address;
 	return 0;
 }
+EXPORT_SYMBOL(ipmi_get_my_address);
 
 int ipmi_set_my_LUN(ipmi_user_t   user,
 		    unsigned int  channel,
@@ -1021,6 +1057,7 @@ int ipmi_set_my_LUN(ipmi_user_t   user,
 	user->intf->channels[channel].lun = LUN & 0x3;
 	return 0;
 }
+EXPORT_SYMBOL(ipmi_set_my_LUN);
 
 int ipmi_get_my_LUN(ipmi_user_t   user,
 		    unsigned int  channel,
@@ -1031,6 +1068,7 @@ int ipmi_get_my_LUN(ipmi_user_t   user,
 	*address = user->intf->channels[channel].lun;
 	return 0;
 }
+EXPORT_SYMBOL(ipmi_get_my_LUN);
 
 int ipmi_get_maintenance_mode(ipmi_user_t user)
 {
@@ -1139,6 +1177,7 @@ int ipmi_set_gets_events(ipmi_user_t use
 
 	return 0;
 }
+EXPORT_SYMBOL(ipmi_set_gets_events);
 
 static struct cmd_rcvr *find_cmd_rcvr(ipmi_smi_t    intf,
 				      unsigned char netfn,
@@ -1204,6 +1243,7 @@ int ipmi_register_for_cmd(ipmi_user_t   
 
 	return rv;
 }
+EXPORT_SYMBOL(ipmi_register_for_cmd);
 
 int ipmi_unregister_for_cmd(ipmi_user_t   user,
 			    unsigned char netfn,
@@ -1241,12 +1281,13 @@ int ipmi_unregister_for_cmd(ipmi_user_t 
 	}
 	return rv;
 }
+EXPORT_SYMBOL(ipmi_unregister_for_cmd);
 
 static unsigned char
 ipmb_checksum(unsigned char *data, int size)
 {
 	unsigned char csum = 0;
-	
+
 	for (; size > 0; size--, data++)
 		csum += *data;
 
@@ -1288,8 +1329,10 @@ static inline void format_ipmb_msg(struc
 		= ipmb_checksum(&(smi_msg->data[i+6]),
 				smi_msg->data_size-6);
 
-	/* Add on the checksum size and the offset from the
-	   broadcast. */
+	/*
+	 * Add on the checksum size and the offset from the
+	 * broadcast.
+	 */
 	smi_msg->data_size += 1 + i;
 
 	smi_msg->msgid = msgid;
@@ -1325,17 +1368,21 @@ static inline void format_lan_msg(struct
 		= ipmb_checksum(&(smi_msg->data[7]),
 				smi_msg->data_size-7);
 
-	/* Add on the checksum size and the offset from the
-	   broadcast. */
+	/*
+	 * Add on the checksum size and the offset from the
+	 * broadcast.
+	 */
 	smi_msg->data_size += 1;
 
 	smi_msg->msgid = msgid;
 }
 
-/* Separate from ipmi_request so that the user does not have to be
-   supplied in certain circumstances (mainly at panic time).  If
-   messages are supplied, they will be freed, even if an error
-   occurs. */
+/*
+ * Separate from ipmi_request so that the user does not have to be
+ * supplied in certain circumstances (mainly at panic time).  If
+ * messages are supplied, they will be freed, even if an error
+ * occurs.
+ */
 static int i_ipmi_request(ipmi_user_t          user,
 			  ipmi_smi_t           intf,
 			  struct ipmi_addr     *addr,
@@ -1357,19 +1404,18 @@ static int i_ipmi_request(ipmi_user_t   
 	struct ipmi_smi_handlers *handlers;
 
 
-	if (supplied_recv) {
+	if (supplied_recv)
 		recv_msg = supplied_recv;
-	} else {
+	else {
 		recv_msg = ipmi_alloc_recv_msg();
-		if (recv_msg == NULL) {
+		if (recv_msg == NULL)
 			return -ENOMEM;
-		}
 	}
 	recv_msg->user_msg_data = user_msg_data;
 
-	if (supplied_smi) {
+	if (supplied_smi)
 		smi_msg = (struct ipmi_smi_msg *) supplied_smi;
-	} else {
+	else {
 		smi_msg = ipmi_alloc_smi_msg();
 		if (smi_msg == NULL) {
 			ipmi_free_recv_msg(recv_msg);
@@ -1388,8 +1434,10 @@ static int i_ipmi_request(ipmi_user_t   
 	if (user)
 		kref_get(&user->refcount);
 	recv_msg->msgid = msgid;
-	/* Store the message to send in the receive message so timeout
-	   responses can get the proper response data. */
+	/*
+	 * Store the message to send in the receive message so timeout
+	 * responses can get the proper response data.
+	 */
 	recv_msg->msg = *msg;
 
 	if (addr->addr_type == IPMI_SYSTEM_INTERFACE_ADDR_TYPE) {
@@ -1413,10 +1461,11 @@ static int i_ipmi_request(ipmi_user_t   
 		if ((msg->netfn == IPMI_NETFN_APP_REQUEST)
 		    && ((msg->cmd == IPMI_SEND_MSG_CMD)
 			|| (msg->cmd == IPMI_GET_MSG_CMD)
-			|| (msg->cmd == IPMI_READ_EVENT_MSG_BUFFER_CMD)))
-		{
-			/* We don't let the user do these, since we manage
-			   the sequence numbers. */
+			|| (msg->cmd == IPMI_READ_EVENT_MSG_BUFFER_CMD))) {
+			/*
+			 * We don't let the user do these, since we manage
+			 * the sequence numbers.
+			 */
 			ipmi_inc_stat(intf, sent_invalid_commands);
 			rv = -EINVAL;
 			goto out_err;
@@ -1425,14 +1474,12 @@ static int i_ipmi_request(ipmi_user_t   
 		if (((msg->netfn == IPMI_NETFN_APP_REQUEST)
 		      && ((msg->cmd == IPMI_COLD_RESET_CMD)
 			  || (msg->cmd == IPMI_WARM_RESET_CMD)))
-		     || (msg->netfn == IPMI_NETFN_FIRMWARE_REQUEST))
-		{
+		     || (msg->netfn == IPMI_NETFN_FIRMWARE_REQUEST)) {
 			spin_lock_irqsave(&intf->maintenance_mode_lock, flags);
 			intf->auto_maintenance_timeout
 				= IPMI_MAINTENANCE_MODE_TIMEOUT;
 			if (!intf->maintenance_mode
-			    && !intf->maintenance_mode_enable)
-			{
+			    && !intf->maintenance_mode_enable) {
 				intf->maintenance_mode_enable = 1;
 				maintenance_mode_update(intf);
 			}
@@ -1455,8 +1502,7 @@ static int i_ipmi_request(ipmi_user_t   
 		smi_msg->data_size = msg->data_len + 2;
 		ipmi_inc_stat(intf, sent_local_commands);
 	} else if ((addr->addr_type == IPMI_IPMB_ADDR_TYPE)
-		   || (addr->addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE))
-	{
+		   || (addr->addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE)) {
 		struct ipmi_ipmb_addr *ipmb_addr;
 		unsigned char         ipmb_seq;
 		long                  seqid;
@@ -1469,8 +1515,7 @@ static int i_ipmi_request(ipmi_user_t   
 		}
 
 		if (intf->channels[addr->channel].medium
-		    != IPMI_CHANNEL_MEDIUM_IPMB)
-		{
+					!= IPMI_CHANNEL_MEDIUM_IPMB) {
 			ipmi_inc_stat(intf, sent_invalid_commands);
 			rv = -EINVAL;
 			goto out_err;
@@ -1483,9 +1528,11 @@ static int i_ipmi_request(ipmi_user_t   
 			retries = 4;
 		}
 		if (addr->addr_type == IPMI_IPMB_BROADCAST_ADDR_TYPE) {
-		    /* Broadcasts add a zero at the beginning of the
-		       message, but otherwise is the same as an IPMB
-		       address. */
+		    /*
+		     * Broadcasts add a zero at the beginning of the
+		     * message, but otherwise is the same as an IPMB
+		     * address.
+		     */
 		    addr->addr_type = IPMI_IPMB_ADDR_TYPE;
 		    broadcast = 1;
 		}
@@ -1495,8 +1542,10 @@ static int i_ipmi_request(ipmi_user_t   
 		if (retry_time_ms == 0)
 		    retry_time_ms = 1000;
 
-		/* 9 for the header and 1 for the checksum, plus
-                   possibly one for the broadcast. */
+		/*
+		 * 9 for the header and 1 for the checksum, plus
+		 * possibly one for the broadcast.
+		 */
 		if ((msg->data_len + 10 + broadcast) > IPMI_MAX_MSG_LENGTH) {
 			ipmi_inc_stat(intf, sent_invalid_commands);
 			rv = -EMSGSIZE;
@@ -1513,15 +1562,19 @@ static int i_ipmi_request(ipmi_user_t   
 		memcpy(&recv_msg->addr, ipmb_addr, sizeof(*ipmb_addr));
 
 		if (recv_msg->msg.netfn & 0x1) {
-			/* It's a response, so use the user's sequence
-                           from msgid. */
+			/*
+			 * It's a response, so use the user's sequence
+			 * from msgid.
+			 */
 			ipmi_inc_stat(intf, sent_ipmb_responses);
 			format_ipmb_msg(smi_msg, msg, ipmb_addr, msgid,
 					msgid, broadcast,
 					source_address, source_lun);
 
-			/* Save the receive message so we can use it
-			   to deliver the response. */
+			/*
+			 * Save the receive message so we can use it
+			 * to deliver the response.
+			 */
 			smi_msg->user_data = recv_msg;
 		} else {
 			/* It's a command, so get a sequence for it. */
@@ -1530,8 +1583,10 @@ static int i_ipmi_request(ipmi_user_t   
 
 			ipmi_inc_stat(intf, sent_ipmb_commands);
 
-			/* Create a sequence number with a 1 second
-                           timeout and 4 retries. */
+			/*
+			 * Create a sequence number with a 1 second
+			 * timeout and 4 retries.
+			 */
 			rv = intf_next_seq(intf,
 					   recv_msg,
 					   retry_time_ms,
@@ -1540,34 +1595,42 @@ static int i_ipmi_request(ipmi_user_t   
 					   &ipmb_seq,
 					   &seqid);
 			if (rv) {
-				/* We have used up all the sequence numbers,
-				   probably, so abort. */
+				/*
+				 * We have used up all the sequence numbers,
+				 * probably, so abort.
+				 */
 				spin_unlock_irqrestore(&(intf->seq_lock),
 						       flags);
 				goto out_err;
 			}
 
-			/* Store the sequence number in the message,
-                           so that when the send message response
-                           comes back we can start the timer. */
+			/*
+			 * Store the sequence number in the message,
+			 * so that when the send message response
+			 * comes back we can start the timer.
+			 */
 			format_ipmb_msg(smi_msg, msg, ipmb_addr,
 					STORE_SEQ_IN_MSGID(ipmb_seq, seqid),
 					ipmb_seq, broadcast,
 					source_address, source_lun);
 
-			/* Copy the message into the recv message data, so we
-			   can retransmit it later if necessary. */
+			/*
+			 * Copy the message into the recv message data, so we
+			 * can retransmit it later if necessary.
+			 */
 			memcpy(recv_msg->msg_data, smi_msg->data,
 			       smi_msg->data_size);
 			recv_msg->msg.data = recv_msg->msg_data;
 			recv_msg->msg.data_len = smi_msg->data_size;
 
-			/* We don't unlock until here, because we need
-                           to copy the completed message into the
-                           recv_msg before we release the lock.
-                           Otherwise, race conditions may bite us.  I
-                           know that's pretty paranoid, but I prefer
-                           to be correct. */
+			/*
+			 * We don't unlock until here, because we need
+			 * to copy the completed message into the
+			 * recv_msg before we release the lock.
+			 * Otherwise, race conditions may bite us.  I
+			 * know that's pretty paranoid, but I prefer
+			 * to be correct.
+			 */
 			spin_unlock_irqrestore(&(intf->seq_lock), flags);
 		}
 	} else if (addr->addr_type == IPMI_LAN_ADDR_TYPE) {
@@ -1582,10 +1645,9 @@ static int i_ipmi_request(ipmi_user_t   
 		}
 
 		if ((intf->channels[addr->channel].medium
-		    != IPMI_CHANNEL_MEDIUM_8023LAN)
+				!= IPMI_CHANNEL_MEDIUM_8023LAN)
 		    && (intf->channels[addr->channel].medium
-			!= IPMI_CHANNEL_MEDIUM_ASYNC))
-		{
+				!= IPMI_CHANNEL_MEDIUM_ASYNC)) {
 			ipmi_inc_stat(intf, sent_invalid_commands);
 			rv = -EINVAL;
 			goto out_err;
@@ -1614,14 +1676,18 @@ static int i_ipmi_request(ipmi_user_t   
 		memcpy(&recv_msg->addr, lan_addr, sizeof(*lan_addr));
 
 		if (recv_msg->msg.netfn & 0x1) {
-			/* It's a response, so use the user's sequence
-                           from msgid. */
+			/*
+			 * It's a response, so use the user's sequence
+			 * from msgid.
+			 */
 			ipmi_inc_stat(intf, sent_lan_responses);
 			format_lan_msg(smi_msg, msg, lan_addr, msgid,
 				       msgid, source_lun);
 
-			/* Save the receive message so we can use it
-			   to deliver the response. */
+			/*
+			 * Save the receive message so we can use it
+			 * to deliver the response.
+			 */
 			smi_msg->user_data = recv_msg;
 		} else {
 			/* It's a command, so get a sequence for it. */
@@ -1630,8 +1696,10 @@ static int i_ipmi_request(ipmi_user_t   
 
 			ipmi_inc_stat(intf, sent_lan_commands);
 
-			/* Create a sequence number with a 1 second
-                           timeout and 4 retries. */
+			/*
+			 * Create a sequence number with a 1 second
+			 * timeout and 4 retries.
+			 */
 			rv = intf_next_seq(intf,
 					   recv_msg,
 					   retry_time_ms,
@@ -1640,33 +1708,41 @@ static int i_ipmi_request(ipmi_user_t   
 					   &ipmb_seq,
 					   &seqid);
 			if (rv) {
-				/* We have used up all the sequence numbers,
-				   probably, so abort. */
+				/*
+				 * We have used up all the sequence numbers,
+				 * probably, so abort.
+				 */
 				spin_unlock_irqrestore(&(intf->seq_lock),
 						       flags);
 				goto out_err;
 			}
 
-			/* Store the sequence number in the message,
-                           so that when the send message response
-                           comes back we can start the timer. */
+			/*
+			 * Store the sequence number in the message,
+			 * so that when the send message response
+			 * comes back we can start the timer.
+			 */
 			format_lan_msg(smi_msg, msg, lan_addr,
 				       STORE_SEQ_IN_MSGID(ipmb_seq, seqid),
 				       ipmb_seq, source_lun);
 
-			/* Copy the message into the recv message data, so we
-			   can retransmit it later if necessary. */
+			/*
+			 * Copy the message into the recv message data, so we
+			 * can retransmit it later if necessary.
+			 */
 			memcpy(recv_msg->msg_data, smi_msg->data,
 			       smi_msg->data_size);
 			recv_msg->msg.data = recv_msg->msg_data;
 			recv_msg->msg.data_len = smi_msg->data_size;
 
-			/* We don't unlock until here, because we need
-                           to copy the completed message into the
-                           recv_msg before we release the lock.
-                           Otherwise, race conditions may bite us.  I
-                           know that's pretty paranoid, but I prefer
-                           to be correct. */
+			/*
+			 * We don't unlock until here, because we need
+			 * to copy the completed message into the
+			 * recv_msg before we release the lock.
+			 * Otherwise, race conditions may bite us.  I
+			 * know that's pretty paranoid, but I prefer
+			 * to be correct.
+			 */
 			spin_unlock_irqrestore(&(intf->seq_lock), flags);
 		}
 	} else {
@@ -1739,6 +1815,7 @@ int ipmi_request_settime(ipmi_user_t    
 			      retries,
 			      retry_time_ms);
 }
+EXPORT_SYMBOL(ipmi_request_settime);
 
 int ipmi_request_supply_msgs(ipmi_user_t          user,
 			     struct ipmi_addr     *addr,
@@ -1770,6 +1847,7 @@ int ipmi_request_supply_msgs(ipmi_user_t
 			      lun,
 			      -1, 0);
 }
+EXPORT_SYMBOL(ipmi_request_supply_msgs);
 
 #ifdef CONFIG_PROC_FS
 static int ipmb_file_read_proc(char *page, char **start, off_t off,
@@ -1903,6 +1981,7 @@ int ipmi_smi_add_proc_entry(ipmi_smi_t s
 
 	return rv;
 }
+EXPORT_SYMBOL(ipmi_smi_add_proc_entry);
 
 static int add_proc_entries(ipmi_smi_t smi, int num)
 {
@@ -1913,9 +1992,8 @@ static int add_proc_entries(ipmi_smi_t s
 	smi->proc_dir = proc_mkdir(smi->proc_dir_name, proc_ipmi_root);
 	if (!smi->proc_dir)
 		rv = -ENOMEM;
-	else {
+	else
 		smi->proc_dir->owner = THIS_MODULE;
-	}
 
 	if (rv == 0)
 		rv = ipmi_smi_add_proc_entry(smi, "stats",
@@ -2214,37 +2292,47 @@ static int create_files(struct bmc_devic
 
 	err = device_create_file(&bmc->dev->dev,
 			   &bmc->device_id_attr);
-	if (err) goto out;
+	if (err)
+		goto out;
 	err = device_create_file(&bmc->dev->dev,
 			   &bmc->provides_dev_sdrs_attr);
-	if (err) goto out_devid;
+	if (err)
+		goto out_devid;
 	err = device_create_file(&bmc->dev->dev,
 			   &bmc->revision_attr);
-	if (err) goto out_sdrs;
+	if (err)
+		goto out_sdrs;
 	err = device_create_file(&bmc->dev->dev,
 			   &bmc->firmware_rev_attr);
-	if (err) goto out_rev;
+	if (err)
+		goto out_rev;
 	err = device_create_file(&bmc->dev->dev,
 			   &bmc->version_attr);
-	if (err) goto out_firm;
+	if (err)
+		goto out_firm;
 	err = device_create_file(&bmc->dev->dev,
 			   &bmc->add_dev_support_attr);
-	if (err) goto out_version;
+	if (err)
+		goto out_version;
 	err = device_create_file(&bmc->dev->dev,
 			   &bmc->manufacturer_id_attr);
-	if (err) goto out_add_dev;
+	if (err)
+		goto out_add_dev;
 	err = device_create_file(&bmc->dev->dev,
 			   &bmc->product_id_attr);
-	if (err) goto out_manu;
+	if (err)
+		goto out_manu;
 	if (bmc->id.aux_firmware_revision_set) {
 		err = device_create_file(&bmc->dev->dev,
 				   &bmc->aux_firmware_rev_attr);
-		if (err) goto out_prod_id;
+		if (err)
+			goto out_prod_id;
 	}
 	if (bmc->guid_set) {
 		err = device_create_file(&bmc->dev->dev,
 				   &bmc->guid_attr);
-		if (err) goto out_aux_firm;
+		if (err)
+			goto out_aux_firm;
 	}
 
 	return 0;
@@ -2372,8 +2460,10 @@ static int ipmi_bmc_register(ipmi_smi_t 
 			       "ipmi_msghandler:"
 			       " Unable to register bmc device: %d\n",
 			       rv);
-			/* Don't go to out_err, you can only do that if
-			   the device is registered already. */
+			/*
+			 * Don't go to out_err, you can only do that if
+			 * the device is registered already.
+			 */
 			return rv;
 		}
 
@@ -2564,17 +2654,18 @@ channel_handler(ipmi_smi_t intf, struct 
 
 	if ((msg->addr.addr_type == IPMI_SYSTEM_INTERFACE_ADDR_TYPE)
 	    && (msg->msg.netfn == IPMI_NETFN_APP_RESPONSE)
-	    && (msg->msg.cmd == IPMI_GET_CHANNEL_INFO_CMD))
-	{
+	    && (msg->msg.cmd == IPMI_GET_CHANNEL_INFO_CMD)) {
 		/* It's the one we want */
 		if (msg->msg.data[0] != 0) {
 			/* Got an error from the channel, just go on. */
 
 			if (msg->msg.data[0] == IPMI_INVALID_COMMAND_ERR) {
-				/* If the MC does not support this
-				   command, that is legal.  We just
-				   assume it has one IPMB at channel
-				   zero. */
+				/*
+				 * If the MC does not support this
+				 * command, that is legal.  We just
+				 * assume it has one IPMB at channel
+				 * zero.
+				 */
 				intf->channels[0].medium
 					= IPMI_CHANNEL_MEDIUM_IPMB;
 				intf->channels[0].protocol
@@ -2595,7 +2686,7 @@ channel_handler(ipmi_smi_t intf, struct 
 		intf->channels[chan].medium = msg->msg.data[2] & 0x7f;
 		intf->channels[chan].protocol = msg->msg.data[3] & 0x1f;
 
-	next_channel:
+ next_channel:
 		intf->curr_channel++;
 		if (intf->curr_channel >= IPMI_MAX_CHANNELS)
 			wake_up(&intf->waitq);
@@ -2623,6 +2714,7 @@ void ipmi_poll_interface(ipmi_user_t use
 	if (intf->handlers->poll)
 		intf->handlers->poll(intf->send_info);
 }
+EXPORT_SYMBOL(ipmi_poll_interface);
 
 int ipmi_register_smi(struct ipmi_smi_handlers *handlers,
 		      void		       *send_info,
@@ -2637,14 +2729,18 @@ int ipmi_register_smi(struct ipmi_smi_ha
 	ipmi_smi_t       tintf;
 	struct list_head *link;
 
-	/* Make sure the driver is actually initialized, this handles
-	   problems with initialization order. */
+	/*
+	 * Make sure the driver is actually initialized, this handles
+	 * problems with initialization order.
+	 */
 	if (!initialized) {
 		rv = ipmi_init_msghandler();
 		if (rv)
 			return rv;
-		/* The init code doesn't return an error if it was turned
-		   off, but it won't initialize.  Check that. */
+		/*
+		 * The init code doesn't return an error if it was turned
+		 * off, but it won't initialize.  Check that.
+		 */
 		if (!initialized)
 			return -ENODEV;
 	}
@@ -2722,11 +2818,12 @@ int ipmi_register_smi(struct ipmi_smi_ha
 	get_guid(intf);
 
 	if ((intf->ipmi_version_major > 1)
-	    || ((intf->ipmi_version_major == 1)
-		&& (intf->ipmi_version_minor >= 5)))
-	{
-		/* Start scanning the channels to see what is
-		   available. */
+			|| ((intf->ipmi_version_major == 1)
+			    && (intf->ipmi_version_minor >= 5))) {
+		/*
+		 * Start scanning the channels to see what is
+		 * available.
+		 */
 		intf->null_user_handler = channel_handler;
 		intf->curr_channel = 0;
 		rv = send_channel_info_cmd(intf, 0);
@@ -2774,6 +2871,7 @@ int ipmi_register_smi(struct ipmi_smi_ha
 
 	return rv;
 }
+EXPORT_SYMBOL(ipmi_register_smi);
 
 static void cleanup_smi_msgs(ipmi_smi_t intf)
 {
@@ -2808,8 +2906,10 @@ int ipmi_unregister_smi(ipmi_smi_t intf)
 
 	remove_proc_entries(intf);
 
-	/* Call all the watcher interfaces to tell them that
-	   an interface is gone. */
+	/*
+	 * Call all the watcher interfaces to tell them that
+	 * an interface is gone.
+	 */
 	list_for_each_entry(w, &smi_watchers, link)
 		w->smi_gone(intf_num);
 	mutex_unlock(&smi_watchers_mutex);
@@ -2817,6 +2917,7 @@ int ipmi_unregister_smi(ipmi_smi_t intf)
 	kref_put(&intf->refcount, intf_free);
 	return 0;
 }
+EXPORT_SYMBOL(ipmi_unregister_smi);
 
 static int handle_ipmb_get_msg_rsp(ipmi_smi_t          intf,
 				   struct ipmi_smi_msg *msg)
@@ -2824,9 +2925,10 @@ static int handle_ipmb_get_msg_rsp(ipmi_
 	struct ipmi_ipmb_addr ipmb_addr;
 	struct ipmi_recv_msg  *recv_msg;
 
-	
-	/* This is 11, not 10, because the response must contain a
-	 * completion code. */
+	/*
+	 * This is 11, not 10, because the response must contain a
+	 * completion code.
+	 */
 	if (msg->rsp_size < 11) {
 		/* Message not big enough, just ignore it. */
 		ipmi_inc_stat(intf, invalid_ipmb_responses);
@@ -2843,18 +2945,21 @@ static int handle_ipmb_get_msg_rsp(ipmi_
 	ipmb_addr.channel = msg->rsp[3] & 0x0f;
 	ipmb_addr.lun = msg->rsp[7] & 3;
 
-	/* It's a response from a remote entity.  Look up the sequence
-	   number and handle the response. */
+	/*
+	 * It's a response from a remote entity.  Look up the sequence
+	 * number and handle the response.
+	 */
 	if (intf_find_seq(intf,
 			  msg->rsp[7] >> 2,
 			  msg->rsp[3] & 0x0f,
 			  msg->rsp[8],
 			  (msg->rsp[4] >> 2) & (~1),
 			  (struct ipmi_addr *) &(ipmb_addr),
-			  &recv_msg))
-	{
-		/* We were unable to find the sequence number,
-		   so just nuke the message. */
+			  &recv_msg)) {
+		/*
+		 * We were unable to find the sequence number,
+		 * so just nuke the message.
+		 */
 		ipmi_inc_stat(intf, unhandled_ipmb_responses);
 		return 0;
 	}
@@ -2862,9 +2967,11 @@ static int handle_ipmb_get_msg_rsp(ipmi_
 	memcpy(recv_msg->msg_data,
 	       &(msg->rsp[9]),
 	       msg->rsp_size - 9);
-	/* THe other fields matched, so no need to set them, except
-           for netfn, which needs to be the response that was
-           returned, not the request value. */
+	/*
+	 * The other fields matched, so no need to set them, except
+	 * for netfn, which needs to be the response that was
+	 * returned, not the request value.
+	 */
 	recv_msg->msg.netfn = msg->rsp[4] >> 2;
 	recv_msg->msg.data = recv_msg->msg_data;
 	recv_msg->msg.data_len = msg->rsp_size - 10;
@@ -2920,11 +3027,11 @@ static int handle_ipmb_get_msg_cmd(ipmi_
 		msg->data[1] = IPMI_SEND_MSG_CMD;
 		msg->data[2] = msg->rsp[3];
 		msg->data[3] = msg->rsp[6];
-                msg->data[4] = ((netfn + 1) << 2) | (msg->rsp[7] & 0x3);
+		msg->data[4] = ((netfn + 1) << 2) | (msg->rsp[7] & 0x3);
 		msg->data[5] = ipmb_checksum(&(msg->data[3]), 2);
 		msg->data[6] = intf->channels[msg->rsp[3] & 0xf].address;
-                /* rqseq/lun */
-                msg->data[7] = (msg->rsp[7] & 0xfc) | (msg->rsp[4] & 0x3);
+		/* rqseq/lun */
+		msg->data[7] = (msg->rsp[7] & 0xfc) | (msg->rsp[4] & 0x3);
 		msg->data[8] = msg->rsp[8]; /* cmd */
 		msg->data[9] = IPMI_INVALID_CMD_COMPLETION_CODE;
 		msg->data[10] = ipmb_checksum(&(msg->data[6]), 4);
@@ -2943,9 +3050,11 @@ static int handle_ipmb_get_msg_cmd(ipmi_
 		handlers = intf->handlers;
 		if (handlers) {
 			handlers->sender(intf->send_info, msg, 0);
-			/* We used the message, so return the value
-			   that causes it to not be freed or
-			   queued. */
+			/*
+			 * We used the message, so return the value
+			 * that causes it to not be freed or
+			 * queued.
+			 */
 			rv = -1;
 		}
 		rcu_read_unlock();
@@ -2955,9 +3064,11 @@ static int handle_ipmb_get_msg_cmd(ipmi_
 
 		recv_msg = ipmi_alloc_recv_msg();
 		if (!recv_msg) {
-			/* We couldn't allocate memory for the
-                           message, so requeue it for handling
-                           later. */
+			/*
+			 * We couldn't allocate memory for the
+			 * message, so requeue it for handling
+			 * later.
+			 */
 			rv = 1;
 			kref_put(&user->refcount, free_user);
 		} else {
@@ -2968,8 +3079,10 @@ static int handle_ipmb_get_msg_cmd(ipmi_
 			ipmb_addr->lun = msg->rsp[7] & 3;
 			ipmb_addr->channel = msg->rsp[3] & 0xf;
 
-			/* Extract the rest of the message information
-			   from the IPMB header.*/
+			/*
+			 * Extract the rest of the message information
+			 * from the IPMB header.
+			 */
 			recv_msg->user = user;
 			recv_msg->recv_type = IPMI_CMD_RECV_TYPE;
 			recv_msg->msgid = msg->rsp[7] >> 2;
@@ -2977,8 +3090,10 @@ static int handle_ipmb_get_msg_cmd(ipmi_
 			recv_msg->msg.cmd = msg->rsp[8];
 			recv_msg->msg.data = recv_msg->msg_data;
 
-			/* We chop off 10, not 9 bytes because the checksum
-			   at the end also needs to be removed. */
+			/*
+			 * We chop off 10, not 9 bytes because the checksum
+			 * at the end also needs to be removed.
+			 */
 			recv_msg->msg.data_len = msg->rsp_size - 10;
 			memcpy(recv_msg->msg_data,
 			       &(msg->rsp[9]),
@@ -2997,8 +3112,10 @@ static int handle_lan_get_msg_rsp(ipmi_s
 	struct ipmi_recv_msg  *recv_msg;
 
 
-	/* This is 13, not 12, because the response must contain a
-	 * completion code. */
+	/*
+	 * This is 13, not 12, because the response must contain a
+	 * completion code.
+	 */
 	if (msg->rsp_size < 13) {
 		/* Message not big enough, just ignore it. */
 		ipmi_inc_stat(intf, invalid_lan_responses);
@@ -3018,18 +3135,21 @@ static int handle_lan_get_msg_rsp(ipmi_s
 	lan_addr.privilege = msg->rsp[3] >> 4;
 	lan_addr.lun = msg->rsp[9] & 3;
 
-	/* It's a response from a remote entity.  Look up the sequence
-	   number and handle the response. */
+	/*
+	 * It's a response from a remote entity.  Look up the sequence
+	 * number and handle the response.
+	 */
 	if (intf_find_seq(intf,
 			  msg->rsp[9] >> 2,
 			  msg->rsp[3] & 0x0f,
 			  msg->rsp[10],
 			  (msg->rsp[6] >> 2) & (~1),
 			  (struct ipmi_addr *) &(lan_addr),
-			  &recv_msg))
-	{
-		/* We were unable to find the sequence number,
-		   so just nuke the message. */
+			  &recv_msg)) {
+		/*
+		 * We were unable to find the sequence number,
+		 * so just nuke the message.
+		 */
 		ipmi_inc_stat(intf, unhandled_lan_responses);
 		return 0;
 	}
@@ -3037,9 +3157,11 @@ static int handle_lan_get_msg_rsp(ipmi_s
 	memcpy(recv_msg->msg_data,
 	       &(msg->rsp[11]),
 	       msg->rsp_size - 11);
-	/* The other fields matched, so no need to set them, except
-           for netfn, which needs to be the response that was
-           returned, not the request value. */
+	/*
+	 * The other fields matched, so no need to set them, except
+	 * for netfn, which needs to be the response that was
+	 * returned, not the request value.
+	 */
 	recv_msg->msg.netfn = msg->rsp[6] >> 2;
 	recv_msg->msg.data = recv_msg->msg_data;
 	recv_msg->msg.data_len = msg->rsp_size - 12;
@@ -3090,17 +3212,21 @@ static int handle_lan_get_msg_cmd(ipmi_s
 		/* We didn't find a user, just give up. */
 		ipmi_inc_stat(intf, unhandled_commands);
 
-		rv = 0; /* Don't do anything with these messages, just
-			   allow them to be freed. */
+		/*
+		 * Don't do anything with these messages, just allow
+		 * them to be freed.
+		 */
+		rv = 0;
 	} else {
 		/* Deliver the message to the user. */
 		ipmi_inc_stat(intf, handled_commands);
 
 		recv_msg = ipmi_alloc_recv_msg();
 		if (!recv_msg) {
-			/* We couldn't allocate memory for the
-                           message, so requeue it for handling
-                           later. */
+			/*
+			 * We couldn't allocate memory for the
+			 * message, so requeue it for handling later.
+			 */
 			rv = 1;
 			kref_put(&user->refcount, free_user);
 		} else {
@@ -3114,8 +3240,10 @@ static int handle_lan_get_msg_cmd(ipmi_s
 			lan_addr->channel = msg->rsp[3] & 0xf;
 			lan_addr->privilege = msg->rsp[3] >> 4;
 
-			/* Extract the rest of the message information
-			   from the IPMB header.*/
+			/*
+			 * Extract the rest of the message information
+			 * from the IPMB header.
+			 */
 			recv_msg->user = user;
 			recv_msg->recv_type = IPMI_CMD_RECV_TYPE;
 			recv_msg->msgid = msg->rsp[9] >> 2;
@@ -3123,8 +3251,10 @@ static int handle_lan_get_msg_cmd(ipmi_s
 			recv_msg->msg.cmd = msg->rsp[10];
 			recv_msg->msg.data = recv_msg->msg_data;
 
-			/* We chop off 12, not 11 bytes because the checksum
-			   at the end also needs to be removed. */
+			/*
+			 * We chop off 12, not 11 bytes because the checksum
+			 * at the end also needs to be removed.
+			 */
 			recv_msg->msg.data_len = msg->rsp_size - 12;
 			memcpy(recv_msg->msg_data,
 			       &(msg->rsp[11]),
@@ -3140,7 +3270,7 @@ static void copy_event_into_recv_msg(str
 				     struct ipmi_smi_msg  *msg)
 {
 	struct ipmi_system_interface_addr *smi_addr;
-	
+
 	recv_msg->msgid = 0;
 	smi_addr = (struct ipmi_system_interface_addr *) &(recv_msg->addr);
 	smi_addr->addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
@@ -3181,8 +3311,10 @@ static int handle_read_event_rsp(ipmi_sm
 
 	ipmi_inc_stat(intf, events);
 
-	/* Allocate and fill in one message for every user that is getting
-	   events. */
+	/*
+	 * Allocate and fill in one message for every user that is
+	 * getting events.
+	 */
 	rcu_read_lock();
 	list_for_each_entry_rcu(user, &intf->users, link) {
 		if (!user->gets_events)
@@ -3196,9 +3328,11 @@ static int handle_read_event_rsp(ipmi_sm
 				list_del(&recv_msg->link);
 				ipmi_free_recv_msg(recv_msg);
 			}
-			/* We couldn't allocate memory for the
-                           message, so requeue it for handling
-                           later. */
+			/*
+			 * We couldn't allocate memory for the
+			 * message, so requeue it for handling
+			 * later.
+			 */
 			rv = 1;
 			goto out;
 		}
@@ -3219,13 +3353,17 @@ static int handle_read_event_rsp(ipmi_sm
 			deliver_response(recv_msg);
 		}
 	} else if (intf->waiting_events_count < MAX_EVENTS_IN_QUEUE) {
-		/* No one to receive the message, put it in queue if there's
-		   not already too many things in the queue. */
+		/*
+		 * No one to receive the message, put it in queue if there's
+		 * not already too many things in the queue.
+		 */
 		recv_msg = ipmi_alloc_recv_msg();
 		if (!recv_msg) {
-			/* We couldn't allocate memory for the
-                           message, so requeue it for handling
-                           later. */
+			/*
+			 * We couldn't allocate memory for the
+			 * message, so requeue it for handling
+			 * later.
+			 */
 			rv = 1;
 			goto out;
 		}
@@ -3234,8 +3372,10 @@ static int handle_read_event_rsp(ipmi_sm
 		list_add_tail(&(recv_msg->link), &(intf->waiting_events));
 		intf->waiting_events_count++;
 	} else if (!intf->event_msg_printed) {
-		/* There's too many things in the queue, discard this
-		   message. */
+		/*
+		 * There's too many things in the queue, discard this
+		 * message.
+		 */
 		printk(KERN_WARNING PFX "Event queue full, discarding"
 		       " incoming events\n");
 		intf->event_msg_printed = 1;
@@ -3254,12 +3394,12 @@ static int handle_bmc_rsp(ipmi_smi_t    
 	struct ipmi_user     *user;
 
 	recv_msg = (struct ipmi_recv_msg *) msg->user_data;
-	if (recv_msg == NULL)
-	{
-		printk(KERN_WARNING"IPMI message received with no owner. This\n"
-			"could be because of a malformed message, or\n"
-			"because of a hardware error.  Contact your\n"
-			"hardware vender for assistance\n");
+	if (recv_msg == NULL) {
+		printk(KERN_WARNING
+		       "IPMI message received with no owner. This\n"
+		       "could be because of a malformed message, or\n"
+		       "because of a hardware error.  Contact your\n"
+		       "hardware vender for assistance\n");
 		return 0;
 	}
 
@@ -3293,9 +3433,11 @@ static int handle_bmc_rsp(ipmi_smi_t    
 	return 0;
 }
 
-/* Handle a new message.  Return 1 if the message should be requeued,
-   0 if the message should be freed, or -1 if the message should not
-   be freed or requeued. */
+/*
+ * Handle a new message.  Return 1 if the message should be requeued,
+ * 0 if the message should be freed, or -1 if the message should not
+ * be freed or requeued.
+ */
 static int handle_new_recv_msg(ipmi_smi_t          intf,
 			       struct ipmi_smi_msg *msg)
 {
@@ -3320,10 +3462,12 @@ static int handle_new_recv_msg(ipmi_smi_
 		msg->rsp[1] = msg->data[1];
 		msg->rsp[2] = IPMI_ERR_UNSPECIFIED;
 		msg->rsp_size = 3;
-	} else if (((msg->rsp[0] >> 2) != ((msg->data[0] >> 2) | 1))/* Netfn */
-		   || (msg->rsp[1] != msg->data[1]))		  /* Command */
-	{
-		/* The response is not even marginally correct. */
+	} else if (((msg->rsp[0] >> 2) != ((msg->data[0] >> 2) | 1))
+		   || (msg->rsp[1] != msg->data[1])) {
+		/*
+		 * The NetFN and Command in the response is not even
+		 * marginally correct.
+		 */
 		printk(KERN_WARNING PFX "BMC returned incorrect response,"
 		       " expected netfn %x cmd %x, got netfn %x cmd %x\n",
 		       (msg->data[0] >> 2) | 1, msg->data[1],
@@ -3338,10 +3482,11 @@ static int handle_new_recv_msg(ipmi_smi_
 
 	if ((msg->rsp[0] == ((IPMI_NETFN_APP_REQUEST|1) << 2))
 	    && (msg->rsp[1] == IPMI_SEND_MSG_CMD)
-	    && (msg->user_data != NULL))
-	{
-		/* It's a response to a response we sent.  For this we
-		   deliver a send message response to the user. */
+	    && (msg->user_data != NULL)) {
+		/*
+		 * It's a response to a response we sent.  For this we
+		 * deliver a send message response to the user.
+		 */
 		struct ipmi_recv_msg     *recv_msg = msg->user_data;
 
 		requeue = 0;
@@ -3367,8 +3512,7 @@ static int handle_new_recv_msg(ipmi_smi_
 		recv_msg->msg_data[0] = msg->rsp[2];
 		deliver_response(recv_msg);
 	} else if ((msg->rsp[0] == ((IPMI_NETFN_APP_REQUEST|1) << 2))
-		   && (msg->rsp[1] == IPMI_GET_MSG_CMD))
-	{
+		   && (msg->rsp[1] == IPMI_GET_MSG_CMD)) {
 		/* It's from the receive queue. */
 		chan = msg->rsp[3] & 0xf;
 		if (chan >= IPMI_MAX_CHANNELS) {
@@ -3380,12 +3524,16 @@ static int handle_new_recv_msg(ipmi_smi_
 		switch (intf->channels[chan].medium) {
 		case IPMI_CHANNEL_MEDIUM_IPMB:
 			if (msg->rsp[4] & 0x04) {
-				/* It's a response, so find the
-				   requesting message and send it up. */
+				/*
+				 * It's a response, so find the
+				 * requesting message and send it up.
+				 */
 				requeue = handle_ipmb_get_msg_rsp(intf, msg);
 			} else {
-				/* It's a command to the SMS from some other
-				   entity.  Handle that. */
+				/*
+				 * It's a command to the SMS from some other
+				 * entity.  Handle that.
+				 */
 				requeue = handle_ipmb_get_msg_cmd(intf, msg);
 			}
 			break;
@@ -3393,25 +3541,30 @@ static int handle_new_recv_msg(ipmi_smi_
 		case IPMI_CHANNEL_MEDIUM_8023LAN:
 		case IPMI_CHANNEL_MEDIUM_ASYNC:
 			if (msg->rsp[6] & 0x04) {
-				/* It's a response, so find the
-				   requesting message and send it up. */
+				/*
+				 * It's a response, so find the
+				 * requesting message and send it up.
+				 */
 				requeue = handle_lan_get_msg_rsp(intf, msg);
 			} else {
-				/* It's a command to the SMS from some other
-				   entity.  Handle that. */
+				/*
+				 * It's a command to the SMS from some other
+				 * entity.  Handle that.
+				 */
 				requeue = handle_lan_get_msg_cmd(intf, msg);
 			}
 			break;
 
 		default:
-			/* We don't handle the channel type, so just
-			 * free the message. */
+			/*
+			 * We don't handle the channel type, so just
+			 * free the message.
+			 */
 			requeue = 0;
 		}
 
 	} else if ((msg->rsp[0] == ((IPMI_NETFN_APP_REQUEST|1) << 2))
-		   && (msg->rsp[1] == IPMI_READ_EVENT_MSG_BUFFER_CMD))
-	{
+		   && (msg->rsp[1] == IPMI_READ_EVENT_MSG_BUFFER_CMD)) {
 		/* It's an asyncronous event. */
 		requeue = handle_read_event_rsp(intf, msg);
 	} else {
@@ -3435,23 +3588,25 @@ void ipmi_smi_msg_received(ipmi_smi_t   
 	if ((msg->data_size >= 2)
 	    && (msg->data[0] == (IPMI_NETFN_APP_REQUEST << 2))
 	    && (msg->data[1] == IPMI_SEND_MSG_CMD)
-	    && (msg->user_data == NULL))
-	{
-		/* This is the local response to a command send, start
-                   the timer for these.  The user_data will not be
-                   NULL if this is a response send, and we will let
-                   response sends just go through. */
-
-		/* Check for errors, if we get certain errors (ones
-                   that mean basically we can try again later), we
-                   ignore them and start the timer.  Otherwise we
-                   report the error immediately. */
+	    && (msg->user_data == NULL)) {
+		/*
+		 * This is the local response to a command send, start
+		 * the timer for these.  The user_data will not be
+		 * NULL if this is a response send, and we will let
+		 * response sends just go through.
+		 */
+
+		/*
+		 * Check for errors, if we get certain errors (ones
+		 * that mean basically we can try again later), we
+		 * ignore them and start the timer.  Otherwise we
+		 * report the error immediately.
+		 */
 		if ((msg->rsp_size >= 3) && (msg->rsp[2] != 0)
 		    && (msg->rsp[2] != IPMI_NODE_BUSY_ERR)
 		    && (msg->rsp[2] != IPMI_LOST_ARBITRATION_ERR)
 		    && (msg->rsp[2] != IPMI_BUS_ERR)
-		    && (msg->rsp[2] != IPMI_NAK_ON_WRITE_ERR))
-		{
+		    && (msg->rsp[2] != IPMI_NAK_ON_WRITE_ERR)) {
 			int chan = msg->rsp[3] & 0xf;
 
 			/* Got an error sending the message, handle it. */
@@ -3465,17 +3620,18 @@ void ipmi_smi_msg_received(ipmi_smi_t   
 			else
 				ipmi_inc_stat(intf, sent_ipmb_command_errs);
 			intf_err_seq(intf, msg->msgid, msg->rsp[2]);
-		} else {
+		} else
 			/* The message was sent, start the timer. */
 			intf_start_seq_timer(intf, msg->msgid);
-		}
 
 		ipmi_free_smi_msg(msg);
 		goto out;
 	}
 
-	/* To preserve message order, if the list is not empty, we
-           tack this message onto the end of the list. */
+	/*
+	 * To preserve message order, if the list is not empty, we
+	 * tack this message onto the end of the list.
+	 */
 	run_to_completion = intf->run_to_completion;
 	if (!run_to_completion)
 		spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
@@ -3487,11 +3643,13 @@ void ipmi_smi_msg_received(ipmi_smi_t   
 	}
 	if (!run_to_completion)
 		spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
-		
+
 	rv = handle_new_recv_msg(intf, msg);
 	if (rv > 0) {
-		/* Could not handle the message now, just add it to a
-                   list to handle later. */
+		/*
+		 * Could not handle the message now, just add it to a
+		 * list to handle later.
+		 */
 		run_to_completion = intf->run_to_completion;
 		if (!run_to_completion)
 			spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
@@ -3505,6 +3663,7 @@ void ipmi_smi_msg_received(ipmi_smi_t   
  out:
 	return;
 }
+EXPORT_SYMBOL(ipmi_smi_msg_received);
 
 void ipmi_smi_watchdog_pretimeout(ipmi_smi_t intf)
 {
@@ -3519,7 +3678,7 @@ void ipmi_smi_watchdog_pretimeout(ipmi_s
 	}
 	rcu_read_unlock();
 }
-
+EXPORT_SYMBOL(ipmi_smi_watchdog_pretimeout);
 
 static struct ipmi_smi_msg *
 smi_from_recv_msg(ipmi_smi_t intf, struct ipmi_recv_msg *recv_msg,
@@ -3527,14 +3686,16 @@ smi_from_recv_msg(ipmi_smi_t intf, struc
 {
 	struct ipmi_smi_msg *smi_msg = ipmi_alloc_smi_msg();
 	if (!smi_msg)
-		/* If we can't allocate the message, then just return, we
-		   get 4 retries, so this should be ok. */
+		/*
+		 * If we can't allocate the message, then just return, we
+		 * get 4 retries, so this should be ok.
+		 */
 		return NULL;
 
 	memcpy(smi_msg->data, recv_msg->msg.data, recv_msg->msg.data_len);
 	smi_msg->data_size = recv_msg->msg.data_len;
 	smi_msg->msgid = STORE_SEQ_IN_MSGID(seq, seqid);
-		
+
 #ifdef DEBUG_MSGING
 	{
 		int m;
@@ -3579,8 +3740,10 @@ static void check_msg_timeout(ipmi_smi_t
 		struct ipmi_smi_msg *smi_msg;
 		/* More retries, send again. */
 
-		/* Start with the max timer, set to normal
-		   timer after the message is sent. */
+		/*
+		 * Start with the max timer, set to normal timer after
+		 * the message is sent.
+		 */
 		ent->timeout = MAX_MSG_TIMEOUT;
 		ent->retries_left--;
 		if (ent->recv_msg->addr.addr_type == IPMI_LAN_ADDR_TYPE)
@@ -3595,11 +3758,13 @@ static void check_msg_timeout(ipmi_smi_t
 
 		spin_unlock_irqrestore(&intf->seq_lock, *flags);
 
-		/* Send the new message.  We send with a zero
-		 * priority.  It timed out, I doubt time is
-		 * that critical now, and high priority
-		 * messages are really only for messages to the
-		 * local MC, which don't get resent. */
+		/*
+		 * Send the new message.  We send with a zero
+		 * priority.  It timed out, I doubt time is that
+		 * critical now, and high priority messages are really
+		 * only for messages to the local MC, which don't get
+		 * resent.
+		 */
 		handlers = intf->handlers;
 		if (handlers)
 			intf->handlers->sender(intf->send_info,
@@ -3630,16 +3795,20 @@ static void ipmi_timeout_handler(long ti
 				list_del(&smi_msg->link);
 				ipmi_free_smi_msg(smi_msg);
 			} else {
-				/* To preserve message order, quit if we
-				   can't handle a message. */
+				/*
+				 * To preserve message order, quit if we
+				 * can't handle a message.
+				 */
 				break;
 			}
 		}
 		spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);
 
-		/* Go through the seq table and find any messages that
-		   have timed out, putting them in the timeouts
-		   list. */
+		/*
+		 * Go through the seq table and find any messages that
+		 * have timed out, putting them in the timeouts
+		 * list.
+		 */
 		INIT_LIST_HEAD(&timeouts);
 		spin_lock_irqsave(&intf->seq_lock, flags);
 		for (i = 0; i < IPMI_IPMB_NUM_SEQ; i++)
@@ -3665,8 +3834,7 @@ static void ipmi_timeout_handler(long ti
 				intf->auto_maintenance_timeout
 					-= timeout_period;
 				if (!intf->maintenance_mode
-				    && (intf->auto_maintenance_timeout <= 0))
-				{
+				    && (intf->auto_maintenance_timeout <= 0)) {
 					intf->maintenance_mode_enable = 0;
 					maintenance_mode_update(intf);
 				}
@@ -3684,8 +3852,10 @@ static void ipmi_request_event(void)
 	struct ipmi_smi_handlers *handlers;
 
 	rcu_read_lock();
-	/* Called from the timer, no need to check if handlers is
-	 * valid. */
+	/*
+	 * Called from the timer, no need to check if handlers is
+	 * valid.
+	 */
 	list_for_each_entry_rcu(intf, &ipmi_interfaces, link) {
 		/* No event requests when in maintenance mode. */
 		if (intf->maintenance_mode_enable)
@@ -3706,10 +3876,12 @@ static struct timer_list ipmi_timer;
 /* How many jiffies does it take to get to the timeout time. */
 #define IPMI_TIMEOUT_JIFFIES	((IPMI_TIMEOUT_TIME * HZ) / 1000)
 
-/* Request events from the queue every second (this is the number of
-   IPMI_TIMEOUT_TIMES between event requests).  Hopefully, in the
-   future, IPMI will add a way to know immediately if an event is in
-   the queue and this silliness can go away. */
+/*
+ * Request events from the queue every second (this is the number of
+ * IPMI_TIMEOUT_TIMES between event requests).  Hopefully, in the
+ * future, IPMI will add a way to know immediately if an event is in
+ * the queue and this silliness can go away.
+ */
 #define IPMI_REQUEST_EV_TIME	(1000 / (IPMI_TIMEOUT_TIME))
 
 static atomic_t stop_operation;
@@ -3753,6 +3925,7 @@ struct ipmi_smi_msg *ipmi_alloc_smi_msg(
 	}
 	return rv;
 }
+EXPORT_SYMBOL(ipmi_alloc_smi_msg);
 
 static void free_recv_msg(struct ipmi_recv_msg *msg)
 {
@@ -3779,6 +3952,7 @@ void ipmi_free_recv_msg(struct ipmi_recv
 		kref_put(&msg->user->refcount, free_user);
 	msg->done(msg);
 }
+EXPORT_SYMBOL(ipmi_free_recv_msg);
 
 #ifdef CONFIG_IPMI_PANIC_EVENT
 
@@ -3796,8 +3970,7 @@ static void event_receiver_fetcher(ipmi_
 	if ((msg->addr.addr_type == IPMI_SYSTEM_INTERFACE_ADDR_TYPE)
 	    && (msg->msg.netfn == IPMI_NETFN_SENSOR_EVENT_RESPONSE)
 	    && (msg->msg.cmd == IPMI_GET_EVENT_RECEIVER_CMD)
-	    && (msg->msg.data[0] == IPMI_CC_NO_ERROR))
-	{
+	    && (msg->msg.data[0] == IPMI_CC_NO_ERROR)) {
 		/* A get event receiver command, save it. */
 		intf->event_receiver = msg->msg.data[1];
 		intf->event_receiver_lun = msg->msg.data[2] & 0x3;
@@ -3809,10 +3982,11 @@ static void device_id_fetcher(ipmi_smi_t
 	if ((msg->addr.addr_type == IPMI_SYSTEM_INTERFACE_ADDR_TYPE)
 	    && (msg->msg.netfn == IPMI_NETFN_APP_RESPONSE)
 	    && (msg->msg.cmd == IPMI_GET_DEVICE_ID_CMD)
-	    && (msg->msg.data[0] == IPMI_CC_NO_ERROR))
-	{
-		/* A get device id command, save if we are an event
-		   receiver or generator. */
+	    && (msg->msg.data[0] == IPMI_CC_NO_ERROR)) {
+		/*
+		 * A get device id command, save if we are an event
+		 * receiver or generator.
+		 */
 		intf->local_sel_device = (msg->msg.data[6] >> 2) & 1;
 		intf->local_event_generator = (msg->msg.data[6] >> 5) & 1;
 	}
@@ -3845,8 +4019,10 @@ static void send_panic_events(char *str)
 	data[4] = 0x6f; /* Sensor specific, IPMI table 36-1 */
 	data[5] = 0xa1; /* Runtime stop OEM bytes 2 & 3. */
 
-	/* Put a few breadcrumbs in.  Hopefully later we can add more things
-	   to make the panic events more useful. */
+	/*
+	 * Put a few breadcrumbs in.  Hopefully later we can add more things
+	 * to make the panic events more useful.
+	 */
 	if (str) {
 		data[3] = str[0];
 		data[6] = str[1];
@@ -3880,9 +4056,11 @@ static void send_panic_events(char *str)
 	}
 
 #ifdef CONFIG_IPMI_PANIC_STRING
-	/* On every interface, dump a bunch of OEM event holding the
-	   string. */
-	if (!str) 
+	/*
+	 * On every interface, dump a bunch of OEM event holding the
+	 * string.
+	 */
+	if (!str)
 		return;
 
 	/* For every registered interface, send the event. */
@@ -3903,11 +4081,13 @@ static void send_panic_events(char *str)
 		 */
 		smp_rmb();
 
-		/* First job here is to figure out where to send the
-		   OEM events.  There's no way in IPMI to send OEM
-		   events using an event send command, so we have to
-		   find the SEL to put them in and stick them in
-		   there. */
+		/*
+		 * First job here is to figure out where to send the
+		 * OEM events.  There's no way in IPMI to send OEM
+		 * events using an event send command, so we have to
+		 * find the SEL to put them in and stick them in
+		 * there.
+		 */
 
 		/* Get capabilities from the get device id. */
 		intf->local_sel_device = 0;
@@ -3955,24 +4135,29 @@ static void send_panic_events(char *str)
 		}
 		intf->null_user_handler = NULL;
 
-		/* Validate the event receiver.  The low bit must not
-		   be 1 (it must be a valid IPMB address), it cannot
-		   be zero, and it must not be my address. */
-                if (((intf->event_receiver & 1) == 0)
+		/*
+		 * Validate the event receiver.  The low bit must not
+		 * be 1 (it must be a valid IPMB address), it cannot
+		 * be zero, and it must not be my address.
+		 */
+		if (((intf->event_receiver & 1) == 0)
 		    && (intf->event_receiver != 0)
-		    && (intf->event_receiver != intf->channels[0].address))
-		{
-			/* The event receiver is valid, send an IPMB
-			   message. */
+		    && (intf->event_receiver != intf->channels[0].address)) {
+			/*
+			 * The event receiver is valid, send an IPMB
+			 * message.
+			 */
 			ipmb = (struct ipmi_ipmb_addr *) &addr;
 			ipmb->addr_type = IPMI_IPMB_ADDR_TYPE;
 			ipmb->channel = 0; /* FIXME - is this right? */
 			ipmb->lun = intf->event_receiver_lun;
 			ipmb->slave_addr = intf->event_receiver;
 		} else if (intf->local_sel_device) {
-			/* The event receiver was not valid (or was
-			   me), but I am an SEL device, just dump it
-			   in my SEL. */
+			/*
+			 * The event receiver was not valid (or was
+			 * me), but I am an SEL device, just dump it
+			 * in my SEL.
+			 */
 			si = (struct ipmi_system_interface_addr *) &addr;
 			si->addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
 			si->channel = IPMI_BMC_CHANNEL;
@@ -3980,7 +4165,6 @@ static void send_panic_events(char *str)
 		} else
 			continue; /* No where to send the event. */
 
-		
 		msg.netfn = IPMI_NETFN_STORAGE_REQUEST; /* Storage. */
 		msg.cmd = IPMI_ADD_SEL_ENTRY_CMD;
 		msg.data = data;
@@ -3997,8 +4181,10 @@ static void send_panic_events(char *str)
 			data[2] = 0xf0; /* OEM event without timestamp. */
 			data[3] = intf->channels[0].address;
 			data[4] = j++; /* sequence # */
-			/* Always give 11 bytes, so strncpy will fill
-			   it with zeroes for me. */
+			/*
+			 * Always give 11 bytes, so strncpy will fill
+			 * it with zeroes for me.
+			 */
 			strncpy(data+5, p, 11);
 			p += size;
 
@@ -4015,7 +4201,7 @@ static void send_panic_events(char *str)
 				       intf->channels[0].lun,
 				       0, 1); /* no retry, and no wait. */
 		}
-	}	
+	}
 #endif /* CONFIG_IPMI_PANIC_STRING */
 }
 #endif /* CONFIG_IPMI_PANIC_EVENT */
@@ -4024,7 +4210,7 @@ static int has_panicked;
 
 static int panic_event(struct notifier_block *this,
 		       unsigned long         event,
-                       void                  *ptr)
+		       void                  *ptr)
 {
 	ipmi_smi_t intf;
 
@@ -4106,11 +4292,16 @@ static __exit void cleanup_ipmi(void)
 
 	atomic_notifier_chain_unregister(&panic_notifier_list, &panic_block);
 
-	/* This can't be called if any interfaces exist, so no worry about
-	   shutting down the interfaces. */
+	/*
+	 * This can't be called if any interfaces exist, so no worry
+	 * about shutting down the interfaces.
+	 */
 
-	/* Tell the timer to stop, then wait for it to stop.  This avoids
-	   problems with race conditions removing the timer here. */
+	/*
+	 * Tell the timer to stop, then wait for it to stop.  This
+	 * avoids problems with race conditions removing the timer
+	 * here.
+	 */
 	atomic_inc(&stop_operation);
 	del_timer_sync(&ipmi_timer);
 
@@ -4137,30 +4328,6 @@ module_exit(cleanup_ipmi);
 module_init(ipmi_init_msghandler_mod);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Corey Minyard <minyard@mvista.com>");
-MODULE_DESCRIPTION("Incoming and outgoing message routing for an IPMI interface.");
+MODULE_DESCRIPTION("Incoming and outgoing message routing for an IPMI"
+		   " interface.");
 MODULE_VERSION(IPMI_DRIVER_VERSION);
-
-EXPORT_SYMBOL(ipmi_create_user);
-EXPORT_SYMBOL(ipmi_destroy_user);
-EXPORT_SYMBOL(ipmi_get_version);
-EXPORT_SYMBOL(ipmi_request_settime);
-EXPORT_SYMBOL(ipmi_request_supply_msgs);
-EXPORT_SYMBOL(ipmi_poll_interface);
-EXPORT_SYMBOL(ipmi_register_smi);
-EXPORT_SYMBOL(ipmi_unregister_smi);
-EXPORT_SYMBOL(ipmi_register_for_cmd);
-EXPORT_SYMBOL(ipmi_unregister_for_cmd);
-EXPORT_SYMBOL(ipmi_smi_msg_received);
-EXPORT_SYMBOL(ipmi_smi_watchdog_pretimeout);
-EXPORT_SYMBOL(ipmi_alloc_smi_msg);
-EXPORT_SYMBOL(ipmi_addr_length);
-EXPORT_SYMBOL(ipmi_validate_addr);
-EXPORT_SYMBOL(ipmi_set_gets_events);
-EXPORT_SYMBOL(ipmi_smi_watcher_register);
-EXPORT_SYMBOL(ipmi_smi_watcher_unregister);
-EXPORT_SYMBOL(ipmi_set_my_address);
-EXPORT_SYMBOL(ipmi_get_my_address);
-EXPORT_SYMBOL(ipmi_set_my_LUN);
-EXPORT_SYMBOL(ipmi_get_my_LUN);
-EXPORT_SYMBOL(ipmi_smi_add_proc_entry);
-EXPORT_SYMBOL(ipmi_free_recv_msg);
diff -puN include/linux/ipmi.h~ipmi-style-fixes-in-the-base-code include/linux/ipmi.h
--- a/include/linux/ipmi.h~ipmi-style-fixes-in-the-base-code
+++ a/include/linux/ipmi.h
@@ -75,8 +75,7 @@
  * work for sockets.
  */
 #define IPMI_MAX_ADDR_SIZE 32
-struct ipmi_addr
-{
+struct ipmi_addr {
 	 /* Try to take these from the "Channel Medium Type" table
 	    in section 6.5 of the IPMI 1.5 manual. */
 	int   addr_type;
@@ -90,8 +89,7 @@ struct ipmi_addr
  * 0), or IPMC_BMC_CHANNEL if communicating directly with the BMC.
  */
 #define IPMI_SYSTEM_INTERFACE_ADDR_TYPE	0x0c
-struct ipmi_system_interface_addr
-{
+struct ipmi_system_interface_addr {
 	int           addr_type;
 	short         channel;
 	unsigned char lun;
@@ -100,10 +98,9 @@ struct ipmi_system_interface_addr
 /* An IPMB Address. */
 #define IPMI_IPMB_ADDR_TYPE		0x01
 /* Used for broadcast get device id as described in section 17.9 of the
-   IPMI 1.5 manual. */ 
+   IPMI 1.5 manual. */
 #define IPMI_IPMB_BROADCAST_ADDR_TYPE	0x41
-struct ipmi_ipmb_addr
-{
+struct ipmi_ipmb_addr {
 	int           addr_type;
 	short         channel;
 	unsigned char slave_addr;
@@ -128,8 +125,7 @@ struct ipmi_ipmb_addr
  * message is a little weird, but this is required.
  */
 #define IPMI_LAN_ADDR_TYPE		0x04
-struct ipmi_lan_addr
-{
+struct ipmi_lan_addr {
 	int           addr_type;
 	short         channel;
 	unsigned char privilege;
@@ -162,16 +158,14 @@ struct ipmi_lan_addr
  * byte of data in the response (as the spec shows the messages laid
  * out).
  */
-struct ipmi_msg
-{
+struct ipmi_msg {
 	unsigned char  netfn;
 	unsigned char  cmd;
 	unsigned short data_len;
 	unsigned char  __user *data;
 };
 
-struct kernel_ipmi_msg
-{
+struct kernel_ipmi_msg {
 	unsigned char  netfn;
 	unsigned char  cmd;
 	unsigned short data_len;
@@ -239,12 +233,11 @@ typedef struct ipmi_user *ipmi_user_t;
  * used after the message is delivered, so the upper layer may use the
  * link to build a linked list, if it likes.
  */
-struct ipmi_recv_msg
-{
+struct ipmi_recv_msg {
 	struct list_head link;
 
 	/* The type of message as defined in the "Receive Types"
-           defines above. */
+	   defines above. */
 	int              recv_type;
 
 	ipmi_user_t      user;
@@ -271,9 +264,8 @@ struct ipmi_recv_msg
 /* Allocate and free the receive message. */
 void ipmi_free_recv_msg(struct ipmi_recv_msg *msg);
 
-struct ipmi_user_hndl
-{
-        /* Routine type to call when a message needs to be routed to
+struct ipmi_user_hndl {
+	/* Routine type to call when a message needs to be routed to
 	   the upper layer.  This will be called with some locks held,
 	   the only IPMI routines that can be called are ipmi_request
 	   and the alloc/free operations.  The handler_data is the
@@ -433,8 +425,7 @@ int ipmi_set_gets_events(ipmi_user_t use
  * every existing interface when a new watcher is registered with
  * ipmi_smi_watcher_register().
  */
-struct ipmi_smi_watcher
-{
+struct ipmi_smi_watcher {
 	struct list_head link;
 
 	/* You must set the owner to the current module, if you are in
@@ -505,8 +496,7 @@ int ipmi_validate_addr(struct ipmi_addr 
 
 
 /* Messages sent to the interface are this format. */
-struct ipmi_req
-{
+struct ipmi_req {
 	unsigned char __user *addr; /* Address to send the message to. */
 	unsigned int  addr_len;
 
@@ -531,12 +521,11 @@ struct ipmi_req
 
 /* Messages sent to the interface with timing parameters are this
    format. */
-struct ipmi_req_settime
-{
+struct ipmi_req_settime {
 	struct ipmi_req req;
 
 	/* See ipmi_request_settime() above for details on these
-           values. */
+	   values. */
 	int          retries;
 	unsigned int retry_time_ms;
 };
@@ -553,8 +542,7 @@ struct ipmi_req_settime
 					     struct ipmi_req_settime)
 
 /* Messages received from the interface are this format. */
-struct ipmi_recv
-{
+struct ipmi_recv {
 	int     recv_type; /* Is this a command, response or an
 			      asyncronous event. */
 
@@ -600,13 +588,12 @@ struct ipmi_recv
 					      struct ipmi_recv)
 
 /* Register to get commands from other entities on this interface. */
-struct ipmi_cmdspec
-{
+struct ipmi_cmdspec {
 	unsigned char netfn;
 	unsigned char cmd;
 };
 
-/* 
+/*
  * Register to receive a specific command.  error values:
  *   - EFAULT - an address supplied was invalid.
  *   - EBUSY - The netfn/cmd supplied was already in use.
@@ -629,8 +616,7 @@ struct ipmi_cmdspec
  * else.  The chans field is a bitmask, (1 << channel) for each channel.
  * It may be IPMI_CHAN_ALL for all channels.
  */
-struct ipmi_cmdspec_chans
-{
+struct ipmi_cmdspec_chans {
 	unsigned int netfn;
 	unsigned int cmd;
 	unsigned int chans;
@@ -652,7 +638,7 @@ struct ipmi_cmdspec_chans
 #define IPMICTL_UNREGISTER_FOR_CMD_CHANS _IOR(IPMI_IOC_MAGIC, 29,	\
 					     struct ipmi_cmdspec_chans)
 
-/* 
+/*
  * Set whether this interface receives events.  Note that the first
  * user registered for events will get all pending events for the
  * interface.  error values:
@@ -668,15 +654,18 @@ struct ipmi_cmdspec_chans
  * things it takes to determine your address (if not the BMC) and set
  * it for everyone else.  You should probably leave the LUN alone.
  */
-struct ipmi_channel_lun_address_set
-{
+struct ipmi_channel_lun_address_set {
 	unsigned short channel;
 	unsigned char  value;
 };
-#define IPMICTL_SET_MY_CHANNEL_ADDRESS_CMD _IOR(IPMI_IOC_MAGIC, 24, struct ipmi_channel_lun_address_set)
-#define IPMICTL_GET_MY_CHANNEL_ADDRESS_CMD _IOR(IPMI_IOC_MAGIC, 25, struct ipmi_channel_lun_address_set)
-#define IPMICTL_SET_MY_CHANNEL_LUN_CMD	   _IOR(IPMI_IOC_MAGIC, 26, struct ipmi_channel_lun_address_set)
-#define IPMICTL_GET_MY_CHANNEL_LUN_CMD	   _IOR(IPMI_IOC_MAGIC, 27, struct ipmi_channel_lun_address_set)
+#define IPMICTL_SET_MY_CHANNEL_ADDRESS_CMD \
+	_IOR(IPMI_IOC_MAGIC, 24, struct ipmi_channel_lun_address_set)
+#define IPMICTL_GET_MY_CHANNEL_ADDRESS_CMD \
+	_IOR(IPMI_IOC_MAGIC, 25, struct ipmi_channel_lun_address_set)
+#define IPMICTL_SET_MY_CHANNEL_LUN_CMD \
+	_IOR(IPMI_IOC_MAGIC, 26, struct ipmi_channel_lun_address_set)
+#define IPMICTL_GET_MY_CHANNEL_LUN_CMD \
+	_IOR(IPMI_IOC_MAGIC, 27, struct ipmi_channel_lun_address_set)
 /* Legacy interfaces, these only set IPMB 0. */
 #define IPMICTL_SET_MY_ADDRESS_CMD	_IOR(IPMI_IOC_MAGIC, 17, unsigned int)
 #define IPMICTL_GET_MY_ADDRESS_CMD	_IOR(IPMI_IOC_MAGIC, 18, unsigned int)
@@ -687,8 +676,7 @@ struct ipmi_channel_lun_address_set
  * Get/set the default timing values for an interface.  You shouldn't
  * generally mess with these.
  */
-struct ipmi_timing_parms
-{
+struct ipmi_timing_parms {
 	int          retries;
 	unsigned int retry_time_ms;
 };
diff -puN include/linux/ipmi_smi.h~ipmi-style-fixes-in-the-base-code include/linux/ipmi_smi.h
--- a/include/linux/ipmi_smi.h~ipmi-style-fixes-in-the-base-code
+++ a/include/linux/ipmi_smi.h
@@ -60,8 +60,7 @@ typedef struct ipmi_smi *ipmi_smi_t;
  * asynchronous data and messages and request them from the
  * interface.
  */
-struct ipmi_smi_msg
-{
+struct ipmi_smi_msg {
 	struct list_head link;
 
 	long    msgid;
@@ -74,12 +73,11 @@ struct ipmi_smi_msg
 	unsigned char rsp[IPMI_MAX_MSG_LENGTH];
 
 	/* Will be called when the system is done with the message
-           (presumably to free it). */
+	   (presumably to free it). */
 	void (*done)(struct ipmi_smi_msg *msg);
 };
 
-struct ipmi_smi_handlers
-{
+struct ipmi_smi_handlers {
 	struct module *owner;
 
 	/* The low-level interface cannot start sending messages to
_

Patches currently in -mm which might be from cminyard@mvista.com are

origin.patch

