From: akpm@linux-foundation.org
Subject: + tpm-fixup-pcrs-sysfs-file-update.patch added to -mm tree
Date: Fri, 04 Sep 2009 13:52:15 -0700
Message-ID: <200909042052.n84KqFpD008740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933903AbZIDUyP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2009 16:54:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jgunthorpe@obsidianresearch.com, debora@linux.vnet.ibm.com, jmorris@namei.org, m.selhorst@sirrix.com, srajiv@linux.vnet.ibm.com


The patch titled
     tpm-fixup-pcrs-sysfs-file-update
has been added to the -mm tree.  Its filename is
     tpm-fixup-pcrs-sysfs-file-update.patch

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
Subject: tpm-fixup-pcrs-sysfs-file-update
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Marcel Selhorst <m.selhorst@sirrix.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-fixup-pcrs-sysfs-file-update drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-fixup-pcrs-sysfs-file-update
+++ a/drivers/char/tpm/tpm.c
@@ -741,7 +741,7 @@ EXPORT_SYMBOL_GPL(tpm_pcr_read);
  * the module usage count.
  */
 #define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
-#define EXTEND_PCR_SIZE 34
+#define EXTEND_PCR_RESULT_SIZE 34
 static struct tpm_input_header pcrextend_header = {
 	.tag = TPM_TAG_RQU_COMMAND,
 	.length = cpu_to_be32(34),
@@ -759,10 +759,9 @@ int tpm_pcr_extend(u32 chip_num, int pcr
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

linux-next.patch
tpm-fixup-pcrs-sysfs-file.patch
tpm-fixup-pcrs-sysfs-file-update.patch

