From: akpm@linux-foundation.org
Subject: + cciss-add-cciss_allow_hpsa-module-parameter.patch added to -mm tree
Date: Mon, 22 Apr 2013 15:10:51 -0700
Message-ID: <20130422221051.6D49731C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:35729 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3DVWKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 18:10:52 -0400
Received: by mail-ye0-f201.google.com with SMTP id m2so749807yen.2
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 15:10:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, axboe@kernel.dk


The patch titled
     Subject: cciss: add cciss_allow_hpsa module parameter
has been added to the -mm tree.  Its filename is
     cciss-add-cciss_allow_hpsa-module-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

cciss-add-cciss_allow_hpsa-module-parameter.patch

