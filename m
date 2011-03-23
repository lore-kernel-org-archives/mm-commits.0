From: akpm@linux-foundation.org
Subject: [folded] rapidio-add-new-sysfs-attributes-v2.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:22:27 -0700
Message-ID: <201103232322.p2NNMR69004499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933116Ab1CWXX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:23:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com, mm-commits@vger.kernel.org


The patch titled
     rapidio-add-new-sysfs-attributes-v2
has been removed from the -mm tree.  Its filename was
     rapidio-add-new-sysfs-attributes-v2.patch

This patch was dropped because it was folded into rapidio-add-new-sysfs-attributes.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio-add-new-sysfs-attributes-v2
From: Alexandre Bounine <alexandre.bounine@idt.com>

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-sysfs.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/rapidio/rio-sysfs.c~rapidio-add-new-sysfs-attributes-v2 drivers/rapidio/rio-sysfs.c
--- a/drivers/rapidio/rio-sysfs.c~rapidio-add-new-sysfs-attributes-v2
+++ a/drivers/rapidio/rio-sysfs.c
@@ -59,8 +59,8 @@ static ssize_t lprev_show(struct device 
 {
 	struct rio_dev *rdev = to_rio_dev(dev);
 
-	return sprintf(buf, "%02d %s\n", RIO_GET_PORT_NUM(rdev->swpinfo),
-		       (rdev->prev) ? rio_name(rdev->prev) : "host");
+	return sprintf(buf, "%s\n",
+			(rdev->prev) ? rio_name(rdev->prev) : "root");
 }
 
 static ssize_t lnext_show(struct device *dev,
@@ -73,8 +73,10 @@ static ssize_t lnext_show(struct device 
 	if (rdev->pef & RIO_PEF_SWITCH) {
 		for (i = 0; i < RIO_GET_TOTAL_PORTS(rdev->swpinfo); i++) {
 			if (rdev->rswitch->nextdev[i])
-				str += sprintf(str, "%02d %s\n", i,
+				str += sprintf(str, "%s\n",
 					rio_name(rdev->rswitch->nextdev[i]));
+			else
+				str += sprintf(str, "null\n");
 		}
 	}
 
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-new-sysfs-attributes.patch
rapidio-add-rapidio-documentation.patch
rapidio-add-rapidio-documentation-v2.patch
rapidio-add-architecture-specific-callbacks.patch
rapidio-modify-configuration-to-support-pci-srio-controller.patch
rapidio-modify-configuration-to-support-pci-srio-controller-fix-configuration-option.patch
rapidio-modify-subsystem-and-driver-initialization-sequence.patch
rapidio-modify-mport-id-assignment.patch
rapidio-remove-mport-resource-reservation-from-common-rio-code.patch
rapidio-fix-potential-null-deref-on-failure-path.patch

