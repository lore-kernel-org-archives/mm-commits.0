From: akpm@linux-foundation.org
Subject: - small-fixes-for-jsm-driver.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:45 -0700
Message-ID: <200705090246.l492kjBX008896@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934410AbXEICqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lsorense@csclub.uwaterloo.ca, Scott_Kilau@digi.com, wendyx@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Small fixes for jsm driver
has been removed from the -mm tree.  Its filename was
     small-fixes-for-jsm-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
