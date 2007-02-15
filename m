From: akpm@linux-foundation.org
Subject: - serial-trivial-code-flow-simplification.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:47:27 -0800
Message-ID: <200702150847.l1F8lRRY024983@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39923 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965357AbXBOIrn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:47:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     serial: trivial code flow simplification
has been removed from the -mm tree.  Its filename was
     serial-trivial-code-flow-simplification.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: serial: trivial code flow simplification
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Return failure immediately, so we don't have to test it twice.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/serial/8250_pnp.c~serial-trivial-code-flow-simplification drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~serial-trivial-code-flow-simplification
+++ a/drivers/serial/8250_pnp.c
@@ -450,11 +450,11 @@ serial_pnp_probe(struct pnp_dev *dev, co
 	port.dev = &dev->dev;
 
 	line = serial8250_register_port(&port);
+	if (line < 0)
+		return -ENODEV;
 
-	if (line >= 0)
-		pnp_set_drvdata(dev, (void *)((long)line + 1));
-	return line >= 0 ? 0 : -ENODEV;
-
+	pnp_set_drvdata(dev, (void *)((long)line + 1));
+	return 0;
 }
 
 static void __devexit serial_pnp_remove(struct pnp_dev *dev)
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
git-acpi.patch
