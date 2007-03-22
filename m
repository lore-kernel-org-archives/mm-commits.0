From: akpm@linux-foundation.org
Subject: - mpt-fusion-handle-pci-layer-error-on-resume.patch removed from -mm tree
Date: Thu, 22 Mar 2007 12:08:39 -0800
Message-ID: <200703222008.l2MK8dvW029140@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48855 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbXCVUIu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 16:08:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, Eric.Moore@lsil.com, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     MPT fusion: handle PCI layer error on resume
has been removed from the -mm tree.  Its filename was
     mpt-fusion-handle-pci-layer-error-on-resume.patch

This patch was dropped because a similar but totally different patch was merged

------------------------------------------------------
Subject: MPT fusion: handle PCI layer error on resume
From: Jeff Garzik <jeff@garzik.org>

In the unlikely event of pci_enable_device() failure during resume, we do
the minimalist solution and simply exit, rather than continuing to enable
the hardware.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~mpt-fusion-handle-pci-layer-error-on-resume drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~mpt-fusion-handle-pci-layer-error-on-resume
+++ a/drivers/message/fusion/mptbase.c
@@ -1530,7 +1530,7 @@ mpt_resume(struct pci_dev *pdev)
 {
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 	u32 device_state = pdev->current_state;
-	int recovery_state;
+	int recovery_state, rc;
 
 	printk(MYIOC_s_INFO_FMT
 	"pci-resume: pdev=0x%p, slot=%s, Previous operating state [D%d]\n",
@@ -1538,7 +1538,13 @@ mpt_resume(struct pci_dev *pdev)
 
 	pci_set_power_state(pdev, 0);
 	pci_restore_state(pdev);
-	pci_enable_device(pdev);
+
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		printk(MYIOC_s_INFO_FMT
+			"pci-resume: device enable failed\n", ioc->name);
+		return rc;
+	}
 
 	/* enable interrupts */
 	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-libata-all.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
ata-ncq-is-broken-on-maxtor-6l250s0.patch
git-netdev-all.patch
8139too-force-media-setting-fix.patch
baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced.patch
remove-unused-header-file-drivers-net-skfp-h-lnkstath.patch
tulip-fix-shutdown-dma-irq-race.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
8139too-fix-irq-problem-with-napi-netpoll.patch
git-ioat.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
mpt-fusion-handle-pci-layer-error-on-resume.patch
mpt-fusion-handle-mpt_resume-failure-while-resuming.patch
git-qla3xxx.patch
introduce-config_has_dma.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
uml-network-interface-hotplug-error-handling.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
unify-flush_work-flush_work_keventd-and-rename-it-to-cancel_work_sync.patch
e1000-printk-warning-fixes.patch
git-gccbug.patch
