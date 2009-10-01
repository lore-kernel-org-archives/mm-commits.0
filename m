From: akpm@linux-foundation.org
Subject: + jsm-remove-ch_old_baud-field.patch added to -mm tree
Date: Thu, 01 Oct 2009 13:54:19 -0700
Message-ID: <200910012054.n91KsJnQ014432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921AbZJAUy4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2009 16:54:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leitao@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, scottk@digi.com


The patch titled
     jsm: remove ch_old_baud field
has been added to the -mm tree.  Its filename is
     jsm-remove-ch_old_baud-field.patch

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
Subject: jsm: remove ch_old_baud field
From: Breno Leitao <leitao@linux.vnet.ibm.com>

Currently the field jsm_channel->ch_old_baud is not used, just assigned in
a lot of places but never used.  This patches removes this field.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>
Cc: Scott Kilau <scottk@digi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm.h     |    2 --
 drivers/serial/jsm/jsm_neo.c |    2 --
 drivers/serial/jsm/jsm_tty.c |    2 --
 3 files changed, 6 deletions(-)

diff -puN drivers/serial/jsm/jsm.h~jsm-remove-ch_old_baud-field drivers/serial/jsm/jsm.h
--- a/drivers/serial/jsm/jsm.h~jsm-remove-ch_old_baud-field
+++ a/drivers/serial/jsm/jsm.h
@@ -215,8 +215,6 @@ struct jsm_channel {
 	u8		ch_stopc;	/* Stop character		*/
 	u8		ch_startc;	/* Start character		*/
 
-	u32		ch_old_baud;	/* Cache of the current baud */
-
 	u32		ch_wopen;	/* Waiting for open process cnt */
 
 	u8		ch_mostat;	/* FEP output modem status	*/
diff -puN drivers/serial/jsm/jsm_neo.c~jsm-remove-ch_old_baud-field drivers/serial/jsm/jsm_neo.c
--- a/drivers/serial/jsm/jsm_neo.c~jsm-remove-ch_old_baud-field
+++ a/drivers/serial/jsm/jsm_neo.c
@@ -954,7 +954,6 @@ static void neo_param(struct jsm_channel
 		ch->ch_flags |= (CH_BAUD0);
 		ch->ch_mostat &= ~(UART_MCR_RTS | UART_MCR_DTR);
 		neo_assert_modem_signals(ch);
-		ch->ch_old_baud = 0;
 		return;
 
 	} else {
@@ -1041,7 +1040,6 @@ static void neo_param(struct jsm_channel
 	quot = ch->ch_bd->bd_dividend / baud;
 
 	if (quot != 0) {
-		ch->ch_old_baud = baud;
 		writeb(UART_LCR_DLAB, &ch->ch_neo_uart->lcr);
 		writeb((quot & 0xff), &ch->ch_neo_uart->txrx);
 		writeb((quot >> 8), &ch->ch_neo_uart->ier);
diff -puN drivers/serial/jsm/jsm_tty.c~jsm-remove-ch_old_baud-field drivers/serial/jsm/jsm_tty.c
--- a/drivers/serial/jsm/jsm_tty.c~jsm-remove-ch_old_baud-field
+++ a/drivers/serial/jsm/jsm_tty.c
@@ -296,8 +296,6 @@ static void jsm_tty_close(struct uart_po
 		bd->bd_ops->assert_modem_signals(channel);
 	}
 
-	channel->ch_old_baud = 0;
