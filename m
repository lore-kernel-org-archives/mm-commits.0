From: akpm@linux-foundation.org
Subject: - serial-convert-early_uart-to-earlycon-for-8250.patch removed from -mm tree
Date: Wed, 30 May 2007 20:16:08 -0700
Message-ID: <200705310316.l4V3G7nd011278@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756163AbXEaDQT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 23:16:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, bjorn.helgaas@hp.com, hpa@zytor.com, kraxel@suse.de, rmk@arm.linux.org.uk, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     serial: convert early_uart to earlycon for 8250
has been removed from the -mm tree.  Its filename was
     serial-convert-early_uart-to-earlycon-for-8250.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: serial: convert early_uart to earlycon for 8250
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Beacuse SERIAL_PORT_DFNS is removed from include/asm-i386/serial.h and
include/asm-x86_64/serial.h.  the serial8250_ports need to be probed late in
serial initializing stage.  the console_init=>serial8250_console_init=>
register_console=>serial8250_console_setup will return -ENDEV, and console
ttyS0 can not be enabled at that time.  need to wait till uart_add_one_port in
drivers/serial/serial_core.c to call register_console to get console ttyS0. 
that is too late.

Make early_uart to use early_param, so uart console can be used earlier.  Make
it to be bootconsole with CON_BOOT flag, so can use console handover feature. 
and it will switch to corresponding normal serial console automatically.

new command line will be:
	console=uart8250,io,0x3f8,9600n8
	console=uart8250,mmio,0xff5e0000,115200n8
or
	earlycon=uart8250,io,0x3f8,9600n8
	earlycon=uart8250,mmio,0xff5e0000,115200n8

it will print in very early stage:
	Early serial console at I/O port 0x3f8 (options '9600n8')
	console [uart0] enabled
later for console it will print:
	console handover: boot [uart0] -> real [ttyS0]

Signed-off-by: <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Gerd Hoffmann <kraxel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   11 ++
 arch/ia64/kernel/setup.c            |    4 -
 drivers/serial/8250.c               |   28 +------
 drivers/serial/8250_early.c         |  103 ++++++++++----------------
 drivers/serial/Kconfig              |   10 ++
 include/asm-i386/fixmap.h           |    2 
 include/asm-i386/io.h               |   13 +++
 include/asm-ia64/io.h               |    4 +
 include/asm-x86_64/fixmap.h         |    4 -
 include/asm-x86_64/io.h             |   13 +++
 include/linux/console.h             |    2 
 include/linux/serial.h              |    6 -
 include/linux/serial_8250.h         |    3 
 init/main.c                         |    5 +
 kernel/printk.c                     |   22 +++++
 15 files changed, 132 insertions(+), 98 deletions(-)

diff -puN Documentation/kernel-parameters.txt~serial-convert-early_uart-to-earlycon-for-8250 Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~serial-convert-early_uart-to-earlycon-for-8250
+++ a/Documentation/kernel-parameters.txt
@@ -464,13 +464,20 @@ and is between 256 and 4096 characters. 
 			Documentation/networking/netconsole.txt for an
 			alternative.
 
-		uart,io,<addr>[,options]
-		uart,mmio,<addr>[,options]
+		uart8250,io,<addr>[,options]
+		uart8250,mmio,<addr>[,options]
 			Start an early, polled-mode console on the 8250/16550
 			UART at the specified I/O port or MMIO address,
 			switching to the matching ttyS device later.  The
 			options are the same as for ttyS, above.
 
+	earlycon=	[KNL] Output early console device and options.
+		uart8250,io,<addr>[,options]
+		uart8250,mmio,<addr>[,options]
+			Start an early, polled-mode console on the 8250/16550
+			UART at the specified I/O port or MMIO address.
+			The options are the same as for ttyS, above.
+
 	cpcihp_generic=	[HW,PCI] Generic port I/O CompactPCI driver
 			Format:
 			<first_slot>,<last_slot>,<port>,<enum_bit>[,<debug>]
