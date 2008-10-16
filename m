From: akpm@linux-foundation.org
Subject: + serial_txx9-use-%lx-for-iobase.patch added to -mm tree
Date: Thu, 16 Oct 2008 16:23:16 -0700
Message-ID: <200810162323.m9GNNGeA005423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756304AbYJPXYR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 19:24:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, alan@lxorguk.ukuu.org.uk, joy@entuzijast.net


The patch titled
     serial_txx9: use %lx for iobase
has been added to the -mm tree.  Its filename is
     serial_txx9-use-%lx-for-iobase.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
rtc-file-close-consistently-disables-repeating-irqs.patch
rtc-rtc-m41t80c-add-support-for-the-st-m41t65-rtc.patch
serial_txx9-use-%lx-for-iobase.patch

