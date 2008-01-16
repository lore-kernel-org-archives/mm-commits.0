From: akpm@linux-foundation.org
Subject: - tpm-fix-suspend-and-resume-failure.patch removed from -mm tree
Date: Tue, 15 Jan 2008 17:38:11 -0800
Message-ID: <200801160138.m0G1cBCR013886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42135 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755635AbYAPBiw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:38:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dds@google.com, pavel@ucw.cz, shpedoikal@gmail.com, tpm@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     TPM: fix suspend and resume failure
has been removed from the -mm tree.  Its filename was
     tpm-fix-suspend-and-resume-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: TPM: fix suspend and resume failure
From: David Smith <dds@google.com>

The savestate command structure was being overwritten by the result of running
the TPM_SaveState command after one run, so make it a local variable to the
function instead of a global variable that gets overwritten.

Cc: Pavel Machek <pavel@ucw.cz>
Cc: Kent Yoder <shpedoikal@gmail.com>
Cc: Marcel Selhorst <tpm@selhorst.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-fix-suspend-and-resume-failure drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-fix-suspend-and-resume-failure
+++ a/drivers/char/tpm/tpm.c
@@ -1046,12 +1046,6 @@ void tpm_remove_hardware(struct device *
 }
 EXPORT_SYMBOL_GPL(tpm_remove_hardware);
 
-static u8 savestate[] = {
-	0, 193,			/* TPM_TAG_RQU_COMMAND */
-	0, 0, 0, 10,		/* blob length (in bytes) */
-	0, 0, 0, 152		/* TPM_ORD_SaveState */
-};
-
 /*
  * We are about to suspend. Save the TPM state
  * so that it can be restored.
@@ -1059,6 +1053,12 @@ static u8 savestate[] = {
 int tpm_pm_suspend(struct device *dev, pm_message_t pm_state)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
+	u8 savestate[] = {
+		0, 193,		/* TPM_TAG_RQU_COMMAND */
+		0, 0, 0, 10,	/* blob length (in bytes) */
+		0, 0, 0, 152	/* TPM_ORD_SaveState */
+	};
+
 	if (chip == NULL)
 		return -ENODEV;
 
_

Patches currently in -mm which might be from dds@google.com are

origin.patch
