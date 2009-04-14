From: akpm@linux-foundation.org
Subject: [merged] sgi-xpc-prevent-false-heartbeat-failures.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:50:16 -0700
Message-ID: <200904141950.n3EJoGR8020084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753106AbZDNTwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, dcn@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xpc: prevent false heartbeat failures
has been removed from the -mm tree.  Its filename was
     sgi-xpc-prevent-false-heartbeat-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xpc: prevent false heartbeat failures
From: Robin Holt <holt@sgi.com>

The heartbeat timeout functionality in sgi-xpc is currently not trained to
the connection time.  If a connection is made and the code is in the last
polling window prior to doing a timeout, the next polling window will see
the heartbeat as unchanged and initiate a no-heartbeat disconnect.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpc.h      |  104 ++++++++++----------------
 drivers/misc/sgi-xp/xpc_main.c |    8 +-
 drivers/misc/sgi-xp/xpc_sn2.c  |   44 +++++++++--
 drivers/misc/sgi-xp/xpc_uv.c   |  123 ++++++++++---------------------
 4 files changed, 125 insertions(+), 154 deletions(-)

diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xpc-prevent-false-heartbeat-failures drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xpc-prevent-false-heartbeat-failures
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -90,18 +90,21 @@ struct xpc_rsvd_page {
 	short max_npartitions;	/* value of XPC_MAX_PARTITIONS */
 	u8 version;
 	u8 pad1[3];		/* align to next u64 in 1st 64-byte cacheline */
+	unsigned long ts_jiffies; /* timestamp when rsvd pg was setup by XPC */
 	union {
-		unsigned long vars_pa;	/* phys address of struct xpc_vars */
-		unsigned long activate_gru_mq_desc_gpa; /* phys addr of */
-							/* activate mq's */
-							/* gru mq descriptor */
+		struct {
+			unsigned long vars_pa;	/* phys addr */
+		} sn2;
+		struct {
+			unsigned long heartbeat_gpa; /* phys addr */
+			unsigned long activate_gru_mq_desc_gpa; /* phys addr */
+		} uv;
 	} sn;
-	unsigned long ts_jiffies; /* timestamp when rsvd pg was setup by XPC */
-	u64 pad2[10];		/* align to last u64 in 2nd 64-byte cacheline */
+	u64 pad2[9];		/* align to last u64 in 2nd 64-byte cacheline */
 	u64 SAL_nasids_size;	/* SAL: size of each nasid mask in bytes */
 };
 
-#define XPC_RP_VERSION _XPC_VERSION(2, 0) /* version 2.0 of the reserved page */
+#define XPC_RP_VERSION _XPC_VERSION(3, 0) /* version 3.0 of the reserved page */
 
 /*
  * Define the structures by which XPC variables can be exported to other
@@ -182,6 +185,17 @@ struct xpc_vars_part_sn2 {
 				 (XPC_RP_MACH_NASIDS(_rp) + \
 				  xpc_nasid_mask_nlongs))
 
+
+/*
+ * The following structure describes the partition's heartbeat info which
+ * will be periodically read by other partitions to determine whether this
+ * XPC is still 'alive'.
+ */
+struct xpc_heartbeat_uv {
+	unsigned long value;
+	unsigned long offline;	/* if 0, heartbeat should be changing */
+};
+
 /*
  * Info pertinent to a GRU message queue using a watch list for irq generation.
  */
