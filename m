From: akpm@linux-foundation.org
Subject: [withdrawn]
 printk-allow-different-timestamps-for-printktime.patch removed from -mm
 tree
Date: Wed, 27 Jul 2016 16:08:28 -0700
Message-ID: <57993eec.KctLUHD1rOBUUBsE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163142AbcG0XIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 19:08:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prarit@redhat.com, baolin.wang@linaro.org, gregkh@linuxfoundation.org, joe@perches.com, john.stultz@linaro.org, pang.xunlei@linaro.org, peter@hurleysoftware.com, pmladek@suse.com, pmladek@suse.cz, tglx@linutronix.de, tj@kernel.org, vvs@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk, allow different timestamps for printk.time
has been removed from the -mm tree.  Its filename was
     printk-allow-different-timestamps-for-printktime.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Prarit Bhargava <prarit@redhat.com>
Subject: printk, allow different timestamps for printk.time

Over the past years I've seen many reports of bugs that include
time-stamped kernel logs (enabled when CONFIG_PRINTK_TIME=y or
print.time=1 is specified as a kernel parameter) that do not align with
either external time stamped logs or /var/log/messages.  This also makes
determining the time of a failure difficult in cases where
/var/log/messages is unavailable.

For example,

[root@intel-wildcatpass-06 ~]# date; echo "Hello!" > /dev/kmsg ; date
Thu Dec 17 13:58:31 EST 2015
Thu Dec 17 13:58:31 EST 2015

which displays

[83973.768912] Hello!

on the serial console.

Running a script to convert this to the stamped time,

[root@intel-wildcatpass-06 ~]# ./human.sh  | tail -1
[Thu Dec 17 13:59:57 2015] Hello!

which is already off by 1 minute and 26 seconds off after ~24 hours of
uptime.

This occurs because the time stamp is obtained from a call to
local_clock() which (on x86) is a direct call to the hardware.  These
hardware clock reads are not modified by the standard ntp or ptp protocol,
while the other timestamps are, and that results in situations external
time sources are further and further offset from the kernel log
timestamps.

This patch introduces printk.time=[0-3] allowing a user to specify an
adjusted clock to use with printk timestamps.  The hardware clock, or the
existing functionality, is preserved by default.

Real clock & 32-bit systems: Selecting the real clock printk timestamp may
lead to unlikely situations where a timestamp is wrong because the real
time offset is read without the protection of a sequence lock in the call
to ktime_get_log_ts() in printk_get_ts().

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Cc: Petr Mladek <pmladek@suse.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Xunlei Pang <pang.xunlei@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Baolin Wang <baolin.wang@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 ++--
 include/linux/timekeeping.h         |    1 
 kernel/printk/printk.c              |   35 ++++++++++++++++++++++++--
 kernel/time/timekeeping.c           |   13 +++++++++
 lib/Kconfig.debug                   |    7 ++---
 5 files changed, 55 insertions(+), 7 deletions(-)

diff -puN Documentation/kernel-parameters.txt~printk-allow-different-timestamps-for-printktime Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~printk-allow-different-timestamps-for-printktime
+++ a/Documentation/kernel-parameters.txt
@@ -3163,8 +3163,10 @@ bytes respectively. Such letter suffixes
 			ratelimit - ratelimit the logging
 			Default: ratelimit
 
-	printk.time=	Show timing data prefixed to each printk message line
-			Format: <string>  (1/Y/y=enable, 0/N/n=disable)
+	printk.time=	Show timestamp prefixed to each printk message line
+			Format: <string>
+				(0/N/n = disable, 1/Y/y = local clock,
+				2 = monotonic clock, 3 = real clock)
 
 	processor.max_cstate=	[HW,ACPI]
 			Limit processor to maximum C-state
diff -puN include/linux/timekeeping.h~printk-allow-different-timestamps-for-printktime include/linux/timekeeping.h
--- a/include/linux/timekeeping.h~printk-allow-different-timestamps-for-printktime
+++ a/include/linux/timekeeping.h
@@ -249,6 +249,7 @@ static inline u64 ktime_get_raw_ns(void)
 
 extern u64 ktime_get_mono_fast_ns(void);
 extern u64 ktime_get_raw_fast_ns(void);
