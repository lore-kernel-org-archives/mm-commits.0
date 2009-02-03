From: akpm@linux-foundation.org
Subject: [to-be-updated] pps-linuxpps-clients-support.patch removed from -mm tree
Date: Mon, 02 Feb 2009 23:42:07 -0800
Message-ID: <200902030742.n137g7ZP013722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbZBCHnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 02:43:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, alan@lxorguk.ukuu.org.uk, davej@redhat.com, dwmw2@infradead.org, greg@kroah.com, hpa@zytor.com, kay.sievers@vrfy.org, mingo@elte.hu, mtk.manpages@gmail.com, randy.d


The patch titled
     PPS: LinuxPPS clients support
has been removed from the -mm tree.  Its filename was
     pps-linuxpps-clients-support.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PPS: LinuxPPS clients support
From: Rodolfo Giometti <giometti@linux.it>

Each PPS source can be registered/deregistered into the system by using
special modules called "clients".  They simply define the PPS sources'
attributes and implement the time signal registartion mechanism.

This patch adds a special directory for such clients and adds a dummy
client that can be useful to test system integrity on real systems.

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

 drivers/pps/Kconfig          |    2 
 drivers/pps/Makefile         |    1 
 drivers/pps/clients/Kconfig  |   18 ++++
 drivers/pps/clients/Makefile |    9 ++
 drivers/pps/clients/ktimer.c |  124 +++++++++++++++++++++++++++++++++
 5 files changed, 154 insertions(+)

diff -puN drivers/pps/Kconfig~pps-linuxpps-clients-support drivers/pps/Kconfig
--- a/drivers/pps/Kconfig~pps-linuxpps-clients-support
+++ a/drivers/pps/Kconfig
@@ -30,4 +30,6 @@ config PPS_DEBUG
 	  messages to the system log.  Select this if you are having a
 	  problem with PPS support and want to see more of what is going on.
 
+source drivers/pps/clients/Kconfig
+
 endmenu
diff -puN drivers/pps/Makefile~pps-linuxpps-clients-support drivers/pps/Makefile
--- a/drivers/pps/Makefile~pps-linuxpps-clients-support
+++ a/drivers/pps/Makefile
@@ -4,5 +4,6 @@
 
 pps_core-y			:= pps.o kapi.o sysfs.o
 obj-$(CONFIG_PPS)		:= pps_core.o
+obj-y				+= clients/
 
 ccflags-$(CONFIG_PPS_DEBUG) := -DDEBUG
diff -puN /dev/null drivers/pps/clients/Kconfig
--- /dev/null
+++ a/drivers/pps/clients/Kconfig
@@ -0,0 +1,18 @@
+#
+# PPS clients configuration
+#
+
+if PPS
+
+comment "PPS clients support"
+
+config PPS_CLIENT_KTIMER
+	tristate "Kernel timer client (Testing client, use for debug)"
+	help
+	  If you say yes here you get support for a PPS debugging client
+	  which uses a kernel timer to generate the PPS signal.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called ktimer.ko.
+
+endif
diff -puN /dev/null drivers/pps/clients/Makefile
--- /dev/null
+++ a/drivers/pps/clients/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for PPS clients.
+#
+
+obj-$(CONFIG_PPS_CLIENT_KTIMER)	+= ktimer.o
+
+ifeq ($(CONFIG_PPS_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
diff -puN /dev/null drivers/pps/clients/ktimer.c
--- /dev/null
+++ a/drivers/pps/clients/ktimer.c
@@ -0,0 +1,124 @@
+/*
+ * ktimer.c -- kernel timer test client
+ *
+ *
+ * Copyright (C) 2005-2006   Rodolfo Giometti <giometti@linux.it>
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
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/time.h>
+#include <linux/timer.h>
+
+#include <linux/pps.h>
+
+/*
+ * Global variables
+ */
+
+static int source;
+static struct timer_list ktimer;
+
+/*
+ * The kernel timer
+ */
+
+static void pps_ktimer_event(unsigned long ptr)
+{
+	struct timespec __ts;
+	struct pps_ktime ts;
+
+	/* First of all we get the time stamp... */
+	getnstimeofday(&__ts);
+
+	pr_info("PPS event at %lu\n", jiffies);
+
+	/* ... and translate it to PPS time data struct */
+	ts.sec = __ts.tv_sec;
+	ts.nsec = __ts.tv_nsec;
+
+	pps_event(source, &ts, PPS_CAPTUREASSERT, NULL);
+
+	mod_timer(&ktimer, jiffies + HZ);
+}
+
+/*
+ * The echo function
+ */
+
+static void pps_ktimer_echo(int source, int event, void *data)
+{
+	pr_info("echo %s %s for source %d\n",
+		event & PPS_CAPTUREASSERT ? "assert" : "",
+		event & PPS_CAPTURECLEAR ? "clear" : "",
+		source);
+}
+
+/*
+ * The PPS info struct
+ */
+
+static struct pps_source_info pps_ktimer_info = {
+	.name		= "ktimer",
+	.path		= "",
+	.mode		= PPS_CAPTUREASSERT | PPS_OFFSETASSERT | \
+			  PPS_ECHOASSERT | \
+			  PPS_CANWAIT | PPS_TSFMT_TSPEC,
+	.echo 		= pps_ktimer_echo,
+	.owner		= THIS_MODULE,
+};
+
+/*
+ * Module staff
+ */
+
+static void __exit pps_ktimer_exit(void)
+{
+	del_timer_sync(&ktimer);
+	pps_unregister_source(source);
+
+	pr_info("ktimer PPS source unregistered\n");
+}
+
+static int __init pps_ktimer_init(void)
+{
+	int ret;
+
+	ret = pps_register_source(&pps_ktimer_info,
+				PPS_CAPTUREASSERT | PPS_OFFSETASSERT);
+	if (ret < 0) {
+		printk(KERN_ERR "cannot register ktimer source\n");
+		return ret;
+	}
+	source = ret;
+
+	setup_timer(&ktimer, pps_ktimer_event, 0);
+	mod_timer(&ktimer, jiffies + HZ);
+
+	pr_info("ktimer PPS source registered at %d\n", source);
+
+	return  0;
+}
+
+module_init(pps_ktimer_init);
+module_exit(pps_ktimer_exit);
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("dummy PPS source by using a kernel timer (just for debug)");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from giometti@linux.it are

pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

