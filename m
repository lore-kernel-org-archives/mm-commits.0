From: akpm@linux-foundation.org
Subject: - sound-pci-ioremap-iounmap-balancing.patch removed from -mm tree
Date: Sat, 11 Aug 2007 02:31:13 -0700
Message-ID: <200708110931.l7B9VDlg002538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48340 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427AbXHKJcC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 11 Aug 2007 05:32:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: postfail@hushmail.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     sound/pci ioremap/iounmap balancing
has been removed from the -mm tree.  Its filename was
     sound-pci-ioremap-iounmap-balancing.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: sound/pci ioremap/iounmap balancing
From: "Scott Thompson" <postfail@hushmail.com>

ioremap / iounmap balancing in sound/pci tree

Signed-off-by: Scott Thompson <postfail@hushmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/mixart/mixart.c   |    7 +++++++
 sound/pci/rme32.c           |    4 ++++
 sound/pci/rme96.c           |    4 ++++
 sound/pci/rme9652/hdsp.c    |   21 ++++++++++++++++-----
 sound/pci/rme9652/hdspm.c   |    6 +++++-
 sound/pci/rme9652/rme9652.c |    4 ++++
 6 files changed, 40 insertions(+), 6 deletions(-)

diff -puN sound/pci/mixart/mixart.c~sound-pci-ioremap-iounmap-balancing sound/pci/mixart/mixart.c
--- a/sound/pci/mixart/mixart.c~sound-pci-ioremap-iounmap-balancing
+++ a/sound/pci/mixart/mixart.c
@@ -1319,6 +1319,13 @@ static int __devinit snd_mixart_probe(st
 						   pci_resource_len(pci, i));
 	}
 
