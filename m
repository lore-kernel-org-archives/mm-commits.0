From: akpm@linux-foundation.org
Subject: - i2o-fix-defined-but-not-used-build-warnings.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:57 -0700
Message-ID: <200710180659.l9I6xv33031035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42164 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763028AbXJRHPu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, mm-commits@vger.kernel.org


The patch titled
     I2O: Fix "defined but not used" build warnings
has been removed from the -mm tree.  Its filename was
     i2o-fix-defined-but-not-used-build-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: I2O: Fix "defined but not used" build warnings
From: Satyam Sharma <satyam@infradead.org>

drivers/message/i2o/exec-osm.c:539: warning: `i2o_exec_lct_notify' defined but not used

comes when CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=n, because its only callsite
is #ifdef'ed as such. So let's #ifdef the function definition also. Also
move the definition to before the callsite, to get rid of forward prototype.

[akpm@linux-foundation.org: fix warnings]
Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/exec-osm.c |   94 +++++++++++++++----------------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff -puN drivers/message/i2o/exec-osm.c~i2o-fix-defined-but-not-used-build-warnings drivers/message/i2o/exec-osm.c
--- a/drivers/message/i2o/exec-osm.c~i2o-fix-defined-but-not-used-build-warnings
+++ a/drivers/message/i2o/exec-osm.c
@@ -41,8 +41,6 @@
 
 struct i2o_driver i2o_exec_driver;
 
-static int i2o_exec_lct_notify(struct i2o_controller *c, u32 change_ind);
-
 /* global wait list for POST WAIT */
 static LIST_HEAD(i2o_exec_wait_list);
 
@@ -369,6 +367,53 @@ static int i2o_exec_remove(struct device
 	return 0;
 };
 
+#ifdef CONFIG_I2O_LCT_NOTIFY_ON_CHANGES
+/**
+ *	i2o_exec_lct_notify - Send a asynchronus LCT NOTIFY request
+ *	@c: I2O controller to which the request should be send
+ *	@change_ind: change indicator
+ *
+ *	This function sends a LCT NOTIFY request to the I2O controller with
+ *	the change indicator change_ind. If the change_ind == 0 the controller
+ *	replies immediately after the request. If change_ind > 0 the reply is
+ *	send after change indicator of the LCT is > change_ind.
+ */
+static int i2o_exec_lct_notify(struct i2o_controller *c, u32 change_ind)
+{
+	i2o_status_block *sb = c->status_block.virt;
+	struct device *dev;
+	struct i2o_message *msg;
+
+	mutex_lock(&c->lct_lock);
+
+	dev = &c->pdev->dev;
+
+	if (i2o_dma_realloc
+	    (dev, &c->dlct, le32_to_cpu(sb->expected_lct_size), GFP_KERNEL))
+		return -ENOMEM;
+
+	msg = i2o_msg_get_wait(c, I2O_TIMEOUT_MESSAGE_GET);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
+
+	msg->u.head[0] = cpu_to_le32(EIGHT_WORD_MSG_SIZE | SGL_OFFSET_6);
+	msg->u.head[1] = cpu_to_le32(I2O_CMD_LCT_NOTIFY << 24 | HOST_TID << 12 |
+				     ADAPTER_TID);
+	msg->u.s.icntxt = cpu_to_le32(i2o_exec_driver.context);
+	msg->u.s.tcntxt = cpu_to_le32(0x00000000);
+	msg->body[0] = cpu_to_le32(0xffffffff);
+	msg->body[1] = cpu_to_le32(change_ind);
+	msg->body[2] = cpu_to_le32(0xd0000000 | c->dlct.len);
+	msg->body[3] = cpu_to_le32(c->dlct.phys);
+
+	i2o_msg_post(c, msg);
+
+	mutex_unlock(&c->lct_lock);
+
+	return 0;
+}
+#endif
+
 /**
  *	i2o_exec_lct_modified - Called on LCT NOTIFY reply
  *	@_work: work struct for a specific controller
@@ -525,51 +570,6 @@ int i2o_exec_lct_get(struct i2o_controll
 	return rc;
 }
 
-/**
- *	i2o_exec_lct_notify - Send a asynchronus LCT NOTIFY request
- *	@c: I2O controller to which the request should be send
- *	@change_ind: change indicator
- *
- *	This function sends a LCT NOTIFY request to the I2O controller with
- *	the change indicator change_ind. If the change_ind == 0 the controller
- *	replies immediately after the request. If change_ind > 0 the reply is
- *	send after change indicator of the LCT is > change_ind.
- */
-static int i2o_exec_lct_notify(struct i2o_controller *c, u32 change_ind)
-{
-	i2o_status_block *sb = c->status_block.virt;
-	struct device *dev;
-	struct i2o_message *msg;
-
-	mutex_lock(&c->lct_lock);
-
-	dev = &c->pdev->dev;
-
-	if (i2o_dma_realloc
-	    (dev, &c->dlct, le32_to_cpu(sb->expected_lct_size), GFP_KERNEL))
-		return -ENOMEM;
-
-	msg = i2o_msg_get_wait(c, I2O_TIMEOUT_MESSAGE_GET);
-	if (IS_ERR(msg))
-		return PTR_ERR(msg);
-
-	msg->u.head[0] = cpu_to_le32(EIGHT_WORD_MSG_SIZE | SGL_OFFSET_6);
-	msg->u.head[1] = cpu_to_le32(I2O_CMD_LCT_NOTIFY << 24 | HOST_TID << 12 |
-				     ADAPTER_TID);
-	msg->u.s.icntxt = cpu_to_le32(i2o_exec_driver.context);
-	msg->u.s.tcntxt = cpu_to_le32(0x00000000);
-	msg->body[0] = cpu_to_le32(0xffffffff);
-	msg->body[1] = cpu_to_le32(change_ind);
-	msg->body[2] = cpu_to_le32(0xd0000000 | c->dlct.len);
-	msg->body[3] = cpu_to_le32(c->dlct.phys);
-
-	i2o_msg_post(c, msg);
-
-	mutex_unlock(&c->lct_lock);
-
-	return 0;
-};
-
 /* Exec OSM driver struct */
 struct i2o_driver i2o_exec_driver = {
 	.name = OSM_NAME,
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
git-watchdog.patch
unify-dma_bit_mask-definitions-v31.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
