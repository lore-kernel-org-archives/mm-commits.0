From: akpm@linux-foundation.org
Subject: + cciss-bug-fix-prevent-cciss-from-loading-in-kdump-kernel.patch added to -mm tree
Date: Tue, 16 Apr 2013 15:01:37 -0700
Message-ID: <20130416220137.7B60331C034@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:52554 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965344Ab3DPWBi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Apr 2013 18:01:38 -0400
Received: by mail-gh0-f201.google.com with SMTP id r13so17775ghr.4
        for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2013 15:01:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, axboe@kernel.dk


The patch titled
     Subject: cciss: bug fix, prevent cciss from loading in kdump kernel
has been added to the -mm tree.  Its filename is
     cciss-bug-fix-prevent-cciss-from-loading-in-kdump-kernel.patch

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

cciss-bug-fix-prevent-cciss-from-loading-in-kdump-kernel.patch

