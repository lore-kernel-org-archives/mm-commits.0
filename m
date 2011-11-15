From: akpm@linux-foundation.org
Subject: + pch_phub-improve-adeaddress-decode-enable-control.patch added to -mm tree
Date: Mon, 14 Nov 2011 16:15:08 -0800
Message-ID: <201111150015.pAF0F9C3010828@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:34560 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1KOAUO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 19:20:14 -0500
Received: by wwe5 with SMTP id 5so124292wwe.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 16:20:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomoya.rohm@gmail.com, alexander.stein@systec-electronic.com, denis@compulab.co.il, gregkh@suse.de, masa-korg@dsn.okisemi.com


The patch titled
     Subject: pch_phub: improve ADE (Address Decode Enable) control
has been added to the -mm tree.  Its filename is
     pch_phub-improve-adeaddress-decode-enable-control.patch

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
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: pch_phub: improve ADE (Address Decode Enable) control

Currently, external ROM access is enabled/disabled in probe()/remove(). 
So, when a buggy software access unanticipated memory area, in case of
enabling this ADE bit, external ROM memory area can be broken.

This patch enables the ADE bit only accessing external ROM area.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Denis Turischev <denis@compulab.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/pch_phub.c |   51 +++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff -puN drivers/misc/pch_phub.c~pch_phub-improve-adeaddress-decode-enable-control drivers/misc/pch_phub.c
--- a/drivers/misc/pch_phub.c~pch_phub-improve-adeaddress-decode-enable-control
+++ a/drivers/misc/pch_phub.c
@@ -115,6 +115,7 @@
  * @pch_mac_start_address:		MAC address area start address
  * @pch_opt_rom_start_address:		Option ROM start address
  * @ioh_type:				Save IOH type
