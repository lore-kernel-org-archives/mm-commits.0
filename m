From: akpm@linux-foundation.org
Subject: + blackfin-serial-driver-fix-a-bug-in-dma-circle-rx-buffer-handling.patch added to -mm tree
Date: Fri, 06 Mar 2009 14:37:06 -0800
Message-ID: <200903062237.n26Mb6kH007009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753786AbZCFWh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 17:37:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sonic.zhang@analog.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org, zhangq@sansitech.com


The patch titled
     blackfin serial driver: fix a bug in dma circle rx buffer handling
has been added to the -mm tree.  Its filename is
     blackfin-serial-driver-fix-a-bug-in-dma-circle-rx-buffer-handling.patch

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
Subject: blackfin serial driver: fix a bug in dma circle rx buffer handling
From: Sonic Zhang <sonic.zhang@analog.com>

Reported-by: Qian Zhang <zhangq@sansitech.com>
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/serial/bfin_5xx.c~blackfin-serial-driver-fix-a-bug-in-dma-circle-rx-buffer-handling drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~blackfin-serial-driver-fix-a-bug-in-dma-circle-rx-buffer-handling
+++ a/drivers/serial/bfin_5xx.c
@@ -402,9 +402,11 @@ static void bfin_serial_dma_rx_chars(str
 	else
 		flg = TTY_NORMAL;
 
-	for (i = uart->rx_dma_buf.tail; i != uart->rx_dma_buf.head; i++) {
+	for (i = uart->rx_dma_buf.tail; ; i++) {
 		if (i >= UART_XMIT_SIZE)
 			i = 0;
+		if (i == uart->rx_dma_buf.head)
+			break;
 		if (!uart_handle_sysrq_char(&uart->port, uart->rx_dma_buf.buf[i]))
 			uart_insert_char(&uart->port, status, OE,
 				uart->rx_dma_buf.buf[i], flg);
_

Patches currently in -mm which might be from sonic.zhang@analog.com are

linux-next.patch
blackfin-serial-driver-fix-a-bug-in-dma-circle-rx-buffer-handling.patch
blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven.patch
blackfin-serial-driver-fix-bug-serial-port-transfer-big-file-from-host-to-target-would-have-more-lines.patch
blackfin-serial-driver-fix-compile-error-in-pio-mode.patch
blackfin-serial-driver-fix-bug-enable-hardware-based-cts-and-rts-for-bf548.patch

