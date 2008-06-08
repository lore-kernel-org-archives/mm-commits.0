From: akpm@linux-foundation.org
Subject: + tpm-correct-tpm-timeouts-to-jiffies-conversion.patch added to -mm tree
Date: Sun, 08 Jun 2008 13:24:24 -0700
Message-ID: <200806082024.m58KOObW018993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753781AbYFHU0C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 16:26:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin_obara@users.sourceforge.net, kjhall@us.ibm.com, tpm@selhorst.net


The patch titled
     tpm: correct tpm timeouts to jiffies conversion
has been added to the -mm tree.  Its filename is
     tpm-correct-tpm-timeouts-to-jiffies-conversion.patch

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
Subject: tpm: correct tpm timeouts to jiffies conversion
From: Marcin Obara <marcin_obara@users.sourceforge.net>

This patch fixes timeouts conversion to jiffies, by replacing
msecs_to_jiffies() calls with usecs_to_jiffies().  According to TCG TPM
Specification Version 1.2 Revision 103 (pages 166, 167) TPM timeouts and
durations are returned in microseconds (usec) not in miliseconds (msec).

Signed-off-by: Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: Marcel Selhorst <tpm@selhorst.net>
Cc: Kylene Jo Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-correct-tpm-timeouts-to-jiffies-conversion drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-correct-tpm-timeouts-to-jiffies-conversion
+++ a/drivers/char/tpm/tpm.c
@@ -525,19 +525,19 @@ void tpm_get_timeouts(struct tpm_chip *c
 	timeout =
 	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_1_IDX)));
 	if (timeout)
-		chip->vendor.timeout_a = msecs_to_jiffies(timeout);
+		chip->vendor.timeout_a = usecs_to_jiffies(timeout);
 	timeout =
 	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_2_IDX)));
 	if (timeout)
-		chip->vendor.timeout_b = msecs_to_jiffies(timeout);
+		chip->vendor.timeout_b = usecs_to_jiffies(timeout);
 	timeout =
 	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_3_IDX)));
 	if (timeout)
-		chip->vendor.timeout_c = msecs_to_jiffies(timeout);
+		chip->vendor.timeout_c = usecs_to_jiffies(timeout);
 	timeout =
 	    be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_4_IDX)));
 	if (timeout)
-		chip->vendor.timeout_d = msecs_to_jiffies(timeout);
+		chip->vendor.timeout_d = usecs_to_jiffies(timeout);
 
 duration:
 	memcpy(data, tpm_cap, sizeof(tpm_cap));
@@ -554,15 +554,15 @@ duration:
 		return;
 
 	chip->vendor.duration[TPM_SHORT] =
-	    msecs_to_jiffies(be32_to_cpu
+	    usecs_to_jiffies(be32_to_cpu
 			     (*((__be32 *) (data +
 					    TPM_GET_CAP_RET_UINT32_1_IDX))));
 	chip->vendor.duration[TPM_MEDIUM] =
-	    msecs_to_jiffies(be32_to_cpu
+	    usecs_to_jiffies(be32_to_cpu
 			     (*((__be32 *) (data +
 					    TPM_GET_CAP_RET_UINT32_2_IDX))));
 	chip->vendor.duration[TPM_LONG] =
-	    msecs_to_jiffies(be32_to_cpu
+	    usecs_to_jiffies(be32_to_cpu
 			     (*((__be32 *) (data +
 					    TPM_GET_CAP_RET_UINT32_3_IDX))));
 }
_

Patches currently in -mm which might be from marcin_obara@users.sourceforge.net are

tpm-correct-tpm-timeouts-to-jiffies-conversion.patch
tpm-increase-size-of-internal-tpm-response-buffers.patch