+ * @pdev:				pointer to pci device struct
  */
 struct pch_phub_reg {
 	u32 phub_id_reg;
@@ -136,6 +137,7 @@ struct pch_phub_reg {
 	u32 pch_mac_start_address;
 	u32 pch_opt_rom_start_address;
 	int ioh_type;
+	struct pci_dev *pdev;
 };
 
 /* SROM SPEC for MAC address assignment offset */
@@ -498,6 +500,7 @@ static ssize_t pch_phub_bin_read(struct 
 	unsigned int orom_size;
 	int ret;
 	int err;
+	ssize_t rom_size;
 
 	struct pch_phub_reg *chip =
 		dev_get_drvdata(container_of(kobj, struct device, kobj));
@@ -509,6 +512,10 @@ static ssize_t pch_phub_bin_read(struct 
 	}
 
 	/* Get Rom signature */
+	chip->pch_phub_extrom_base_address = pci_map_rom(chip->pdev, &rom_size);
+	if (!chip->pch_phub_extrom_base_address)
+		goto exrom_map_err;
+
 	pch_phub_read_serial_rom(chip, chip->pch_opt_rom_start_address,
 				(unsigned char *)&rom_signature);
 	rom_signature &= 0xff;
@@ -539,10 +546,13 @@ static ssize_t pch_phub_bin_read(struct 
 		goto return_err;
 	}
 return_ok:
+	pci_unmap_rom(chip->pdev, chip->pch_phub_extrom_base_address);
 	mutex_unlock(&pch_phub_mutex);
 	return addr_offset;
 
 return_err:
+	pci_unmap_rom(chip->pdev, chip->pch_phub_extrom_base_address);
+exrom_map_err:
 	mutex_unlock(&pch_phub_mutex);
 return_err_nomutex:
 	return err;
@@ -555,6 +565,7 @@ static ssize_t pch_phub_bin_write(struct
 	int err;
 	unsigned int addr_offset;
 	int ret;
+	ssize_t rom_size;
 	struct pch_phub_reg *chip =
 		dev_get_drvdata(container_of(kobj, struct device, kobj));
 
@@ -571,6 +582,12 @@ static ssize_t pch_phub_bin_write(struct
 		goto return_ok;
 	}
 
+	chip->pch_phub_extrom_base_address = pci_map_rom(chip->pdev, &rom_size);
+	if (!chip->pch_phub_extrom_base_address) {
+		err = -ENOMEM;
+		goto exrom_map_err;
+	}
+
 	for (addr_offset = 0; addr_offset < count; addr_offset++) {
 		if (PCH_PHUB_OROM_SIZE < off + addr_offset)
 			goto return_ok;
@@ -585,10 +602,14 @@ static ssize_t pch_phub_bin_write(struct
 	}
 
 return_ok:
+	pci_unmap_rom(chip->pdev, chip->pch_phub_extrom_base_address);
 	mutex_unlock(&pch_phub_mutex);
 	return addr_offset;
 
 return_err:
+	pci_unmap_rom(chip->pdev, chip->pch_phub_extrom_base_address);
+
+exrom_map_err:
 	mutex_unlock(&pch_phub_mutex);
 	return err;
 }
@@ -598,8 +619,14 @@ static ssize_t show_pch_mac(struct devic
 {
 	u8 mac[8];
 	struct pch_phub_reg *chip = dev_get_drvdata(dev);
+	ssize_t rom_size;
+
+	chip->pch_phub_extrom_base_address = pci_map_rom(chip->pdev, &rom_size);
+	if (!chip->pch_phub_extrom_base_address)
+		return -ENOMEM;
 
 	pch_phub_read_gbe_mac_addr(chip, mac);
+	pci_unmap_rom(chip->pdev, chip->pch_phub_extrom_base_address);
 
 	return sprintf(buf, "%pM\n", mac);
 }
@@ -608,6 +635,7 @@ static ssize_t store_pch_mac(struct devi
 			     const char *buf, size_t count)
 {
 	u8 mac[6];
+	ssize_t rom_size;
 	struct pch_phub_reg *chip = dev_get_drvdata(dev);
 
 	if (count != 18)
@@ -617,7 +645,12 @@ static ssize_t store_pch_mac(struct devi
 		(u32 *)&mac[0], (u32 *)&mac[1], (u32 *)&mac[2], (u32 *)&mac[3],
 		(u32 *)&mac[4], (u32 *)&mac[5]);
 
+	chip->pch_phub_extrom_base_address = pci_map_rom(chip->pdev, &rom_size);
+	if (!chip->pch_phub_extrom_base_address)
+		return -ENOMEM;
+
 	pch_phub_write_gbe_mac_addr(chip, mac);
+	pci_unmap_rom(chip->pdev, chip->pch_phub_extrom_base_address);
 
 	return count;
 }
@@ -640,7 +673,6 @@ static int __devinit pch_phub_probe(stru
 	int retval;
 
 	int ret;
-	ssize_t rom_size;
 	struct pch_phub_reg *chip;
 
 	chip = kzalloc(sizeof(struct pch_phub_reg), GFP_KERNEL);
@@ -677,19 +709,7 @@ static int __devinit pch_phub_probe(stru
 		"in pch_phub_base_address variable is %p\n", __func__,
 		chip->pch_phub_base_address);
 
-	if (id->driver_data != 3) {
-		chip->pch_phub_extrom_base_address =\
-						   pci_map_rom(pdev, &rom_size);
-		if (chip->pch_phub_extrom_base_address == 0) {
-			dev_err(&pdev->dev, "%s: pci_map_rom FAILED", __func__);
-			ret = -ENOMEM;
-			goto err_pci_map;
-		}
-		dev_dbg(&pdev->dev, "%s : "
-			"pci_map_rom SUCCESS and value in "
-			"pch_phub_extrom_base_address variable is %p\n",
-			__func__, chip->pch_phub_extrom_base_address);
-	}
+	chip->pdev = pdev; /* Save pci device struct */
 
 	if (id->driver_data == 1) { /* EG20T PCH */
 		const char *board_name;
@@ -773,8 +793,6 @@ exit_bin_attr:
 	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_pch_mac.attr);
 
 err_sysfs_create:
-	pci_unmap_rom(pdev, chip->pch_phub_extrom_base_address);
-err_pci_map:
 	pci_iounmap(pdev, chip->pch_phub_base_address);
 err_pci_iomap:
 	pci_release_regions(pdev);
@@ -792,7 +810,6 @@ static void __devexit pch_phub_remove(st
 
 	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_pch_mac.attr);
 	sysfs_remove_bin_file(&pdev->dev.kobj, &pch_bin_attr);
-	pci_unmap_rom(pdev, chip->pch_phub_extrom_base_address);
 	pci_iounmap(pdev, chip->pch_phub_base_address);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
_
Subject: Subject: pch_phub: improve ADE (Address Decode Enable) control

Patches currently in -mm which might be from tomoya.rohm@gmail.com are

pch_phub-improve-adeaddress-decode-enable-control.patch
pch_phub-fix-mac-address-writing-issue-for-lapis-ml7831.patch

