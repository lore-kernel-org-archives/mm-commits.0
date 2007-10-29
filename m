From: akpm@linux-foundation.org
Subject: + uartlite-speed-up-console-output.patch added to -mm tree
Date: Mon, 29 Oct 2007 13:44:54 -0700
Message-ID: <200710292044.l9TKisOi022422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58235 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760AbXJ2Upa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:45:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grant.likely@secretlab.ca, benh@kernel.crashing.org, jwboyer@linux.vnet.ibm.com, paulus@samba.org


The patch titled
     Uartlite: speed up console output
has been added to the -mm tree.  Its filename is
     uartlite-speed-up-console-output.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Uartlite: speed up console output
From: Grant Likely <grant.likely@secretlab.ca>

Change the wait_tx routine to call cpu_relax() instead of udelay() to
reduce console output latency and test for the TXFULL bit instead of
TXEMPTY.  That way the FIFO doesn't need to by 100% flushed before writing
the next character.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/uartlite.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/serial/uartlite.c~uartlite-speed-up-console-output drivers/serial/uartlite.c
--- a/drivers/serial/uartlite.c~uartlite-speed-up-console-output
+++ a/drivers/serial/uartlite.c
@@ -329,12 +329,14 @@ static struct uart_ops ulite_ops = {
 static void ulite_console_wait_tx(struct uart_port *port)
 {
 	int i;
+	u8 val;
 
-	/* wait up to 10ms for the character(s) to be sent */
-	for (i = 0; i < 10000; i++) {
-		if (readb(port->membase + ULITE_STATUS) & ULITE_STATUS_TXEMPTY)
+	/* Spin waiting for TX fifo to have space available */
+	for (i = 0; i < 100000; i++) {
+		val = readb(port->membase + ULITE_STATUS);
+		if ((val & ULITE_STATUS_TXFULL) == 0)
 			break;
-		udelay(1);
+		cpu_relax();
 	}
 }
 
_

Patches currently in -mm which might be from grant.likely@secretlab.ca are

uartlite-speed-up-console-output.patch
