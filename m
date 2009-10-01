From: akpm@linux-foundation.org
Subject: [merged] tpm-fix-pcrread.patch removed from -mm tree
Date: Thu, 01 Oct 2009 11:44:49 -0700
Message-ID: <200910011844.n91IinhQ013741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932090AbZJASpP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2009 14:45:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srajiv@linux.vnet.ibm.com, debora@linux.vnet.ibm.com, jgunthorpe@obsidianresearch.com, jmorris@namei.org, m.selhorst@sirrix.com, mm-commits@vger.kernel.org


The patch titled
     tpm: fix pcrread
has been removed from the -mm tree.  Its filename was
     tpm-fix-pcrread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

