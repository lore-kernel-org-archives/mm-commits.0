From: akpm@linux-foundation.org
Subject: + tpm-change-tpm_suspend_pcr-to-be-module-parameter.patch added to -mm tree
Date: Fri, 17 Sep 2010 14:03:40 -0700
Message-ID: <201009172103.o8HL3emi010020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561Ab0IQVDv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Sep 2010 17:03:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, debora@linux.vnet.ibm.com, dtor@mail.ru, jmorris@namei.org, safford@watson.ibm.com, srajiv@linux.vnet.ibm.com


The patch titled
     tpm: change 'tpm_suspend_pcr' to be module parameter
has been added to the -mm tree.  Its filename is
     tpm-change-tpm_suspend_pcr-to-be-module-parameter.patch

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
Subject: tpm: change 'tpm_suspend_pcr' to be module parameter
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Fix the following warning:

drivers/char/tpm/tpm.c:1085: warning: `tpm_suspend_setup' defined but not used

and make the workaround operable in case when TPM is compiled as a module.
As a side-effect the option will be called tpm.suspend_pcr.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: David Safford <safford@watson.ibm.com>
Cc: James Morris <jmorris@namei.org>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-change-tpm_suspend_pcr-to-be-module-parameter drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-change-tpm_suspend_pcr-to-be-module-parameter
+++ a/drivers/char/tpm/tpm.c
@@ -47,6 +47,16 @@ enum tpm_duration {
 #define TPM_MAX_PROTECTED_ORDINAL 12
 #define TPM_PROTECTED_ORDINAL_MASK 0xFF
 
+/*
+ * Bug workaround - some TPM's don't flush the most
+ * recently changed pcr on suspend, so force the flush
+ * with an extend to the selected _unused_ non-volatile pcr.
+ */
+static int tpm_suspend_pcr;
+module_param_named(suspend_pcr, tpm_suspend_pcr, uint, 0644);
+MODULE_PARM_DESC(suspend_pcr,
+		 "PCR to use for dummy writes to faciltate flush on suspend.");
+
 static LIST_HEAD(tpm_chip_list);
 static DEFINE_SPINLOCK(driver_lock);
 static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
@@ -1077,18 +1087,6 @@ static struct tpm_input_header savestate
 	.ordinal = TPM_ORD_SAVESTATE
 };
 
-/* Bug workaround - some TPM's don't flush the most
- * recently changed pcr on suspend, so force the flush
- * with an extend to the selected _unused_ non-volatile pcr.
- */
-static int tpm_suspend_pcr;
-static int __init tpm_suspend_setup(char *str)
-{
-	get_option(&str, &tpm_suspend_pcr);
-	return 1;
-}
-__setup("tpm_suspend_pcr=", tpm_suspend_setup);
