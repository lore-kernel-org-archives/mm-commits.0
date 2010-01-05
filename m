From: akpm@linux-foundation.org
Subject: + tpm_infineon-fix-suspend-resume-handler-for-pnp_driver.patch added to -mm tree
Date: Tue, 05 Jan 2010 15:59:08 -0800
Message-ID: <201001052359.o05Nx8xg028329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755319Ab0AEX70 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jan 2010 18:59:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp, debora@linux.vnet.ibm.com, m.selhorst@sirrix.com, srajiv@linux.vnet.ibm.com


The patch titled
     tpm_infineon: fix suspend/resume handler for pnp_driver
has been added to the -mm tree.  Its filename is
     tpm_infineon-fix-suspend-resume-handler-for-pnp_driver.patch

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
Subject: tpm_infineon: fix suspend/resume handler for pnp_driver
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

With recent quick review, I found the bug in tpm_infineon. (I don't have
this device, and compile test only)

PNP driver must use pnp_driver->suspend/resume.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Marcel Selhorst <m.selhorst@sirrix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm_infineon.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN drivers/char/tpm/tpm_infineon.c~tpm_infineon-fix-suspend-resume-handler-for-pnp_driver drivers/char/tpm/tpm_infineon.c
--- a/drivers/char/tpm/tpm_infineon.c~tpm_infineon-fix-suspend-resume-handler-for-pnp_driver
+++ a/drivers/char/tpm/tpm_infineon.c
@@ -611,16 +611,26 @@ static __devexit void tpm_inf_pnp_remove
 	}
 }
 
+static int tpm_pnp_suspend(struct pnp_dev *dev, pm_message_t pm_state)
+{
+	return tpm_pm_suspend(&dev->dev, pm_state);
+}
+
+static int tpm_pnp_resume(struct pnp_dev *dev)
+{
+	return tpm_pm_resume(&dev->dev);
+}
+
 static struct pnp_driver tpm_inf_pnp_driver = {
 	.name = "tpm_inf_pnp",
-	.driver = {
-		.owner = THIS_MODULE,
-		.suspend = tpm_pm_suspend,
-		.resume = tpm_pm_resume,
-	},
 	.id_table = tpm_pnp_tbl,
 	.probe = tpm_inf_pnp_probe,
 	.remove = __devexit_p(tpm_inf_pnp_remove),
+	.suspend = tpm_pnp_suspend,
+	.resume = tpm_pnp_resume,
+	.driver = {
+		.owner = THIS_MODULE,
+	},
 };
 
 static int __init init_inf(void)
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
tpm_infineon-fix-suspend-resume-handler-for-pnp_driver.patch

