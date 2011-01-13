From: akpm@linux-foundation.org
Subject: [merged] pps-add-kernel-consumer-support.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:34 -0800
Message-ID: <201101132012.p0DKCFkf030272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933767Ab1AMUUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:20:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasaine@lvk.cs.msu.su, giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     pps: add kernel consumer support
has been removed from the -mm tree.  Its filename was
     pps-add-kernel-consumer-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: add kernel consumer support
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Add an optional feature of PPSAPI, kernel consumer support, which uses the
added hardpps() function.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Acked-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ioctl/ioctl-number.txt |    2 
 drivers/pps/Makefile                 |    1 
 drivers/pps/kapi.c                   |    6 +
 drivers/pps/kc.c                     |  123 +++++++++++++++++++++++++
 drivers/pps/kc.h                     |   47 +++++++++
 drivers/pps/pps.c                    |   38 +++++++
 include/linux/pps.h                  |    7 +
 7 files changed, 222 insertions(+), 2 deletions(-)

diff -puN Documentation/ioctl/ioctl-number.txt~pps-add-kernel-consumer-support Documentation/ioctl/ioctl-number.txt
--- a/Documentation/ioctl/ioctl-number.txt~pps-add-kernel-consumer-support
+++ a/Documentation/ioctl/ioctl-number.txt
@@ -247,7 +247,7 @@ Code  Seq#(hex)	Include File		Comments
 'p'	40-7F	linux/nvram.h
 'p'	80-9F	linux/ppdev.h		user-space parport
 					<mailto:tim@cyberelk.net>
-'p'	A1-A4	linux/pps.h		LinuxPPS
+'p'	A1-A5	linux/pps.h		LinuxPPS
 					<mailto:giometti@linux.it>
 'q'	00-1F	linux/serio.h
 'q'	80-FF	linux/telephony.h	Internet PhoneJACK, Internet LineJACK
diff -puN drivers/pps/Makefile~pps-add-kernel-consumer-support drivers/pps/Makefile
--- a/drivers/pps/Makefile~pps-add-kernel-consumer-support
+++ a/drivers/pps/Makefile
@@ -3,6 +3,7 @@
 #
 
 pps_core-y			:= pps.o kapi.o sysfs.o
+pps_core-$(CONFIG_NTP_PPS)	+= kc.o
 obj-$(CONFIG_PPS)		:= pps_core.o
 obj-y				+= clients/
 
diff -puN drivers/pps/kapi.c~pps-add-kernel-consumer-support drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-add-kernel-consumer-support
+++ a/drivers/pps/kapi.c
@@ -26,11 +26,14 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/time.h>
+#include <linux/timex.h>
 #include <linux/spinlock.h>
 #include <linux/fs.h>
 #include <linux/pps_kernel.h>
 #include <linux/slab.h>
 
+#include "kc.h"
+
 /*
  * Local functions
  */
@@ -139,6 +142,7 @@ EXPORT_SYMBOL(pps_register_source);
 
 void pps_unregister_source(struct pps_device *pps)
 {
+	pps_kc_remove(pps);
 	pps_unregister_cdev(pps);
 
 	/* don't have to kfree(pps) here because it will be done on
@@ -211,6 +215,8 @@ void pps_event(struct pps_device *pps, s
 		captured = ~0;
 	}
 
+	pps_kc_event(pps, ts, event);
+
 	/* Wake up if captured something */
 	if (captured) {
 		pps->last_ev++;
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
diff -puN drivers/pps/pps.c~pps-add-kernel-consumer-support drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-add-kernel-consumer-support
+++ a/drivers/pps/pps.c
@@ -33,6 +33,8 @@
 #include <linux/pps_kernel.h>
 #include <linux/slab.h>
 
+#include "kc.h"
+
 /*
  * Local variables
  */
@@ -198,9 +200,43 @@ static long pps_cdev_ioctl(struct file *
 
 		break;
 	}
+	case PPS_KC_BIND: {
+		struct pps_bind_args bind_args;
+
+		dev_dbg(pps->dev, "PPS_KC_BIND\n");
+
+		/* Check the capabilities */
+		if (!capable(CAP_SYS_TIME))
+			return -EPERM;
+
+		if (copy_from_user(&bind_args, uarg,
+					sizeof(struct pps_bind_args)))
+			return -EFAULT;
+
+		/* Check for supported capabilities */
+		if ((bind_args.edge & ~pps->info.mode) != 0) {
+			dev_err(pps->dev, "unsupported capabilities (%x)\n",
+					bind_args.edge);
+			return -EINVAL;
+		}
+
+		/* Validate parameters roughly */
+		if (bind_args.tsformat != PPS_TSFMT_TSPEC ||
+				(bind_args.edge & ~PPS_CAPTUREBOTH) != 0 ||
+				bind_args.consumer != PPS_KC_HARDPPS) {
+			dev_err(pps->dev, "invalid kernel consumer bind"
+					" parameters (%x)\n", bind_args.edge);
+			return -EINVAL;
+		}
+
+		err = pps_kc_bind(pps, &bind_args);
+		if (err < 0)
+			return err;
+
+		break;
+	}
 	default:
 		return -ENOTTY;
-		break;
 	}
 
 	return 0;
diff -puN include/linux/pps.h~pps-add-kernel-consumer-support include/linux/pps.h
--- a/include/linux/pps.h~pps-add-kernel-consumer-support
+++ a/include/linux/pps.h
@@ -114,11 +114,18 @@ struct pps_fdata {
 	struct pps_ktime timeout;
 };
 
+struct pps_bind_args {
+	int tsformat;	/* format of time stamps */
+	int edge;	/* selected event type */
+	int consumer;	/* selected kernel consumer */
+};
+
 #include <linux/ioctl.h>
 
 #define PPS_GETPARAMS		_IOR('p', 0xa1, struct pps_kparams *)
 #define PPS_SETPARAMS		_IOW('p', 0xa2, struct pps_kparams *)
 #define PPS_GETCAP		_IOR('p', 0xa3, int *)
 #define PPS_FETCH		_IOWR('p', 0xa4, struct pps_fdata *)
+#define PPS_KC_BIND		_IOW('p', 0xa5, struct pps_bind_args *)
 
 #endif /* _PPS_H_ */
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

origin.patch

