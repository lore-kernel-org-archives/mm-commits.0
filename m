From: akpm@osdl.org
Subject: - amba-pl010-clear-error-flags-on-rx-error.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:15:49 -0800
Message-ID: <200612072315.kB7NFnoI030752@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53563 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163779AbWLGXPv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:15:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buytenh@wantstofly.org, mm-commits@vger.kernel.org


The patch titled
     amba-pl010: clear error flags on rx error
has been removed from the -mm tree.  Its filename was
     amba-pl010-clear-error-flags-on-rx-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: amba-pl010: clear error flags on rx error
From: Lennert Buytenhek <buytenh@wantstofly.org>

The pl010 primecell documentation specifies that an error indicated via RSR
should be cleared by a write to ECR.  We didn't do this, which was causing
errors to be re-reported on every call to pl010_rx_chars().

Doing a write to ECR once we detect an error appears to prevent the ep93xx
console UART driver from going into a mode where it reports "ttyAM0: X
input overrun(s)" every couple of keystrokes.

Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/serial/amba-pl010.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/serial/amba-pl010.c~amba-pl010-clear-error-flags-on-rx-error drivers/serial/amba-pl010.c
--- a/drivers/serial/amba-pl010.c~amba-pl010-clear-error-flags-on-rx-error
+++ a/drivers/serial/amba-pl010.c
@@ -129,6 +129,8 @@ static void pl010_rx_chars(struct uart_p
 		 */
 		rsr = readb(port->membase + UART01x_RSR) | UART_DUMMY_RSR_RX;
 		if (unlikely(rsr & UART01x_RSR_ANY)) {
+			writel(0, port->membase + UART01x_ECR);
+
 			if (rsr & UART01x_RSR_BE) {
 				rsr &= ~(UART01x_RSR_FE | UART01x_RSR_PE);
 				port->icount.brk++;
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

origin.patch