+	if (!mgr->mem[0].virt || !mgr->mem[1].virt){
+		printk(KERN_ERR "unable to remap resource 0x%lx and/or 0x%lx\n",
+			mgr->mem[0].phys, mgr->mem[1].phys);
+		snd_mixart_free(mgr);
+		return -EBUSY;
+	}
+
 	if (request_irq(pci->irq, snd_mixart_interrupt, IRQF_SHARED,
 			CARD_NAME, mgr)) {
 		snd_printk(KERN_ERR "unable to grab IRQ %d\n", pci->irq);
diff -puN sound/pci/rme32.c~sound-pci-ioremap-iounmap-balancing sound/pci/rme32.c
--- a/sound/pci/rme32.c~sound-pci-ioremap-iounmap-balancing
+++ a/sound/pci/rme32.c
@@ -1373,6 +1373,7 @@ static int __devinit snd_rme32_create(st
 	if (request_irq(pci->irq, snd_rme32_interrupt, IRQF_SHARED,
 			"RME32", rme32)) {
 		snd_printk(KERN_ERR "unable to grab IRQ %d\n", pci->irq);
+		iounmap(rme32->iobase);
 		return -EBUSY;
 	}
 	rme32->irq = pci->irq;
@@ -1382,6 +1383,7 @@ static int __devinit snd_rme32_create(st
 
 	/* set up ALSA pcm device for S/PDIF */
 	if ((err = snd_pcm_new(rme32->card, "Digi32 IEC958", 0, 1, 1, &rme32->spdif_pcm)) < 0) {
+		iounmap(rme32->iobase);
 		return err;
 	}
 	rme32->spdif_pcm->private_data = rme32;
@@ -1414,6 +1416,7 @@ static int __devinit snd_rme32_create(st
 		if ((err = snd_pcm_new(rme32->card, "Digi32 ADAT", 1,
 				       1, 1, &rme32->adat_pcm)) < 0)
 		{
+			iounmap(rme32->iobase);
 			return err;
 		}		
 		rme32->adat_pcm->private_data = rme32;
@@ -1459,6 +1462,7 @@ static int __devinit snd_rme32_create(st
 
 	/* init switch interface */
 	if ((err = snd_rme32_create_switches(rme32->card, rme32)) < 0) {
+		iounmap(rme32->iobase);
 		return err;
 	}
 
diff -puN sound/pci/rme96.c~sound-pci-ioremap-iounmap-balancing sound/pci/rme96.c
--- a/sound/pci/rme96.c~sound-pci-ioremap-iounmap-balancing
+++ a/sound/pci/rme96.c
@@ -1590,6 +1590,7 @@ snd_rme96_create(struct rme96 *rme96)
 	if (request_irq(pci->irq, snd_rme96_interrupt, IRQF_SHARED,
 			"RME96", rme96)) {
 		snd_printk(KERN_ERR "unable to grab IRQ %d\n", pci->irq);
+		iounmap(rme96->iobase);
 		return -EBUSY;
 	}
 	rme96->irq = pci->irq;
@@ -1601,6 +1602,7 @@ snd_rme96_create(struct rme96 *rme96)
 	if ((err = snd_pcm_new(rme96->card, "Digi96 IEC958", 0,
 			       1, 1, &rme96->spdif_pcm)) < 0)
 	{
+		iounmap(rme96->iobase);
 		return err;
 	}
 	rme96->spdif_pcm->private_data = rme96;
@@ -1619,6 +1621,7 @@ snd_rme96_create(struct rme96 *rme96)
 		if ((err = snd_pcm_new(rme96->card, "Digi96 ADAT", 1,
 				       1, 1, &rme96->adat_pcm)) < 0)
 		{
+			iounmap(rme96->iobase);
 			return err;
 		}		
 		rme96->adat_pcm->private_data = rme96;
@@ -1671,6 +1674,7 @@ snd_rme96_create(struct rme96 *rme96)
 	
 	/* init switch interface */
 	if ((err = snd_rme96_create_switches(rme96->card, rme96)) < 0) {
+		iounmap(rme96->iobase);
 		return err;
 	}
 
diff -puN sound/pci/rme9652/hdsp.c~sound-pci-ioremap-iounmap-balancing sound/pci/rme9652/hdsp.c
--- a/sound/pci/rme9652/hdsp.c~sound-pci-ioremap-iounmap-balancing
+++ a/sound/pci/rme9652/hdsp.c
@@ -5000,6 +5000,7 @@ static int __devinit snd_hdsp_create(str
 	if (request_irq(pci->irq, snd_hdsp_interrupt, IRQF_SHARED,
 			"hdsp", hdsp)) {
 		snd_printk(KERN_ERR "Hammerfall-DSP: unable to use IRQ %d\n", pci->irq);
+		iounmap(hdsp->iobase);
 		return -EBUSY;
 	}
 
@@ -5008,8 +5009,10 @@ static int __devinit snd_hdsp_create(str
 	hdsp->use_midi_tasklet = 1;
 	hdsp->dds_value = 0;
 
-	if ((err = snd_hdsp_initialize_memory(hdsp)) < 0)
+	if ((err = snd_hdsp_initialize_memory(hdsp)) < 0) {
+		iounmap(hdsp->iobase);
 		return err;
+	}
 	
 	if (!is_9652 && !is_9632) {
 		/* we wait 2 seconds to let freshly inserted cardbus cards do their hardware init */
@@ -5029,8 +5032,10 @@ static int __devinit snd_hdsp_create(str
 #endif
 			/* no iobox connected, we defer initialization */
 			snd_printk(KERN_INFO "Hammerfall-DSP: card initialization pending : waiting for firmware\n");
-			if ((err = snd_hdsp_create_hwdep(card, hdsp)) < 0)
+			if ((err = snd_hdsp_create_hwdep(card, hdsp)) < 0) {
+				iounmap(hdsp->iobase);
 				return err;
+			}
 			return 0;
 		} else {
 			snd_printk(KERN_INFO "Hammerfall-DSP: Firmware already present, initializing card.\n");	    
@@ -5041,8 +5046,10 @@ static int __devinit snd_hdsp_create(str
 		}
 	}
 	
-	if ((err = snd_hdsp_enable_io(hdsp)) != 0)
+	if ((err = snd_hdsp_enable_io(hdsp)) != 0) {
+		iounmap(hdsp->iobase);
 		return err;
+	}
 	
 	if (is_9652)
 	        hdsp->io_type = H9652;
@@ -5050,16 +5057,20 @@ static int __devinit snd_hdsp_create(str
 	if (is_9632)
 		hdsp->io_type = H9632;
 
-	if ((err = snd_hdsp_create_hwdep(card, hdsp)) < 0)
+	if ((err = snd_hdsp_create_hwdep(card, hdsp)) < 0) {
+		iounmap(hdsp->iobase);
 		return err;
+	}
 	
 	snd_hdsp_initialize_channels(hdsp);
 	snd_hdsp_initialize_midi_flush(hdsp);
 
 	hdsp->state |= HDSP_FirmwareLoaded;	
 
-	if ((err = snd_hdsp_create_alsa_devices(card, hdsp)) < 0)
+	if ((err = snd_hdsp_create_alsa_devices(card, hdsp)) < 0) {
+		iounmap(hdsp->iobase);
 		return err;
+	}
 
 	return 0;	
 }
diff -puN sound/pci/rme9652/hdspm.c~sound-pci-ioremap-iounmap-balancing sound/pci/rme9652/hdspm.c
--- a/sound/pci/rme9652/hdspm.c~sound-pci-ioremap-iounmap-balancing
+++ a/sound/pci/rme9652/hdspm.c
@@ -4416,6 +4416,7 @@ static int __devinit snd_hdspm_create(st
 	if (request_irq(pci->irq, snd_hdspm_interrupt,
 			IRQF_SHARED, "hdspm", hdspm)) {
 		snd_printk(KERN_ERR "HDSPM: unable to use IRQ %d\n", pci->irq);
+		iounmap(hdspm->iobase);
 		return -EBUSY;
 	}
 
@@ -4433,6 +4434,7 @@ static int __devinit snd_hdspm_create(st
 		snd_printk(KERN_ERR "HDSPM: "
 			   "unable to kmalloc Mixer memory of %d Bytes\n",
 			   (int)sizeof(struct hdspm_mixer));
+		iounmap(hdspm->iobase);
 		return err;
 	}
 
@@ -4442,8 +4444,10 @@ static int __devinit snd_hdspm_create(st
 
 	snd_printdd("create alsa devices.\n");
 	err = snd_hdspm_create_alsa_devices(card, hdspm);
-	if (err < 0)
+	if (err < 0) {
+		iounmap(hdspm->iobase);
 		return err;
+	}
 
 	snd_hdspm_initialize_midi_flush(hdspm);
 
diff -puN sound/pci/rme9652/rme9652.c~sound-pci-ioremap-iounmap-balancing sound/pci/rme9652/rme9652.c
--- a/sound/pci/rme9652/rme9652.c~sound-pci-ioremap-iounmap-balancing
+++ a/sound/pci/rme9652/rme9652.c
@@ -2478,6 +2478,7 @@ static int __devinit snd_rme9652_create(
 	if (request_irq(pci->irq, snd_rme9652_interrupt, IRQF_SHARED,
 			"rme9652", rme9652)) {
 		snd_printk(KERN_ERR "unable to request IRQ %d\n", pci->irq);
+		iounmap(rme9652->iobase);
 		return -EBUSY;
 	}
 	rme9652->irq = pci->irq;
@@ -2538,14 +2539,17 @@ static int __devinit snd_rme9652_create(
 	pci_set_master(rme9652->pci);
 
 	if ((err = snd_rme9652_initialize_memory(rme9652)) < 0) {
+		iounmap(rme9652->iobase);
 		return err;
 	}
 
 	if ((err = snd_rme9652_create_pcm(card, rme9652)) < 0) {
+		iounmap(rme9652->iobase);
 		return err;
 	}
 
 	if ((err = snd_rme9652_create_controls(card, rme9652)) < 0) {
+		iounmap(rme9652->iobase);
 		return err;
 	}
 
_

Patches currently in -mm which might be from postfail@hushmail.com are

git-alsa.patch
sound-pci-ioremap-iounmap-balancing.patch
