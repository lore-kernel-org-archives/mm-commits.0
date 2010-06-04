From: akpm@linux-foundation.org
Subject: + cciss-add-performant-mode-support-for-stars-sirius-fix-call-to-put_controller_in_performant_mode.patch added to -mm tree
Date: Fri, 04 Jun 2010 16:50:54 -0700
Message-ID: <201006042350.o54Nosca025379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49883 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757454Ab0FDXvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 19:51:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, axboe@kernel.dk, scameron@beardog.cce.hp.com


The patch titled
     cciss: fix call to put_controller_in_performant_mode
has been added to the -mm tree.  Its filename is
     cciss-add-performant-mode-support-for-stars-sirius-fix-call-to-put_controller_in_performant_mode.patch

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
Subject: cciss: fix call to put_controller_in_performant_mode
From: Mike Miller <mike.miller@hp.com>

call to put_controller_in_performant_mode was in the wrong place
The call inadvertently ended up in an error path.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-add-performant-mode-support-for-stars-sirius-fix-call-to-put_controller_in_performant_mode drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-add-performant-mode-support-for-stars-sirius-fix-call-to-put_controller_in_performant_mode
+++ a/drivers/block/cciss.c
@@ -4142,6 +4142,7 @@ static int __devinit cciss_pci_init(ctlr
 #ifdef CCISS_DEBUG
 	printk(KERN_WARNING "Trying to put board into Performant mode\n");
 #endif				/* CCISS_DEBUG */
+	cciss_put_controller_into_performant_mode(c);
 	return 0;
 
 err_out_free_res:
@@ -4150,7 +4151,6 @@ err_out_free_res:
 	 * Smart Array controllers that pci_enable_device does not undo
 	 */
 	pci_release_regions(pdev);
-	cciss_put_controller_into_performant_mode(c);
 	return err;
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

