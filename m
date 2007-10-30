From: akpm@linux-foundation.org
Subject: - media-video-planb-fix-obvious-interrupt-handling-bugs.patch removed from -mm tree
Date: Tue, 30 Oct 2007 11:06:46 -0700
Message-ID: <200710301806.l9UI6kWl020548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44373 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877AbXJ3SHk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:07:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, jgarzik@redhat.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     media/video/planb: fix obvious interrupt handling bugs
has been removed from the -mm tree.  Its filename was
     media-video-planb-fix-obvious-interrupt-handling-bugs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: media/video/planb: fix obvious interrupt handling bugs
From: Jeff Garzik <jeff@garzik.org>

irq handlers have returned a return value for years now... catch up with
the times.

Also, ditch unneeded prototype.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/planb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/media/video/planb.c~media-video-planb-fix-obvious-interrupt-handling-bugs drivers/media/video/planb.c
--- a/drivers/media/video/planb.c~media-video-planb-fix-obvious-interrupt-handling-bugs
+++ a/drivers/media/video/planb.c
@@ -91,7 +91,6 @@ static void planb_close(struct video_dev
 static int planb_ioctl(struct video_device *, unsigned int, void *);
 static int planb_init_done(struct video_device *);
 static int planb_mmap(struct video_device *, const char *, unsigned long);
-static void planb_irq(int, void *);
 static void release_planb(void);
 int init_planbs(struct video_init *);
 
@@ -1315,7 +1314,7 @@ cmd_tab_data_end:
 	return c1;
 }
 
-static void planb_irq(int irq, void *dev_id)
+static irqreturn_t planb_irq(int irq, void *dev_id)
 {
 	unsigned int stat, astat;
 	struct planb *pb = (struct planb *)dev_id;
@@ -1358,13 +1357,14 @@ static void planb_irq(int irq, void *dev
 		pb->frame_stat[fr] = GBUFFER_DONE;
 		pb->grabbing--;
 		wake_up_interruptible(&pb->capq);
-		return;
+		return IRQ_HANDLED;
 	}
 	/* incorrect interrupts? */
 	pb->intr_mask = PLANB_CLR_IRQ;
 	out_le32(&pb->planb_base->intr_stat, PLANB_CLR_IRQ);
 	printk(KERN_ERR "PlanB: IRQ lockup, cleared intrrupts"
 							" unconditionally\n");
+	return IRQ_HANDLED;
 }
 
 /*******************************
@@ -2090,7 +2090,7 @@ static int init_planb(struct planb *pb)
 	/* clear interrupt mask */
 	pb->intr_mask = PLANB_CLR_IRQ;
 
-	result = request_irq(pb->irq, planb_irq, 0, "PlanB", (void *)pb);
+	result = request_irq(pb->irq, planb_irq, 0, "PlanB", pb);
 	if (result < 0) {
 		if (result==-EINVAL)
 			printk(KERN_ERR "PlanB: Bad irq number (%d) "
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
acpi-sbs-fix-retval-warning.patch
git-arm.patch
git-dvb.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-add-helper-__ide_setup_pci_device.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
git-netdev-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
scsi-gdth-kill-unneeded-irq-argument.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
scsi-sym53c416-kill-pointless-irq-handler-loop-and-test.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
scsi-ncr5380-minor-irq-handler-cleanups.patch
usb-s3c2410_udc-minor-irq-handler-cleanups.patch
git-wireless.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-pointless-casts-from-void-pointers.patch
