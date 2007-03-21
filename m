From: akpm@linux-foundation.org
Subject: + char-rocket-add-module_device_table.patch added to -mm tree
Date: Wed, 21 Mar 2007 16:21:11 -0700
Message-ID: <200703212321.l2LNLBYd006731@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58254 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbXCUXVQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 19:21:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: rocket, add MODULE_DEVICE_TABLE
has been added to the -mm tree.  Its filename is
     char-rocket-add-module_device_table.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: rocket, add MODULE_DEVICE_TABLE
From: Jiri Slaby <jirislaby@gmail.com>

rocket, add MODULE_DEVICE_TABLE

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN drivers/char/rocket.c~char-rocket-add-module_device_table drivers/char/rocket.c
--- a/drivers/char/rocket.c~char-rocket-add-module_device_table
+++ a/drivers/char/rocket.c
@@ -1848,6 +1848,12 @@ static void rp_flush_buffer(struct tty_s
 
 #ifdef CONFIG_PCI
 
+static struct pci_device_id __devinitdata rocket_pci_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_RP, PCI_ANY_ID) },
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, rocket_pci_ids);
+
 /*
  *  Called when a PCI card is found.  Retrieves and stores model information,
  *  init's aiopic and serial port hardware.
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
shrink_slab-handle-bad-shrinkers.patch
