From: akpm@linux-foundation.org
Subject: + scsi-ses-check-name-in-enclosure_component_register-v2.patch added to -mm tree
Date: Mon, 04 May 2009 14:09:09 -0700
Message-ID: <200905042109.n44L99J0024793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866AbZEDVMq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 17:12:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, James.Bottomley@HansenPartnership.com


The patch titled
     scsi: ses check name in enclosure_component_register()
has been added to the -mm tree.  Its filename is
     scsi-ses-check-name-in-enclosure_component_register-v2.patch

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
Subject: scsi: ses check name in enclosure_component_register()
From: Yinghai Lu <yinghai@kernel.org>

dev_set_name will use sprintf to copy the name.  need to check if the name
does valid.

Otherwise the code will error from device_add() later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/enclosure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/misc/enclosure.c~scsi-ses-check-name-in-enclosure_component_register-v2 drivers/misc/enclosure.c
--- a/drivers/misc/enclosure.c~scsi-ses-check-name-in-enclosure_component_register-v2
+++ a/drivers/misc/enclosure.c
@@ -119,7 +119,7 @@ enclosure_register(struct device *dev, c
 	edev->edev.class = &enclosure_class;
 	edev->edev.parent = get_device(dev);
 	edev->cb = cb;
-	dev_set_name(&edev->edev, name);
+	dev_set_name(&edev->edev, "%s", name);
 	err = device_register(&edev->edev);
 	if (err)
 		goto err;
@@ -255,8 +255,8 @@ enclosure_component_register(struct encl
 	ecomp->number = number;
 	cdev = &ecomp->cdev;
 	cdev->parent = get_device(&edev->edev);
-	if (name)
-		dev_set_name(cdev, name);
+	if (name && name[0])
+		dev_set_name(cdev, "%s", name);
 	else
 		dev_set_name(cdev, "%u", number);
 
_

Patches currently in -mm which might be from yinghai@kernel.org are

linux-next.patch
arch-x86-kernel-apic-io_apicc-conditionally-compile-eoi_ioapic_irq.patch
scsi-ses-check-name-in-enclosure_component_register-v2.patch

