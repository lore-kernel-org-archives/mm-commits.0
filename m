From: akpm@linux-foundation.org
Subject: - pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:03:19 -0700
Message-ID: <200806232103.m5NL3Jv5016151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758049AbYFWVD7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:03:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@gmail.com, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de, mm-commits@v


The patch titled
     pnp: define PNP-specific IORESOURCE_IO_* flags alongside IRQ, DMA, MEM
has been removed from the -mm tree.  Its filename was
     pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: define PNP-specific IORESOURCE_IO_* flags alongside IRQ, DMA, MEM
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

PNP previously defined PNP_PORT_FLAG_16BITADDR and PNP_PORT_FLAG_FIXED in
a private header file, but put those flags in struct resource.flags
fields.  Better to make them IORESOURCE_IO_* flags like the existing IRQ,
DMA, and MEM flags.

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

 drivers/pnp/interface.c        |    2 +-
 drivers/pnp/isapnp/core.c      |    4 ++--
 drivers/pnp/pnpacpi/rsparser.c |   10 +++++-----
 drivers/pnp/pnpbios/rsparser.c |    4 ++--
 include/linux/ioport.h         |    4 ++++
 include/linux/pnp.h            |    3 ---
 6 files changed, 14 insertions(+), 13 deletions(-)

diff -puN drivers/pnp/interface.c~pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem
+++ a/drivers/pnp/interface.c
@@ -57,7 +57,7 @@ static void pnp_print_port(pnp_info_buff
 		   "%sport 0x%x-0x%x, align 0x%x, size 0x%x, %i-bit address decoding\n",
 		   space, port->min, port->max,
 		   port->align ? (port->align - 1) : 0, port->size,
-		   port->flags & PNP_PORT_FLAG_16BITADDR ? 16 : 10);
+		   port->flags & IORESOURCE_IO_16BIT_ADDR ? 16 : 10);
 }
 
 static void pnp_print_irq(pnp_info_buffer_t * buffer, char *space,
diff -puN drivers/pnp/isapnp/core.c~pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem drivers/pnp/isapnp/core.c
--- a/drivers/pnp/isapnp/core.c~pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem
+++ a/drivers/pnp/isapnp/core.c
@@ -486,7 +486,7 @@ static void __init isapnp_parse_port_res
 	port->max = (tmp[4] << 8) | tmp[3];
 	port->align = tmp[5];
 	port->size = tmp[6];
-	port->flags = tmp[0] ? PNP_PORT_FLAG_16BITADDR : 0;
+	port->flags = tmp[0] ? IORESOURCE_IO_16BIT_ADDR : 0;
 	pnp_register_port_resource(dev, option, port);
 }
 
@@ -507,7 +507,7 @@ static void __init isapnp_parse_fixed_po
 	port->min = port->max = (tmp[1] << 8) | tmp[0];
 	port->size = tmp[2];
 	port->align = 0;
-	port->flags = PNP_PORT_FLAG_FIXED;
+	port->flags = IORESOURCE_IO_FIXED;
 	pnp_register_port_resource(dev, option, port);
 }
 
diff -puN drivers/pnp/pnpacpi/rsparser.c~pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -178,7 +178,7 @@ static void pnpacpi_parse_allocated_iore
 	u64 end = start + len - 1;
 
 	if (io_decode == ACPI_DECODE_16)
-		flags |= PNP_PORT_FLAG_16BITADDR;
+		flags |= IORESOURCE_IO_16BIT_ADDR;
 	if (len == 0 || end >= 0x10003)
 		flags |= IORESOURCE_DISABLED;
 
@@ -451,7 +451,7 @@ static __init void pnpacpi_parse_port_op
 	port->align = io->alignment;
 	port->size = io->address_length;
 	port->flags = ACPI_DECODE_16 == io->io_decode ?
-	    PNP_PORT_FLAG_16BITADDR : 0;
+	    IORESOURCE_IO_16BIT_ADDR : 0;
 	pnp_register_port_resource(dev, option, port);
 }
 
@@ -469,7 +469,7 @@ static __init void pnpacpi_parse_fixed_p
 	port->min = port->max = io->address;
 	port->size = io->address_length;
 	port->align = 0;
-	port->flags = PNP_PORT_FLAG_FIXED;
+	port->flags = IORESOURCE_IO_FIXED;
 	pnp_register_port_resource(dev, option, port);
 }
 
@@ -575,7 +575,7 @@ static __init void pnpacpi_parse_address
 		port->min = port->max = p->minimum;
 		port->size = p->address_length;
 		port->align = 0;
-		port->flags = PNP_PORT_FLAG_FIXED;
+		port->flags = IORESOURCE_IO_FIXED;
 		pnp_register_port_resource(dev, option, port);
 	}
 }
@@ -890,7 +890,7 @@ static void pnpacpi_encode_io(struct pnp
 	struct acpi_resource_io *io = &resource->data.io;
 
 	/* Note: pnp_assign_port will copy pnp_port->flags into p->flags */
-	io->io_decode = (p->flags & PNP_PORT_FLAG_16BITADDR) ?
+	io->io_decode = (p->flags & IORESOURCE_IO_16BIT_ADDR) ?
 	    ACPI_DECODE_16 : ACPI_DECODE_10;
 	io->minimum = p->start;
 	io->maximum = p->end;
diff -puN drivers/pnp/pnpbios/rsparser.c~pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem drivers/pnp/pnpbios/rsparser.c
--- a/drivers/pnp/pnpbios/rsparser.c~pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem
+++ a/drivers/pnp/pnpbios/rsparser.c
@@ -310,7 +310,7 @@ static __init void pnpbios_parse_port_op
 	port->max = (p[5] << 8) | p[4];
 	port->align = p[6];
 	port->size = p[7];
-	port->flags = p[1] ? PNP_PORT_FLAG_16BITADDR : 0;
+	port->flags = p[1] ? IORESOURCE_IO_16BIT_ADDR : 0;
 	pnp_register_port_resource(dev, option, port);
 }
 
@@ -326,7 +326,7 @@ static __init void pnpbios_parse_fixed_p
 	port->min = port->max = (p[2] << 8) | p[1];
 	port->size = p[3];
 	port->align = 0;
-	port->flags = PNP_PORT_FLAG_FIXED;
+	port->flags = IORESOURCE_IO_FIXED;
 	pnp_register_port_resource(dev, option, port);
 }
 
diff -puN include/linux/ioport.h~pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem include/linux/ioport.h
--- a/include/linux/ioport.h~pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem
+++ a/include/linux/ioport.h
@@ -88,6 +88,10 @@ struct resource_list {
 #define IORESOURCE_MEM_SHADOWABLE	(1<<5)	/* dup: IORESOURCE_SHADOWABLE */
 #define IORESOURCE_MEM_EXPANSIONROM	(1<<6)
 
+/* PnP I/O specific bits (IORESOURCE_BITS) */
+#define IORESOURCE_IO_16BIT_ADDR	(1<<0)
+#define IORESOURCE_IO_FIXED		(1<<1)
+
 /* PCI ROM control bits (IORESOURCE_BITS) */
 #define IORESOURCE_ROM_ENABLE		(1<<0)	/* ROM is enabled, same as PCI_ROM_ADDRESS_ENABLE */
 #define IORESOURCE_ROM_SHADOW		(1<<1)	/* ROM is copy at C000:0 */
diff -puN include/linux/pnp.h~pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem include/linux/pnp.h
--- a/include/linux/pnp.h~pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem
+++ a/include/linux/pnp.h
@@ -175,9 +175,6 @@ static inline int pnp_dma_valid(struct p
 }
 
 
-#define PNP_PORT_FLAG_16BITADDR	(1<<0)
-#define PNP_PORT_FLAG_FIXED	(1<<1)
