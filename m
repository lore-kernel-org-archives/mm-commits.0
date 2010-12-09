From: akpm@linux-foundation.org
Subject: + memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc.patch added to -mm tree
Date: Thu, 09 Dec 2010 12:14:30 -0800
Message-ID: <201012092014.oB9KEU9R004586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757017Ab0LIUPD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 15:15:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oakad@yahoo.com


The patch titled
     memstick: factor out transfer initiating functionality in mspro_block.c
has been added to the -mm tree.  Its filename is
     memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: factor out transfer initiating functionality in mspro_block.c
From: Alex Dubov <oakad@yahoo.com>

Apart from currently used standard memstick data transfer method, Sony
introduced several newer ones, to uncover full bandwidth/capacity of its
Pro, HG and XC media formats. This patch lays a foundation to enable
those methods as made possible by host/media capabilities.

As a side effect of this patch, mspro_block_read_attributes became more
streamlined and readable.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |  138 ++++++++++++++------------
 1 file changed, 75 insertions(+), 63 deletions(-)

diff -puN drivers/memstick/core/mspro_block.c~memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc
+++ a/drivers/memstick/core/mspro_block.c
@@ -159,6 +159,13 @@ struct mspro_block_data {
 	int                   (*mrq_handler)(struct memstick_dev *card,
 					     struct memstick_request **mrq);
 
+
+	/* Default request setup function for data access method preferred by
+	 * this host instance.
+	 */
+	void                  (*setup_transfer)(struct memstick_dev *card,
+						u64 offset, size_t length);
+
 	struct attribute_group attr_group;
 
 	struct scatterlist    req_sg[MSPRO_BLOCK_MAX_SEGS];
@@ -656,14 +663,43 @@ has_int_reg:
 	}
 }
 
+/*** Transfer setup functions for different access methods. ***/
+
+/** Setup data transfer request for SET_CMD TPC with arguments in card
+ *  registers.
+ *
+ *  @card    Current media instance
+ *  @offset  Target data offset in bytes
+ *  @length  Required transfer length in bytes.
+ */
+static void h_mspro_block_setup_cmd(struct memstick_dev *card, u64 offset,
+				    size_t length)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	struct mspro_param_register param = {
+		.system = msb->system,
+		.data_count = cpu_to_be16((uint16_t)(length / msb->page_size)),
+		/* ISO C90 warning precludes direct initialization for now. */
+		.data_address = 0,
+		.tpc_param = 0
+	};
+
+	do_div(offset, msb->page_size);
+	param.data_address = cpu_to_be32((uint32_t)offset);
+
+	card->next_request = h_mspro_block_req_init;
+	msb->mrq_handler = h_mspro_block_transfer_data;
+	memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG,
+			  &param, sizeof(param));
+}
+
 /*** Data transfer ***/
 
 static int mspro_block_issue_req(struct memstick_dev *card, int chunk)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	sector_t t_sec;
+	u64 t_off;
 	unsigned int count;
-	struct mspro_param_register param;
 
 try_again:
 	while (chunk) {
@@ -678,30 +714,17 @@ try_again:
 			continue;
 		}
 
-		t_sec = blk_rq_pos(msb->block_req) << 9;
-		sector_div(t_sec, msb->page_size);
-
+		t_off = blk_rq_pos(msb->block_req);
+		t_off <<= 9;
 		count = blk_rq_bytes(msb->block_req);
-		count /= msb->page_size;
 
-		param.system = msb->system;
-		param.data_count = cpu_to_be16(count);
-		param.data_address = cpu_to_be32((uint32_t)t_sec);
-		param.tpc_param = 0;
+		msb->setup_transfer(card, t_off, count);
 
 		msb->data_dir = rq_data_dir(msb->block_req);
 		msb->transfer_cmd = msb->data_dir == READ
 				    ? MSPRO_CMD_READ_DATA
 				    : MSPRO_CMD_WRITE_DATA;
 
