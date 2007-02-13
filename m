From: akpm@linux-foundation.org
Subject: + sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch added to -mm tree
Date: Mon, 12 Feb 2007 22:46:05 -0800
Message-ID: <200702130646.l1D6k5mn024241@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56607 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161067AbXBMGqU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 01:46:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hancockr@shaw.ca, htejun@gmail.com, jeff@garzik.org


The patch titled
     sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy
has been added to the -mm tree.  Its filename is
     sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Moer kernely.

Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff -puN drivers/ata/sata_nv.c~sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy
+++ a/drivers/ata/sata_nv.c
@@ -1443,31 +1443,38 @@ static void nv_adma_error_handler(struct
 		int i;
 		u16 tmp;
 
-		if(ata_tag_valid(ap->active_tag) || ap->sactive) {
+		if (ata_tag_valid(ap->active_tag) || ap->sactive) {
 			u32 notifier = readl(mmio + NV_ADMA_NOTIFIER);
 			u32 notifier_error = readl(mmio + NV_ADMA_NOTIFIER_ERROR);
 			u32 gen_ctl = readl(pp->gen_block + NV_ADMA_GEN_CTL);
 			u32 status = readw(mmio + NV_ADMA_STAT);
 
-			ata_port_printk(ap, KERN_ERR, "EH in ADMA mode, notifier 0x%X "
-				"notifier_error 0x%X gen_ctl 0x%X status 0x%X\n",
+			ata_port_printk(ap, KERN_ERR, "EH in ADMA mode, "
+				"notifier 0x%X notifier_error 0x%X gen_ctl "
+				"0x%X status 0x%X\n",
 				notifier, notifier_error, gen_ctl, status);
 
-			for( i=0;i<NV_ADMA_MAX_CPBS;i++) {
+			for (i = 0; i < NV_ADMA_MAX_CPBS; i++) {
 				struct nv_adma_cpb *cpb = &pp->cpb[i];
-				if( (ata_tag_valid(ap->active_tag) && i == ap->active_tag) ||
-				    ap->sactive & (1 << i) )
-					ata_port_printk(ap, KERN_ERR,
-						"CPB %d: ctl_flags 0x%x, resp_flags 0x%x\n",
-						i, cpb->ctl_flags, cpb->resp_flags);
+				if ((ata_tag_valid(ap->active_tag) &&
+						i == ap->active_tag) ||
+						ap->sactive & (1 << i))
+					ata_port_printk(ap, KERN_ERR, "CPB %d: "
+						"ctl_flags 0x%x, resp_flags "
+						"0x%x\n",
+						i, cpb->ctl_flags,
+						cpb->resp_flags);
 			}
 		}
 
 		/* Push us back into port register mode for error handling. */
 		nv_adma_register_mode(ap);
 
-		/* Mark all of the CPBs as invalid to prevent them from being executed */
-		for( i=0;i<NV_ADMA_MAX_CPBS;i++)
+		/*
+		 * Mark all of the CPBs as invalid to prevent them from being
+		 * executed
+		*/
+		for (i = 0; i< NV_ADMA_MAX_CPBS; i++)
 			pp->cpb[i].ctl_flags &= ~NV_CPB_CTL_CPB_VALID;
 
 		/* clear CPB fetch count */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-acpi-fixup.patch
git-agpgart.patch
git-arm.patch
git-cifs-fix.patch
git-cpufreq.patch
fix-warning-in-device_add_attrs.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
git-infiniband.patch
sis-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-nfs-fixup.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-unionfs-fixup.patch
git-watchdog.patch
revert-x86_64-mm-msr-on-cpu.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
revert-x86_64-mm-putreg-check.patch
git-gccbug-fixup.patch
