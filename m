From: akpm@linux-foundation.org
Subject: - unbreak-msi-on-ati-devices.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:01:10 -0800
Message-ID: <200703060101.l2611ALv007048@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43881 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbXCFBBi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:01:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: petr@vandrovec.name, ebiederm@xmission.com, greg@kroah.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     Unbreak MSI on ATI devices
has been removed from the -mm tree.  Its filename was
     unbreak-msi-on-ati-devices.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Unbreak MSI on ATI devices
From: Petr Vandrovec <petr@vandrovec.name>

I'm using second patch below for couple of months to get MSI on all devices
present on my notebook which are MSI capable (except IDE - notebook uses
IDE in legacy mode and seems unhappy with transition to native MSI-based
mode; maybe I could try do the job with libata now when I switched; and
VGA, I do not use dri...).  All worked nicely until last sync, when I
noticed that my USB devices suddenly stopped working (it took me few weeks
as I do not use USB regulary).

After poking around I've found that problem is that at least ATI USB-HCDs
apply INTX enable even for MSI, despite warning in the PCI specification
that it should apply only to MSI (actually I have feeling that on these USB
devices disabling INTX in MSI mode drives their INTA# line active as when
ohci1394 module got loaded kernel complained about interrupt being
continuously activated for no good reason (TI's 7421 is one of few
MSI-incapable devices in my box).

So my question is - what is real reason for disabling INTX when in MSI
mode?  According to PCI spec it should not be needed, and it hurts at least
chips listed below:

00:13.0 0c03: 1002:4374 USB Controller: ATI Technologies Inc IXP SB400 USB Host Controller
00:13.1 0c03: 1002:4375 USB Controller: ATI Technologies Inc IXP SB400 USB Host Controller
00:13.2 0c03: 1002:4373 USB Controller: ATI Technologies Inc IXP SB400 USB2 Host Controller

I believe that these devices from same vendor accept disabling INTX while
in MSI fine (I did not notice problems with them even with INTX disabling
code in msi.c):

00:14.5 0401: 1002:4370 (rev 02) Multimedia audio controller: ATI Technologies Inc IXP SB400 AC'97 Audio Controller (rev 02)
00:14.6 0703: 1002:4378 (rev 02) Modem: ATI Technologies Inc ATI SB400 - AC'97 Modem Controller (rev 02)

None of devices in the box assert INTX while in MSI even if INTX is
enabled.

So I'd like to see first patch below accepted.  If there are some devices
which require INTX disabling, then apparently decision whether to disable
it or no has to be moved to device drivers, or some blacklist/whitelist
must be created...

I'm not sure about second one - I have it in my tree for months, but I run
that kernel only on hardware mentioned above, so it is probably too dangerous
until pci_enable_msi() gets answer whether MSI works or no always right.


/proc/interrupts after patch.  Before patch *hci_hcd:usb* were at zero, IRQ21 was
stuck with IRQ count at 10000, and HCD complained about "Unlink after no-IRQ?".

           CPU0
  0:     140326  local-APIC-edge-fasteio   timer
  1:      10773   IO-APIC-edge      i8042
  8:          1   IO-APIC-edge      rtc
 12:      34498   IO-APIC-edge      i8042
 14:      34714   IO-APIC-edge      libata
 15:         82   IO-APIC-edge      libata
 16:          1   IO-APIC-fasteoi   tifm_7xx1, yenta, sdhci:slot0, sdhci:slot1, sdhci:slot2
 21:        265   IO-APIC-fasteoi   acpi, ohci1394
 22:      28973   IO-APIC-fasteoi   ipw2200
216:          1   PCI-MSI-edge      ATI IXP Modem
217:          1   PCI-MSI-edge      ATI IXP
218:          2   PCI-MSI-edge      ehci_hcd:usb3
219:         88   PCI-MSI-edge      ohci_hcd:usb2
220:          1   PCI-MSI-edge      ohci_hcd:usb1
221:          1   PCI-MSI-edge      eth0
NMI:          0
LOC:     140293
ERR:          0
MIS:          0

Do not disable INTX in MSI mode.  It breaks ATI USB HCDs (both OHCI and EHCI).

Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/msi.c          |    2 +-
 drivers/usb/core/hcd-pci.c |    4 ++++
 sound/pci/atiixp.c         |   25 +++++++++++++++++++++++++
 sound/pci/atiixp_modem.c   |   25 +++++++++++++++++++++++++
 4 files changed, 55 insertions(+), 1 deletion(-)

diff -puN drivers/pci/msi.c~unbreak-msi-on-ati-devices drivers/pci/msi.c
--- a/drivers/pci/msi.c~unbreak-msi-on-ati-devices
+++ a/drivers/pci/msi.c
@@ -256,7 +256,7 @@ static void enable_msi_mode(struct pci_d
 		dev->msix_enabled = 1;
 	}
 
-	pci_intx(dev, 0);  /* disable intx */
+	pci_intx(dev, 1);  /* enable intx, on some devices it affects MSI as well */
 }
 
 void disable_msi_mode(struct pci_dev *dev, int pos, int type)
