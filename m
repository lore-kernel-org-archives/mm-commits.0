From: akpm@linux-foundation.org
Subject: - pnp-fix-formatting-of-dbg_pnp_show_resources-output.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:05:48 -0700
Message-ID: <200808042005.m74K5mrV027624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757944AbYHDUGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:06:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, clem@clem.clem-digital.net, rene.herman@keyaccess.nl, uwe.bugla@gmx.de, mm-commits@vger.kernel.org


The patch titled
     PNP: fix formatting of dbg_pnp_show_resources() output
has been removed from the -mm tree.  Its filename was
     pnp-fix-formatting-of-dbg_pnp_show_resources-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PNP: fix formatting of dbg_pnp_show_resources() output
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Each resource should be printed on its own line, so start snprintf'ing
at the beginning of the buffer every time through the loop.

Also, use scnprintf() rather than snprintf() when building up the
buffer to print.  scnprintf() returns the number of characters actually
written into the buffer (not including the trailing NULL).

snprintf() returns the number of characters that *would be* written,
assuming everything would fit in the buffer.  That's nice if we want to
resize the buffer to make sure everything fits, but in this case, I
just want to keep from overflowing the buffer, and it's OK if the
output is truncated.

Using snprintf() meant that my "len" could grow to be more than the
the buffer size, which makes "sizeof(buf) - len" negative, which causes
this alarming WARN_ON:
    http://marc.info/?l=linux-kernel&m=121736480005656&w=2

More useful snprintf/scnprintf discussion:
    http://lwn.net/Articles/69419/

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Reported-by: Pete Clements <clem@clem.clem-digital.net>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/support.c |   96 ++++++++++++++++++++--------------------
 1 file changed, 49 insertions(+), 47 deletions(-)

