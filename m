From: akpm@linux-foundation.org
Subject: + cciss-bug-fix-to-prevent-cciss-from-loading-in-kdump-crash-kernel.patch added to -mm tree
Date: Wed, 24 Apr 2013 14:21:16 -0700
Message-ID: <20130424212116.76FDB5A4034@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:61700 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3DXVVR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 17:21:17 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so1935ggc.4
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 14:21:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, axboe@kernel.dk


The patch titled
     Subject: cciss: bug fix to prevent cciss from loading in kdump crash kernel
has been added to the -mm tree.  Its filename is
     cciss-bug-fix-to-prevent-cciss-from-loading-in-kdump-crash-kernel.patch

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

cciss-add-cciss_allow_hpsa-module-parameter.patch
cciss-bug-fix-to-prevent-cciss-from-loading-in-kdump-crash-kernel.patch