diff -puN arch/ia64/kernel/setup.c~serial-convert-early_uart-to-earlycon-for-8250 arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~serial-convert-early_uart-to-earlycon-for-8250
+++ a/arch/ia64/kernel/setup.c
@@ -390,10 +390,6 @@ early_console_setup (char *cmdline)
 	if (!efi_setup_pcdp_console(cmdline))
 		earlycons++;
 #endif
-#ifdef CONFIG_SERIAL_8250_CONSOLE
-	if (!early_serial_console_init(cmdline))
-		earlycons++;
-#endif
 
 	return (earlycons) ? 0 : -1;
 }
diff -puN drivers/serial/8250.c~serial-convert-early_uart-to-earlycon-for-8250 drivers/serial/8250.c
--- a/drivers/serial/8250.c~serial-convert-early_uart-to-earlycon-for-8250
+++ a/drivers/serial/8250.c
@@ -2514,12 +2514,18 @@ static int __init serial8250_console_set
 	return uart_set_options(port, co, baud, parity, bits, flow);
 }
 
+static int __init serial8250_console_early_setup(void)
+{
+	return serial8250_find_port_for_earlycon();
+}
+
 static struct uart_driver serial8250_reg;
 static struct console serial8250_console = {
 	.name		= "ttyS",
 	.write		= serial8250_console_write,
 	.device		= uart_console_device,
 	.setup		= serial8250_console_setup,
+	.early_setup	= serial8250_console_early_setup,
 	.flags		= CON_PRINTBUFFER,
 	.index		= -1,
 	.data		= &serial8250_reg,
@@ -2533,7 +2539,7 @@ static int __init serial8250_console_ini
 }
 console_initcall(serial8250_console_init);
 
