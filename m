From: akpm@linux-foundation.org
Subject: [obsolete] tpm-integrity-fix.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:36:05 -0800
Message-ID: <200902061936.n16Ja5e4008937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380AbZBFThJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:37:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srajiv@linux.vnet.ibm.com, jmorris@namei.org, safford@watson.ibm.com, serue@us.ibm.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     tpm: integrity fix
has been removed from the -mm tree.  Its filename was
     tpm-integrity-fix.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: integrity fix
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Fix to a function which is called by IMA, now tpm_chip_find_get()
considers the case in which the machine doesn't have a TPM or, if it has,
its TPM isn't enabled.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: <safford@watson.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-integrity-fix drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-integrity-fix
+++ a/drivers/char/tpm/tpm.c
@@ -666,18 +666,20 @@ EXPORT_SYMBOL_GPL(tpm_show_temp_deactiva
  */
 static struct tpm_chip *tpm_chip_find_get(int chip_num)
 {
-	struct tpm_chip *pos;
+	struct tpm_chip *pos, *chip = NULL;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
 		if (chip_num != TPM_ANY_NUM && chip_num != pos->dev_num)
 			continue;
 
-		if (try_module_get(pos->dev->driver->owner))
+		if (try_module_get(pos->dev->driver->owner)) {
+			chip = pos;
 			break;
+		}
 	}
 	rcu_read_unlock();
-	return pos;
+	return chip;
 }
 
 #define TPM_ORDINAL_PCRREAD cpu_to_be32(21)
_

Patches currently in -mm which might be from srajiv@linux.vnet.ibm.com are

tpm-integrity-fix.patch

