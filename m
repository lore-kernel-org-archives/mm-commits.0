From: akpm@linux-foundation.org
Subject: + tpm-fix-suspend-and-resume-failure.patch added to -mm tree
Date: Wed, 09 Jan 2008 21:31:31 -0800
Message-ID: <200801100531.m0A5VBgu006930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53980 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587AbYAJFb5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 00:31:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dds@google.com, pavel@ucw.cz, shpedoikal@gmail.com, tpm@selhorst.net


The patch titled
     TPM: fix suspend and resume failure
has been added to the -mm tree.  Its filename is
     tpm-fix-suspend-and-resume-failure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1041,12 +1041,6 @@ void tpm_remove_hardware(struct device *
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
@@ -1054,6 +1048,12 @@ static u8 savestate[] = {
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

tpm-fix-suspend-and-resume-failure.patch
