From: akpm@linux-foundation.org
Subject: [to-be-updated] pps-parallel-port-clients-support.patch removed from -mm tree
Date: Mon, 02 Feb 2009 23:42:11 -0800
Message-ID: <200902030742.n137gBZO013764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302AbZBCHnR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 02:43:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, alan@lxorguk.ukuu.org.uk, davej@redhat.com, dwmw2@infradead.org, greg@kroah.com, hpa@zytor.com, kay.sievers@vrfy.org, mingo@elte.hu, mtk.manpages@gmail.com, randy.d


The patch titled
     PPS: parallel port clients support
has been removed from the -mm tree.  Its filename was
     pps-parallel-port-clients-support.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PPS: parallel port clients support
From: Rodolfo Giometti <giometti@linux.it>

Adds support for the PPS sources connected with the interrupt pin of a
parallel port.

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
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/lp.c           |   61 ++++++++++++++++++++++++++++++++++
 drivers/pps/clients/Kconfig |   10 +++++
 include/linux/parport.h     |   22 ++++++++++++
 3 files changed, 93 insertions(+)

diff -puN drivers/char/lp.c~pps-parallel-port-clients-support drivers/char/lp.c
--- a/drivers/char/lp.c~pps-parallel-port-clients-support
+++ a/drivers/char/lp.c
@@ -760,6 +760,27 @@ static struct console lpcons = {
 
 #endif /* console on line printer */
 
+/* Support for PPS signal on the line printer */
+
+#ifdef CONFIG_PPS_CLIENT_LP
+
+static void lp_pps_echo(int source, int event, void *data)
+{
+	struct parport *port = data;
+	unsigned char status = parport_read_status(port);
+
+	/* echo event via SEL bit */
+	parport_write_control(port,
+		parport_read_control(port) | PARPORT_CONTROL_SELECT);
+
+	/* signal no event */
+	if ((status & PARPORT_STATUS_ACK) != 0)
+		parport_write_control(port,
+			parport_read_control(port) & ~PARPORT_CONTROL_SELECT);
+}
+
+#endif
+
 /* --- initialisation code ------------------------------------- */
 
 static int parport_nr[LP_NO] = { [0 ... LP_NO-1] = LP_PARPORT_UNSPEC };
@@ -831,6 +852,38 @@ static int lp_register(int nr, struct pa
 	}
 #endif
 
+#ifdef CONFIG_PPS_CLIENT_LP
+	port->pps_info.owner = THIS_MODULE;
+	port->pps_info.dev = port->dev;
+	snprintf(port->pps_info.path, PPS_MAX_NAME_LEN, "/dev/lp%d", nr);
+
+	/* No PPS support if lp port has no IRQ line */
+	if (port->irq != PARPORT_IRQ_NONE) {
+		strncpy(port->pps_info.name, port->name, PPS_MAX_NAME_LEN);
+
+		port->pps_info.mode = PPS_CAPTUREASSERT | PPS_OFFSETASSERT | \
+				PPS_ECHOASSERT | \
+				PPS_CANWAIT | PPS_TSFMT_TSPEC;
+
+		port->pps_info.echo = lp_pps_echo;
+
+		port->pps_source = pps_register_source(&(port->pps_info),
+				PPS_CAPTUREASSERT | PPS_OFFSETASSERT);
+		if (port->pps_source < 0)
+			dev_err(port->dev,
+					"cannot register PPS source \"%s\"\n",
+					port->pps_info.path);
+		else
+			dev_info(port->dev, "PPS source #%d \"%s\" added\n",
+					port->pps_source, port->pps_info.path);
+	} else {
+		port->pps_source = -1;
+		dev_err(port->dev, "PPS support disabled because port \"%s\" "
+					"is in polling mode\n",
+					port->pps_info.path);
+	}
+#endif
+
 	return 0;
 }
 
@@ -873,6 +926,14 @@ static void lp_detach (struct parport *p
 		console_registered = NULL;
 	}
 #endif /* CONFIG_LP_CONSOLE */
+
+#ifdef CONFIG_PPS_CLIENT_LP
+	if (port->pps_source >= 0) {
+		pps_unregister_source(port->pps_source);
+		dev_dbg(port->dev, "PPS source #%d \"%s\" removed\n",
+			port->pps_source, port->pps_info.path);
+	}
+#endif
 }
 
 static struct parport_driver lp_driver = {
diff -puN drivers/pps/clients/Kconfig~pps-parallel-port-clients-support drivers/pps/clients/Kconfig
--- a/drivers/pps/clients/Kconfig~pps-parallel-port-clients-support
+++ a/drivers/pps/clients/Kconfig
@@ -15,4 +15,14 @@ config PPS_CLIENT_KTIMER
 	  This driver can also be built as a module.  If so, the module
 	  will be called ktimer.ko.
 
+comment "Parallel printer support (forced off)"
+	depends on !( PRINTER != n && !(PPS = m && PRINTER = y))
+
+config PPS_CLIENT_LP
+	bool "Parallel printer support"
+	depends on PRINTER != n && !(PPS = m && PRINTER = y)
+	help
+	  If you say yes here you get support for a PPS source connected
+	  with the interrupt pin of your parallel port.
+
 endif
diff -puN include/linux/parport.h~pps-parallel-port-clients-support include/linux/parport.h
--- a/include/linux/parport.h~pps-parallel-port-clients-support
+++ a/include/linux/parport.h
@@ -98,6 +98,7 @@ typedef enum {
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
+#include <linux/pps.h>
 #include <linux/irqreturn.h>
 #include <linux/semaphore.h>
 #include <asm/system.h>
@@ -326,6 +327,11 @@ struct parport {
 
 	struct list_head full_list;
 	struct parport *slaves[3];
+
+#ifdef CONFIG_PPS_CLIENT_LP
+	struct pps_source_info pps_info;
+	int pps_source;		/* PPS source ID */
+#endif
 };
 
 #define DEFAULT_SPIN_TIME 500 /* us */
@@ -514,6 +520,22 @@ extern int parport_daisy_select (struct 
 /* Lowlevel drivers _can_ call this support function to handle irqs.  */
 static inline void parport_generic_irq(struct parport *port)
 {
+#ifdef CONFIG_PPS_CLIENT_LP
+	struct timespec __ts;
+	struct pps_ktime ts;
+
+	/* First of all we get the time stamp... */
+	getnstimeofday(&__ts);
+
+	/* ... and translate it to PPS time data struct */
+	ts.sec = __ts.tv_sec;
+	ts.nsec = __ts.tv_nsec;
+
+	pps_event(port->pps_source, &ts, PPS_CAPTUREASSERT, port);
+	dev_dbg(port->dev, "PPS assert at %lu on source #%d\n",
+		jiffies, port->pps_source);
+#endif
+
 	parport_ieee1284_interrupt (port);
 	read_lock(&port->cad_lock);
 	if (port->cad && port->cad->irq_func)
_

Patches currently in -mm which might be from giometti@linux.it are

pps-parallel-port-clients-support.patch

