From: akpm@linux-foundation.org
Subject: + i2o_cfg_passthru-cleanup.patch added to -mm tree
Date: Tue, 15 May 2007 12:49:40 -0700
Message-ID: <200705151949.l4FJnef6016200@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49319 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754640AbXEOTuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 15:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vvs@sw.ru, Markus.Lidel@shadowconnect.com, alan@lxorguk.ukuu.org.uk, dev@openvz.org


The patch titled
     i2o_cfg_passthru cleanup
has been added to the -mm tree.  Its filename is
     i2o_cfg_passthru-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i2o_cfg_passthru cleanup
From: Vasily Averin <vvs@sw.ru>

This patch fixes a number of issues in i2o_cfg_passthru{,32}:
- i2o_msg_get_wait() return vaile is not checked;
- i2o_message memory leaks on error paths;
- infinite loop to sg_list_cleanup in passthru32

It's important issue because of i2o_cfg_passthru is used by raidutils for
monitorig controllers state, and in case of memory shortage it leads to the
node crash or disk IO stall.

Signed-off-by: Vasily Averin <vvs@sw.ru>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Acked-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/i2o_config.c |   62 +++++++++++++++++------------
 1 files changed, 38 insertions(+), 24 deletions(-)

diff -puN drivers/message/i2o/i2o_config.c~i2o_cfg_passthru-cleanup drivers/message/i2o/i2o_config.c
--- a/drivers/message/i2o/i2o_config.c~i2o_cfg_passthru-cleanup
+++ a/drivers/message/i2o/i2o_config.c
@@ -554,8 +554,6 @@ static int i2o_cfg_passthru32(struct fil
 		return -ENXIO;
 	}
 
