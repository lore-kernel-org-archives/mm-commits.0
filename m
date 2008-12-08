From: akpm@linux-foundation.org
Subject: + w1-add-touch-block-command.patch added to -mm tree
Date: Mon, 08 Dec 2008 13:59:07 -0800
Message-ID: <200812082159.mB8Lx7NW020045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbYLHV7m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 16:59:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zbr@ioremap.net


The patch titled
     w1: add touch block command
has been added to the -mm tree.  Its filename is
     w1-add-touch-block-command.patch

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
Subject: w1: add touch block command
From: Evgeniy Polyakov <zbr@ioremap.net>

Writes and returns sampled data back to userspace.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.h         |    1 +
 drivers/w1/w1_io.c      |   26 +++++++++++++++++++++++++-
 drivers/w1/w1_netlink.c |   11 ++++++++---
 drivers/w1/w1_netlink.h |    1 +
 4 files changed, 35 insertions(+), 4 deletions(-)

diff -puN drivers/w1/w1.h~w1-add-touch-block-command drivers/w1/w1.h
--- a/drivers/w1/w1.h~w1-add-touch-block-command
+++ a/drivers/w1/w1.h
@@ -210,6 +210,7 @@ u8 w1_read_8(struct w1_master *);
 int w1_reset_bus(struct w1_master *);
 u8 w1_calc_crc8(u8 *, int);
 void w1_write_block(struct w1_master *, const u8 *, int);
+void w1_touch_block(struct w1_master *, u8 *, int);
 u8 w1_read_block(struct w1_master *, u8 *, int);
 int w1_reset_select_slave(struct w1_slave *sl);
 void w1_next_pullup(struct w1_master *, int);
diff -puN drivers/w1/w1_io.c~w1-add-touch-block-command drivers/w1/w1_io.c
--- a/drivers/w1/w1_io.c~w1-add-touch-block-command
+++ a/drivers/w1/w1_io.c
@@ -238,7 +238,6 @@ EXPORT_SYMBOL_GPL(w1_read_8);
  * @param dev     the master device
  * @param buf     pointer to the data to write
  * @param len     the number of bytes to write
- * @return        the byte read
  */
 void w1_write_block(struct w1_master *dev, const u8 *buf, int len)
 {
@@ -256,6 +255,31 @@ void w1_write_block(struct w1_master *de
 EXPORT_SYMBOL_GPL(w1_write_block);
 
 /**
+ * Touches a series of bytes.
+ *
+ * @param dev     the master device
+ * @param buf     pointer to the data to write
+ * @param len     the number of bytes to write
+ */
+void w1_touch_block(struct w1_master *dev, u8 *buf, int len)
+{
+	int i, j;
+	u8 tmp;
+
+	for (i = 0; i < len; ++i) {
+		tmp = 0;
+		for (j = 0; j < 8; ++j) {
+			if (j == 7)
+				w1_pre_write(dev);
+			tmp |= w1_touch_bit(dev, (buf[i] >> j) & 0x1) << j;
+		}
+
+		buf[i] = tmp;
+	}
+}
+EXPORT_SYMBOL_GPL(w1_touch_block);
+
+/**
  * Reads a series of bytes.
  *
  * @param dev     the master device
diff -puN drivers/w1/w1_netlink.c~w1-add-touch-block-command drivers/w1/w1_netlink.c
--- a/drivers/w1/w1_netlink.c~w1-add-touch-block-command
+++ a/drivers/w1/w1_netlink.c
@@ -108,6 +108,10 @@ static int w1_process_command_slave(stru
 		cmd->cmd, cmd->len);
 
 	switch (cmd->cmd) {
+		case W1_CMD_TOUCH:
+			w1_touch_block(sl->master, cmd->data, cmd->len);
+			w1_send_read_reply(sl, msg, hdr, cmd);
+			break;
 		case W1_CMD_READ:
 			w1_read_block(sl->master, cmd->data, cmd->len);
 			w1_send_read_reply(sl, msg, hdr, cmd);
@@ -208,9 +212,6 @@ static void w1_cn_callback(void *data)
 			break;
 		}
 
-		if (!mlen)
-			goto out_cont;
-
 		if (m->type == W1_MASTER_CMD) {
 			dev = w1_search_master_id(m->id.mst.id);
 		} else if (m->type == W1_SLAVE_CMD) {
@@ -227,6 +228,10 @@ static void w1_cn_callback(void *data)
 			goto out_cont;
 		}
 
+		err = 0;
+		if (!mlen)
+			goto out_cont;
+
 		mutex_lock(&dev->mutex);
 
 		if (sl && w1_reset_select_slave(sl)) {
diff -puN drivers/w1/w1_netlink.h~w1-add-touch-block-command drivers/w1/w1_netlink.h
--- a/drivers/w1/w1_netlink.h~w1-add-touch-block-command
+++ a/drivers/w1/w1_netlink.h
@@ -56,6 +56,7 @@ struct w1_netlink_msg
 #define W1_CMD_WRITE		0x1
 #define W1_CMD_SEARCH		0x2
 #define W1_CMD_ALARM_SEARCH	0x3
+#define W1_CMD_TOUCH		0x4
 
 struct w1_netlink_cmd
 {
_

Patches currently in -mm which might be from zbr@ioremap.net are

mx2-add-w1-device-resources.patch
mx31-add-w1-platform_device-and-resources.patch
mx2-pcm038-add-1-wire-master-support.patch
pcm037-add-1wire-support.patch
w1-add-1-wire-master-driver-for-imx27-imx31.patch
w1-add-1-wire-master-driver-for-imx27-imx31-update.patch
w1-add-list-masters-w1-command.patch
w1-add-touch-block-command.patch
w1-list-slaves-commands.patch
w1-documentation-update.patch

