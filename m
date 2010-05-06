From: akpm@linux-foundation.org
Subject: + serial-mpc52xx_uart-fix-null-pointer-dereference.patch added to -mm tree
Date: Thu, 06 May 2010 15:09:32 -0700
Message-ID: <201005062209.o46M9WhX017913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753089Ab0EFWJo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 May 2010 18:09:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agust@denx.de, grant.likely@secretlab.ca, gregkh@suse.de, jcrigby@gmail.com, leonardo.lists@gmail.com


The patch titled
     serial: mpc52xx_uart: fix null pointer dereference
has been added to the -mm tree.  Its filename is
     serial-mpc52xx_uart-fix-null-pointer-dereference.patch

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
serial-mpc52xx_uart-fix-null-pointer-dereference.patch

