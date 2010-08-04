From: akpm@linux-foundation.org
Subject: + pps-add-kernel-consumer-support.patch added to -mm tree
Date: Wed, 04 Aug 2010 16:38:42 -0700
Message-ID: <201008042338.o74Ncg83017026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759524Ab0HDXjj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Aug 2010 19:39:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@enneenne.com, johnstul@us.ibm.com, joonwpark81@gmail.com, tj@kernel.org, yoush@cs.msu.su


The patch titled
     pps: add kernel consumer support
has been added to the -mm tree.  Its filename is
     pps-add-kernel-consumer-support.patch

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
Subject: pps: add kernel consumer support
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Add an optional feature of PPSAPI, kernel consumer support, which uses
the added hardpps() function.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ioctl/ioctl-number.txt |    2 
 drivers/pps/Kconfig                  |    1 
 drivers/pps/kapi.c                   |   23 +++++++++
 drivers/pps/pps.c                    |   62 ++++++++++++++++++++++++-
 include/linux/pps.h                  |    7 ++
 include/linux/pps_kernel.h           |    6 ++
 6 files changed, 99 insertions(+), 2 deletions(-)

diff -puN Documentation/ioctl/ioctl-number.txt~pps-add-kernel-consumer-support Documentation/ioctl/ioctl-number.txt
--- a/Documentation/ioctl/ioctl-number.txt~pps-add-kernel-consumer-support
+++ a/Documentation/ioctl/ioctl-number.txt
@@ -249,7 +249,7 @@ Code  Seq#(hex)	Include File		Comments
 'p'	40-7F	linux/nvram.h
 'p'	80-9F	linux/ppdev.h		user-space parport
 					<mailto:tim@cyberelk.net>
-'p'	A1-A4	linux/pps.h		LinuxPPS
+'p'	A1-A5	linux/pps.h		LinuxPPS
 					<mailto:giometti@linux.it>
 'q'	00-1F	linux/serio.h
 'q'	80-FF	linux/telephony.h	Internet PhoneJACK, Internet LineJACK
diff -puN drivers/pps/Kconfig~pps-add-kernel-consumer-support drivers/pps/Kconfig
--- a/drivers/pps/Kconfig~pps-add-kernel-consumer-support
+++ a/drivers/pps/Kconfig
@@ -7,6 +7,7 @@ menu "PPS support"
 config PPS
 	tristate "PPS support"
 	depends on EXPERIMENTAL
+	select NTP_PPS
 	---help---
 	  PPS (Pulse Per Second) is a special pulse provided by some GPS
 	  antennae. Userland can use it to get a high-precision time
diff -puN drivers/pps/kapi.c~pps-add-kernel-consumer-support drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-add-kernel-consumer-support
+++ a/drivers/pps/kapi.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/time.h>
+#include <linux/timex.h>
 #include <linux/spinlock.h>
 #include <linux/fs.h>
 #include <linux/pps_kernel.h>
@@ -37,6 +38,12 @@
 /* PPS event workqueue */
 struct workqueue_struct *pps_event_workqueue;
 
+/* state variables to bind kernel consumer */
+/* PPS API (RFC 2783): current source and mode for ``kernel consumer'' */
+DEFINE_SPINLOCK(pps_kc_hardpps_lock);
+void	*pps_kc_hardpps_dev;	/* some unique pointer to device */
+int	pps_kc_hardpps_mode;	/* mode bits for kernel consumer */
+
 /*
  * Local functions
  */
@@ -140,6 +147,16 @@ EXPORT_SYMBOL(pps_register_source);
 
 void pps_unregister_source(struct pps_device *pps)
 {
+	spin_lock(&pps_kc_hardpps_lock);
+	if (pps == pps_kc_hardpps_dev) {
+		pps_kc_hardpps_mode = 0;
+		pps_kc_hardpps_dev = NULL;
+		spin_unlock(&pps_kc_hardpps_lock);
+		dev_info(pps->dev, "unbound kernel consumer"
+				" on device removal\n");
+	} else
+		spin_unlock(&pps_kc_hardpps_lock);
+
 	pps_unregister_cdev(pps);
 }
 EXPORT_SYMBOL(pps_unregister_source);
@@ -209,6 +226,12 @@ void pps_event(struct pps_device *pps, s
 		captured = ~0;
 	}
 
+	/* Pass some events to kernel consumer if activated */
+	spin_lock(&pps_kc_hardpps_lock);
+	if (pps == pps_kc_hardpps_dev && event & pps_kc_hardpps_mode)
+		hardpps(&ts->ts_real, &ts->ts_raw);
+	spin_unlock(&pps_kc_hardpps_lock);
+
 	/* Wake up if captured something */
 	if (captured) {
 		pps->last_ev++;
diff -puN drivers/pps/pps.c~pps-add-kernel-consumer-support drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-add-kernel-consumer-support
+++ a/drivers/pps/pps.c
@@ -196,9 +196,69 @@ static long pps_cdev_ioctl(struct file *
 
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
+		/* Check if another consumer is already bound */
+		spin_lock(&pps_kc_hardpps_lock);
+
+		if (bind_args.edge == 0)
+			if (pps_kc_hardpps_dev == pps) {
+				pps_kc_hardpps_mode = 0;
+				pps_kc_hardpps_dev = NULL;
+				spin_unlock(&pps_kc_hardpps_lock);
+				dev_info(pps->dev, "unbound kernel"
+						" consumer\n");
+			} else {
+				spin_unlock(&pps_kc_hardpps_lock);
+				dev_err(pps->dev, "selected kernel consumer"
+						" is not bound\n");
+				return -EINVAL;
+			}
+		else
+			if (pps_kc_hardpps_dev == NULL ||
+					pps_kc_hardpps_dev == pps) {
+				pps_kc_hardpps_mode = bind_args.edge;
+				pps_kc_hardpps_dev = pps;
+				spin_unlock(&pps_kc_hardpps_lock);
+				dev_info(pps->dev, "bound kernel consumer: "
+					"edge=0x%x\n", bind_args.edge);
+			} else {
+				spin_unlock(&pps_kc_hardpps_lock);
+				dev_err(pps->dev, "another kernel consumer"
+						" is already bound\n");
+				return -EINVAL;
+			}
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
diff -puN include/linux/pps_kernel.h~pps-add-kernel-consumer-support include/linux/pps_kernel.h
--- a/include/linux/pps_kernel.h~pps-add-kernel-consumer-support
+++ a/include/linux/pps_kernel.h
@@ -87,6 +87,12 @@ struct pps_device {
 
 extern struct device_attribute pps_attrs[];
 
+/* state variables to bind kernel consumer */
+/* PPS API (RFC 2783): current source and mode for ``kernel consumer'' */
+extern spinlock_t pps_kc_hardpps_lock;
+extern void *pps_kc_hardpps_dev;	/* some unique pointer to device */
+extern int pps_kc_hardpps_mode;		/* mode bits for kernel consumer */
+
 extern struct workqueue_struct *pps_event_workqueue;
 
 /*
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-add-async-pps-event-handler.patch
pps-dont-disable-interrupts-when-using-spin-locks.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

