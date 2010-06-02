From: akpm@linux-foundation.org
Subject: + cciss-check-for-msi-in-interrupt_not_for_us.patch added to -mm tree
Date: Wed, 02 Jun 2010 12:58:02 -0700
Message-ID: <201006021958.o52Jw25q013710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933022Ab0FBT6Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 15:58:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, jens.axboe@oracle.com, scameron@beardog.cce.hp.com


The patch titled
     cciss: check for msi in interrupt_not_for_us
has been added to the -mm tree.  Its filename is
     cciss-check-for-msi-in-interrupt_not_for_us.patch

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
Subject: cciss: check for msi in interrupt_not_for_us
From: Mike Miller <mike.miller@hp.com>

Check to see if h->msi[x]_vector is set.  We need this for a following
patch.  Without this check we process one interrupt then stop because in
msi[x] mode the interrupt pending bit is not set.  Not sure why we didn't
encounter this before.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/block/cciss.c~cciss-check-for-msi-in-interrupt_not_for_us drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-check-for-msi-in-interrupt_not_for_us
+++ a/drivers/block/cciss.c
@@ -3333,8 +3333,9 @@ static inline int interrupt_pending(ctlr
 
 static inline long interrupt_not_for_us(ctlr_info_t *h)
 {
-	return (((h->access.intr_pending(h) == 0) ||
-		(h->interrupts_enabled == 0)));
+	return !(h->msi_vector || h->msix_vector) &&
+		((h->access.intr_pending(h) == 0) ||
+		(h->interrupts_enabled == 0));
 }
 
 static inline int bad_tag(ctlr_info_t *h, u32 tag_index,
_

Patches currently in -mm which might be from mike.miller@hp.com are

cciss-enqueue-and-submit-io.patch
cciss-clean-up-interrupt-handler.patch
cciss-check-for-msi-in-interrupt_not_for_us.patch
cciss-make-interrupt-access-methods-return-type-bool.patch
cciss-add-performant-mode-support-for-stars-sirius.patch
cciss-new-controller-support-and-bump-driver-version.patch

