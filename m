From: akpm@osdl.org
Subject: + hp100-convert-pci_module_init-to-pci_register_driver.patch added to -mm tree
Date: Sun, 28 Jan 2007 15:55:58 -0800
Message-ID: <200701282355.l0SNtwxE006419@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42561 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932978AbXA1X4J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 18:56:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se, jeff@garzik.org


The patch titled
     hp100: convert pci_module_init() to pci_register_driver()
has been added to the -mm tree.  Its filename is
     hp100-convert-pci_module_init-to-pci_register_driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hp100: convert pci_module_init() to pci_register_driver()
From: Richard Knutsson <ricknu-0@student.ltu.se>

Convert pci_module_init() to pci_register_driver().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/hp100.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/hp100.c~hp100-convert-pci_module_init-to-pci_register_driver drivers/net/hp100.c
--- a/drivers/net/hp100.c~hp100-convert-pci_module_init-to-pci_register_driver
+++ a/drivers/net/hp100.c
@@ -3034,7 +3034,7 @@ static int __init hp100_module_init(void
 		goto out2;
 #endif
 #ifdef CONFIG_PCI
-	err = pci_module_init(&hp100_pci_driver);
+	err = pci_register_driver(&hp100_pci_driver);
 	if (err && err != -ENODEV)
 		goto out3;
 #endif
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

hp100-convert-pci_module_init-to-pci_register_driver.patch
drivers-scsi-buslogic-replace-boolean-by-bool.patch
git-cryptodev.patch
drivers-block-dac960-converted-boolean-to-bool.patch
