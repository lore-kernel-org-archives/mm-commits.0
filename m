From: akpm@linux-foundation.org
Subject: + cciss-add-performant-mode-support-for-stars-sirius-remove-errant-debug-code.patch added to -mm tree
Date: Fri, 04 Jun 2010 16:50:58 -0700
Message-ID: <201006042350.o54NowHr025385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757526Ab0FDXvJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 19:51:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, axboe@kernel.dk, scameron@beardog.cce.hp.com


The patch titled
     cciss: remove errant debug code
has been added to the -mm tree.  Its filename is
     cciss-add-performant-mode-support-for-stars-sirius-remove-errant-debug-code.patch

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
Subject: cciss: remove errant debug code
From: Mike Miller <mike.miller@hp.com>

Remove a debug statement left behind by accident Ths debug statement got
left behind.  It was commented out after use but not deleted.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss_scsi.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/block/cciss_scsi.c~cciss-add-performant-mode-support-for-stars-sirius-remove-errant-debug-code drivers/block/cciss_scsi.c
--- a/drivers/block/cciss_scsi.c~cciss-add-performant-mode-support-for-stars-sirius-remove-errant-debug-code
+++ a/drivers/block/cciss_scsi.c
@@ -213,8 +213,6 @@ scsi_cmd_stack_setup(int ctlr, struct cc
 
 	/* Check alignment, see cciss_cmd.h near CommandList_struct def. */
 	BUILD_BUG_ON((sizeof(*stk->pool) % COMMANDLIST_ALIGNMENT) != 0);
-	/* printk(KERN_WARNING "cciss_scsi.c: 0x%08x 0x%08x 0x%08x\n",
-			0xdeadbeef, sizeof(*stk->pool), 0xbeefdead); */
 	/* pci_alloc_consistent guarantees 32-bit DMA address will be used */
 	stk->pool = (struct cciss_scsi_cmd_stack_elem_t *)
 		pci_alloc_consistent(hba[ctlr]->pdev, size, &stk->cmd_pool_handle);
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

