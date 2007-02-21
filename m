From: akpm@linux-foundation.org
Subject: - 8250-fix-gcc4-signed-unsigned-mismatch-warning.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:45:58 -0800
Message-ID: <200702211045.l1LAjwb8006417@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46916 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416AbXBUKqR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:46:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas.koeller@baslerweb.com, mm-commits@vger.kernel.org


The patch titled
     8250: Fix GCC4 signed/unsigned mismatch warning
has been removed from the -mm tree.  Its filename was
     8250-fix-gcc4-signed-unsigned-mismatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: 8250: Fix GCC4 signed/unsigned mismatch warning
From: Thomas Koeller <thomas.koeller@baslerweb.com>

Signed-off-by: Thomas Koeller <thomas.koeller@baslerweb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/8250.c~8250-fix-gcc4-signed-unsigned-mismatch-warning drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250-fix-gcc4-signed-unsigned-mismatch-warning
+++ a/drivers/serial/8250.c
@@ -1196,7 +1196,7 @@ static void serial8250_enable_ms(struct 
 }
 
 static void
-receive_chars(struct uart_8250_port *up, int *status)
+receive_chars(struct uart_8250_port *up, unsigned int *status)
 {
 	struct tty_struct *tty = up->port.info->tty;
 	unsigned char ch, lsr = *status;
_

Patches currently in -mm which might be from thomas.koeller@baslerweb.com are