-static int __init find_port(struct uart_port *p)
+int serial8250_find_port(struct uart_port *p)
 {
 	int line;
 	struct uart_port *port;
@@ -2546,26 +2552,6 @@ static int __init find_port(struct uart_
 	return -ENODEV;
 }
 
-int __init serial8250_start_console(struct uart_port *port, char *options)
-{
-	int line;
-
-	line = find_port(port);
-	if (line < 0)
-		return -ENODEV;
-
-	add_preferred_console("ttyS", line, options);
-	printk("Adding console on ttyS%d at %s 0x%lx (options '%s')\n",
-		line, port->iotype == UPIO_MEM ? "MMIO" : "I/O port",
-		port->iotype == UPIO_MEM ? (unsigned long) port->mapbase :
-		    (unsigned long) port->iobase, options);
-	if (!(serial8250_console.flags & CON_ENABLED)) {
-		serial8250_console.flags &= ~CON_PRINTBUFFER;
-		register_console(&serial8250_console);
-	}
-	return line;
-}
-
 #define SERIAL8250_CONSOLE	&serial8250_console
 #else
 #define SERIAL8250_CONSOLE	NULL
diff -puN drivers/serial/8250_early.c~serial-convert-early_uart-to-earlycon-for-8250 drivers/serial/8250_early.c
--- a/drivers/serial/8250_early.c~serial-convert-early_uart-to-earlycon-for-8250
+++ a/drivers/serial/8250_early.c
@@ -17,13 +17,11 @@
  * we locate the device directly by its MMIO or I/O port address.
  *
  * The user can specify the device directly, e.g.,
- *	console=uart,io,0x3f8,9600n8
- *	console=uart,mmio,0xff5e0000,115200n8
- * or platform code can call early_uart_console_init() to set
- * the early UART device.
- *
- * After the normal serial driver starts, we try to locate the
- * matching ttyS device and start a console there.
+ *	earlycon=uart8250,io,0x3f8,9600n8
+ *	earlycon=uart8250,mmio,0xff5e0000,115200n8
+ * or
+ *	console=uart8250,io,0x3f8,9600n8
+ *	console=uart8250,mmio,0xff5e0000,115200n8
  */
 
 #include <linux/tty.h>
@@ -32,17 +30,17 @@
 #include <linux/serial_core.h>
 #include <linux/serial_reg.h>
 #include <linux/serial.h>
+#include <linux/serial_8250.h>
 #include <asm/io.h>
 #include <asm/serial.h>
 
-struct early_uart_device {
+struct early_serial8250_device {
 	struct uart_port port;
 	char options[16];		/* e.g., 115200n8 */
 	unsigned int baud;
 };
 
-static struct early_uart_device early_device __initdata;
-static int early_uart_registered __initdata;
+static struct early_serial8250_device early_device;
 
 static unsigned int __init serial_in(struct uart_port *port, int offset)
 {
@@ -80,7 +78,7 @@ static void __init putc(struct uart_port
 	serial_out(port, UART_TX, c);
 }
 
-static void __init early_uart_write(struct console *console, const char *s, unsigned int count)
+static void __init early_serial8250_write(struct console *console, const char *s, unsigned int count)
 {
 	struct uart_port *port = &early_device.port;
 	unsigned int ier;
@@ -111,7 +109,7 @@ static unsigned int __init probe_baud(st
 	return (port->uartclk / 16) / quot;
 }
 
-static void __init init_port(struct early_uart_device *device)
+static void __init init_port(struct early_serial8250_device *device)
 {
 	struct uart_port *port = &device->port;
 	unsigned int divisor;
@@ -130,10 +128,9 @@ static void __init init_port(struct earl
 	serial_out(port, UART_LCR, c & ~UART_LCR_DLAB);
 }
 
-static int __init parse_options(struct early_uart_device *device, char *options)
+static int __init parse_options(struct early_serial8250_device *device, char *options)
 {
 	struct uart_port *port = &device->port;
-	int mapsize = 64;
 	int mmio, length;
 
 	if (!options)
@@ -143,12 +140,7 @@ static int __init parse_options(struct e
 	if (!strncmp(options, "mmio,", 5)) {
 		port->iotype = UPIO_MEM;
 		port->mapbase = simple_strtoul(options + 5, &options, 0);
-		port->membase = ioremap(port->mapbase, mapsize);
-		if (!port->membase) {
-			printk(KERN_ERR "%s: Couldn't ioremap 0x%lx\n",
-				__FUNCTION__, port->mapbase);
-			return -ENOMEM;
-		}
+		port->membase = fix_ioremap(FIX_EARLYCON_MEM_BASE, port->mapbase);
 		mmio = 1;
 	} else if (!strncmp(options, "io,", 3)) {
 		port->iotype = UPIO_PORT;
@@ -175,9 +167,16 @@ static int __init parse_options(struct e
 	return 0;
 }
 
-static int __init early_uart_setup(struct console *console, char *options)
+static struct console early_serial8250_console __initdata = {
+	.name	= "uart",
+	.write	= early_serial8250_write,
+	.flags	= CON_PRINTBUFFER | CON_BOOT,
+	.index	= -1,
+};
+
+static int __init early_serial8250_setup(char *options)
 {
-	struct early_uart_device *device = &early_device;
+	struct early_serial8250_device *device = &early_device;
 	int err;
 
 	if (device->port.membase || device->port.iobase)
@@ -190,61 +189,39 @@ static int __init early_uart_setup(struc
 	return 0;
 }
 
-static struct console early_uart_console __initdata = {
-	.name	= "uart",
-	.write	= early_uart_write,
-	.setup	= early_uart_setup,
-	.flags	= CON_PRINTBUFFER,
-	.index	= -1,
-};
-
-static int __init early_uart_console_init(void)
-{
-	if (!early_uart_registered) {
-		register_console(&early_uart_console);
-		early_uart_registered = 1;
-	}
-	return 0;
-}
-console_initcall(early_uart_console_init);
-
-int __init early_serial_console_init(char *cmdline)
+static int __init setup_early_serial8250_console(char *cmdline)
 {
 	char *options;
 	int err;
 
-	options = strstr(cmdline, "console=uart,");
+	options = strstr(cmdline, "uart8250,");
 	if (!options)
-		return -ENODEV;
+		return 0;
 
 	options = strchr(cmdline, ',') + 1;
-	if ((err = early_uart_setup(NULL, options)) < 0)
+	if ((err = early_serial8250_setup(options)) < 0)
 		return err;
-	return early_uart_console_init();
+
+	register_console(&early_serial8250_console);
+
+	return 0;
 }
 
-static int __init early_uart_console_switch(void)
+int __init serial8250_find_port_for_earlycon(void)
 {
-	struct early_uart_device *device = &early_device;
+	struct early_serial8250_device *device = &early_device;
 	struct uart_port *port = &device->port;
-	int mmio, line;
+	int line;
 
-	if (!(early_uart_console.flags & CON_ENABLED))
-		return 0;
+	if (!device->port.membase && !device->port.iobase)
+		return -ENODEV;
 
-	/* Try to start the normal driver on a matching line.  */
-	mmio = (port->iotype == UPIO_MEM);
-	line = serial8250_start_console(port, device->options);
+	line = serial8250_find_port(port);
 	if (line < 0)
-		printk("No ttyS device at %s 0x%lx for console\n",
-			mmio ? "MMIO" : "I/O port",
-			mmio ? port->mapbase :
-			    (unsigned long) port->iobase);
-
-	unregister_console(&early_uart_console);
-	if (mmio)
-		iounmap(port->membase);
+		return -ENODEV;
 
-	return 0;
+	return update_console_cmdline("uart", 8250,
+				     "ttyS", line, device->options);
 }
-late_initcall(early_uart_console_switch);
+
+early_param("earlycon", setup_early_serial8250_console);
diff -puN drivers/serial/Kconfig~serial-convert-early_uart-to-earlycon-for-8250 drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~serial-convert-early_uart-to-earlycon-for-8250
+++ a/drivers/serial/Kconfig
@@ -62,6 +62,16 @@ config SERIAL_8250_CONSOLE
 	  kernel will automatically use the first serial line, /dev/ttyS0, as
 	  system console.
 
+	  you can set that using a kernel command line option such as
+	  "console=uart8250,io,0x3f8,9600n8"
+	  "console=uart8250,mmio,0xff5e0000,115200n8".
+	  and it will switch to normal serial console when correponding port is
+	  ready.
+	  "earlycon=uart8250,io,0x3f8,9600n8"
+	  "earlycon=uart8250,mmio,0xff5e0000,115200n8".
+	  it will not only setup early console.
+
+
 	  If unsure, say N.
 
 config SERIAL_8250_GSC
diff -puN include/asm-i386/fixmap.h~serial-convert-early_uart-to-earlycon-for-8250 include/asm-i386/fixmap.h
--- a/include/asm-i386/fixmap.h~serial-convert-early_uart-to-earlycon-for-8250
+++ a/include/asm-i386/fixmap.h
@@ -54,6 +54,8 @@ extern unsigned long __FIXADDR_TOP;
 enum fixed_addresses {
 	FIX_HOLE,
 	FIX_VDSO,
+	FIX_DBGP_BASE,
+	FIX_EARLYCON_MEM_BASE,
 #ifdef CONFIG_X86_LOCAL_APIC
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 #endif
diff -puN include/asm-i386/io.h~serial-convert-early_uart-to-earlycon-for-8250 include/asm-i386/io.h
--- a/include/asm-i386/io.h~serial-convert-early_uart-to-earlycon-for-8250
+++ a/include/asm-i386/io.h
@@ -130,6 +130,19 @@ extern void iounmap(volatile void __iome
 extern void *bt_ioremap(unsigned long offset, unsigned long size);
 extern void bt_iounmap(void *addr, unsigned long size);
 
+#include <asm/pgtable.h>
+#include <asm/fixmap.h>
+
+static inline void __iomem * fix_ioremap (unsigned idx, unsigned long phys)
+{
+	void __iomem * vaddr;
+	set_fixmap_nocache(idx, phys & PAGE_MASK);
+	vaddr = (void __iomem *)__fix_to_virt(idx);
+	vaddr += phys & ~PAGE_MASK;
+
+	return vaddr;
+}
+
 /* Use early IO mappings for DMI because it's initialized early */
 #define dmi_ioremap bt_ioremap
 #define dmi_iounmap bt_iounmap
diff -puN include/asm-ia64/io.h~serial-convert-early_uart-to-earlycon-for-8250 include/asm-ia64/io.h
--- a/include/asm-ia64/io.h~serial-convert-early_uart-to-earlycon-for-8250
+++ a/include/asm-ia64/io.h
@@ -423,6 +423,10 @@ extern void __iomem * ioremap(unsigned l
 extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
 extern void iounmap (volatile void __iomem *addr);
 
+/* for console=uart8250,mmio,0xffe5000,9600n8 */
+#define FIX_EARLYCON_MEM_BASE 1
+#define fix_ioremap(idx, phys) ioremap(phys, 64)
+
 /* Use normal IO mappings for DMI */
 #define dmi_ioremap ioremap
 #define dmi_iounmap(x,l) iounmap(x)
diff -puN include/asm-x86_64/fixmap.h~serial-convert-early_uart-to-earlycon-for-8250 include/asm-x86_64/fixmap.h
--- a/include/asm-x86_64/fixmap.h~serial-convert-early_uart-to-earlycon-for-8250
+++ a/include/asm-x86_64/fixmap.h
@@ -35,6 +35,8 @@ enum fixed_addresses {
 	VSYSCALL_LAST_PAGE,
 	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
 	VSYSCALL_HPET,
+	FIX_DBGP_BASE,
+	FIX_EARLYCON_MEM_BASE,
 	FIX_HPET_BASE,
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 	FIX_IO_APIC_BASE_0,
@@ -84,7 +86,7 @@ static __always_inline unsigned long fix
 	if (idx >= __end_of_fixed_addresses)
 		__this_fixmap_does_not_exist();
 
-        return __fix_to_virt(idx);
+	return __fix_to_virt(idx);
 }
 
 #endif
diff -puN include/asm-x86_64/io.h~serial-convert-early_uart-to-earlycon-for-8250 include/asm-x86_64/io.h
--- a/include/asm-x86_64/io.h~serial-convert-early_uart-to-earlycon-for-8250
+++ a/include/asm-x86_64/io.h
@@ -145,6 +145,19 @@ extern void early_iounmap(void *addr, un
 extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
 extern void iounmap(volatile void __iomem *addr);
 
+#include <asm/pgtable.h>
+#include <asm/fixmap.h>
+
+static inline void __iomem * fix_ioremap (unsigned idx, unsigned long phys)
+{
+	void __iomem * vaddr;
+	set_fixmap_nocache(idx, phys & PAGE_MASK);
+	vaddr = (void __iomem *)__fix_to_virt(idx);
+	vaddr += phys & ~PAGE_MASK;
+
+	return vaddr;
+}
+
 /*
  * ISA I/O bus memory addresses are 1:1 with the physical address.
  */
diff -puN include/linux/console.h~serial-convert-early_uart-to-earlycon-for-8250 include/linux/console.h
--- a/include/linux/console.h~serial-convert-early_uart-to-earlycon-for-8250
+++ a/include/linux/console.h
@@ -99,6 +99,7 @@ struct console {
 	struct tty_driver *(*device)(struct console *, int *);
 	void	(*unblank)(void);
 	int	(*setup)(struct console *, char *);
+	int	(*early_setup)(void);
 	short	flags;
 	short	index;
 	int	cflag;
@@ -107,6 +108,7 @@ struct console {
 };
 
 extern int add_preferred_console(char *name, int idx, char *options);
+extern int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options);
 extern void register_console(struct console *);
 extern int unregister_console(struct console *);
 extern struct console *console_drivers;
diff -puN include/linux/serial.h~serial-convert-early_uart-to-earlycon-for-8250 include/linux/serial.h
--- a/include/linux/serial.h~serial-convert-early_uart-to-earlycon-for-8250
+++ a/include/linux/serial.h
@@ -177,11 +177,5 @@ struct serial_icounter_struct {
 #ifdef __KERNEL__
 #include <linux/compiler.h>
 
-/* Allow architectures to override entries in serial8250_ports[] at run time: */
-struct uart_port;	/* forward declaration */
-extern int early_serial_setup(struct uart_port *port);
-extern int early_serial_console_init(char *options);
-extern int serial8250_start_console(struct uart_port *port, char *options);
-
 #endif /* __KERNEL__ */
 #endif /* _LINUX_SERIAL_H */
diff -puN include/linux/serial_8250.h~serial-convert-early_uart-to-earlycon-for-8250 include/linux/serial_8250.h
--- a/include/linux/serial_8250.h~serial-convert-early_uart-to-earlycon-for-8250
+++ a/include/linux/serial_8250.h
@@ -60,4 +60,7 @@ void serial8250_unregister_port(int line
 void serial8250_suspend_port(int line);
 void serial8250_resume_port(int line);
 
+extern int serial8250_find_port(struct uart_port *p);
+extern int serial8250_find_port_for_earlycon(void);
+
 #endif
diff -puN init/main.c~serial-convert-early_uart-to-earlycon-for-8250 init/main.c
--- a/init/main.c~serial-convert-early_uart-to-earlycon-for-8250
+++ a/init/main.c
@@ -452,7 +452,10 @@ static int __init do_early_param(char *p
 	struct obs_kernel_param *p;
 
 	for (p = __setup_start; p < __setup_end; p++) {
-		if (p->early && strcmp(param, p->str) == 0) {
+		if ((p->early && strcmp(param, p->str) == 0) ||
+		    (strcmp(param, "console") == 0 &&
+		     strcmp(p->str, "earlycon") == 0)
+		) {
 			if (p->setup_func(val) != 0)
 				printk(KERN_WARNING
 				       "Malformed early option '%s'\n", param);
diff -puN kernel/printk.c~serial-convert-early_uart-to-earlycon-for-8250 kernel/printk.c
--- a/kernel/printk.c~serial-convert-early_uart-to-earlycon-for-8250
+++ a/kernel/printk.c
@@ -726,6 +726,25 @@ int __init add_preferred_console(char *n
 	return 0;
 }
 
+int __init update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options)
+{
+	struct console_cmdline *c;
+	int i;
+
+	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
+		if (strcmp(console_cmdline[i].name, name) == 0 &&
+			  console_cmdline[i].index == idx) {
+				c = &console_cmdline[i];
+				memcpy(c->name, name_new, sizeof(c->name));
+				c->name[sizeof(c->name) - 1] = 0;
+				c->options = options;
+				c->index = idx_new;
+				return i;
+		}
+	/* not found */
+	return -1;
+}
+
 #ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
 /**
  * suspend_console - suspend the console subsystem
@@ -942,6 +961,9 @@ void register_console(struct console *co
 	if (preferred_console < 0 || bootconsole || !console_drivers)
 		preferred_console = selected_console;
 
+	if (console->early_setup)
+		console->early_setup();
+
 	/*
 	 *	See if we want to use this console driver. If we
 	 *	didn't select a console we take the first one
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

serial-convert-early_uart-to-earlycon-for-8250.patch
serial-convert-early_uart-to-earlycon-for-8250-fix-2.patch
serial-set-dtr-in-uart-for-kernel-serial-console.patch
