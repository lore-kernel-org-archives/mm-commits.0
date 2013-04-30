From: akpm@linux-foundation.org
Subject: [merged] cciss-add-cciss_allow_hpsa-module-parameter.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:03:17 -0700
Message-ID: <20130430190317.770C45A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:61029 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933600Ab3D3TDS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:03:18 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so87619qcs.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:03:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: cciss: add cciss_allow_hpsa module parameter
has been removed from the -mm tree.  Its filename was
     cciss-add-cciss_allow_hpsa-module-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Miller <mike.miller@hp.com>
Subject: cciss: add cciss_allow_hpsa module parameter

Add the cciss_allow_hpsa modules parameter.  This allows users to use the
hpsa driver instead of cciss for older controllers.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-add-cciss_allow_hpsa-module-parameter drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-add-cciss_allow_hpsa-module-parameter
+++ a/drivers/block/cciss.c
@@ -75,6 +75,12 @@ module_param(cciss_simple_mode, int, S_I
 MODULE_PARM_DESC(cciss_simple_mode,
 	"Use 'simple mode' rather than 'performant mode'");
 
+static int cciss_allow_hpsa;
+module_param(cciss_allow_hpsa, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(cciss_allow_hpsa,
+	"Prevent cciss driver from accessing hardware known to be "
+	" supported by the hpsa driver");
+
 static DEFINE_MUTEX(cciss_mutex);
 static struct proc_dir_entry *proc_cciss;
 
@@ -4116,9 +4122,13 @@ static int cciss_lookup_board_id(struct
 	*board_id = ((subsystem_device_id << 16) & 0xffff0000) |
 			subsystem_vendor_id;
 
-	for (i = 0; i < ARRAY_SIZE(products); i++)
+	for (i = 0; i < ARRAY_SIZE(products); i++) {
+		/* Stand aside for hpsa driver on request */
+		if (cciss_allow_hpsa)
+			return -ENODEV;
 		if (*board_id == products[i].board_id)
 			return i;
+	}
 	dev_warn(&pdev->dev, "unrecognized board ID: 0x%08x, ignoring.\n",
 		*board_id);
 	return -ENODEV;
_

Patches currently in -mm which might be from mike.miller@hp.com are

linux-next.patch

