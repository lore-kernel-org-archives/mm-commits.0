From: akpm@linux-foundation.org
Subject: + pnp-increase-i-o-port-memory-option-address-sizes.patch added to -mm tree
Date: Wed, 04 Jun 2008 22:57:17 -0700
Message-ID: <200806050557.m555vHYO028351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752450AbYFEF6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 01:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@gmail.com, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de


The patch titled
     pnp: increase I/O port & memory option address sizes
has been added to the -mm tree.  Its filename is
     pnp-increase-i-o-port-memory-option-address-sizes.patch

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
Subject: pnp: increase I/O port & memory option address sizes
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

ACPI Address Space Descriptors can be up to 64 bits wide.  We should keep
track of the whole thing when parsing resource options, so this patch
changes PNP port and mem option fields from "unsigned short" and "unsigned
int" to "resource_size_t".

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

 drivers/pnp/base.h      |   16 ++++++++--------
 drivers/pnp/interface.c |   17 +++++++++++------
 drivers/pnp/resource.c  |   14 ++++++++++----
 3 files changed, 29 insertions(+), 18 deletions(-)

diff -puN drivers/pnp/base.h~pnp-increase-i-o-port-memory-option-address-sizes drivers/pnp/base.h
--- a/drivers/pnp/base.h~pnp-increase-i-o-port-memory-option-address-sizes
+++ a/drivers/pnp/base.h
@@ -20,10 +20,10 @@ int pnp_add_card_device(struct pnp_card 
 void pnp_remove_card_device(struct pnp_dev *dev);
 
 struct pnp_port {
-	unsigned short min;	/* min base number */
-	unsigned short max;	/* max base number */
-	unsigned char align;	/* align boundary */
-	unsigned char size;	/* size of range */
+	resource_size_t min;	/* min base number */
+	resource_size_t max;	/* max base number */
+	resource_size_t align;	/* align boundary */
+	resource_size_t size;	/* size of range */
 	unsigned char flags;	/* port flags */
 	unsigned char pad;	/* pad */
 	struct pnp_port *next;	/* next port */
@@ -46,10 +46,10 @@ struct pnp_dma {
 };
 
 struct pnp_mem {
-	unsigned int min;	/* min base number */
-	unsigned int max;	/* max base number */
-	unsigned int align;	/* align boundary */
-	unsigned int size;	/* size of range */
+	resource_size_t min;	/* min base number */
+	resource_size_t max;	/* max base number */
+	resource_size_t align;	/* align boundary */
+	resource_size_t size;	/* size of range */
 	unsigned char flags;	/* memory flags */
 	unsigned char pad;	/* pad */
 	struct pnp_mem *next;	/* next memory resource */
diff -puN drivers/pnp/interface.c~pnp-increase-i-o-port-memory-option-address-sizes drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~pnp-increase-i-o-port-memory-option-address-sizes
+++ a/drivers/pnp/interface.c
@@ -53,10 +53,12 @@ static int pnp_printf(pnp_info_buffer_t 
 static void pnp_print_port(pnp_info_buffer_t * buffer, char *space,
 			   struct pnp_port *port)
 {
-	pnp_printf(buffer,
-		   "%sport 0x%x-0x%x, align 0x%x, size 0x%x, %i-bit address decoding\n",
-		   space, port->min, port->max,
-		   port->align ? (port->align - 1) : 0, port->size,
+	pnp_printf(buffer, "%sport %#llx-%#llx, align %#llx, size %#llx, "
+		   "%i-bit address decoding\n", space,
+		   (unsigned long long) port->min,
+		   (unsigned long long) port->max,
+		   port->align ? ((unsigned long long) port->align - 1) : 0,
+		   (unsigned long long) port->size,
 		   port->flags & IORESOURCE_IO_16BIT_ADDR ? 16 : 10);
 }
 
@@ -148,8 +150,11 @@ static void pnp_print_mem(pnp_info_buffe
 {
 	char *s;
 
-	pnp_printf(buffer, "%sMemory 0x%x-0x%x, align 0x%x, size 0x%x",
-		   space, mem->min, mem->max, mem->align, mem->size);
+	pnp_printf(buffer, "%sMemory %#llx-%#llx, align %#llx, size %#llx",
+		   space, (unsigned long long) mem->min,
+		   (unsigned long long) mem->max,
+		   (unsigned long long) mem->align,
+		   (unsigned long long) mem->size);
 	if (mem->flags & IORESOURCE_MEM_WRITEABLE)
 		pnp_printf(buffer, ", writeable");
 	if (mem->flags & IORESOURCE_MEM_CACHEABLE)
diff -puN drivers/pnp/resource.c~pnp-increase-i-o-port-memory-option-address-sizes drivers/pnp/resource.c
--- a/drivers/pnp/resource.c~pnp-increase-i-o-port-memory-option-address-sizes
+++ a/drivers/pnp/resource.c
@@ -143,8 +143,11 @@ int pnp_register_port_resource(struct pn
 		option->port = data;
 
 	dev_dbg(&dev->dev, "  io  "
-		"min %#x max %#x align %d size %d flags %#x\n",
-		data->min, data->max, data->align, data->size, data->flags);
+		"min %#llx max %#llx align %lld size %lld flags %#x\n",
+		(unsigned long long) data->min,
+		(unsigned long long) data->max,
+		(unsigned long long) data->align,
+		(unsigned long long) data->size, data->flags);
 	return 0;
 }
 
@@ -162,8 +165,11 @@ int pnp_register_mem_resource(struct pnp
 		option->mem = data;
 
 	dev_dbg(&dev->dev, "  mem "
-		"min %#x max %#x align %d size %d flags %#x\n",
-		data->min, data->max, data->align, data->size, data->flags);
+		"min %#llx max %#llx align %lld size %lld flags %#x\n",
+		(unsigned long long) data->min,
+		(unsigned long long) data->max,
+		(unsigned long long) data->align,
+		(unsigned long long) data->size, data->flags);
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

