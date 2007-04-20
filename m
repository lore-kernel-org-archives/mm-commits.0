From: akpm@linux-foundation.org
Subject: + alsa-intel8x0-fix-oops-in-crash-kernel.patch added to -mm tree
Date: Fri, 20 Apr 2007 11:17:29 -0700
Message-ID: <200704201817.l3KIHTnR020875@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993308AbXDTSSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 14:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, bunk@stusta.de, cebbert@redhat.com, michal.k.k.piotrowski@gmail.com, perex@suse.cz


The patch titled
     ALSA: intel8x0 - Fix Oops in kdump crash kernel
has been added to the -mm tree.  Its filename is
     alsa-intel8x0-fix-oops-in-crash-kernel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ALSA: intel8x0 - Fix Oops in kdump crash kernel
From: Takashi Iwai <tiwai@suse.de>

When intel8x0 driver is loaded in the crash kernel, it gets Oops
occasionally.  This is because the irq handler gets called before the
proper hardware initialization.  Now defer it after
snd_intel8x0_chip_init().

(reference: http://lkml.org/lkml/2007/3/5/252)

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/intel8x0.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff -puN sound/pci/intel8x0.c~alsa-intel8x0-fix-oops-in-crash-kernel sound/pci/intel8x0.c
--- a/sound/pci/intel8x0.c~alsa-intel8x0-fix-oops-in-crash-kernel
+++ a/sound/pci/intel8x0.c
@@ -2493,6 +2493,7 @@ static int intel8x0_resume(struct pci_de
 		return -EIO;
 	}
 	pci_set_master(pci);
+	snd_intel8x0_chip_init(chip, 0);
 	if (request_irq(pci->irq, snd_intel8x0_interrupt,
 			IRQF_SHARED, card->shortname, chip)) {
 		printk(KERN_ERR "intel8x0: unable to grab IRQ %d, "
@@ -2502,7 +2503,6 @@ static int intel8x0_resume(struct pci_de
 	}
 	chip->irq = pci->irq;
 	synchronize_irq(chip->irq);
-	snd_intel8x0_chip_init(chip, 0);
 
 	/* re-initialize mixer stuff */
 	if (chip->device_type == DEVICE_INTEL_ICH4 && !spdif_aclink) {
@@ -2862,16 +2862,7 @@ static int __devinit snd_intel8x0_create
 		ICH_REG_ALI_INTERRUPTSR : ICH_REG_GLOB_STA;
 	chip->int_sta_mask = int_sta_masks;
 
-	/* request irq after initializaing int_sta_mask, etc */
-	if (request_irq(pci->irq, snd_intel8x0_interrupt,
-			IRQF_SHARED, card->shortname, chip)) {
-		snd_printk(KERN_ERR "unable to grab IRQ %d\n", pci->irq);
-		snd_intel8x0_free(chip);
-		return -EBUSY;
-	}
-	chip->irq = pci->irq;
 	pci_set_master(pci);
-	synchronize_irq(chip->irq);
 
 	switch(chip->device_type) {
 	case DEVICE_INTEL_ICH4:
@@ -2901,6 +2892,15 @@ static int __devinit snd_intel8x0_create
 		return err;
 	}
 
+	/* request irq after initializaing int_sta_mask, etc */
+	if (request_irq(pci->irq, snd_intel8x0_interrupt,
+			IRQF_SHARED, card->shortname, chip)) {
+		snd_printk(KERN_ERR "unable to grab IRQ %d\n", pci->irq);
+		snd_intel8x0_free(chip);
+		return -EBUSY;
+	}
+	chip->irq = pci->irq;
+
 	if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops)) < 0) {
 		snd_intel8x0_free(chip);
 		return err;
_

Patches currently in -mm which might be from tiwai@suse.de are

alsa-intel8x0-fix-oops-in-crash-kernel.patch
git-alsa.patch