diff -puN drivers/usb/core/hcd-pci.c~unbreak-msi-on-ati-devices drivers/usb/core/hcd-pci.c
--- a/drivers/usb/core/hcd-pci.c~unbreak-msi-on-ati-devices
+++ a/drivers/usb/core/hcd-pci.c
@@ -69,6 +69,7 @@ int usb_hcd_pci_probe (struct pci_dev *d
 
 	if (pci_enable_device (dev) < 0)
 		return -ENODEV;
+	pci_enable_msi(dev);
 	dev->current_state = PCI_D0;
 	dev->dev.power.power_state = PMSG_ON;
 	
@@ -139,6 +140,7 @@ int usb_hcd_pci_probe (struct pci_dev *d
 		release_region (hcd->rsrc_start, hcd->rsrc_len);
  err2:
 	usb_put_hcd (hcd);
+	pci_disable_msi (dev);
  err1:
 	pci_disable_device (dev);
 	dev_err (&dev->dev, "init %s fail, %d\n", pci_name(dev), retval);
@@ -177,6 +179,7 @@ void usb_hcd_pci_remove (struct pci_dev 
 		release_region (hcd->rsrc_start, hcd->rsrc_len);
 	}
 	usb_put_hcd (hcd);
+	pci_disable_msi(dev);
 	pci_disable_device(dev);
 }
 EXPORT_SYMBOL (usb_hcd_pci_remove);
@@ -391,6 +394,7 @@ int usb_hcd_pci_resume (struct pci_dev *
 			"can't re-enable after resume, %d!\n", retval);
 		return retval;
 	}
+	pci_enable_msi (dev);
 	pci_set_master (dev);
 	pci_restore_state (dev);
 
diff -puN sound/pci/atiixp.c~unbreak-msi-on-ati-devices sound/pci/atiixp.c
--- a/sound/pci/atiixp.c~unbreak-msi-on-ati-devices
+++ a/sound/pci/atiixp.c
@@ -63,6 +63,8 @@ MODULE_PARM_DESC(spdif_aclink, "S/PDIF o
 /* just for backward compatibility */
 static int enable;
 module_param(enable, bool, 0444);
+static int msi;
+module_param(msi, bool, 0444);
 
 
 /*
@@ -282,6 +284,8 @@ struct atiixp {
 
 	int spdif_over_aclink;		/* passed from the module option */
 	struct mutex open_mutex;	/* playback open mutex */
+
+	int have_msi;
 };
 
 
@@ -1471,6 +1475,11 @@ static int snd_atiixp_suspend(struct pci
 	snd_atiixp_aclink_down(chip);
 	snd_atiixp_chip_stop(chip);
 
+	if (chip->have_msi) {
+		pci_disable_msi(pci);
+	} else {
+		pci_intx(pci, 0);
+	}
 	pci_disable_device(pci);
 	pci_save_state(pci);
 	pci_set_power_state(pci, pci_choose_state(pci, state));
@@ -1492,6 +1501,11 @@ static int snd_atiixp_resume(struct pci_
 		return -EIO;
 	}
 	pci_set_master(pci);
+	if (chip->have_msi) {
+		pci_enable_msi(pci);
+	} else {
+		pci_intx(pci, 1);
+	}
 
 	snd_atiixp_aclink_reset(chip);
 	snd_atiixp_chip_start(chip);
@@ -1561,6 +1575,11 @@ static int snd_atiixp_free(struct atiixp
 	if (chip->remap_addr)
 		iounmap(chip->remap_addr);
 	pci_release_regions(chip->pci);
+	if (chip->have_msi) {
+		pci_disable_msi(chip->pci);
+	} else {
+		pci_intx(chip->pci, 0);
+	}
 	pci_disable_device(chip->pci);
 	kfree(chip);
 	return 0;
@@ -1612,6 +1631,9 @@ static int __devinit snd_atiixp_create(s
 		return -EIO;
 	}
 
+	if (msi && pci_enable_msi(pci) == 0) {
+		chip->have_msi = 1;
+	}
 	if (request_irq(pci->irq, snd_atiixp_interrupt, IRQF_SHARED,
 			card->shortname, chip)) {
 		snd_printk(KERN_ERR "unable to grab IRQ %d\n", pci->irq);
@@ -1620,6 +1642,9 @@ static int __devinit snd_atiixp_create(s
 	}
 	chip->irq = pci->irq;
 	pci_set_master(pci);
+	if (!chip->have_msi) {
+		pci_intx(pci, 1);
+	}
 	synchronize_irq(chip->irq);
 
 	if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops)) < 0) {
diff -puN sound/pci/atiixp_modem.c~unbreak-msi-on-ati-devices sound/pci/atiixp_modem.c
--- a/sound/pci/atiixp_modem.c~unbreak-msi-on-ati-devices
+++ a/sound/pci/atiixp_modem.c
@@ -54,6 +54,8 @@ MODULE_PARM_DESC(ac97_clock, "AC'97 code
 /* just for backward compatibility */
 static int enable;
 module_param(enable, bool, 0444);
+static int msi;
+module_param(msi, bool, 0444);
 
 
 /*
@@ -257,6 +259,8 @@ struct atiixp_modem {
 
 	int spdif_over_aclink;		/* passed from the module option */
 	struct mutex open_mutex;	/* playback open mutex */
+
+	int have_msi;
 };
 
 
@@ -1128,6 +1132,11 @@ static int snd_atiixp_suspend(struct pci
 	snd_atiixp_aclink_down(chip);
 	snd_atiixp_chip_stop(chip);
 
+	if (chip->have_msi) {
+		pci_disable_msi(pci);
+	} else {
+		pci_intx(pci, 0);
+	}
 	pci_disable_device(pci);
 	pci_save_state(pci);
 	pci_set_power_state(pci, pci_choose_state(pci, state));
@@ -1149,6 +1158,11 @@ static int snd_atiixp_resume(struct pci_
 		return -EIO;
 	}
 	pci_set_master(pci);
+	if (chip->have_msi) {
+		pci_enable_msi(pci);
+	} else {
+		pci_intx(pci, 1);
+	}
 
 	snd_atiixp_aclink_reset(chip);
 	snd_atiixp_chip_start(chip);
@@ -1204,6 +1218,11 @@ static int snd_atiixp_free(struct atiixp
 		free_irq(chip->irq, chip);
 	if (chip->remap_addr)
 		iounmap(chip->remap_addr);
+	if (chip->have_msi) {
+		pci_disable_msi(chip->pci);
+	} else {
+		pci_intx(chip->pci, 0);
+	}
 	pci_release_regions(chip->pci);
 	pci_disable_device(chip->pci);
 	kfree(chip);
@@ -1256,6 +1275,9 @@ static int __devinit snd_atiixp_create(s
 		return -EIO;
 	}
 
+	if (msi && pci_enable_msi(pci) == 0) {
+		chip->have_msi = 1;
+	}
 	if (request_irq(pci->irq, snd_atiixp_interrupt, IRQF_SHARED,
 			card->shortname, chip)) {
 		snd_printk(KERN_ERR "unable to grab IRQ %d\n", pci->irq);
@@ -1264,6 +1286,9 @@ static int __devinit snd_atiixp_create(s
 	}
 	chip->irq = pci->irq;
 	pci_set_master(pci);
+	if (!chip->have_msi) {
+		pci_intx(pci, 1);
+	}
 	synchronize_irq(chip->irq);
 
 	if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops)) < 0) {
_

Patches currently in -mm which might be from petr@vandrovec.name are

git-mmc.patch
