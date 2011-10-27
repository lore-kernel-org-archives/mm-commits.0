From: akpm@linux-foundation.org
Subject: [merged] cciss-add-half-second-delay-to-pci-pm-reset-code.patch removed from -mm tree
Date: Thu, 27 Oct 2011 16:08:29 -0700
Message-ID: <201110272308.p9RN8TvW000447@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:22355 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab1J0XIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2011 19:08:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: cciss: add half second delay to PCI PM reset code
has been removed from the -mm tree.  Its filename was
     cciss-add-half-second-delay-to-pci-pm-reset-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mike Miller <mike.miller@hp.com>
Subject: cciss: add half second delay to PCI PM reset code

After using PCI Power Management to reset the Smart Array in kdump kernels
we need some delay.  Otherwise we may think the board failed to reset and
bail out.  This affects all users with a Smart Array P600.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
