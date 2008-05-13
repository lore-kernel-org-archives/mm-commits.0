From: akpm@linux-foundation.org
Subject: - drivers-misc-sgi-xp-replace-partid_t-with-a-short.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:03 -0700
Message-ID: <200805132133.m4DLX3K0000779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759386AbYEMVdG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:33:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, holt@sgi.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc/sgi-xp: replace partid_t with a short
has been removed from the -mm tree.  Its filename was
     drivers-misc-sgi-xp-replace-partid_t-with-a-short.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc/sgi-xp: replace partid_t with a short
From: Dean Nelson <dcn@sgi.com>

In preparation for supporting greater than 64 partitions replace partid_t by
short in drivers/misc/sgi-xp.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Acked-by: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xp.h            |   34 +++++++++++++-------------
 drivers/misc/sgi-xp/xp_main.c       |   30 +++++++++++-----------
 drivers/misc/sgi-xp/xpc.h           |   20 +++++++--------
 drivers/misc/sgi-xp/xpc_channel.c   |   20 +++++++--------
 drivers/misc/sgi-xp/xpc_main.c      |   16 ++++++------
 drivers/misc/sgi-xp/xpc_partition.c |   10 +++----
 drivers/misc/sgi-xp/xpnet.c         |    8 +++---
 7 files changed, 69 insertions(+), 69 deletions(-)

