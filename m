From: akpm@linux-foundation.org
Subject: - hptiop-add-more-adapter-models-and-other-fixes-update.patch removed from -mm tree
Date: Thu, 13 Dec 2007 16:12:35 -0800
Message-ID: <200712140012.lBE0CaJw026041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41540 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895AbXLNAMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 19:12:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@highpoint-tech.com, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     hptiop: add more adapter models and other fixes (update)
has been removed from the -mm tree.  Its filename was
     hptiop-add-more-adapter-models-and-other-fixes-update.patch

This patch was dropped because it was folded into hptiop-add-more-adapter-models-and-other-fixes.patch

------------------------------------------------------
Subject: hptiop: add more adapter models and other fixes (update)
From: HighPoint Linux Team <linux@highpoint-tech.com>

There is still a problem in the patch (scp->resid should be changed to use
scsi_set_resid() in current tree).

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hptiop.c |   20 ++++++++++----------
 drivers/scsi/hptiop.h |   33 +++++++++++----------------------
 2 files changed, 21 insertions(+), 32 deletions(-)

diff -puN drivers/scsi/hptiop.c~hptiop-add-more-adapter-models-and-other-fixes-update drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c~hptiop-add-more-adapter-models-and-other-fixes-update
+++ a/drivers/scsi/hptiop.c
@@ -77,7 +77,7 @@ static int iop_wait_ready_mv(struct hpti
 	return iop_send_sync_msg(hba, IOPMU_INBOUND_MSG0_NOP, millisec);
 }
 
