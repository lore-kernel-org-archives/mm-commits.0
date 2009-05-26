From: akpm@linux-foundation.org
Subject: [merged] scsi-ses-check-name-in-enclosure_component_register-v2.patch removed from -mm tree
Date: Tue, 26 May 2009 12:35:39 -0700
Message-ID: <200905261935.n4QJZddN006477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757429AbZEZThI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     scsi: ses check name in enclosure_component_register()
has been removed from the -mm tree.  Its filename was
     scsi-ses-check-name-in-enclosure_component_register-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

