From: akpm@linux-foundation.org
Subject: - char-cyclades-remove-some-global-vars.patch removed from -mm tree
Date: Tue, 08 May 2007 19:57:09 -0700
Message-ID: <200705090257.l492v9BW010143@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032747AbXEIC5N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:57:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, remove some global vars
has been removed from the -mm tree.  Its filename was
     char-cyclades-remove-some-global-vars.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, remove some global vars
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-remove-some-global-vars drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-remove-some-global-vars
+++ a/drivers/char/cyclades.c
@@ -818,9 +818,6 @@ static int cy_chip_offset[] = { 0x0000,
 
 /* PCI related definitions */
 
-static unsigned short cy_pci_nboard;
-static unsigned short cy_isa_nboard;
-static unsigned short cy_nboard;
 #ifdef CONFIG_PCI
 static struct pci_device_id cy_pci_dev_id[] __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Y_Lo) },	/* PCI < 1Mb */
@@ -5462,7 +5459,7 @@ static const struct tty_operations cy_op
 
 static int __init cy_init(void)
 {
-	unsigned int i;
+	unsigned int i, nboards;
 
 	cy_serial_driver = alloc_tty_driver(NR_PORTS);
 	if (!cy_serial_driver)
@@ -5506,14 +5503,12 @@ static int __init cy_init(void)
 	   the cy_next_channel. */
 
 	/* look for isa boards */
-	cy_isa_nboard = cy_detect_isa();
+	nboards = cy_detect_isa();
 
 	/* look for pci boards */
-	cy_pci_nboard = cy_detect_pci();
-
-	cy_nboard = cy_isa_nboard + cy_pci_nboard;
+	nboards += cy_detect_pci();
 
-	return 0;
+	return nboards ? 0 : -ENODEV;
 }				/* cy_init */
 
 static void __exit cy_cleanup_module(void)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
cinergyt2-fix-file-release-handler.patch
auerswald-fix-file-release-handler.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
vmstat-use-our-own-timer-events-fix.patch
shrink_slab-handle-bad-shrinkers.patch
