From: akpm@linux-foundation.org
Subject: [merged] pps-serial-clients-support.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:04:17 -0400
Message-ID: <201003150704.o2F74pc4017040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759733Ab0COHFf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, greg@kroah.com, lasaine@lvk.cs.msu.su, mm-commits@vger.kernel.org


The patch titled
     pps: serial clients support
has been removed from the -mm tree.  Its filename was
     pps-serial-clients-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: serial clients support
From: Rodolfo Giometti <giometti@linux.it>

Adds support, by using the PPS line discipline, for the PPS sources
connected with the CD (Carrier Detect) pin of a serial port.

[akpm@linux-foundation.org: fix cast size warnings]
Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/Kconfig     |    7 +
 drivers/pps/clients/Makefile    |    1 
 drivers/pps/clients/pps-ldisc.c |  154 ++++++++++++++++++++++++++++++
 include/linux/serial_core.h     |   11 +-
 4 files changed, 172 insertions(+), 1 deletion(-)

diff -puN drivers/pps/clients/Kconfig~pps-serial-clients-support drivers/pps/clients/Kconfig
--- a/drivers/pps/clients/Kconfig~pps-serial-clients-support
+++ a/drivers/pps/clients/Kconfig
@@ -15,4 +15,11 @@ config PPS_CLIENT_KTIMER
 	  This driver can also be built as a module.  If so, the module
 	  will be called pps-ktimer.
 
+config PPS_CLIENT_LDISC
+	tristate "PPS line discipline"
+	depends on PPS
+	help
+	  If you say yes here you get support for a PPS source connected
+	  with the CD (Carrier Detect) pin of your serial port.
+
 endif
diff -puN drivers/pps/clients/Makefile~pps-serial-clients-support drivers/pps/clients/Makefile
--- a/drivers/pps/clients/Makefile~pps-serial-clients-support
+++ a/drivers/pps/clients/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_PPS_CLIENT_KTIMER)	+= pps-ktimer.o
+obj-$(CONFIG_PPS_CLIENT_LDISC)	+= pps-ldisc.o
 
 ifeq ($(CONFIG_PPS_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
diff -puN /dev/null drivers/pps/clients/pps-ldisc.c
--- /dev/null
+++ a/drivers/pps/clients/pps-ldisc.c
@@ -0,0 +1,154 @@
+/*
+ * pps-ldisc.c -- PPS line discipline
+ *
+ *
+ * Copyright (C) 2008	Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/serial_core.h>
+#include <linux/tty.h>
+#include <linux/pps_kernel.h>
+
+#define PPS_TTY_MAGIC		0x0001
+
+static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
+				struct timespec *ts)
+{
+	int id = (long)tty->disc_data;
+	struct timespec __ts;
+	struct pps_ktime pps_ts;
+
+	/* First of all we get the time stamp... */
+	getnstimeofday(&__ts);
+
+	/* Does caller give us a timestamp? */
+	if (ts) {	/* Yes. Let's use it! */
+		pps_ts.sec = ts->tv_sec;
+		pps_ts.nsec = ts->tv_nsec;
+	} else {	/* No. Do it ourself! */
+		pps_ts.sec = __ts.tv_sec;
+		pps_ts.nsec = __ts.tv_nsec;
+	}
+
+	/* Now do the PPS event report */
+	pps_event(id, &pps_ts, status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR,
+			NULL);
+
+	pr_debug("PPS %s at %lu on source #%d\n",
+			status ? "assert" : "clear", jiffies, id);
+}
+
+static int (*alias_n_tty_open)(struct tty_struct *tty);
+
+static int pps_tty_open(struct tty_struct *tty)
+{
+	struct pps_source_info info;
+	struct tty_driver *drv = tty->driver;
+	int index = tty->index + drv->name_base;
+	int ret;
+
+	info.owner = THIS_MODULE;
+	info.dev = NULL;
+	snprintf(info.name, PPS_MAX_NAME_LEN, "%s%d", drv->driver_name, index);
+	snprintf(info.path, PPS_MAX_NAME_LEN, "/dev/%s%d", drv->name, index);
+	info.mode = PPS_CAPTUREBOTH | \
+			PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
+			PPS_CANWAIT | PPS_TSFMT_TSPEC;
+
+	ret = pps_register_source(&info, PPS_CAPTUREBOTH | \
+				PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
+	if (ret < 0) {
+		pr_err("cannot register PPS source \"%s\"\n", info.path);
+		return ret;
+	}
+	tty->disc_data = (void *)(long)ret;
+
+	/* Should open N_TTY ldisc too */
+	ret = alias_n_tty_open(tty);
+	if (ret < 0)
+		pps_unregister_source((long)tty->disc_data);
+
+	pr_info("PPS source #%d \"%s\" added\n", ret, info.path);
+
+	return 0;
+}
+
+static void (*alias_n_tty_close)(struct tty_struct *tty);
+
+static void pps_tty_close(struct tty_struct *tty)
+{
+	int id = (long)tty->disc_data;
+
+	pps_unregister_source(id);
+	alias_n_tty_close(tty);
+
+	pr_info("PPS source #%d removed\n", id);
+}
+
+static struct tty_ldisc_ops pps_ldisc_ops;
+
+/*
+ * Module stuff
+ */
+
+static int __init pps_tty_init(void)
+{
+	int err;
+
+	/* Inherit the N_TTY's ops */
+	n_tty_inherit_ops(&pps_ldisc_ops);
+
+	/* Save N_TTY's open()/close() methods */
+	alias_n_tty_open = pps_ldisc_ops.open;
+	alias_n_tty_close = pps_ldisc_ops.close;
+
+	/* Init PPS_TTY data */
+	pps_ldisc_ops.owner = THIS_MODULE;
+	pps_ldisc_ops.magic = PPS_TTY_MAGIC;
+	pps_ldisc_ops.name = "pps_tty";
+	pps_ldisc_ops.dcd_change = pps_tty_dcd_change;
+	pps_ldisc_ops.open = pps_tty_open;
+	pps_ldisc_ops.close = pps_tty_close;
+
+	err = tty_register_ldisc(N_PPS, &pps_ldisc_ops);
+	if (err)
+		pr_err("can't register PPS line discipline\n");
+	else
+		pr_info("PPS line discipline registered\n");
+
+	return err;
+}
+
+static void __exit pps_tty_cleanup(void)
+{
+	int err;
+
+	err = tty_unregister_ldisc(N_PPS);
+	if (err)
+		pr_err("can't unregister PPS line discipline\n");
+	else
+		pr_info("PPS line discipline removed\n");
+}
+
+module_init(pps_tty_init);
+module_exit(pps_tty_cleanup);
+
+MODULE_ALIAS_LDISC(N_PPS);
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("PPS TTY device driver");
+MODULE_LICENSE("GPL");
diff -puN include/linux/serial_core.h~pps-serial-clients-support include/linux/serial_core.h
--- a/include/linux/serial_core.h~pps-serial-clients-support
+++ a/include/linux/serial_core.h
@@ -491,9 +491,13 @@ uart_handle_dcd_change(struct uart_port 
 {
 	struct uart_state *state = uport->state;
 	struct tty_port *port = &state->port;
+	struct tty_ldisc *ld = tty_ldisc_ref(port->tty);
+	struct timespec ts;
 
-	uport->icount.dcd++;
+	if (ld && ld->ops->dcd_change)
+		getnstimeofday(&ts);
 
+	uport->icount.dcd++;
 #ifdef CONFIG_HARD_PPS
 	if ((uport->flags & UPF_HARDPPS_CD) && status)
 		hardpps();
@@ -505,6 +509,11 @@ uart_handle_dcd_change(struct uart_port 
 		else if (port->tty)
 			tty_hangup(port->tty);
 	}
+
+	if (ld && ld->ops->dcd_change)
+		ld->ops->dcd_change(port->tty, status, &ts);
+	if (ld)
+		tty_ldisc_deref(ld);
 }
 
 /**
_

Patches currently in -mm which might be from giometti@linux.it are

origin.patch

