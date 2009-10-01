From: akpm@linux-foundation.org
Subject: + jsm-remove-the-field-jsm_board-intr_count.patch added to -mm tree
Date: Thu, 01 Oct 2009 13:54:25 -0700
Message-ID: <200910012054.n91KsPvq014593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752106AbZJAUzQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2009 16:55:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leitao@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, scottk@digi.com


The patch titled
     jsm: remove the field jsm_board->intr_count
has been added to the -mm tree.  Its filename is
     jsm-remove-the-field-jsm_board-intr_count.patch

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
Subject: jsm: remove the field jsm_board->intr_count
From: Breno Leitao <leitao@linux.vnet.ibm.com>

Currently there is a field in the jsm_board structure to cont the number
of interrupt that the card recevived, but it's not working properly when
the IRQ line is shared, and also nowhere else this field is used.  So,
This patch is removing it.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Scott Kilau <scottk@digi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm.h     |    1 -
 drivers/serial/jsm/jsm_neo.c |    2 --
 2 files changed, 3 deletions(-)

diff -puN drivers/serial/jsm/jsm.h~jsm-remove-the-field-jsm_board-intr_count drivers/serial/jsm/jsm.h
--- a/drivers/serial/jsm/jsm.h~jsm-remove-the-field-jsm_board-intr_count
+++ a/drivers/serial/jsm/jsm.h
@@ -138,7 +138,6 @@ struct jsm_board
 	u32		nasync;		/* Number of ports on card */
 
 	u32		irq;		/* Interrupt request number */
-	u64		intr_count;	/* Count of interrupts */
 
 	u64		membase;	/* Start of base memory of the card */
 	u64		membase_end;	/* End of base memory of the card */
diff -puN drivers/serial/jsm/jsm_neo.c~jsm-remove-the-field-jsm_board-intr_count drivers/serial/jsm/jsm_neo.c
--- a/drivers/serial/jsm/jsm_neo.c~jsm-remove-the-field-jsm_board-intr_count
+++ a/drivers/serial/jsm/jsm_neo.c
@@ -1117,8 +1117,6 @@ static irqreturn_t neo_intr(int irq, voi
 	unsigned long lock_flags2;
 	int outofloop_count = 0;
 
-	brd->intr_count++;
