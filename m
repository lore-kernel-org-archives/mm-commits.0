From: akpm@linux-foundation.org
Subject: + serial-define-fixed_port-flag-for-serial_core.patch added to -mm tree
Date: Wed, 21 Feb 2007 14:31:36 -0800
Message-ID: <200702212231.l1LMVadL028494@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53178 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423209AbXBUWcD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 17:32:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@gibson.dropbear.id.au, dwg@au1.ibm.com, rmk@arm.linux.org.uk


The patch titled
     serial: define FIXED_PORT flag for serial_core
has been added to the -mm tree.  Its filename is
     serial-define-fixed_port-flag-for-serial_core.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: define FIXED_PORT flag for serial_core
From: David Gibson <david@gibson.dropbear.id.au>

At present, the serial core always allows setserial in userspace to change the
port address, irq and base clock of any serial port.  That makes sense for
legacy ISA ports, but not for (say) embedded ns16550 compatible serial ports
at peculiar addresses.  In these cases, the kernel code configuring the ports
must know exactly where they are, and their clocking arrangements (which can
be unusual on embedded boards).  It doesn't make sense for userspace to change
these settings.

Therefore, this patch defines a UPF_FIXED_PORT flag for the uart_port
structure.  If this flag is set when the serial port is configured, any
attempts to alter the port's type, io address, irq or base clock with
setserial are ignored.

In addition this patch uses the new flag for on-chip serial ports probed in
arch/powerpc/kernel/legacy_serial.c, and for other hard-wired serial ports
probed by drivers/serial/of_serial.c.

Signed-off-by: David Gibson <dwg@au1.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/legacy_serial.c |    3 ++-
 drivers/serial/of_serial.c          |    3 ++-
 drivers/serial/serial_core.c        |   22 +++++++++++++---------
 include/linux/serial_core.h         |    1 +
 4 files changed, 18 insertions(+), 11 deletions(-)

diff -puN arch/powerpc/kernel/legacy_serial.c~serial-define-fixed_port-flag-for-serial_core arch/powerpc/kernel/legacy_serial.c
--- a/arch/powerpc/kernel/legacy_serial.c~serial-define-fixed_port-flag-for-serial_core
+++ a/arch/powerpc/kernel/legacy_serial.c
@@ -115,7 +115,8 @@ static int __init add_legacy_soc_port(st
 {
 	u64 addr;
 	const u32 *addrp;
-	upf_t flags = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_SHARE_IRQ;
+	upf_t flags = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_SHARE_IRQ
+		| UPF_FIXED_PORT;
 	struct device_node *tsi = of_get_parent(np);
 
 	/* We only support ports that have a clock frequency properly
diff -puN drivers/serial/of_serial.c~serial-define-fixed_port-flag-for-serial_core drivers/serial/of_serial.c
--- a/drivers/serial/of_serial.c~serial-define-fixed_port-flag-for-serial_core
+++ a/drivers/serial/of_serial.c
@@ -48,7 +48,8 @@ static int __devinit of_platform_serial_
 	port->iotype = UPIO_MEM;
 	port->type = type;
 	port->uartclk = *clk;
-	port->flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_IOREMAP;
+	port->flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_IOREMAP
+		| UPF_FIXED_PORT;
 	port->dev = &ofdev->dev;
 	port->custom_divisor = *clk / (16 * (*spd));
 
diff -puN drivers/serial/serial_core.c~serial-define-fixed_port-flag-for-serial_core drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-define-fixed_port-flag-for-serial_core
+++ a/drivers/serial/serial_core.c
@@ -672,19 +672,21 @@ static int uart_set_info(struct uart_sta
 	 */
 	mutex_lock(&state->mutex);
 
-	change_irq  = new_serial.irq != port->irq;
+	change_irq  = !(port->flags & UPF_FIXED_PORT)
+		&& new_serial.irq != port->irq;
 
 	/*
 	 * Since changing the 'type' of the port changes its resource
 	 * allocations, we should treat type changes the same as
 	 * IO port changes.
 	 */
-	change_port = new_port != port->iobase ||
-		      (unsigned long)new_serial.iomem_base != port->mapbase ||
-		      new_serial.hub6 != port->hub6 ||
-		      new_serial.io_type != port->iotype ||
-		      new_serial.iomem_reg_shift != port->regshift ||
-		      new_serial.type != port->type;
+	change_port = !(port->flags & UPF_FIXED_PORT)
+		&& (new_port != port->iobase ||
+		    (unsigned long)new_serial.iomem_base != port->mapbase ||
+		    new_serial.hub6 != port->hub6 ||
+		    new_serial.io_type != port->iotype ||
+		    new_serial.iomem_reg_shift != port->regshift ||
+		    new_serial.type != port->type);
 
 	old_flags = port->flags;
 	new_flags = new_serial.flags;
@@ -796,8 +798,10 @@ static int uart_set_info(struct uart_sta
 		}
 	}
 
-	port->irq              = new_serial.irq;
-	port->uartclk          = new_serial.baud_base * 16;
+	if (change_irq)
+		port->irq      = new_serial.irq;
+	if (!(port->flags & UPF_FIXED_PORT))
+		port->uartclk  = new_serial.baud_base * 16;
 	port->flags            = (port->flags & ~UPF_CHANGE_MASK) |
 				 (new_flags & UPF_CHANGE_MASK);
 	port->custom_divisor   = new_serial.custom_divisor;
diff -puN include/linux/serial_core.h~serial-define-fixed_port-flag-for-serial_core include/linux/serial_core.h
--- a/include/linux/serial_core.h~serial-define-fixed_port-flag-for-serial_core
+++ a/include/linux/serial_core.h
@@ -263,6 +263,7 @@ struct uart_port {
 #define UPF_CONS_FLOW		((__force upf_t) (1 << 23))
 #define UPF_SHARE_IRQ		((__force upf_t) (1 << 24))
 #define UPF_BOOT_AUTOCONF	((__force upf_t) (1 << 28))
+#define UPF_FIXED_PORT		((__force upf_t) (1 << 29))
 #define UPF_DEAD		((__force upf_t) (1 << 30))
 #define UPF_IOREMAP		((__force upf_t) (1 << 31))
 
_

Patches currently in -mm which might be from david@gibson.dropbear.id.au are

serial-define-fixed_port-flag-for-serial_core.patch
serial-use-resource_size_t-for-serial-port-io-addresses.patch