-		dev_dbg(&card->dev, "data transfer: cmd %x, "
-			"lba %x, count %x\n", msb->transfer_cmd,
-			be32_to_cpu(param.data_address), count);
-
-		card->next_request = h_mspro_block_req_init;
-		msb->mrq_handler = h_mspro_block_transfer_data;
-		memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG,
-				  &param, sizeof(param));
 		memstick_new_req(card->host);
 		return 0;
 	}
@@ -956,18 +979,16 @@ try_again:
 static int mspro_block_read_attributes(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
-	struct mspro_param_register param = {
-		.system = msb->system,
-		.data_count = cpu_to_be16(1),
-		.data_address = 0,
-		.tpc_param = 0
-	};
 	struct mspro_attribute *attr = NULL;
 	struct mspro_sys_attr *s_attr = NULL;
 	unsigned char *buffer = NULL;
 	int cnt, rc, attr_count;
-	unsigned int addr;
-	unsigned short page_count;
+	/* While normally physical device offsets, represented here by
+	 * attr_offset and attr_len will be of large numeric types, we can be
+	 * sure, that attributes are close enough to the beginning of the
+	 * device, to save ourselves some trouble.
+	 */
+	unsigned int addr, attr_offset = 0, attr_len = msb->page_size;
 
 	attr = kmalloc(msb->page_size, GFP_KERNEL);
 	if (!attr)
@@ -980,10 +1001,8 @@ static int mspro_block_read_attributes(s
 	msb->data_dir = READ;
 	msb->transfer_cmd = MSPRO_CMD_READ_ATRB;
 
-	card->next_request = h_mspro_block_req_init;
-	msb->mrq_handler = h_mspro_block_transfer_data;
-	memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG, &param,
-			  sizeof(param));
+	msb->setup_transfer(card, attr_offset, attr_len);
+
 	memstick_new_req(card->host);
 	wait_for_completion(&card->mrq_complete);
 	if (card->current_mrq.error) {
@@ -1014,13 +1033,12 @@ static int mspro_block_read_attributes(s
 	}
 	msb->attr_group.name = "media_attributes";
 
-	buffer = kmalloc(msb->page_size, GFP_KERNEL);
+	buffer = kmalloc(attr_len, GFP_KERNEL);
 	if (!buffer) {
 		rc = -ENOMEM;
 		goto out_free_attr;
 	}
-	memcpy(buffer, (char *)attr, msb->page_size);
-	page_count = 1;
+	memcpy(buffer, (char *)attr, attr_len);
 
 	for (cnt = 0; cnt < attr_count; ++cnt) {
 		s_attr = kzalloc(sizeof(struct mspro_sys_attr), GFP_KERNEL);
@@ -1031,9 +1049,10 @@ static int mspro_block_read_attributes(s
 
 		msb->attr_group.attrs[cnt] = &s_attr->dev_attr.attr;
 		addr = be32_to_cpu(attr->entries[cnt].address);
-		rc = be32_to_cpu(attr->entries[cnt].size);
+		s_attr->size = be32_to_cpu(attr->entries[cnt].size);
 		dev_dbg(&card->dev, "adding attribute %d: id %x, address %x, "
-			"size %x\n", cnt, attr->entries[cnt].id, addr, rc);
+			"size %x\n", cnt, attr->entries[cnt].id, addr,
+			s_attr->size);
 		s_attr->id = attr->entries[cnt].id;
 		if (mspro_block_attr_name(s_attr->id))
 			snprintf(s_attr->name, sizeof(s_attr->name), "%s",
@@ -1047,57 +1066,47 @@ static int mspro_block_read_attributes(s
 		s_attr->dev_attr.attr.mode = S_IRUGO;
 		s_attr->dev_attr.show = mspro_block_attr_show(s_attr->id);
 
-		if (!rc)
+		if (!s_attr->size)
 			continue;
 
-		s_attr->size = rc;
-		s_attr->data = kmalloc(rc, GFP_KERNEL);
+		s_attr->data = kmalloc(s_attr->size, GFP_KERNEL);
 		if (!s_attr->data) {
 			rc = -ENOMEM;
 			goto out_free_buffer;
 		}
 
-		if (((addr / msb->page_size)
-		     == be32_to_cpu(param.data_address))
-		    && (((addr + rc - 1) / msb->page_size)
-			== be32_to_cpu(param.data_address))) {
+		if (((addr / msb->page_size) == (attr_offset / msb->page_size))
+		    && (((addr + s_attr->size - 1) / msb->page_size)
+			== (attr_offset / msb->page_size))) {
 			memcpy(s_attr->data, buffer + addr % msb->page_size,
-			       rc);
+			       s_attr->size);
 			continue;
 		}
 
-		if (page_count <= (rc / msb->page_size)) {
+		attr_offset = (addr / msb->page_size) * msb->page_size;
+
+		if ((attr_offset + attr_len) < (addr + s_attr->size)) {
 			kfree(buffer);
-			page_count = (rc / msb->page_size) + 1;
-			buffer = kmalloc(page_count * msb->page_size,
-					 GFP_KERNEL);
+			attr_len = (((addr + s_attr->size) / msb->page_size)
+				    + 1 ) * msb->page_size - attr_offset;
+			buffer = kmalloc(attr_len, GFP_KERNEL);
 			if (!buffer) {
 				rc = -ENOMEM;
 				goto out_free_attr;
 			}
 		}
 
-		param.system = msb->system;
-		param.data_count = cpu_to_be16((rc / msb->page_size) + 1);
-		param.data_address = cpu_to_be32(addr / msb->page_size);
-		param.tpc_param = 0;
-
-		sg_init_one(&msb->req_sg[0], buffer,
-			    be16_to_cpu(param.data_count) * msb->page_size);
+		sg_init_one(&msb->req_sg[0], buffer, attr_len);
 		msb->seg_count = 1;
 		msb->current_seg = 0;
 		msb->current_page = 0;
 		msb->data_dir = READ;
 		msb->transfer_cmd = MSPRO_CMD_READ_ATRB;
 
-		dev_dbg(&card->dev, "reading attribute pages %x, %x\n",
-			be32_to_cpu(param.data_address),
-			be16_to_cpu(param.data_count));
-
-		card->next_request = h_mspro_block_req_init;
-		msb->mrq_handler = h_mspro_block_transfer_data;
-		memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG,
-				  (char *)&param, sizeof(param));
+		dev_dbg(&card->dev, "reading attribute range %x, %x\n",
+			attr_offset, attr_len);
+
+		msb->setup_transfer(card, attr_offset, attr_len);
 		memstick_new_req(card->host);
 		wait_for_completion(&card->mrq_complete);
 		if (card->current_mrq.error) {
@@ -1105,7 +1114,8 @@ static int mspro_block_read_attributes(s
 			goto out_free_buffer;
 		}
 
-		memcpy(s_attr->data, buffer + addr % msb->page_size, rc);
+		memcpy(s_attr->data, buffer + addr % msb->page_size,
+		       s_attr->size);
 	}
 
 	rc = 0;
@@ -1123,6 +1133,8 @@ static int mspro_block_init_card(struct 
 	int rc = 0;
 
 	msb->system = MEMSTICK_SYS_SERIAL;
+	msb->setup_transfer = h_mspro_block_setup_cmd;
+
 	card->reg_addr.r_offset = offsetof(struct mspro_register, status);
 	card->reg_addr.r_length = sizeof(struct ms_status_register);
 	card->reg_addr.w_offset = offsetof(struct mspro_register, param);
_

Patches currently in -mm which might be from oakad@yahoo.com are

memstick-core-fix-device_register-error-handling.patch
memstick-fix-setup-for-jmicron-38x-controllers.patch
memstick-set-pmos-values-propery-for-jmicron-38x-controllers.patch
memstick-add-support-for-jmicron-jmb-385-and-390-controllers.patch
memstick-avert-possible-race-condition-between-idr_pre_get-and-idr_get_new.patch
memstick-remove-mspro_block_mutex.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc.patch
memstick-add-support-for-mspro-specific-data-transfer-method.patch

