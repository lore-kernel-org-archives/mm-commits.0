From: akpm@linux-foundation.org
Subject: + tpm_tis-fix-subsequent-suspend-failures.patch added to -mm tree
Date: Wed, 23 Jun 2010 12:18:56 -0700
Message-ID: <201006231918.o5NJIutP026547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751940Ab0FWTTa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jun 2010 15:19:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srajiv@linux.vnet.ibm.com, debora@linux.vnet.ibm.com, helmut.schaa@googlemail.com, jmorris@namei.org, safford@watson.ibm.com


The patch titled
     tpm_tis: fix subsequent suspend failures
has been added to the -mm tree.  Its filename is
     tpm_tis-fix-subsequent-suspend-failures.patch

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
Subject: tpm_tis: fix subsequent suspend failures
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Fix subsequent suspends by issuing tpm_continue_selftest during resume.
Otherwise, the tpm chip seems to be not fully initialized and will reject
the save state command during suspend, thus preventing the whole system
to suspend.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16256

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: David Safford <safford@watson.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_tis.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/char/tpm/tpm_tis.c~tpm_tis-fix-subsequent-suspend-failures drivers/char/tpm/tpm_tis.c
--- a/drivers/char/tpm/tpm_tis.c~tpm_tis-fix-subsequent-suspend-failures
+++ a/drivers/char/tpm/tpm_tis.c
@@ -623,7 +623,14 @@ static int tpm_tis_pnp_suspend(struct pn
 
 static int tpm_tis_pnp_resume(struct pnp_dev *dev)
 {
-	return tpm_pm_resume(&dev->dev);
+	struct tpm_chip *chip = pnp_get_drvdata(dev);
+	int ret;
+
+	ret = tpm_pm_resume(&dev->dev);
+	if (!ret)
+		tpm_continue_selftest(chip);
+
+	return ret;
 }
 
 static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
_

Patches currently in -mm which might be from srajiv@linux.vnet.ibm.com are

tpm_tis-fix-subsequent-suspend-failures.patch

