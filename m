From: akpm@linux-foundation.org
Subject: + i2o-fix-defined-but-not-used-build-warnings.patch added to -mm tree
Date: Thu, 13 Sep 2007 00:58:15 -0700
Message-ID: <200709130758.l8D7wF6L008727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40746 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752268AbXIMH6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 03:58:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: satyam@infradead.org


The patch titled
     I2O: Fix "defined but not used" build warnings
has been added to the -mm tree.  Its filename is
     i2o-fix-defined-but-not-used-build-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: I2O: Fix "defined but not used" build warnings
From: Satyam Sharma <satyam@infradead.org>

drivers/message/i2o/exec-osm.c:539: warning: `i2o_exec_lct_notify' defined but not used

comes when CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=n, because its only callsite
is #ifdef'ed as such. So let's #ifdef the function definition also. Also
move the definition to before the callsite, to get rid of forward prototype.

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
+};
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

h8-300-fix-misnamed-config_blkdev_reserve_address-kconfig-variable.patch
cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
drivers-char-nozomic-__devexit_p-usage-build-fix.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-netdev-all.patch
git-net.patch
net-sched-sch_cbqc-shut-up-uninitialized-variable.patch
git-s390.patch
sched-use-show_regs-to-improve-__schedule_bug-output.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
git-watchdog.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
softlockup-improve-debug-output-fix.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
i2o-fix-defined-but-not-used-build-warnings.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch
