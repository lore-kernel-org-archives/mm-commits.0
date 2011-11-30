From: akpm@linux-foundation.org
Subject: + tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode.patch added to -mm tree
Date: Wed, 30 Nov 2011 15:51:11 -0800
Message-ID: <201111302351.pAUNpBA0013430@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38663 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab1K3XvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 18:51:15 -0500
Received: by eeuu44 with SMTP id u44so20316eeu.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 15:51:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sivanich@sgi.com, john.stultz@linaro.org, tglx@linutronix.de


The patch titled
     Subject: tick-sched: add specific do_timer_cpu value for nohz off mode
has been added to the -mm tree.  Its filename is
     tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode.patch

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
From: Dimitri Sivanich <sivanich@sgi.com>
Subject: tick-sched: add specific do_timer_cpu value for nohz off mode

Show and modify the tick_do_timer_cpu via sysfs.  This determines the cpu
on which global time (jiffies) updates occur.  Modification can only be
done on systems with nohz mode turned off.

While not necessarily harmful, doing jiffies updates on an application cpu
does cause some extra overhead that HPC benchmarking people notice.  They
prefer to have OS activity isolated to certain cpus.  They like reproducibility
of results, and having jiffies updates bouncing around introduces variability.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-devices-system-timekeeping |   16 ++
 drivers/base/sys.c                                         |   10 -
 include/linux/sysdev.h                                     |    2 
 kernel/time/tick-sched.c                                   |   59 ++++++++++
 4 files changed, 81 insertions(+), 6 deletions(-)

diff -puN /dev/null Documentation/ABI/testing/sysfs-devices-system-timekeeping
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-devices-system-timekeeping
@@ -0,0 +1,16 @@
+What:		/sys/devices/system/timekeeping/
+Date:		November 2011
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Timekeeping attributes
+
+
+What:		/sys/devices/system/timekeeping/timekeeping0/jiffies_cpu
+Date:		November 2011
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Show and modify the kernel's tick_do_timer_cpu.  This
+		determines the cpu on which global time (jiffies) updates
+		occur.  This can only be modified on systems running with
+		the nohz mode turned off (nohz=off).
+
+		Possible values are:
+			0 - <num online cpus>
diff -puN drivers/base/sys.c~tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode drivers/base/sys.c
--- a/drivers/base/sys.c~tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode
+++ a/drivers/base/sys.c
@@ -339,13 +339,11 @@ int __init system_bus_init(void)
 	return 0;
 }
 
-#define to_ext_attr(x) container_of(x, struct sysdev_ext_attribute, attr)
-
 ssize_t sysdev_store_ulong(struct sys_device *sysdev,
 			   struct sysdev_attribute *attr,
 			   const char *buf, size_t size)
 {
-	struct sysdev_ext_attribute *ea = to_ext_attr(attr);
+	struct sysdev_ext_attribute *ea = SYSDEV_TO_EXT_ATTR(attr);
 	char *end;
 	unsigned long new = simple_strtoul(buf, &end, 0);
 	if (end == buf)
@@ -360,7 +358,7 @@ ssize_t sysdev_show_ulong(struct sys_dev
 			  struct sysdev_attribute *attr,
 			  char *buf)
 {
-	struct sysdev_ext_attribute *ea = to_ext_attr(attr);
+	struct sysdev_ext_attribute *ea = SYSDEV_TO_EXT_ATTR(attr);
 	return snprintf(buf, PAGE_SIZE, "%lx\n", *(unsigned long *)(ea->var));
 }
 EXPORT_SYMBOL_GPL(sysdev_show_ulong);
@@ -369,7 +367,7 @@ ssize_t sysdev_store_int(struct sys_devi
 			   struct sysdev_attribute *attr,
 			   const char *buf, size_t size)
 {
-	struct sysdev_ext_attribute *ea = to_ext_attr(attr);
+	struct sysdev_ext_attribute *ea = SYSDEV_TO_EXT_ATTR(attr);
 	char *end;
 	long new = simple_strtol(buf, &end, 0);
 	if (end == buf || new > INT_MAX || new < INT_MIN)
@@ -384,7 +382,7 @@ ssize_t sysdev_show_int(struct sys_devic
 			  struct sysdev_attribute *attr,
 			  char *buf)
 {
-	struct sysdev_ext_attribute *ea = to_ext_attr(attr);
+	struct sysdev_ext_attribute *ea = SYSDEV_TO_EXT_ATTR(attr);
 	return snprintf(buf, PAGE_SIZE, "%d\n", *(int *)(ea->var));
 }
 EXPORT_SYMBOL_GPL(sysdev_show_int);
diff -puN include/linux/sysdev.h~tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode include/linux/sysdev.h
--- a/include/linux/sysdev.h~tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode
+++ a/include/linux/sysdev.h
@@ -132,6 +132,8 @@ struct sysdev_ext_attribute {
 	void *var;
 };
 
+#define SYSDEV_TO_EXT_ATTR(x) container_of(x, struct sysdev_ext_attribute, attr)
+
 /*
  * Support for simple variable sysdev attributes.
  * The pointer to the variable is stored in a sysdev_ext_attribute
diff -puN kernel/time/tick-sched.c~tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode
+++ a/kernel/time/tick-sched.c
@@ -834,6 +834,65 @@ void tick_cancel_sched_timer(int cpu)
 }
 #endif
 
+#ifdef CONFIG_SYSFS
+/*
+ * Allow modification of tick_do_timer_cpu when nohz mode is off.
+ */
+static ssize_t sysfs_store_do_timer_cpu(struct sys_device *dev,
+						struct sysdev_attribute *attr,
+						const char *buf, size_t size)
+{
+	struct sysdev_ext_attribute *ea = SYSDEV_TO_EXT_ATTR(attr);
+	unsigned int new;
+	int rv;
+
+#ifdef CONFIG_NO_HZ
+	/* nohz mode not supported */
+	if (tick_nohz_enabled)
+		return -EINVAL;
+#endif
+
+	rv = kstrtouint(buf, 0, &new);
+	if (rv)
+		return rv;
+
+	if (new >= NR_CPUS || !cpu_online(new))
+		return -ERANGE;
+
+	*(unsigned int *)(ea->var) = new;
+	return size;
+}
+
+static struct sysdev_ext_attribute attr_jiffies_cpu = {
+			_SYSDEV_ATTR(jiffies_cpu, 0644, sysdev_show_int,
+					sysfs_store_do_timer_cpu),
+			&tick_do_timer_cpu };
+
+static struct sysdev_class timekeeping_sysclass = {
+	.name = "timekeeping",
+};
+
+static struct sys_device device_timekeeping = {
+	.id     = 0,
+	.cls    = &timekeeping_sysclass,
+};
+
+static int __init init_timekeeping_sysfs(void)
+{
+	int error = sysdev_class_register(&timekeeping_sysclass);
+
+	if (!error)
+		error = sysdev_register(&device_timekeeping);
+	if (!error)
+		error = sysdev_create_file(
+				&device_timekeeping,
+				&attr_jiffies_cpu.attr);
+	return error;
+}
+
+device_initcall(init_timekeeping_sysfs);
+#endif /* SYSFS */
+
 /**
  * Async notification about clocksource changes
  */
_
Subject: Subject: tick-sched: add specific do_timer_cpu value for nohz off mode

Patches currently in -mm which might be from sivanich@sgi.com are

tick-sched-add-specific-do_timer_cpu-value-for-nohz-off-mode.patch

