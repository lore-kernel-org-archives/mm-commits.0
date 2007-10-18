From: akpm@linux-foundation.org
Subject: + fix-random-hard-freeze-with-avm-c4-card-part-2.patch added to -mm tree
Date: Thu, 18 Oct 2007 14:13:20 -0700
Message-ID: <200710182113.l9ILDKZY031441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52267 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758118AbXJRVNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 17:13:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kkeil@suse.de


The patch titled
     isdn: fix random hard freeze with AVM c4 card part 2
has been added to the -mm tree.  Its filename is
     fix-random-hard-freeze-with-avm-c4-card-part-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: isdn: fix random hard freeze with AVM c4 card part 2
From: Karsten Keil <kkeil@suse.de>

One call was missing in the previous patch.

Signed-off-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/avm/c4.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/isdn/hardware/avm/c4.c~fix-random-hard-freeze-with-avm-c4-card-part-2 drivers/isdn/hardware/avm/c4.c
--- a/drivers/isdn/hardware/avm/c4.c~fix-random-hard-freeze-with-avm-c4-card-part-2
+++ a/drivers/isdn/hardware/avm/c4.c
@@ -678,7 +678,9 @@ static irqreturn_t c4_handle_interrupt(a
                 for (i=0; i < card->nr_controllers; i++) {
 			avmctrl_info *cinfo = &card->ctrlinfo[i];
 			memset(cinfo->version, 0, sizeof(cinfo->version));
+			spin_lock_irqsave(&card->lock, flags);
 			capilib_release(&cinfo->ncci_head);
+			spin_unlock_irqrestore(&card->lock, flags);
 			capi_ctr_reseted(&cinfo->capi_ctrl);
 		}
 		card->nlogcontr = 0;
_

Patches currently in -mm which might be from kkeil@suse.de are

origin.patch
fix-random-freezes-with-avm-b1-drivers.patch
fix-random-hard-freeze-with-avm-c4-card.patch
fix-random-hard-freeze-with-avm-c4-card-part-2.patch
fix-random-hard-freeze-with-avm-cards-using-b1dma.patch
fix-random-hard-freeze-with-avm-t1-cards.patch
