From: akpm@linux-foundation.org
Subject: [folded] pps-add-kernel-consumer-support-v7.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:26:54 -0800
Message-ID: <201101130026.p0D0QsDn012441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756402Ab1AMA1H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:27:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasaine@lvk.cs.msu.su, giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     pps: add kernel consumer support
has been removed from the -mm tree.  Its filename was
     pps-add-kernel-consumer-support-v7.patch

This patch was dropped because it was folded into pps-add-kernel-consumer-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: add kernel consumer support
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Add an optional feature of PPSAPI, kernel consumer support, which uses
the added hardpps() function.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/Kconfig        |    1 
 drivers/pps/Makefile       |    1 
 drivers/pps/kapi.c         |   27 -------
 drivers/pps/kc.c           |  123 +++++++++++++++++++++++++++++++++++
 drivers/pps/kc.h           |   47 +++++++++++++
 drivers/pps/pps.c          |   34 +--------
 include/linux/pps_kernel.h |    6 -
 7 files changed, 179 insertions(+), 60 deletions(-)

diff -puN drivers/pps/Kconfig~pps-add-kernel-consumer-support-v7 drivers/pps/Kconfig
--- a/drivers/pps/Kconfig~pps-add-kernel-consumer-support-v7
+++ a/drivers/pps/Kconfig
@@ -7,7 +7,6 @@ menu "PPS support"
 config PPS
 	tristate "PPS support"
 	depends on EXPERIMENTAL
-	select NTP_PPS
 	---help---
 	  PPS (Pulse Per Second) is a special pulse provided by some GPS
 	  antennae. Userland can use it to get a high-precision time
diff -puN drivers/pps/Makefile~pps-add-kernel-consumer-support-v7 drivers/pps/Makefile
--- a/drivers/pps/Makefile~pps-add-kernel-consumer-support-v7
+++ a/drivers/pps/Makefile
@@ -3,6 +3,7 @@
 #
 
 pps_core-y			:= pps.o kapi.o sysfs.o
+pps_core-$(CONFIG_NTP_PPS)	+= kc.o
 obj-$(CONFIG_PPS)		:= pps_core.o
 obj-y				+= clients/
 
diff -puN drivers/pps/kapi.c~pps-add-kernel-consumer-support-v7 drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-add-kernel-consumer-support-v7
+++ a/drivers/pps/kapi.c
@@ -32,15 +32,7 @@
 #include <linux/pps_kernel.h>
 #include <linux/slab.h>
 
