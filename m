From: akpm@linux-foundation.org
Subject: + xen-paravirt-add-the-xen-virtual-console-driver.patch added to -mm tree
Date: Thu, 15 Feb 2007 23:00:32 -0800
Message-ID: <200702160700.l1G70WXo022664@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55252 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423381AbXBPHBp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 02:01:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, Christian.Limpach@cl.cam.ac.uk, ak@suse.de, chrisw@sous-sol.org, ian.pratt@xensource.com, rusty@rustcorp.com.au, zach@vmware.com


The patch titled
     Xen-paravirt: add the Xen virtual console driver
has been added to the -mm tree.  Its filename is
     xen-paravirt-add-the-xen-virtual-console-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Xen-paravirt: add the Xen virtual console driver
From: Jeremy Fitzhardinge <jeremy@goop.org>

This provides a bootstrap and ongoing emergency console which is intended to
be available from very early during boot and at all times thereafter, in
contrast with alternatives such as UDP-based syslogd, or logging in via ssh. 
The protocol is based on a simple shared-memory ring buffer.

Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/early_printk.c    |    2 
 drivers/Makefile                   |    3 
 drivers/xen/Makefile               |    1 
 drivers/xen/console/Makefile       |    2 
 drivers/xen/console/console.c      |  585 +++++++++++++++++++++++++++
 drivers/xen/console/xencons_ring.c |  144 ++++++
 include/xen/xencons.h              |   14 
 init/main.c                        |    2 
 8 files changed, 753 insertions(+)

diff -puN arch/i386/kernel/early_printk.c~xen-paravirt-add-the-xen-virtual-console-driver arch/i386/kernel/early_printk.c
--- a/arch/i386/kernel/early_printk.c~xen-paravirt-add-the-xen-virtual-console-driver
+++ a/arch/i386/kernel/early_printk.c
@@ -1,2 +1,4 @@
 
+#ifndef CONFIG_XEN
 #include "../../x86_64/kernel/early_printk.c"
+#endif
diff -puN drivers/Makefile~xen-paravirt-add-the-xen-virtual-console-driver drivers/Makefile
--- a/drivers/Makefile~xen-paravirt-add-the-xen-virtual-console-driver
+++ a/drivers/Makefile
@@ -15,6 +15,9 @@ obj-$(CONFIG_ACPI)		+= acpi/
 obj-$(CONFIG_PNP)		+= pnp/
 obj-$(CONFIG_ARM_AMBA)		+= amba/
 
+# Xen is the default console when running as a guest
+obj-$(CONFIG_XEN)		+= xen/
+
 # char/ comes before serial/ etc so that the VT console is the boot-time
 # default.
 obj-y				+= char/
