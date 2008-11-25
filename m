From: akpm@linux-foundation.org
Subject: + pps-serial-clients-support.patch added to -mm tree
Date: Tue, 25 Nov 2008 14:35:52 -0800
Message-ID: <200811252235.mAPMZrgd016470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751760AbYKYWho (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 17:37:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it, alan@lxorguk.ukuu.org.uk, davej@redhat.com, dwmw2@infradead.org, greg@kroah.com, hpa@zytor.com, kay.sievers@vrfy.org, mingo@elte.hu, mtk.manpages@googlemail.com, randy.dunlap@oracle.com, sam@ravnborg.org, zippel@linux-m68k.org


The patch titled
     PPS: serial clients support
has been added to the -mm tree.  Its filename is
     pps-serial-clients-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PPS: serial clients support
From: Rodolfo Giometti <giometti@linux.it>

Adds support, by using the PPS line discipline, for the PPS sources
connected with the CD (Carrier Detect) pin of a serial port.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/Kconfig     |    7 +
 drivers/pps/clients/Makefile    |    1 
 drivers/pps/clients/pps-ldisc.c |  155 ++++++++++++++++++++++++++++++
 drivers/serial/8250.c           |   13 ++
 include/linux/serial_core.h     |   11 +-
 5 files changed, 186 insertions(+), 1 deletion(-)

diff -puN drivers/pps/clients/Kconfig~pps-serial-clients-support drivers/pps/clients/Kconfig
--- a/drivers/pps/clients/Kconfig~pps-serial-clients-support
+++ a/drivers/pps/clients/Kconfig
@@ -15,4 +15,11 @@ config PPS_CLIENT_KTIMER
 	  This driver can also be built as a module.  If so, the module
 	  will be called ktimer.ko.
 
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
 
 obj-$(CONFIG_PPS_CLIENT_KTIMER)	+= ktimer.o
+obj-$(CONFIG_PPS_CLIENT_LDISC)	+= pps-ldisc.o
 
 ifeq ($(CONFIG_PPS_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
diff -puN /dev/null drivers/pps/clients/pps-ldisc.c
--- /dev/null
+++ a/drivers/pps/clients/pps-ldisc.c
@@ -0,0 +1,155 @@
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
+#include <linux/pps.h>
+
+#define PPS_TTY_MAGIC		0x0001
+
+static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
+				struct timespec *ts)
+{
+	int id = (int) tty->disc_data;
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
+	tty->disc_data = (void *) ret;
+
+	/* Should open N_TTY ldisc too */
+	ret = n_tty_open(tty);
+	if (ret < 0)
+		pps_unregister_source((int) tty->disc_data);
+
+	pr_info("PPS source #%d \"%s\" added\n", ret, info.path);
+
+	return 0;
+}
+
+static void pps_tty_close(struct tty_struct *tty)
+{
+	int id = (int) tty->disc_data;
+
+	pps_unregister_source(id);
+	n_tty_close(tty);
+
+	pr_info("PPS source #%d removed\n", id);
+}
+
+struct tty_ldisc_ops pps_ldisc_ops = {
+	.owner		= THIS_MODULE,
+	.magic		= PPS_TTY_MAGIC,
+	.name		= "pps_tty",
+	.dcd_change	= pps_tty_dcd_change,
+	.open		= pps_tty_open,
+	.close		= pps_tty_close,
+
+	/* Now we should use N_TTY ldisc methods in order to have
+	 * normal tty behaviour
+	 */
+	.flush_buffer	= n_tty_flush_buffer,
+	.chars_in_buffer = n_tty_chars_in_buffer,
+	.read		= n_tty_read,
+	.write		= n_tty_write,
+	.ioctl		= n_tty_ioctl_helper,
+	.set_termios	= n_tty_set_termios,
+	.poll		= n_tty_poll,
+	.receive_buf	= n_tty_receive_buf,
+	.write_wakeup	= n_tty_write_wakeup
+};
+
+/*
+ * Module stuff
+ */
+
+static int __init pps_tty_init(void)
+{
+	int err;
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
diff -puN drivers/serial/8250.c~pps-serial-clients-support drivers/serial/8250.c
--- a/drivers/serial/8250.c~pps-serial-clients-support
+++ a/drivers/serial/8250.c
@@ -2313,6 +2313,18 @@ serial8250_set_termios(struct uart_port 
 }
 
 static void
+serial8250_set_ldisc(struct uart_port *port)
+{
+	int line = port->line;
+
+	if (line >= port->info->port.tty->driver->num)
+		return;
+
+	if (port->info->port.tty->ldisc.ops->num == N_PPS)
+		serial8250_enable_ms(port);
+}
+
+static void
 serial8250_pm(struct uart_port *port, unsigned int state,
 	      unsigned int oldstate)
 {
@@ -2523,6 +2535,7 @@ static struct uart_ops serial8250_pops =
 	.startup	= serial8250_startup,
 	.shutdown	= serial8250_shutdown,
 	.set_termios	= serial8250_set_termios,
+	.set_ldisc	= serial8250_set_ldisc,
 	.pm		= serial8250_pm,
 	.type		= serial8250_type,
 	.release_port	= serial8250_release_port,
diff -puN include/linux/serial_core.h~pps-serial-clients-support include/linux/serial_core.h
--- a/include/linux/serial_core.h~pps-serial-clients-support
+++ a/include/linux/serial_core.h
@@ -497,9 +497,13 @@ static inline void
 uart_handle_dcd_change(struct uart_port *port, unsigned int status)
 {
 	struct uart_info *info = port->info;
+	struct tty_ldisc *ld = tty_ldisc_ref(info->port.tty);
+	struct timespec ts;
 
-	port->icount.dcd++;
+	if (ld && ld->ops->dcd_change)
+		getnstimeofday(&ts);
 
+	port->icount.dcd++;
 #ifdef CONFIG_HARD_PPS
 	if ((port->flags & UPF_HARDPPS_CD) && status)
 		hardpps();
@@ -511,6 +515,11 @@ uart_handle_dcd_change(struct uart_port 
 		else if (info->port.tty)
 			tty_hangup(info->port.tty);
 	}
+
+	if (ld && ld->ops->dcd_change)
+		ld->ops->dcd_change(port, status, &ts);
+	if (ld)
+		tty_ldisc_deref(ld);
 }
 
 /**
_

Patches currently in -mm which might be from giometti@linux.it are

linux-next.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods.patch
pps-serial-clients-support.patch
pps-parallel-port-clients-support.patch
pps-low-level-irq-timestamps-recording.patch

