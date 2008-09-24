From: akpm@linux-foundation.org
Subject: + serial-fix-device-name-reporting-when-minor-space-is-shared-between-drivers.patch added to -mm tree
Date: Wed, 24 Sep 2008 01:06:52 -0700
Message-ID: <200809240806.m8O86qRa017027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205AbYIXIHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Sep 2008 04:07:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davem@davemloft.net, alan@lxorguk.ukuu.org.uk


The patch titled
     serial: fix device name reporting when minor space is shared between drivers
has been added to the -mm tree.  Its filename is
     serial-fix-device-name-reporting-when-minor-space-is-shared-between-drivers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: fix device name reporting when minor space is shared between drivers
From: David S. Miller <davem@davemloft.net>

The multiple drivers share the minor space occupied by a particular major
number, the actual index within the device name's space is indicated by
the tty_driver->name_base + uart_port->line

Another usable formula is (uart_driver->minor - MINOR_BASE) + port->line

Use those to print the device names properly in such situations in
serial_core.c and 8250.c

Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c        |   22 +++++++++++++++-------
 drivers/serial/serial_core.c |    7 +++++--
 2 files changed, 20 insertions(+), 9 deletions(-)

diff -puN drivers/serial/8250.c~serial-fix-device-name-reporting-when-minor-space-is-shared-between-drivers drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-fix-device-name-reporting-when-minor-space-is-shared-between-drivers
+++ a/drivers/serial/8250.c
@@ -57,6 +57,13 @@ static unsigned int share_irqs = SERIAL8
 
 static unsigned int nr_uarts = CONFIG_SERIAL_8250_RUNTIME_UARTS;
 
+static struct uart_driver serial8250_reg;
+
+static int serial_index(struct uart_port *port)
+{
+	return (serial8250_reg.minor - 64) + port->line;
+}
+
 /*
  * Debugging.
  */
@@ -1001,7 +1008,7 @@ static void autoconfig(struct uart_8250_
 		return;
 
 	DEBUG_AUTOCONF("ttyS%d: autoconf (0x%04x, 0x%p): ",
-			up->port.line, up->port.iobase, up->port.membase);
+		       serial_index(&up->port), up->port.iobase, up->port.membase);
 
 	/*
 	 * We really do need global IRQs disabled here - we're going to
@@ -1136,8 +1143,8 @@ static void autoconfig(struct uart_8250_
 	if (up->capabilities != uart_config[up->port.type].flags) {
 		printk(KERN_WARNING
 		       "ttyS%d: detected caps %08x should be %08x\n",
-			up->port.line, up->capabilities,
-			uart_config[up->port.type].flags);
+		       serial_index(&up->port), up->capabilities,
+		       uart_config[up->port.type].flags);
 	}
 
 	up->port.fifosize = uart_config[up->port.type].fifo_size;
@@ -1902,7 +1909,8 @@ static int serial8250_startup(struct uar
 	 */
 	if (!(up->port.flags & UPF_BUGGY_UART) &&
 	    (serial_inp(up, UART_LSR) == 0xff)) {
-		printk("ttyS%d: LSR safety check engaged!\n", up->port.line);
+		printk("ttyS%d: LSR safety check engaged!\n",
+		       serial_index(&up->port));
 		return -ENODEV;
 	}
 
@@ -1957,7 +1965,8 @@ static int serial8250_startup(struct uar
 		 */
 		if (!(iir1 & UART_IIR_NO_INT) && (iir & UART_IIR_NO_INT)) {
 			up->bugs |= UART_BUG_THRE;
-			pr_debug("ttyS%d - using backup timer\n", port->line);
+			pr_debug("ttyS%d - using backup timer\n",
+				 serial_index(port));
 		}
 	}
 
@@ -2017,7 +2026,7 @@ static int serial8250_startup(struct uar
 		if (!(up->bugs & UART_BUG_TXEN)) {
 			up->bugs |= UART_BUG_TXEN;
 			pr_debug("ttyS%d - enabling bad tx status workarounds\n",
-				 port->line);
+				 serial_index(port));
 		}
 	} else {
 		up->bugs &= ~UART_BUG_TXEN;
@@ -2685,7 +2694,6 @@ static int serial8250_console_early_setu
 	return serial8250_find_port_for_earlycon();
 }
 
-static struct uart_driver serial8250_reg;
 static struct console serial8250_console = {
 	.name		= "ttyS",
 	.write		= serial8250_console_write,
diff -puN drivers/serial/serial_core.c~serial-fix-device-name-reporting-when-minor-space-is-shared-between-drivers drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-fix-device-name-reporting-when-minor-space-is-shared-between-drivers
+++ a/drivers/serial/serial_core.c
@@ -2051,7 +2051,8 @@ int uart_suspend_port(struct uart_driver
 					"transmitter\n",
 			       port->dev ? port->dev->bus_id : "",
 			       port->dev ? ": " : "",
-			       drv->dev_name, port->line);
+			       drv->dev_name,
+			       drv->tty_driver->name_base + port->line);
 
 		ops->shutdown(port);
 	}
@@ -2176,7 +2177,9 @@ uart_report_port(struct uart_driver *drv
 	printk(KERN_INFO "%s%s%s%d at %s (irq = %d) is a %s\n",
 	       port->dev ? port->dev->bus_id : "",
 	       port->dev ? ": " : "",
-	       drv->dev_name, port->line, address, port->irq, uart_type(port));
+	       drv->dev_name,
+	       drv->tty_driver->name_base + port->line,
+	       address, port->irq, uart_type(port));
 }
 
 static void
_

Patches currently in -mm which might be from davem@davemloft.net are

sys_paccept-disable-paccept-until-api-design-is-resolved.patch
linux-next.patch
git-net.patch
drivers-isdn-capi-kcapic-adjust-error-handling-code-involving-capi_ctr_put.patch
sunrpc-do-not-pin-sunrpc-module-in-the-memory.patch
drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32.patch
drivers-net-mlx4-allocc-needs-mmh.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
compat-generic-compat-get-settimeofday.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
sparc64-use-iommu_num_pages-function-in-iommu-code.patch
serial-make-uart_ports-ioport-unsigned-long-fix.patch
serial-allow-8250-to-be-used-on-sparc.patch
serial-fix-device-name-reporting-when-minor-space-is-shared-between-drivers.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
radeonfb-misc-cleanup-of-engine-and-dst-cache-handling.patch
radeonfb-accelerate-imageblit-and-other-improvements.patch
sysctl-simplify-strategy.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

