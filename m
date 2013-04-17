From: akpm@linux-foundation.org
Subject: [failures] cciss-bug-fix-prevent-cciss-from-loading-in-kdump-kernel.patch removed from -mm tree
Date: Wed, 17 Apr 2013 15:03:11 -0700
Message-ID: <20130417220312.5302831C03C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:35630 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965558Ab3DQWDN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Apr 2013 18:03:13 -0400
Received: by mail-qe0-f74.google.com with SMTP id b10so216054qen.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2013 15:03:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: cciss: bug fix, prevent cciss from loading in kdump kernel
has been removed from the -mm tree.  Its filename was
     cciss-bug-fix-prevent-cciss-from-loading-in-kdump-kernel.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Mike Miller <mike.miller@hp.com>
Subject: cciss: bug fix, prevent cciss from loading in kdump kernel

If hpsa is selected as the Smart Array driver cciss may try to load in the
kdump kernel.  When this happens kdump fails and a core file cannot be
created.  This patch prevents cciss from trying to load in this scenario. 
This effects primarily older Smart Array controllers.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/block/cciss.c~cciss-bug-fix-prevent-cciss-from-loading-in-kdump-kernel drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-bug-fix-prevent-cciss-from-loading-in-kdump-kernel
+++ a/drivers/block/cciss.c
@@ -4960,6 +4960,12 @@ static int cciss_init_one(struct pci_dev
 	ctlr_info_t *h;
 	unsigned long flags;
 
+	/*
+	 * if this is the kdump kernel and the user has set the flags to
+	 * use hpsa rather than cciss just bail
+	 */
+	if ((reset_devices) && (cciss_allow_hpsa == 1))
+		return -ENODEV;
 	rc = cciss_init_reset_devices(pdev);
 	if (rc) {
 		if (rc != -ENOTSUPP)
_

Patches currently in -mm which might be from mike.miller@hp.com are


