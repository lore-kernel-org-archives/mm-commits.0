From: akpm@linux-foundation.org
Subject: - drivers-edac-device-output-clenaup.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:37 -0700
Message-ID: <200707192006.l6JK6bfq020161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39459 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756391AbXGSUPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: device output clenaup
has been removed from the -mm tree.  Its filename was
     drivers-edac-device-output-clenaup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: device output clenaup
From: Douglas Thompson <dougthompson@xmission.com>

The error handling output strings needed to be refactored for better
displaying of the error informaton.

Also needed to added offset_value for output as well

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_device.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/edac/edac_device.c~drivers-edac-device-output-clenaup drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~drivers-edac-device-output-clenaup
+++ a/drivers/edac/edac_device.c
@@ -158,7 +158,7 @@ struct edac_device_ctl_info *edac_device
 			attrib_p = &dev_attrib[block * nr_attribs];
 			blk->attribs = attrib_p;
 			snprintf(blk->name, sizeof(blk->name),
-				 "%s%d", edac_block_name, block + 1);
+				 "%s%d", edac_block_name, block+offset_value);
 			blk->name[sizeof(blk->name) - 1] = '\0';
 
 			debugf1("%s() instance=%d block=%d name=%s\n",
@@ -580,7 +580,7 @@ void edac_device_handle_ce(struct edac_d
 
 	if (edac_device_get_log_ce(edac_dev))
 		edac_device_printk(edac_dev, KERN_WARNING,
-				   "CE ctl: %s, instance: %s, block: %s: %s\n",
+				   "CE: %s instance: %s block: %s '%s'\n",
 				   edac_dev->ctl_name, instance->name,
 				   block ? block->name : "N/A", msg);
 }
@@ -626,12 +626,12 @@ void edac_device_handle_ue(struct edac_d
 
 	if (edac_device_get_log_ue(edac_dev))
 		edac_device_printk(edac_dev, KERN_EMERG,
-				   "UE ctl: %s, instance: %s, block: %s: %s\n",
+				   "UE: %s instance: %s block: %s '%s'\n",
 				   edac_dev->ctl_name, instance->name,
 				   block ? block->name : "N/A", msg);
 
 	if (edac_device_get_panic_on_ue(edac_dev))
-		panic("EDAC %s: UE instance: %s, block %s: %s\n",
+		panic("EDAC %s: UE instance: %s block %s '%s'\n",
 		      edac_dev->ctl_name, instance->name,
 		      block ? block->name : "N/A", msg);
 }
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
