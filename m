From: akpm@linux-foundation.org
Subject: - tpm-correct-tpm-timeouts-to-jiffies-conversion.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:32 -0700
Message-ID: <200810182319.m9INJWnN029501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855AbYJRXTt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:19:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin_obara@users.sourceforge.net, jirislaby@gmail.com, kjhall@us.ibm.com, tpm@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     tpm: correct tpm timeouts to jiffies conversion
has been removed from the -mm tree.  Its filename was
     tpm-correct-tpm-timeouts-to-jiffies-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: correct tpm timeouts to jiffies conversion
From: Marcin Obara <marcin_obara@users.sourceforge.net>

This patch fixes timeouts conversion to jiffies, by replacing
msecs_to_jiffies() calls with usecs_to_jiffies().  According to TCG TPM
Specification Version 1.2 Revision 103 (pages 166, 167) TPM timeouts and
durations are returned in microseconds (usec) not in miliseconds (msec).

This fixes a long hang while loading TPM driver, if TPM chip starts in
"Idle" state instead of "Ready" state.  Without this patch - 'modprobe'
may hang for 30 seconds or more.

Signed-off-by: Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: Marcel Selhorst <tpm@selhorst.net>
Cc: Kylene Jo Hall <kjhall@us.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
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

origin.patch

