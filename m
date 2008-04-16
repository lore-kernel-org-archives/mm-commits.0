From: akpm@linux-foundation.org
Subject: + smbus-i2c-i801-ioports-request.patch added to -mm tree
Date: Tue, 15 Apr 2008 21:22:12 -0700
Message-ID: <200804160422.m3G4MCp5031793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbYDPEWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 00:22:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muvarov@ru.mvista.com, khali@linux-fr.org


The patch titled
     i2c: SMbus i2c-i801 ioports request
has been added to the -mm tree.  Its filename is
     smbus-i2c-i801-ioports-request.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2c: SMbus i2c-i801 ioports request
From: Maxim Uvarov <muvarov@ru.mvista.com>

MPCBL0040 target has buggy DC752HRA bios with wrong length of SMBus region
(SMBL field).  That makes acpi pnp code reserve incorrect region.  i2c-801
driver fails on requesting ioport region because half of this region is alredy
held by acpi pnp and regions lengths are not match.  This patch requests each
ioport separately so it doesn't matter now if ioport is reserved by acpi pnp
or not.

This patch makes extra records in /proc/ioport.  One record per ioport = 20
lines.  In case with DC752HRA bios we can request ioports on 2 commands and we
will have only 2 lines in /proc/ioport.  But this solution is more universal.

Signed-off-by: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-i801.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN drivers/i2c/busses/i2c-i801.c~smbus-i2c-i801-ioports-request drivers/i2c/busses/i2c-i801.c
--- a/drivers/i2c/busses/i2c-i801.c~smbus-i2c-i801-ioports-request
+++ a/drivers/i2c/busses/i2c-i801.c
@@ -602,6 +602,7 @@ static int __devinit i801_probe(struct p
 {
 	unsigned char temp;
 	int err;
+	int idx;
 
 	I801_dev = dev;
 	i801_features = 0;
@@ -644,12 +645,15 @@ static int __devinit i801_probe(struct p
 	if (err)
 		goto exit;
 
-	err = pci_request_region(dev, SMBBAR, i801_driver.name);
-	if (err) {
-		dev_err(&dev->dev, "Failed to request SMBus region "
-			"0x%lx-0x%Lx\n", i801_smba,
-			(unsigned long long)pci_resource_end(dev, SMBBAR));
-		goto exit;
+	for (idx = 0; idx < pci_resource_len(dev, SMBBAR); idx++) {
+		if (!request_region(i801_smba + idx, 1, i801_driver.name)) {
+				while (idx--)
+					release_region(i801_smba + idx, 1);
+				dev_err(&dev->dev, "Failed to request SMBus region "
+					"0x%lx-0x%Lx\n", i801_smba,
+					(unsigned long long)pci_resource_end(dev, SMBBAR));
+				goto exit;
+		}
 	}
 
 	pci_read_config_byte(I801_dev, SMBHSTCFG, &temp);
@@ -684,7 +688,8 @@ static int __devinit i801_probe(struct p
 	return 0;
 
 exit_release:
-	pci_release_region(dev, SMBBAR);
+	for (idx = 0; idx < pci_resource_len(dev, SMBBAR); idx++)
+		release_region(i801_smba + idx, 1);
 exit:
 	return err;
 }
_

Patches currently in -mm which might be from muvarov@ru.mvista.com are

smbus-i2c-i801-ioports-request.patch

