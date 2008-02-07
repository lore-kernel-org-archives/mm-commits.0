From: akpm@linux-foundation.org
Subject: - sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:20:44 -0800
Message-ID: <200802070020.m170KPEg006132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933993AbYBGAVj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:21:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, jgarzik@redhat.com, mm-commits@vger.kernel.org


The patch titled
     sound/oss/pss: set_io_base() always returns success, mark it void
has been removed from the -mm tree.  Its filename was
     sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sound/oss/pss: set_io_base() always returns success, mark it void
From: Jeff Garzik <jeff@garzik.org>

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/pss.c |   30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff -puN sound/oss/pss.c~sound-oss-pss-set_io_base-always-returns-success-mark-it-void sound/oss/pss.c
--- a/sound/oss/pss.c~sound-oss-pss-set_io_base-always-returns-success-mark-it-void
+++ a/sound/oss/pss.c
@@ -232,14 +232,12 @@ static int set_irq(pss_confdata * devc, 
 	return 1;
 }
 
-static int set_io_base(pss_confdata * devc, int dev, int base)
+static void set_io_base(pss_confdata * devc, int dev, int base)
 {
 	unsigned short  tmp = inw(REG(dev)) & 0x003f;
 	unsigned short  bits = (base & 0x0ffc) << 4;
 
 	outw(bits | tmp, REG(dev));
-
-	return 1;
 }
 
 static int set_dma(pss_confdata * devc, int dev, int dma)
@@ -673,20 +671,12 @@ static void configure_nonsound_component
 
 	/* Configure CDROM port */
 
-	if(pss_cdrom_port == -1)	/* If cdrom port enablation wasn't requested */
-	{
+	if (pss_cdrom_port == -1) {	/* If cdrom port enablation wasn't requested */
 		printk(KERN_INFO "PSS: CDROM port not enabled.\n");
-	}
-	else if(check_region(pss_cdrom_port, 2))
-	{
+	} else if (check_region(pss_cdrom_port, 2)) {
 		printk(KERN_ERR "PSS: CDROM I/O port conflict.\n");
-	}
-	else if(!set_io_base(devc, CONF_CDROM, pss_cdrom_port))
-	{
-		printk(KERN_ERR "PSS: CDROM I/O port could not be set.\n");
-	}
-	else					/* CDROM port successfully configured */
-	{
+	} else {
+		set_io_base(devc, CONF_CDROM, pss_cdrom_port);
 		printk(KERN_INFO "PSS: CDROM I/O port set to 0x%x.\n", pss_cdrom_port);
 	}
 }
@@ -758,10 +748,7 @@ static int __init probe_pss_mpu(struct a
 		printk(KERN_ERR "PSS: MPU I/O port conflict\n");
 		return 0;
 	}
-	if (!set_io_base(devc, CONF_MIDI, hw_config->io_base)) {
-		printk(KERN_ERR "PSS: MIDI base could not be set.\n");
-		goto fail;
-	}
+	set_io_base(devc, CONF_MIDI, hw_config->io_base);
 	if (!set_irq(devc, CONF_MIDI, hw_config->irq)) {
 		printk(KERN_ERR "PSS: MIDI IRQ allocation error.\n");
 		goto fail;
@@ -1057,10 +1044,7 @@ static int __init probe_pss_mss(struct a
 		release_region(hw_config->io_base, 4);
 		return 0;
 	}
-	if (!set_io_base(devc, CONF_WSS, hw_config->io_base)) {
-		printk("PSS: WSS base not settable.\n");
-		goto fail;
-	}
+	set_io_base(devc, CONF_WSS, hw_config->io_base);
 	if (!set_irq(devc, CONF_WSS, hw_config->irq)) {
 		printk("PSS: WSS IRQ allocation error.\n");
 		goto fail;
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
git-libata-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix.patch
i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch
i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch
i8k-inspiron-e1705-fix.patch
smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
