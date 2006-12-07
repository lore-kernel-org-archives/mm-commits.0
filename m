From: akpm@osdl.org
Subject: - sound-oss-btaudioc-ioremap-balanced-with-iounmap.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:00:58 -0800
Message-ID: <200612072300.kB7N0wlJ029687@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51351 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163747AbWLGXBC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:01:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amol@verismonetworks.com, mm-commits@vger.kernel.org


The patch titled
     sound/oss/btaudio.c: ioremap balanced with iounmap
has been removed from the -mm tree.  Its filename was
     sound-oss-btaudioc-ioremap-balanced-with-iounmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sound/oss/btaudio.c: ioremap balanced with iounmap
From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result
in a memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 sound/oss/btaudio.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN sound/oss/btaudio.c~sound-oss-btaudioc-ioremap-balanced-with-iounmap sound/oss/btaudio.c
--- a/sound/oss/btaudio.c~sound-oss-btaudioc-ioremap-balanced-with-iounmap
+++ a/sound/oss/btaudio.c
@@ -1020,6 +1020,7 @@ static int __devinit btaudio_probe(struc
  fail2:
         free_irq(bta->irq,bta);	
  fail1:
+	iounmap(bta->mmio);
 	kfree(bta);
  fail0:
 	release_mem_region(pci_resource_start(pci_dev,0),
@@ -1051,6 +1052,7 @@ static void __devexit btaudio_remove(str
         free_irq(bta->irq,bta);
 	release_mem_region(pci_resource_start(pci_dev,0),
 			   pci_resource_len(pci_dev,0));
+	iounmap(bta->mmio);
 
 	/* remove from linked list */
 	if (bta == btaudios) {
_

Patches currently in -mm which might be from amol@verismonetworks.com are

origin.patch
git-cpufreq.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-megaraidc-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
drivers-isdn-handcrafted-min-max-macro-removal.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
ioremap-balanced-with-iounmap-for-drivers-video-virgefb.patch
ioremap-balanced-with-iounmap-for-drivers-video-vesafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-tridentfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-tgafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-stifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-retz3fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-pvr2fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-platinumfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-offb.patch
ioremap-balanced-with-iounmap-for-drivers-video-macfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-hpfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-fm2fb.patch
ioremap-balanced-with-iounmap-for-drivers-video-ffb.patch
ioremap-balanced-with-iounmap-for-drivers-video-cyberfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-cirrusfb.patch
ioremap-balanced-with-iounmap-for-drivers-video-atyfb_base.patch
ioremap-balanced-with-iounmap-for-drivers-video-atafb.patch
ioremap-balanced-with-iounmap-for-drivers-video-amifb.patch
ioremap-balanced-with-iounmap-for-drivers-video-S3triofb.patch

