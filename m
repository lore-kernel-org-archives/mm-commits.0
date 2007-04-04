From: akpm@linux-foundation.org
Subject: + cciss-add-init-of-drv-cylinders-back-to-cciss_geometry_inquiry.patch added to -mm tree
Date: Wed, 04 Apr 2007 13:00:37 -0700
Message-ID: <200704042000.l34K0cCk029776@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54896 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766909AbXDDUD4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 16:03:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikem@beardog.cca.cpqcorp.net, mike.miller@hp.com


The patch titled
     cciss: add init of drv->cylinders back to cciss_geometry_inquiry
has been added to the -mm tree.  Its filename is
     cciss-add-init-of-drv-cylinders-back-to-cciss_geometry_inquiry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cciss: add init of drv->cylinders back to cciss_geometry_inquiry
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>

This patch adds initialization of drv->cylinders back into the failing case in
cciss_geometry_inquiry. I inadvertently removed it in one my 2TB updates.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    1 +
 1 files changed, 1 insertion(+)

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

cciss-add-init-of-drv-cylinders-back-to-cciss_geometry_inquiry.patch