-static inline void hptiop_request_callback_itl(struct hptiop_hba *hba, u32 tag)
+static void hptiop_request_callback_itl(struct hptiop_hba *hba, u32 tag)
 {
 	if (tag & IOPMU_QUEUE_ADDR_HOST_BIT)
 		hptiop_host_request_callback_itl(hba,
@@ -86,7 +86,7 @@ static inline void hptiop_request_callba
 		hptiop_iop_request_callback_itl(hba, tag);
 }
 
-static inline void hptiop_drain_outbound_queue_itl(struct hptiop_hba *hba)
+static void hptiop_drain_outbound_queue_itl(struct hptiop_hba *hba)
 {
 	u32 req;
 
@@ -138,7 +138,7 @@ static int iop_intr_itl(struct hptiop_hb
 	return ret;
 }
 
-static inline u64 mv_outbound_read(struct hpt_iopmu_mv __iomem *mu)
+static u64 mv_outbound_read(struct hpt_iopmu_mv __iomem *mu)
 {
 	u32 outbound_tail = readl(&mu->outbound_tail);
 	u32 outbound_head = readl(&mu->outbound_head);
@@ -157,7 +157,7 @@ static inline u64 mv_outbound_read(struc
 		return 0;
 }
 
-static inline void mv_inbound_write(u64 p, struct hptiop_hba *hba)
+static void mv_inbound_write(u64 p, struct hptiop_hba *hba)
 {
 	u32 inbound_head = readl(&hba->u.mv.mu->inbound_head);
 	u32 head = inbound_head + 1;
@@ -510,7 +510,7 @@ static void hptiop_message_callback(stru
 		hba->msg_done = 1;
 }
 
-static inline struct hptiop_request *get_req(struct hptiop_hba *hba)
+static struct hptiop_request *get_req(struct hptiop_hba *hba)
 {
 	struct hptiop_request *ret;
 
@@ -523,7 +523,7 @@ static inline struct hptiop_request *get
 	return ret;
 }
 
-static inline void free_req(struct hptiop_hba *hba, struct hptiop_request *req)
+static void free_req(struct hptiop_hba *hba, struct hptiop_request *req)
 {
 	dprintk("free_req(%d, %p)\n", req->index, req);
 	req->next = hba->req_list;
@@ -550,8 +550,8 @@ static void hptiop_finish_scsi_req(struc
 
 	switch (le32_to_cpu(req->header.result)) {
 	case IOP_RESULT_SUCCESS:
-		scp->resid = scsi_bufflen(scp) -
-			le32_to_cpu(req->dataxfer_length);
+		scsi_set_resid(scp,
+			scsi_bufflen(scp) - le32_to_cpu(req->dataxfer_length));
 		scp->result = (DID_OK<<16);
 		break;
 	case IOP_RESULT_BAD_TARGET:
@@ -570,8 +570,8 @@ static void hptiop_finish_scsi_req(struc
 		scp->result = (DID_ABORT<<16);
 		break;
 	case IOP_RESULT_CHECK_CONDITION:
-		scp->resid = scsi_bufflen(scp) -
-			le32_to_cpu(req->dataxfer_length);
+		scsi_set_resid(scp,
+			scsi_bufflen(scp) - le32_to_cpu(req->dataxfer_length));
 		scp->result = SAM_STAT_CHECK_CONDITION;
 		memcpy(&scp->sense_buffer, &req->sg_list,
 				min(sizeof(scp->sense_buffer),
diff -puN drivers/scsi/hptiop.h~hptiop-add-more-adapter-models-and-other-fixes-update drivers/scsi/hptiop.h
--- a/drivers/scsi/hptiop.h~hptiop-add-more-adapter-models-and-other-fixes-update
+++ a/drivers/scsi/hptiop.h
@@ -18,8 +18,7 @@
 #ifndef _HPTIOP_H_
 #define _HPTIOP_H_
 
-struct hpt_iopmu_itl
-{
+struct hpt_iopmu_itl {
 	__le32 resrved0[4];
 	__le32 inbound_msgaddr0;
 	__le32 inbound_msgaddr1;
@@ -56,8 +55,7 @@ struct hpt_iopmu_itl
 
 #define MVIOP_QUEUE_LEN  512
 
-struct hpt_iopmu_mv
-{
+struct hpt_iopmu_mv {
 	__le32 inbound_head;
 	__le32 inbound_tail;
 	__le32 outbound_head;
@@ -69,8 +67,7 @@ struct hpt_iopmu_mv
 	__le64 outbound_q[MVIOP_QUEUE_LEN];
 };
 
-struct hpt_iopmv_regs
-{
+struct hpt_iopmv_regs {
 	__le32 reserved[0x20400 / 4];
 	__le32 inbound_doorbell;
 	__le32 inbound_intmask;
@@ -108,8 +105,7 @@ enum hpt_iopmu_message {
 	IOPMU_OUTBOUND_MSG0_REVALIDATE_DEVICE_MAX = 0x3ff,
 };
 
-struct hpt_iop_request_header
-{
+struct hpt_iop_request_header {
 	__le32 size;
 	__le32 type;
 	__le32 flags;
@@ -143,8 +139,7 @@ enum hpt_iop_result_type {
 	IOP_RESULT_CHECK_CONDITION,
 };
 
-struct hpt_iop_request_get_config
-{
+struct hpt_iop_request_get_config {
 	struct hpt_iop_request_header header;
 	__le32 interface_version;
 	__le32 firmware_version;
@@ -157,8 +152,7 @@ struct hpt_iop_request_get_config
 	__le32 sdram_size;
 };
 
-struct hpt_iop_request_set_config
-{
+struct hpt_iop_request_set_config {
 	struct hpt_iop_request_header header;
 	__le32 iop_id;
 	__le16 vbus_id;
@@ -166,15 +160,13 @@ struct hpt_iop_request_set_config
 	__le32 reserve[6];
 };
 
-struct hpt_iopsg
-{
+struct hpt_iopsg {
 	__le32 size;
 	__le32 eot; /* non-zero: end of table */
 	__le64 pci_address;
 };
 
-struct hpt_iop_request_block_command
-{
+struct hpt_iop_request_block_command {
 	struct hpt_iop_request_header header;
 	u8     channel;
 	u8     target;
@@ -192,8 +184,7 @@ struct hpt_iop_request_block_command
 #define IOP_BLOCK_COMMAND_FLUSH    4
 #define IOP_BLOCK_COMMAND_SHUTDOWN 5
 
-struct hpt_iop_request_scsi_command
-{
+struct hpt_iop_request_scsi_command {
 	struct hpt_iop_request_header header;
 	u8     channel;
 	u8     target;
@@ -204,8 +195,7 @@ struct hpt_iop_request_scsi_command
 	struct hpt_iopsg sg_list[1];
 };
 
-struct hpt_iop_request_ioctl_command
-{
+struct hpt_iop_request_ioctl_command {
 	struct hpt_iop_request_header header;
 	__le32 ioctl_code;
 	__le32 inbuf_size;
@@ -279,8 +269,7 @@ struct hptiop_hba {
 	wait_queue_head_t ioctl_wq;
 };
 
-struct hpt_ioctl_k
-{
+struct hpt_ioctl_k {
 	struct hptiop_hba * hba;
 	u32    ioctl_code;
 	u32    inbuf_size;
_

Patches currently in -mm which might be from linux@highpoint-tech.com are

hptiop-add-more-adapter-models-and-other-fixes.patch
hptiop-add-more-adapter-models-and-other-fixes-update.patch
hptiop-add-more-adapter-models-and-other-fixes-fix-2.patch
