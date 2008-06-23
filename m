From: akpm@linux-foundation.org
Subject: - not-for-merging-pnp-changes-suspend-oops.patch removed from -mm tree
Date: Mon, 23 Jun 2008 13:35:29 -0700
Message-ID: <200806232035.m5NKZTgu014893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754001AbYFWUfi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 16:35:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     (not for merging) pnp changes -> suspend oops [Was: 2.6.26-rc5-mm2]
has been removed from the -mm tree.  Its filename was
     not-for-merging-pnp-changes-suspend-oops.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: (not for merging) pnp changes -> suspend oops [Was: 2.6.26-rc5-mm2]
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

On Wednesday 11 June 2008 12:08:53 pm Jiri Slaby wrote:
> On 06/10/2008 07:31 AM, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc5/2.6.26-rc5-mm2/
>
> I face problems after some of the pnp changes. If this is not known, I may
> bisect it, it's 100% reproducible. I have no real logs, It panics prior to
> network is woken up to see something on netconsole, I just captured a function
> name and an offset of place where it oopses.
>
> pnpacpi_encode_resources, ACPI_RESOURCE_TYPE_DMA case, pnp_get_resource(dev,
> IORESOURCE_DMA, dma) returns NULL, which is dereferenced at pnpacpi_encode_dma
> at p->flags.
>
> It happens on resume after mem > /sys/power/state.

Thanks for the report, I hadn't heard about this.

We used to always have a resource from the static table to encode
(assuming the table was big enough), even if that resource was
disabled or unassigned.  But now we don't keep those around, so
we can end up with null pointers like you're seeing.

Before you go to all the trouble of bisecting it, can you turn on
CONFIG_PNP_DEBUG and try the following debug patch?  I think this
will prevent the oops, but it's just papering over the real problem,
so please capture the complete dmesg log.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/rsparser.c |   40 +++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff -puN drivers/pnp/pnpacpi/rsparser.c~not-for-merging-pnp-changes-suspend-oops drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~not-for-merging-pnp-changes-suspend-oops
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -749,6 +749,11 @@ static void pnpacpi_encode_irq(struct pn
 	struct acpi_resource_irq *irq = &resource->data.irq;
 	int triggering, polarity, shareable;
 
+	if (!p) {
+		dev_err(&dev->dev, "  no irq resource to encode!\n");
+		return;
+	}
+
 	decode_irq_flags(dev, p->flags, &triggering, &polarity, &shareable);
 	irq->triggering = triggering;
 	irq->polarity = polarity;
@@ -771,6 +776,11 @@ static void pnpacpi_encode_ext_irq(struc
 	struct acpi_resource_extended_irq *extended_irq = &resource->data.extended_irq;
 	int triggering, polarity, shareable;
 
+	if (!p) {
+		dev_err(&dev->dev, "  no extended irq resource to encode!\n");
+		return;
+	}
+
 	decode_irq_flags(dev, p->flags, &triggering, &polarity, &shareable);
 	extended_irq->producer_consumer = ACPI_CONSUMER;
 	extended_irq->triggering = triggering;
@@ -791,6 +801,11 @@ static void pnpacpi_encode_dma(struct pn
 {
 	struct acpi_resource_dma *dma = &resource->data.dma;
 
+	if (!p) {
+		dev_err(&dev->dev, "  no dma resource to encode!\n");
+		return;
+	}
+
 	/* Note: pnp_assign_dma will copy pnp_dma->flags into p->flags */
 	switch (p->flags & IORESOURCE_DMA_SPEED_MASK) {
 	case IORESOURCE_DMA_TYPEA:
@@ -832,6 +847,11 @@ static void pnpacpi_encode_io(struct pnp
 {
 	struct acpi_resource_io *io = &resource->data.io;
 
+	if (!p) {
+		dev_err(&dev->dev, "  no io resource to encode!\n");
+		return;
+	}
+
 	/* Note: pnp_assign_port will copy pnp_port->flags into p->flags */
 	io->io_decode = (p->flags & IORESOURCE_IO_16BIT_ADDR) ?
 	    ACPI_DECODE_16 : ACPI_DECODE_10;
@@ -851,6 +871,11 @@ static void pnpacpi_encode_fixed_io(stru
 {
 	struct acpi_resource_fixed_io *fixed_io = &resource->data.fixed_io;
 
+	if (!p) {
+		dev_err(&dev->dev, "  no fixed io resource to encode!\n");
+		return;
+	}
+
 	fixed_io->address = p->start;
 	fixed_io->address_length = p->end - p->start + 1;
 
@@ -864,6 +889,11 @@ static void pnpacpi_encode_mem24(struct 
 {
 	struct acpi_resource_memory24 *memory24 = &resource->data.memory24;
 
+	if (!p) {
+		dev_err(&dev->dev, "  no mem24 resource to encode!\n");
+		return;
+	}
+
 	/* Note: pnp_assign_mem will copy pnp_mem->flags into p->flags */
 	memory24->write_protect =
 	    (p->flags & IORESOURCE_MEM_WRITEABLE) ?
@@ -884,6 +914,11 @@ static void pnpacpi_encode_mem32(struct 
 {
 	struct acpi_resource_memory32 *memory32 = &resource->data.memory32;
 
+	if (!p) {
+		dev_err(&dev->dev, "  no mem32 resource to encode!\n");
+		return;
+	}
+
 	memory32->write_protect =
 	    (p->flags & IORESOURCE_MEM_WRITEABLE) ?
 	    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
@@ -903,6 +938,11 @@ static void pnpacpi_encode_fixed_mem32(s
 {
 	struct acpi_resource_fixed_memory32 *fixed_memory32 = &resource->data.fixed_memory32;
 
+	if (!p) {
+		dev_err(&dev->dev, "  no fixed_mem32 resource to encode!\n");
+		return;
+	}
+
 	fixed_memory32->write_protect =
 	    (p->flags & IORESOURCE_MEM_WRITEABLE) ?
 	    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
make-pnp_add_card_id-static.patch

