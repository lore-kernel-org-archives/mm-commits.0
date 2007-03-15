From: akpm@linux-foundation.org
Subject: + small-fixes-for-jsm-driver.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:53:33 -0800
Message-ID: <200703151853.l2FIrZKr023425@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35778 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbXCOSxp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:53:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lsorense@csclub.uwaterloo.ca, Scott_Kilau@digi.com, wendyx@us.ibm.com


The patch titled
     Small fixes for jsm driver
has been added to the -mm tree.  Its filename is
     small-fixes-for-jsm-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Small fixes for jsm driver
From: Len Sorensen <lsorense@csclub.uwaterloo.ca>

The jsm driver fails when you try to use the TIOCSSERIAL ioctl.  The reason
is that the driver never sets uart_port.uartclk, causing the data received
using TIOCGSERIAL to not match the internal state of the driver.  This
patch fixes this problem by settings the uartclk to the value used by the
serial_core (16 times the baud base).

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Scott H Kilau <Scott_Kilau@digi.com>
Cc: Wendy Xiong <wendyx@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm_tty.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/serial/jsm/jsm_tty.c~small-fixes-for-jsm-driver drivers/serial/jsm/jsm_tty.c
--- a/drivers/serial/jsm/jsm_tty.c~small-fixes-for-jsm-driver
+++ a/drivers/serial/jsm/jsm_tty.c
@@ -448,6 +448,7 @@ int jsm_uart_port_init(struct jsm_board 
 			continue;
 
 		brd->channels[i]->uart_port.irq = brd->irq;
+		brd->channels[i]->uart_port.uartclk = 14745600;
 		brd->channels[i]->uart_port.type = PORT_JSM;
 		brd->channels[i]->uart_port.iotype = UPIO_MEM;
 		brd->channels[i]->uart_port.membase = brd->re_map_membase;
_

Patches currently in -mm which might be from lsorense@csclub.uwaterloo.ca are

small-fixes-for-jsm-driver.patch
jsm-driver-fix-for-linuxpps-support.patch