-	msg = i2o_msg_get_wait(c, I2O_TIMEOUT_MESSAGE_GET);
-
 	sb = c->status_block.virt;
 
 	if (get_user(size, &user_msg[0])) {
@@ -573,24 +571,30 @@ static int i2o_cfg_passthru32(struct fil
 
 	size <<= 2;		// Convert to bytes
 
+	msg = i2o_msg_get_wait(c, I2O_TIMEOUT_MESSAGE_GET);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
+
+	rcode = -EFAULT;
 	/* Copy in the user's I2O command */
 	if (copy_from_user(msg, user_msg, size)) {
 		osm_warn("unable to copy user message\n");
-		return -EFAULT;
+		goto out;
 	}
 	i2o_dump_message(msg);
 
 	if (get_user(reply_size, &user_reply[0]) < 0)
-		return -EFAULT;
+		goto out;
 
 	reply_size >>= 16;
 	reply_size <<= 2;
 
+	rcode = -ENOMEM;
 	reply = kzalloc(reply_size, GFP_KERNEL);
 	if (!reply) {
 		printk(KERN_WARNING "%s: Could not allocate reply buffer\n",
 		       c->name);
-		return -ENOMEM;
+		goto out;
 	}
 
 	sg_offset = (msg->u.head[0] >> 4) & 0x0f;
@@ -661,13 +665,14 @@ static int i2o_cfg_passthru32(struct fil
 	}
 
 	rcode = i2o_msg_post_wait(c, msg, 60);
+	msg = NULL;
 	if (rcode) {
 		reply[4] = ((u32) rcode) << 24;
 		goto sg_list_cleanup;
 	}
 
 	if (sg_offset) {
-		u32 msg[I2O_OUTBOUND_MSG_FRAME_SIZE];
+		u32 rmsg[I2O_OUTBOUND_MSG_FRAME_SIZE];
 		/* Copy back the Scatter Gather buffers back to user space */
 		u32 j;
 		// TODO 64bit fix
@@ -675,7 +680,7 @@ static int i2o_cfg_passthru32(struct fil
 		int sg_size;
 
 		// re-acquire the original message to handle correctly the sg copy operation
-		memset(&msg, 0, I2O_OUTBOUND_MSG_FRAME_SIZE * 4);
+		memset(&rmsg, 0, I2O_OUTBOUND_MSG_FRAME_SIZE * 4);
 		// get user msg size in u32s
 		if (get_user(size, &user_msg[0])) {
 			rcode = -EFAULT;
@@ -684,7 +689,7 @@ static int i2o_cfg_passthru32(struct fil
 		size = size >> 16;
 		size *= 4;
 		/* Copy in the user's I2O command */
-		if (copy_from_user(msg, user_msg, size)) {
+		if (copy_from_user(rmsg, user_msg, size)) {
 			rcode = -EFAULT;
 			goto sg_list_cleanup;
 		}
@@ -692,7 +697,7 @@ static int i2o_cfg_passthru32(struct fil
 		    (size - sg_offset * 4) / sizeof(struct sg_simple_element);
 
 		// TODO 64bit fix
-		sg = (struct sg_simple_element *)(msg + sg_offset);
+		sg = (struct sg_simple_element *)(rmsg + sg_offset);
 		for (j = 0; j < sg_count; j++) {
 			/* Copy out the SG list to user's buffer if necessary */
 			if (!
@@ -714,7 +719,7 @@ static int i2o_cfg_passthru32(struct fil
 		}
 	}
 
-      sg_list_cleanup:
+sg_list_cleanup:
 	/* Copy back the reply to user space */
 	if (reply_size) {
 		// we wrote our own values for context - now restore the user supplied ones
@@ -723,7 +728,6 @@ static int i2o_cfg_passthru32(struct fil
 			       "%s: Could not copy message context FROM user\n",
 			       c->name);
 			rcode = -EFAULT;
-			goto sg_list_cleanup;
 		}
 		if (copy_to_user(user_reply, reply, reply_size)) {
 			printk(KERN_WARNING
@@ -731,12 +735,14 @@ static int i2o_cfg_passthru32(struct fil
 			rcode = -EFAULT;
 		}
 	}
-
 	for (i = 0; i < sg_index; i++)
 		i2o_dma_free(&c->pdev->dev, &sg_list[i]);
 
-      cleanup:
+cleanup:
 	kfree(reply);
+	if (msg)
+out:
+		i2o_msg_nop(c, msg);
 	return rcode;
 }
 
@@ -793,8 +799,6 @@ static int i2o_cfg_passthru(unsigned lon
 		return -ENXIO;
 	}
 
-	msg = i2o_msg_get_wait(c, I2O_TIMEOUT_MESSAGE_GET);
-
 	sb = c->status_block.virt;
 
 	if (get_user(size, &user_msg[0]))
@@ -810,12 +814,17 @@ static int i2o_cfg_passthru(unsigned lon
 
 	size <<= 2;		// Convert to bytes
 
+	msg = i2o_msg_get_wait(c, I2O_TIMEOUT_MESSAGE_GET);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
+
+	rcode = -EFAULT;
 	/* Copy in the user's I2O command */
 	if (copy_from_user(msg, user_msg, size))
-		return -EFAULT;
+		goto out;
 
 	if (get_user(reply_size, &user_reply[0]) < 0)
-		return -EFAULT;
+		goto out;
 
 	reply_size >>= 16;
 	reply_size <<= 2;
@@ -824,7 +833,8 @@ static int i2o_cfg_passthru(unsigned lon
 	if (!reply) {
 		printk(KERN_WARNING "%s: Could not allocate reply buffer\n",
 		       c->name);
-		return -ENOMEM;
+		rcode = -ENOMEM;
+		goto out;
 	}
 
 	sg_offset = (msg->u.head[0] >> 4) & 0x0f;
@@ -891,13 +901,14 @@ static int i2o_cfg_passthru(unsigned lon
 	}
 
 	rcode = i2o_msg_post_wait(c, msg, 60);
+	msg = NULL;
 	if (rcode) {
 		reply[4] = ((u32) rcode) << 24;
 		goto sg_list_cleanup;
 	}
 
 	if (sg_offset) {
-		u32 msg[128];
+		u32 rmsg[128];
 		/* Copy back the Scatter Gather buffers back to user space */
 		u32 j;
 		// TODO 64bit fix
@@ -905,7 +916,7 @@ static int i2o_cfg_passthru(unsigned lon
 		int sg_size;
 
 		// re-acquire the original message to handle correctly the sg copy operation
-		memset(&msg, 0, I2O_OUTBOUND_MSG_FRAME_SIZE * 4);
+		memset(&rmsg, 0, I2O_OUTBOUND_MSG_FRAME_SIZE * 4);
 		// get user msg size in u32s
 		if (get_user(size, &user_msg[0])) {
 			rcode = -EFAULT;
@@ -914,7 +925,7 @@ static int i2o_cfg_passthru(unsigned lon
 		size = size >> 16;
 		size *= 4;
 		/* Copy in the user's I2O command */
-		if (copy_from_user(msg, user_msg, size)) {
+		if (copy_from_user(rmsg, user_msg, size)) {
 			rcode = -EFAULT;
 			goto sg_list_cleanup;
 		}
@@ -922,7 +933,7 @@ static int i2o_cfg_passthru(unsigned lon
 		    (size - sg_offset * 4) / sizeof(struct sg_simple_element);
 
 		// TODO 64bit fix
-		sg = (struct sg_simple_element *)(msg + sg_offset);
+		sg = (struct sg_simple_element *)(rmsg + sg_offset);
 		for (j = 0; j < sg_count; j++) {
 			/* Copy out the SG list to user's buffer if necessary */
 			if (!
@@ -944,7 +955,7 @@ static int i2o_cfg_passthru(unsigned lon
 		}
 	}
 
-      sg_list_cleanup:
+sg_list_cleanup:
 	/* Copy back the reply to user space */
 	if (reply_size) {
 		// we wrote our own values for context - now restore the user supplied ones
@@ -964,8 +975,11 @@ static int i2o_cfg_passthru(unsigned lon
 	for (i = 0; i < sg_index; i++)
 		kfree(sg_list[i]);
 
-      cleanup:
+cleanup:
 	kfree(reply);
+	if (msg)
+out:
+		i2o_msg_nop(c, msg);
 	return rcode;
 }
 #endif
_

Patches currently in -mm which might be from vvs@sw.ru are

i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
