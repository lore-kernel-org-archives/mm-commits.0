From: akpm@osdl.org
Subject: + jmicron-40-80pin-primary-detection.patch added to -mm tree
Date: Mon, 29 Jan 2007 23:44:17 -0800
Message-ID: <200701300744.l0U7iHjo012540@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46750 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965426AbXA3Hof (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 02:44:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, sshtylyov@ru.mvista.com


The patch titled
     jmicron: 40/80pin primary detection
has been added to the -mm tree.  Its filename is
     jmicron-40-80pin-primary-detection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jmicron: 40/80pin primary detection
From: ethanhsiao@jmicron.com

jmicron module detects all JMB36x as JMB361 and PATA0 has wrong pin status
of XICBLID.

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/pci/jmicron.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/ide/pci/jmicron.c~jmicron-40-80pin-primary-detection drivers/ide/pci/jmicron.c
--- a/drivers/ide/pci/jmicron.c~jmicron-40-80pin-primary-detection
+++ a/drivers/ide/pci/jmicron.c
@@ -86,8 +86,8 @@ static int __devinit ata66_jmicron(ide_h
 	{
 	case PORT_PATA0:
 		if (control & (1 << 3))	/* 40/80 pin primary */
-			return 1;
-		return 0;
+			return 0;
+		return 1;
 	case PORT_PATA1:
 		if (control5 & (1 << 19))	/* 40/80 pin secondary */
 			return 0;
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-libata-all.patch
pata_platform-set_mode-fix.patch
libata-scsi-ata_task_ioctl-should-return-ata-registers-from.patch
sata_nv-cleanup-adma-error-handling-v2.patch
sata_nv-cleanup-adma-error-handling-v2-cleanup.patch
sata_nv-use-adma-for-nodata-commands.patch
fix-config_sata_sis=y-compile-error.patch
jmicron-40-80pin-primary-detection.patch
mips-declance-driver-model-for-the-pmad-a.patch
mips-defxx-turbochannel-support.patch
git-netdev-all.patch
git-netdev-all-atl1-build-fix.patch
git-netdev-all-atl1-pm-fix.patch
8139too-force-media-setting-fix.patch
net-ifb-error-path-loop-fix.patch
ucc-ether-driver-kmalloc-casting-cleanups.patch
remove-one-remaining-define-bcm_tso-1.patch
82596-warning-fix.patch
hp100-convert-pci_module_init-to-pci_register_driver.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
tulip-fix-shutdown-dma-irq-race.patch
z85230-spinlock-logic.patch
remove-unused-kernel-config-option-dlci_count.patch
bonding-arp-monitoring-broken-on-x86_64.patch
git-ioat.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
mpt-fusion-handle-pci-layer-error-on-resume.patch
fix-unaligned-exception-in-drivers-net-wireless-orinococ.patch
uml-network-driver-whitespace-and-style-fixes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
e1000-printk-warning-fixes.patch
git-gccbug.patch