-/*
- * Global variables
- */
-
-/* state variables to bind kernel consumer */
-/* PPS API (RFC 2783): current source and mode for ``kernel consumer'' */
-DEFINE_SPINLOCK(pps_kc_hardpps_lock);
-void	*pps_kc_hardpps_dev;	/* some unique pointer to device */
-int	pps_kc_hardpps_mode;	/* mode bits for kernel consumer */
+#include "kc.h"
 
 /*
  * Local functions
@@ -150,16 +142,7 @@ EXPORT_SYMBOL(pps_register_source);
 
 void pps_unregister_source(struct pps_device *pps)
 {
-	spin_lock_irq(&pps_kc_hardpps_lock);
-	if (pps == pps_kc_hardpps_dev) {
-		pps_kc_hardpps_mode = 0;
-		pps_kc_hardpps_dev = NULL;
-		spin_unlock_irq(&pps_kc_hardpps_lock);
-		dev_info(pps->dev, "unbound kernel consumer"
-				" on device removal\n");
-	} else
-		spin_unlock_irq(&pps_kc_hardpps_lock);
-
+	pps_kc_remove(pps);
 	pps_unregister_cdev(pps);
 
 	/* don't have to kfree(pps) here because it will be done on
@@ -232,11 +215,7 @@ void pps_event(struct pps_device *pps, s
 		captured = ~0;
 	}
 
-	/* Pass some events to kernel consumer if activated */
-	spin_lock(&pps_kc_hardpps_lock);
-	if (pps == pps_kc_hardpps_dev && event & pps_kc_hardpps_mode)
-		hardpps(&ts->ts_real, &ts->ts_raw);
-	spin_unlock(&pps_kc_hardpps_lock);
+	pps_kc_event(pps, ts, event);
 
 	/* Wake up if captured something */
 	if (captured) {
diff -puN /dev/null drivers/pps/kc.c
--- /dev/null
+++ a/drivers/pps/kc.c
@@ -0,0 +1,123 @@
+/*
+ * PPS kernel consumer API
+ *
+ * Copyright (C) 2009-2010   Alexander Gordeev <lasaine@lvk.cs.msu.su>
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
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/pps_kernel.h>
+
+#include "kc.h"
+
+/*
+ * Global variables
+ */
+
+/* state variables to bind kernel consumer */
+DEFINE_SPINLOCK(pps_kc_hardpps_lock);
+/* PPS API (RFC 2783): current source and mode for kernel consumer */
+struct pps_device *pps_kc_hardpps_dev;	/* unique pointer to device */
+int pps_kc_hardpps_mode;		/* mode bits for kernel consumer */
+
+/* pps_kc_bind - control PPS kernel consumer binding
+ * @pps: the PPS source
+ * @bind_args: kernel consumer bind parameters
+ *
+ * This function is used to bind or unbind PPS kernel consumer according to
+ * supplied parameters. Should not be called in interrupt context.
+ */
+int pps_kc_bind(struct pps_device *pps, struct pps_bind_args *bind_args)
+{
+	/* Check if another consumer is already bound */
+	spin_lock_irq(&pps_kc_hardpps_lock);
+
+	if (bind_args->edge == 0)
+		if (pps_kc_hardpps_dev == pps) {
+			pps_kc_hardpps_mode = 0;
+			pps_kc_hardpps_dev = NULL;
+			spin_unlock_irq(&pps_kc_hardpps_lock);
+			dev_info(pps->dev, "unbound kernel"
+					" consumer\n");
+		} else {
+			spin_unlock_irq(&pps_kc_hardpps_lock);
+			dev_err(pps->dev, "selected kernel consumer"
+					" is not bound\n");
+			return -EINVAL;
+		}
+	else
+		if (pps_kc_hardpps_dev == NULL ||
+				pps_kc_hardpps_dev == pps) {
+			pps_kc_hardpps_mode = bind_args->edge;
+			pps_kc_hardpps_dev = pps;
+			spin_unlock_irq(&pps_kc_hardpps_lock);
+			dev_info(pps->dev, "bound kernel consumer: "
+				"edge=0x%x\n", bind_args->edge);
+		} else {
+			spin_unlock_irq(&pps_kc_hardpps_lock);
+			dev_err(pps->dev, "another kernel consumer"
+					" is already bound\n");
+			return -EINVAL;
+		}
+
+	return 0;
+}
+
+/* pps_kc_remove - unbind kernel consumer on PPS source removal
+ * @pps: the PPS source
+ *
+ * This function is used to disable kernel consumer on PPS source removal
+ * if this source was bound to PPS kernel consumer. Can be called on any
+ * source safely. Should not be called in interrupt context.
+ */
+void pps_kc_remove(struct pps_device *pps)
+{
+	spin_lock_irq(&pps_kc_hardpps_lock);
+	if (pps == pps_kc_hardpps_dev) {
+		pps_kc_hardpps_mode = 0;
+		pps_kc_hardpps_dev = NULL;
+		spin_unlock_irq(&pps_kc_hardpps_lock);
+		dev_info(pps->dev, "unbound kernel consumer"
+				" on device removal\n");
+	} else
+		spin_unlock_irq(&pps_kc_hardpps_lock);
+}
+
+/* pps_kc_event - call hardpps() on PPS event
+ * @pps: the PPS source
+ * @ts: PPS event timestamp
+ * @event: PPS event edge
+ *
+ * This function calls hardpps() when an event from bound PPS source occurs.
+ */
+void pps_kc_event(struct pps_device *pps, struct pps_event_time *ts,
+		int event)
+{
+	unsigned long flags;
+
+	/* Pass some events to kernel consumer if activated */
+	spin_lock_irqsave(&pps_kc_hardpps_lock, flags);
+	if (pps == pps_kc_hardpps_dev && event & pps_kc_hardpps_mode)
+		hardpps(&ts->ts_real, &ts->ts_raw);
+	spin_unlock_irqrestore(&pps_kc_hardpps_lock, flags);
+}
+
diff -puN /dev/null drivers/pps/kc.h
--- /dev/null
+++ a/drivers/pps/kc.h
@@ -0,0 +1,47 @@
+/*
+ * PPS kernel consumer API header
+ *
+ * Copyright (C) 2009-2010   Alexander Gordeev <lasaine@lvk.cs.msu.su>
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
+#ifndef LINUX_PPS_KC_H
+#define LINUX_PPS_KC_H
+
+#include <linux/errno.h>
+#include <linux/pps_kernel.h>
+
+#ifdef CONFIG_NTP_PPS
+
+extern int pps_kc_bind(struct pps_device *pps,
+		struct pps_bind_args *bind_args);
+extern void pps_kc_remove(struct pps_device *pps);
+extern void pps_kc_event(struct pps_device *pps,
+		struct pps_event_time *ts, int event);
+
+
+#else /* CONFIG_NTP_PPS */
+
+static inline int pps_kc_bind(struct pps_device *pps,
+		struct pps_bind_args *bind_args) { return -EOPNOTSUPP; }
+static inline void pps_kc_remove(struct pps_device *pps) {}
+static inline void pps_kc_event(struct pps_device *pps,
+		struct pps_event_time *ts, int event) {}
+
+#endif /* CONFIG_NTP_PPS */
+
+#endif /* LINUX_PPS_KC_H */
+
diff -puN drivers/pps/pps.c~pps-add-kernel-consumer-support-v7 drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-add-kernel-consumer-support-v7
+++ a/drivers/pps/pps.c
@@ -33,6 +33,8 @@
 #include <linux/pps_kernel.h>
 #include <linux/slab.h>
 
+#include "kc.h"
+
 /*
  * Local variables
  */
@@ -227,36 +229,10 @@ static long pps_cdev_ioctl(struct file *
 			return -EINVAL;
 		}
 
-		/* Check if another consumer is already bound */
-		spin_lock_irq(&pps_kc_hardpps_lock);
+		err = pps_kc_bind(pps, &bind_args);
+		if (err < 0)
+			return err;
 
-		if (bind_args.edge == 0)
-			if (pps_kc_hardpps_dev == pps) {
-				pps_kc_hardpps_mode = 0;
-				pps_kc_hardpps_dev = NULL;
-				spin_unlock_irq(&pps_kc_hardpps_lock);
-				dev_info(pps->dev, "unbound kernel"
-						" consumer\n");
-			} else {
-				spin_unlock_irq(&pps_kc_hardpps_lock);
-				dev_err(pps->dev, "selected kernel consumer"
-						" is not bound\n");
-				return -EINVAL;
-			}
-		else
-			if (pps_kc_hardpps_dev == NULL ||
-					pps_kc_hardpps_dev == pps) {
-				pps_kc_hardpps_mode = bind_args.edge;
-				pps_kc_hardpps_dev = pps;
-				spin_unlock_irq(&pps_kc_hardpps_lock);
-				dev_info(pps->dev, "bound kernel consumer: "
-					"edge=0x%x\n", bind_args.edge);
-			} else {
-				spin_unlock_irq(&pps_kc_hardpps_lock);
-				dev_err(pps->dev, "another kernel consumer"
-						" is already bound\n");
-				return -EINVAL;
-			}
 		break;
 	}
 	default:
diff -puN include/linux/pps_kernel.h~pps-add-kernel-consumer-support-v7 include/linux/pps_kernel.h
--- a/include/linux/pps_kernel.h~pps-add-kernel-consumer-support-v7
+++ a/include/linux/pps_kernel.h
@@ -81,12 +81,6 @@ struct pps_device {
 
 extern struct device_attribute pps_attrs[];
 
-/* state variables to bind kernel consumer */
-/* PPS API (RFC 2783): current source and mode for ``kernel consumer'' */
-extern spinlock_t pps_kc_hardpps_lock;
-extern void *pps_kc_hardpps_dev;	/* some unique pointer to device */
-extern int pps_kc_hardpps_mode;		/* mode bits for kernel consumer */
-
 /*
  * Exported functions
  */
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-make-idr-lock-a-mutex-and-protect-idr_pre_get.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
pps-timestamp-is-always-passed-to-dcd_change.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-client-v7.patch
pps-add-parallel-port-pps-signal-generator.patch
pps-add-parallel-port-pps-signal-generator-fix.patch
pps-add-parallel-port-pps-signal-generator-v7.patch

