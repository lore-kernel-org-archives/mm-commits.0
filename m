From: akpm@linux-foundation.org
Subject: [merged] tpm_tis-tpm_sts_data_expect-workaround.patch removed from -mm tree
Date: Mon, 02 Nov 2009 12:45:34 -0800
Message-ID: <200911022045.nA2KjYmn001795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932378AbZKBUph (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2009 15:45:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srajiv@linux.vnet.ibm.com, adi@vmware.com, david.daniel.smith@gmail.com, jmorris@namei.org, seiji.munetoh@gmail.com, shaz.linux@gmail.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     tpm_tis: TPM_STS_DATA_EXPECT workaround
has been removed from the -mm tree.  Its filename was
     tpm_tis-tpm_sts_data_expect-workaround.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm_tis: TPM_STS_DATA_EXPECT workaround
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Some newer Lenovo models are shipped with a TPM that doesn't seem to set
the TPM_STS_DATA_EXPECT status bit when sending it a burst of data, so the
code understands it as a failure and doesn't proceed sending the chip the
intended data.  In this patch we bypass this bit check in case the itpm
module parameter was set.

This patch is based on Andy Isaacson's one:

http://marc.info/?l=linux-kernel&m=124650185023495&w=2

It was heavily discussed how should we deal with identifying the chip in
kernel space, but the required patch to do so was NACK'd:

http://marc.info/?l=linux-kernel&m=124650186423711&w=2

This way we let the user choose using this workaround or not based on his
observations on this code behavior when trying to use the TPM.

Fixed a checkpatch issue present on the previous patch, thanks to Daniel Walker.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Tested-by: Seiji Munetoh <seiji.munetoh@gmail.com>

David Smith <david.daniel.smith@gmail.com>
Cc: Seiji Munetoh <seiji.munetoh@gmail.com>
Cc: Andy Isaacson <adi@vmware.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Shahbaz Khan <shaz.linux@gmail.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/char/tpm/tpm_tis.c~tpm_tis-tpm_sts_data_expect-workaround drivers/char/tpm/tpm_tis.c
--- a/drivers/char/tpm/tpm_tis.c~tpm_tis-tpm_sts_data_expect-workaround
+++ a/drivers/char/tpm/tpm_tis.c
@@ -257,6 +257,10 @@ out:
 	return size;
 }
 
+static int itpm;
+module_param(itpm, bool, 0444);
+MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
+
 /*
  * If interrupts are used (signaled by an irq set in the vendor structure)
  * tpm.c can skip polling for the data to be available as the interrupt is
@@ -293,7 +297,7 @@ static int tpm_tis_send(struct tpm_chip 
 		wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
 			      &chip->vendor.int_queue);
 		status = tpm_tis_status(chip);
-		if ((status & TPM_STS_DATA_EXPECT) == 0) {
+		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
 			rc = -EIO;
 			goto out_err;
 		}
@@ -467,6 +471,10 @@ static int tpm_tis_init(struct device *d
 		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
+	if (itpm)
+		dev_info(dev, "Intel iTPM workaround enabled\n");
+
+
 	/* Figure out the capabilities */
 	intfcaps =
 	    ioread32(chip->vendor.iobase +
_

Patches currently in -mm which might be from srajiv@linux.vnet.ibm.com are

linux-next.patch

