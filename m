From: akpm@linux-foundation.org
Subject: + serial_txx9-fix-printk-format-mismatch.patch added to -mm tree
Date: Thu, 26 Jul 2007 22:24:35 -0700
Message-ID: <200707270524.l6R5OZDj007283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55588 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754370AbXG0FZT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 01:25:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp


The patch titled
     serial_txx9: fix printk format mismatch
has been added to the -mm tree.  Its filename is
     serial_txx9-fix-printk-format-mismatch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial_txx9: fix printk format mismatch
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Since the commit 4f640efb3170dbcf99a37a3cc99060647b95428c, "%lx" is not
suitable for p->mapbase (resource_size_t) in 32-bit.  This patch fixes a
compiler warning caused by the mismatch.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_txx9.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/serial/serial_txx9.c~serial_txx9-fix-printk-format-mismatch drivers/serial/serial_txx9.c
--- a/drivers/serial/serial_txx9.c~serial_txx9-fix-printk-format-mismatch
+++ a/drivers/serial/serial_txx9.c
@@ -1060,8 +1060,9 @@ static int __devinit serial_txx9_probe(s
 		ret = serial_txx9_register_port(&port);
 		if (ret < 0) {
 			dev_err(&dev->dev, "unable to register port at index %d "
-				"(IO%x MEM%lx IRQ%d): %d\n", i,
-				p->iobase, p->mapbase, p->irq, ret);
+				"(IO%x MEM%llx IRQ%d): %d\n", i,
+				p->iobase, (unsigned long long)p->mapbase,
+				p->irq, ret);
 		}
 	}
 	return 0;
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
serial_txx9-fix-printk-format-mismatch.patch
serial_txx9-fix-modem-control-line-handling.patch
serial_txx9-cleanup-includes.patch
