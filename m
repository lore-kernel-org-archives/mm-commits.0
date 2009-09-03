From: akpm@linux-foundation.org
Subject: + tpm-fixup-pcrs-sysfs-file.patch added to -mm tree
Date: Thu, 03 Sep 2009 16:52:50 -0700
Message-ID: <200909032352.n83NqoAN028324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756580AbZICXy1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Sep 2009 19:54:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jgunthorpe@obsidianresearch.com, debora@linux.vnet.ibm.com, jmorris@namei.org, m.selhorst@sirrix.com, srajiv@linux.vnet.ibm.com


The patch titled
     tpm: fix up pcrs sysfs file
has been added to the -mm tree.  Its filename is
     tpm-fixup-pcrs-sysfs-file.patch

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

The TCG spec says the reply size is supposed to be 30 bytes.

The length input to transmit_cmd is the size of the reply, not of the
request.  It should be 30 for READ_PCR.

With this change my chip reports all 23 pcrs.

Also, the BUILD_BUG_ON() is just wrong - it's testing a value which isn't
a compile-time constant.  Simply remove that assertion.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Marcel Selhorst <m.selhorst@sirrix.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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
_

Patches currently in -mm which might be from jgunthorpe@obsidianresearch.com are

tpm-fixup-pcrs-sysfs-file.patch
linux-next.patch

