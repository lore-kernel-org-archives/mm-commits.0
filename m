From: akpm@linux-foundation.org
Subject: - char-rocket-add-module_device_table.patch removed from -mm tree
Date: Tue, 08 May 2007 19:47:26 -0700
Message-ID: <200705090247.l492lQk3008973@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031868AbXEICrb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:47:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: rocket, add MODULE_DEVICE_TABLE
has been removed from the -mm tree.  Its filename was
     char-rocket-add-module_device_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: rocket, add MODULE_DEVICE_TABLE
From: Jiri Slaby <jirislaby@gmail.com>

rocket, add MODULE_DEVICE_TABLE

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rocket.c |    6 ++++++
 1 file changed, 6 insertions(+)

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

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
