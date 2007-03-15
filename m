From: akpm@linux-foundation.org
Subject: - z85230-fix-fifo-handling.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:59:56 -0800
Message-ID: <200703152159.l2FLxuL6027851@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42652 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbXCOWAR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 18:00:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org, khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     z85230: Fix FIFO handling
has been removed from the -mm tree.  Its filename was
     z85230-fix-fifo-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: z85230: Fix FIFO handling
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

We must exit immediately on a FIFO fill not take the end of packet path
otherwise each underrun in PIO transmit mode causes a runt packet and the
data is lost.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/z85230.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wan/z85230.c~z85230-fix-fifo-handling drivers/net/wan/z85230.c
--- a/drivers/net/wan/z85230.c~z85230-fix-fifo-handling
+++ a/drivers/net/wan/z85230.c
@@ -407,7 +407,7 @@ static void z8530_tx(struct z8530_channe
 	while(c->txcount) {
 		/* FIFO full ? */
 		if(!(read_zsreg(c, R0)&4))
-			break;
+			return;
 		c->txcount--;
 		/*
 		 *	Shovel out the byte
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pcmcia-spot-slave-decode-flaws-for-testing.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced.patch
resend-iphase-64bit-cleanup.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