@@ -198,7 +212,7 @@ struct xpc_gru_mq_uv {
 
 /*
  * The activate_mq is used to send/receive GRU messages that affect XPC's
- * heartbeat, partition active state, and channel state. This is UV only.
+ * partition active state and channel state. This is uv only.
  */
 struct xpc_activate_mq_msghdr_uv {
 	unsigned int gru_msg_hdr; /* FOR GRU INTERNAL USE ONLY */
@@ -210,33 +224,26 @@ struct xpc_activate_mq_msghdr_uv {
 
 /* activate_mq defined message types */
 #define XPC_ACTIVATE_MQ_MSG_SYNC_ACT_STATE_UV		0
-#define XPC_ACTIVATE_MQ_MSG_INC_HEARTBEAT_UV		1
-#define XPC_ACTIVATE_MQ_MSG_OFFLINE_HEARTBEAT_UV	2
-#define XPC_ACTIVATE_MQ_MSG_ONLINE_HEARTBEAT_UV		3
-
-#define XPC_ACTIVATE_MQ_MSG_ACTIVATE_REQ_UV		4
-#define XPC_ACTIVATE_MQ_MSG_DEACTIVATE_REQ_UV		5
-
-#define XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREQUEST_UV	6
-#define XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREPLY_UV		7
-#define XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREQUEST_UV	8
-#define XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREPLY_UV		9
 
-#define XPC_ACTIVATE_MQ_MSG_MARK_ENGAGED_UV		10
-#define XPC_ACTIVATE_MQ_MSG_MARK_DISENGAGED_UV		11
+#define XPC_ACTIVATE_MQ_MSG_ACTIVATE_REQ_UV		1
+#define XPC_ACTIVATE_MQ_MSG_DEACTIVATE_REQ_UV		2
 
-struct xpc_activate_mq_msg_uv {
-	struct xpc_activate_mq_msghdr_uv hdr;
-};
+#define XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREQUEST_UV	3
+#define XPC_ACTIVATE_MQ_MSG_CHCTL_CLOSEREPLY_UV		4
+#define XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREQUEST_UV	5
+#define XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREPLY_UV		6
+
+#define XPC_ACTIVATE_MQ_MSG_MARK_ENGAGED_UV		7
+#define XPC_ACTIVATE_MQ_MSG_MARK_DISENGAGED_UV		8
 
-struct xpc_activate_mq_msg_heartbeat_req_uv {
+struct xpc_activate_mq_msg_uv {
 	struct xpc_activate_mq_msghdr_uv hdr;
-	u64 heartbeat;
 };
 
 struct xpc_activate_mq_msg_activate_req_uv {
 	struct xpc_activate_mq_msghdr_uv hdr;
 	unsigned long rp_gpa;
+	unsigned long heartbeat_gpa;
 	unsigned long activate_gru_mq_desc_gpa;
 };
 
@@ -687,6 +694,9 @@ struct xpc_partition_sn2 {
 };
 
 struct xpc_partition_uv {
+	unsigned long heartbeat_gpa; /* phys addr of partition's heartbeat */
+	struct xpc_heartbeat_uv cached_heartbeat; /* cached copy of */
+						  /* partition's heartbeat */
 	unsigned long activate_gru_mq_desc_gpa;	/* phys addr of parititon's */
 						/* activate mq's gru mq */
 						/* descriptor */
@@ -698,14 +708,12 @@ struct xpc_partition_uv {
 	u8 remote_act_state;	/* remote partition's act_state */
 	u8 act_state_req;	/* act_state request from remote partition */
 	enum xp_retval reason;	/* reason for deactivate act_state request */
-	u64 heartbeat;		/* incremented by remote partition */
 };
 
 /* struct xpc_partition_uv flags */
 
-#define XPC_P_HEARTBEAT_OFFLINE_UV		0x00000001
+#define XPC_P_CACHED_ACTIVATE_GRU_MQ_DESC_UV	0x00000001
 #define XPC_P_ENGAGED_UV			0x00000002
-#define XPC_P_CACHED_ACTIVATE_GRU_MQ_DESC_UV	0x00000004
 
 /* struct xpc_partition_uv act_state change requests */
 
@@ -807,7 +815,6 @@ extern int xpc_disengage_timedout;
 extern int xpc_activate_IRQ_rcvd;
 extern spinlock_t xpc_activate_IRQ_rcvd_lock;
 extern wait_queue_head_t xpc_activate_IRQ_wq;
-extern void *xpc_heartbeating_to_mask;
 extern void *xpc_kzalloc_cacheline_aligned(size_t, gfp_t, void **);
 extern void xpc_activate_partition(struct xpc_partition *);
 extern void xpc_activate_kthreads(struct xpc_channel *, int);
@@ -825,6 +832,9 @@ extern void (*xpc_increment_heartbeat) (
 extern void (*xpc_offline_heartbeat) (void);
 extern void (*xpc_online_heartbeat) (void);
 extern enum xp_retval (*xpc_get_remote_heartbeat) (struct xpc_partition *);
+extern void (*xpc_allow_hb) (short);
+extern void (*xpc_disallow_hb) (short);
+extern void (*xpc_disallow_all_hbs) (void);
 extern enum xp_retval (*xpc_make_first_contact) (struct xpc_partition *);
 extern u64 (*xpc_get_chctl_all_flags) (struct xpc_partition *);
 extern enum xp_retval (*xpc_setup_msg_structures) (struct xpc_channel *);
@@ -909,40 +919,6 @@ extern void xpc_disconnect_channel(const
 extern void xpc_disconnect_callout(struct xpc_channel *, enum xp_retval);
 extern void xpc_partition_going_down(struct xpc_partition *, enum xp_retval);
 
-static inline int
-xpc_hb_allowed(short partid, void *heartbeating_to_mask)
-{
-	return test_bit(partid, heartbeating_to_mask);
-}
-
-static inline int
-xpc_any_hbs_allowed(void)
-{
-	DBUG_ON(xpc_heartbeating_to_mask == NULL);
-	return !bitmap_empty(xpc_heartbeating_to_mask, xp_max_npartitions);
-}
-
-static inline void
-xpc_allow_hb(short partid)
-{
-	DBUG_ON(xpc_heartbeating_to_mask == NULL);
-	set_bit(partid, xpc_heartbeating_to_mask);
-}
-
-static inline void
-xpc_disallow_hb(short partid)
-{
-	DBUG_ON(xpc_heartbeating_to_mask == NULL);
-	clear_bit(partid, xpc_heartbeating_to_mask);
-}
-
-static inline void
-xpc_disallow_all_hbs(void)
-{
-	DBUG_ON(xpc_heartbeating_to_mask == NULL);
-	bitmap_zero(xpc_heartbeating_to_mask, xp_max_npartitions);
-}
-
 static inline void
 xpc_wakeup_channel_mgr(struct xpc_partition *part)
 {
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xpc-prevent-false-heartbeat-failures drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xpc-prevent-false-heartbeat-failures
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2004-2009 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 /*
@@ -150,7 +150,6 @@ DECLARE_WAIT_QUEUE_HEAD(xpc_activate_IRQ
 
 static unsigned long xpc_hb_check_timeout;
 static struct timer_list xpc_hb_timer;
-void *xpc_heartbeating_to_mask;
 
 /* notification that the xpc_hb_checker thread has exited */
 static DECLARE_COMPLETION(xpc_hb_checker_exited);
@@ -176,6 +175,10 @@ enum xp_retval (*xpc_get_partition_rsvd_
 						  unsigned long *rp_pa,
 						  size_t *len);
 int (*xpc_setup_rsvd_page_sn) (struct xpc_rsvd_page *rp);
+
+void (*xpc_allow_hb) (short partid);
+void (*xpc_disallow_hb) (short partid);
+void (*xpc_disallow_all_hbs) (void);
 void (*xpc_heartbeat_init) (void);
 void (*xpc_heartbeat_exit) (void);
 void (*xpc_increment_heartbeat) (void);
@@ -1087,7 +1090,6 @@ xpc_do_exit(enum xp_retval reason)
 	} while (1);
 
 	DBUG_ON(xpc_any_partition_engaged());
-	DBUG_ON(xpc_any_hbs_allowed() != 0);
 
 	xpc_teardown_rsvd_page();
 
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xpc-prevent-false-heartbeat-failures drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xpc-prevent-false-heartbeat-failures
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -3,7 +3,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2008-2009 Silicon Graphics, Inc.  All Rights Reserved.
  */
 
 /*
@@ -629,7 +629,7 @@ xpc_setup_rsvd_page_sn_sn2(struct xpc_rs
 
 	xpc_vars_sn2 = XPC_RP_VARS(rp);
 
-	rp->sn.vars_pa = xp_pa(xpc_vars_sn2);
+	rp->sn.sn2.vars_pa = xp_pa(xpc_vars_sn2);
 
 	/* vars_part array follows immediately after vars */
 	xpc_vars_part_sn2 = (struct xpc_vars_part_sn2 *)((u8 *)XPC_RP_VARS(rp) +
@@ -693,6 +693,33 @@ xpc_setup_rsvd_page_sn_sn2(struct xpc_rs
 	return 0;
 }
 
+static int
+xpc_hb_allowed_sn2(short partid, void *heartbeating_to_mask)
+{
+	return test_bit(partid, heartbeating_to_mask);
+}
+
+static void
+xpc_allow_hb_sn2(short partid)
+{
+	DBUG_ON(xpc_vars_sn2 == NULL);
+	set_bit(partid, xpc_vars_sn2->heartbeating_to_mask);
+}
+
+static void
+xpc_disallow_hb_sn2(short partid)
+{
+	DBUG_ON(xpc_vars_sn2 == NULL);
+	clear_bit(partid, xpc_vars_sn2->heartbeating_to_mask);
+}
+
+static void
+xpc_disallow_all_hbs_sn2(void)
+{
+	DBUG_ON(xpc_vars_sn2 == NULL);
+	bitmap_zero(xpc_vars_sn2->heartbeating_to_mask, xp_max_npartitions);
+}
+
 static void
 xpc_increment_heartbeat_sn2(void)
 {
@@ -719,7 +746,6 @@ xpc_heartbeat_init_sn2(void)
 	DBUG_ON(xpc_vars_sn2 == NULL);
 
 	bitmap_zero(xpc_vars_sn2->heartbeating_to_mask, XP_MAX_NPARTITIONS_SN2);
-	xpc_heartbeating_to_mask = &xpc_vars_sn2->heartbeating_to_mask[0];
 	xpc_online_heartbeat_sn2();
 }
 
@@ -751,9 +777,9 @@ xpc_get_remote_heartbeat_sn2(struct xpc_
 		remote_vars->heartbeating_to_mask[0]);
 
 	if ((remote_vars->heartbeat == part->last_heartbeat &&
-	    remote_vars->heartbeat_offline == 0) ||
-	    !xpc_hb_allowed(sn_partition_id,
-			    &remote_vars->heartbeating_to_mask)) {
+	    !remote_vars->heartbeat_offline) ||
+	    !xpc_hb_allowed_sn2(sn_partition_id,
+				remote_vars->heartbeating_to_mask)) {
 		ret = xpNoHeartbeat;
 	} else {
 		part->last_heartbeat = remote_vars->heartbeat;
@@ -972,7 +998,7 @@ xpc_identify_activate_IRQ_req_sn2(int na
 		return;
 	}
 
-	remote_vars_pa = remote_rp->sn.vars_pa;
+	remote_vars_pa = remote_rp->sn.sn2.vars_pa;
 	remote_rp_version = remote_rp->version;
 	remote_rp_ts_jiffies = remote_rp->ts_jiffies;
 
@@ -2325,6 +2351,10 @@ xpc_init_sn2(void)
 	xpc_teardown_partitions_sn = xpc_teardown_partitions_sn_sn2;
 	xpc_get_partition_rsvd_page_pa = xpc_get_partition_rsvd_page_pa_sn2;
 	xpc_setup_rsvd_page_sn = xpc_setup_rsvd_page_sn_sn2;
+
+	xpc_allow_hb = xpc_allow_hb_sn2;
+	xpc_disallow_hb = xpc_disallow_hb_sn2;
+	xpc_disallow_all_hbs = xpc_disallow_all_hbs_sn2;
 	xpc_increment_heartbeat = xpc_increment_heartbeat_sn2;
 	xpc_offline_heartbeat = xpc_offline_heartbeat_sn2;
 	xpc_online_heartbeat = xpc_online_heartbeat_sn2;
diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xpc-prevent-false-heartbeat-failures drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xpc-prevent-false-heartbeat-failures
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -46,8 +46,7 @@ struct uv_IO_APIC_route_entry {
 };
 #endif
 
-static atomic64_t xpc_heartbeat_uv;
-static DECLARE_BITMAP(xpc_heartbeating_to_mask_uv, XP_MAX_NPARTITIONS_UV);
+static struct xpc_heartbeat_uv *xpc_heartbeat_uv;
 
 #define XPC_ACTIVATE_MSG_SIZE_UV	(1 * GRU_CACHE_LINE_BYTES)
 #define XPC_ACTIVATE_MQ_SIZE_UV		(4 * XP_MAX_NPARTITIONS_UV * \
@@ -423,41 +422,6 @@ xpc_handle_activate_mq_msg_uv(struct xpc
 		/* syncing of remote_act_state was just done above */
 		break;
 
-	case XPC_ACTIVATE_MQ_MSG_INC_HEARTBEAT_UV: {
-		struct xpc_activate_mq_msg_heartbeat_req_uv *msg;
-
-		msg = container_of(msg_hdr,
-				   struct xpc_activate_mq_msg_heartbeat_req_uv,
-				   hdr);
-		part_uv->heartbeat = msg->heartbeat;
-		break;
-	}
-	case XPC_ACTIVATE_MQ_MSG_OFFLINE_HEARTBEAT_UV: {
-		struct xpc_activate_mq_msg_heartbeat_req_uv *msg;
-
-		msg = container_of(msg_hdr,
-				   struct xpc_activate_mq_msg_heartbeat_req_uv,
-				   hdr);
-		part_uv->heartbeat = msg->heartbeat;
-
-		spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
-		part_uv->flags |= XPC_P_HEARTBEAT_OFFLINE_UV;
-		spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
-		break;
-	}
-	case XPC_ACTIVATE_MQ_MSG_ONLINE_HEARTBEAT_UV: {
-		struct xpc_activate_mq_msg_heartbeat_req_uv *msg;
-
-		msg = container_of(msg_hdr,
-				   struct xpc_activate_mq_msg_heartbeat_req_uv,
-				   hdr);
-		part_uv->heartbeat = msg->heartbeat;
-
-		spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
-		part_uv->flags &= ~XPC_P_HEARTBEAT_OFFLINE_UV;
-		spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
-		break;
-	}
 	case XPC_ACTIVATE_MQ_MSG_ACTIVATE_REQ_UV: {
 		struct xpc_activate_mq_msg_activate_req_uv *msg;
 
@@ -475,6 +439,7 @@ xpc_handle_activate_mq_msg_uv(struct xpc
 		part_uv->act_state_req = XPC_P_ASR_ACTIVATE_UV;
 		part->remote_rp_pa = msg->rp_gpa; /* !!! _pa is _gpa */
 		part->remote_rp_ts_jiffies = msg_hdr->rp_ts_jiffies;
+		part_uv->heartbeat_gpa = msg->heartbeat_gpa;
 
 		if (msg->activate_gru_mq_desc_gpa !=
 		    part_uv->activate_gru_mq_desc_gpa) {
@@ -759,7 +724,7 @@ xpc_send_local_activate_IRQ_uv(struct xp
 
 	/*
 	 * !!! Make our side think that the remote partition sent an activate
-	 * !!! message our way by doing what the activate IRQ handler would
+	 * !!! mq message our way by doing what the activate IRQ handler would
 	 * !!! do had one really been sent.
 	 */
 
@@ -808,88 +773,80 @@ xpc_get_partition_rsvd_page_pa_uv(void *
 static int
 xpc_setup_rsvd_page_sn_uv(struct xpc_rsvd_page *rp)
 {
-	rp->sn.activate_gru_mq_desc_gpa =
+	xpc_heartbeat_uv =
+	    &xpc_partitions[sn_partition_id].sn.uv.cached_heartbeat;
+	rp->sn.uv.heartbeat_gpa = uv_gpa(xpc_heartbeat_uv);
+	rp->sn.uv.activate_gru_mq_desc_gpa =
 	    uv_gpa(xpc_activate_mq_uv->gru_mq_desc);
 	return 0;
 }
 
 static void
-xpc_send_heartbeat_uv(int msg_type)
+xpc_allow_hb_uv(short partid)
 {
-	short partid;
-	struct xpc_partition *part;
-	struct xpc_activate_mq_msg_heartbeat_req_uv msg;
-
-	/*
-	 * !!! On uv we're broadcasting a heartbeat message every 5 seconds.
-	 * !!! Whereas on sn2 we're bte_copy'ng the heartbeat info every 20
-	 * !!! seconds. This is an increase in numalink traffic.
-	 * ??? Is this good?
-	 */
-
-	msg.heartbeat = atomic64_inc_return(&xpc_heartbeat_uv);
-
-	partid = find_first_bit(xpc_heartbeating_to_mask_uv,
-				XP_MAX_NPARTITIONS_UV);
-
-	while (partid < XP_MAX_NPARTITIONS_UV) {
-		part = &xpc_partitions[partid];
+}
 
-		xpc_send_activate_IRQ_part_uv(part, &msg, sizeof(msg),
-					      msg_type);
+static void
+xpc_disallow_hb_uv(short partid)
+{
+}
 
-		partid = find_next_bit(xpc_heartbeating_to_mask_uv,
-				       XP_MAX_NPARTITIONS_UV, partid + 1);
-	}
+static void
+xpc_disallow_all_hbs_uv(void)
+{
 }
 
 static void
 xpc_increment_heartbeat_uv(void)
 {
-	xpc_send_heartbeat_uv(XPC_ACTIVATE_MQ_MSG_INC_HEARTBEAT_UV);
+	xpc_heartbeat_uv->value++;
 }
 
 static void
 xpc_offline_heartbeat_uv(void)
 {
-	xpc_send_heartbeat_uv(XPC_ACTIVATE_MQ_MSG_OFFLINE_HEARTBEAT_UV);
+	xpc_increment_heartbeat_uv();
+	xpc_heartbeat_uv->offline = 1;
 }
 
 static void
 xpc_online_heartbeat_uv(void)
 {
-	xpc_send_heartbeat_uv(XPC_ACTIVATE_MQ_MSG_ONLINE_HEARTBEAT_UV);
+	xpc_increment_heartbeat_uv();
+	xpc_heartbeat_uv->offline = 0;
 }
 
 static void
 xpc_heartbeat_init_uv(void)
 {
-	atomic64_set(&xpc_heartbeat_uv, 0);
-	bitmap_zero(xpc_heartbeating_to_mask_uv, XP_MAX_NPARTITIONS_UV);
-	xpc_heartbeating_to_mask = &xpc_heartbeating_to_mask_uv[0];
+	xpc_heartbeat_uv->value = 1;
+	xpc_heartbeat_uv->offline = 0;
 }
 
 static void
 xpc_heartbeat_exit_uv(void)
 {
-	xpc_send_heartbeat_uv(XPC_ACTIVATE_MQ_MSG_OFFLINE_HEARTBEAT_UV);
+	xpc_offline_heartbeat_uv();
 }
 
 static enum xp_retval
 xpc_get_remote_heartbeat_uv(struct xpc_partition *part)
 {
 	struct xpc_partition_uv *part_uv = &part->sn.uv;
-	enum xp_retval ret = xpNoHeartbeat;
+	enum xp_retval ret;
 
-	if (part_uv->remote_act_state != XPC_P_AS_INACTIVE &&
-	    part_uv->remote_act_state != XPC_P_AS_DEACTIVATING) {
+	ret = xp_remote_memcpy(uv_gpa(&part_uv->cached_heartbeat),
+			       part_uv->heartbeat_gpa,
+			       sizeof(struct xpc_heartbeat_uv));
+	if (ret != xpSuccess)
+		return ret;
 
-		if (part_uv->heartbeat != part->last_heartbeat ||
-		    (part_uv->flags & XPC_P_HEARTBEAT_OFFLINE_UV)) {
+	if (part_uv->cached_heartbeat.value == part->last_heartbeat &&
+	    !part_uv->cached_heartbeat.offline) {
 
-			part->last_heartbeat = part_uv->heartbeat;
-			ret = xpSuccess;
-		}
+		ret = xpNoHeartbeat;
+	} else {
+		part->last_heartbeat = part_uv->cached_heartbeat.value;
 	}
 	return ret;
 }
@@ -904,8 +861,9 @@ xpc_request_partition_activation_uv(stru
 
 	part->remote_rp_pa = remote_rp_gpa; /* !!! _pa here is really _gpa */
 	part->remote_rp_ts_jiffies = remote_rp->ts_jiffies;
+	part->sn.uv.heartbeat_gpa = remote_rp->sn.uv.heartbeat_gpa;
 	part->sn.uv.activate_gru_mq_desc_gpa =
-	    remote_rp->sn.activate_gru_mq_desc_gpa;
+	    remote_rp->sn.uv.activate_gru_mq_desc_gpa;
 
 	/*
 	 * ??? Is it a good idea to make this conditional on what is
@@ -913,8 +871,9 @@ xpc_request_partition_activation_uv(stru
 	 */
 	if (part->sn.uv.remote_act_state == XPC_P_AS_INACTIVE) {
 		msg.rp_gpa = uv_gpa(xpc_rsvd_page);
+		msg.heartbeat_gpa = xpc_rsvd_page->sn.uv.heartbeat_gpa;
 		msg.activate_gru_mq_desc_gpa =
-		    xpc_rsvd_page->sn.activate_gru_mq_desc_gpa;
+		    xpc_rsvd_page->sn.uv.activate_gru_mq_desc_gpa;
 		xpc_send_activate_IRQ_part_uv(part, &msg, sizeof(msg),
 					   XPC_ACTIVATE_MQ_MSG_ACTIVATE_REQ_UV);
 	}
@@ -1677,6 +1636,10 @@ xpc_init_uv(void)
 	xpc_process_activate_IRQ_rcvd = xpc_process_activate_IRQ_rcvd_uv;
 	xpc_get_partition_rsvd_page_pa = xpc_get_partition_rsvd_page_pa_uv;
 	xpc_setup_rsvd_page_sn = xpc_setup_rsvd_page_sn_uv;
+
+	xpc_allow_hb = xpc_allow_hb_uv;
+	xpc_disallow_hb = xpc_disallow_hb_uv;
+	xpc_disallow_all_hbs = xpc_disallow_all_hbs_uv;
 	xpc_increment_heartbeat = xpc_increment_heartbeat_uv;
 	xpc_offline_heartbeat = xpc_offline_heartbeat_uv;
 	xpc_online_heartbeat = xpc_online_heartbeat_uv;
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch

