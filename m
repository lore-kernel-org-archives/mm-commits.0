From: akpm@linux-foundation.org
Subject: + atmel_serial-remove-duplicated-macro-definition.patch added to -mm tree
Date: Tue, 15 Apr 2008 22:34:08 -0700
Message-ID: <200804160534.m3G5Y8qI001727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256AbYDPFeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 01:34:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trimarchimichael@yahoo.it, hskinnemoen@atmel.com, trimarchimichael@evidence.eu.com


The patch titled
     atmel_serial: remove duplicated macro definition
has been added to the -mm tree.  Its filename is
     atmel_serial-remove-duplicated-macro-definition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial: remove duplicated macro definition
From: Michael Trimarchi <trimarchimichael@yahoo.it>

After commit 39d4c922b596633da86878b1a5cc881785b8e5fa (atmel_serial: fix
uart/console concurrent access) the UART_GET_TCR macro got redefined. This
patch removes the duplicated definition.

Signed-off-by: michael trimarchi <trimarchimichael@evidence.eu.com>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-remove-duplicated-macro-definition drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-remove-duplicated-macro-definition
+++ a/drivers/serial/atmel_serial.c
@@ -96,7 +96,6 @@
 
  /* PDC registers */
 #define UART_PUT_PTCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_PTCR)
-#define UART_GET_TCR(port)      __raw_readl((port)->membase + ATMEL_PDC_TCR)
 #define UART_GET_PTSR(port)	__raw_readl((port)->membase + ATMEL_PDC_PTSR)
 
 #define UART_PUT_RPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_RPR)
_

Patches currently in -mm which might be from trimarchimichael@yahoo.it are

jffs2-add-write-verify-on-dataflash.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
atmel_serial-remove-duplicated-macro-definition.patch

