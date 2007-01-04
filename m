From: akpm@osdl.org
Subject: - pciehp-fix-wait-command-completion.patch removed from -mm tree
Date: Thu, 04 Jan 2007 15:43:07 -0800
Message-ID: <200701042343.l04Nh7xi002872@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:36826 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030271AbXADXnS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 18:43:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaneshige.kenji@jp.fujitsu.com, greg@kroah.com, kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     pciehp: fix wait command completion
has been removed from the -mm tree.  Its filename was
     pciehp-fix-wait-command-completion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pciehp: fix wait command completion
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Fix the problem that pciehp driver will sleep unnecessarily long when waiting
for command completion.  With this patch, modprobe pciehp driver becomes very
faster as follows for instance.

  o Without this patch
    # time /sbin/modprobe pciehp

    real    0m4.976s
    user    0m0.000s
    sys     0m0.004s

  o With this patch
    # time /sbin/modprobe pciehp

    real    0m0.640s
    user    0m0.000s
    sys     0m0.004s

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/hotplug/pciehp.h     |    1 +
 drivers/pci/hotplug/pciehp_hpc.c |   27 +++++++++++++++------------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff -puN drivers/pci/hotplug/pciehp.h~pciehp-fix-wait-command-completion drivers/pci/hotplug/pciehp.h
--- a/drivers/pci/hotplug/pciehp.h~pciehp-fix-wait-command-completion
+++ a/drivers/pci/hotplug/pciehp.h
@@ -100,6 +100,7 @@ struct controller {
 	u16 vendor_id;
 	u8 cap_base;
 	struct timer_list poll_timer;
+	volatile int cmd_busy;
 };
 
 #define INT_BUTTON_IGNORE		0
diff -puN drivers/pci/hotplug/pciehp_hpc.c~pciehp-fix-wait-command-completion drivers/pci/hotplug/pciehp_hpc.c
--- a/drivers/pci/hotplug/pciehp_hpc.c~pciehp-fix-wait-command-completion
+++ a/drivers/pci/hotplug/pciehp_hpc.c
@@ -251,20 +251,21 @@ static void start_int_poll_timer(struct 
 
 static inline int pcie_wait_cmd(struct controller *ctrl)
 {
-	DECLARE_WAITQUEUE(wait, current);
-
-	add_wait_queue(&ctrl->queue, &wait);
-	if (!pciehp_poll_mode)
-		/* Sleep for up to 1 second */
-		msleep_interruptible(1000);
-	else
-		msleep_interruptible(2500);
+	int retval = 0;
+	unsigned int msecs = pciehp_poll_mode ? 2500 : 1000;
+	unsigned long timeout = msecs_to_jiffies(msecs);
+	int rc;
 
-	remove_wait_queue(&ctrl->queue, &wait);
-	if (signal_pending(current))
-		return -EINTR;
+	rc = wait_event_interruptible_timeout(ctrl->queue,
+					      !ctrl->cmd_busy, timeout);
+	if (!rc)
+		dbg("Command not completed in 1000 msec\n");
+	else if (rc < 0) {
+		retval = -EINTR;
+		info("Command was interrupted by a signal\n");
+	}
 
-	return 0;
+	return retval;
 }
 
 static int pcie_write_cmd(struct slot *slot, u16 cmd)
@@ -291,6 +292,7 @@ static int pcie_write_cmd(struct slot *s
 		    __FUNCTION__);
 	}
 
+	ctrl->cmd_busy = 1;
 	retval = pciehp_writew(ctrl, SLOTCTRL, (cmd | CMD_CMPL_INTR_ENABLE));
 	if (retval) {
 		err("%s: Cannot write to SLOTCTRL register\n", __FUNCTION__);
@@ -773,6 +775,7 @@ static irqreturn_t pcie_isr(int irq, voi
 		/* 
 		 * Command Complete Interrupt Pending 
 		 */
+		ctrl->cmd_busy = 0;
 		wake_up_interruptible(&ctrl->queue);
 	}
 
_

Patches currently in -mm which might be from kaneshige.kenji@jp.fujitsu.com are
