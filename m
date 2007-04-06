From: akpm@linux-foundation.org
Subject: - cciss-add-init-of-drv-cylinders-back-to-cciss_geometry_inquiry.patch removed from -mm tree
Date: Fri, 06 Apr 2007 13:08:38 -0700
Message-ID: <200704062008.l36K8c9X017864@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32921 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819AbXDFULz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 16:11:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikem@beardog.cca.cpqcorp.net, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: add init of drv->cylinders back to cciss_geometry_inquiry
has been removed from the -mm tree.  Its filename was
     cciss-add-init-of-drv-cylinders-back-to-cciss_geometry_inquiry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: add init of drv->cylinders back to cciss_geometry_inquiry
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>

This patch adds initialization of drv->cylinders back into the failing case in
cciss_geometry_inquiry. I inadvertently removed it in one my 2TB updates.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/cciss.c~cciss-add-init-of-drv-cylinders-back-to-cciss_geometry_inquiry drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-add-init-of-drv-cylinders-back-to-cciss_geometry_inquiry
+++ a/drivers/block/cciss.c
@@ -1915,6 +1915,7 @@ static void cciss_geometry_inquiry(int c
 			       "does not support reading geometry\n");
 			drv->heads = 255;
 			drv->sectors = 32;	// Sectors per track
+			drv->cylinders = total_size + 1;
 			drv->raid_level = RAID_UNKNOWN;
 		} else {
 			drv->heads = inq_buff->data_byte[6];
_

Patches currently in -mm which might be from mikem@beardog.cca.cpqcorp.net are
