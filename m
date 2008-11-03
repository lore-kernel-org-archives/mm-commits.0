From: akpm@linux-foundation.org
Subject: + edac-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch added to -mm tree
Date: Mon, 03 Nov 2008 14:54:05 -0800
Message-ID: <200811032254.mA3Ms53s016079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753629AbYKCWyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 17:54:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, dougthompson@xmission.com, gregkh@suse.de


The patch titled
     edac: struct device: replace bus_id with dev_name(), dev_set_name()
has been added to the -mm tree.  Its filename is
     edac-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: struct device: replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>

This patch is part of a larger patch series which will remove the "char
bus_id[20]" name string from struct device.  The device name is managed in
the kobject anyway, and without any size limitation, and just needlessly
copied into "struct device".

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_device.c    |    2 +-
 drivers/edac/edac_mc.c        |    2 +-
 drivers/edac/edac_pci.c       |    2 +-
 drivers/edac/edac_pci_sysfs.c |    6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/edac/edac_device.c~edac-struct-device-replace-bus_id-with-dev_name-dev_set_name drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~edac-struct-device-replace-bus_id-with-dev_name-dev_set_name
+++ a/drivers/edac/edac_device.c
@@ -333,7 +333,7 @@ static int add_edac_dev_to_global_list(s
 fail0:
 	edac_printk(KERN_WARNING, EDAC_MC,
 			"%s (%s) %s %s already assigned %d\n",
-			rover->dev->bus_id, edac_dev_name(rover),
+			dev_name(rover->dev), edac_dev_name(rover),
 			rover->mod_name, rover->ctl_name, rover->dev_idx);
 	return 1;
 
diff -puN drivers/edac/edac_mc.c~edac-struct-device-replace-bus_id-with-dev_name-dev_set_name drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~edac-struct-device-replace-bus_id-with-dev_name-dev_set_name
+++ a/drivers/edac/edac_mc.c
@@ -401,7 +401,7 @@ static int add_mc_to_global_list(struct 
 
 fail0:
 	edac_printk(KERN_WARNING, EDAC_MC,
-		"%s (%s) %s %s already assigned %d\n", p->dev->bus_id,
+		"%s (%s) %s %s already assigned %d\n",dev_name( p->dev),
 		edac_dev_name(mci), p->mod_name, p->ctl_name, p->mc_idx);
 	return 1;
 
diff -puN drivers/edac/edac_pci.c~edac-struct-device-replace-bus_id-with-dev_name-dev_set_name drivers/edac/edac_pci.c
--- a/drivers/edac/edac_pci.c~edac-struct-device-replace-bus_id-with-dev_name-dev_set_name
+++ a/drivers/edac/edac_pci.c
@@ -150,7 +150,7 @@ static int add_edac_pci_to_global_list(s
 fail0:
 	edac_printk(KERN_WARNING, EDAC_PCI,
 		"%s (%s) %s %s already assigned %d\n",
-		rover->dev->bus_id, edac_dev_name(rover),
+		dev_name(rover->dev), edac_dev_name(rover),
 		rover->mod_name, rover->ctl_name, rover->pci_idx);
 	return 1;
 
diff -puN drivers/edac/edac_pci_sysfs.c~edac-struct-device-replace-bus_id-with-dev_name-dev_set_name drivers/edac/edac_pci_sysfs.c
--- a/drivers/edac/edac_pci_sysfs.c~edac-struct-device-replace-bus_id-with-dev_name-dev_set_name
+++ a/drivers/edac/edac_pci_sysfs.c
@@ -569,7 +569,7 @@ static void edac_pci_dev_parity_test(str
 
 	local_irq_restore(flags);
 
-	debugf4("PCI STATUS= 0x%04x %s\n", status, dev->dev.bus_id);
+	debugf4("PCI STATUS= 0x%04x %s\n", status, dev_name(&dev->dev));
 
 	/* check the status reg for errors on boards NOT marked as broken
 	 * if broken, we cannot trust any of the status bits
@@ -600,13 +600,13 @@ static void edac_pci_dev_parity_test(str
 	}
 
 
-	debugf4("PCI HEADER TYPE= 0x%02x %s\n", header_type, dev->dev.bus_id);
+	debugf4("PCI HEADER TYPE= 0x%02x %s\n", header_type, dev_name(&dev->dev));
 
 	if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
 		/* On bridges, need to examine secondary status register  */
 		status = get_pci_parity_status(dev, 1);
 
-		debugf4("PCI SEC_STATUS= 0x%04x %s\n", status, dev->dev.bus_id);
+		debugf4("PCI SEC_STATUS= 0x%04x %s\n", status, dev_name(&dev->dev));
 
 		/* check the secondary status reg for errors,
 		 * on NOT broken boards
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

linux-next.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch

