From: akpm@linux-foundation.org
Subject: [merged] pnpacpi-register-disabled-resources.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:56:38 -0700
Message-ID: <201107260755.p6Q7tgGS003480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753282Ab1GZH4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Witold.Szczeponik@gmx.net, abelay@mit.edu, bhelgaas@google.com, bjorn.helgaas@hp.com, hmh@hmh.eng.br, lenb@kernel.org, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pnpacpi: register disabled resources
has been removed from the -mm tree.  Its filename was
     pnpacpi-register-disabled-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnpacpi: register disabled resources
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>

When parsing PnP ACPI resource structures, it may happen that some of the
resources are disabled (in which case "the size" of the resource equals zero).
The current solution is to skip these resources completely - with the
unfortunate side effect that they are not registered despite the fact that
they exist, after all.  (The downside of this approach is that these resources
cannot be used as templates for setting the actual device's resources
because they are missing from the template.) The kernel's APM implementation
does not suffer from this problem and registers all resources regardless of
"their size".

This patch fixes a problem with (at least) the vintage IBM ThinkPad 600E
(and most likely also with the 600, 600X, and 770X which have a very
similar layout) where some of its PnP devices support options where either
an IRQ, a DMA, or an IO port is disabled.  Without this patch, the devices
can not be configured using the "/sys/bus/pnp/devices/*/resources" interface.

The manipulation of these resources is important because the 600E has very
demanding requirements.  For instance, the number of IRQs is not sufficient
to support all devices of the 600E.  Fortunately, some of the devices,
like the sound card's MPU-401 UART, can be configured to not use any IRQ,
hence freeing an IRQ for a device that requires one.  (Still, the device's
"ResourceTemplate" requires an IRQ resource descriptor which cannot be
created if the resource has not been registered in the first place.)

As an example, the dependent sets of the 600E's CSC0103 device (the MPU-401
UART) are listed, with the patch applied, as:

  Dependent: 00 - Priority preferred
    port 0x300-0x330, align 0xf, size 0x4, 16-bit address decoding
    irq <none> High-Edge
  Dependent: 01 - Priority acceptable
    port 0x300-0x330, align 0xf, size 0x4, 16-bit address decoding
    irq 5,7,2/9,10,11,15 High-Edge

(The same result is obtained when PNPBIOS is used instead of PnP ACPI.)
Without the patch, the IRQ resource in the preferred option is not listed
at all:

  Dependent: 00 - Priority preferred
    port 0x300-0x330, align 0xf, size 0x4, 16-bit address decoding
  Dependent: 01 - Priority acceptable
    port 0x300-0x330, align 0xf, size 0x4, 16-bit address decoding
    irq 5,7,2/9,10,11,15 High-Edge

And in fact, the 600E's DSDT lists the disabled IRQ as an option, as can  be
seen from the following excerpt from the DSDT:

	Name (_PRS, ResourceTemplate ()
	{
        StartDependentFn (0x00, 0x00)
        {
            IO (Decode16, 0x0300, 0x0330, 0x10, 0x04)
            IRQNoFlags () {}
        }
        StartDependentFn (0x01, 0x00)
        {
            IO (Decode16, 0x0300, 0x0330, 0x10, 0x04)
            IRQNoFlags () {5,7,9,10,11,15}
        }
        EndDependentFn ()
	})

With this patch applied, a user space program - or maybe even the kernel -
can  allocate all devices' resources optimally.  For the 600E, this means
to find optimal resources for (at least) the serial port, the parallel port,
the infrared port, the MWAVE modem, the sound card, and the MPU-401 UART.

The patch applies the idea to register disabled resources to all types of
resources, not just to IRQs, DMAs, and IO ports.  At the same time, it mimics
the behavior of the "pnp_assign_xxx" functions from "drivers/pnp/manager.c"
where resources with "no size" are considered disabled.

No regressions were observed on hardware that does not require this patch.

The patch is applied against 2.6.39.

NB: The kernel's current PnP interface does not allow for disabling individual
resources using the "/sys/bus/pnp/devices/$device/resources" file.  Assuming
this could be done, a device could be configured to use a disabled resource
using a simple series of calls:

  echo disable > /sys/bus/pnp/devices/$device/resources
  echo clear > /sys/bus/pnp/devices/$device/resources
  echo set irq disabled > /sys/bus/pnp/devices/$device/resources
  echo fill > /sys/bus/pnp/devices/$device/resources
  echo activate > /sys/bus/pnp/devices/$device/resources

This patch addresses only the parsing of PnP ACPI devices.

ChangeLog (v1 -> v2):
 - extend patch description
 - fix typo in patch itself

Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam Belay <abelay@mit.edu>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/rsparser.c |   52 ++++++++++++++++---------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff -puN drivers/pnp/pnpacpi/rsparser.c~pnpacpi-register-disabled-resources drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnpacpi-register-disabled-resources
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -509,15 +509,15 @@ static __init void pnpacpi_parse_dma_opt
 					    struct acpi_resource_dma *p)
 {
 	int i;
-	unsigned char map = 0, flags;
+	unsigned char map = 0, flags = 0;
 
 	if (p->channel_count == 0)
-		return;
+		flags |= IORESOURCE_DISABLED;
 
 	for (i = 0; i < p->channel_count; i++)
 		map |= 1 << p->channels[i];
 
-	flags = dma_flags(dev, p->type, p->bus_master, p->transfer);
+	flags |= dma_flags(dev, p->type, p->bus_master, p->transfer);
 	pnp_register_dma_resource(dev, option_flags, map, flags);
 }
 
@@ -527,17 +527,17 @@ static __init void pnpacpi_parse_irq_opt
 {
 	int i;
 	pnp_irq_mask_t map;
-	unsigned char flags;
+	unsigned char flags = 0;
 
 	if (p->interrupt_count == 0)
-		return;
+		flags |= IORESOURCE_DISABLED;
 
 	bitmap_zero(map.bits, PNP_IRQ_NR);
 	for (i = 0; i < p->interrupt_count; i++)
 		if (p->interrupts[i])
 			__set_bit(p->interrupts[i], map.bits);
 
-	flags = irq_flags(p->triggering, p->polarity, p->sharable);
+	flags |= irq_flags(p->triggering, p->polarity, p->sharable);
 	pnp_register_irq_resource(dev, option_flags, &map, flags);
 }
 
@@ -547,10 +547,10 @@ static __init void pnpacpi_parse_ext_irq
 {
 	int i;
 	pnp_irq_mask_t map;
-	unsigned char flags;
+	unsigned char flags = 0;
 
 	if (p->interrupt_count == 0)
-		return;
+		flags |= IORESOURCE_DISABLED;
 
 	bitmap_zero(map.bits, PNP_IRQ_NR);
 	for (i = 0; i < p->interrupt_count; i++) {
@@ -564,7 +564,7 @@ static __init void pnpacpi_parse_ext_irq
 		}
 	}
 
-	flags = irq_flags(p->triggering, p->polarity, p->sharable);
+	flags |= irq_flags(p->triggering, p->polarity, p->sharable);
 	pnp_register_irq_resource(dev, option_flags, &map, flags);
 }
 
@@ -575,10 +575,10 @@ static __init void pnpacpi_parse_port_op
 	unsigned char flags = 0;
 
 	if (io->address_length == 0)
-		return;
+		flags |= IORESOURCE_DISABLED;
 
 	if (io->io_decode == ACPI_DECODE_16)
-		flags = IORESOURCE_IO_16BIT_ADDR;
+		flags |= IORESOURCE_IO_16BIT_ADDR;
 	pnp_register_port_resource(dev, option_flags, io->minimum, io->maximum,
 				   io->alignment, io->address_length, flags);
 }
