From: akpm@linux-foundation.org
Subject: + tpm-tis-device-driver-locality-request.patch added to -mm tree
Date: Mon, 19 Nov 2007 22:23:13 -0800
Message-ID: <200711200623.lAK6NDKU017699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbXKTGXV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 01:23:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tpm@selhorst.net, kjhall@us.ibm.com


The patch titled
     TPM: fix TIS device driver locality request
has been added to the -mm tree.  Its filename is
     tpm-tis-device-driver-locality-request.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: TPM: fix TIS device driver locality request
From: Marcel Selhorst <tpm@selhorst.net>

During the initialization of the TPM TIS driver, the necessary locality has
to be requested earlier in the init-process.  Depending on the used TPM
chip, this leads to wrong information.  For example: Lenovo X61s with Atmel
TPM:

tpm_tis 00:0a: 1.2 TPM (device-id 0xFFFF, rev-id 255)

But correct is:

tpm_tis 00:0c: 1.2 TPM (device-id 0x3203, rev-id 9)

This short patch fixes this issue.

Signed-off-by: Marcel Selhorst <tpm@selhorst.net>
Cc: Kylene Jo Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_tis.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/char/tpm/tpm_tis.c~tpm-tis-device-driver-locality-request drivers/char/tpm/tpm_tis.c
--- a/drivers/char/tpm/tpm_tis.c~tpm-tis-device-driver-locality-request
+++ a/drivers/char/tpm/tpm_tis.c
@@ -450,6 +450,11 @@ static int tpm_tis_init(struct device *d
 		goto out_err;
 	}
 
+	if (request_locality(chip, 0) != 0) {
+		rc = -ENODEV;
+		goto out_err;
+	}
+
 	vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
 
 	/* Default timeouts */
@@ -487,11 +492,6 @@ static int tpm_tis_init(struct device *d
 	if (intfcaps & TPM_INTF_DATA_AVAIL_INT)
 		dev_dbg(dev, "\tData Avail Int Support\n");
 
-	if (request_locality(chip, 0) != 0) {
-		rc = -ENODEV;
-		goto out_err;
-	}
-
 	/* INTERRUPT Setup */
 	init_waitqueue_head(&chip->vendor.read_queue);
 	init_waitqueue_head(&chip->vendor.int_queue);
_

Patches currently in -mm which might be from tpm@selhorst.net are

tpm-tis-device-driver-locality-request.patch