+extern u64 ktime_get_log_ts(u64 *offset_real);
 
 /*
  * Timespec interfaces utilizing the ktime based ones
diff -puN kernel/printk/printk.c~printk-allow-different-timestamps-for-printktime kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-allow-different-timestamps-for-printktime
+++ a/kernel/printk/printk.c
@@ -529,6 +529,8 @@ static u32 truncate_msg(u16 *text_len, u
 	return msg_used_size(*text_len + *trunc_msg_len, 0, pad_len);
 }
 
+static u64 printk_get_ts(void);
+
 /* insert record into the buffer, discard old ones, update heads */
 static int log_store(int facility, int level,
 		     enum log_flags flags, u64 ts_nsec,
@@ -577,7 +579,7 @@ static int log_store(int facility, int l
 	if (ts_nsec > 0)
 		msg->ts_nsec = ts_nsec;
 	else
-		msg->ts_nsec = local_clock();
+		msg->ts_nsec = printk_get_ts();
 	memset(log_dict(msg) + dict_len, 0, pad_len);
 	msg->len = size;
 
@@ -1173,6 +1175,12 @@ static inline void boot_delay_msec(int l
 
 static int printk_time = CONFIG_PRINTK_TIME;
 
+/*
+ * Real clock & 32-bit systems:  Selecting the real clock printk timestamp may
+ * lead to unlikely situations where a timestamp is wrong because the real time
+ * offset is read without the protection of a sequence lock in the call to
+ * ktime_get_log_ts() in printk_get_ts() below.
+ */
 static int printk_time_param_set(const char *val,
 				 const struct kernel_param *kp)
 {
@@ -1194,6 +1202,14 @@ static int printk_time_param_set(const c
 	case 'y':
 		printk_time = 1;
 		break;
+	/* 2 = monotonic clock */
+	case '2':
+		printk_time = 2;
+		break;
+	/* 3 = real clock */
+	case '3':
+		printk_time = 3;
+		break;
 	default:
 		pr_warn("printk: invalid timestamp value\n");
 		return -EINVAL;
@@ -1211,6 +1227,21 @@ static struct kernel_param_ops printk_ti
 
 module_param_cb(time, &printk_time_param_ops, &printk_time, S_IRUGO);
 
+static u64 printk_get_ts(void)
+{
+	u64 mono, offset_real;
+
+	if (printk_time <= 1)
+		return local_clock();
+
+	mono = ktime_get_log_ts(&offset_real);
+
+	if (printk_time == 2)
+		return mono;
+
+	return mono + offset_real;
+}
+
 static size_t print_time(u64 ts, char *buf)
 {
 	unsigned long rem_nsec;
@@ -1727,7 +1758,7 @@ static bool cont_add(int facility, int l
 		cont.facility = facility;
 		cont.level = level;
 		cont.owner = current;
-		cont.ts_nsec = local_clock();
+		cont.ts_nsec = printk_get_ts();
 		cont.flags = 0;
 		cont.cons = 0;
 		cont.flushed = false;
diff -puN kernel/time/timekeeping.c~printk-allow-different-timestamps-for-printktime kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~printk-allow-different-timestamps-for-printktime
+++ a/kernel/time/timekeeping.c
@@ -43,6 +43,7 @@ static struct {
 
 static DEFINE_RAW_SPINLOCK(timekeeper_lock);
 static struct timekeeper shadow_timekeeper;
+static int timekeeping_active;
 
 /**
  * struct tk_fast - NMI safe timekeeper
@@ -419,6 +420,16 @@ u64 ktime_get_raw_fast_ns(void)
 }
 EXPORT_SYMBOL_GPL(ktime_get_raw_fast_ns);
 
+u64 ktime_get_log_ts(u64 *offset_real)
+{
+	*offset_real = ktime_to_ns(tk_core.timekeeper.offs_real);
+
+	if (timekeeping_active)
+		return ktime_get_mono_fast_ns();
+	else
+		return local_clock();
+}
+
 /* Suspend-time cycles value for halted fast timekeeper. */
 static cycle_t cycles_at_suspend;
 
@@ -1505,6 +1516,8 @@ void __init timekeeping_init(void)
 
 	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
+
+	timekeeping_active = 1;
 }
 
 /* time in seconds when suspend began for persistent clock */
diff -puN lib/Kconfig.debug~printk-allow-different-timestamps-for-printktime lib/Kconfig.debug
--- a/lib/Kconfig.debug~printk-allow-different-timestamps-for-printktime
+++ a/lib/Kconfig.debug
@@ -1,8 +1,8 @@
 menu "printk and dmesg options"
 
 config PRINTK_TIME
-	int "Show timing information on printks (0-1)"
-	range 0 1
+	int "Show timing information on printks (0-3)"
+	range 0 3
 	default "0"
 	depends on PRINTK
 	help
@@ -13,7 +13,8 @@ config PRINTK_TIME
 	  The timestamp is always recorded internally, and exported
 	  to /dev/kmsg. This flag just specifies if the timestamp should
 	  be included, not that the timestamp is recorded. 0 disables the
-	  timestamp and 1 uses the local clock.
+	  timestamp and 1 uses the local clock, 2 uses the monotonic clock, and
+	  3 uses real clock.
 
 	  The behavior is also controlled by the kernel command line
 	  parameter printk.time=1. See Documentation/kernel-parameters.txt
_

Patches currently in -mm which might be from prarit@redhat.com are

init-allow-blacklisting-of-module_init-functions.patch

