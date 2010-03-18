From: akpm@linux-foundation.org
Subject: [merged] cpm_uart-use-resource_size.patch removed from -mm tree
Date: Thu, 18 Mar 2010 11:09:04 -0400
Message-ID: <201003181809.o2II9jAF007593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676Ab0CRSKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 14:10:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, alan@lxorguk.ukuu.org.uk, galak@gate.crashing.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     cpm_uart: use resource_size()
has been removed from the -mm tree.  Its filename was
     cpm_uart-use-resource_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpm_uart: use resource_size()
From: Tobias Klauser <tklauser@distanz.ch>

Use the resource_size function instead of manually calculating the
resource size.  This reduces the chance of introducing off-by-one errors.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/cpm_uart/cpm_uart_cpm2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/cpm_uart/cpm_uart_cpm2.c~cpm_uart-use-resource_size drivers/serial/cpm_uart/cpm_uart_cpm2.c
--- a/drivers/serial/cpm_uart/cpm_uart_cpm2.c~cpm_uart-use-resource_size
+++ a/drivers/serial/cpm_uart/cpm_uart_cpm2.c
@@ -61,7 +61,7 @@ void __iomem *cpm_uart_map_pram(struct u
 	void __iomem *pram;
 	unsigned long offset;
 	struct resource res;
-	unsigned long len;
+	resource_size_t len;
 
 	/* Don't remap parameter RAM if it has already been initialized
 	 * during console setup.
@@ -74,7 +74,7 @@ void __iomem *cpm_uart_map_pram(struct u
 	if (of_address_to_resource(np, 1, &res))
 		return NULL;
 
-	len = 1 + res.end - res.start;
+	len = resource_size(&res);
 	pram = ioremap(res.start, len);
 	if (!pram)
 		return NULL;
_

Patches currently in -mm which might be from tklauser@distanz.ch are

linux-next.patch
serial-add-driver-for-the-altera-jtag-uart.patch
serial-add-driver-for-the-altera-uart.patch

