From: akpm@linux-foundation.org
Subject: [folded] pps-linuxpps-clients-support-v3.patch removed from -mm tree
Date: Wed, 10 Mar 2010 15:05:29 -0800
Message-ID: <201003102305.o2AN5TOj009247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932856Ab0CJXF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 18:05:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     From: Rodolfo Giometti <giometti@linux.it>
has been removed from the -mm tree.  Its filename was
     pps-linuxpps-clients-support-v3.patch

This patch was dropped because it was folded into pps-linuxpps-clients-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: From: Rodolfo Giometti <giometti@linux.it>


Each PPS source can be registered/deregistered into the system by
using special modules called "clients". They simply define the PPS
sources' attributes and implement the time signal registartion
mechanism.

This patch adds a special directory for such clients and adds a dummy
client that can be useful to test system integrity on real systems.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 create mode 100644 drivers/pps/clients/Kconfig
 create mode 100644 drivers/pps/clients/Makefile
 create mode 100644 drivers/pps/clients/pps-ktimer.c

index cc2eb8e..1afe4e0 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/Kconfig      |    2 
 drivers/pps/clients/Makefile     |    2 
 drivers/pps/clients/ktimer.c     |  123 -----------------------------
 drivers/pps/clients/pps-ktimer.c |  123 +++++++++++++++++++++++++++++
 4 files changed, 125 insertions(+), 125 deletions(-)

diff -puN drivers/pps/clients/Kconfig~pps-linuxpps-clients-support-v3 drivers/pps/clients/Kconfig
--- a/drivers/pps/clients/Kconfig~pps-linuxpps-clients-support-v3
+++ a/drivers/pps/clients/Kconfig
@@ -13,6 +13,6 @@ config PPS_CLIENT_KTIMER
 	  which uses a kernel timer to generate the PPS signal.
 
 	  This driver can also be built as a module.  If so, the module
-	  will be called ktimer.
+	  will be called pps-ktimer.
 
 endif
diff -puN drivers/pps/clients/Makefile~pps-linuxpps-clients-support-v3 drivers/pps/clients/Makefile
--- a/drivers/pps/clients/Makefile~pps-linuxpps-clients-support-v3
+++ a/drivers/pps/clients/Makefile
@@ -2,7 +2,7 @@
 # Makefile for PPS clients.
 #
 
-obj-$(CONFIG_PPS_CLIENT_KTIMER)	+= ktimer.o
+obj-$(CONFIG_PPS_CLIENT_KTIMER)	+= pps-ktimer.o
 
 ifeq ($(CONFIG_PPS_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
diff -puN drivers/pps/clients/ktimer.c~pps-linuxpps-clients-support-v3 /dev/null
--- a/drivers/pps/clients/ktimer.c
+++ /dev/null
@@ -1,123 +0,0 @@
-/*
- * ktimer.c -- kernel timer test client
- *
- *
- * Copyright (C) 2005-2006   Rodolfo Giometti <giometti@linux.it>
- *
- *   This program is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License as published by
- *   the Free Software Foundation; either version 2 of the License, or
- *   (at your option) any later version.
- *
- *   This program is distributed in the hope that it will be useful,
- *   but WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *   GNU General Public License for more details.
- *
- *   You should have received a copy of the GNU General Public License
- *   along with this program; if not, write to the Free Software
- *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/time.h>
-#include <linux/timer.h>
-#include <linux/pps_kernel.h>
-
-/*
- * Global variables
- */
-
-static int source;
-static struct timer_list ktimer;
-
-/*
- * The kernel timer
- */
-
-static void pps_ktimer_event(unsigned long ptr)
-{
-	struct timespec __ts;
-	struct pps_ktime ts;
-
-	/* First of all we get the time stamp... */
-	getnstimeofday(&__ts);
-
-	pr_info("PPS event at %lu\n", jiffies);
-
-	/* ... and translate it to PPS time data struct */
-	ts.sec = __ts.tv_sec;
-	ts.nsec = __ts.tv_nsec;
-
-	pps_event(source, &ts, PPS_CAPTUREASSERT, NULL);
-
-	mod_timer(&ktimer, jiffies + HZ);
-}
-
-/*
- * The echo function
- */
-
-static void pps_ktimer_echo(int source, int event, void *data)
-{
-	pr_info("echo %s %s for source %d\n",
-		event & PPS_CAPTUREASSERT ? "assert" : "",
-		event & PPS_CAPTURECLEAR ? "clear" : "",
-		source);
-}
-
-/*
- * The PPS info struct
- */
-
-static struct pps_source_info pps_ktimer_info = {
-	.name		= "ktimer",
-	.path		= "",
-	.mode		= PPS_CAPTUREASSERT | PPS_OFFSETASSERT | \
-			  PPS_ECHOASSERT | \
-			  PPS_CANWAIT | PPS_TSFMT_TSPEC,
-	.echo 		= pps_ktimer_echo,
-	.owner		= THIS_MODULE,
-};
-
-/*
- * Module staff
- */
-
-static void __exit pps_ktimer_exit(void)
-{
-	del_timer_sync(&ktimer);
-	pps_unregister_source(source);
-
-	pr_info("ktimer PPS source unregistered\n");
-}
-
-static int __init pps_ktimer_init(void)
-{
-	int ret;
-
-	ret = pps_register_source(&pps_ktimer_info,
-				PPS_CAPTUREASSERT | PPS_OFFSETASSERT);
-	if (ret < 0) {
-		printk(KERN_ERR "cannot register ktimer source\n");
-		return ret;
-	}
-	source = ret;
-
-	setup_timer(&ktimer, pps_ktimer_event, 0);
-	mod_timer(&ktimer, jiffies + HZ);
-
-	pr_info("ktimer PPS source registered at %d\n", source);
-
-	return  0;
-}
-
-module_init(pps_ktimer_init);
-module_exit(pps_ktimer_exit);
-
-MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
-MODULE_DESCRIPTION("dummy PPS source by using a kernel timer (just for debug)");
-MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/pps/clients/pps-ktimer.c
--- /dev/null
+++ a/drivers/pps/clients/pps-ktimer.c
@@ -0,0 +1,123 @@
+/*
+ * pps-ktimer.c -- kernel timer test client
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
+#include <linux/pps_kernel.h>
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
+	.mode		= PPS_CAPTUREASSERT | PPS_OFFSETASSERT |
+			  PPS_ECHOASSERT |
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
pps-linuxpps-clients-support-v3.patch
pps-linuxpps-clients-support-v3-checkpatch-fixes.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-add-new-method-n_tty_inherit_ops.patch
ldisc-n_tty-add-new-method-n_tty_inherit_ops-update.patch
pps-serial-clients-support.patch
pps-serial-clients-support-warning-fixes.patch
serial-8250-enable-pps-support.patch
serial-amba-pl010-enable-pps-support.patch

