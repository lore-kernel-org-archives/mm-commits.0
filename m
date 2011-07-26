From: akpm@linux-foundation.org
Subject: [folded] misc-eeprom-add-driver-for-microwire-93xx46-eeprom-fix.patch removed from -mm tree
Date: Mon, 25 Jul 2011 17:01:29 -0700
Message-ID: <201107260001.p6Q01Tew006537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169Ab1GZABf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 20:01:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, agust@denx.de, mm-commits@vger.kernel.org


The patch titled
     misc-eeprom-add-driver-for-microwire-93xx46-eeprom-fix
has been removed from the -mm tree.  Its filename was
     misc-eeprom-add-driver-for-microwire-93xx46-eeprom-fix.patch

This patch was dropped because it was folded into misc-eeprom-add-driver-for-microwire-93xx46-eeproms.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: misc-eeprom-add-driver-for-microwire-93xx46-eeprom-fix
From: Randy Dunlap <randy.dunlap@oracle.com>

fix printk format

drivers/misc/eeprom/eeprom_93xx46.c:95: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/eeprom/eeprom_93xx46.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/eeprom/eeprom_93xx46.c~misc-eeprom-add-driver-for-microwire-93xx46-eeprom-fix drivers/misc/eeprom/eeprom_93xx46.c
--- a/drivers/misc/eeprom/eeprom_93xx46.c~misc-eeprom-add-driver-for-microwire-93xx46-eeprom-fix
+++ a/drivers/misc/eeprom/eeprom_93xx46.c
@@ -91,7 +91,7 @@ eeprom_93xx46_bin_read(struct file *filp
 	/* have to wait at least Tcsl ns */
 	ndelay(250);
 	if (ret) {
-		dev_err(&edev->spi->dev, "read %d bytes at %d: err. %d\n",
+		dev_err(&edev->spi->dev, "read %zu bytes at %d: err. %d\n",
 			count, (int)off, ret);
 	}
 
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
um-clean-up-vm-flagsh.patch
asm-generic-iomaph-add-stubs-for-pci-iomap-iounmap.patch
kernel-configsc-include-module_-when-config_ikconfig_proc=n.patch
drivers-firmware-sigmac-needs-module_license.patch
misc-eeprom-add-driver-for-microwire-93xx46-eeproms.patch

