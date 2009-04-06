From: akpm@linux-foundation.org
Subject: [merged] sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:37 -0700
Message-ID: <200904061937.n36Jbbrs013019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563AbZDFUPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, dcn@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-gru: add support to the GRU driver for message queue interrupts
has been removed from the -mm tree.  Its filename was
     sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-gru: add support to the GRU driver for message queue interrupts
From: Jack Steiner <steiner@sgi.com>

Add support to the GRU driver for message queue interrupts.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukservices.c |  104 ++++++-----
 drivers/misc/sgi-gru/grukservices.h |   33 ++-
 drivers/misc/sgi-xp/xpc.h           |   33 ++-
 drivers/misc/sgi-xp/xpc_channel.c   |    8 
 drivers/misc/sgi-xp/xpc_main.c      |    6 
 drivers/misc/sgi-xp/xpc_sn2.c       |   10 +
 drivers/misc/sgi-xp/xpc_uv.c        |  229 ++++++++++++++++++++------
 7 files changed, 305 insertions(+), 118 deletions(-)

diff -puN drivers/misc/sgi-gru/grukservices.c~sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -52,8 +52,10 @@
  */
 
 /* Blade percpu resources PERMANENTLY reserved for kernel use */
-#define GRU_NUM_KERNEL_CBR      1
+#define GRU_NUM_KERNEL_CBR	1
 #define GRU_NUM_KERNEL_DSR_BYTES 256
+#define GRU_NUM_KERNEL_DSR_CL	(GRU_NUM_KERNEL_DSR_BYTES /		\
+					GRU_CACHE_LINE_BYTES)
 #define KERNEL_CTXNUM           15
 
 /* GRU instruction attributes for all instructions */
@@ -94,7 +96,6 @@ struct message_header {
 	char	fill;
 };
 
-#define QLINES(mq)	((mq) + offsetof(struct message_queue, qlines))
 #define HSTATUS(mq, h)	((mq) + offsetof(struct message_queue, hstatus[h]))
 
 static int gru_get_cpu_resources(int dsr_bytes, void **cb, void **dsr)
