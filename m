From: akpm@linux-foundation.org
Subject: [wrecked] tpm-fixup-pcrs-sysfs-file.patch removed from -mm tree
Date: Tue, 22 Sep 2009 16:17:33 -0700
Message-ID: <200909222317.n8MNHXx5023867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862AbZIVXSY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 19:18:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jgunthorpe@obsidianresearch.com, debora@linux.vnet.ibm.com, jmorris@namei.org, m.selhorst@sirrix.com, srajiv@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     tpm: fix up pcrs sysfs file
has been removed from the -mm tree.  Its filename was
     tpm-fixup-pcrs-sysfs-file.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: fix up pcrs sysfs file
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

I'm testing the tpm_tis low level driver with a winbond WPCT200:
$ cat caps
Manufacturer: 0x57454300
TCG version: 1.2
Firmware version: 2.16

and noted that tpm_pcr_read for the pcrs sysfile file does not function. 
tpm_tis_recv returned with an error because the expected reply size was
set to 14 (the request size) and the chip returned 30 bytes.

The TCG spec says the reply size for READ_PCR is supposed to be 30 bytes.

The length input to transmit_cmd is the size of the reply, not of the
request.

With this change my chip reports all 23 pcrs.

Also fix tpm_pcr_extend to match the idiom of the rest of the code to
prevent future confusion.

Finally, the BUILD_BUG_ON() is just wrong - it's testing a value which
isn't a compile-time constant.  Simply remove that assertion, the buffer
is large enough by design.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Marcel Selhorst <m.selhorst@sirrix.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-fixup-pcrs-sysfs-file drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-fixup-pcrs-sysfs-file
+++ a/drivers/char/tpm/tpm.c
@@ -696,8 +696,7 @@ int __tpm_pcr_read(struct tpm_chip *chip
 
 	cmd.header.in = pcrread_header;
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	BUILD_BUG_ON(cmd.header.in.length > READ_PCR_RESULT_SIZE);
-	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
+	rc = transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
 			  "attempting to read a pcr value");
 
 	if (rc == 0)
@@ -742,7 +741,7 @@ EXPORT_SYMBOL_GPL(tpm_pcr_read);
  * the module usage count.
  */
 #define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
-#define EXTEND_PCR_SIZE 34
+#define EXTEND_PCR_RESULT_SIZE 34
 static struct tpm_input_header pcrextend_header = {
 	.tag = TPM_TAG_RQU_COMMAND,
 	.length = cpu_to_be32(34),
@@ -760,10 +759,9 @@ int tpm_pcr_extend(u32 chip_num, int pcr
 		return -ENODEV;
 
 	cmd.header.in = pcrextend_header;
-	BUILD_BUG_ON(be32_to_cpu(cmd.header.in.length) > EXTEND_PCR_SIZE);
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
-	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
+	rc = transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
 			  "attempting extend a PCR value");
 
 	module_put(chip->dev->driver->owner);
_

Patches currently in -mm which might be from jgunthorpe@obsidianresearch.com are

origin.patch
linux-next.patch
tpm-fixup-pcrs-sysfs-file.patch
tpm-fix-up-pubek-sysfs-file.patch

