From: akpm@linux-foundation.org
Subject: [to-be-updated] max3100-add-console-support-for-max3100.patch removed from -mm tree
Date: Tue, 27 Apr 2010 14:39:10 -0700
Message-ID: <201004272139.o3RLdAxC021650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756542Ab0D0Vka (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 17:40:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chripell@fsfe.org, alan@lxorguk.ukuu.org.uk, feng.tang@intel.com, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     max3100: add console support for MAX3100
has been removed from the -mm tree.  Its filename was
     max3100-add-console-support-for-max3100.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: max3100: add console support for MAX3100
From: Christian Pellegrin <chripell@fsfe.org>

Add console support for the MAX3100 UART (console=ttyMAX0,11500).  The SPI
subsystem and an suitable SPI master driver have to be compiled in the
kernel.

Signed-off-by: Christian Pellegrin <chripell@fsfe.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig         |    7 +
 drivers/serial/max3100.c       |  217 ++++++++++++++++++++++++++++---
 include/linux/serial_max3100.h |    4 
 3 files changed, 212 insertions(+), 16 deletions(-)

diff -puN drivers/serial/Kconfig~max3100-add-console-support-for-max3100 drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~max3100-add-console-support-for-max3100
+++ a/drivers/serial/Kconfig
@@ -564,6 +564,13 @@ config SERIAL_MAX3100
 	help
 	  MAX3100 chip support
 
+config SERIAL_MAX3100_CONSOLE
+	bool "Support console on MAX3100"
+	depends on SERIAL_MAX3100=y
+	select SERIAL_CORE_CONSOLE
+	help
+	  Console on MAX3100
+
 config SERIAL_DZ
 	bool "DECstation DZ serial driver"
 	depends on MACH_DECSTATION && 32BIT
diff -puN drivers/serial/max3100.c~max3100-add-console-support-for-max3100 drivers/serial/max3100.c
--- a/drivers/serial/max3100.c~max3100-add-console-support-for-max3100
+++ a/drivers/serial/max3100.c
@@ -49,6 +49,7 @@
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
 #include <linux/bitops.h>
+#include <linux/console.h>
 
 #include <linux/serial_max3100.h>
 
@@ -132,6 +133,22 @@ struct max3100_port {
 	int poll_time;
 	/* and its timer */
 	struct timer_list	timer;
+
+	int console_flags;
+	/* is this port a console? */
+#define MAX3100_IS_CONSOLE   (1 << 0)
+	/* are we in suspend/resume? */
+#define MAX3100_SUSPENDING   (1 << 1)
+#ifdef CONFIG_SERIAL_MAX3100_CONSOLE
+	/* console buffer */
+#define CONSOLE_BUF_SIZE 4096
+	char *console_buf;
+	int console_head, console_tail;
+	/* delayed console work because we may have to sleep */
+	struct work_struct console_work;
+	/* char tx timeout */
+	int console_tout;
+#endif
 };
 
 static struct max3100_port *max3100s[MAX_MAX3100]; /* the chips */
@@ -176,7 +193,9 @@ static void max3100_resume_work(struct w
 	struct max3100_port *s = container_of(w, struct max3100_port,
 					      resume_work);
 
-	raise_threaded_irq(s->irq);
+	if (s->irq)
+		raise_threaded_irq(s->irq);
+	s->console_flags &= ~MAX3100_SUSPENDING;
 }
 
 static void max3100_timeout(unsigned long data)
@@ -553,14 +572,16 @@ static void max3100_shutdown(struct uart
 	if (s->irq)
 		free_irq(s->irq, s);
 
-	/* set shutdown mode to save power */
-	if (s->max3100_hw_suspend)
-		s->max3100_hw_suspend(1);
-	else  {
-		u16 tx, rx;
+	if (!(s->console_flags & MAX3100_IS_CONSOLE)) {
+		/* set shutdown mode to save power */
+		if (s->max3100_hw_suspend) {
+			s->max3100_hw_suspend(1);
+		} else {
+			u16 tx, rx;
 
-		tx = MAX3100_WC | MAX3100_SHDN;
-		max3100_sr(s, tx, &rx);
+			tx = MAX3100_WC | MAX3100_SHDN;
+			max3100_sr(s, tx, &rx);
+		}
 	}
 }
 
@@ -579,8 +600,6 @@ static int max3100_startup(struct uart_p
 	s->parity = 0;
 	s->rts = 0;
 
-	INIT_WORK(&s->resume_work, max3100_resume_work);
-
 	if (request_threaded_irq(s->irq, NULL, max3100_ist,
 			IRQF_TRIGGER_FALLING, "max3100", s) < 0) {
 		dev_err(&s->spi->dev, "cannot allocate irq %d\n", s->irq);
@@ -700,6 +719,147 @@ static struct uart_ops max3100_ops = {
 	.verify_port	= max3100_verify_port,
 };
 
+#ifdef CONFIG_SERIAL_MAX3100_CONSOLE
+
+static void max3100_console_work(struct work_struct *w)
+{
+	struct max3100_port *s = container_of(w, struct max3100_port,
+					      console_work);
+	unsigned long start;
+	u16 tx, rx;
+
+	while (s->console_head != s->console_tail &&
+	       (s->console_flags & MAX3100_SUSPENDING) == 0) {
+		start = jiffies;
+		do {
+			tx = MAX3100_RC;
+			max3100_sr(s, tx, &rx);
+		} while ((rx & MAX3100_T) == 0 &&
+			 !time_after(jiffies, start + s->console_tout));
+		tx = s->console_buf[s->console_tail];
+		max3100_calc_parity(s, &tx);
+		tx |= MAX3100_WD | MAX3100_RTS;
+		max3100_sr(s, tx, &rx);
+		s->console_tail = (s->console_tail + 1) % CONSOLE_BUF_SIZE;
+	}
+}
+
+static void max3100_console_putchar(struct uart_port *port, int ch)
+{
+	struct max3100_port *s = to_max3100_port(port);
+	int next = (s->console_head + 1) % CONSOLE_BUF_SIZE;
+
+	if (next != s->console_tail) {
+		s->console_buf[next] = ch;
+		s->console_head = next;
+	}
+}
+
+static void max3100_console_write(struct console *co,
+				  const char *str, unsigned int count)
+{
+	struct max3100_port *s = max3100s[co->index];;
+
+	uart_console_write(&s->port, str, count, max3100_console_putchar);
+	schedule_work(&s->console_work);
+}
+
+static int max3100_console_setup(struct console *co, char *options)
+{
+	struct max3100_port *s;
+	int baud = 115200;
+	int bits = 8;
+	int parity = 'n';
+	int flow = 'n';
+	int ret;
+	u16 tx, rx;
+
+	if (co->index == -1 || co->index >= MAX_MAX3100)
+		co->index = 0;
+	s = max3100s[co->index];
+	if (!s)
+		return -ENOENT;
+
+	s->console_buf = kmalloc(CONSOLE_BUF_SIZE, GFP_KERNEL);
+	if (!s->console_buf)
+		return -ENOMEM;
+	INIT_WORK(&s->console_work, max3100_console_work);
+	s->console_flags |= MAX3100_IS_CONSOLE;
+
+	if (options)
+		uart_parse_options(options, &baud, &parity, &bits, &flow);
+	ret = uart_set_options(&s->port, co, baud, parity, bits, flow);
+
+	tx = 0;
+	switch (baud) {
+	case 300:
+		tx = 15;
+		break;
+	case 600:
+		tx = 14 + s->crystal;
+		break;
+	case 1200:
+		tx = 13 + s->crystal;
+		break;
+	case 2400:
+		tx = 12 + s->crystal;
+		break;
+	case 4800:
+		tx = 11 + s->crystal;
+		break;
+	case 9600:
+		tx = 10 + s->crystal;
+		break;
+	case 19200:
+		tx = 9 + s->crystal;
+		break;
+	case 38400:
+		tx = 8 + s->crystal;
+		break;
+	case 57600:
+		tx = 1 + s->crystal;
+		break;
+	case 115200:
+		tx = 0 + s->crystal;
+		break;
+	case 230400:
+		tx = 0;
+		break;
+	}
+	if (bits == 7) {
+		tx |= MAX3100_L;
+		s->parity |= MAX3100_7BIT;
+	}
+	if (parity == 'o' || parity == 'e') {
+		tx |= MAX3100_PE;
+		s->parity |= MAX3100_PARITY_ON;
+	}
+	if (parity == 'o')
+		s->parity |= MAX3100_PARITY_ODD;
+	s->console_tout = 1 + (20 * HZ) / baud; /* jiffies to send 20 bits */
+
+	tx |= MAX3100_WC;
+	max3100_sr(s, tx, &rx);
+
+	/* wait for oscilator to stabilize. Data sheet says 25ms,
+	 * apply "multiply by two" engineer's rule */
+	msleep(50);
+	return ret;
+}
+
+static struct uart_driver max3100_uart_driver;
+static struct console max3100_console = {
+	.name		= "ttyMAX",
+	.write		= max3100_console_write,
+	.device		= uart_console_device,
+	.setup		= max3100_console_setup,
+	.flags		= CON_PRINTBUFFER,
+	.index		= -1,
+	.data		= &max3100_uart_driver,
+};
+static int max3100_console_registered;
+#endif
+
 static struct uart_driver max3100_uart_driver = {
 	.owner          = THIS_MODULE,
 	.driver_name    = "ttyMAX",
@@ -707,6 +867,9 @@ static struct uart_driver max3100_uart_d
 	.major          = MAX3100_MAJOR,
 	.minor          = MAX3100_MINOR,
 	.nr             = MAX_MAX3100,
+#ifdef CONFIG_SERIAL_MAX3100_CONSOLE
+	.cons           = &max3100_console,
+#endif
 };
 static int uart_driver_registered;
 
@@ -769,18 +932,27 @@ static int __devinit max3100_probe(struc
 	max3100s[i]->port.line = i;
 	max3100s[i]->port.type = PORT_MAX3100;
 	max3100s[i]->port.dev = &spi->dev;
+	INIT_WORK(&max3100s[i]->resume_work, max3100_resume_work);
 	retval = uart_add_one_port(&max3100_uart_driver, &max3100s[i]->port);
 	if (retval < 0)
 		dev_warn(&spi->dev,
 			 "uart_add_one_port failed for line %d with error %d\n",
 			 i, retval);
 
-	/* set shutdown mode to save power. Will be woken-up on open */
-	if (max3100s[i]->max3100_hw_suspend)
-		max3100s[i]->max3100_hw_suspend(1);
-	else {
-		tx = MAX3100_WC | MAX3100_SHDN;
-		max3100_sr(max3100s[i], tx, &rx);
+#ifdef CONFIG_SERIAL_MAX3100_CONSOLE
+	if (pdata->console && !max3100_console_registered) {
+		register_console(&max3100_console);
+		max3100_console_registered = 1;
+	}
+#endif
+	if (!(max3100s[i]->console_flags & MAX3100_IS_CONSOLE)) {
+		/* set shutdown mode to save power. Will be woken-up on open */
+		if (max3100s[i]->max3100_hw_suspend) {
+			max3100s[i]->max3100_hw_suspend(1);
+		} else {
+			tx = MAX3100_WC | MAX3100_SHDN;
+			max3100_sr(max3100s[i], tx, &rx);
+		}
 	}
 	mutex_unlock(&max3100s_lock);
 	return 0;
@@ -793,12 +965,24 @@ static int __devexit max3100_remove(stru
 
 	mutex_lock(&max3100s_lock);
 
+#ifdef CONFIG_SERIAL_MAX3100_CONSOLE
+	if (max3100_console_registered) {
+		unregister_console(&max3100_console);
+		max3100_console_registered = 0;
+	}
+#endif
 	/* find out the index for the chip we are removing */
 	for (i = 0; i < MAX_MAX3100; i++)
 		if (max3100s[i] == s)
 			break;
 
 	dev_dbg(&spi->dev, "%s: removing port %d\n", __func__, i);
+#ifdef CONFIG_SERIAL_MAX3100_CONSOLE
+	if (s->console_buf) {
+		flush_work(&s->console_work);
+		kfree(s->console_buf);
+	}
+#endif
 	uart_remove_one_port(&max3100_uart_driver, &max3100s[i]->port);
 	kfree(max3100s[i]);
 	max3100s[i] = NULL;
@@ -824,6 +1008,7 @@ static int max3100_suspend(struct spi_de
 
 	dev_dbg(&s->spi->dev, "%s\n", __func__);
 
+	s->console_flags |= MAX3100_SUSPENDING;
 	disable_irq(s->irq);
 
 	if (s->max3100_hw_suspend)
diff -puN include/linux/serial_max3100.h~max3100-add-console-support-for-max3100 include/linux/serial_max3100.h
--- a/include/linux/serial_max3100.h~max3100-add-console-support-for-max3100
+++ a/include/linux/serial_max3100.h
@@ -21,6 +21,9 @@
  *                       called on suspend and resume to activate it.
  * @poll_time:           poll time for CTS signal in ms, 0 disables (so no hw
  *                       flow ctrl is possible but you have less CPU usage)
+ * @console:             1 if this MAX3100 is the last one on the system
+ *                       (in the order of spi_board_info enumeration) that
+ *                       can act as a console.
  *
  * You should use this structure in your machine description to specify
  * how the MAX3100 is connected. Example:
@@ -47,6 +50,7 @@ struct plat_max3100 {
 	int crystal;
 	void (*max3100_hw_suspend) (int suspend);
 	int poll_time;
+	int console;
 };
 
 #endif
_

Patches currently in -mm which might be from chripell@fsfe.org are

linux-next.patch
max3100-add-console-support-for-max3100.patch
max3100-to_max3100_port-small-style-fixes.patch
max3100-add-console-support-for-max3100-fixes-for-the-max31x0-console.patch

