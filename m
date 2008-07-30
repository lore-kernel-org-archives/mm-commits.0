From: akpm@linux-foundation.org
Subject: - sgi-xp-setup-the-activate-gru-message-queue.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:17:15 -0700
Message-ID: <200807301917.m6UJHFRU011198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753265AbYG3TSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:18:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, steiner@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: setup the activate GRU message queue
has been removed from the -mm tree.  Its filename was
     sgi-xp-setup-the-activate-gru-message-queue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: setup the activate GRU message queue
From: Dean Nelson <dcn@sgi.com>

Setup the activate GRU message queue that is used for partition activation
and channel connection on UV systems.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xp.h            |    3 
 drivers/misc/sgi-xp/xp_uv.c         |   10 
 drivers/misc/sgi-xp/xpc.h           |  158 ++++-
 drivers/misc/sgi-xp/xpc_channel.c   |   22 
 drivers/misc/sgi-xp/xpc_main.c      |  329 ++++++++--
 drivers/misc/sgi-xp/xpc_partition.c |   28 
 drivers/misc/sgi-xp/xpc_sn2.c       |  387 +++++-------
 drivers/misc/sgi-xp/xpc_uv.c        |  781 +++++++++++++++++++++++++-
 8 files changed, 1328 insertions(+), 390 deletions(-)

diff -puN drivers/misc/sgi-xp/xp.h~sgi-xp-setup-the-activate-gru-message-queue drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~sgi-xp-setup-the-activate-gru-message-queue
+++ a/drivers/misc/sgi-xp/xp.h
@@ -208,8 +208,9 @@ enum xp_retval {
 	xpNeedMoreInfo,		/* 57: more info is needed by SAL */
 
 	xpGruCopyError,		/* 58: gru_copy_gru() returned error */
+	xpGruSendMqError,	/* 59: gru send message queue related error */
 
-	xpUnknownReason		/* 59: unknown reason - must be last in enum */
+	xpUnknownReason		/* 60: unknown reason - must be last in enum */
 };
 
 /*
diff -puN drivers/misc/sgi-xp/xp_uv.c~sgi-xp-setup-the-activate-gru-message-queue drivers/misc/sgi-xp/xp_uv.c
--- a/drivers/misc/sgi-xp/xp_uv.c~sgi-xp-setup-the-activate-gru-message-queue
+++ a/drivers/misc/sgi-xp/xp_uv.c
@@ -42,15 +42,25 @@ xp_remote_memcpy_uv(unsigned long dst_gp
 	return xpGruCopyError;
 }
 
+static int
+xp_cpu_to_nasid_uv(int cpuid)
+{
+	/* ??? Is this same as sn2 nasid in mach/part bitmaps set up by SAL? */
+	return UV_PNODE_TO_NASID(uv_cpu_to_pnode(cpuid));
+}
+
 enum xp_retval
 xp_init_uv(void)
 {
 	BUG_ON(!is_uv());
 
 	xp_max_npartitions = XP_MAX_NPARTITIONS_UV;
+	xp_partition_id = 0;	/* !!! not correct value */
+	xp_region_size = 0;	/* !!! not correct value */
 
 	xp_pa = xp_pa_uv;
 	xp_remote_memcpy = xp_remote_memcpy_uv;
+	xp_cpu_to_nasid = xp_cpu_to_nasid_uv;
 
 	return xpSuccess;
 }
diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-setup-the-activate-gru-message-queue drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-setup-the-activate-gru-message-queue
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -164,8 +164,8 @@ struct xpc_vars_part_sn2 {
  * MAGIC2 indicates that this partition has pulled the remote partititions
  * per partition variables that pertain to this partition.
  */
-#define XPC_VP_MAGIC1	0x0053524156435058L   /* 'XPCVARS\0'L (little endian) */
-#define XPC_VP_MAGIC2	0x0073726176435058L   /* 'XPCvars\0'L (little endian) */
+#define XPC_VP_MAGIC1_SN2 0x0053524156435058L /* 'XPCVARS\0'L (little endian) */
+#define XPC_VP_MAGIC2_SN2 0x0073726176435058L /* 'XPCvars\0'L (little endian) */
 
 /* the reserved page sizes and offsets */
 
@@ -181,6 +181,80 @@ struct xpc_vars_part_sn2 {
 				  xpc_nasid_mask_nlongs))
 
 /*
+ * The activate_mq is used to send/receive messages that affect XPC's heartbeat,
+ * partition active state, and channel state. This is UV only.
+ */
+struct xpc_activate_mq_msghdr_uv {
+	short partid;		/* sender's partid */
+	u8 act_state;		/* sender's act_state at time msg sent */
+	u8 type;		/* message's type */
+	unsigned long rp_ts_jiffies; /* timestamp of sender's rp setup by XPC */
+};
+
+/* activate_mq defined message types */
+#define XPC_ACTIVATE_MQ_MSG_SYNC_ACT_STATE_UV		0
+#define XPC_ACTIVATE_MQ_MSG_INC_HEARTBEAT_UV		1
+#define XPC_ACTIVATE_MQ_MSG_OFFLINE_HEARTBEAT_UV	2
+#define XPC_ACTIVATE_MQ_MSG_ONLINE_HEARTBEAT_UV		3
+
+#define XPC_ACTIVATE_MQ_MSG_ACTIVATE_REQ_UV		4
+#define XPC_ACTIVATE_MQ_MSG_DEACTIVATE_REQ_UV		5
+
+#define XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREQUEST_UV	6
+#define XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREPLY_UV		7
+#define XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREQUEST_UV	8
+#define XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREPLY_UV		9
+
+#define XPC_ACTIVATE_MQ_MSG_MARK_ENGAGED_UV		10
+#define XPC_ACTIVATE_MQ_MSG_MARK_DISENGAGED_UV		11
+
+struct xpc_activate_mq_msg_uv {
+	struct xpc_activate_mq_msghdr_uv header;
+};
+
+struct xpc_activate_mq_msg_heartbeat_req_uv {
+	struct xpc_activate_mq_msghdr_uv header;
+	u64 heartbeat;
+};
+
+struct xpc_activate_mq_msg_activate_req_uv {
+	struct xpc_activate_mq_msghdr_uv header;
+	unsigned long rp_gpa;
+	unsigned long activate_mq_gpa;
+};
+
+struct xpc_activate_mq_msg_deactivate_req_uv {
+	struct xpc_activate_mq_msghdr_uv header;
+	enum xp_retval reason;
+};
+
+struct xpc_activate_mq_msg_chctl_closerequest_uv {
+	struct xpc_activate_mq_msghdr_uv header;
+	short ch_number;
+	enum xp_retval reason;
+};
+
+struct xpc_activate_mq_msg_chctl_closereply_uv {
+	struct xpc_activate_mq_msghdr_uv header;
+	short ch_number;
+};
+
+struct xpc_activate_mq_msg_chctl_openrequest_uv {
+	struct xpc_activate_mq_msghdr_uv header;
+	short ch_number;
+	short msg_size;		/* size of notify_mq's messages */
+	short local_nentries;	/* ??? Is this needed? What is? */
+};
+
+struct xpc_activate_mq_msg_chctl_openreply_uv {
+	struct xpc_activate_mq_msghdr_uv header;
+	short ch_number;
+	short remote_nentries;	/* ??? Is this needed? What is? */
+	short local_nentries;	/* ??? Is this needed? What is? */
+	unsigned long local_notify_mq_gpa;
+};
+
+/*
  * Functions registered by add_timer() or called by kernel_thread() only
  * allow for a single 64-bit argument. The following macros can be used to
  * pack and unpack two (32-bit, 16-bit or 8-bit) arguments into or out from
@@ -331,6 +405,18 @@ struct xpc_notify {
  */
 
 struct xpc_channel_sn2 {
+	struct xpc_openclose_args *local_openclose_args; /* args passed on */
+					     /* opening or closing of channel */
+
+	void *local_msgqueue_base;	/* base address of kmalloc'd space */
+	struct xpc_msg *local_msgqueue;	/* local message queue */
+	void *remote_msgqueue_base;	/* base address of kmalloc'd space */
+	struct xpc_msg *remote_msgqueue; /* cached copy of remote partition's */
+					 /* local message queue */
+	unsigned long remote_msgqueue_pa; /* phys addr of remote partition's */
+					  /* local message queue */
+
+	struct xpc_notify *notify_queue;    /* notify queue for messages sent */
 
 	/* various flavors of local and remote Get/Put values */
 
@@ -344,13 +430,14 @@ struct xpc_channel_sn2 {
 };
 
 struct xpc_channel_uv {
-	/* !!! code is coming */
+	unsigned long remote_notify_mq_gpa;	/* gru phys address of remote */
+						/* partition's notify mq */
 };
 
 struct xpc_channel {
 	short partid;		/* ID of remote partition connected */
 	spinlock_t lock;	/* lock for updating this structure */
-	u32 flags;		/* general flags */
+	unsigned int flags;	/* general flags */
 
 	enum xp_retval reason;	/* reason why channel is disconnect'g */
 	int reason_line;	/* line# disconnect initiated from */
@@ -361,14 +448,6 @@ struct xpc_channel {
 	u16 local_nentries;	/* #of msg entries in local msg queue */
 	u16 remote_nentries;	/* #of msg entries in remote msg queue */
 
-	void *local_msgqueue_base;	/* base address of kmalloc'd space */
-	struct xpc_msg *local_msgqueue;	/* local message queue */
-	void *remote_msgqueue_base;	/* base address of kmalloc'd space */
-	struct xpc_msg *remote_msgqueue; /* cached copy of remote partition's */
-					 /* local message queue */
-	unsigned long remote_msgqueue_pa; /* phys addr of remote partition's */
-					  /* local message queue */
-
 	atomic_t references;	/* #of external references to queues */
 
 	atomic_t n_on_msg_allocate_wq;	/* #on msg allocation wait queue */
@@ -377,19 +456,13 @@ struct xpc_channel {
 	u8 delayed_chctl_flags;	/* chctl flags received, but delayed */
 				/* action until channel disconnected */
 
-	/* queue of msg senders who want to be notified when msg received */
-
 	atomic_t n_to_notify;	/* #of msg senders to notify */
-	struct xpc_notify *notify_queue;    /* notify queue for messages sent */
 
 	xpc_channel_func func;	/* user's channel function */
 	void *key;		/* pointer to user's key */
 
 	struct completion wdisconnect_wait;    /* wait for channel disconnect */
 
-	struct xpc_openclose_args *local_openclose_args; /* args passed on */
-					     /* opening or closing of channel */
-
 	/* kthread management related fields */
 
 	atomic_t kthreads_assigned;	/* #of kthreads assigned to channel */
@@ -507,6 +580,8 @@ struct xpc_partition_sn2 {
 	unsigned long remote_GPs_pa; /* phys addr of remote partition's local */
 				     /* Get/Put values */
 
+	void *local_openclose_args_base;   /* base address of kmalloc'd space */
+	struct xpc_openclose_args *local_openclose_args;      /* local's args */
 	unsigned long remote_openclose_args_pa;	/* phys addr of remote's args */
 
 	int notify_IRQ_nasid;	/* nasid of where to send notify IRQs */
@@ -520,9 +595,27 @@ struct xpc_partition_sn2 {
 };
 
 struct xpc_partition_uv {
-	/* !!! code is coming */
+	unsigned long remote_activate_mq_gpa;	/* gru phys address of remote */
+						/* partition's activate mq */
+	spinlock_t flags_lock;	/* protect updating of flags */
+	unsigned int flags;	/* general flags */
+	u8 remote_act_state;	/* remote partition's act_state */
+	u8 act_state_req;	/* act_state request from remote partition */
+	enum xp_retval reason;	/* reason for deactivate act_state request */
+	u64 heartbeat;		/* incremented by remote partition */
 };
 
+/* struct xpc_partition_uv flags */
+
+#define XPC_P_HEARTBEAT_OFFLINE_UV	0x00000001
+#define XPC_P_ENGAGED_UV		0x00000002
+
+/* struct xpc_partition_uv act_state change requests */
+
+#define XPC_P_ASR_ACTIVATE_UV		0x01
+#define XPC_P_ASR_REACTIVATE_UV		0x02
+#define XPC_P_ASR_DEACTIVATE_UV		0x03
+
 struct xpc_partition {
 
 	/* XPC HB infrastructure */
@@ -556,8 +649,6 @@ struct xpc_partition {
 	union xpc_channel_ctl_flags chctl; /* chctl flags yet to be processed */
 	spinlock_t chctl_lock;	/* chctl flags lock */
 
-	void *local_openclose_args_base;   /* base address of kmalloc'd space */
-	struct xpc_openclose_args *local_openclose_args;      /* local's args */
 	void *remote_openclose_args_base;  /* base address of kmalloc'd space */
 	struct xpc_openclose_args *remote_openclose_args; /* copy of remote's */
 							  /* args */
@@ -616,17 +707,20 @@ extern struct device *xpc_part;
 extern struct device *xpc_chan;
 extern int xpc_disengage_timelimit;
 extern int xpc_disengage_timedout;
-extern atomic_t xpc_activate_IRQ_rcvd;
+extern int xpc_activate_IRQ_rcvd;
+extern spinlock_t xpc_activate_IRQ_rcvd_lock;
 extern wait_queue_head_t xpc_activate_IRQ_wq;
 extern void *xpc_heartbeating_to_mask;
+extern void *xpc_kzalloc_cacheline_aligned(size_t, gfp_t, void **);
 extern void xpc_activate_partition(struct xpc_partition *);
 extern void xpc_activate_kthreads(struct xpc_channel *, int);
 extern void xpc_create_kthreads(struct xpc_channel *, int, int);
 extern void xpc_disconnect_wait(int);
+extern int (*xpc_setup_partitions_sn) (void);
 extern enum xp_retval (*xpc_get_partition_rsvd_page_pa) (void *, u64 *,
 							 unsigned long *,
 							 size_t *);
-extern enum xp_retval (*xpc_rsvd_page_init) (struct xpc_rsvd_page *);
+extern int (*xpc_setup_rsvd_page_sn) (struct xpc_rsvd_page *);
 extern void (*xpc_heartbeat_init) (void);
 extern void (*xpc_heartbeat_exit) (void);
 extern void (*xpc_increment_heartbeat) (void);
@@ -635,8 +729,8 @@ extern void (*xpc_online_heartbeat) (voi
 extern enum xp_retval (*xpc_get_remote_heartbeat) (struct xpc_partition *);
 extern enum xp_retval (*xpc_make_first_contact) (struct xpc_partition *);
 extern u64 (*xpc_get_chctl_all_flags) (struct xpc_partition *);
-extern enum xp_retval (*xpc_allocate_msgqueues) (struct xpc_channel *);
-extern void (*xpc_free_msgqueues) (struct xpc_channel *);
+extern enum xp_retval (*xpc_setup_msg_structures) (struct xpc_channel *);
+extern void (*xpc_teardown_msg_structures) (struct xpc_channel *);
 extern void (*xpc_notify_senders_of_disconnect) (struct xpc_channel *);
 extern void (*xpc_process_msg_chctl_flags) (struct xpc_partition *, int);
 extern int (*xpc_n_of_deliverable_msgs) (struct xpc_channel *);
@@ -647,9 +741,9 @@ extern void (*xpc_request_partition_reac
 extern void (*xpc_request_partition_deactivation) (struct xpc_partition *);
 extern void (*xpc_cancel_partition_deactivation_request) (
 							struct xpc_partition *);
-extern void (*xpc_process_activate_IRQ_rcvd) (int);
-extern enum xp_retval (*xpc_setup_infrastructure) (struct xpc_partition *);
-extern void (*xpc_teardown_infrastructure) (struct xpc_partition *);
+extern void (*xpc_process_activate_IRQ_rcvd) (void);
+extern enum xp_retval (*xpc_setup_ch_structures_sn) (struct xpc_partition *);
+extern void (*xpc_teardown_ch_structures_sn) (struct xpc_partition *);
 
 extern void (*xpc_indicate_partition_engaged) (struct xpc_partition *);
 extern int (*xpc_partition_engaged) (short);
@@ -665,6 +759,9 @@ extern void (*xpc_send_chctl_openrequest
 					   unsigned long *);
 extern void (*xpc_send_chctl_openreply) (struct xpc_channel *, unsigned long *);
 
+extern void (*xpc_save_remote_msgqueue_pa) (struct xpc_channel *,
+					    unsigned long);
+
 extern enum xp_retval (*xpc_send_msg) (struct xpc_channel *, u32, void *, u16,
 				       u8, xpc_notify_func, void *);
 extern void (*xpc_received_msg) (struct xpc_channel *, struct xpc_msg *);
@@ -674,7 +771,7 @@ extern int xpc_init_sn2(void);
 extern void xpc_exit_sn2(void);
 
 /* found in xpc_uv.c */
-extern void xpc_init_uv(void);
+extern int xpc_init_uv(void);
 extern void xpc_exit_uv(void);
 
 /* found in xpc_partition.c */
@@ -684,7 +781,8 @@ extern struct xpc_rsvd_page *xpc_rsvd_pa
 extern unsigned long *xpc_mach_nasids;
 extern struct xpc_partition *xpc_partitions;
 extern void *xpc_kmalloc_cacheline_aligned(size_t, gfp_t, void **);
-extern struct xpc_rsvd_page *xpc_setup_rsvd_page(void);
+extern int xpc_setup_rsvd_page(void);
+extern void xpc_teardown_rsvd_page(void);
 extern int xpc_identify_activate_IRQ_sender(void);
 extern int xpc_partition_disengaged(struct xpc_partition *);
 extern enum xp_retval xpc_mark_partition_active(struct xpc_partition *);
diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-setup-the-activate-gru-message-queue drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-setup-the-activate-gru-message-queue
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -39,7 +39,7 @@ xpc_process_connect(struct xpc_channel *
 
 	if (!(ch->flags & XPC_C_SETUP)) {
 		spin_unlock_irqrestore(&ch->lock, *irq_flags);
-		ret = xpc_allocate_msgqueues(ch);
+		ret = xpc_setup_msg_structures(ch);
 		spin_lock_irqsave(&ch->lock, *irq_flags);
 
 		if (ret != xpSuccess)
@@ -62,8 +62,6 @@ xpc_process_connect(struct xpc_channel *
 	if (!(ch->flags & XPC_C_ROPENREPLY))
 		return;
 
-	DBUG_ON(ch->remote_msgqueue_pa == 0);
-
 	ch->flags = (XPC_C_CONNECTED | XPC_C_SETUP);	/* clear all else */
 
 	dev_info(xpc_chan, "channel %d to partition %d connected\n",
@@ -134,13 +132,23 @@ xpc_process_disconnect(struct xpc_channe
 		spin_lock_irqsave(&ch->lock, *irq_flags);
 	}
 
+	DBUG_ON(atomic_read(&ch->n_to_notify) != 0);
+
 	/* it's now safe to free the channel's message queues */
-	xpc_free_msgqueues(ch);
+	xpc_teardown_msg_structures(ch);
+
+	ch->func = NULL;
+	ch->key = NULL;
+	ch->msg_size = 0;
+	ch->local_nentries = 0;
+	ch->remote_nentries = 0;
+	ch->kthreads_assigned_limit = 0;
+	ch->kthreads_idle_limit = 0;
 
 	/*
 	 * Mark the channel disconnected and clear all other flags, including
-	 * XPC_C_SETUP (because of call to xpc_free_msgqueues()) but not
-	 * including XPC_C_WDISCONNECT (if it was set).
+	 * XPC_C_SETUP (because of call to xpc_teardown_msg_structures()) but
+	 * not including XPC_C_WDISCONNECT (if it was set).
 	 */
 	ch->flags = (XPC_C_DISCONNECTED | (ch->flags & XPC_C_WDISCONNECT));
 
@@ -395,7 +403,7 @@ again:
 		DBUG_ON(args->remote_nentries == 0);
 
 		ch->flags |= XPC_C_ROPENREPLY;
-		ch->remote_msgqueue_pa = args->local_msgqueue_pa;
+		xpc_save_remote_msgqueue_pa(ch, args->local_msgqueue_pa);
 
 		if (args->local_nentries < ch->remote_nentries) {
 			dev_dbg(xpc_chan, "XPC_CHCTL_OPENREPLY: new "
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-setup-the-activate-gru-message-queue drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-setup-the-activate-gru-message-queue
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -141,8 +141,9 @@ static struct ctl_table_header *xpc_sysc
 /* non-zero if any remote partition disengage was timed out */
 int xpc_disengage_timedout;
 
-/* #of activate IRQs received */
-atomic_t xpc_activate_IRQ_rcvd = ATOMIC_INIT(0);
+/* #of activate IRQs received and not yet processed */
+int xpc_activate_IRQ_rcvd;
+DEFINE_SPINLOCK(xpc_activate_IRQ_rcvd_lock);
 
 /* IRQ handler notifies this wait queue on receipt of an IRQ */
 DECLARE_WAIT_QUEUE_HEAD(xpc_activate_IRQ_wq);
@@ -169,10 +170,11 @@ static struct notifier_block xpc_die_not
 	.notifier_call = xpc_system_die,
 };
 
+int (*xpc_setup_partitions_sn) (void);
 enum xp_retval (*xpc_get_partition_rsvd_page_pa) (void *buf, u64 *cookie,
 						  unsigned long *rp_pa,
 						  size_t *len);
-enum xp_retval (*xpc_rsvd_page_init) (struct xpc_rsvd_page *rp);
+int (*xpc_setup_rsvd_page_sn) (struct xpc_rsvd_page *rp);
 void (*xpc_heartbeat_init) (void);
 void (*xpc_heartbeat_exit) (void);
 void (*xpc_increment_heartbeat) (void);
@@ -183,8 +185,8 @@ enum xp_retval (*xpc_get_remote_heartbea
 enum xp_retval (*xpc_make_first_contact) (struct xpc_partition *part);
 void (*xpc_notify_senders_of_disconnect) (struct xpc_channel *ch);
 u64 (*xpc_get_chctl_all_flags) (struct xpc_partition *part);
-enum xp_retval (*xpc_allocate_msgqueues) (struct xpc_channel *ch);
-void (*xpc_free_msgqueues) (struct xpc_channel *ch);
+enum xp_retval (*xpc_setup_msg_structures) (struct xpc_channel *ch);
+void (*xpc_teardown_msg_structures) (struct xpc_channel *ch);
 void (*xpc_process_msg_chctl_flags) (struct xpc_partition *part, int ch_number);
 int (*xpc_n_of_deliverable_msgs) (struct xpc_channel *ch);
 struct xpc_msg *(*xpc_get_deliverable_msg) (struct xpc_channel *ch);
@@ -196,9 +198,9 @@ void (*xpc_request_partition_reactivatio
 void (*xpc_request_partition_deactivation) (struct xpc_partition *part);
 void (*xpc_cancel_partition_deactivation_request) (struct xpc_partition *part);
 
-void (*xpc_process_activate_IRQ_rcvd) (int n_IRQs_expected);
-enum xp_retval (*xpc_setup_infrastructure) (struct xpc_partition *part);
-void (*xpc_teardown_infrastructure) (struct xpc_partition *part);
+void (*xpc_process_activate_IRQ_rcvd) (void);
+enum xp_retval (*xpc_setup_ch_structures_sn) (struct xpc_partition *part);
+void (*xpc_teardown_ch_structures_sn) (struct xpc_partition *part);
 
 void (*xpc_indicate_partition_engaged) (struct xpc_partition *part);
 int (*xpc_partition_engaged) (short partid);
@@ -215,6 +217,9 @@ void (*xpc_send_chctl_openrequest) (stru
 void (*xpc_send_chctl_openreply) (struct xpc_channel *ch,
 				  unsigned long *irq_flags);
 
+void (*xpc_save_remote_msgqueue_pa) (struct xpc_channel *ch,
+				     unsigned long msgqueue_pa);
+
 enum xp_retval (*xpc_send_msg) (struct xpc_channel *ch, u32 flags,
 				void *payload, u16 payload_size, u8 notify_type,
 				xpc_notify_func func, void *key);
@@ -308,8 +313,6 @@ xpc_check_remote_hb(void)
 static int
 xpc_hb_checker(void *ignore)
 {
-	int last_IRQ_count = 0;
-	int new_IRQ_count;
 	int force_IRQ = 0;
 
 	/* this thread was marked active by xpc_hb_init() */
@@ -325,43 +328,37 @@ xpc_hb_checker(void *ignore)
 		dev_dbg(xpc_part, "woke up with %d ticks rem; %d IRQs have "
 			"been received\n",
 			(int)(xpc_hb_check_timeout - jiffies),
-			atomic_read(&xpc_activate_IRQ_rcvd) - last_IRQ_count);
+			xpc_activate_IRQ_rcvd);
 
 		/* checking of remote heartbeats is skewed by IRQ handling */
 		if (time_is_before_eq_jiffies(xpc_hb_check_timeout)) {
+			xpc_hb_check_timeout = jiffies +
+			    (xpc_hb_check_interval * HZ);
+
 			dev_dbg(xpc_part, "checking remote heartbeats\n");
 			xpc_check_remote_hb();
 
 			/*
-			 * We need to periodically recheck to ensure no
-			 * IRQ/amo pairs have been missed.  That check
-			 * must always reset xpc_hb_check_timeout.
+			 * On sn2 we need to periodically recheck to ensure no
+			 * IRQ/amo pairs have been missed.
 			 */
-			force_IRQ = 1;
+			if (is_shub())
+				force_IRQ = 1;
 		}
 
 		/* check for outstanding IRQs */
-		new_IRQ_count = atomic_read(&xpc_activate_IRQ_rcvd);
-		if (last_IRQ_count < new_IRQ_count || force_IRQ != 0) {
+		if (xpc_activate_IRQ_rcvd > 0 || force_IRQ != 0) {
 			force_IRQ = 0;
-
-			dev_dbg(xpc_part, "found an IRQ to process; will be "
-				"resetting xpc_hb_check_timeout\n");
-
-			xpc_process_activate_IRQ_rcvd(new_IRQ_count -
-						      last_IRQ_count);
-			last_IRQ_count = new_IRQ_count;
-
-			xpc_hb_check_timeout = jiffies +
-			    (xpc_hb_check_interval * HZ);
+			dev_dbg(xpc_part, "processing activate IRQs "
+				"received\n");
+			xpc_process_activate_IRQ_rcvd();
 		}
 
 		/* wait for IRQ or timeout */
 		(void)wait_event_interruptible(xpc_activate_IRQ_wq,
-					       (last_IRQ_count < atomic_read(
-						&xpc_activate_IRQ_rcvd)
-						|| time_is_before_eq_jiffies(
+					       (time_is_before_eq_jiffies(
 						xpc_hb_check_timeout) ||
+						xpc_activate_IRQ_rcvd > 0 ||
 						xpc_exiting));
 	}
 
@@ -437,6 +434,153 @@ xpc_channel_mgr(struct xpc_partition *pa
 }
 
 /*
+ * Guarantee that the kzalloc'd memory is cacheline aligned.
+ */
+void *
+xpc_kzalloc_cacheline_aligned(size_t size, gfp_t flags, void **base)
+{
+	/* see if kzalloc will give us cachline aligned memory by default */
+	*base = kzalloc(size, flags);
+	if (*base == NULL)
+		return NULL;
+
+	if ((u64)*base == L1_CACHE_ALIGN((u64)*base))
+		return *base;
+
+	kfree(*base);
+
+	/* nope, we'll have to do it ourselves */
+	*base = kzalloc(size + L1_CACHE_BYTES, flags);
+	if (*base == NULL)
+		return NULL;
+
+	return (void *)L1_CACHE_ALIGN((u64)*base);
+}
+
+/*
+ * Setup the channel structures necessary to support XPartition Communication
+ * between the specified remote partition and the local one.
+ */
+static enum xp_retval
+xpc_setup_ch_structures(struct xpc_partition *part)
+{
+	enum xp_retval ret;
+	int ch_number;
+	struct xpc_channel *ch;
+	short partid = XPC_PARTID(part);
+
+	/*
+	 * Allocate all of the channel structures as a contiguous chunk of
+	 * memory.
+	 */
+	DBUG_ON(part->channels != NULL);
+	part->channels = kzalloc(sizeof(struct xpc_channel) * XPC_MAX_NCHANNELS,
+				 GFP_KERNEL);
+	if (part->channels == NULL) {
+		dev_err(xpc_chan, "can't get memory for channels\n");
+		return xpNoMemory;
+	}
+
+	/* allocate the remote open and close args */
+
+	part->remote_openclose_args =
+	    xpc_kzalloc_cacheline_aligned(XPC_OPENCLOSE_ARGS_SIZE,
+					  GFP_KERNEL, &part->
+					  remote_openclose_args_base);
+	if (part->remote_openclose_args == NULL) {
+		dev_err(xpc_chan, "can't get memory for remote connect args\n");
+		ret = xpNoMemory;
+		goto out_1;
+	}
+
+	part->chctl.all_flags = 0;
+	spin_lock_init(&part->chctl_lock);
+
+	atomic_set(&part->channel_mgr_requests, 1);
+	init_waitqueue_head(&part->channel_mgr_wq);
+
+	part->nchannels = XPC_MAX_NCHANNELS;
+
+	atomic_set(&part->nchannels_active, 0);
+	atomic_set(&part->nchannels_engaged, 0);
+
+	for (ch_number = 0; ch_number < part->nchannels; ch_number++) {
+		ch = &part->channels[ch_number];
+
+		ch->partid = partid;
+		ch->number = ch_number;
+		ch->flags = XPC_C_DISCONNECTED;
+
+		atomic_set(&ch->kthreads_assigned, 0);
+		atomic_set(&ch->kthreads_idle, 0);
+		atomic_set(&ch->kthreads_active, 0);
+
+		atomic_set(&ch->references, 0);
+		atomic_set(&ch->n_to_notify, 0);
+
+		spin_lock_init(&ch->lock);
+		init_completion(&ch->wdisconnect_wait);
+
+		atomic_set(&ch->n_on_msg_allocate_wq, 0);
+		init_waitqueue_head(&ch->msg_allocate_wq);
+		init_waitqueue_head(&ch->idle_wq);
+	}
+
+	ret = xpc_setup_ch_structures_sn(part);
+	if (ret != xpSuccess)
+		goto out_2;
+
+	/*
+	 * With the setting of the partition setup_state to XPC_P_SS_SETUP,
+	 * we're declaring that this partition is ready to go.
+	 */
+	part->setup_state = XPC_P_SS_SETUP;
+
+	return xpSuccess;
+
+	/* setup of ch structures failed */
+out_2:
+	kfree(part->remote_openclose_args_base);
+	part->remote_openclose_args = NULL;
+out_1:
+	kfree(part->channels);
+	part->channels = NULL;
+	return ret;
+}
+
+/*
+ * Teardown the channel structures necessary to support XPartition Communication
+ * between the specified remote partition and the local one.
+ */
+static void
+xpc_teardown_ch_structures(struct xpc_partition *part)
+{
+	DBUG_ON(atomic_read(&part->nchannels_engaged) != 0);
+	DBUG_ON(atomic_read(&part->nchannels_active) != 0);
+
+	/*
+	 * Make this partition inaccessible to local processes by marking it
+	 * as no longer setup. Then wait before proceeding with the teardown
+	 * until all existing references cease.
+	 */
+	DBUG_ON(part->setup_state != XPC_P_SS_SETUP);
+	part->setup_state = XPC_P_SS_WTEARDOWN;
+
+	wait_event(part->teardown_wq, (atomic_read(&part->references) == 0));
+
+	/* now we can begin tearing down the infrastructure */
+
+	xpc_teardown_ch_structures_sn(part);
+
+	kfree(part->remote_openclose_args_base);
+	part->remote_openclose_args = NULL;
+	kfree(part->channels);
+	part->channels = NULL;
+
+	part->setup_state = XPC_P_SS_TORNDOWN;
+}
+
+/*
  * When XPC HB determines that a partition has come up, it will create a new
  * kthread and that kthread will call this function to attempt to set up the
  * basic infrastructure used for Cross Partition Communication with the newly
@@ -476,7 +620,7 @@ xpc_activating(void *__partid)
 
 	xpc_allow_hb(partid);
 
-	if (xpc_setup_infrastructure(part) == xpSuccess) {
+	if (xpc_setup_ch_structures(part) == xpSuccess) {
 		(void)xpc_part_ref(part);	/* this will always succeed */
 
 		if (xpc_make_first_contact(part) == xpSuccess) {
@@ -486,7 +630,7 @@ xpc_activating(void *__partid)
 		}
 
 		xpc_part_deref(part);
-		xpc_teardown_infrastructure(part);
+		xpc_teardown_ch_structures(part);
 	}
 
 	xpc_disallow_hb(partid);
@@ -806,6 +950,56 @@ xpc_disconnect_wait(int ch_number)
 	}
 }
 
+static int
+xpc_setup_partitions(void)
+{
+	short partid;
+	struct xpc_partition *part;
+
+	xpc_partitions = kzalloc(sizeof(struct xpc_partition) *
+				 xp_max_npartitions, GFP_KERNEL);
+	if (xpc_partitions == NULL) {
+		dev_err(xpc_part, "can't get memory for partition structure\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * The first few fields of each entry of xpc_partitions[] need to
+	 * be initialized now so that calls to xpc_connect() and
+	 * xpc_disconnect() can be made prior to the activation of any remote
+	 * partition. NOTE THAT NONE OF THE OTHER FIELDS BELONGING TO THESE
+	 * ENTRIES ARE MEANINGFUL UNTIL AFTER AN ENTRY'S CORRESPONDING
+	 * PARTITION HAS BEEN ACTIVATED.
+	 */
+	for (partid = 0; partid < xp_max_npartitions; partid++) {
+		part = &xpc_partitions[partid];
+
+		DBUG_ON((u64)part != L1_CACHE_ALIGN((u64)part));
+
+		part->activate_IRQ_rcvd = 0;
+		spin_lock_init(&part->act_lock);
+		part->act_state = XPC_P_AS_INACTIVE;
+		XPC_SET_REASON(part, 0, 0);
+
+		init_timer(&part->disengage_timer);
+		part->disengage_timer.function =
+		    xpc_timeout_partition_disengage;
+		part->disengage_timer.data = (unsigned long)part;
+
+		part->setup_state = XPC_P_SS_UNSET;
+		init_waitqueue_head(&part->teardown_wq);
+		atomic_set(&part->references, 0);
+	}
+
+	return xpc_setup_partitions_sn();
+}
+
+static void
+xpc_teardown_partitions(void)
+{
+	kfree(xpc_partitions);
+}
+
 static void
 xpc_do_exit(enum xp_retval reason)
 {
@@ -892,8 +1086,7 @@ xpc_do_exit(enum xp_retval reason)
 	DBUG_ON(xpc_any_partition_engaged());
 	DBUG_ON(xpc_any_hbs_allowed() != 0);
 
-	/* a zero timestamp indicates our rsvd page is not initialized */
-	xpc_rsvd_page->ts_jiffies = 0;
+	xpc_teardown_rsvd_page();
 
 	if (reason == xpUnloading) {
 		(void)unregister_die_notifier(&xpc_die_notifier);
@@ -906,7 +1099,7 @@ xpc_do_exit(enum xp_retval reason)
 	if (xpc_sysctl)
 		unregister_sysctl_table(xpc_sysctl);
 
-	kfree(xpc_partitions);
+	xpc_teardown_partitions();
 
 	if (is_shub())
 		xpc_exit_sn2();
@@ -1062,8 +1255,6 @@ int __init
 xpc_init(void)
 {
 	int ret;
-	short partid;
-	struct xpc_partition *part;
 	struct task_struct *kthread;
 
 	snprintf(xpc_part->bus_id, BUS_ID_SIZE, "part");
@@ -1076,56 +1267,29 @@ xpc_init(void)
 		 * further to only support exactly 64 partitions on this
 		 * architecture, no less.
 		 */
-		if (xp_max_npartitions != 64)
-			return -EINVAL;
-
-		ret = xpc_init_sn2();
-		if (ret != 0)
-			return ret;
+		if (xp_max_npartitions != 64) {
+			dev_err(xpc_part, "max #of partitions not set to 64\n");
+			ret = -EINVAL;
+		} else {
+			ret = xpc_init_sn2();
+		}
 
 	} else if (is_uv()) {
-		xpc_init_uv();
+		ret = xpc_init_uv();
 
 	} else {
-		return -ENODEV;
+		ret = -ENODEV;
 	}
 
-	xpc_partitions = kzalloc(sizeof(struct xpc_partition) *
-				 xp_max_npartitions, GFP_KERNEL);
-	if (xpc_partitions == NULL) {
+	if (ret != 0)
+		return ret;
+
+	ret = xpc_setup_partitions();
+	if (ret != 0) {
 		dev_err(xpc_part, "can't get memory for partition structure\n");
-		ret = -ENOMEM;
 		goto out_1;
 	}
 
-	/*
-	 * The first few fields of each entry of xpc_partitions[] need to
-	 * be initialized now so that calls to xpc_connect() and
-	 * xpc_disconnect() can be made prior to the activation of any remote
-	 * partition. NOTE THAT NONE OF THE OTHER FIELDS BELONGING TO THESE
-	 * ENTRIES ARE MEANINGFUL UNTIL AFTER AN ENTRY'S CORRESPONDING
-	 * PARTITION HAS BEEN ACTIVATED.
-	 */
-	for (partid = 0; partid < xp_max_npartitions; partid++) {
-		part = &xpc_partitions[partid];
-
-		DBUG_ON((u64)part != L1_CACHE_ALIGN((u64)part));
-
-		part->activate_IRQ_rcvd = 0;
-		spin_lock_init(&part->act_lock);
-		part->act_state = XPC_P_AS_INACTIVE;
-		XPC_SET_REASON(part, 0, 0);
-
-		init_timer(&part->disengage_timer);
-		part->disengage_timer.function =
-		    xpc_timeout_partition_disengage;
-		part->disengage_timer.data = (unsigned long)part;
-
-		part->setup_state = XPC_P_SS_UNSET;
-		init_waitqueue_head(&part->teardown_wq);
-		atomic_set(&part->references, 0);
-	}
-
 	xpc_sysctl = register_sysctl_table(xpc_sys_dir);
 
 	/*
@@ -1133,10 +1297,9 @@ xpc_init(void)
 	 * other partitions to discover we are alive and establish initial
 	 * communications.
 	 */
-	xpc_rsvd_page = xpc_setup_rsvd_page();
-	if (xpc_rsvd_page == NULL) {
+	ret = xpc_setup_rsvd_page();
+	if (ret != 0) {
 		dev_err(xpc_part, "can't setup our reserved page\n");
-		ret = -EBUSY;
 		goto out_2;
 	}
 
@@ -1187,15 +1350,15 @@ xpc_init(void)
 
 	/* initialization was not successful */
 out_3:
-	/* a zero timestamp indicates our rsvd page is not initialized */
-	xpc_rsvd_page->ts_jiffies = 0;
+	xpc_teardown_rsvd_page();
 
 	(void)unregister_die_notifier(&xpc_die_notifier);
 	(void)unregister_reboot_notifier(&xpc_reboot_notifier);
 out_2:
 	if (xpc_sysctl)
 		unregister_sysctl_table(xpc_sysctl);
-	kfree(xpc_partitions);
+
+	xpc_teardown_partitions();
 out_1:
 	if (is_shub())
 		xpc_exit_sn2();
diff -puN drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-setup-the-activate-gru-message-queue drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-setup-the-activate-gru-message-queue
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -73,6 +73,12 @@ xpc_get_rsvd_page_pa(int nasid)
 
 	while (1) {
 
+		/* !!! rp_pa will need to be _gpa on UV.
+		 * ??? So do we save it into the architecture specific parts
+		 * ??? of the xpc_partition structure? Do we rename this
+		 * ??? function or have two versions? Rename rp_pa for UV to
+		 * ??? rp_gpa?
+		 */
 		ret = xpc_get_partition_rsvd_page_pa(buf, &cookie, &rp_pa,
 						     &len);
 
@@ -118,9 +124,10 @@ xpc_get_rsvd_page_pa(int nasid)
  * other partitions to discover we are alive and establish initial
  * communications.
  */
-struct xpc_rsvd_page *
+int
 xpc_setup_rsvd_page(void)
 {
+	int ret;
 	struct xpc_rsvd_page *rp;
 	unsigned long rp_pa;
 	unsigned long new_ts_jiffies;
@@ -132,7 +139,7 @@ xpc_setup_rsvd_page(void)
 	preempt_enable();
 	if (rp_pa == 0) {
 		dev_err(xpc_part, "SAL failed to locate the reserved page\n");
-		return NULL;
+		return -ESRCH;
 	}
 	rp = (struct xpc_rsvd_page *)__va(rp_pa);
 
@@ -146,7 +153,7 @@ xpc_setup_rsvd_page(void)
 		dev_err(xpc_part, "the reserved page's partid of %d is outside "
 			"supported range (< 0 || >= %d)\n", rp->SAL_partid,
 			xp_max_npartitions);
-		return NULL;
+		return -EINVAL;
 	}
 
 	rp->version = XPC_RP_VERSION;
@@ -165,8 +172,9 @@ xpc_setup_rsvd_page(void)
 	xpc_part_nasids = XPC_RP_PART_NASIDS(rp);
 	xpc_mach_nasids = XPC_RP_MACH_NASIDS(rp);
 
-	if (xpc_rsvd_page_init(rp) != xpSuccess)
-		return NULL;
+	ret = xpc_setup_rsvd_page_sn(rp);
+	if (ret != 0)
+		return ret;
 
 	/*
 	 * Set timestamp of when reserved page was setup by XPC.
@@ -178,7 +186,15 @@ xpc_setup_rsvd_page(void)
 		new_ts_jiffies++;
 	rp->ts_jiffies = new_ts_jiffies;
 
-	return rp;
+	xpc_rsvd_page = rp;
+	return 0;
+}
+
+void
+xpc_teardown_rsvd_page(void)
+{
+	/* a zero timestamp indicates our rsvd page is not initialized */
+	xpc_rsvd_page->ts_jiffies = 0;
 }
 
 /*
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-setup-the-activate-gru-message-queue drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-setup-the-activate-gru-message-queue
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -53,12 +53,19 @@
  * Buffer used to store a local copy of portions of a remote partition's
  * reserved page (either its header and part_nasids mask, or its vars).
  */
-static char *xpc_remote_copy_buffer_sn2;
 static void *xpc_remote_copy_buffer_base_sn2;
+static char *xpc_remote_copy_buffer_sn2;
 
 static struct xpc_vars_sn2 *xpc_vars_sn2;
 static struct xpc_vars_part_sn2 *xpc_vars_part_sn2;
 
+static int
+xpc_setup_partitions_sn_sn2(void)
+{
+	/* nothing needs to be done */
+	return 0;
+}
+
 /* SH_IPI_ACCESS shub register value on startup */
 static u64 xpc_sh1_IPI_access_sn2;
 static u64 xpc_sh2_IPI_access0_sn2;
@@ -198,7 +205,12 @@ xpc_init_IRQ_amo_sn2(int index)
 static irqreturn_t
 xpc_handle_activate_IRQ_sn2(int irq, void *dev_id)
 {
-	atomic_inc(&xpc_activate_IRQ_rcvd);
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+	xpc_activate_IRQ_rcvd++;
+	spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+
 	wake_up_interruptible(&xpc_activate_IRQ_wq);
 	return IRQ_HANDLED;
 }
@@ -222,6 +234,7 @@ xpc_send_activate_IRQ_sn2(unsigned long 
 static void
 xpc_send_local_activate_IRQ_sn2(int from_nasid)
 {
+	unsigned long irq_flags;
 	struct amo *amos = (struct amo *)__va(xpc_vars_sn2->amos_page_pa +
 					      (XPC_ACTIVATE_IRQ_AMOS_SN2 *
 					      sizeof(struct amo)));
@@ -230,7 +243,10 @@ xpc_send_local_activate_IRQ_sn2(int from
 	FETCHOP_STORE_OP(TO_AMO((u64)&amos[BIT_WORD(from_nasid / 2)].variable),
 			 FETCHOP_OR, BIT_MASK(from_nasid / 2));
 
-	atomic_inc(&xpc_activate_IRQ_rcvd);
+	spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+	xpc_activate_IRQ_rcvd++;
+	spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+
 	wake_up_interruptible(&xpc_activate_IRQ_wq);
 }
 
@@ -375,7 +391,7 @@ static void
 xpc_send_chctl_closerequest_sn2(struct xpc_channel *ch,
 				unsigned long *irq_flags)
 {
-	struct xpc_openclose_args *args = ch->local_openclose_args;
+	struct xpc_openclose_args *args = ch->sn.sn2.local_openclose_args;
 
 	args->reason = ch->reason;
 	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_CLOSEREQUEST, irq_flags);
@@ -390,7 +406,7 @@ xpc_send_chctl_closereply_sn2(struct xpc
 static void
 xpc_send_chctl_openrequest_sn2(struct xpc_channel *ch, unsigned long *irq_flags)
 {
-	struct xpc_openclose_args *args = ch->local_openclose_args;
+	struct xpc_openclose_args *args = ch->sn.sn2.local_openclose_args;
 
 	args->msg_size = ch->msg_size;
 	args->local_nentries = ch->local_nentries;
@@ -400,11 +416,11 @@ xpc_send_chctl_openrequest_sn2(struct xp
 static void
 xpc_send_chctl_openreply_sn2(struct xpc_channel *ch, unsigned long *irq_flags)
 {
-	struct xpc_openclose_args *args = ch->local_openclose_args;
+	struct xpc_openclose_args *args = ch->sn.sn2.local_openclose_args;
 
 	args->remote_nentries = ch->remote_nentries;
 	args->local_nentries = ch->local_nentries;
-	args->local_msgqueue_pa = xp_pa(ch->local_msgqueue);
+	args->local_msgqueue_pa = xp_pa(ch->sn.sn2.local_msgqueue);
 	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_OPENREPLY, irq_flags);
 }
 
@@ -420,6 +436,13 @@ xpc_send_chctl_local_msgrequest_sn2(stru
 	XPC_SEND_LOCAL_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_MSGREQUEST);
 }
 
+static void
+xpc_save_remote_msgqueue_pa_sn2(struct xpc_channel *ch,
+				unsigned long msgqueue_pa)
+{
+	ch->sn.sn2.remote_msgqueue_pa = msgqueue_pa;
+}
+
 /*
  * This next set of functions are used to keep track of when a partition is
  * potentially engaged in accessing memory belonging to another partition.
@@ -489,6 +512,17 @@ xpc_indicate_partition_disengaged_sn2(st
 				  part_sn2->activate_IRQ_phys_cpuid);
 }
 
+static void
+xpc_assume_partition_disengaged_sn2(short partid)
+{
+	struct amo *amo = xpc_vars_sn2->amos_page +
+			  XPC_ENGAGED_PARTITIONS_AMO_SN2;
+
+	/* clear bit(s) based on partid mask in our partition's amo */
+	FETCHOP_STORE_OP(TO_AMO((u64)&amo->variable), FETCHOP_AND,
+			 ~BIT(partid));
+}
+
 static int
 xpc_partition_engaged_sn2(short partid)
 {
@@ -510,17 +544,6 @@ xpc_any_partition_engaged_sn2(void)
 	return FETCHOP_LOAD_OP(TO_AMO((u64)&amo->variable), FETCHOP_LOAD) != 0;
 }
 
-static void
-xpc_assume_partition_disengaged_sn2(short partid)
-{
-	struct amo *amo = xpc_vars_sn2->amos_page +
-			  XPC_ENGAGED_PARTITIONS_AMO_SN2;
-
-	/* clear bit(s) based on partid mask in our partition's amo */
-	FETCHOP_STORE_OP(TO_AMO((u64)&amo->variable), FETCHOP_AND,
-			 ~BIT(partid));
-}
-
 /* original protection values for each node */
 static u64 xpc_prot_vec_sn2[MAX_NUMNODES];
 
@@ -595,8 +618,8 @@ xpc_get_partition_rsvd_page_pa_sn2(void 
 }
 
 
-static enum xp_retval
-xpc_rsvd_page_init_sn2(struct xpc_rsvd_page *rp)
+static int
+xpc_setup_rsvd_page_sn_sn2(struct xpc_rsvd_page *rp)
 {
 	struct amo *amos_page;
 	int i;
@@ -627,7 +650,7 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 		amos_page = (struct amo *)TO_AMO(uncached_alloc_page(0, 1));
 		if (amos_page == NULL) {
 			dev_err(xpc_part, "can't allocate page of amos\n");
-			return xpNoMemory;
+			return -ENOMEM;
 		}
 
 		/*
@@ -639,7 +662,7 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 			dev_err(xpc_part, "can't allow amo operations\n");
 			uncached_free_page(__IA64_UNCACHED_OFFSET |
 					   TO_PHYS((u64)amos_page), 1);
-			return ret;
+			return -EPERM;
 		}
 	}
 
@@ -665,7 +688,7 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 	(void)xpc_init_IRQ_amo_sn2(XPC_ENGAGED_PARTITIONS_AMO_SN2);
 	(void)xpc_init_IRQ_amo_sn2(XPC_DEACTIVATE_REQUEST_AMO_SN2);
 
-	return xpSuccess;
+	return 0;
 }
 
 static void
@@ -1082,10 +1105,19 @@ xpc_identify_activate_IRQ_sender_sn2(voi
 }
 
 static void
-xpc_process_activate_IRQ_rcvd_sn2(int n_IRQs_expected)
+xpc_process_activate_IRQ_rcvd_sn2(void)
 {
+	unsigned long irq_flags;
+	int n_IRQs_expected;
 	int n_IRQs_detected;
 
+	DBUG_ON(xpc_activate_IRQ_rcvd == 0);
+
+	spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+	n_IRQs_expected = xpc_activate_IRQ_rcvd;
+	xpc_activate_IRQ_rcvd = 0;
+	spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+
 	n_IRQs_detected = xpc_identify_activate_IRQ_sender_sn2();
 	if (n_IRQs_detected < n_IRQs_expected) {
 		/* retry once to help avoid missing amo */
@@ -1094,116 +1126,63 @@ xpc_process_activate_IRQ_rcvd_sn2(int n_
 }
 
 /*
- * Guarantee that the kzalloc'd memory is cacheline aligned.
- */
-static void *
-xpc_kzalloc_cacheline_aligned_sn2(size_t size, gfp_t flags, void **base)
-{
-	/* see if kzalloc will give us cachline aligned memory by default */
-	*base = kzalloc(size, flags);
-	if (*base == NULL)
-		return NULL;
-
-	if ((u64)*base == L1_CACHE_ALIGN((u64)*base))
-		return *base;
-
-	kfree(*base);
-
-	/* nope, we'll have to do it ourselves */
-	*base = kzalloc(size + L1_CACHE_BYTES, flags);
-	if (*base == NULL)
-		return NULL;
-
-	return (void *)L1_CACHE_ALIGN((u64)*base);
-}
-
-/*
- * Setup the infrastructure necessary to support XPartition Communication
- * between the specified remote partition and the local one.
+ * Setup the channel structures that are sn2 specific.
  */
 static enum xp_retval
-xpc_setup_infrastructure_sn2(struct xpc_partition *part)
+xpc_setup_ch_structures_sn_sn2(struct xpc_partition *part)
 {
 	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
+	struct xpc_channel_sn2 *ch_sn2;
 	enum xp_retval retval;
 	int ret;
 	int cpuid;
 	int ch_number;
-	struct xpc_channel *ch;
 	struct timer_list *timer;
 	short partid = XPC_PARTID(part);
 
-	/*
-	 * Allocate all of the channel structures as a contiguous chunk of
-	 * memory.
-	 */
-	DBUG_ON(part->channels != NULL);
-	part->channels = kzalloc(sizeof(struct xpc_channel) * XPC_MAX_NCHANNELS,
-				 GFP_KERNEL);
-	if (part->channels == NULL) {
-		dev_err(xpc_chan, "can't get memory for channels\n");
-		return xpNoMemory;
-	}
-
 	/* allocate all the required GET/PUT values */
 
 	part_sn2->local_GPs =
-	    xpc_kzalloc_cacheline_aligned_sn2(XPC_GP_SIZE, GFP_KERNEL,
-					      &part_sn2->local_GPs_base);
+	    xpc_kzalloc_cacheline_aligned(XPC_GP_SIZE, GFP_KERNEL,
+					  &part_sn2->local_GPs_base);
 	if (part_sn2->local_GPs == NULL) {
 		dev_err(xpc_chan, "can't get memory for local get/put "
 			"values\n");
-		retval = xpNoMemory;
-		goto out_1;
+		return xpNoMemory;
 	}
 
 	part_sn2->remote_GPs =
-	    xpc_kzalloc_cacheline_aligned_sn2(XPC_GP_SIZE, GFP_KERNEL,
-					      &part_sn2->remote_GPs_base);
+	    xpc_kzalloc_cacheline_aligned(XPC_GP_SIZE, GFP_KERNEL,
+					  &part_sn2->remote_GPs_base);
 	if (part_sn2->remote_GPs == NULL) {
 		dev_err(xpc_chan, "can't get memory for remote get/put "
 			"values\n");
 		retval = xpNoMemory;
-		goto out_2;
+		goto out_1;
 	}
 
 	part_sn2->remote_GPs_pa = 0;
 
 	/* allocate all the required open and close args */
 
-	part->local_openclose_args =
-	    xpc_kzalloc_cacheline_aligned_sn2(XPC_OPENCLOSE_ARGS_SIZE,
-					      GFP_KERNEL,
-					      &part->local_openclose_args_base);
-	if (part->local_openclose_args == NULL) {
+	part_sn2->local_openclose_args =
+	    xpc_kzalloc_cacheline_aligned(XPC_OPENCLOSE_ARGS_SIZE,
+					  GFP_KERNEL, &part_sn2->
+					  local_openclose_args_base);
+	if (part_sn2->local_openclose_args == NULL) {
 		dev_err(xpc_chan, "can't get memory for local connect args\n");
 		retval = xpNoMemory;
-		goto out_3;
-	}
-
-	part->remote_openclose_args =
-	    xpc_kzalloc_cacheline_aligned_sn2(XPC_OPENCLOSE_ARGS_SIZE,
-					      GFP_KERNEL,
-					     &part->remote_openclose_args_base);
-	if (part->remote_openclose_args == NULL) {
-		dev_err(xpc_chan, "can't get memory for remote connect args\n");
-		retval = xpNoMemory;
-		goto out_4;
+		goto out_2;
 	}
 
 	part_sn2->remote_openclose_args_pa = 0;
 
 	part_sn2->local_chctl_amo_va = xpc_init_IRQ_amo_sn2(partid);
-	part->chctl.all_flags = 0;
-	spin_lock_init(&part->chctl_lock);
 
 	part_sn2->notify_IRQ_nasid = 0;
 	part_sn2->notify_IRQ_phys_cpuid = 0;
 	part_sn2->remote_chctl_amo_va = NULL;
 
-	atomic_set(&part->channel_mgr_requests, 1);
-	init_waitqueue_head(&part->channel_mgr_wq);
-
 	sprintf(part_sn2->notify_IRQ_owner, "xpc%02d", partid);
 	ret = request_irq(SGI_XPC_NOTIFY, xpc_handle_notify_IRQ_sn2,
 			  IRQF_SHARED, part_sn2->notify_IRQ_owner,
@@ -1212,7 +1191,7 @@ xpc_setup_infrastructure_sn2(struct xpc_
 		dev_err(xpc_chan, "can't register NOTIFY IRQ handler, "
 			"errno=%d\n", -ret);
 		retval = xpLackOfResources;
-		goto out_5;
+		goto out_3;
 	}
 
 	/* Setup a timer to check for dropped notify IRQs */
@@ -1224,45 +1203,17 @@ xpc_setup_infrastructure_sn2(struct xpc_
 	timer->expires = jiffies + XPC_DROPPED_NOTIFY_IRQ_WAIT_INTERVAL;
 	add_timer(timer);
 
-	part->nchannels = XPC_MAX_NCHANNELS;
-
-	atomic_set(&part->nchannels_active, 0);
-	atomic_set(&part->nchannels_engaged, 0);
-
 	for (ch_number = 0; ch_number < part->nchannels; ch_number++) {
-		ch = &part->channels[ch_number];
-
-		ch->partid = partid;
-		ch->number = ch_number;
-		ch->flags = XPC_C_DISCONNECTED;
-
-		ch->sn.sn2.local_GP = &part_sn2->local_GPs[ch_number];
-		ch->local_openclose_args =
-		    &part->local_openclose_args[ch_number];
-
-		atomic_set(&ch->kthreads_assigned, 0);
-		atomic_set(&ch->kthreads_idle, 0);
-		atomic_set(&ch->kthreads_active, 0);
+		ch_sn2 = &part->channels[ch_number].sn.sn2;
 
-		atomic_set(&ch->references, 0);
-		atomic_set(&ch->n_to_notify, 0);
+		ch_sn2->local_GP = &part_sn2->local_GPs[ch_number];
+		ch_sn2->local_openclose_args =
+		    &part_sn2->local_openclose_args[ch_number];
 
-		spin_lock_init(&ch->lock);
-		mutex_init(&ch->sn.sn2.msg_to_pull_mutex);
-		init_completion(&ch->wdisconnect_wait);
-
-		atomic_set(&ch->n_on_msg_allocate_wq, 0);
-		init_waitqueue_head(&ch->msg_allocate_wq);
-		init_waitqueue_head(&ch->idle_wq);
+		mutex_init(&ch_sn2->msg_to_pull_mutex);
 	}
 
 	/*
-	 * With the setting of the partition setup_state to XPC_P_SS_SETUP,
-	 * we're declaring that this partition is ready to go.
-	 */
-	part->setup_state = XPC_P_SS_SETUP;
-
-	/*
 	 * Setup the per partition specific variables required by the
 	 * remote partition to establish channel connections with us.
 	 *
@@ -1271,7 +1222,7 @@ xpc_setup_infrastructure_sn2(struct xpc_
 	 */
 	xpc_vars_part_sn2[partid].GPs_pa = xp_pa(part_sn2->local_GPs);
 	xpc_vars_part_sn2[partid].openclose_args_pa =
-	    xp_pa(part->local_openclose_args);
+	    xp_pa(part_sn2->local_openclose_args);
 	xpc_vars_part_sn2[partid].chctl_amo_pa =
 	    xp_pa(part_sn2->local_chctl_amo_va);
 	cpuid = raw_smp_processor_id();	/* any CPU in this partition will do */
@@ -1279,80 +1230,48 @@ xpc_setup_infrastructure_sn2(struct xpc_
 	xpc_vars_part_sn2[partid].notify_IRQ_phys_cpuid =
 	    cpu_physical_id(cpuid);
 	xpc_vars_part_sn2[partid].nchannels = part->nchannels;
-	xpc_vars_part_sn2[partid].magic = XPC_VP_MAGIC1;
+	xpc_vars_part_sn2[partid].magic = XPC_VP_MAGIC1_SN2;
 
 	return xpSuccess;
 
-	/* setup of infrastructure failed */
-out_5:
-	kfree(part->remote_openclose_args_base);
-	part->remote_openclose_args = NULL;
-out_4:
-	kfree(part->local_openclose_args_base);
-	part->local_openclose_args = NULL;
+	/* setup of ch structures failed */
 out_3:
+	kfree(part_sn2->local_openclose_args_base);
+	part_sn2->local_openclose_args = NULL;
+out_2:
 	kfree(part_sn2->remote_GPs_base);
 	part_sn2->remote_GPs = NULL;
-out_2:
+out_1:
 	kfree(part_sn2->local_GPs_base);
 	part_sn2->local_GPs = NULL;
-out_1:
-	kfree(part->channels);
-	part->channels = NULL;
 	return retval;
 }
 
 /*
- * Teardown the infrastructure necessary to support XPartition Communication
- * between the specified remote partition and the local one.
+ * Teardown the channel structures that are sn2 specific.
  */
 static void
-xpc_teardown_infrastructure_sn2(struct xpc_partition *part)
+xpc_teardown_ch_structures_sn_sn2(struct xpc_partition *part)
 {
 	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
 	short partid = XPC_PARTID(part);
 
 	/*
-	 * We start off by making this partition inaccessible to local
-	 * processes by marking it as no longer setup. Then we make it
-	 * inaccessible to remote processes by clearing the XPC per partition
-	 * specific variable's magic # (which indicates that these variables
-	 * are no longer valid) and by ignoring all XPC notify IRQs sent to
-	 * this partition.
+	 * Indicate that the variables specific to the remote partition are no
+	 * longer available for its use.
 	 */
-
-	DBUG_ON(atomic_read(&part->nchannels_engaged) != 0);
-	DBUG_ON(atomic_read(&part->nchannels_active) != 0);
-	DBUG_ON(part->setup_state != XPC_P_SS_SETUP);
-	part->setup_state = XPC_P_SS_WTEARDOWN;
-
 	xpc_vars_part_sn2[partid].magic = 0;
 
-	free_irq(SGI_XPC_NOTIFY, (void *)(u64)partid);
-
-	/*
-	 * Before proceeding with the teardown we have to wait until all
-	 * existing references cease.
-	 */
-	wait_event(part->teardown_wq, (atomic_read(&part->references) == 0));
-
-	/* now we can begin tearing down the infrastructure */
-
-	part->setup_state = XPC_P_SS_TORNDOWN;
-
 	/* in case we've still got outstanding timers registered... */
 	del_timer_sync(&part_sn2->dropped_notify_IRQ_timer);
+	free_irq(SGI_XPC_NOTIFY, (void *)(u64)partid);
 
-	kfree(part->remote_openclose_args_base);
-	part->remote_openclose_args = NULL;
-	kfree(part->local_openclose_args_base);
-	part->local_openclose_args = NULL;
+	kfree(part_sn2->local_openclose_args_base);
+	part_sn2->local_openclose_args = NULL;
 	kfree(part_sn2->remote_GPs_base);
 	part_sn2->remote_GPs = NULL;
 	kfree(part_sn2->local_GPs_base);
 	part_sn2->local_GPs = NULL;
-	kfree(part->channels);
-	part->channels = NULL;
 	part_sn2->local_chctl_amo_va = NULL;
 }
 
@@ -1429,8 +1348,8 @@ xpc_pull_remote_vars_part_sn2(struct xpc
 
 	/* see if they've been set up yet */
 
-	if (pulled_entry->magic != XPC_VP_MAGIC1 &&
-	    pulled_entry->magic != XPC_VP_MAGIC2) {
+	if (pulled_entry->magic != XPC_VP_MAGIC1_SN2 &&
+	    pulled_entry->magic != XPC_VP_MAGIC2_SN2) {
 
 		if (pulled_entry->magic != 0) {
 			dev_dbg(xpc_chan, "partition %d's XPC vars_part for "
@@ -1443,7 +1362,7 @@ xpc_pull_remote_vars_part_sn2(struct xpc
 		return xpRetry;
 	}
 
-	if (xpc_vars_part_sn2[partid].magic == XPC_VP_MAGIC1) {
+	if (xpc_vars_part_sn2[partid].magic == XPC_VP_MAGIC1_SN2) {
 
 		/* validate the variables */
 
@@ -1473,10 +1392,10 @@ xpc_pull_remote_vars_part_sn2(struct xpc
 
 		/* let the other side know that we've pulled their variables */
 
-		xpc_vars_part_sn2[partid].magic = XPC_VP_MAGIC2;
+		xpc_vars_part_sn2[partid].magic = XPC_VP_MAGIC2_SN2;
 	}
 
-	if (pulled_entry->magic == XPC_VP_MAGIC1)
+	if (pulled_entry->magic == XPC_VP_MAGIC1_SN2)
 		return xpRetry;
 
 	return xpSuccess;
@@ -1605,6 +1524,7 @@ xpc_get_chctl_all_flags_sn2(struct xpc_p
 static enum xp_retval
 xpc_allocate_local_msgqueue_sn2(struct xpc_channel *ch)
 {
+	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
 	unsigned long irq_flags;
 	int nentries;
 	size_t nbytes;
@@ -1612,17 +1532,17 @@ xpc_allocate_local_msgqueue_sn2(struct x
 	for (nentries = ch->local_nentries; nentries > 0; nentries--) {
 
 		nbytes = nentries * ch->msg_size;
-		ch->local_msgqueue =
-		    xpc_kzalloc_cacheline_aligned_sn2(nbytes, GFP_KERNEL,
-						      &ch->local_msgqueue_base);
-		if (ch->local_msgqueue == NULL)
+		ch_sn2->local_msgqueue =
+		    xpc_kzalloc_cacheline_aligned(nbytes, GFP_KERNEL,
+						  &ch_sn2->local_msgqueue_base);
+		if (ch_sn2->local_msgqueue == NULL)
 			continue;
 
 		nbytes = nentries * sizeof(struct xpc_notify);
-		ch->notify_queue = kzalloc(nbytes, GFP_KERNEL);
-		if (ch->notify_queue == NULL) {
-			kfree(ch->local_msgqueue_base);
-			ch->local_msgqueue = NULL;
+		ch_sn2->notify_queue = kzalloc(nbytes, GFP_KERNEL);
+		if (ch_sn2->notify_queue == NULL) {
+			kfree(ch_sn2->local_msgqueue_base);
+			ch_sn2->local_msgqueue = NULL;
 			continue;
 		}
 
@@ -1649,6 +1569,7 @@ xpc_allocate_local_msgqueue_sn2(struct x
 static enum xp_retval
 xpc_allocate_remote_msgqueue_sn2(struct xpc_channel *ch)
 {
+	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
 	unsigned long irq_flags;
 	int nentries;
 	size_t nbytes;
@@ -1658,10 +1579,10 @@ xpc_allocate_remote_msgqueue_sn2(struct 
 	for (nentries = ch->remote_nentries; nentries > 0; nentries--) {
 
 		nbytes = nentries * ch->msg_size;
-		ch->remote_msgqueue =
-		    xpc_kzalloc_cacheline_aligned_sn2(nbytes, GFP_KERNEL,
-						     &ch->remote_msgqueue_base);
-		if (ch->remote_msgqueue == NULL)
+		ch_sn2->remote_msgqueue =
+		    xpc_kzalloc_cacheline_aligned(nbytes, GFP_KERNEL, &ch_sn2->
+						  remote_msgqueue_base);
+		if (ch_sn2->remote_msgqueue == NULL)
 			continue;
 
 		spin_lock_irqsave(&ch->lock, irq_flags);
@@ -1687,8 +1608,9 @@ xpc_allocate_remote_msgqueue_sn2(struct 
  * Note: Assumes all of the channel sizes are filled in.
  */
 static enum xp_retval
-xpc_allocate_msgqueues_sn2(struct xpc_channel *ch)
+xpc_setup_msg_structures_sn2(struct xpc_channel *ch)
 {
+	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
 	enum xp_retval ret;
 
 	DBUG_ON(ch->flags & XPC_C_SETUP);
@@ -1698,10 +1620,10 @@ xpc_allocate_msgqueues_sn2(struct xpc_ch
 
 		ret = xpc_allocate_remote_msgqueue_sn2(ch);
 		if (ret != xpSuccess) {
-			kfree(ch->local_msgqueue_base);
-			ch->local_msgqueue = NULL;
-			kfree(ch->notify_queue);
-			ch->notify_queue = NULL;
+			kfree(ch_sn2->local_msgqueue_base);
+			ch_sn2->local_msgqueue = NULL;
+			kfree(ch_sn2->notify_queue);
+			ch_sn2->notify_queue = NULL;
 		}
 	}
 	return ret;
@@ -1715,21 +1637,13 @@ xpc_allocate_msgqueues_sn2(struct xpc_ch
  * they're cleared when XPC_C_DISCONNECTED is cleared.
  */
 static void
-xpc_free_msgqueues_sn2(struct xpc_channel *ch)
+xpc_teardown_msg_structures_sn2(struct xpc_channel *ch)
 {
 	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
 
 	DBUG_ON(!spin_is_locked(&ch->lock));
-	DBUG_ON(atomic_read(&ch->n_to_notify) != 0);
 
-	ch->remote_msgqueue_pa = 0;
-	ch->func = NULL;
-	ch->key = NULL;
-	ch->msg_size = 0;
-	ch->local_nentries = 0;
-	ch->remote_nentries = 0;
-	ch->kthreads_assigned_limit = 0;
-	ch->kthreads_idle_limit = 0;
+	ch_sn2->remote_msgqueue_pa = 0;
 
 	ch_sn2->local_GP->get = 0;
 	ch_sn2->local_GP->put = 0;
@@ -1745,12 +1659,12 @@ xpc_free_msgqueues_sn2(struct xpc_channe
 		dev_dbg(xpc_chan, "ch->flags=0x%x, partid=%d, channel=%d\n",
 			ch->flags, ch->partid, ch->number);
 
-		kfree(ch->local_msgqueue_base);
-		ch->local_msgqueue = NULL;
-		kfree(ch->remote_msgqueue_base);
-		ch->remote_msgqueue = NULL;
-		kfree(ch->notify_queue);
-		ch->notify_queue = NULL;
+		kfree(ch_sn2->local_msgqueue_base);
+		ch_sn2->local_msgqueue = NULL;
+		kfree(ch_sn2->remote_msgqueue_base);
+		ch_sn2->remote_msgqueue = NULL;
+		kfree(ch_sn2->notify_queue);
+		ch_sn2->notify_queue = NULL;
 	}
 }
 
@@ -1766,7 +1680,7 @@ xpc_notify_senders_sn2(struct xpc_channe
 
 	while (++get < put && atomic_read(&ch->n_to_notify) > 0) {
 
-		notify = &ch->notify_queue[get % ch->local_nentries];
+		notify = &ch->sn.sn2.notify_queue[get % ch->local_nentries];
 
 		/*
 		 * See if the notify entry indicates it was associated with
@@ -1818,7 +1732,7 @@ xpc_clear_local_msgqueue_flags_sn2(struc
 
 	get = ch_sn2->w_remote_GP.get;
 	do {
-		msg = (struct xpc_msg *)((u64)ch->local_msgqueue +
+		msg = (struct xpc_msg *)((u64)ch_sn2->local_msgqueue +
 					 (get % ch->local_nentries) *
 					 ch->msg_size);
 		msg->flags = 0;
@@ -1837,7 +1751,7 @@ xpc_clear_remote_msgqueue_flags_sn2(stru
 
 	put = ch_sn2->w_remote_GP.put;
 	do {
-		msg = (struct xpc_msg *)((u64)ch->remote_msgqueue +
+		msg = (struct xpc_msg *)((u64)ch_sn2->remote_msgqueue +
 					 (put % ch->remote_nentries) *
 					 ch->msg_size);
 		msg->flags = 0;
@@ -1976,8 +1890,9 @@ xpc_pull_remote_msg_sn2(struct xpc_chann
 		}
 
 		msg_offset = msg_index * ch->msg_size;
-		msg = (struct xpc_msg *)((u64)ch->remote_msgqueue + msg_offset);
-		remote_msg_pa = ch->remote_msgqueue_pa + msg_offset;
+		msg = (struct xpc_msg *)((u64)ch_sn2->remote_msgqueue +
+		    msg_offset);
+		remote_msg_pa = ch_sn2->remote_msgqueue_pa + msg_offset;
 
 		ret = xpc_pull_remote_cachelines_sn2(part, msg, remote_msg_pa,
 						     nmsgs * ch->msg_size);
@@ -2001,7 +1916,7 @@ xpc_pull_remote_msg_sn2(struct xpc_chann
 
 	/* return the message we were looking for */
 	msg_offset = (get % ch->remote_nentries) * ch->msg_size;
-	msg = (struct xpc_msg *)((u64)ch->remote_msgqueue + msg_offset);
+	msg = (struct xpc_msg *)((u64)ch_sn2->remote_msgqueue + msg_offset);
 
 	return msg;
 }
@@ -2080,7 +1995,7 @@ xpc_send_msgs_sn2(struct xpc_channel *ch
 			if (put == ch_sn2->w_local_GP.put)
 				break;
 
-			msg = (struct xpc_msg *)((u64)ch->local_msgqueue +
+			msg = (struct xpc_msg *)((u64)ch_sn2->local_msgqueue +
 						 (put % ch->local_nentries) *
 						 ch->msg_size);
 
@@ -2182,7 +2097,7 @@ xpc_allocate_msg_sn2(struct xpc_channel 
 	}
 
 	/* get the message's address and initialize it */
-	msg = (struct xpc_msg *)((u64)ch->local_msgqueue +
+	msg = (struct xpc_msg *)((u64)ch_sn2->local_msgqueue +
 				 (put % ch->local_nentries) * ch->msg_size);
 
 	DBUG_ON(msg->flags != 0);
@@ -2207,6 +2122,7 @@ xpc_send_msg_sn2(struct xpc_channel *ch,
 		 void *key)
 {
 	enum xp_retval ret = xpSuccess;
+	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
 	struct xpc_msg *msg = msg;
 	struct xpc_notify *notify = notify;
 	s64 msg_number;
@@ -2243,7 +2159,7 @@ xpc_send_msg_sn2(struct xpc_channel *ch,
 
 		atomic_inc(&ch->n_to_notify);
 
-		notify = &ch->notify_queue[msg_number % ch->local_nentries];
+		notify = &ch_sn2->notify_queue[msg_number % ch->local_nentries];
 		notify->func = func;
 		notify->key = key;
 		notify->type = notify_type;
@@ -2279,7 +2195,7 @@ xpc_send_msg_sn2(struct xpc_channel *ch,
 
 	/* see if the message is next in line to be sent, if so send it */
 
-	put = ch->sn.sn2.local_GP->put;
+	put = ch_sn2->local_GP->put;
 	if (put == msg_number)
 		xpc_send_msgs_sn2(ch, put);
 
@@ -2307,7 +2223,7 @@ xpc_acknowledge_msgs_sn2(struct xpc_chan
 			if (get == ch_sn2->w_local_GP.get)
 				break;
 
-			msg = (struct xpc_msg *)((u64)ch->remote_msgqueue +
+			msg = (struct xpc_msg *)((u64)ch_sn2->remote_msgqueue +
 						 (get % ch->remote_nentries) *
 						 ch->msg_size);
 
@@ -2385,8 +2301,9 @@ xpc_init_sn2(void)
 	int ret;
 	size_t buf_size;
 
+	xpc_setup_partitions_sn = xpc_setup_partitions_sn_sn2;
 	xpc_get_partition_rsvd_page_pa = xpc_get_partition_rsvd_page_pa_sn2;
-	xpc_rsvd_page_init = xpc_rsvd_page_init_sn2;
+	xpc_setup_rsvd_page_sn = xpc_setup_rsvd_page_sn_sn2;
 	xpc_increment_heartbeat = xpc_increment_heartbeat_sn2;
 	xpc_offline_heartbeat = xpc_offline_heartbeat_sn2;
 	xpc_online_heartbeat = xpc_online_heartbeat_sn2;
@@ -2403,29 +2320,33 @@ xpc_init_sn2(void)
 	    xpc_cancel_partition_deactivation_request_sn2;
 
 	xpc_process_activate_IRQ_rcvd = xpc_process_activate_IRQ_rcvd_sn2;
-	xpc_setup_infrastructure = xpc_setup_infrastructure_sn2;
-	xpc_teardown_infrastructure = xpc_teardown_infrastructure_sn2;
+	xpc_setup_ch_structures_sn = xpc_setup_ch_structures_sn_sn2;
+	xpc_teardown_ch_structures_sn = xpc_teardown_ch_structures_sn_sn2;
 	xpc_make_first_contact = xpc_make_first_contact_sn2;
+
 	xpc_get_chctl_all_flags = xpc_get_chctl_all_flags_sn2;
-	xpc_allocate_msgqueues = xpc_allocate_msgqueues_sn2;
-	xpc_free_msgqueues = xpc_free_msgqueues_sn2;
+	xpc_send_chctl_closerequest = xpc_send_chctl_closerequest_sn2;
+	xpc_send_chctl_closereply = xpc_send_chctl_closereply_sn2;
+	xpc_send_chctl_openrequest = xpc_send_chctl_openrequest_sn2;
+	xpc_send_chctl_openreply = xpc_send_chctl_openreply_sn2;
+
+	xpc_save_remote_msgqueue_pa = xpc_save_remote_msgqueue_pa_sn2;
+
+	xpc_setup_msg_structures = xpc_setup_msg_structures_sn2;
+	xpc_teardown_msg_structures = xpc_teardown_msg_structures_sn2;
+
 	xpc_notify_senders_of_disconnect = xpc_notify_senders_of_disconnect_sn2;
 	xpc_process_msg_chctl_flags = xpc_process_msg_chctl_flags_sn2;
 	xpc_n_of_deliverable_msgs = xpc_n_of_deliverable_msgs_sn2;
 	xpc_get_deliverable_msg = xpc_get_deliverable_msg_sn2;
 
 	xpc_indicate_partition_engaged = xpc_indicate_partition_engaged_sn2;
-	xpc_partition_engaged = xpc_partition_engaged_sn2;
-	xpc_any_partition_engaged = xpc_any_partition_engaged_sn2;
 	xpc_indicate_partition_disengaged =
 	    xpc_indicate_partition_disengaged_sn2;
+	xpc_partition_engaged = xpc_partition_engaged_sn2;
+	xpc_any_partition_engaged = xpc_any_partition_engaged_sn2;
 	xpc_assume_partition_disengaged = xpc_assume_partition_disengaged_sn2;
 
-	xpc_send_chctl_closerequest = xpc_send_chctl_closerequest_sn2;
-	xpc_send_chctl_closereply = xpc_send_chctl_closereply_sn2;
-	xpc_send_chctl_openrequest = xpc_send_chctl_openrequest_sn2;
-	xpc_send_chctl_openreply = xpc_send_chctl_openreply_sn2;
-
 	xpc_send_msg = xpc_send_msg_sn2;
 	xpc_received_msg = xpc_received_msg_sn2;
 
diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-setup-the-activate-gru-message-queue drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-setup-the-activate-gru-message-queue
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -14,41 +14,528 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/device.h>
 #include <asm/uv/uv_hub.h>
+#include "../sgi-gru/gru.h"
 #include "../sgi-gru/grukservices.h"
 #include "xpc.h"
 
+static atomic64_t xpc_heartbeat_uv;
 static DECLARE_BITMAP(xpc_heartbeating_to_mask_uv, XP_MAX_NPARTITIONS_UV);
 
-static void *xpc_activate_mq;
+#define XPC_ACTIVATE_MSG_SIZE_UV	(1 * GRU_CACHE_LINE_BYTES)
+#define XPC_NOTIFY_MSG_SIZE_UV		(2 * GRU_CACHE_LINE_BYTES)
+
+#define XPC_ACTIVATE_MQ_SIZE_UV	(4 * XP_MAX_NPARTITIONS_UV * \
+				 XPC_ACTIVATE_MSG_SIZE_UV)
+#define XPC_NOTIFY_MQ_SIZE_UV	(4 * XP_MAX_NPARTITIONS_UV * \
+				 XPC_NOTIFY_MSG_SIZE_UV)
+
+static void *xpc_activate_mq_uv;
+static void *xpc_notify_mq_uv;
+
+static int
+xpc_setup_partitions_sn_uv(void)
+{
+	short partid;
+	struct xpc_partition_uv *part_uv;
+
+	for (partid = 0; partid < XP_MAX_NPARTITIONS_UV; partid++) {
+		part_uv = &xpc_partitions[partid].sn.uv;
+
+		spin_lock_init(&part_uv->flags_lock);
+		part_uv->remote_act_state = XPC_P_AS_INACTIVE;
+	}
+	return 0;
+}
+
+static void *
+xpc_create_gru_mq_uv(unsigned int mq_size, int cpuid, unsigned int irq,
+		     irq_handler_t irq_handler)
+{
+	int ret;
+	int nid;
+	int mq_order;
+	struct page *page;
+	void *mq;
+
+	nid = cpu_to_node(cpuid);
+	mq_order = get_order(mq_size);
+	page = alloc_pages_node(nid, GFP_KERNEL | __GFP_ZERO | GFP_THISNODE,
+				mq_order);
+	if (page == NULL)
+		return NULL;
+
+	mq = page_address(page);
+	ret = gru_create_message_queue(mq, mq_size);
+	if (ret != 0) {
+		dev_err(xpc_part, "gru_create_message_queue() returned "
+			"error=%d\n", ret);
+		free_pages((unsigned long)mq, mq_order);
+		return NULL;
+	}
+
+	/* !!! Need to do some other things to set up IRQ */
+
+	ret = request_irq(irq, irq_handler, 0, "xpc", NULL);
+	if (ret != 0) {
+		dev_err(xpc_part, "request_irq(irq=%d) returned error=%d\n",
+			irq, ret);
+		free_pages((unsigned long)mq, mq_order);
+		return NULL;
+	}
+
+	/* !!! enable generation of irq when GRU mq op occurs to this mq */
+
+	/* ??? allow other partitions to access GRU mq? */
+
+	return mq;
+}
+
+static void
+xpc_destroy_gru_mq_uv(void *mq, unsigned int mq_size, unsigned int irq)
+{
+	/* ??? disallow other partitions to access GRU mq? */
+
+	/* !!! disable generation of irq when GRU mq op occurs to this mq */
+
+	free_irq(irq, NULL);
+
+	free_pages((unsigned long)mq, get_order(mq_size));
+}
+
+static enum xp_retval
+xpc_send_gru_msg(unsigned long mq_gpa, void *msg, size_t msg_size)
+{
+	enum xp_retval xp_ret;
+	int ret;
+
+	while (1) {
+		ret = gru_send_message_gpa(mq_gpa, msg, msg_size);
+		if (ret == MQE_OK) {
+			xp_ret = xpSuccess;
+			break;
+		}
+
+		if (ret == MQE_QUEUE_FULL) {
+			dev_dbg(xpc_chan, "gru_send_message_gpa() returned "
+				"error=MQE_QUEUE_FULL\n");
+			/* !!! handle QLimit reached; delay & try again */
+			/* ??? Do we add a limit to the number of retries? */
+			(void)msleep_interruptible(10);
+		} else if (ret == MQE_CONGESTION) {
+			dev_dbg(xpc_chan, "gru_send_message_gpa() returned "
+				"error=MQE_CONGESTION\n");
+			/* !!! handle LB Overflow; simply try again */
+			/* ??? Do we add a limit to the number of retries? */
+		} else {
+			/* !!! Currently this is MQE_UNEXPECTED_CB_ERR */
+			dev_err(xpc_chan, "gru_send_message_gpa() returned "
+				"error=%d\n", ret);
+			xp_ret = xpGruSendMqError;
+			break;
+		}
+	}
+	return xp_ret;
+}
+
+static void
+xpc_process_activate_IRQ_rcvd_uv(void)
+{
+	unsigned long irq_flags;
+	short partid;
+	struct xpc_partition *part;
+	u8 act_state_req;
+
+	DBUG_ON(xpc_activate_IRQ_rcvd == 0);
+
+	spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+	for (partid = 0; partid < XP_MAX_NPARTITIONS_UV; partid++) {
+		part = &xpc_partitions[partid];
+
+		if (part->sn.uv.act_state_req == 0)
+			continue;
+
+		xpc_activate_IRQ_rcvd--;
+		BUG_ON(xpc_activate_IRQ_rcvd < 0);
+
+		act_state_req = part->sn.uv.act_state_req;
+		part->sn.uv.act_state_req = 0;
+		spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+
+		if (act_state_req == XPC_P_ASR_ACTIVATE_UV) {
+			if (part->act_state == XPC_P_AS_INACTIVE)
+				xpc_activate_partition(part);
+			else if (part->act_state == XPC_P_AS_DEACTIVATING)
+				XPC_DEACTIVATE_PARTITION(part, xpReactivating);
+
+		} else if (act_state_req == XPC_P_ASR_REACTIVATE_UV) {
+			if (part->act_state == XPC_P_AS_INACTIVE)
+				xpc_activate_partition(part);
+			else
+				XPC_DEACTIVATE_PARTITION(part, xpReactivating);
+
+		} else if (act_state_req == XPC_P_ASR_DEACTIVATE_UV) {
+			XPC_DEACTIVATE_PARTITION(part, part->sn.uv.reason);
+
+		} else {
+			BUG();
+		}
+
+		spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+		if (xpc_activate_IRQ_rcvd == 0)
+			break;
+	}
+	spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+
+}
+
+static irqreturn_t
+xpc_handle_activate_IRQ_uv(int irq, void *dev_id)
+{
+	unsigned long irq_flags;
+	struct xpc_activate_mq_msghdr_uv *msg_hdr;
+	short partid;
+	struct xpc_partition *part;
+	struct xpc_partition_uv *part_uv;
+	struct xpc_openclose_args *args;
+	int wakeup_hb_checker = 0;
+
+	while ((msg_hdr = gru_get_next_message(xpc_activate_mq_uv)) != NULL) {
+
+		partid = msg_hdr->partid;
+		if (partid < 0 || partid >= XP_MAX_NPARTITIONS_UV) {
+			dev_err(xpc_part, "xpc_handle_activate_IRQ_uv() invalid"
+				"partid=0x%x passed in message\n", partid);
+			gru_free_message(xpc_activate_mq_uv, msg_hdr);
+			continue;
+		}
+		part = &xpc_partitions[partid];
+		part_uv = &part->sn.uv;
+
+		part_uv->remote_act_state = msg_hdr->act_state;
+
+		switch (msg_hdr->type) {
+		case XPC_ACTIVATE_MQ_MSG_SYNC_ACT_STATE_UV:
+			/* syncing of remote_act_state was just done above */
+			break;
+
+		case XPC_ACTIVATE_MQ_MSG_INC_HEARTBEAT_UV: {
+			struct xpc_activate_mq_msg_heartbeat_req_uv *msg;
+
+			msg = (struct xpc_activate_mq_msg_heartbeat_req_uv *)
+			    msg_hdr;
+			part_uv->heartbeat = msg->heartbeat;
+			break;
+		}
+		case XPC_ACTIVATE_MQ_MSG_OFFLINE_HEARTBEAT_UV: {
+			struct xpc_activate_mq_msg_heartbeat_req_uv *msg;
+
+			msg = (struct xpc_activate_mq_msg_heartbeat_req_uv *)
+			    msg_hdr;
+			part_uv->heartbeat = msg->heartbeat;
+			spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
+			part_uv->flags |= XPC_P_HEARTBEAT_OFFLINE_UV;
+			spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
+			break;
+		}
+		case XPC_ACTIVATE_MQ_MSG_ONLINE_HEARTBEAT_UV: {
+			struct xpc_activate_mq_msg_heartbeat_req_uv *msg;
+
+			msg = (struct xpc_activate_mq_msg_heartbeat_req_uv *)
+			    msg_hdr;
+			part_uv->heartbeat = msg->heartbeat;
+			spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
+			part_uv->flags &= ~XPC_P_HEARTBEAT_OFFLINE_UV;
+			spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
+			break;
+		}
+		case XPC_ACTIVATE_MQ_MSG_ACTIVATE_REQ_UV: {
+			struct xpc_activate_mq_msg_activate_req_uv *msg;
+
+			/*
+			 * ??? Do we deal here with ts_jiffies being different
+			 * ??? if act_state != XPC_P_AS_INACTIVE instead of
+			 * ??? below?
+			 */
+			msg = (struct xpc_activate_mq_msg_activate_req_uv *)
+			    msg_hdr;
+			spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock,
+					  irq_flags);
+			if (part_uv->act_state_req == 0)
+				xpc_activate_IRQ_rcvd++;
+			part_uv->act_state_req = XPC_P_ASR_ACTIVATE_UV;
+			part->remote_rp_pa = msg->rp_gpa; /* !!! _pa is _gpa */
+			part->remote_rp_ts_jiffies = msg_hdr->rp_ts_jiffies;
+			part_uv->remote_activate_mq_gpa = msg->activate_mq_gpa;
+			spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock,
+					       irq_flags);
+			wakeup_hb_checker++;
+			break;
+		}
+		case XPC_ACTIVATE_MQ_MSG_DEACTIVATE_REQ_UV: {
+			struct xpc_activate_mq_msg_deactivate_req_uv *msg;
+
+			msg = (struct xpc_activate_mq_msg_deactivate_req_uv *)
+			    msg_hdr;
+			spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock,
+					  irq_flags);
+			if (part_uv->act_state_req == 0)
+				xpc_activate_IRQ_rcvd++;
+			part_uv->act_state_req = XPC_P_ASR_DEACTIVATE_UV;
+			part_uv->reason = msg->reason;
+			spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock,
+					       irq_flags);
+			wakeup_hb_checker++;
+			break;
+		}
+		case XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREQUEST_UV: {
+			struct xpc_activate_mq_msg_chctl_closerequest_uv *msg;
+
+			msg = (struct xpc_activate_mq_msg_chctl_closerequest_uv
+			    *)msg_hdr;
+			args = &part->remote_openclose_args[msg->ch_number];
+			args->reason = msg->reason;
+
+			spin_lock_irqsave(&part->chctl_lock, irq_flags);
+			part->chctl.flags[msg->ch_number] |=
+			    XPC_CHCTL_CLOSEREQUEST;
+			spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
+
+			xpc_wakeup_channel_mgr(part);
+			break;
+		}
+		case XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREPLY_UV: {
+			struct xpc_activate_mq_msg_chctl_closereply_uv *msg;
+
+			msg = (struct xpc_activate_mq_msg_chctl_closereply_uv *)
+			    msg_hdr;
+
+			spin_lock_irqsave(&part->chctl_lock, irq_flags);
+			part->chctl.flags[msg->ch_number] |=
+			    XPC_CHCTL_CLOSEREPLY;
+			spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
+
+			xpc_wakeup_channel_mgr(part);
+			break;
+		}
+		case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREQUEST_UV: {
+			struct xpc_activate_mq_msg_chctl_openrequest_uv *msg;
+
+			msg = (struct xpc_activate_mq_msg_chctl_openrequest_uv
+			    *)msg_hdr;
+			args = &part->remote_openclose_args[msg->ch_number];
+			args->msg_size = msg->msg_size;
+			args->local_nentries = msg->local_nentries;
+
+			spin_lock_irqsave(&part->chctl_lock, irq_flags);
+			part->chctl.flags[msg->ch_number] |=
+			    XPC_CHCTL_OPENREQUEST;
+			spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
+
+			xpc_wakeup_channel_mgr(part);
+			break;
+		}
+		case XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREPLY_UV: {
+			struct xpc_activate_mq_msg_chctl_openreply_uv *msg;
+
+			msg = (struct xpc_activate_mq_msg_chctl_openreply_uv *)
+			    msg_hdr;
+			args = &part->remote_openclose_args[msg->ch_number];
+			args->remote_nentries = msg->remote_nentries;
+			args->local_nentries = msg->local_nentries;
+			args->local_msgqueue_pa = msg->local_notify_mq_gpa;
+
+			spin_lock_irqsave(&part->chctl_lock, irq_flags);
+			part->chctl.flags[msg->ch_number] |=
+			    XPC_CHCTL_OPENREPLY;
+			spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
+
+			xpc_wakeup_channel_mgr(part);
+			break;
+		}
+		case XPC_ACTIVATE_MQ_MSG_MARK_ENGAGED_UV:
+			spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
+			part_uv->flags |= XPC_P_ENGAGED_UV;
+			spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
+			break;
+
+		case XPC_ACTIVATE_MQ_MSG_MARK_DISENGAGED_UV:
+			spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
+			part_uv->flags &= ~XPC_P_ENGAGED_UV;
+			spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
+			break;
+
+		default:
+			dev_err(xpc_part, "received unknown activate_mq msg "
+				"type=%d from partition=%d\n", msg_hdr->type,
+				partid);
+		}
+
+		if (msg_hdr->rp_ts_jiffies != part->remote_rp_ts_jiffies &&
+		    part->remote_rp_ts_jiffies != 0) {
+			/*
+			 * ??? Does what we do here need to be sensitive to
+			 * ??? act_state or remote_act_state?
+			 */
+			spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock,
+					  irq_flags);
+			if (part_uv->act_state_req == 0)
+				xpc_activate_IRQ_rcvd++;
+			part_uv->act_state_req = XPC_P_ASR_REACTIVATE_UV;
+			spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock,
+					       irq_flags);
+			wakeup_hb_checker++;
+		}
+
+		gru_free_message(xpc_activate_mq_uv, msg_hdr);
+	}
+
+	if (wakeup_hb_checker)
+		wake_up_interruptible(&xpc_activate_IRQ_wq);
+
+	return IRQ_HANDLED;
+}
+
+static enum xp_retval
+xpc_send_activate_IRQ_uv(struct xpc_partition *part, void *msg, size_t msg_size,
+			 int msg_type)
+{
+	struct xpc_activate_mq_msghdr_uv *msg_hdr = msg;
+
+	DBUG_ON(msg_size > XPC_ACTIVATE_MSG_SIZE_UV);
+
+	msg_hdr->type = msg_type;
+	msg_hdr->partid = XPC_PARTID(part);
+	msg_hdr->act_state = part->act_state;
+	msg_hdr->rp_ts_jiffies = xpc_rsvd_page->ts_jiffies;
+
+	/* ??? Is holding a spin_lock (ch->lock) during this call a bad idea? */
+	return xpc_send_gru_msg(part->sn.uv.remote_activate_mq_gpa, msg,
+				msg_size);
+}
 
 static void
-xpc_send_local_activate_IRQ_uv(struct xpc_partition *part)
+xpc_send_activate_IRQ_part_uv(struct xpc_partition *part, void *msg,
+			      size_t msg_size, int msg_type)
 {
+	enum xp_retval ret;
+
+	ret = xpc_send_activate_IRQ_uv(part, msg, msg_size, msg_type);
+	if (unlikely(ret != xpSuccess))
+		XPC_DEACTIVATE_PARTITION(part, ret);
+}
+
+static void
+xpc_send_activate_IRQ_ch_uv(struct xpc_channel *ch, unsigned long *irq_flags,
+			 void *msg, size_t msg_size, int msg_type)
+{
+	struct xpc_partition *part = &xpc_partitions[ch->number];
+	enum xp_retval ret;
+
+	ret = xpc_send_activate_IRQ_uv(part, msg, msg_size, msg_type);
+	if (unlikely(ret != xpSuccess)) {
+		if (irq_flags != NULL)
+			spin_unlock_irqrestore(&ch->lock, *irq_flags);
+
+		XPC_DEACTIVATE_PARTITION(part, ret);
+
+		if (irq_flags != NULL)
+			spin_lock_irqsave(&ch->lock, *irq_flags);
+	}
+}
+
+static void
+xpc_send_local_activate_IRQ_uv(struct xpc_partition *part, int act_state_req)
+{
+	unsigned long irq_flags;
+	struct xpc_partition_uv *part_uv = &part->sn.uv;
+
 	/*
 	 * !!! Make our side think that the remote parition sent an activate
-	 * !!! message our way. Also do what the activate IRQ handler would
+	 * !!! message our way by doing what the activate IRQ handler would
 	 * !!! do had one really been sent.
 	 */
+
+	spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+	if (part_uv->act_state_req == 0)
+		xpc_activate_IRQ_rcvd++;
+	part_uv->act_state_req = act_state_req;
+	spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock, irq_flags);
+
+	wake_up_interruptible(&xpc_activate_IRQ_wq);
 }
 
 static enum xp_retval
-xpc_rsvd_page_init_uv(struct xpc_rsvd_page *rp)
+xpc_get_partition_rsvd_page_pa_uv(void *buf, u64 *cookie, unsigned long *rp_pa,
+				  size_t *len)
 {
-	/* !!! need to have established xpc_activate_mq earlier */
-	rp->sn.activate_mq_gpa = uv_gpa(xpc_activate_mq);
-	return xpSuccess;
+	/* !!! call the UV version of sn_partition_reserved_page_pa() */
+	return xpUnsupported;
+}
+
+static int
+xpc_setup_rsvd_page_sn_uv(struct xpc_rsvd_page *rp)
+{
+	rp->sn.activate_mq_gpa = uv_gpa(xpc_activate_mq_uv);
+	return 0;
+}
+
+static void
+xpc_send_heartbeat_uv(int msg_type)
+{
+	short partid;
+	struct xpc_partition *part;
+	struct xpc_activate_mq_msg_heartbeat_req_uv msg;
+
+	/*
+	 * !!! On uv we're broadcasting a heartbeat message every 5 seconds.
+	 * !!! Whereas on sn2 we're bte_copy'ng the heartbeat info every 20
+	 * !!! seconds. This is an increase in numalink traffic.
+	 * ??? Is this good?
+	 */
+
+	msg.heartbeat = atomic64_inc_return(&xpc_heartbeat_uv);
+
+	partid = find_first_bit(xpc_heartbeating_to_mask_uv,
+				XP_MAX_NPARTITIONS_UV);
+
+	while (partid < XP_MAX_NPARTITIONS_UV) {
+		part = &xpc_partitions[partid];
+
+		xpc_send_activate_IRQ_part_uv(part, &msg, sizeof(msg),
+					      msg_type);
+
+		partid = find_next_bit(xpc_heartbeating_to_mask_uv,
+				       XP_MAX_NPARTITIONS_UV, partid + 1);
+	}
 }
 
 static void
 xpc_increment_heartbeat_uv(void)
 {
-	/* !!! send heartbeat msg to xpc_heartbeating_to_mask partids */
+	xpc_send_heartbeat_uv(XPC_ACTIVATE_MQ_MSG_INC_HEARTBEAT_UV);
+}
+
+static void
+xpc_offline_heartbeat_uv(void)
+{
+	xpc_send_heartbeat_uv(XPC_ACTIVATE_MQ_MSG_OFFLINE_HEARTBEAT_UV);
+}
+
+static void
+xpc_online_heartbeat_uv(void)
+{
+	xpc_send_heartbeat_uv(XPC_ACTIVATE_MQ_MSG_ONLINE_HEARTBEAT_UV);
 }
 
 static void
 xpc_heartbeat_init_uv(void)
 {
+	atomic64_set(&xpc_heartbeat_uv, 0);
 	bitmap_zero(xpc_heartbeating_to_mask_uv, XP_MAX_NPARTITIONS_UV);
 	xpc_heartbeating_to_mask = &xpc_heartbeating_to_mask_uv[0];
 }
@@ -56,48 +543,94 @@ xpc_heartbeat_init_uv(void)
 static void
 xpc_heartbeat_exit_uv(void)
 {
-	/* !!! send heartbeat_offline msg to xpc_heartbeating_to_mask partids */
+	xpc_send_heartbeat_uv(XPC_ACTIVATE_MQ_MSG_OFFLINE_HEARTBEAT_UV);
+}
+
+static enum xp_retval
+xpc_get_remote_heartbeat_uv(struct xpc_partition *part)
+{
+	struct xpc_partition_uv *part_uv = &part->sn.uv;
+	enum xp_retval ret = xpNoHeartbeat;
+
+	if (part_uv->remote_act_state != XPC_P_AS_INACTIVE &&
+	    part_uv->remote_act_state != XPC_P_AS_DEACTIVATING) {
+
+		if (part_uv->heartbeat != part->last_heartbeat ||
+		    (part_uv->flags & XPC_P_HEARTBEAT_OFFLINE_UV)) {
+
+			part->last_heartbeat = part_uv->heartbeat;
+			ret = xpSuccess;
+		}
+	}
+	return ret;
 }
 
 static void
 xpc_request_partition_activation_uv(struct xpc_rsvd_page *remote_rp,
-				    unsigned long remote_rp_pa, int nasid)
+				    unsigned long remote_rp_gpa, int nasid)
 {
 	short partid = remote_rp->SAL_partid;
 	struct xpc_partition *part = &xpc_partitions[partid];
+	struct xpc_activate_mq_msg_activate_req_uv msg;
 
-/*
- * !!! Setup part structure with the bits of info we can glean from the rp:
- * !!!	part->remote_rp_pa = remote_rp_pa;
- * !!!	part->sn.uv.activate_mq_gpa = remote_rp->sn.activate_mq_gpa;
- */
+	part->remote_rp_pa = remote_rp_gpa; /* !!! _pa here is really _gpa */
+	part->remote_rp_ts_jiffies = remote_rp->ts_jiffies;
+	part->sn.uv.remote_activate_mq_gpa = remote_rp->sn.activate_mq_gpa;
+
+	/*
+	 * ??? Is it a good idea to make this conditional on what is
+	 * ??? potentially stale state information?
+	 */
+	if (part->sn.uv.remote_act_state == XPC_P_AS_INACTIVE) {
+		msg.rp_gpa = uv_gpa(xpc_rsvd_page);
+		msg.activate_mq_gpa = xpc_rsvd_page->sn.activate_mq_gpa;
+		xpc_send_activate_IRQ_part_uv(part, &msg, sizeof(msg),
+					   XPC_ACTIVATE_MQ_MSG_ACTIVATE_REQ_UV);
+	}
 
-	xpc_send_local_activate_IRQ_uv(part);
+	if (part->act_state == XPC_P_AS_INACTIVE)
+		xpc_send_local_activate_IRQ_uv(part, XPC_P_ASR_ACTIVATE_UV);
 }
 
 static void
 xpc_request_partition_reactivation_uv(struct xpc_partition *part)
 {
-	xpc_send_local_activate_IRQ_uv(part);
+	xpc_send_local_activate_IRQ_uv(part, XPC_P_ASR_ACTIVATE_UV);
+}
+
+static void
+xpc_request_partition_deactivation_uv(struct xpc_partition *part)
+{
+	struct xpc_activate_mq_msg_deactivate_req_uv msg;
+
+	/*
+	 * ??? Is it a good idea to make this conditional on what is
+	 * ??? potentially stale state information?
+	 */
+	if (part->sn.uv.remote_act_state != XPC_P_AS_DEACTIVATING &&
+	    part->sn.uv.remote_act_state != XPC_P_AS_INACTIVE) {
+
+		msg.reason = part->reason;
+		xpc_send_activate_IRQ_part_uv(part, &msg, sizeof(msg),
+					 XPC_ACTIVATE_MQ_MSG_DEACTIVATE_REQ_UV);
+	}
 }
 
 /*
- * Setup the infrastructure necessary to support XPartition Communication
- * between the specified remote partition and the local one.
+ * Setup the channel structures that are uv specific.
  */
 static enum xp_retval
-xpc_setup_infrastructure_uv(struct xpc_partition *part)
+xpc_setup_ch_structures_sn_uv(struct xpc_partition *part)
 {
 	/* !!! this function needs fleshing out */
 	return xpUnsupported;
 }
 
 /*
- * Teardown the infrastructure necessary to support XPartition Communication
- * between the specified remote partition and the local one.
+ * Teardown the channel structures that are uv specific.
  */
 static void
-xpc_teardown_infrastructure_uv(struct xpc_partition *part)
+xpc_teardown_ch_structures_sn_uv(struct xpc_partition *part)
 {
 	/* !!! this function needs fleshing out */
 	return;
@@ -106,15 +639,163 @@ xpc_teardown_infrastructure_uv(struct xp
 static enum xp_retval
 xpc_make_first_contact_uv(struct xpc_partition *part)
 {
-	/* !!! this function needs fleshing out */
-	return xpUnsupported;
+	struct xpc_activate_mq_msg_uv msg;
+
+	/*
+	 * We send a sync msg to get the remote partition's remote_act_state
+	 * updated to our current act_state which at this point should
+	 * be XPC_P_AS_ACTIVATING.
+	 */
+	xpc_send_activate_IRQ_part_uv(part, &msg, sizeof(msg),
+				      XPC_ACTIVATE_MQ_MSG_SYNC_ACT_STATE_UV);
+
+	while (part->sn.uv.remote_act_state != XPC_P_AS_ACTIVATING) {
+
+		dev_dbg(xpc_part, "waiting to make first contact with "
+			"partition %d\n", XPC_PARTID(part));
+
+		/* wait a 1/4 of a second or so */
+		(void)msleep_interruptible(250);
+
+		if (part->act_state == XPC_P_AS_DEACTIVATING)
+			return part->reason;
+	}
+
+	return xpSuccess;
 }
 
 static u64
 xpc_get_chctl_all_flags_uv(struct xpc_partition *part)
 {
+	unsigned long irq_flags;
+	union xpc_channel_ctl_flags chctl;
+
+	spin_lock_irqsave(&part->chctl_lock, irq_flags);
+	chctl = part->chctl;
+	if (chctl.all_flags != 0)
+		part->chctl.all_flags = 0;
+
+	spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
+	return chctl.all_flags;
+}
+
+static enum xp_retval
+xpc_setup_msg_structures_uv(struct xpc_channel *ch)
+{
 	/* !!! this function needs fleshing out */
-	return 0UL;
+	return xpUnsupported;
+}
+
+static void
+xpc_teardown_msg_structures_uv(struct xpc_channel *ch)
+{
+	struct xpc_channel_uv *ch_uv = &ch->sn.uv;
+
+	ch_uv->remote_notify_mq_gpa = 0;
+
+	/* !!! this function needs fleshing out */
+}
+
+static void
+xpc_send_chctl_closerequest_uv(struct xpc_channel *ch, unsigned long *irq_flags)
+{
+	struct xpc_activate_mq_msg_chctl_closerequest_uv msg;
+
+	msg.ch_number = ch->number;
+	msg.reason = ch->reason;
+	xpc_send_activate_IRQ_ch_uv(ch, irq_flags, &msg, sizeof(msg),
+				    XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREQUEST_UV);
+}
+
+static void
+xpc_send_chctl_closereply_uv(struct xpc_channel *ch, unsigned long *irq_flags)
+{
+	struct xpc_activate_mq_msg_chctl_closereply_uv msg;
+
+	msg.ch_number = ch->number;
+	xpc_send_activate_IRQ_ch_uv(ch, irq_flags, &msg, sizeof(msg),
+				    XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREPLY_UV);
+}
+
+static void
+xpc_send_chctl_openrequest_uv(struct xpc_channel *ch, unsigned long *irq_flags)
+{
+	struct xpc_activate_mq_msg_chctl_openrequest_uv msg;
+
+	msg.ch_number = ch->number;
+	msg.msg_size = ch->msg_size;
+	msg.local_nentries = ch->local_nentries;
+	xpc_send_activate_IRQ_ch_uv(ch, irq_flags, &msg, sizeof(msg),
+				    XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREQUEST_UV);
+}
+
+static void
+xpc_send_chctl_openreply_uv(struct xpc_channel *ch, unsigned long *irq_flags)
+{
+	struct xpc_activate_mq_msg_chctl_openreply_uv msg;
+
+	msg.ch_number = ch->number;
+	msg.local_nentries = ch->local_nentries;
+	msg.remote_nentries = ch->remote_nentries;
+	msg.local_notify_mq_gpa = uv_gpa(xpc_notify_mq_uv);
+	xpc_send_activate_IRQ_ch_uv(ch, irq_flags, &msg, sizeof(msg),
+				    XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREPLY_UV);
+}
+
+static void
+xpc_save_remote_msgqueue_pa_uv(struct xpc_channel *ch,
+			       unsigned long msgqueue_pa)
+{
+	ch->sn.uv.remote_notify_mq_gpa = msgqueue_pa;
+}
+
+static void
+xpc_indicate_partition_engaged_uv(struct xpc_partition *part)
+{
+	struct xpc_activate_mq_msg_uv msg;
+
+	xpc_send_activate_IRQ_part_uv(part, &msg, sizeof(msg),
+				      XPC_ACTIVATE_MQ_MSG_MARK_ENGAGED_UV);
+}
+
+static void
+xpc_indicate_partition_disengaged_uv(struct xpc_partition *part)
+{
+	struct xpc_activate_mq_msg_uv msg;
+
+	xpc_send_activate_IRQ_part_uv(part, &msg, sizeof(msg),
+				      XPC_ACTIVATE_MQ_MSG_MARK_DISENGAGED_UV);
+}
+
+static void
+xpc_assume_partition_disengaged_uv(short partid)
+{
+	struct xpc_partition_uv *part_uv = &xpc_partitions[partid].sn.uv;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
+	part_uv->flags &= ~XPC_P_ENGAGED_UV;
+	spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
+}
+
+static int
+xpc_partition_engaged_uv(short partid)
+{
+	return (xpc_partitions[partid].sn.uv.flags & XPC_P_ENGAGED_UV) != 0;
+}
+
+static int
+xpc_any_partition_engaged_uv(void)
+{
+	struct xpc_partition_uv *part_uv;
+	short partid;
+
+	for (partid = 0; partid < XP_MAX_NPARTITIONS_UV; partid++) {
+		part_uv = &xpc_partitions[partid].sn.uv;
+		if ((part_uv->flags & XPC_P_ENGAGED_UV) != 0)
+			return 1;
+	}
+	return 0;
 }
 
 static struct xpc_msg *
@@ -124,24 +805,64 @@ xpc_get_deliverable_msg_uv(struct xpc_ch
 	return NULL;
 }
 
-void
+int
 xpc_init_uv(void)
 {
-	xpc_rsvd_page_init = xpc_rsvd_page_init_uv;
+	xpc_setup_partitions_sn = xpc_setup_partitions_sn_uv;
+	xpc_process_activate_IRQ_rcvd = xpc_process_activate_IRQ_rcvd_uv;
+	xpc_get_partition_rsvd_page_pa = xpc_get_partition_rsvd_page_pa_uv;
+	xpc_setup_rsvd_page_sn = xpc_setup_rsvd_page_sn_uv;
 	xpc_increment_heartbeat = xpc_increment_heartbeat_uv;
+	xpc_offline_heartbeat = xpc_offline_heartbeat_uv;
+	xpc_online_heartbeat = xpc_online_heartbeat_uv;
 	xpc_heartbeat_init = xpc_heartbeat_init_uv;
 	xpc_heartbeat_exit = xpc_heartbeat_exit_uv;
+	xpc_get_remote_heartbeat = xpc_get_remote_heartbeat_uv;
+
 	xpc_request_partition_activation = xpc_request_partition_activation_uv;
 	xpc_request_partition_reactivation =
 	    xpc_request_partition_reactivation_uv;
-	xpc_setup_infrastructure = xpc_setup_infrastructure_uv;
-	xpc_teardown_infrastructure = xpc_teardown_infrastructure_uv;
+	xpc_request_partition_deactivation =
+	    xpc_request_partition_deactivation_uv;
+
+	xpc_setup_ch_structures_sn = xpc_setup_ch_structures_sn_uv;
+	xpc_teardown_ch_structures_sn = xpc_teardown_ch_structures_sn_uv;
+
 	xpc_make_first_contact = xpc_make_first_contact_uv;
+
 	xpc_get_chctl_all_flags = xpc_get_chctl_all_flags_uv;
+	xpc_send_chctl_closerequest = xpc_send_chctl_closerequest_uv;
+	xpc_send_chctl_closereply = xpc_send_chctl_closereply_uv;
+	xpc_send_chctl_openrequest = xpc_send_chctl_openrequest_uv;
+	xpc_send_chctl_openreply = xpc_send_chctl_openreply_uv;
+
+	xpc_save_remote_msgqueue_pa = xpc_save_remote_msgqueue_pa_uv;
+
+	xpc_setup_msg_structures = xpc_setup_msg_structures_uv;
+	xpc_teardown_msg_structures = xpc_teardown_msg_structures_uv;
+
+	xpc_indicate_partition_engaged = xpc_indicate_partition_engaged_uv;
+	xpc_indicate_partition_disengaged =
+	    xpc_indicate_partition_disengaged_uv;
+	xpc_assume_partition_disengaged = xpc_assume_partition_disengaged_uv;
+	xpc_partition_engaged = xpc_partition_engaged_uv;
+	xpc_any_partition_engaged = xpc_any_partition_engaged_uv;
+
 	xpc_get_deliverable_msg = xpc_get_deliverable_msg_uv;
+
+	/* ??? The cpuid argument's value is 0, is that what we want? */
+	/* !!! The irq argument's value isn't correct. */
+	xpc_activate_mq_uv = xpc_create_gru_mq_uv(XPC_ACTIVATE_MQ_SIZE_UV, 0, 0,
+						  xpc_handle_activate_IRQ_uv);
+	if (xpc_activate_mq_uv == NULL)
+		return -ENOMEM;
+
+	return 0;
 }
 
 void
 xpc_exit_uv(void)
 {
+	/* !!! The irq argument's value isn't correct. */
+	xpc_destroy_gru_mq_uv(xpc_activate_mq_uv, XPC_ACTIVATE_MQ_SIZE_UV, 0);
 }
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch

