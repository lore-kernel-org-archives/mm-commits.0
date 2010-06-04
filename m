From: akpm@linux-foundation.org
Subject: + cciss-clean-up-interrupt-handler-make-sure-we-request-the-performant-mode-irq.patch added to -mm tree
Date: Fri, 04 Jun 2010 16:50:50 -0700
Message-ID: <201006042350.o54NooxG025376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757454Ab0FDXvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 19:51:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, axboe@kernel.dk, scameron@beardog.cce.hp.com


The patch titled
     cciss: make sure we request the performant mode irq
has been added to the -mm tree.  Its filename is
     cciss-clean-up-interrupt-handler-make-sure-we-request-the-performant-mode-irq.patch

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
Subject: cciss: make sure we request the performant mode irq
From: Mike Miller <mike.miller@hp.com>

Make sure we register the performant mode interrupt Another blunder. 
Seemed to work because the call to put_controller_into_performant_mode was
never called.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/block/cciss.c~cciss-clean-up-interrupt-handler-make-sure-we-request-the-performant-mode-irq drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-clean-up-interrupt-handler-make-sure-we-request-the-performant-mode-irq
+++ a/drivers/block/cciss.c
@@ -4308,18 +4308,18 @@ static int __devinit cciss_init_one(stru
 	/* make sure the board interrupts are off */
 	hba[i]->access.set_intr_mask(hba[i], CCISS_INTR_OFF);
 	if (hba[i]->msi_vector || hba[i]->msix_vector) {
-		if (request_irq(hba[i]->intr[SIMPLE_MODE_INT],
+		if (request_irq(hba[i]->intr[PERF_MODE_INT],
 				do_cciss_msix_intr,
 				IRQF_DISABLED, hba[i]->devname, hba[i])) {
 			printk(KERN_ERR "cciss: Unable to get irq %d for %s\n",
-			       hba[i]->intr[SIMPLE_MODE_INT], hba[i]->devname);
+			       hba[i]->intr[PERF_MODE_INT], hba[i]->devname);
 			goto clean2;
 		}
 	} else {
-		if (request_irq(hba[i]->intr[SIMPLE_MODE_INT], do_cciss_intx,
+		if (request_irq(hba[i]->intr[PERF_MODE_INT], do_cciss_intx,
 				IRQF_DISABLED, hba[i]->devname, hba[i])) {
 			printk(KERN_ERR "cciss: Unable to get irq %d for %s\n",
-			       hba[i]->intr[SIMPLE_MODE_INT], hba[i]->devname);
+			       hba[i]->intr[PERF_MODE_INT], hba[i]->devname);
 			goto clean2;
 		}
 	}
_

Patches currently in -mm which might be from mike.miller@hp.com are

cciss-enqueue-and-submit-io.patch
cciss-clean-up-interrupt-handler.patch
cciss-clean-up-interrupt-handler-make-sure-we-request-the-performant-mode-irq.patch
cciss-check-for-msi-in-interrupt_not_for_us.patch
cciss-make-interrupt-access-methods-return-type-bool.patch
cciss-add-performant-mode-support-for-stars-sirius.patch
cciss-add-performant-mode-support-for-stars-sirius-fix-call-to-put_controller_in_performant_mode.patch
cciss-add-performant-mode-support-for-stars-sirius-move-next_command-function-from-ifdef.patch
cciss-add-performant-mode-support-for-stars-sirius-remove-errant-debug-code.patch
cciss-add-performant-mode-support-for-stars-sirius-change-pad-value-from-32-to-0.patch
cciss-new-controller-support-and-bump-driver-version.patch

