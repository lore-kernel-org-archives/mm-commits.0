From: akpm@linux-foundation.org
Subject: + sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch added to -mm tree
Date: Wed, 24 Oct 2007 21:29:28 -0700
Message-ID: <200710250429.l9P4TSR0031861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44651 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754382AbXJYE3r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 00:29:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, jgarzik@redhat.com


The patch titled
     sound/oss/pss: set_io_base() always returns success, mark it void
has been added to the -mm tree.  Its filename is
     sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sound/oss/pss: set_io_base() always returns success, mark it void
From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/pss.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

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
@@ -677,16 +675,11 @@ static void configure_nonsound_component
 	{
 		printk(KERN_INFO "PSS: CDROM port not enabled.\n");
 	}
-	else if(check_region(pss_cdrom_port, 2))
-	{
+	else if(check_region(pss_cdrom_port, 2)) {
 		printk(KERN_ERR "PSS: CDROM I/O port conflict.\n");
 	}
-	else if(!set_io_base(devc, CONF_CDROM, pss_cdrom_port))
-	{
-		printk(KERN_ERR "PSS: CDROM I/O port could not be set.\n");
-	}
-	else					/* CDROM port successfully configured */
-	{
+	else {
+		set_io_base(devc, CONF_CDROM, pss_cdrom_port);
 		printk(KERN_INFO "PSS: CDROM I/O port set to 0x%x.\n", pss_cdrom_port);
 	}
 }
@@ -758,10 +751,7 @@ static int __init probe_pss_mpu(struct a
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
@@ -1057,10 +1047,7 @@ static int __init probe_pss_mss(struct a
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

lguest-build-fix.patch
remove-bogus-default-y-for-dmar-and-net_dma.patch
acpi-sbs-fix-retval-warning.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
ide-add-helper-__ide_setup_pci_device.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
drivers-ide-pci-sc1200c-fix-suspend-resume-buglets-and-warnings.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
git-wireless.patch
mac80211-fix-warning-created-by-bit.patch
x86-fix-config_smp-warning-in-processorc.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
isdn-sc-fix-longstanding-warning.patch