@@ -587,11 +587,13 @@ static __init void pnpacpi_parse_fixed_p
 					unsigned int option_flags,
 					struct acpi_resource_fixed_io *io)
 {
+	unsigned char flags = 0;
+
 	if (io->address_length == 0)
-		return;
+		flags |= IORESOURCE_DISABLED;
 
 	pnp_register_port_resource(dev, option_flags, io->address, io->address,
-				   0, io->address_length, IORESOURCE_IO_FIXED);
+				   0, io->address_length, flags | IORESOURCE_IO_FIXED);
 }
 
 static __init void pnpacpi_parse_mem24_option(struct pnp_dev *dev,
@@ -601,10 +603,10 @@ static __init void pnpacpi_parse_mem24_o
 	unsigned char flags = 0;
 
 	if (p->address_length == 0)
-		return;
+		flags |= IORESOURCE_DISABLED;
 
 	if (p->write_protect == ACPI_READ_WRITE_MEMORY)
-		flags = IORESOURCE_MEM_WRITEABLE;
+		flags |= IORESOURCE_MEM_WRITEABLE;
 	pnp_register_mem_resource(dev, option_flags, p->minimum, p->maximum,
 				  p->alignment, p->address_length, flags);
 }
@@ -616,10 +618,10 @@ static __init void pnpacpi_parse_mem32_o
 	unsigned char flags = 0;
 
 	if (p->address_length == 0)
-		return;
+		flags |= IORESOURCE_DISABLED;
 
 	if (p->write_protect == ACPI_READ_WRITE_MEMORY)
-		flags = IORESOURCE_MEM_WRITEABLE;
+		flags |= IORESOURCE_MEM_WRITEABLE;
 	pnp_register_mem_resource(dev, option_flags, p->minimum, p->maximum,
 				  p->alignment, p->address_length, flags);
 }
@@ -631,10 +633,10 @@ static __init void pnpacpi_parse_fixed_m
 	unsigned char flags = 0;
 
 	if (p->address_length == 0)
-		return;
+		flags |= IORESOURCE_DISABLED;
 
 	if (p->write_protect == ACPI_READ_WRITE_MEMORY)
-		flags = IORESOURCE_MEM_WRITEABLE;
+		flags |= IORESOURCE_MEM_WRITEABLE;
 	pnp_register_mem_resource(dev, option_flags, p->address, p->address,
 				  0, p->address_length, flags);
 }
@@ -655,18 +657,18 @@ static __init void pnpacpi_parse_address
 	}
 
 	if (p->address_length == 0)
-		return;
+		flags |= IORESOURCE_DISABLED;
 
 	if (p->resource_type == ACPI_MEMORY_RANGE) {
 		if (p->info.mem.write_protect == ACPI_READ_WRITE_MEMORY)
-			flags = IORESOURCE_MEM_WRITEABLE;
+			flags |= IORESOURCE_MEM_WRITEABLE;
 		pnp_register_mem_resource(dev, option_flags, p->minimum,
 					  p->minimum, 0, p->address_length,
 					  flags);
 	} else if (p->resource_type == ACPI_IO_RANGE)
 		pnp_register_port_resource(dev, option_flags, p->minimum,
 					   p->minimum, 0, p->address_length,
-					   IORESOURCE_IO_FIXED);
+					   flags | IORESOURCE_IO_FIXED);
 }
 
 static __init void pnpacpi_parse_ext_address_option(struct pnp_dev *dev,
@@ -677,18 +679,18 @@ static __init void pnpacpi_parse_ext_add
 	unsigned char flags = 0;
 
 	if (p->address_length == 0)
-		return;
+		flags |= IORESOURCE_DISABLED;
 
 	if (p->resource_type == ACPI_MEMORY_RANGE) {
 		if (p->info.mem.write_protect == ACPI_READ_WRITE_MEMORY)
-			flags = IORESOURCE_MEM_WRITEABLE;
+			flags |= IORESOURCE_MEM_WRITEABLE;
 		pnp_register_mem_resource(dev, option_flags, p->minimum,
 					  p->minimum, 0, p->address_length,
 					  flags);
 	} else if (p->resource_type == ACPI_IO_RANGE)
 		pnp_register_port_resource(dev, option_flags, p->minimum,
 					   p->minimum, 0, p->address_length,
-					   IORESOURCE_IO_FIXED);
+					   flags | IORESOURCE_IO_FIXED);
 }
 
 struct acpipnp_parse_option_s {
_

Patches currently in -mm which might be from Witold.Szczeponik@gmx.net are

origin.patch

