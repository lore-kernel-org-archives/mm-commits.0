From: akpm@linux-foundation.org
Subject: + altera_uart-proper-section-for-altera_uart_remove.patch added to -mm tree
Date: Thu, 03 Jun 2010 12:56:19 -0700
Message-ID: <201006031956.o53JuJgo012331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab0FCT4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jun 2010 15:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tklauser@distanz.ch, greg@kroah.com


The patch titled
     altera_uart: proper section for altera_uart_remove
has been added to the -mm tree.  Its filename is
     altera_uart-proper-section-for-altera_uart_remove.patch

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
Subject: altera_uart: proper section for altera_uart_remove
From: Tobias Klauser <tklauser@distanz.ch>

altera_uart_remove() should be in .devexit.text

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/altera_uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/altera_uart.c~altera_uart-proper-section-for-altera_uart_remove drivers/serial/altera_uart.c
--- a/drivers/serial/altera_uart.c~altera_uart-proper-section-for-altera_uart_remove
+++ a/drivers/serial/altera_uart.c
@@ -498,7 +498,7 @@ static int __devinit altera_uart_probe(s
 	return 0;
 }
 
-static int altera_uart_remove(struct platform_device *pdev)
+static int __devexit altera_uart_remove(struct platform_device *pdev)
 {
 	struct uart_port *port;
 	int i;
_

Patches currently in -mm which might be from tklauser@distanz.ch are

origin.patch
linux-next.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
altera_uart-proper-section-for-altera_uart_remove.patch