diff -puN /dev/null drivers/xen/Makefile
--- /dev/null
+++ a/drivers/xen/Makefile
@@ -0,0 +1 @@
+obj-y	+= console/
diff -puN /dev/null drivers/xen/console/Makefile
--- /dev/null
+++ a/drivers/xen/console/Makefile
@@ -0,0 +1,2 @@
+
+obj-y	:= console.o xencons_ring.o
diff -puN /dev/null drivers/xen/console/console.c
--- /dev/null
+++ a/drivers/xen/console/console.c
@@ -0,0 +1,585 @@
+/******************************************************************************
+ * console.c
+ *
+ * Virtual console driver.
+ *
+ * Copyright (c) 2002-2004, K A Fraser.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+#include <linux/serial.h>
+#include <linux/major.h>
+#include <linux/ptrace.h>
+#include <linux/ioport.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/console.h>
+#include <linux/bootmem.h>
+#include <linux/sysrq.h>
+#include <linux/vt.h>
+
+#include <asm/io.h>
+#include <asm/irq.h>
+#include <asm/uaccess.h>
+#include <xen/interface/xen.h>
+#include <xen/interface/event_channel.h>
+#include <asm/xen/hypervisor.h>
+#include <xen/events.h>
+#include <xen/xencons.h>
+
+MODULE_LICENSE("Dual BSD/GPL");
+
+static int xc_disabled = 0;
+static int xc_num = -1;
+
+/* /dev/xvc0 device number allocated by lanana.org. */
+#define XEN_XVC_MAJOR 204
+#define XEN_XVC_MINOR 191
+
+#ifdef CONFIG_MAGIC_SYSRQ
+static unsigned long sysrq_requested;
+#endif
+
+static int __init xencons_setup(char *str)
+{
+	if (!strcmp(str, "off"))
+		xc_disabled = 1;
+	return 1;
+}
+__setup("xencons=", xencons_setup);
+
+/* The kernel and user-land drivers share a common transmit buffer. */
+static unsigned int wbuf_size = 4096;
+#define WBUF_MASK(_i) ((_i)&(wbuf_size-1))
+static char *wbuf;
+static unsigned int wc, wp; /* write_cons, write_prod */
+
+static int __init xencons_bufsz_setup(char *str)
+{
+	unsigned int goal;
+	goal = simple_strtoul(str, NULL, 0);
+	if (goal) {
+		goal = roundup_pow_of_two(goal);
+		if (wbuf_size < goal)
+			wbuf_size = goal;
+	}
+	return 1;
+}
+__setup("xencons_bufsz=", xencons_bufsz_setup);
+
+/* This lock protects accesses to the common transmit buffer. */
+static DEFINE_SPINLOCK(xencons_lock);
+
+/* Common transmit-kick routine. */
+static void __xencons_tx_flush(void);
+
+static struct tty_driver *xencons_driver;
+
+/******************** Kernel console driver ********************************/
+
+static void kcons_write(struct console *c, const char *s, unsigned int count)
+{
+	int           i = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&xencons_lock, flags);
+
+	while (i < count) {
+		for (; i < count; i++) {
+			if ((wp - wc) >= (wbuf_size - 1))
+				break;
+			if ((wbuf[WBUF_MASK(wp++)] = s[i]) == '\n')
+				wbuf[WBUF_MASK(wp++)] = '\r';
+		}
+
+		__xencons_tx_flush();
+	}
+
+	spin_unlock_irqrestore(&xencons_lock, flags);
+}
+
+static void kcons_write_dom0(struct console *c, const char *s, unsigned int count)
+{
+	while (count > 0) {
+		int rc;
+		rc = HYPERVISOR_console_io(CONSOLEIO_write, count, (char *)s);
+		if (rc <= 0)
+			break;
+		count -= rc;
+		s += rc;
+	}
+}
+
+void early_printk(const char *fmt, ...)
+{
+	va_list args;
+	int printk_len;
+	static char printk_buf[1024];
+
+	/* Emit the output into the temporary buffer */
+	va_start(args, fmt);
+	printk_len = vsnprintf(printk_buf, sizeof(printk_buf), fmt, args);
+	va_end(args);
+
+	/* Send the processed output directly to Xen. */
+	kcons_write_dom0(NULL, printk_buf, printk_len);
+}
+
+static struct console early_xen_console = {
+	.name =		"earlyxen",
+	.write =	kcons_write_dom0,
+	.flags =	CON_PRINTBUFFER,
+	.index =	-1,
+};
+
+static int early_console_initialized = 0;
+
+int __init setup_early_printk(char *opt)
+{
+	early_console_initialized = 1;
+	register_console(&early_xen_console);
+
+	return 0;
+}
+
+void __init disable_early_printk(void)
+{
+	if (!early_console_initialized)
+		return;
+	printk("disabling early console\n");
+	unregister_console(&early_xen_console);
+	early_console_initialized = 0;
+}
+
+static struct tty_driver *kcons_device(struct console *c, int *index)
+{
+	*index = 0;
+	return xencons_driver;
+}
+
+static struct console kcons_info = {
+	.name   = "xvc",
+	.device	= kcons_device,
+	.flags	= CON_PRINTBUFFER | CON_ENABLED,
+	.index	= -1,
+};
+
+static int __init xen_console_init(void)
+{
+	if (!is_running_on_xen())
+		goto out;
+	if (xc_disabled)
+		goto out;
+
+	if (is_initial_xendomain()) {
+		kcons_info.write = kcons_write_dom0;
+	} else {
+		if (!xen_start_info->console.domU.evtchn)
+			goto out;
+		kcons_info.write = kcons_write;
+	}
+	if (xc_num == -1)
+		xc_num = 0;
+
+	wbuf = alloc_bootmem(wbuf_size);
+
+	register_console(&kcons_info);
+
+out:
+	return 0;
+}
+console_initcall(xen_console_init);
+
+/*** Forcibly flush console data before dying. ***/
+void xencons_force_flush(void)
+{
+	int sz;
+
+	/* Emergency console is synchronous, so there's nothing to flush. */
+	if (!is_running_on_xen() ||
+	    is_initial_xendomain() ||
+	    !xen_start_info->console.domU.evtchn)
+		return;
+
+	/* Spin until console data is flushed through to the daemon. */
+	while (wc != wp) {
+		int sent = 0;
+		if ((sz = wp - wc) == 0)
+			continue;
+		sent = xencons_ring_send(&wbuf[WBUF_MASK(wc)], sz);
+		if (sent > 0)
+			wc += sent;
+	}
+}
+
+
+/******************** User-space console driver (/dev/console) ************/
+
+#define DRV(_d)         (_d)
+
+static struct ktermios *xencons_termios[1];
+static struct ktermios *xencons_termios_locked[1];
+static struct tty_struct *xencons_tty;
+static int xencons_priv_irq;
+static char x_char;
+
+void xencons_rx(char *buf, unsigned len)
+{
+	int           i;
+	unsigned long flags;
+
+	spin_lock_irqsave(&xencons_lock, flags);
+	if (xencons_tty == NULL)
+		goto out;
+
+	for (i = 0; i < len; i++) {
+#ifdef CONFIG_MAGIC_SYSRQ
+		if (sysrq_on()) {
+			if (buf[i] == '\x0f') { /* ^O */
+				sysrq_requested = jiffies;
+				continue; /* don't print the sysrq key */
+			} else if (sysrq_requested) {
+				unsigned long sysrq_timeout =
+					sysrq_requested + HZ*2;
+				sysrq_requested = 0;
+				if (time_before(jiffies, sysrq_timeout)) {
+					spin_unlock_irqrestore(
+						&xencons_lock, flags);
+					handle_sysrq(
+						buf[i], xencons_tty);
+					spin_lock_irqsave(
+						&xencons_lock, flags);
+					continue;
+				}
+			}
+		}
+#endif
+		tty_insert_flip_char(xencons_tty, buf[i], TTY_NORMAL);
+	}
+	tty_flip_buffer_push(xencons_tty);
+
+ out:
+	spin_unlock_irqrestore(&xencons_lock, flags);
+}
+
+static void __xencons_tx_flush(void)
+{
+	int sent, sz, work_done = 0;
+
+	if (x_char) {
+		if (is_initial_xendomain())
+			kcons_write_dom0(NULL, &x_char, 1);
+		else
+			while (x_char)
+				if (xencons_ring_send(&x_char, 1) == 1)
+					break;
+		x_char = 0;
+		work_done = 1;
+	}
+
+	while (wc != wp) {
+		sz = wp - wc;
+		if (sz > (wbuf_size - WBUF_MASK(wc)))
+			sz = wbuf_size - WBUF_MASK(wc);
+		if (is_initial_xendomain()) {
+			kcons_write_dom0(NULL, &wbuf[WBUF_MASK(wc)], sz);
+			wc += sz;
+		} else {
+			sent = xencons_ring_send(&wbuf[WBUF_MASK(wc)], sz);
+			if (sent == 0)
+				break;
+			wc += sent;
+		}
+		work_done = 1;
+	}
+
+	if (work_done && (xencons_tty != NULL)) {
+		wake_up_interruptible(&xencons_tty->write_wait);
+		tty_wakeup(xencons_tty);
+	}
+}
+
+void xencons_tx(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&xencons_lock, flags);
+	__xencons_tx_flush();
+	spin_unlock_irqrestore(&xencons_lock, flags);
+}
+
+/* Privileged receive callback and transmit kicker. */
+static irqreturn_t xencons_priv_interrupt(int irq, void *dev_id)
+{
+	static char rbuf[16];
+	int         l;
+
+	while ((l = HYPERVISOR_console_io(CONSOLEIO_read, 16, rbuf)) > 0)
+		xencons_rx(rbuf, l);
+
+	xencons_tx();
+
+	return IRQ_HANDLED;
+}
+
+static int xencons_write_room(struct tty_struct *tty)
+{
+	return wbuf_size - (wp - wc);
+}
+
+static int xencons_chars_in_buffer(struct tty_struct *tty)
+{
+	return wp - wc;
+}
+
+static void xencons_send_xchar(struct tty_struct *tty, char ch)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&xencons_lock, flags);
+	x_char = ch;
+	__xencons_tx_flush();
+	spin_unlock_irqrestore(&xencons_lock, flags);
+}
+
+static void xencons_throttle(struct tty_struct *tty)
+{
+	if (I_IXOFF(tty))
+		xencons_send_xchar(tty, STOP_CHAR(tty));
+}
+
+static void xencons_unthrottle(struct tty_struct *tty)
+{
+	if (I_IXOFF(tty)) {
+		if (x_char != 0)
+			x_char = 0;
+		else
+			xencons_send_xchar(tty, START_CHAR(tty));
+	}
+}
+
+static void xencons_flush_buffer(struct tty_struct *tty)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&xencons_lock, flags);
+	wc = wp = 0;
+	spin_unlock_irqrestore(&xencons_lock, flags);
+}
+
+static inline int __xencons_put_char(unsigned char ch)
+{
+	if ((wp - wc) == wbuf_size)
+		return 0;
+	wbuf[WBUF_MASK(wp++)] = ch;
+	return 1;
+}
+
+static int xencons_write(
+	struct tty_struct *tty,
+	const unsigned char *buf,
+	int count)
+{
+	int i;
+	unsigned long flags;
+
+	spin_lock_irqsave(&xencons_lock, flags);
+
+	for (i = 0; i < count; i++)
+		if (!__xencons_put_char(buf[i]))
+			break;
+
+	if (i != 0)
+		__xencons_tx_flush();
+
+	spin_unlock_irqrestore(&xencons_lock, flags);
+
+	return i;
+}
+
+static void xencons_put_char(struct tty_struct *tty, unsigned char ch)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&xencons_lock, flags);
+	(void)__xencons_put_char(ch);
+	spin_unlock_irqrestore(&xencons_lock, flags);
+}
+
+static void xencons_flush_chars(struct tty_struct *tty)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&xencons_lock, flags);
+	__xencons_tx_flush();
+	spin_unlock_irqrestore(&xencons_lock, flags);
+}
+
+static void xencons_wait_until_sent(struct tty_struct *tty, int timeout)
+{
+	unsigned long orig_jiffies = jiffies;
+
+	while (DRV(tty->driver)->chars_in_buffer(tty)) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(1);
+		if (signal_pending(current))
+			break;
+		if (timeout && time_after(jiffies, orig_jiffies + timeout))
+			break;
+	}
+
+	set_current_state(TASK_RUNNING);
+}
+
+static int xencons_open(struct tty_struct *tty, struct file *filp)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&xencons_lock, flags);
+	tty->driver_data = NULL;
+	if (xencons_tty == NULL)
+		xencons_tty = tty;
+	__xencons_tx_flush();
+	spin_unlock_irqrestore(&xencons_lock, flags);
+
+	return 0;
+}
+
+static void xencons_close(struct tty_struct *tty, struct file *filp)
+{
+	unsigned long flags;
+
+	mutex_lock(&tty_mutex);
+
+	if (tty->count != 1) {
+		mutex_unlock(&tty_mutex);
+		return;
+	}
+
+	/* Prevent other threads from re-opening this tty. */
+	set_bit(TTY_CLOSING, &tty->flags);
+	mutex_unlock(&tty_mutex);
+
+	tty->closing = 1;
+	tty_wait_until_sent(tty, 0);
+	if (DRV(tty->driver)->flush_buffer != NULL)
+		DRV(tty->driver)->flush_buffer(tty);
+	if (tty->ldisc.flush_buffer != NULL)
+		tty->ldisc.flush_buffer(tty);
+	tty->closing = 0;
+	spin_lock_irqsave(&xencons_lock, flags);
+	xencons_tty = NULL;
+	spin_unlock_irqrestore(&xencons_lock, flags);
+}
+
+static struct tty_operations xencons_ops = {
+	.open = xencons_open,
+	.close = xencons_close,
+	.write = xencons_write,
+	.write_room = xencons_write_room,
+	.put_char = xencons_put_char,
+	.flush_chars = xencons_flush_chars,
+	.chars_in_buffer = xencons_chars_in_buffer,
+	.send_xchar = xencons_send_xchar,
+	.flush_buffer = xencons_flush_buffer,
+	.throttle = xencons_throttle,
+	.unthrottle = xencons_unthrottle,
+	.wait_until_sent = xencons_wait_until_sent,
+};
+
+static int __init xencons_init(void)
+{
+	int rc;
+
+	if (!is_running_on_xen())
+		return -ENODEV;
+
+	if (xc_disabled)
+		return 0;
+
+	if (!is_initial_xendomain()) {
+		rc = xencons_ring_init();
+		if (rc)
+			return rc;
+	}
+
+	xencons_driver = alloc_tty_driver(1);
+	if (xencons_driver == NULL)
+		return -ENOMEM;
+
+	DRV(xencons_driver)->name            = "xvc";
+	DRV(xencons_driver)->major           = XEN_XVC_MAJOR;
+	DRV(xencons_driver)->minor_start     = XEN_XVC_MINOR;
+	DRV(xencons_driver)->name_base       = xc_num;
+	DRV(xencons_driver)->type            = TTY_DRIVER_TYPE_SERIAL;
+	DRV(xencons_driver)->subtype         = SERIAL_TYPE_NORMAL;
+	DRV(xencons_driver)->init_termios    = tty_std_termios;
+	DRV(xencons_driver)->flags           =
+		TTY_DRIVER_REAL_RAW |
+		TTY_DRIVER_RESET_TERMIOS |
+		TTY_DRIVER_DYNAMIC_DEV;
+	DRV(xencons_driver)->termios         = xencons_termios;
+	DRV(xencons_driver)->termios_locked  = xencons_termios_locked;
+
+	tty_set_operations(xencons_driver, &xencons_ops);
+
+	if ((rc = tty_register_driver(DRV(xencons_driver))) != 0) {
+		printk("WARNING: Failed to register Xen virtual "
+		       "console driver as '%s%d'\n",
+		       DRV(xencons_driver)->name,
+		       DRV(xencons_driver)->name_base);
+		put_tty_driver(xencons_driver);
+		xencons_driver = NULL;
+		return rc;
+	}
+
+	if (is_initial_xendomain()) {
+		xencons_priv_irq = bind_virq_to_irqhandler(
+			VIRQ_CONSOLE,
+			0,
+			xencons_priv_interrupt,
+			0,
+			"console",
+			NULL);
+		BUG_ON(xencons_priv_irq < 0);
+	}
+
+	printk("Xen virtual console successfully installed as %s%d\n",
+	       DRV(xencons_driver)->name, xc_num);
+
+	return 0;
+}
+
+module_init(xencons_init);
diff -puN /dev/null drivers/xen/console/xencons_ring.c
--- /dev/null
+++ a/drivers/xen/console/xencons_ring.c
@@ -0,0 +1,144 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+#include <linux/serial.h>
+#include <linux/major.h>
+#include <linux/ptrace.h>
+#include <linux/ioport.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+
+#include <asm/xen/hypervisor.h>
+#include <linux/wait.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/err.h>
+#include <xen/interface/io/console.h>
+#include <xen/events.h>
+#include <xen/xencons.h>
+#include <xen/page.h>
+
+static int xencons_irq;
+
+static inline struct xencons_interface *xencons_interface(void)
+{
+	return mfn_to_virt(xen_start_info->console.domU.mfn);
+}
+
+static inline void notify_daemon(void)
+{
+	/* Use evtchn: this is called early, before irq is set up. */
+	notify_remote_via_evtchn(xen_start_info->console.domU.evtchn);
+}
+
+int xencons_ring_send(const char *data, unsigned len)
+{
+	int sent = 0;
+	struct xencons_interface *intf = xencons_interface();
+	XENCONS_RING_IDX cons, prod;
+
+	cons = intf->out_cons;
+	prod = intf->out_prod;
+	mb();
+	BUG_ON((prod - cons) > sizeof(intf->out));
+
+	while ((sent < len) && ((prod - cons) < sizeof(intf->out)))
+		intf->out[MASK_XENCONS_IDX(prod++, intf->out)] = data[sent++];
+
+	wmb();
+	intf->out_prod = prod;
+
+	notify_daemon();
+
+	return sent;
+}
+
+static irqreturn_t handle_input(int irq, void *unused)
+{
+	struct xencons_interface *intf = xencons_interface();
+	XENCONS_RING_IDX cons, prod;
+
+	cons = intf->in_cons;
+	prod = intf->in_prod;
+	mb();
+	BUG_ON((prod - cons) > sizeof(intf->in));
+
+	while (cons != prod) {
+		xencons_rx(intf->in+MASK_XENCONS_IDX(cons,intf->in), 1);
+		cons++;
+	}
+
+	mb();
+	intf->in_cons = cons;
+
+	notify_daemon();
+
+	xencons_tx();
+
+	return IRQ_HANDLED;
+}
+
+int xencons_ring_init(void)
+{
+	int irq;
+
+	if (xencons_irq)
+		unbind_from_irqhandler(xencons_irq, NULL);
+	xencons_irq = 0;
+
+	if (!is_running_on_xen() ||
+	    is_initial_xendomain() ||
+	    !xen_start_info->console.domU.evtchn)
+		return -ENODEV;
+
+	irq = bind_evtchn_to_irqhandler(
+		xen_start_info->console.domU.evtchn,
+		handle_input, 0, "xencons", NULL);
+	if (irq < 0) {
+		printk(KERN_ERR "XEN console request irq failed %i\n", irq);
+		return irq;
+	}
+
+	xencons_irq = irq;
+
+	/* In case we have in-flight data after save/restore... */
+	notify_daemon();
+
+	return 0;
+}
+
+void xencons_resume(void)
+{
+	(void)xencons_ring_init();
+}
diff -puN /dev/null include/xen/xencons.h
--- /dev/null
+++ a/include/xen/xencons.h
@@ -0,0 +1,14 @@
+#ifndef __ASM_XENCONS_H__
+#define __ASM_XENCONS_H__
+
+void xencons_force_flush(void);
+void xencons_resume(void);
+
+/* Interrupt work hooks. Receive data, or kick data out. */
+void xencons_rx(char *buf, unsigned len);
+void xencons_tx(void);
+
+int xencons_ring_init(void);
+int xencons_ring_send(const char *data, unsigned len);
+
+#endif /* __ASM_XENCONS_H__ */
diff -puN init/main.c~xen-paravirt-add-the-xen-virtual-console-driver init/main.c
--- a/init/main.c~xen-paravirt-add-the-xen-virtual-console-driver
+++ a/init/main.c
@@ -506,6 +506,8 @@ asmlinkage void __init start_kernel(void
 	unwind_init();
 	lockdep_init();
 
+	//setup_early_printk(NULL);
+
 	local_irq_disable();
 	early_boot_irqs_off();
 	early_init_irq_lock_class();
_

Patches currently in -mm which might be from jeremy@goop.org are

i386-probe_roms-cleanup.patch
no-need-to-use-traditional-for-processing-asm-in-i386-kernel.patch
xen-paravirt-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt-remove-ctor-for-pgd-cache.patch
xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment.patch
xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt-allocate-and-free-vmalloc-areas.patch
xen-paravirt-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch
xen-paravirt-add-xen-interface-header-files.patch
xen-paravirt-core-xen-implementation.patch
xen-paravirt-add-the-xen-virtual-console-driver.patch
xen-paravirt-add-xen-grant-table-support.patch
xen-paravirt-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt-add-xen-virtual-block-device-driver.patch
xen-paravirt-add-the-xen-virtual-network-device-driver.patch
uninline-jiffiesh-functions.patch
