From: akpm@linux-foundation.org
Subject: + blackfin-serial-driver-fix-bug-up-arrow-key-works-abnormal-for-bf561-ezkit-board.patch added to -mm tree
Date: Fri, 06 Mar 2009 14:37:37 -0800
Message-ID: <200903062237.n26Mbbn2007080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755330AbZCFWiY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 17:38:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: graf.yang@analog.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org


The patch titled
     blackfin serial driver: fix bug - up arrow key works abnormal for bf561 ezkit board
has been added to the -mm tree.  Its filename is
     blackfin-serial-driver-fix-bug-up-arrow-key-works-abnormal-for-bf561-ezkit-board.patch

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
Subject: blackfin serial driver: fix bug - up arrow key works abnormal for bf561 ezkit board
From: Graf Yang <graf.yang@analog.com>

Subtrack ANOMALY_05000230 on quot.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/bfin_5xx.c~blackfin-serial-driver-fix-bug-up-arrow-key-works-abnormal-for-bf561-ezkit-board drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~blackfin-serial-driver-fix-bug-up-arrow-key-works-abnormal-for-bf561-ezkit-board
+++ a/drivers/serial/bfin_5xx.c
@@ -789,7 +789,7 @@ bfin_serial_set_termios(struct uart_port
 	}
 
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16);
-	quot = uart_get_divisor(port, baud);
+	quot = uart_get_divisor(port, baud) - ANOMALY_05000230;
 	spin_lock_irqsave(&uart->port.lock, flags);
 
 	UART_SET_ANOMALY_THRESHOLD(uart, USEC_PER_SEC / baud * 15);
_

Patches currently in -mm which might be from graf.yang@analog.com are

linux-next.patch
mtd-cfi-fix-bug-bonnie-error-on-bf548-nor-flash.patch
blackfin-serial-driver-add-a-debug-function-to-serial-driver.patch
blackfin-serial-driver-use-barrier-instead-of-cpu_relax-for-blackfin-smp-like-patch.patch
blackfin-serial-driver-fix-bug-up-arrow-key-works-abnormal-for-bf561-ezkit-board.patch

