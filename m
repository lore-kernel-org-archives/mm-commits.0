From: akpm@linux-foundation.org
Subject: + tpm-fix-pcrread.patch added to -mm tree
Date: Wed, 30 Sep 2009 16:26:01 -0700
Message-ID: <200909302326.n8UNQ1Lu021383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754410AbZI3X0s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 19:26:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srajiv@linux.vnet.ibm.com, debora@linux.vnet.ibm.com, jgunthorpe@obsidianresearch.com, jmorris@namei.org, m.selhorst@sirrix.com


The patch titled
     tpm: fix pcrread
has been added to the -mm tree.  Its filename is
     tpm-fix-pcrread.patch

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
Subject: tpm: fix pcrread
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

The previously sent patch:

http://marc.info/?l=tpmdd-devel&m=125208945007834&w=2

Had its first hunk cropped when merged, submitting only this first hunk
again.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Marcel Selhorst <m.selhorst@sirrix.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-fix-pcrread drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-fix-pcrread
+++ a/drivers/char/tpm/tpm.c
@@ -696,8 +696,7 @@ int __tpm_pcr_read(struct tpm_chip *chip
 
 	cmd.header.in = pcrread_header;
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	BUG_ON(cmd.header.in.length > READ_PCR_RESULT_SIZE);
-	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
+	rc = transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
 			  "attempting to read a pcr value");
 
 	if (rc == 0)
_

Patches currently in -mm which might be from srajiv@linux.vnet.ibm.com are

linux-next.patch
tpm-fix-pcrread.patch

