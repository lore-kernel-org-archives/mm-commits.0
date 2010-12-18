From: akpm@linux-foundation.org
Subject: [to-be-updated] pps-unify-timestamp-gathering.patch removed from -mm tree
Date: Fri, 17 Dec 2010 16:04:34 -0800
Message-ID: <201012180004.oBI04YvV004192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756442Ab0LRAFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Dec 2010 19:05:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasaine@lvk.cs.msu.su, giometti@linux.it, johnstul@us.ibm.com, joonwpark81@gmail.com, tj@kernel.org, yoush@cs.msu.su, mm-commits@vger.kernel.org


The patch titled
     pps: unify timestamp gathering
has been removed from the -mm tree.  Its filename was
     pps-unify-timestamp-gathering.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: unify timestamp gathering
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Add a helper function to gather timestamps. This way clients don't have
to duplicate it.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Acked-by: Rodolfo Giometti <giometti@linux.it>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-ktimer.c |    9 ++-------
 drivers/pps/clients/pps-ldisc.c  |   18 ++++++------------
 drivers/pps/kapi.c               |   19 ++++++++++++-------
 include/linux/pps_kernel.h       |   19 ++++++++++++++++++-
 include/linux/serial_core.h      |    5 +++--
 include/linux/tty_ldisc.h        |    5 +++--
 6 files changed, 44 insertions(+), 31 deletions(-)

