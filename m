From: akpm@linux-foundation.org
Subject: + cciss-make-interrupt-access-methods-return-type-bool.patch added to -mm tree
Date: Wed, 02 Jun 2010 12:58:04 -0700
Message-ID: <201006021958.o52Jw4du013715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933039Ab0FBT6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 15:58:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, jens.axboe@oracle.com, scameron@beardog.cce.hp.com


The patch titled
     cciss: make interrupt access methods return type bool
has been added to the -mm tree.  Its filename is
     cciss-make-interrupt-access-methods-return-type-bool.patch

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
Subject: cciss: make interrupt access methods return type bool
From: Mike Miller <mike.miller@hp.com>

Change the return type of our interrupt access routines to bool from
unsigned long.  It makes more sense that way.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/block/cciss.h~cciss-make-interrupt-access-methods-return-type-bool drivers/block/cciss.h
--- a/drivers/block/cciss.h~cciss-make-interrupt-access-methods-return-type-bool
+++ a/drivers/block/cciss.h
@@ -25,7 +25,7 @@ struct access_method {
 	void (*submit_command)(ctlr_info_t *h, CommandList_struct *c);
 	void (*set_intr_mask)(ctlr_info_t *h, unsigned long val);
 	unsigned long (*fifo_full)(ctlr_info_t *h);
-	unsigned long (*intr_pending)(ctlr_info_t *h);
+	bool (*intr_pending)(ctlr_info_t *h);
 	unsigned long (*command_completed)(ctlr_info_t *h);
 };
 typedef struct _drive_info_struct
@@ -253,7 +253,7 @@ static unsigned long SA5_completed(ctlr_
 /*
  *	Returns true if an interrupt is pending.. 
  */
-static unsigned long SA5_intr_pending(ctlr_info_t *h)
+static bool SA5_intr_pending(ctlr_info_t *h)
 {
 	unsigned long register_value  = 
 		readl(h->vaddr + SA5_INTR_STATUS);
@@ -268,7 +268,7 @@ static unsigned long SA5_intr_pending(ct
 /*
  *      Returns true if an interrupt is pending..
  */
-static unsigned long SA5B_intr_pending(ctlr_info_t *h)
+static bool SA5B_intr_pending(ctlr_info_t *h)
 {
         unsigned long register_value  =
                 readl(h->vaddr + SA5_INTR_STATUS);
_

Patches currently in -mm which might be from mike.miller@hp.com are

cciss-enqueue-and-submit-io.patch
cciss-clean-up-interrupt-handler.patch
cciss-check-for-msi-in-interrupt_not_for_us.patch
cciss-make-interrupt-access-methods-return-type-bool.patch
cciss-add-performant-mode-support-for-stars-sirius.patch
cciss-new-controller-support-and-bump-driver-version.patch

