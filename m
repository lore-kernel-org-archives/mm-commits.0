From: akpm@linux-foundation.org
Subject: - serial_txx9-use-%lx-for-iobase.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:32:21 -0700
Message-ID: <200810202032.m9KKWLDo010384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbYJTUdU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:33:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, alan@lxorguk.ukuu.org.uk, joy@entuzijast.net, mm-commits@vger.kernel.org


The patch titled
     serial_txx9: use %lx for iobase
has been removed from the -mm tree.  Its filename was
     serial_txx9-use-%lx-for-iobase.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial_txx9: use %lx for iobase
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Fix a warning caused by commit 0c8946d97ae7d2d6691f8290a10faa63453b63f8
(serial: Make uart_port's ioport "unsigned long".)

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Josip Rodin <joy@entuzijast.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_txx9.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/serial_txx9.c~serial_txx9-use-%lx-for-iobase drivers/serial/serial_txx9.c
--- a/drivers/serial/serial_txx9.c~serial_txx9-use-%lx-for-iobase
+++ a/drivers/serial/serial_txx9.c
@@ -1039,7 +1039,7 @@ static int __devinit serial_txx9_probe(s
 		ret = serial_txx9_register_port(&port);
 		if (ret < 0) {
 			dev_err(&dev->dev, "unable to register port at index %d "
-				"(IO%x MEM%llx IRQ%d): %d\n", i,
+				"(IO%lx MEM%llx IRQ%d): %d\n", i,
 				p->iobase, (unsigned long long)p->mapbase,
 				p->irq, ret);
 		}
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
linux-next.patch

