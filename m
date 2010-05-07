From: akpm@linux-foundation.org
Subject: [merged] serial-mpc52xx_uart-fix-null-pointer-dereference.patch removed from -mm tree
Date: Fri, 07 May 2010 12:10:58 -0400
Message-ID: <201005071912.o47JCSMS006475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757799Ab0EGTMi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 May 2010 15:12:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agust@denx.de, grant.likely@secretlab.ca, gregkh@suse.de, jcrigby@gmail.com, leonardo.lists@gmail.com, mm-commits@vger.kernel.org


The patch titled
     serial: mpc52xx_uart: fix null pointer dereference
has been removed from the -mm tree.  Its filename was
     serial-mpc52xx_uart-fix-null-pointer-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: mpc52xx_uart: fix null pointer dereference
From: Anatolij Gustschin <agust@denx.de>

Commit 6acc6833510db8f72b5ef343296d97480555fda9 ("serial: mpc52xx_uart:
re-enable mpc5121 PSC UART support") introduced a NULL pointer dereference
and kernel crash on ppc32 machines while booting.  Fix this bug now.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Reported-by: Leonardo Chiquitto <leonardo.lists@gmail.com>
Cc: John Rigby <jcrigby@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/mpc52xx_uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/mpc52xx_uart.c~serial-mpc52xx_uart-fix-null-pointer-dereference drivers/serial/mpc52xx_uart.c
--- a/drivers/serial/mpc52xx_uart.c~serial-mpc52xx_uart-fix-null-pointer-dereference
+++ a/drivers/serial/mpc52xx_uart.c
@@ -1554,7 +1554,7 @@ mpc52xx_uart_init(void)
 	/*
 	 * Map the PSC FIFO Controller and init if on MPC512x.
 	 */
-	if (psc_ops->fifoc_init) {
+	if (psc_ops && psc_ops->fifoc_init) {
 		ret = psc_ops->fifoc_init();
 		if (ret)
 			return ret;
_

Patches currently in -mm which might be from agust@denx.de are

linux-next.patch

