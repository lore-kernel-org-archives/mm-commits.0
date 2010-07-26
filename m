From: akpm@linux-foundation.org
Subject: + char-mxser-remove-unnesesary-null-check.patch added to -mm tree
Date: Mon, 26 Jul 2010 16:41:48 -0700
Message-ID: <201007262341.o6QNfmxA016698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834Ab0GZXmQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jul 2010 19:42:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com, jirislaby@gmail.com


The patch titled
     char: mxser: remove unnesesary NULL check
has been added to the -mm tree.  Its filename is
     char-mxser-remove-unnesesary-null-check.patch

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
Subject: char: mxser: remove unnesesary NULL check
From: Kulikov Vasiliy <segooon@gmail.com>

mxser_transmit_chars(tty, port) is called only from mxser_interrupt().
NULL check is performed in mxser_interrupt() so it is redundant here.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mxser.c~char-mxser-remove-unnesesary-null-check drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-mxser-remove-unnesesary-null-check
+++ a/drivers/char/mxser.c
@@ -2193,7 +2193,7 @@ static void mxser_transmit_chars(struct 
 	port->mon_data.up_txcnt += (cnt - port->xmit_cnt);
 	port->icount.tx += (cnt - port->xmit_cnt);
 
-	if (port->xmit_cnt < WAKEUP_CHARS && tty)
+	if (port->xmit_cnt < WAKEUP_CHARS)
 		tty_wakeup(tty);
 
 	if (port->xmit_cnt <= 0) {
_

Patches currently in -mm which might be from segooon@gmail.com are

linux-next.patch
i2o-fix-overflow-of-copy_to_user.patch
i2o-check-return-code-from-put_user.patch
char-mxser-remove-unnesesary-null-check.patch
edac-i5000-improve-handling-of-pci_enable_device-return-value.patch
edac-i5400-improve-handling-of-pci_enable_device-return-value.patch

