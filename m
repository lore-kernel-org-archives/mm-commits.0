From: akpm@linux-foundation.org
Subject: - tpm-work-around-bug-in-broadcom-bcm0102-chipset.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:35 -0700
Message-ID: <200810182319.m9INJZ1Y029516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbYJRXT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:19:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: valdis.kletnieks@vt.edu, kjhall@us.ibm.com, marcin_obara@users.sourceforge.net, tpm@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     tpm: work around bug in Broadcom BCM0102 chipset
has been removed from the -mm tree.  Its filename was
     tpm-work-around-bug-in-broadcom-bcm0102-chipset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: work around bug in Broadcom BCM0102 chipset
From: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Patch tpm-correct-tpm-timeouts-to-jiffies-conversion reveals a bug in the
Broadcom BCM0102 TPM chipset used in the Dell Latitude D820 - although
most of the timeouts are returned in usecs as per the spec, one is
apparently returned in msecs, which results in a too-small value leading
to a timeout when the code treats it as usecs.  To prevent a regression,
we check for the known too-short value and adjust it to a value that makes
things work.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: Marcel Selhorst <tpm@selhorst.net>
Cc: Kylene Jo Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/char/tpm/tpm.c~tpm-work-around-bug-in-broadcom-bcm0102-chipset drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-work-around-bug-in-broadcom-bcm0102-chipset
+++ a/drivers/char/tpm/tpm.c
@@ -557,6 +557,13 @@ duration:
 	    usecs_to_jiffies(be32_to_cpu
 			     (*((__be32 *) (data +
 					    TPM_GET_CAP_RET_UINT32_1_IDX))));
+	/* The Broadcom BCM0102 chipset in a Dell Latitude D820 gets the above
+	 * value wrong and apparently reports msecs rather than usecs. So we
+	 * fix up the resulting too-small TPM_SHORT value to make things work.
+	 */
+	if (chip->vendor.duration[TPM_SHORT] < (HZ/100))
+		chip->vendor.duration[TPM_SHORT] = HZ;
+
 	chip->vendor.duration[TPM_MEDIUM] =
 	    usecs_to_jiffies(be32_to_cpu
 			     (*((__be32 *) (data +
_

Patches currently in -mm which might be from valdis.kletnieks@vt.edu are

origin.patch

