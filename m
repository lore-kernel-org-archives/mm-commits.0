From: akpm@linux-foundation.org
Subject: - serial_txx9-fix-printk-format-mismatch.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:54:53 -0700
Message-ID: <200707312354.l6VNsrDE029182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47691 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758443AbXGaXzd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 19:55:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, mm-commits@vger.kernel.org


The patch titled
     serial_txx9: fix printk format mismatch
has been removed from the -mm tree.  Its filename was
     serial_txx9-fix-printk-format-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1043,8 +1043,9 @@ static int __devinit serial_txx9_probe(s
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
serial_txx9-fix-modem-control-line-handling.patch
serial_txx9-cleanup-includes.patch