diff -puN drivers/pps/clients/pps-ktimer.c~pps-unify-timestamp-gathering drivers/pps/clients/pps-ktimer.c
--- a/drivers/pps/clients/pps-ktimer.c~pps-unify-timestamp-gathering
+++ a/drivers/pps/clients/pps-ktimer.c
@@ -40,18 +40,13 @@ static struct timer_list ktimer;
 
 static void pps_ktimer_event(unsigned long ptr)
 {
-	struct timespec __ts;
-	struct pps_ktime ts;
+	struct pps_event_time ts;
 
 	/* First of all we get the time stamp... */
-	getnstimeofday(&__ts);
+	pps_get_ts(&ts);
 
 	pr_info("PPS event at %lu\n", jiffies);
 
-	/* ... and translate it to PPS time data struct */
-	ts.sec = __ts.tv_sec;
-	ts.nsec = __ts.tv_nsec;
-
 	pps_event(source, &ts, PPS_CAPTUREASSERT, NULL);
 
 	mod_timer(&ktimer, jiffies + HZ);
diff -puN drivers/pps/clients/pps-ldisc.c~pps-unify-timestamp-gathering drivers/pps/clients/pps-ldisc.c
--- a/drivers/pps/clients/pps-ldisc.c~pps-unify-timestamp-gathering
+++ a/drivers/pps/clients/pps-ldisc.c
@@ -27,26 +27,20 @@
 #define PPS_TTY_MAGIC		0x0001
 
 static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
-				struct timespec *ts)
+				struct pps_event_time *ts)
 {
 	int id = (long)tty->disc_data;
-	struct timespec __ts;
-	struct pps_ktime pps_ts;
+	struct pps_event_time __ts;
 
 	/* First of all we get the time stamp... */
-	getnstimeofday(&__ts);
+	pps_get_ts(&__ts);
 
 	/* Does caller give us a timestamp? */
-	if (ts) {	/* Yes. Let's use it! */
-		pps_ts.sec = ts->tv_sec;
-		pps_ts.nsec = ts->tv_nsec;
-	} else {	/* No. Do it ourself! */
-		pps_ts.sec = __ts.tv_sec;
-		pps_ts.nsec = __ts.tv_nsec;
-	}
+	if (!ts)	/* No. Do it ourself! */
+		ts = &__ts;
 
 	/* Now do the PPS event report */
-	pps_event(id, &pps_ts, status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR,
+	pps_event(id, ts, status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR,
 			NULL);
 
 	pr_debug("PPS %s at %lu on source #%d\n",
diff -puN drivers/pps/kapi.c~pps-unify-timestamp-gathering drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-unify-timestamp-gathering
+++ a/drivers/pps/kapi.c
@@ -268,11 +268,12 @@ EXPORT_SYMBOL(pps_unregister_source);
  *	pps->info.echo(source, event, data);
  */
 
-void pps_event(int source, struct pps_ktime *ts, int event, void *data)
+void pps_event(int source, struct pps_event_time *ts, int event, void *data)
 {
 	struct pps_device *pps;
 	unsigned long flags;
 	int captured = 0;
+	struct pps_ktime ts_real;
 
 	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
 		printk(KERN_ERR "pps: unknown event (%x) for source %d\n",
@@ -284,8 +285,10 @@ void pps_event(int source, struct pps_kt
 	if (!pps)
 		return;
 
-	pr_debug("PPS event on source %d at %llu.%06u\n",
-			pps->id, (unsigned long long) ts->sec, ts->nsec);
+	pr_debug("PPS event on source %d at %ld.%09ld\n",
+			pps->id, ts->ts_real.tv_sec, ts->ts_real.tv_nsec);
+
+	timespec_to_pps_ktime(&ts_real, ts->ts_real);
 
 	spin_lock_irqsave(&pps->lock, flags);
 
@@ -299,10 +302,11 @@ void pps_event(int source, struct pps_kt
 			(pps->params.mode & PPS_CAPTUREASSERT)) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETASSERT)
-			pps_add_offset(ts, &pps->params.assert_off_tu);
+			pps_add_offset(&ts_real,
+					&pps->params.assert_off_tu);
 
 		/* Save the time stamp */
-		pps->assert_tu = *ts;
+		pps->assert_tu = ts_real;
 		pps->assert_sequence++;
 		pr_debug("capture assert seq #%u for source %d\n",
 			pps->assert_sequence, source);
@@ -313,10 +317,11 @@ void pps_event(int source, struct pps_kt
 			(pps->params.mode & PPS_CAPTURECLEAR)) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETCLEAR)
-			pps_add_offset(ts, &pps->params.clear_off_tu);
+			pps_add_offset(&ts_real,
+					&pps->params.clear_off_tu);
 
 		/* Save the time stamp */
-		pps->clear_tu = *ts;
+		pps->clear_tu = ts_real;
 		pps->clear_sequence++;
 		pr_debug("capture clear seq #%u for source %d\n",
 			pps->clear_sequence, source);
diff -puN include/linux/pps_kernel.h~pps-unify-timestamp-gathering include/linux/pps_kernel.h
--- a/include/linux/pps_kernel.h~pps-unify-timestamp-gathering
+++ a/include/linux/pps_kernel.h
@@ -43,6 +43,10 @@ struct pps_source_info {
 	struct device *dev;
 };
 
+struct pps_event_time {
+	struct timespec ts_real;
+};
+
 /* The main struct */
 struct pps_device {
 	struct pps_source_info info;		/* PSS source info */
@@ -88,7 +92,20 @@ extern int pps_register_source(struct pp
 extern void pps_unregister_source(int source);
 extern int pps_register_cdev(struct pps_device *pps);
 extern void pps_unregister_cdev(struct pps_device *pps);
-extern void pps_event(int source, struct pps_ktime *ts, int event, void *data);
+extern void pps_event(int source, struct pps_event_time *ts, int event,
+		void *data);
+
+static inline void timespec_to_pps_ktime(struct pps_ktime *kt,
+		struct timespec ts)
+{
+	kt->sec = ts.tv_sec;
+	kt->nsec = ts.tv_nsec;
+}
+
+static inline void pps_get_ts(struct pps_event_time *ts)
+{
+	getnstimeofday(&ts->ts_real);
+}
 
 #endif /* LINUX_PPS_KERNEL_H */
 
diff -puN include/linux/serial_core.h~pps-unify-timestamp-gathering include/linux/serial_core.h
--- a/include/linux/serial_core.h~pps-unify-timestamp-gathering
+++ a/include/linux/serial_core.h
@@ -212,6 +212,7 @@
 #include <linux/tty.h>
 #include <linux/mutex.h>
 #include <linux/sysrq.h>
+#include <linux/pps_kernel.h>
 
 struct uart_port;
 struct serial_struct;
@@ -527,10 +528,10 @@ uart_handle_dcd_change(struct uart_port 
 	struct uart_state *state = uport->state;
 	struct tty_port *port = &state->port;
 	struct tty_ldisc *ld = tty_ldisc_ref(port->tty);
-	struct timespec ts;
+	struct pps_event_time ts;
 
 	if (ld && ld->ops->dcd_change)
-		getnstimeofday(&ts);
+		pps_get_ts(&ts);
 
 	uport->icount.dcd++;
 #ifdef CONFIG_HARD_PPS
diff -puN include/linux/tty_ldisc.h~pps-unify-timestamp-gathering include/linux/tty_ldisc.h
--- a/include/linux/tty_ldisc.h~pps-unify-timestamp-gathering
+++ a/include/linux/tty_ldisc.h
@@ -101,7 +101,7 @@
  *	any pending driver I/O is completed.
  *
  * void (*dcd_change)(struct tty_struct *tty, unsigned int status,
- * 			struct timespec *ts)
+ *			struct pps_event_time *ts)
  *
  *	Tells the discipline that the DCD pin has changed its status and
  *	the relative timestamp. Pointer ts can be NULL.
@@ -109,6 +109,7 @@
 
 #include <linux/fs.h>
 #include <linux/wait.h>
+#include <linux/pps_kernel.h>
 
 struct tty_ldisc_ops {
 	int	magic;
@@ -143,7 +144,7 @@ struct tty_ldisc_ops {
 			       char *fp, int count);
 	void	(*write_wakeup)(struct tty_struct *);
 	void	(*dcd_change)(struct tty_struct *, unsigned int,
-				struct timespec *);
+				struct pps_event_time *);
 
 	struct  module *owner;
 	
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-add-async-pps-event-handler.patch
pps-add-async-pps-event-handler-fix.patch
pps-dont-disable-interrupts-when-using-spin-locks.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

