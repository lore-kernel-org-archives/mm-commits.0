From: akpm@linux-foundation.org
Subject: + tpm-autoload-tpm_tis-based-on-system-pnp-ids.patch added to -mm tree
Date: Mon, 02 Nov 2009 15:10:15 -0800
Message-ID: <200911022310.nA2NAFCe017478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756815AbZKBXKZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2009 18:10:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Matt_Domsch@dell.com, jmorris@namei.org, srajiv@linux.vnet.ibm.com


The patch titled
     tpm: autoload tpm_tis based on system PnP IDs
has been added to the -mm tree.  Its filename is
     tpm-autoload-tpm_tis-based-on-system-pnp-ids.patch

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
Subject: tpm: autoload tpm_tis based on system PnP IDs
From: Matt Domsch <Matt_Domsch@dell.com>

The tpm_tis driver already has a list of supported pnp_device_ids.
This patch simply exports that list as a MODULE_DEVICE_TABLE() so that
the module autoloader will discover and load the module at boottime.

Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>
Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/char/tpm/tpm_tis.c~tpm-autoload-tpm_tis-based-on-system-pnp-ids drivers/char/tpm/tpm_tis.c
--- a/drivers/char/tpm/tpm_tis.c~tpm-autoload-tpm_tis-based-on-system-pnp-ids
+++ a/drivers/char/tpm/tpm_tis.c
@@ -637,6 +637,7 @@ static struct pnp_device_id tpm_pnp_tbl[
 	{"", 0},		/* User Specified */
 	{"", 0}			/* Terminator */
 };
+MODULE_DEVICE_TABLE(pnp, tpm_pnp_tbl);
 
 static __devexit void tpm_tis_pnp_remove(struct pnp_dev *dev)
 {
_

Patches currently in -mm which might be from Matt_Domsch@dell.com are

tpm-autoload-tpm_tis-based-on-system-pnp-ids.patch
firmware-only-allow-edd-on-x86.patch

