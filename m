From: akpm@linux-foundation.org
Subject: + pnp-rename-pnp_register__resource-local-variables.patch added to -mm tree
Date: Wed, 04 Jun 2008 22:57:31 -0700
Message-ID: <200806050557.m555vVFL028375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753127AbYFEGHk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 02:07:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@gmail.com, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de


The patch titled
     pnp: rename pnp_register_*_resource() local variables
has been added to the -mm tree.  Its filename is
     pnp-rename-pnp_register__resource-local-variables.patch

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

pnp-mark-resources-that-conflict-with-pci-devices-disabled.patch
acpi_pm_device_sleep_state-cleanup.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
provide-rtc_cmos-platform-device-take-2.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
pnpacpi-fix-irq-flag-decoding.patch
pnpacpi-fix-irq-flag-decoding-comment-fix.patch
pnpacpi-fix-shareable-irq-encode-decode.patch
pnpacpi-use-_crs-irq-descriptor-length-for-_srs-v2.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-make-pnp_portmemetc_start-et-al-work-for-invalid-resources.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources-merge-fix.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way.patch
pnp-whitespace-coding-style-fixes.patch
pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem.patch
pnp-make-resource-option-structures-private-to-pnp-subsystem.patch
pnp-introduce-pnp_irq_mask_t-typedef.patch
pnp-increase-i-o-port-memory-option-address-sizes.patch
pnp-improve-resource-assignment-debug.patch
pnp-in-debug-resource-dump-make-empty-list-obvious.patch
pnp-make-resource-assignment-functions-return-0-success-or-ebusy-failure.patch
pnp-remove-redundant-pnp_can_configure-check.patch
pnp-centralize-resource-option-allocations.patch
pnpacpi-ignore-_prs-interrupt-numbers-larger-than-pnp_irq_nr.patch
pnp-rename-pnp_register__resource-local-variables.patch
pnp-support-optional-irq-resources.patch
pnp-remove-extra-0x100-bit-from-option-priority.patch
isapnp-handle-independent-options-following-dependent-ones.patch
pnp-convert-resource-options-to-single-linked-list.patch
make-pnp_add_card_id-static.patch

