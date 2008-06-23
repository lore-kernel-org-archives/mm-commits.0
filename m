From: akpm@linux-foundation.org
Subject: - pnp-rename-pnp_register__resource-local-variables.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:03:49 -0700
Message-ID: <200806232103.m5NL3nYM016218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759537AbYFWVEm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:04:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@gmail.com, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de, mm-commits@v


The patch titled
     pnp: rename pnp_register_*_resource() local variables
has been removed from the -mm tree.  Its filename was
     pnp-rename-pnp_register__resource-local-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: rename pnp_register_*_resource() local variables
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

No functional change; just rename "data" to something more descriptive.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/resource.c |   94 +++++++++++++++++++--------------------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff -puN drivers/pnp/resource.c~pnp-rename-pnp_register__resource-local-variables drivers/pnp/resource.c
--- a/drivers/pnp/resource.c~pnp-rename-pnp_register__resource-local-variables
+++ a/drivers/pnp/resource.c
@@ -80,40 +80,40 @@ struct pnp_option *pnp_register_dependen
 int pnp_register_irq_resource(struct pnp_dev *dev, struct pnp_option *option,
 			      pnp_irq_mask_t *map, unsigned char flags)
 {
-	struct pnp_irq *data, *ptr;
+	struct pnp_irq *irq, *ptr;
 #ifdef DEBUG
 	char buf[PNP_IRQ_NR];   /* hex-encoded, so this is overkill but safe */
 #endif
 
-	data = kzalloc(sizeof(struct pnp_irq), GFP_KERNEL);
-	if (!data)
+	irq = kzalloc(sizeof(struct pnp_irq), GFP_KERNEL);
+	if (!irq)
 		return -ENOMEM;
 
-	data->map = *map;
-	data->flags = flags;
+	irq->map = *map;
+	irq->flags = flags;
 
 	ptr = option->irq;
 	while (ptr && ptr->next)
 		ptr = ptr->next;
 	if (ptr)
-		ptr->next = data;
+		ptr->next = irq;
 	else
-		option->irq = data;
+		option->irq = irq;
 
 #ifdef CONFIG_PCI
 	{
 		int i;
 
 		for (i = 0; i < 16; i++)
-			if (test_bit(i, data->map.bits))
+			if (test_bit(i, irq->map.bits))
 				pcibios_penalize_isa_irq(i, 0);
 	}
 #endif
 
 #ifdef DEBUG
-	bitmap_scnprintf(buf, sizeof(buf), data->map.bits, PNP_IRQ_NR);
+	bitmap_scnprintf(buf, sizeof(buf), irq->map.bits, PNP_IRQ_NR);
 	dev_dbg(&dev->dev, "  irq bitmask %s flags %#x\n", buf,
-		data->flags);
+		irq->flags);
 #endif
 	return 0;
 }
@@ -121,25 +121,25 @@ int pnp_register_irq_resource(struct pnp
 int pnp_register_dma_resource(struct pnp_dev *dev, struct pnp_option *option,
 			      unsigned char map, unsigned char flags)
 {
-	struct pnp_dma *data, *ptr;
+	struct pnp_dma *dma, *ptr;
 
-	data = kzalloc(sizeof(struct pnp_dma), GFP_KERNEL);
-	if (!data)
+	dma = kzalloc(sizeof(struct pnp_dma), GFP_KERNEL);
+	if (!dma)
 		return -ENOMEM;
 
-	data->map = map;
-	data->flags = flags;
+	dma->map = map;
+	dma->flags = flags;
 
 	ptr = option->dma;
 	while (ptr && ptr->next)
 		ptr = ptr->next;
 	if (ptr)
-		ptr->next = data;
+		ptr->next = dma;
 	else
-		option->dma = data;
+		option->dma = dma;
 
-	dev_dbg(&dev->dev, "  dma bitmask %#x flags %#x\n", data->map,
-		data->flags);
+	dev_dbg(&dev->dev, "  dma bitmask %#x flags %#x\n", dma->map,
+		dma->flags);
 	return 0;
 }
 
@@ -148,32 +148,32 @@ int pnp_register_port_resource(struct pn
 			       resource_size_t align, resource_size_t size,
 			       unsigned char flags)
 {
-	struct pnp_port *data, *ptr;
+	struct pnp_port *port, *ptr;
 
-	data = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
-	if (!data)
+	port = kzalloc(sizeof(struct pnp_port), GFP_KERNEL);
+	if (!port)
 		return -ENOMEM;
 
-	data->min = min;
-	data->max = max;
-	data->align = align;
-	data->size = size;
-	data->flags = flags;
+	port->min = min;
+	port->max = max;
+	port->align = align;
+	port->size = size;
+	port->flags = flags;
 
 	ptr = option->port;
 	while (ptr && ptr->next)
 		ptr = ptr->next;
 	if (ptr)
-		ptr->next = data;
+		ptr->next = port;
 	else
-		option->port = data;
+		option->port = port;
 
 	dev_dbg(&dev->dev, "  io  "
 		"min %#llx max %#llx align %lld size %lld flags %#x\n",
-		(unsigned long long) data->min,
-		(unsigned long long) data->max,
-		(unsigned long long) data->align,
-		(unsigned long long) data->size, data->flags);
+		(unsigned long long) port->min,
+		(unsigned long long) port->max,
+		(unsigned long long) port->align,
+		(unsigned long long) port->size, port->flags);
 	return 0;
 }
 
@@ -182,32 +182,32 @@ int pnp_register_mem_resource(struct pnp
 			      resource_size_t align, resource_size_t size,
 			      unsigned char flags)
 {
-	struct pnp_mem *data, *ptr;
+	struct pnp_mem *mem, *ptr;
 
-	data = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
-	if (!data)
+	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
+	if (!mem)
 		return -ENOMEM;
 
-	data->min = min;
-	data->max = max;
-	data->align = align;
-	data->size = size;
-	data->flags = flags;
+	mem->min = min;
+	mem->max = max;
+	mem->align = align;
+	mem->size = size;
+	mem->flags = flags;
 
 	ptr = option->mem;
 	while (ptr && ptr->next)
 		ptr = ptr->next;
 	if (ptr)
-		ptr->next = data;
+		ptr->next = mem;
 	else
-		option->mem = data;
+		option->mem = mem;
 
 	dev_dbg(&dev->dev, "  mem "
 		"min %#llx max %#llx align %lld size %lld flags %#x\n",
-		(unsigned long long) data->min,
-		(unsigned long long) data->max,
-		(unsigned long long) data->align,
-		(unsigned long long) data->size, data->flags);
+		(unsigned long long) mem->min,
+		(unsigned long long) mem->max,
+		(unsigned long long) mem->align,
+		(unsigned long long) mem->size, mem->flags);
 	return 0;
 }
 
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
make-pnp_add_card_id-static.patch