diff -puN drivers/pnp/support.c~pnp-fix-formatting-of-dbg_pnp_show_resources-output drivers/pnp/support.c
--- a/drivers/pnp/support.c~pnp-fix-formatting-of-dbg_pnp_show_resources-output
+++ a/drivers/pnp/support.c
@@ -77,7 +77,7 @@ void dbg_pnp_show_resources(struct pnp_d
 {
 #ifdef DEBUG
 	char buf[128];
-	int len = 0;
+	int len;
 	struct pnp_resource *pnp_res;
 	struct resource *res;
 
@@ -89,9 +89,10 @@ void dbg_pnp_show_resources(struct pnp_d
 	dev_dbg(&dev->dev, "%s: current resources:\n", desc);
 	list_for_each_entry(pnp_res, &dev->resources, list) {
 		res = &pnp_res->res;
+		len = 0;
 
-		len += snprintf(buf + len, sizeof(buf) - len, "  %-3s ",
-				pnp_resource_type_name(res));
+		len += scnprintf(buf + len, sizeof(buf) - len, "  %-3s ",
+				 pnp_resource_type_name(res));
 
 		if (res->flags & IORESOURCE_DISABLED) {
 			dev_dbg(&dev->dev, "%sdisabled\n", buf);
@@ -101,18 +102,18 @@ void dbg_pnp_show_resources(struct pnp_d
 		switch (pnp_resource_type(res)) {
 		case IORESOURCE_IO:
 		case IORESOURCE_MEM:
-			len += snprintf(buf + len, sizeof(buf) - len,
-					"%#llx-%#llx flags %#lx",
-					(unsigned long long) res->start,
-					(unsigned long long) res->end,
-					res->flags);
+			len += scnprintf(buf + len, sizeof(buf) - len,
+					 "%#llx-%#llx flags %#lx",
+					 (unsigned long long) res->start,
+					 (unsigned long long) res->end,
+					 res->flags);
 			break;
 		case IORESOURCE_IRQ:
 		case IORESOURCE_DMA:
-			len += snprintf(buf + len, sizeof(buf) - len,
-					"%lld flags %#lx",
-					(unsigned long long) res->start,
-					res->flags);
+			len += scnprintf(buf + len, sizeof(buf) - len,
+					 "%lld flags %#lx",
+					 (unsigned long long) res->start,
+					 res->flags);
 			break;
 		}
 		dev_dbg(&dev->dev, "%s\n", buf);
@@ -144,66 +145,67 @@ void dbg_pnp_show_option(struct pnp_dev 
 	struct pnp_dma *dma;
 
 	if (pnp_option_is_dependent(option))
-		len += snprintf(buf + len, sizeof(buf) - len,
-				"  dependent set %d (%s) ",
-				pnp_option_set(option),
-				pnp_option_priority_name(option));
+		len += scnprintf(buf + len, sizeof(buf) - len,
+				 "  dependent set %d (%s) ",
+				 pnp_option_set(option),
+				 pnp_option_priority_name(option));
 	else
-		len += snprintf(buf + len, sizeof(buf) - len, "  independent ");
+		len += scnprintf(buf + len, sizeof(buf) - len,
+				 "  independent ");
 
 	switch (option->type) {
 	case IORESOURCE_IO:
 		port = &option->u.port;
-		len += snprintf(buf + len, sizeof(buf) - len, "io  min %#llx "
-				"max %#llx align %lld size %lld flags %#x",
-				(unsigned long long) port->min,
-				(unsigned long long) port->max,
-				(unsigned long long) port->align,
-				(unsigned long long) port->size, port->flags);
+		len += scnprintf(buf + len, sizeof(buf) - len, "io  min %#llx "
+				 "max %#llx align %lld size %lld flags %#x",
+				 (unsigned long long) port->min,
+				 (unsigned long long) port->max,
+				 (unsigned long long) port->align,
+				 (unsigned long long) port->size, port->flags);
 		break;
 	case IORESOURCE_MEM:
 		mem = &option->u.mem;
-		len += snprintf(buf + len, sizeof(buf) - len, "mem min %#llx "
-				"max %#llx align %lld size %lld flags %#x",
-				(unsigned long long) mem->min,
-				(unsigned long long) mem->max,
-				(unsigned long long) mem->align,
-				(unsigned long long) mem->size, mem->flags);
+		len += scnprintf(buf + len, sizeof(buf) - len, "mem min %#llx "
+				 "max %#llx align %lld size %lld flags %#x",
+				 (unsigned long long) mem->min,
+				 (unsigned long long) mem->max,
+				 (unsigned long long) mem->align,
+				 (unsigned long long) mem->size, mem->flags);
 		break;
 	case IORESOURCE_IRQ:
 		irq = &option->u.irq;
-		len += snprintf(buf + len, sizeof(buf) - len, "irq");
+		len += scnprintf(buf + len, sizeof(buf) - len, "irq");
 		if (bitmap_empty(irq->map.bits, PNP_IRQ_NR))
-			len += snprintf(buf + len, sizeof(buf) - len,
-					" <none>");
+			len += scnprintf(buf + len, sizeof(buf) - len,
+					 " <none>");
 		else {
 			for (i = 0; i < PNP_IRQ_NR; i++)
 				if (test_bit(i, irq->map.bits))
-					len += snprintf(buf + len,
-							sizeof(buf) - len,
-							" %d", i);
+					len += scnprintf(buf + len,
+							 sizeof(buf) - len,
+							 " %d", i);
 		}
-		len += snprintf(buf + len, sizeof(buf) - len, " flags %#x",
-				irq->flags);
+		len += scnprintf(buf + len, sizeof(buf) - len, " flags %#x",
+				 irq->flags);
 		if (irq->flags & IORESOURCE_IRQ_OPTIONAL)
-			len += snprintf(buf + len, sizeof(buf) - len,
-					" (optional)");
+			len += scnprintf(buf + len, sizeof(buf) - len,
+					 " (optional)");
 		break;
 	case IORESOURCE_DMA:
 		dma = &option->u.dma;
-		len += snprintf(buf + len, sizeof(buf) - len, "dma");
+		len += scnprintf(buf + len, sizeof(buf) - len, "dma");
 		if (!dma->map)
-			len += snprintf(buf + len, sizeof(buf) - len,
-					" <none>");
+			len += scnprintf(buf + len, sizeof(buf) - len,
+					 " <none>");
 		else {
 			for (i = 0; i < 8; i++)
 				if (dma->map & (1 << i))
-					len += snprintf(buf + len,
-							sizeof(buf) - len,
-							" %d", i);
+					len += scnprintf(buf + len,
+							 sizeof(buf) - len,
+							 " %d", i);
 		}
-		len += snprintf(buf + len, sizeof(buf) - len, " (bitmask %#x) "
-				"flags %#x", dma->map, dma->flags);
+		len += scnprintf(buf + len, sizeof(buf) - len, " (bitmask %#x) "
+				 "flags %#x", dma->map, dma->flags);
 		break;
 	}
 	dev_dbg(&dev->dev, "%s\n", buf);
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
firmware-use-dev_printk-when-possible.patch
resources-tidy-__request_region.patch