@@ -250,7 +251,8 @@ static inline void restore_present2(void
  * Create a message queue.
  * 	qlines - message queue size in cache lines. Includes 2-line header.
  */
-int gru_create_message_queue(void *p, unsigned int bytes)
+int gru_create_message_queue(struct gru_message_queue_desc *mqd,
+		void *p, unsigned int bytes, int nasid, int vector, int apicid)
 {
 	struct message_queue *mq = p;
 	unsigned int qlines;
@@ -265,6 +267,12 @@ int gru_create_message_queue(void *p, un
 	mq->hstatus[0] = 0;
 	mq->hstatus[1] = 1;
 	mq->head = gru_mesq_head(2, qlines / 2 + 1);
+	mqd->mq = mq;
+	mqd->mq_gpa = uv_gpa(mq);
+	mqd->qlines = qlines;
+	mqd->interrupt_pnode = UV_NASID_TO_PNODE(nasid);
+	mqd->interrupt_vector = vector;
+	mqd->interrupt_apicid = apicid;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(gru_create_message_queue);
@@ -277,8 +285,8 @@ EXPORT_SYMBOL_GPL(gru_create_message_que
  *		-1 - if mesq sent successfully but queue not full
  *		>0 - unexpected error. MQE_xxx returned
  */
-static int send_noop_message(void *cb,
-				unsigned long mq, void *mesg)
+static int send_noop_message(void *cb, struct gru_message_queue_desc *mqd,
+				void *mesg)
 {
 	const struct message_header noop_header = {
 					.present = MQS_NOOP, .lines = 1};
@@ -289,7 +297,7 @@ static int send_noop_message(void *cb,
 	STAT(mesq_noop);
 	save_mhdr = *mhdr;
 	*mhdr = noop_header;
-	gru_mesq(cb, mq, gru_get_tri(mhdr), 1, IMA);
+	gru_mesq(cb, mqd->mq_gpa, gru_get_tri(mhdr), 1, IMA);
 	ret = gru_wait(cb);
 
 	if (ret) {
@@ -313,7 +321,7 @@ static int send_noop_message(void *cb,
 			break;
 		case CBSS_PUT_NACKED:
 			STAT(mesq_noop_put_nacked);
-			m = mq + (gru_get_amo_value_head(cb) << 6);
+			m = mqd->mq_gpa + (gru_get_amo_value_head(cb) << 6);
 			gru_vstore(cb, m, gru_get_tri(mesg), XTYPE_CL, 1, 1,
 						IMA);
 			if (gru_wait(cb) == CBS_IDLE)
@@ -333,30 +341,20 @@ static int send_noop_message(void *cb,
 /*
  * Handle a gru_mesq full.
  */
-static int send_message_queue_full(void *cb,
-			   unsigned long mq, void *mesg, int lines)
+static int send_message_queue_full(void *cb, struct gru_message_queue_desc *mqd,
+				void *mesg, int lines)
 {
 	union gru_mesqhead mqh;
 	unsigned int limit, head;
 	unsigned long avalue;
-	int half, qlines, save;
+	int half, qlines;
 
 	/* Determine if switching to first/second half of q */
 	avalue = gru_get_amo_value(cb);
 	head = gru_get_amo_value_head(cb);
 	limit = gru_get_amo_value_limit(cb);
 
-	/*
-	 * Fetch "qlines" from the queue header. Since the queue may be
-	 * in memory that can't be accessed using socket addresses, use
-	 * the GRU to access the data. Use DSR space from the message.
-	 */
-	save = *(int *)mesg;
-	gru_vload(cb, QLINES(mq), gru_get_tri(mesg), XTYPE_W, 1, 1, IMA);
-	if (gru_wait(cb) != CBS_IDLE)
-		goto cberr;
-	qlines = *(int *)mesg;
-	*(int *)mesg = save;
+	qlines = mqd->qlines;
 	half = (limit != qlines);
 
 	if (half)
@@ -365,7 +363,7 @@ static int send_message_queue_full(void 
 		mqh = gru_mesq_head(2, qlines / 2 + 1);
 
 	/* Try to get lock for switching head pointer */
-	gru_gamir(cb, EOP_IR_CLR, HSTATUS(mq, half), XTYPE_DW, IMA);
+	gru_gamir(cb, EOP_IR_CLR, HSTATUS(mqd->mq_gpa, half), XTYPE_DW, IMA);
 	if (gru_wait(cb) != CBS_IDLE)
 		goto cberr;
 	if (!gru_get_amo_value(cb)) {
@@ -375,8 +373,8 @@ static int send_message_queue_full(void 
 
 	/* Got the lock. Send optional NOP if queue not full, */
 	if (head != limit) {
-		if (send_noop_message(cb, mq, mesg)) {
-			gru_gamir(cb, EOP_IR_INC, HSTATUS(mq, half),
+		if (send_noop_message(cb, mqd, mesg)) {
+			gru_gamir(cb, EOP_IR_INC, HSTATUS(mqd->mq_gpa, half),
 					XTYPE_DW, IMA);
 			if (gru_wait(cb) != CBS_IDLE)
 				goto cberr;
@@ -387,14 +385,16 @@ static int send_message_queue_full(void 
 	}
 
 	/* Then flip queuehead to other half of queue. */
-	gru_gamer(cb, EOP_ERR_CSWAP, mq, XTYPE_DW, mqh.val, avalue, IMA);
+	gru_gamer(cb, EOP_ERR_CSWAP, mqd->mq_gpa, XTYPE_DW, mqh.val, avalue,
+							IMA);
 	if (gru_wait(cb) != CBS_IDLE)
 		goto cberr;
 
 	/* If not successfully in swapping queue head, clear the hstatus lock */
 	if (gru_get_amo_value(cb) != avalue) {
 		STAT(mesq_qf_switch_head_failed);
-		gru_gamir(cb, EOP_IR_INC, HSTATUS(mq, half), XTYPE_DW, IMA);
+		gru_gamir(cb, EOP_IR_INC, HSTATUS(mqd->mq_gpa, half), XTYPE_DW,
+							IMA);
 		if (gru_wait(cb) != CBS_IDLE)
 			goto cberr;
 	}
@@ -404,15 +404,25 @@ cberr:
 	return MQE_UNEXPECTED_CB_ERR;
 }
 
+/*
+ * Send a cross-partition interrupt to the SSI that contains the target
+ * message queue. Normally, the interrupt is automatically delivered by hardware
+ * but some error conditions require explicit delivery.
+ */
+static void send_message_queue_interrupt(struct gru_message_queue_desc *mqd)
+{
+	if (mqd->interrupt_vector)
+		uv_hub_send_ipi(mqd->interrupt_pnode, mqd->interrupt_apicid,
+				mqd->interrupt_vector);
+}
+
 
 /*
  * Handle a gru_mesq failure. Some of these failures are software recoverable
  * or retryable.
  */
-static int send_message_failure(void *cb,
-				unsigned long mq,
-				void *mesg,
-				int lines)
+static int send_message_failure(void *cb, struct gru_message_queue_desc *mqd,
+				void *mesg, int lines)
 {
 	int substatus, ret = 0;
 	unsigned long m;
@@ -429,7 +439,7 @@ static int send_message_failure(void *cb
 		break;
 	case CBSS_QLIMIT_REACHED:
 		STAT(mesq_send_qlimit_reached);
-		ret = send_message_queue_full(cb, mq, mesg, lines);
+		ret = send_message_queue_full(cb, mqd, mesg, lines);
 		break;
 	case CBSS_AMO_NACKED:
 		STAT(mesq_send_amo_nacked);
@@ -437,12 +447,14 @@ static int send_message_failure(void *cb
 		break;
 	case CBSS_PUT_NACKED:
 		STAT(mesq_send_put_nacked);
-		m = mq + (gru_get_amo_value_head(cb) << 6);
+		m = mqd->mq_gpa + (gru_get_amo_value_head(cb) << 6);
 		gru_vstore(cb, m, gru_get_tri(mesg), XTYPE_CL, lines, 1, IMA);
-		if (gru_wait(cb) == CBS_IDLE)
+		if (gru_wait(cb) == CBS_IDLE) {
 			ret = MQE_OK;
-		else
+			send_message_queue_interrupt(mqd);
+		} else {
 			ret = MQE_UNEXPECTED_CB_ERR;
+		}
 		break;
 	default:
 		BUG();
@@ -452,12 +464,12 @@ static int send_message_failure(void *cb
 
 /*
  * Send a message to a message queue
- * 	cb	GRU control block to use to send message
- * 	mq	message queue
+ * 	mqd	message queue descriptor
  * 	mesg	message. ust be vaddr within a GSEG
  * 	bytes	message size (<= 2 CL)
  */
-int gru_send_message_gpa(unsigned long mq, void *mesg, unsigned int bytes)
+int gru_send_message_gpa(struct gru_message_queue_desc *mqd, void *mesg,
+				unsigned int bytes)
 {
 	struct message_header *mhdr;
 	void *cb;
@@ -481,10 +493,10 @@ int gru_send_message_gpa(unsigned long m
 
 	do {
 		ret = MQE_OK;
-		gru_mesq(cb, mq, gru_get_tri(mhdr), clines, IMA);
+		gru_mesq(cb, mqd->mq_gpa, gru_get_tri(mhdr), clines, IMA);
 		istatus = gru_wait(cb);
 		if (istatus != CBS_IDLE)
-			ret = send_message_failure(cb, mq, dsr, clines);
+			ret = send_message_failure(cb, mqd, dsr, clines);
 	} while (ret == MQIE_AGAIN);
 	gru_free_cpu_resources(cb, dsr);
 
@@ -497,9 +509,9 @@ EXPORT_SYMBOL_GPL(gru_send_message_gpa);
 /*
  * Advance the receive pointer for the queue to the next message.
  */
-void gru_free_message(void *rmq, void *mesg)
+void gru_free_message(struct gru_message_queue_desc *mqd, void *mesg)
 {
-	struct message_queue *mq = rmq;
+	struct message_queue *mq = mqd->mq;
 	struct message_header *mhdr = mq->next;
 	void *next, *pnext;
 	int half = -1;
@@ -529,16 +541,16 @@ EXPORT_SYMBOL_GPL(gru_free_message);
  * present. User must call next_message() to move to next message.
  * 	rmq	message queue
  */
-void *gru_get_next_message(void *rmq)
+void *gru_get_next_message(struct gru_message_queue_desc *mqd)
 {
-	struct message_queue *mq = rmq;
+	struct message_queue *mq = mqd->mq;
 	struct message_header *mhdr = mq->next;
 	int present = mhdr->present;
 
 	/* skip NOOP messages */
 	STAT(mesq_receive);
 	while (present == MQS_NOOP) {
-		gru_free_message(rmq, mhdr);
+		gru_free_message(mqd, mhdr);
 		mhdr = mq->next;
 		present = mhdr->present;
 	}
@@ -576,7 +588,7 @@ int gru_copy_gpa(unsigned long dest_gpa,
 	if (gru_get_cpu_resources(GRU_NUM_KERNEL_DSR_BYTES, &cb, &dsr))
 		return MQE_BUG_NO_RESOURCES;
 	gru_bcopy(cb, src_gpa, dest_gpa, gru_get_tri(dsr),
-		  XTYPE_B, bytes, GRU_NUM_KERNEL_DSR_BYTES, IMA);
+		  XTYPE_B, bytes, GRU_NUM_KERNEL_DSR_CL, IMA);
 	ret = gru_wait(cb);
 	gru_free_cpu_resources(cb, dsr);
 	return ret;
@@ -611,7 +623,7 @@ static int quicktest(struct gru_state *g
 
 	if (word0 != word1 || word0 != MAGIC) {
 		printk
-		    ("GRU quicktest err: gru %d, found 0x%lx, expected 0x%lx\n",
+		    ("GRU quicktest err: gid %d, found 0x%lx, expected 0x%lx\n",
 		     gru->gs_gid, word1, MAGIC);
 		BUG();		/* ZZZ should not be fatal */
 	}
diff -puN drivers/misc/sgi-gru/grukservices.h~sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts drivers/misc/sgi-gru/grukservices.h
--- a/drivers/misc/sgi-gru/grukservices.h~sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts
+++ a/drivers/misc/sgi-gru/grukservices.h
@@ -41,6 +41,15 @@
  * 	- gru_create_message_queue() needs interrupt vector info
  */
 
+struct gru_message_queue_desc {
+	void		*mq;			/* message queue vaddress */
+	unsigned long	mq_gpa;			/* global address of mq */
+	int		qlines;			/* queue size in CL */
+	int		interrupt_vector;	/* interrupt vector */
+	int		interrupt_pnode;	/* pnode for interrupt */
+	int		interrupt_apicid;	/* lapicid for interrupt */
+};
+
 /*
  * Initialize a user allocated chunk of memory to be used as
  * a message queue. The caller must ensure that the queue is
@@ -51,14 +60,19 @@
  * to manage the queue.
  *
  *  Input:
- * 	p	pointer to user allocated memory.
+ * 	mqd	pointer to message queue descriptor
+ * 	p	pointer to user allocated mesq memory.
  * 	bytes	size of message queue in bytes
+ *      vector	interrupt vector (zero if no interrupts)
+ *      nasid	nasid of blade where interrupt is delivered
+ *      apicid	apicid of cpu for interrupt
  *
  *  Errors:
  *  	0	OK
  *  	>0	error
  */
-extern int gru_create_message_queue(void *p, unsigned int bytes);
+extern int gru_create_message_queue(struct gru_message_queue_desc *mqd,
+		void *p, unsigned int bytes, int nasid, int vector, int apicid);
 
 /*
  * Send a message to a message queue.
@@ -68,7 +82,7 @@ extern int gru_create_message_queue(void
  *
  *
  *   Input:
- * 	xmq	message queue - must be a UV global physical address
+ * 	mqd	pointer to message queue descriptor
  * 	mesg	pointer to message. Must be 64-bit aligned
  * 	bytes	size of message in bytes
  *
@@ -77,8 +91,8 @@ extern int gru_create_message_queue(void
  *     >0	Send failure - see error codes below
  *
  */
-extern int gru_send_message_gpa(unsigned long mq_gpa, void *mesg,
-						unsigned int bytes);
+extern int gru_send_message_gpa(struct gru_message_queue_desc *mqd,
+			void *mesg, unsigned int bytes);
 
 /* Status values for gru_send_message() */
 #define MQE_OK			0	/* message sent successfully */
@@ -94,10 +108,11 @@ extern int gru_send_message_gpa(unsigned
  * API extensions may allow for out-of-order freeing.
  *
  *   Input
- * 	mq	message queue
+ * 	mqd	pointer to message queue descriptor
  * 	mesq	message being freed
  */
-extern void gru_free_message(void *mq, void *mesq);
+extern void gru_free_message(struct gru_message_queue_desc *mqd,
+			     void *mesq);
 
 /*
  * Get next message from message queue. Returns pointer to
@@ -106,13 +121,13 @@ extern void gru_free_message(void *mq, v
  * in order to move the queue pointers to next message.
  *
  *   Input
- * 	mq	message queue
+ * 	mqd	pointer to message queue descriptor
  *
  *   Output:
  *	p	pointer to message
  *	NULL	no message available
  */
-extern void *gru_get_next_message(void *mq);
+extern void *gru_get_next_message(struct gru_message_queue_desc *mqd);
 
 
 /*
diff -puN drivers/misc/sgi-xp/xpc.h~sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -92,7 +92,9 @@ struct xpc_rsvd_page {
 	u8 pad1[3];		/* align to next u64 in 1st 64-byte cacheline */
 	union {
 		unsigned long vars_pa;	/* phys address of struct xpc_vars */
-		unsigned long activate_mq_gpa; /* gru phy addr of activate_mq */
+		unsigned long activate_gru_mq_desc_gpa; /* phys addr of */
+							/* activate mq's */
+							/* gru mq descriptor */
 	} sn;
 	unsigned long ts_jiffies; /* timestamp when rsvd pg was setup by XPC */
 	u64 pad2[10];		/* align to last u64 in 2nd 64-byte cacheline */
@@ -189,7 +191,9 @@ struct xpc_gru_mq_uv {
 	int irq;		/* irq raised when message is received in mq */
 	int mmr_blade;		/* blade where watchlist was allocated from */
 	unsigned long mmr_offset; /* offset of irq mmr located on mmr_blade */
+	unsigned long mmr_value; /* value of irq mmr located on mmr_blade */
 	int watchlist_num;	/* number of watchlist allocatd by BIOS */
+	void *gru_mq_desc;	/* opaque structure used by the GRU driver */
 };
 
 /*
@@ -197,6 +201,7 @@ struct xpc_gru_mq_uv {
  * heartbeat, partition active state, and channel state. This is UV only.
  */
 struct xpc_activate_mq_msghdr_uv {
+	unsigned int gru_msg_hdr; /* FOR GRU INTERNAL USE ONLY */
 	short partid;		/* sender's partid */
 	u8 act_state;		/* sender's act_state at time msg sent */
 	u8 type;		/* message's type */
@@ -232,7 +237,7 @@ struct xpc_activate_mq_msg_heartbeat_req
 struct xpc_activate_mq_msg_activate_req_uv {
 	struct xpc_activate_mq_msghdr_uv hdr;
 	unsigned long rp_gpa;
-	unsigned long activate_mq_gpa;
+	unsigned long activate_gru_mq_desc_gpa;
 };
 
 struct xpc_activate_mq_msg_deactivate_req_uv {
@@ -263,7 +268,7 @@ struct xpc_activate_mq_msg_chctl_openrep
 	short ch_number;
 	short remote_nentries;	/* ??? Is this needed? What is? */
 	short local_nentries;	/* ??? Is this needed? What is? */
-	unsigned long local_notify_mq_gpa;
+	unsigned long notify_gru_mq_desc_gpa;
 };
 
 /*
@@ -510,8 +515,8 @@ struct xpc_channel_sn2 {
 };
 
 struct xpc_channel_uv {
-	unsigned long remote_notify_mq_gpa;	/* gru phys address of remote */
-						/* partition's notify mq */
+	void *cached_notify_gru_mq_desc; /* remote partition's notify mq's */
+					 /* gru mq descriptor */
 
 	struct xpc_send_msg_slot_uv *send_msg_slots;
 	void *recv_msg_slots;	/* each slot will hold a xpc_notify_mq_msg_uv */
@@ -682,8 +687,12 @@ struct xpc_partition_sn2 {
 };
 
 struct xpc_partition_uv {
-	unsigned long remote_activate_mq_gpa;	/* gru phys address of remote */
-						/* partition's activate mq */
+	unsigned long activate_gru_mq_desc_gpa;	/* phys addr of parititon's */
+						/* activate mq's gru mq */
+						/* descriptor */
+	void *cached_activate_gru_mq_desc; /* cached copy of partition's */
+					   /* activate mq's gru mq descriptor */
+	struct mutex cached_activate_gru_mq_desc_mutex;
 	spinlock_t flags_lock;	/* protect updating of flags */
 	unsigned int flags;	/* general flags */
 	u8 remote_act_state;	/* remote partition's act_state */
@@ -694,8 +703,9 @@ struct xpc_partition_uv {
 
 /* struct xpc_partition_uv flags */
 
-#define XPC_P_HEARTBEAT_OFFLINE_UV	0x00000001
-#define XPC_P_ENGAGED_UV		0x00000002
+#define XPC_P_HEARTBEAT_OFFLINE_UV		0x00000001
+#define XPC_P_ENGAGED_UV			0x00000002
+#define XPC_P_CACHED_ACTIVATE_GRU_MQ_DESC_UV	0x00000004
 
 /* struct xpc_partition_uv act_state change requests */
 
@@ -804,6 +814,7 @@ extern void xpc_activate_kthreads(struct
 extern void xpc_create_kthreads(struct xpc_channel *, int, int);
 extern void xpc_disconnect_wait(int);
 extern int (*xpc_setup_partitions_sn) (void);
+extern void (*xpc_teardown_partitions_sn) (void);
 extern enum xp_retval (*xpc_get_partition_rsvd_page_pa) (void *, u64 *,
 							 unsigned long *,
 							 size_t *);
@@ -846,8 +857,8 @@ extern void (*xpc_send_chctl_openrequest
 					   unsigned long *);
 extern void (*xpc_send_chctl_openreply) (struct xpc_channel *, unsigned long *);
 
-extern void (*xpc_save_remote_msgqueue_pa) (struct xpc_channel *,
-					    unsigned long);
+extern enum xp_retval (*xpc_save_remote_msgqueue_pa) (struct xpc_channel *,
+						      unsigned long);
 
 extern enum xp_retval (*xpc_send_payload) (struct xpc_channel *, u32, void *,
 					   u16, u8, xpc_notify_func, void *);
diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -183,6 +183,7 @@ xpc_process_openclose_chctl_flags(struct
 	    &part->remote_openclose_args[ch_number];
 	struct xpc_channel *ch = &part->channels[ch_number];
 	enum xp_retval reason;
+	enum xp_retval ret;
 
 	spin_lock_irqsave(&ch->lock, irq_flags);
 
@@ -399,8 +400,13 @@ again:
 		DBUG_ON(args->local_nentries == 0);
 		DBUG_ON(args->remote_nentries == 0);
 
+		ret = xpc_save_remote_msgqueue_pa(ch, args->local_msgqueue_pa);
+		if (ret != xpSuccess) {
+			XPC_DISCONNECT_CHANNEL(ch, ret, &irq_flags);
+			spin_unlock_irqrestore(&ch->lock, irq_flags);
+			return;
+		}
 		ch->flags |= XPC_C_ROPENREPLY;
-		xpc_save_remote_msgqueue_pa(ch, args->local_msgqueue_pa);
 
 		if (args->local_nentries < ch->remote_nentries) {
 			dev_dbg(xpc_chan, "XPC_CHCTL_OPENREPLY: new "
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -171,6 +171,7 @@ static struct notifier_block xpc_die_not
 };
 
 int (*xpc_setup_partitions_sn) (void);
+void (*xpc_teardown_partitions_sn) (void);
 enum xp_retval (*xpc_get_partition_rsvd_page_pa) (void *buf, u64 *cookie,
 						  unsigned long *rp_pa,
 						  size_t *len);
@@ -217,8 +218,8 @@ void (*xpc_send_chctl_openrequest) (stru
 void (*xpc_send_chctl_openreply) (struct xpc_channel *ch,
 				  unsigned long *irq_flags);
 
-void (*xpc_save_remote_msgqueue_pa) (struct xpc_channel *ch,
-				     unsigned long msgqueue_pa);
+enum xp_retval (*xpc_save_remote_msgqueue_pa) (struct xpc_channel *ch,
+					       unsigned long msgqueue_pa);
 
 enum xp_retval (*xpc_send_payload) (struct xpc_channel *ch, u32 flags,
 				    void *payload, u16 payload_size,
@@ -998,6 +999,7 @@ xpc_setup_partitions(void)
 static void
 xpc_teardown_partitions(void)
 {
+	xpc_teardown_partitions_sn();
 	kfree(xpc_partitions);
 }
 
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -66,6 +66,12 @@ xpc_setup_partitions_sn_sn2(void)
 	return 0;
 }
 
+static void
+xpc_teardown_partitions_sn_sn2(void)
+{
+	/* nothing needs to be done */
+}
+
 /* SH_IPI_ACCESS shub register value on startup */
 static u64 xpc_sh1_IPI_access_sn2;
 static u64 xpc_sh2_IPI_access0_sn2;
@@ -436,11 +442,12 @@ xpc_send_chctl_local_msgrequest_sn2(stru
 	XPC_SEND_LOCAL_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_MSGREQUEST);
 }
 
-static void
+static enum xp_retval
 xpc_save_remote_msgqueue_pa_sn2(struct xpc_channel *ch,
 				unsigned long msgqueue_pa)
 {
 	ch->sn.sn2.remote_msgqueue_pa = msgqueue_pa;
+	return xpSuccess;
 }
 
 /*
@@ -2315,6 +2322,7 @@ xpc_init_sn2(void)
 	size_t buf_size;
 
 	xpc_setup_partitions_sn = xpc_setup_partitions_sn_sn2;
+	xpc_teardown_partitions_sn = xpc_teardown_partitions_sn_sn2;
 	xpc_get_partition_rsvd_page_pa = xpc_get_partition_rsvd_page_pa_sn2;
 	xpc_setup_rsvd_page_sn = xpc_setup_rsvd_page_sn_sn2;
 	xpc_increment_heartbeat = xpc_increment_heartbeat_sn2;
diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-gru-add-support-to-the-gru-driver-for-message-queue-interrupts
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -31,6 +31,21 @@
 #include "../sgi-gru/grukservices.h"
 #include "xpc.h"
 
+#if defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
+struct uv_IO_APIC_route_entry {
+	__u64	vector		:  8,
+		delivery_mode	:  3,
+		dest_mode	:  1,
+		delivery_status	:  1,
+		polarity	:  1,
+		__reserved_1	:  1,
+		trigger		:  1,
+		mask		:  1,
+		__reserved_2	: 15,
+		dest		: 32;
+};
+#endif
+
 static atomic64_t xpc_heartbeat_uv;
 static DECLARE_BITMAP(xpc_heartbeating_to_mask_uv, XP_MAX_NPARTITIONS_UV);
 
@@ -56,26 +71,52 @@ xpc_setup_partitions_sn_uv(void)
 	for (partid = 0; partid < XP_MAX_NPARTITIONS_UV; partid++) {
 		part_uv = &xpc_partitions[partid].sn.uv;
 
+		mutex_init(&part_uv->cached_activate_gru_mq_desc_mutex);
 		spin_lock_init(&part_uv->flags_lock);
 		part_uv->remote_act_state = XPC_P_AS_INACTIVE;
 	}
 	return 0;
 }
 
+static void
+xpc_teardown_partitions_sn_uv(void)
+{
+	short partid;
+	struct xpc_partition_uv *part_uv;
+	unsigned long irq_flags;
+
+	for (partid = 0; partid < XP_MAX_NPARTITIONS_UV; partid++) {
+		part_uv = &xpc_partitions[partid].sn.uv;
+
+		if (part_uv->cached_activate_gru_mq_desc != NULL) {
+			mutex_lock(&part_uv->cached_activate_gru_mq_desc_mutex);
+			spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
+			part_uv->flags &= ~XPC_P_CACHED_ACTIVATE_GRU_MQ_DESC_UV;
+			spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
+			kfree(part_uv->cached_activate_gru_mq_desc);
+			part_uv->cached_activate_gru_mq_desc = NULL;
+			mutex_unlock(&part_uv->
+				     cached_activate_gru_mq_desc_mutex);
+		}
+	}
+}
+
 static int
 xpc_get_gru_mq_irq_uv(struct xpc_gru_mq_uv *mq, int cpu, char *irq_name)
 {
+	int mmr_pnode = uv_blade_to_pnode(mq->mmr_blade);
+
 #if defined CONFIG_X86_64
 	mq->irq = uv_setup_irq(irq_name, cpu, mq->mmr_blade, mq->mmr_offset);
 	if (mq->irq < 0) {
 		dev_err(xpc_part, "uv_setup_irq() returned error=%d\n",
-			mq->irq);
+			-mq->irq);
+		return mq->irq;
 	}
 
-#elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
-	int mmr_pnode;
-	unsigned long mmr_value;
+	mq->mmr_value = uv_read_global_mmr64(mmr_pnode, mq->mmr_offset);
 
+#elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
 	if (strcmp(irq_name, XPC_ACTIVATE_IRQ_NAME) == 0)
 		mq->irq = SGI_XPC_ACTIVATE;
 	else if (strcmp(irq_name, XPC_NOTIFY_IRQ_NAME) == 0)
@@ -83,10 +124,8 @@ xpc_get_gru_mq_irq_uv(struct xpc_gru_mq_
 	else
 		return -EINVAL;
 
-	mmr_pnode = uv_blade_to_pnode(mq->mmr_blade);
-	mmr_value = (unsigned long)cpu_physical_id(cpu) << 32 | mq->irq;
-
-	uv_write_global_mmr64(mmr_pnode, mq->mmr_offset, mmr_value);
+	mq->mmr_value = (unsigned long)cpu_physical_id(cpu) << 32 | mq->irq;
+	uv_write_global_mmr64(mmr_pnode, mq->mmr_offset, mq->mmr_value);
 #else
 	#error not a supported configuration
 #endif
@@ -127,7 +166,7 @@ xpc_gru_mq_watchlist_alloc_uv(struct xpc
 		return ret;
 	}
 #elif defined CONFIG_IA64_GENERIC || defined CONFIG_IA64_SGI_UV
-	ret = sn_mq_watchlist_alloc(mq->mmr_blade, uv_gpa(mq->address),
+	ret = sn_mq_watchlist_alloc(mq->mmr_blade, (void *)uv_gpa(mq->address),
 				    mq->order, &mq->mmr_offset);
 	if (ret < 0) {
 		dev_err(xpc_part, "sn_mq_watchlist_alloc() failed, ret=%d\n",
@@ -168,12 +207,22 @@ xpc_create_gru_mq_uv(unsigned int mq_siz
 	int pg_order;
 	struct page *page;
 	struct xpc_gru_mq_uv *mq;
+	struct uv_IO_APIC_route_entry *mmr_value;
 
 	mq = kmalloc(sizeof(struct xpc_gru_mq_uv), GFP_KERNEL);
 	if (mq == NULL) {
 		dev_err(xpc_part, "xpc_create_gru_mq_uv() failed to kmalloc() "
 			"a xpc_gru_mq_uv structure\n");
 		ret = -ENOMEM;
+		goto out_0;
+	}
+
+	mq->gru_mq_desc = kzalloc(sizeof(struct gru_message_queue_desc),
+				  GFP_KERNEL);
+	if (mq->gru_mq_desc == NULL) {
+		dev_err(xpc_part, "xpc_create_gru_mq_uv() failed to kmalloc() "
+			"a gru_message_queue_desc structure\n");
+		ret = -ENOMEM;
 		goto out_1;
 	}
 
@@ -194,14 +243,6 @@ xpc_create_gru_mq_uv(unsigned int mq_siz
 	}
 	mq->address = page_address(page);
 
-	ret = gru_create_message_queue(mq->address, mq_size);
-	if (ret != 0) {
-		dev_err(xpc_part, "gru_create_message_queue() returned "
-			"error=%d\n", ret);
-		ret = -EINVAL;
-		goto out_3;
-	}
-
 	/* enable generation of irq when GRU mq operation occurs to this mq */
 	ret = xpc_gru_mq_watchlist_alloc_uv(mq);
 	if (ret != 0)
@@ -214,10 +255,20 @@ xpc_create_gru_mq_uv(unsigned int mq_siz
 	ret = request_irq(mq->irq, irq_handler, 0, irq_name, NULL);
 	if (ret != 0) {
 		dev_err(xpc_part, "request_irq(irq=%d) returned error=%d\n",
-			mq->irq, ret);
+			mq->irq, -ret);
 		goto out_5;
 	}
 
+	mmr_value = (struct uv_IO_APIC_route_entry *)&mq->mmr_value;
+	ret = gru_create_message_queue(mq->gru_mq_desc, mq->address, mq_size,
+				       nid, mmr_value->vector, mmr_value->dest);
+	if (ret != 0) {
+		dev_err(xpc_part, "gru_create_message_queue() returned "
+			"error=%d\n", ret);
+		ret = -EINVAL;
+		goto out_6;
+	}
+
 	/* allow other partitions to access this GRU mq */
 	xp_ret = xp_expand_memprotect(xp_pa(mq->address), mq_size);
 	if (xp_ret != xpSuccess) {
@@ -237,8 +288,10 @@ out_4:
 out_3:
 	free_pages((unsigned long)mq->address, pg_order);
 out_2:
-	kfree(mq);
+	kfree(mq->gru_mq_desc);
 out_1:
+	kfree(mq);
+out_0:
 	return ERR_PTR(ret);
 }
 
@@ -268,13 +321,14 @@ xpc_destroy_gru_mq_uv(struct xpc_gru_mq_
 }
 
 static enum xp_retval
-xpc_send_gru_msg(unsigned long mq_gpa, void *msg, size_t msg_size)
+xpc_send_gru_msg(struct gru_message_queue_desc *gru_mq_desc, void *msg,
+		 size_t msg_size)
 {
 	enum xp_retval xp_ret;
 	int ret;
 
 	while (1) {
-		ret = gru_send_message_gpa(mq_gpa, msg, msg_size);
+		ret = gru_send_message_gpa(gru_mq_desc, msg, msg_size);
 		if (ret == MQE_OK) {
 			xp_ret = xpSuccess;
 			break;
@@ -421,7 +475,15 @@ xpc_handle_activate_mq_msg_uv(struct xpc
 		part_uv->act_state_req = XPC_P_ASR_ACTIVATE_UV;
 		part->remote_rp_pa = msg->rp_gpa; /* !!! _pa is _gpa */
 		part->remote_rp_ts_jiffies = msg_hdr->rp_ts_jiffies;
-		part_uv->remote_activate_mq_gpa = msg->activate_mq_gpa;
+
+		if (msg->activate_gru_mq_desc_gpa !=
+		    part_uv->activate_gru_mq_desc_gpa) {
+			spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
+			part_uv->flags &= ~XPC_P_CACHED_ACTIVATE_GRU_MQ_DESC_UV;
+			spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
+			part_uv->activate_gru_mq_desc_gpa =
+			    msg->activate_gru_mq_desc_gpa;
+		}
 		spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock, irq_flags);
 
 		(*wakeup_hb_checker)++;
@@ -498,7 +560,7 @@ xpc_handle_activate_mq_msg_uv(struct xpc
 		args = &part->remote_openclose_args[msg->ch_number];
 		args->remote_nentries = msg->remote_nentries;
 		args->local_nentries = msg->local_nentries;
-		args->local_msgqueue_pa = msg->local_notify_mq_gpa;
+		args->local_msgqueue_pa = msg->notify_gru_mq_desc_gpa;
 
 		spin_lock_irqsave(&part->chctl_lock, irq_flags);
 		part->chctl.flags[msg->ch_number] |= XPC_CHCTL_OPENREPLY;
@@ -558,9 +620,10 @@ xpc_handle_activate_IRQ_uv(int irq, void
 	short partid;
 	struct xpc_partition *part;
 	int wakeup_hb_checker = 0;
+	int part_referenced;
 
 	while (1) {
-		msg_hdr = gru_get_next_message(xpc_activate_mq_uv->address);
+		msg_hdr = gru_get_next_message(xpc_activate_mq_uv->gru_mq_desc);
 		if (msg_hdr == NULL)
 			break;
 
@@ -571,14 +634,15 @@ xpc_handle_activate_IRQ_uv(int irq, void
 				partid);
 		} else {
 			part = &xpc_partitions[partid];
-			if (xpc_part_ref(part)) {
-				xpc_handle_activate_mq_msg_uv(part, msg_hdr,
-							    &wakeup_hb_checker);
+
+			part_referenced = xpc_part_ref(part);
+			xpc_handle_activate_mq_msg_uv(part, msg_hdr,
+						      &wakeup_hb_checker);
+			if (part_referenced)
 				xpc_part_deref(part);
-			}
 		}
 
-		gru_free_message(xpc_activate_mq_uv->address, msg_hdr);
+		gru_free_message(xpc_activate_mq_uv->gru_mq_desc, msg_hdr);
 	}
 
 	if (wakeup_hb_checker)
@@ -588,21 +652,73 @@ xpc_handle_activate_IRQ_uv(int irq, void
 }
 
 static enum xp_retval
+xpc_cache_remote_gru_mq_desc_uv(struct gru_message_queue_desc *gru_mq_desc,
+				unsigned long gru_mq_desc_gpa)
+{
+	enum xp_retval ret;
+
+	ret = xp_remote_memcpy(uv_gpa(gru_mq_desc), gru_mq_desc_gpa,
+			       sizeof(struct gru_message_queue_desc));
+	if (ret == xpSuccess)
+		gru_mq_desc->mq = NULL;
+
+	return ret;
+}
+
+static enum xp_retval
 xpc_send_activate_IRQ_uv(struct xpc_partition *part, void *msg, size_t msg_size,
 			 int msg_type)
 {
 	struct xpc_activate_mq_msghdr_uv *msg_hdr = msg;
+	struct xpc_partition_uv *part_uv = &part->sn.uv;
+	struct gru_message_queue_desc *gru_mq_desc;
+	unsigned long irq_flags;
+	enum xp_retval ret;
 
 	DBUG_ON(msg_size > XPC_ACTIVATE_MSG_SIZE_UV);
 
 	msg_hdr->type = msg_type;
-	msg_hdr->partid = XPC_PARTID(part);
+	msg_hdr->partid = xp_partition_id;
 	msg_hdr->act_state = part->act_state;
 	msg_hdr->rp_ts_jiffies = xpc_rsvd_page->ts_jiffies;
 
+	mutex_lock(&part_uv->cached_activate_gru_mq_desc_mutex);
+again:
+	if (!(part_uv->flags & XPC_P_CACHED_ACTIVATE_GRU_MQ_DESC_UV)) {
+		gru_mq_desc = part_uv->cached_activate_gru_mq_desc;
+		if (gru_mq_desc == NULL) {
+			gru_mq_desc = kmalloc(sizeof(struct
+					      gru_message_queue_desc),
+					      GFP_KERNEL);
+			if (gru_mq_desc == NULL) {
+				ret = xpNoMemory;
+				goto done;
+			}
+			part_uv->cached_activate_gru_mq_desc = gru_mq_desc;
+		}
+
+		ret = xpc_cache_remote_gru_mq_desc_uv(gru_mq_desc,
+						      part_uv->
+						      activate_gru_mq_desc_gpa);
+		if (ret != xpSuccess)
+			goto done;
+
+		spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
+		part_uv->flags |= XPC_P_CACHED_ACTIVATE_GRU_MQ_DESC_UV;
+		spin_unlock_irqrestore(&part_uv->flags_lock, irq_flags);
+	}
+
 	/* ??? Is holding a spin_lock (ch->lock) during this call a bad idea? */
-	return xpc_send_gru_msg(part->sn.uv.remote_activate_mq_gpa, msg,
-				msg_size);
+	ret = xpc_send_gru_msg(part_uv->cached_activate_gru_mq_desc, msg,
+			       msg_size);
+	if (ret != xpSuccess) {
+		smp_rmb();	/* ensure a fresh copy of part_uv->flags */
+		if (!(part_uv->flags & XPC_P_CACHED_ACTIVATE_GRU_MQ_DESC_UV))
+			goto again;
+	}
+done:
+	mutex_unlock(&part_uv->cached_activate_gru_mq_desc_mutex);
+	return ret;
 }
 
 static void
@@ -620,7 +736,7 @@ static void
 xpc_send_activate_IRQ_ch_uv(struct xpc_channel *ch, unsigned long *irq_flags,
 			 void *msg, size_t msg_size, int msg_type)
 {
-	struct xpc_partition *part = &xpc_partitions[ch->number];
+	struct xpc_partition *part = &xpc_partitions[ch->partid];
 	enum xp_retval ret;
 
 	ret = xpc_send_activate_IRQ_uv(part, msg, msg_size, msg_type);
@@ -692,7 +808,8 @@ xpc_get_partition_rsvd_page_pa_uv(void *
 static int
 xpc_setup_rsvd_page_sn_uv(struct xpc_rsvd_page *rp)
 {
-	rp->sn.activate_mq_gpa = uv_gpa(xpc_activate_mq_uv->address);
+	rp->sn.activate_gru_mq_desc_gpa =
+	    uv_gpa(xpc_activate_mq_uv->gru_mq_desc);
 	return 0;
 }
 
@@ -787,7 +904,8 @@ xpc_request_partition_activation_uv(stru
 
 	part->remote_rp_pa = remote_rp_gpa; /* !!! _pa here is really _gpa */
 	part->remote_rp_ts_jiffies = remote_rp->ts_jiffies;
-	part->sn.uv.remote_activate_mq_gpa = remote_rp->sn.activate_mq_gpa;
+	part->sn.uv.activate_gru_mq_desc_gpa =
+	    remote_rp->sn.activate_gru_mq_desc_gpa;
 
 	/*
 	 * ??? Is it a good idea to make this conditional on what is
@@ -795,7 +913,8 @@ xpc_request_partition_activation_uv(stru
 	 */
 	if (part->sn.uv.remote_act_state == XPC_P_AS_INACTIVE) {
 		msg.rp_gpa = uv_gpa(xpc_rsvd_page);
-		msg.activate_mq_gpa = xpc_rsvd_page->sn.activate_mq_gpa;
+		msg.activate_gru_mq_desc_gpa =
+		    xpc_rsvd_page->sn.activate_gru_mq_desc_gpa;
 		xpc_send_activate_IRQ_part_uv(part, &msg, sizeof(msg),
 					   XPC_ACTIVATE_MQ_MSG_ACTIVATE_REQ_UV);
 	}
@@ -857,7 +976,8 @@ xpc_get_fifo_entry_uv(struct xpc_fifo_he
 		if (head->first == NULL)
 			head->last = NULL;
 	}
-	head->n_entries++;
+	head->n_entries--;
+	BUG_ON(head->n_entries < 0);
 	spin_unlock_irqrestore(&head->lock, irq_flags);
 	first->next = NULL;
 	return first;
@@ -876,8 +996,7 @@ xpc_put_fifo_entry_uv(struct xpc_fifo_he
 	else
 		head->first = last;
 	head->last = last;
-	head->n_entries--;
-	BUG_ON(head->n_entries < 0);
+	head->n_entries++;
 	spin_unlock_irqrestore(&head->lock, irq_flags);
 }
 
@@ -1037,6 +1156,12 @@ xpc_setup_msg_structures_uv(struct xpc_c
 
 	DBUG_ON(ch->flags & XPC_C_SETUP);
 
+	ch_uv->cached_notify_gru_mq_desc = kmalloc(sizeof(struct
+						   gru_message_queue_desc),
+						   GFP_KERNEL);
+	if (ch_uv->cached_notify_gru_mq_desc == NULL)
+		return xpNoMemory;
+
 	ret = xpc_allocate_send_msg_slot_uv(ch);
 	if (ret == xpSuccess) {
 
@@ -1060,7 +1185,8 @@ xpc_teardown_msg_structures_uv(struct xp
 
 	DBUG_ON(!spin_is_locked(&ch->lock));
 
-	ch_uv->remote_notify_mq_gpa = 0;
+	kfree(ch_uv->cached_notify_gru_mq_desc);
+	ch_uv->cached_notify_gru_mq_desc = NULL;
 
 	if (ch->flags & XPC_C_SETUP) {
 		xpc_init_fifo_uv(&ch_uv->msg_slot_free_list);
@@ -1111,7 +1237,7 @@ xpc_send_chctl_openreply_uv(struct xpc_c
 	msg.ch_number = ch->number;
 	msg.local_nentries = ch->local_nentries;
 	msg.remote_nentries = ch->remote_nentries;
-	msg.local_notify_mq_gpa = uv_gpa(xpc_notify_mq_uv);
+	msg.notify_gru_mq_desc_gpa = uv_gpa(xpc_notify_mq_uv->gru_mq_desc);
 	xpc_send_activate_IRQ_ch_uv(ch, irq_flags, &msg, sizeof(msg),
 				    XPC_ACTIVATE_MQ_MSG_CHCTL_OPENREPLY_UV);
 }
@@ -1128,11 +1254,15 @@ xpc_send_chctl_local_msgrequest_uv(struc
 	xpc_wakeup_channel_mgr(part);
 }
 
-static void
+static enum xp_retval
 xpc_save_remote_msgqueue_pa_uv(struct xpc_channel *ch,
-			       unsigned long msgqueue_pa)
+			       unsigned long gru_mq_desc_gpa)
 {
-	ch->sn.uv.remote_notify_mq_gpa = msgqueue_pa;
+	struct xpc_channel_uv *ch_uv = &ch->sn.uv;
+
+	DBUG_ON(ch_uv->cached_notify_gru_mq_desc == NULL);
+	return xpc_cache_remote_gru_mq_desc_uv(ch_uv->cached_notify_gru_mq_desc,
+					       gru_mq_desc_gpa);
 }
 
 static void
@@ -1339,7 +1469,8 @@ xpc_handle_notify_IRQ_uv(int irq, void *
 	short partid;
 	struct xpc_partition *part;
 
-	while ((msg = gru_get_next_message(xpc_notify_mq_uv)) != NULL) {
+	while ((msg = gru_get_next_message(xpc_notify_mq_uv->gru_mq_desc)) !=
+	       NULL) {
 
 		partid = msg->hdr.partid;
 		if (partid < 0 || partid >= XP_MAX_NPARTITIONS_UV) {
@@ -1354,7 +1485,7 @@ xpc_handle_notify_IRQ_uv(int irq, void *
 			}
 		}
 
-		gru_free_message(xpc_notify_mq_uv, msg);
+		gru_free_message(xpc_notify_mq_uv->gru_mq_desc, msg);
 	}
 
 	return IRQ_HANDLED;
@@ -1438,7 +1569,8 @@ xpc_send_payload_uv(struct xpc_channel *
 	msg->hdr.msg_slot_number = msg_slot->msg_slot_number;
 	memcpy(&msg->payload, payload, payload_size);
 
-	ret = xpc_send_gru_msg(ch->sn.uv.remote_notify_mq_gpa, msg, msg_size);
+	ret = xpc_send_gru_msg(ch->sn.uv.cached_notify_gru_mq_desc, msg,
+			       msg_size);
 	if (ret == xpSuccess)
 		goto out_1;
 
@@ -1529,7 +1661,7 @@ xpc_received_payload_uv(struct xpc_chann
 	msg->hdr.partid = xp_partition_id;
 	msg->hdr.size = 0;	/* size of zero indicates this is an ACK */
 
-	ret = xpc_send_gru_msg(ch->sn.uv.remote_notify_mq_gpa, msg,
+	ret = xpc_send_gru_msg(ch->sn.uv.cached_notify_gru_mq_desc, msg,
 			       sizeof(struct xpc_notify_mq_msghdr_uv));
 	if (ret != xpSuccess)
 		XPC_DEACTIVATE_PARTITION(&xpc_partitions[ch->partid], ret);
@@ -1541,6 +1673,7 @@ int
 xpc_init_uv(void)
 {
 	xpc_setup_partitions_sn = xpc_setup_partitions_sn_uv;
+	xpc_teardown_partitions_sn = xpc_teardown_partitions_sn_uv;
 	xpc_process_activate_IRQ_rcvd = xpc_process_activate_IRQ_rcvd_uv;
 	xpc_get_partition_rsvd_page_pa = xpc_get_partition_rsvd_page_pa_uv;
 	xpc_setup_rsvd_page_sn = xpc_setup_rsvd_page_sn_uv;
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

