From: akpm@google.com
Subject: + cciss-add-half-second-delay-to-pci-pm-reset-code.patch added to -mm tree
Date: Fri, 30 Sep 2011 13:52:17 -0700
Message-ID: <201109302052.p8UKqIXg017145@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:18709 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1I3Uwa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Sep 2011 16:52:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, axboe@kernel.dk


The patch titled
     Subject: cciss: add half second delay to PCI PM reset code
has been added to the -mm tree.  Its filename is
     cciss-add-half-second-delay-to-pci-pm-reset-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mike Miller <mike.miller@hp.com>
Subject: cciss: add half second delay to PCI PM reset code

After using PCI Power Management to reset the Smart Array in kdump kernels
we need some delay.  Otherwise we may think the board failed to reset and
bail out.  This affects all users with a Smart Array P600.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/block/cciss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-add-half-second-delay-to-pci-pm-reset-code drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-add-half-second-delay-to-pci-pm-reset-code
+++ a/drivers/block/cciss.c
@@ -4550,13 +4550,13 @@ static int cciss_controller_hard_reset(s
 		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
 		pmcsr |= PCI_D3hot;
 		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