diff -puN drivers/misc/sgi-xp/xp.h~drivers-misc-sgi-xp-replace-partid_t-with-a-short drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~drivers-misc-sgi-xp-replace-partid_t-with-a-short
+++ a/drivers/misc/sgi-xp/xp.h
@@ -264,7 +264,7 @@ enum xp_retval {
  * When a failure reason code is received, one can assume that the channel
  * is not connected.
  */
-typedef void (*xpc_channel_func) (enum xp_retval reason, partid_t partid,
+typedef void (*xpc_channel_func) (enum xp_retval reason, short partid,
 				  int ch_number, void *data, void *key);
 
 /*
@@ -286,7 +286,7 @@ typedef void (*xpc_channel_func) (enum x
  *
  * All other reason codes indicate failure.
  */
-typedef void (*xpc_notify_func) (enum xp_retval reason, partid_t partid,
+typedef void (*xpc_notify_func) (enum xp_retval reason, short partid,
 				 int ch_number, void *key);
 
 /*
@@ -322,24 +322,24 @@ struct xpc_registration {
 struct xpc_interface {
 	void (*connect) (int);
 	void (*disconnect) (int);
-	enum xp_retval (*allocate) (partid_t, int, u32, void **);
-	enum xp_retval (*send) (partid_t, int, void *);
-	enum xp_retval (*send_notify) (partid_t, int, void *,
+	enum xp_retval (*allocate) (short, int, u32, void **);
+	enum xp_retval (*send) (short, int, void *);
+	enum xp_retval (*send_notify) (short, int, void *,
 					xpc_notify_func, void *);
-	void (*received) (partid_t, int, void *);
-	enum xp_retval (*partid_to_nasids) (partid_t, void *);
+	void (*received) (short, int, void *);
+	enum xp_retval (*partid_to_nasids) (short, void *);
 };
 
 extern struct xpc_interface xpc_interface;
 
 extern void xpc_set_interface(void (*)(int),
 			      void (*)(int),
-			      enum xp_retval (*)(partid_t, int, u32, void **),
-			      enum xp_retval (*)(partid_t, int, void *),
-			      enum xp_retval (*)(partid_t, int, void *,
+			      enum xp_retval (*)(short, int, u32, void **),
+			      enum xp_retval (*)(short, int, void *),
+			      enum xp_retval (*)(short, int, void *,
 						  xpc_notify_func, void *),
-			      void (*)(partid_t, int, void *),
-			      enum xp_retval (*)(partid_t, void *));
+			      void (*)(short, int, void *),
+			      enum xp_retval (*)(short, void *));
 extern void xpc_clear_interface(void);
 
 extern enum xp_retval xpc_connect(int, xpc_channel_func, void *, u16,
@@ -347,32 +347,32 @@ extern enum xp_retval xpc_connect(int, x
 extern void xpc_disconnect(int);
 
 static inline enum xp_retval
-xpc_allocate(partid_t partid, int ch_number, u32 flags, void **payload)
+xpc_allocate(short partid, int ch_number, u32 flags, void **payload)
 {
 	return xpc_interface.allocate(partid, ch_number, flags, payload);
 }
 
 static inline enum xp_retval
-xpc_send(partid_t partid, int ch_number, void *payload)
+xpc_send(short partid, int ch_number, void *payload)
 {
 	return xpc_interface.send(partid, ch_number, payload);
 }
 
 static inline enum xp_retval
-xpc_send_notify(partid_t partid, int ch_number, void *payload,
+xpc_send_notify(short partid, int ch_number, void *payload,
 		xpc_notify_func func, void *key)
 {
 	return xpc_interface.send_notify(partid, ch_number, payload, func, key);
 }
 
 static inline void
-xpc_received(partid_t partid, int ch_number, void *payload)
+xpc_received(short partid, int ch_number, void *payload)
 {
 	return xpc_interface.received(partid, ch_number, payload);
 }
 
 static inline enum xp_retval
-xpc_partid_to_nasids(partid_t partid, void *nasids)
+xpc_partid_to_nasids(short partid, void *nasids)
 {
 	return xpc_interface.partid_to_nasids(partid, nasids);
 }
diff -puN drivers/misc/sgi-xp/xp_main.c~drivers-misc-sgi-xp-replace-partid_t-with-a-short drivers/misc/sgi-xp/xp_main.c
--- a/drivers/misc/sgi-xp/xp_main.c~drivers-misc-sgi-xp-replace-partid_t-with-a-short
+++ a/drivers/misc/sgi-xp/xp_main.c
@@ -51,12 +51,12 @@ xpc_notloaded(void)
 struct xpc_interface xpc_interface = {
 	(void (*)(int))xpc_notloaded,
 	(void (*)(int))xpc_notloaded,
-	(enum xp_retval(*)(partid_t, int, u32, void **))xpc_notloaded,
-	(enum xp_retval(*)(partid_t, int, void *))xpc_notloaded,
-	(enum xp_retval(*)(partid_t, int, void *, xpc_notify_func, void *))
+	(enum xp_retval(*)(short, int, u32, void **))xpc_notloaded,
+	(enum xp_retval(*)(short, int, void *))xpc_notloaded,
+	(enum xp_retval(*)(short, int, void *, xpc_notify_func, void *))
 	    xpc_notloaded,
-	(void (*)(partid_t, int, void *))xpc_notloaded,
-	(enum xp_retval(*)(partid_t, void *))xpc_notloaded
+	(void (*)(short, int, void *))xpc_notloaded,
+	(enum xp_retval(*)(short, void *))xpc_notloaded
 };
 EXPORT_SYMBOL_GPL(xpc_interface);
 
@@ -66,12 +66,12 @@ EXPORT_SYMBOL_GPL(xpc_interface);
 void
 xpc_set_interface(void (*connect) (int),
 		  void (*disconnect) (int),
-		  enum xp_retval (*allocate) (partid_t, int, u32, void **),
-		  enum xp_retval (*send) (partid_t, int, void *),
-		  enum xp_retval (*send_notify) (partid_t, int, void *,
+		  enum xp_retval (*allocate) (short, int, u32, void **),
+		  enum xp_retval (*send) (short, int, void *),
+		  enum xp_retval (*send_notify) (short, int, void *,
 						  xpc_notify_func, void *),
-		  void (*received) (partid_t, int, void *),
-		  enum xp_retval (*partid_to_nasids) (partid_t, void *))
+		  void (*received) (short, int, void *),
+		  enum xp_retval (*partid_to_nasids) (short, void *))
 {
 	xpc_interface.connect = connect;
 	xpc_interface.disconnect = disconnect;
@@ -91,16 +91,16 @@ xpc_clear_interface(void)
 {
 	xpc_interface.connect = (void (*)(int))xpc_notloaded;
 	xpc_interface.disconnect = (void (*)(int))xpc_notloaded;
-	xpc_interface.allocate = (enum xp_retval(*)(partid_t, int, u32,
+	xpc_interface.allocate = (enum xp_retval(*)(short, int, u32,
 						     void **))xpc_notloaded;
-	xpc_interface.send = (enum xp_retval(*)(partid_t, int, void *))
+	xpc_interface.send = (enum xp_retval(*)(short, int, void *))
 	    xpc_notloaded;
-	xpc_interface.send_notify = (enum xp_retval(*)(partid_t, int, void *,
+	xpc_interface.send_notify = (enum xp_retval(*)(short, int, void *,
 							xpc_notify_func,
 							void *))xpc_notloaded;
-	xpc_interface.received = (void (*)(partid_t, int, void *))
+	xpc_interface.received = (void (*)(short, int, void *))
 	    xpc_notloaded;
-	xpc_interface.partid_to_nasids = (enum xp_retval(*)(partid_t, void *))
+	xpc_interface.partid_to_nasids = (enum xp_retval(*)(short, void *))
 	    xpc_notloaded;
 }
 EXPORT_SYMBOL_GPL(xpc_clear_interface);
diff -puN drivers/misc/sgi-xp/xpc.h~drivers-misc-sgi-xp-replace-partid_t-with-a-short drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~drivers-misc-sgi-xp-replace-partid_t-with-a-short
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -172,13 +172,13 @@ struct xpc_vars {
 			(_version >= _XPC_VERSION(3, 1))
 
 static inline int
-xpc_hb_allowed(partid_t partid, struct xpc_vars *vars)
+xpc_hb_allowed(short partid, struct xpc_vars *vars)
 {
 	return ((vars->heartbeating_to_mask & (1UL << partid)) != 0);
 }
 
 static inline void
-xpc_allow_hb(partid_t partid, struct xpc_vars *vars)
+xpc_allow_hb(short partid, struct xpc_vars *vars)
 {
 	u64 old_mask, new_mask;
 
@@ -190,7 +190,7 @@ xpc_allow_hb(partid_t partid, struct xpc
 }
 
 static inline void
-xpc_disallow_hb(partid_t partid, struct xpc_vars *vars)
+xpc_disallow_hb(short partid, struct xpc_vars *vars)
 {
 	u64 old_mask, new_mask;
 
@@ -408,7 +408,7 @@ struct xpc_notify {
  *	messages.
  */
 struct xpc_channel {
-	partid_t partid;	/* ID of remote partition connected */
+	short partid;		/* ID of remote partition connected */
 	spinlock_t lock;	/* lock for updating this structure */
 	u32 flags;		/* general flags */
 
@@ -615,7 +615,7 @@ struct xpc_partition {
 /* interval in seconds to print 'waiting disengagement' messages */
 #define XPC_DISENGAGE_PRINTMSG_INTERVAL		10
 
-#define XPC_PARTID(_p)	((partid_t) ((_p) - &xpc_partitions[0]))
+#define XPC_PARTID(_p)	((short)((_p) - &xpc_partitions[0]))
 
 /* found in xp_main.c */
 extern struct xpc_registration xpc_registrations[];
@@ -652,16 +652,16 @@ extern void xpc_discovery(void);
 extern void xpc_check_remote_hb(void);
 extern void xpc_deactivate_partition(const int, struct xpc_partition *,
 				     enum xp_retval);
-extern enum xp_retval xpc_initiate_partid_to_nasids(partid_t, void *);
+extern enum xp_retval xpc_initiate_partid_to_nasids(short, void *);
 
 /* found in xpc_channel.c */
 extern void xpc_initiate_connect(int);
 extern void xpc_initiate_disconnect(int);
-extern enum xp_retval xpc_initiate_allocate(partid_t, int, u32, void **);
-extern enum xp_retval xpc_initiate_send(partid_t, int, void *);
-extern enum xp_retval xpc_initiate_send_notify(partid_t, int, void *,
+extern enum xp_retval xpc_initiate_allocate(short, int, u32, void **);
+extern enum xp_retval xpc_initiate_send(short, int, void *);
+extern enum xp_retval xpc_initiate_send_notify(short, int, void *,
 					       xpc_notify_func, void *);
-extern void xpc_initiate_received(partid_t, int, void *);
+extern void xpc_initiate_received(short, int, void *);
 extern enum xp_retval xpc_setup_infrastructure(struct xpc_partition *);
 extern enum xp_retval xpc_pull_remote_vars_part(struct xpc_partition *);
 extern void xpc_process_channel_activity(struct xpc_partition *);
diff -puN drivers/misc/sgi-xp/xpc_channel.c~drivers-misc-sgi-xp-replace-partid_t-with-a-short drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~drivers-misc-sgi-xp-replace-partid_t-with-a-short
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -53,7 +53,7 @@ xpc_kzalloc_cacheline_aligned(size_t siz
  * Set up the initial values for the XPartition Communication channels.
  */
 static void
-xpc_initialize_channels(struct xpc_partition *part, partid_t partid)
+xpc_initialize_channels(struct xpc_partition *part, short partid)
 {
 	int ch_number;
 	struct xpc_channel *ch;
@@ -95,7 +95,7 @@ xpc_setup_infrastructure(struct xpc_part
 {
 	int ret, cpuid;
 	struct timer_list *timer;
-	partid_t partid = XPC_PARTID(part);
+	short partid = XPC_PARTID(part);
 
 	/*
 	 * Zero out MOST of the entry for this partition. Only the fields
@@ -290,7 +290,7 @@ xpc_pull_remote_vars_part(struct xpc_par
 	    (struct xpc_vars_part *)L1_CACHE_ALIGN((u64)buffer);
 	struct xpc_vars_part *pulled_entry;
 	u64 remote_entry_cacheline_pa, remote_entry_pa;
-	partid_t partid = XPC_PARTID(part);
+	short partid = XPC_PARTID(part);
 	enum xp_retval ret;
 
 	/* pull the cacheline that contains the variables we're interested in */
@@ -1375,7 +1375,7 @@ xpc_partition_going_down(struct xpc_part
 void
 xpc_teardown_infrastructure(struct xpc_partition *part)
 {
-	partid_t partid = XPC_PARTID(part);
+	short partid = XPC_PARTID(part);
 
 	/*
 	 * We start off by making this partition inaccessible to local
@@ -1428,7 +1428,7 @@ xpc_teardown_infrastructure(struct xpc_p
 void
 xpc_initiate_connect(int ch_number)
 {
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	struct xpc_channel *ch;
 
@@ -1484,7 +1484,7 @@ void
 xpc_initiate_disconnect(int ch_number)
 {
 	unsigned long irq_flags;
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	struct xpc_channel *ch;
 
@@ -1728,7 +1728,7 @@ xpc_allocate_msg(struct xpc_channel *ch,
  * 	          return) in which the user-defined message is constructed.
  */
 enum xp_retval
-xpc_initiate_allocate(partid_t partid, int ch_number, u32 flags, void **payload)
+xpc_initiate_allocate(short partid, int ch_number, u32 flags, void **payload)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
 	enum xp_retval ret = xpUnknownReason;
@@ -1909,7 +1909,7 @@ xpc_send_msg(struct xpc_channel *ch, str
  *			xpc_initiate_allocate().
  */
 enum xp_retval
-xpc_initiate_send(partid_t partid, int ch_number, void *payload)
+xpc_initiate_send(short partid, int ch_number, void *payload)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
 	struct xpc_msg *msg = XPC_MSG_ADDRESS(payload);
@@ -1958,7 +1958,7 @@ xpc_initiate_send(partid_t partid, int c
  *	key - user-defined key to be passed to the function when it's called.
  */
 enum xp_retval
-xpc_initiate_send_notify(partid_t partid, int ch_number, void *payload,
+xpc_initiate_send_notify(short partid, int ch_number, void *payload,
 			 xpc_notify_func func, void *key)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
@@ -2203,7 +2203,7 @@ xpc_acknowledge_msgs(struct xpc_channel 
  *			xpc_initiate_allocate().
  */
 void
-xpc_initiate_received(partid_t partid, int ch_number, void *payload)
+xpc_initiate_received(short partid, int ch_number, void *payload)
 {
 	struct xpc_partition *part = &xpc_partitions[partid];
 	struct xpc_channel *ch;
diff -puN drivers/misc/sgi-xp/xpc_main.c~drivers-misc-sgi-xp-replace-partid_t-with-a-short drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~drivers-misc-sgi-xp-replace-partid_t-with-a-short
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -429,7 +429,7 @@ xpc_partition_up(struct xpc_partition *p
 static int
 xpc_activating(void *__partid)
 {
-	partid_t partid = (u64)__partid;
+	short partid = (u64)__partid;
 	struct xpc_partition *part = &xpc_partitions[partid];
 	unsigned long irq_flags;
 
@@ -499,7 +499,7 @@ xpc_activating(void *__partid)
 void
 xpc_activate_partition(struct xpc_partition *part)
 {
-	partid_t partid = XPC_PARTID(part);
+	short partid = XPC_PARTID(part);
 	unsigned long irq_flags;
 	struct task_struct *kthread;
 
@@ -541,7 +541,7 @@ xpc_activate_partition(struct xpc_partit
 irqreturn_t
 xpc_notify_IRQ_handler(int irq, void *dev_id)
 {
-	partid_t partid = (partid_t) (u64)dev_id;
+	short partid = (short)(u64)dev_id;
 	struct xpc_partition *part = &xpc_partitions[partid];
 
 	DBUG_ON(partid <= 0 || partid >= XP_MAX_PARTITIONS);
@@ -643,7 +643,7 @@ xpc_kthread_waitmsgs(struct xpc_partitio
 static int
 xpc_kthread_start(void *args)
 {
-	partid_t partid = XPC_UNPACK_ARG1(args);
+	short partid = XPC_UNPACK_ARG1(args);
 	u16 ch_number = XPC_UNPACK_ARG2(args);
 	struct xpc_partition *part = &xpc_partitions[partid];
 	struct xpc_channel *ch;
@@ -809,7 +809,7 @@ void
 xpc_disconnect_wait(int ch_number)
 {
 	unsigned long irq_flags;
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	struct xpc_channel *ch;
 	int wakeup_channel_mgr;
@@ -859,7 +859,7 @@ xpc_disconnect_wait(int ch_number)
 static void
 xpc_do_exit(enum xp_retval reason)
 {
-	partid_t partid;
+	short partid;
 	int active_part_count, printed_waiting_msg = 0;
 	struct xpc_partition *part;
 	unsigned long printmsg_time, disengage_request_timeout = 0;
@@ -1008,7 +1008,7 @@ static void
 xpc_die_disengage(void)
 {
 	struct xpc_partition *part;
-	partid_t partid;
+	short partid;
 	unsigned long engaged;
 	long time, printmsg_time, disengage_request_timeout;
 
@@ -1124,7 +1124,7 @@ int __init
 xpc_init(void)
 {
 	int ret;
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	struct task_struct *kthread;
 	size_t buf_size;
diff -puN drivers/misc/sgi-xp/xpc_partition.c~drivers-misc-sgi-xp-replace-partid_t-with-a-short drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~drivers-misc-sgi-xp-replace-partid_t-with-a-short
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -403,7 +403,7 @@ xpc_check_remote_hb(void)
 {
 	struct xpc_vars *remote_vars;
 	struct xpc_partition *part;
-	partid_t partid;
+	short partid;
 	bte_result_t bres;
 
 	remote_vars = (struct xpc_vars *)xpc_remote_copy_buffer;
@@ -604,7 +604,7 @@ xpc_identify_act_IRQ_req(int nasid)
 	int reactivate = 0;
 	int stamp_diff;
 	struct timespec remote_rp_stamp = { 0, 0 };
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	enum xp_retval ret;
 
@@ -825,7 +825,7 @@ xpc_identify_act_IRQ_sender(void)
 int
 xpc_partition_disengaged(struct xpc_partition *part)
 {
-	partid_t partid = XPC_PARTID(part);
+	short partid = XPC_PARTID(part);
 	int disengaged;
 
 	disengaged = (xpc_partition_engaged(1UL << partid) == 0);
@@ -982,7 +982,7 @@ xpc_discovery(void)
 	int max_regions;
 	int nasid;
 	struct xpc_rsvd_page *rp;
-	partid_t partid;
+	short partid;
 	struct xpc_partition *part;
 	u64 *discovered_nasids;
 	enum xp_retval ret;
@@ -1152,7 +1152,7 @@ xpc_discovery(void)
  * remote partition's reserved page.
  */
 enum xp_retval
-xpc_initiate_partid_to_nasids(partid_t partid, void *nasid_mask)
+xpc_initiate_partid_to_nasids(short partid, void *nasid_mask)
 {
 	struct xpc_partition *part;
 	u64 part_nasid_pa;
diff -puN drivers/misc/sgi-xp/xpnet.c~drivers-misc-sgi-xp-replace-partid_t-with-a-short drivers/misc/sgi-xp/xpnet.c
--- a/drivers/misc/sgi-xp/xpnet.c~drivers-misc-sgi-xp-replace-partid_t-with-a-short
+++ a/drivers/misc/sgi-xp/xpnet.c
@@ -166,7 +166,7 @@ struct device *xpnet = &xpnet_dbg_subnam
  * Packet was recevied by XPC and forwarded to us.
  */
 static void
-xpnet_receive(partid_t partid, int channel, struct xpnet_message *msg)
+xpnet_receive(short partid, int channel, struct xpnet_message *msg)
 {
 	struct sk_buff *skb;
 	bte_result_t bret;
@@ -282,7 +282,7 @@ xpnet_receive(partid_t partid, int chann
  * state or message reception on a connection.
  */
 static void
-xpnet_connection_activity(enum xp_retval reason, partid_t partid, int channel,
+xpnet_connection_activity(enum xp_retval reason, short partid, int channel,
 			  void *data, void *key)
 {
 	long bp;
@@ -407,7 +407,7 @@ xpnet_dev_get_stats(struct net_device *d
  * release the skb and then release our pending message structure.
  */
 static void
-xpnet_send_completed(enum xp_retval reason, partid_t partid, int channel,
+xpnet_send_completed(enum xp_retval reason, short partid, int channel,
 		     void *__qm)
 {
 	struct xpnet_pending_msg *queued_msg = (struct xpnet_pending_msg *)__qm;
@@ -444,7 +444,7 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 	u64 start_addr, end_addr;
 	long dp;
 	u8 second_mac_octet;
-	partid_t dest_partid;
+	short dest_partid;
 	struct xpnet_dev_private *priv;
 	u16 embedded_bytes;
 
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch

