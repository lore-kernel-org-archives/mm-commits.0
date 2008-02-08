From: akpm@linux-foundation.org
Subject: - dz-dont-panic-when-request_irq-fails.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:17 -0800
Message-ID: <200802080805.m1885wxo014387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42323 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761076AbYBHITg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     dz: don't panic() when request_irq() fails
has been removed from the -mm tree.  Its filename was
     dz-dont-panic-when-request_irq-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dz: don't panic() when request_irq() fails
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Well, panic() is a little bit undue if request_irq() fails; there is probably
no need to justify it any further.  Handle the case gracefully, by
unregistering the driver.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/dz.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN drivers/serial/dz.c~dz-dont-panic-when-request_irq-fails drivers/serial/dz.c
--- a/drivers/serial/dz.c~dz-dont-panic-when-request_irq-fails
+++ a/drivers/serial/dz.c
@@ -794,18 +794,28 @@ static int __init dz_init(void)
 	dz_reset(&dz_ports[0]);
 #endif
 
-	if (request_irq(dz_ports[0].port.irq, dz_interrupt,
-			IRQF_DISABLED, "DZ", &dz_ports[0]))
-		panic("Unable to register DZ interrupt");
-
 	ret = uart_register_driver(&dz_reg);
 	if (ret != 0)
-		return ret;
+		goto out;
+
+	ret = request_irq(dz_ports[0].port.irq, dz_interrupt, IRQF_DISABLED,
+			  "DZ", &dz_ports[0]);
+	if (ret != 0) {
+		printk(KERN_ERR "dz: Cannot get IRQ %d!\n",
+		       dz_ports[0].port.irq);
+		goto out_unregister;
+	}
 
 	for (i = 0; i < DZ_NB_PORT; i++)
 		uart_add_one_port(&dz_reg, &dz_ports[i].port);
 
 	return ret;
+
+out_unregister:
+	uart_unregister_driver(&dz_reg);
+
+out:
+	return ret;
 }
 
 module_init(dz_init);
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
