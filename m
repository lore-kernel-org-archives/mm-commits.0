From: akpm@linux-foundation.org
Subject: + scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id.patch added to -mm tree
Date: Fri, 09 Oct 2009 16:09:47 -0700
Message-ID: <200910092309.n99N9lWI024728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755525AbZJIXKi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 19:10:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com


The patch titled
     hpsa: fix hpsa_allow_any test for vendor ID
has been added to the -mm tree.  Its filename is
     scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id.patch

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
Subject: hpsa: fix hpsa_allow_any test for vendor ID
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

Fix hpsa_allow_any test for vendor ID.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/scsi/hpsa.c~scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id
+++ a/drivers/scsi/hpsa.c
@@ -3080,7 +3080,7 @@ static int hpsa_pci_init(struct ctlr_inf
 
 	if (prod_index == ARRAY_SIZE(products)) {
 		prod_index--;
-		if (subsystem_vendor_id == !PCI_VENDOR_ID_HP ||
+		if (subsystem_vendor_id != PCI_VENDOR_ID_HP ||
 				!hpsa_allow_any) {
 			dev_warn(&pdev->dev, "unrecognized board ID:"
 				" 0x%08lx, ignoring.\n",
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch

