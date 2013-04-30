From: akpm@linux-foundation.org
Subject: [merged] cciss-bug-fix-to-prevent-cciss-from-loading-in-kdump-crash-kernel.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:03:20 -0700
Message-ID: <20130430190320.7FCDF31C07C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:53878 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab3D3TDV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:03:21 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so87650yen.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:03:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: cciss: bug fix to prevent cciss from loading in kdump crash kernel
has been removed from the -mm tree.  Its filename was
     cciss-bug-fix-to-prevent-cciss-from-loading-in-kdump-crash-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Miller <mike.miller@hp.com>
Subject: cciss: bug fix to prevent cciss from loading in kdump crash kernel

By default the cciss driver supports all "older" HP Smart Array
controllers and hpsa supports all controllers starting with the G6 family.
 There are module parameters that allow a user to override those defaults
and use hpsa for any HP Smart Array controller.

If the user does override the default behavior and uses hpsa for older
controllers it is possible that cciss may try to load in a kdump crash
kernel.  This may happen if cciss is loaded first from the kdump initrd
image.  If cciss does load rather than hpsa and reset_devices is true we
immediately call cciss_hard_reset_controller.  This will result in a
kernel panic and the core file cannot be created.  This patch prevents
cciss from trying to load in this scenario.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/block/cciss.c~cciss-bug-fix-to-prevent-cciss-from-loading-in-kdump-crash-kernel drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-bug-fix-to-prevent-cciss-from-loading-in-kdump-crash-kernel
+++ a/drivers/block/cciss.c
@@ -4970,6 +4970,16 @@ static int cciss_init_one(struct pci_dev
 	ctlr_info_t *h;
 	unsigned long flags;
 
+	/*
+	 * By default the cciss driver is used for all older HP Smart Array
+	 * controllers. There are module paramaters that allow a user to
+	 * override this behavior and instead use the hpsa SCSI driver. If
+	 * this is the case cciss may be loaded first from the kdump initrd
+	 * image and cause a kernel panic. So if reset_devices is true and
+	 * cciss_allow_hpsa is set just bail.
+	 */
+	if ((reset_devices) && (cciss_allow_hpsa == 1))
+		return -ENODEV;
 	rc = cciss_init_reset_devices(pdev);
 	if (rc) {
 		if (rc != -ENOTSUPP)
_

Patches currently in -mm which might be from mike.miller@hp.com are

linux-next.patch

