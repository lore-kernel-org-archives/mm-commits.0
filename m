From: akpm@linux-foundation.org
Subject: + cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch added to -mm tree
Date: Fri, 16 Mar 2012 14:37:45 -0700
Message-ID: <20120316213746.4FB2CA02FF@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:57202 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab2CPVhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Mar 2012 17:37:47 -0400
Received: by vcbfk26 with SMTP id fk26so746848vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Mar 2012 14:37:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shuox.liu@intel.com, broonie@opensource.wolfsonmicro.com, deepthi@linux.vnet.ibm.com, gregkh@linuxfoundation.org, hmh@hmh.eng.br, hpa@zytor.com, len.brown@intel.com, lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de, yanmin_zhang@intel.com


The patch titled
     Subject: cpuidle: add a sysfs entry to disable specific C state for debug purpose.
has been added to the -mm tree.  Its filename is
     cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: ShuoX Liu <shuox.liu@intel.com>
Subject: cpuidle: add a sysfs entry to disable specific C state for debug purpose.

Some C states of new CPU might be not good.  One reason is BIOS might
configure them incorrectly.  To help developers root cause it quickly, the
patch adds a new sysfs entry, so developers could disable specific C state
manually.

In addition, C state might have much impact on performance tuning, as it
takes much time to enter/exit C states, which might delay interrupt
processing.  With the new debug option, developers could check if a deep C
state could impact performance and how much impact it could cause.

Also add this option in Documentation/cpuidle/sysfs.txt.

Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
Reviewed-by: Yanmin Zhang <yanmin_zhang@intel.com>
Reviewed-and-Tested-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpuidle/sysfs.txt  |    5 +++
 drivers/cpuidle/cpuidle.c        |    1 
 drivers/cpuidle/governors/menu.c |    5 +++
 drivers/cpuidle/sysfs.c          |   37 +++++++++++++++++++++++++++++
 include/linux/cpuidle.h          |    1 
 5 files changed, 48 insertions(+), 1 deletion(-)

diff -puN Documentation/cpuidle/sysfs.txt~cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose Documentation/cpuidle/sysfs.txt
--- a/Documentation/cpuidle/sysfs.txt~cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose
+++ a/Documentation/cpuidle/sysfs.txt
@@ -36,6 +36,7 @@ drwxr-xr-x 2 root root 0 Feb  8 10:42 st
 /sys/devices/system/cpu/cpu0/cpuidle/state0:
 total 0
 -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
+-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
 -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
 -r--r--r-- 1 root root 4096 Feb  8 10:42 name
 -r--r--r-- 1 root root 4096 Feb  8 10:42 power
@@ -45,6 +46,7 @@ total 0
 /sys/devices/system/cpu/cpu0/cpuidle/state1:
 total 0
 -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
+-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
 -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
 -r--r--r-- 1 root root 4096 Feb  8 10:42 name
 -r--r--r-- 1 root root 4096 Feb  8 10:42 power
@@ -54,6 +56,7 @@ total 0
 /sys/devices/system/cpu/cpu0/cpuidle/state2:
 total 0
 -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
+-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
 -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
 -r--r--r-- 1 root root 4096 Feb  8 10:42 name
 -r--r--r-- 1 root root 4096 Feb  8 10:42 power
@@ -63,6 +66,7 @@ total 0
 /sys/devices/system/cpu/cpu0/cpuidle/state3:
 total 0
 -r--r--r-- 1 root root 4096 Feb  8 10:42 desc
+-rw-r--r-- 1 root root 4096 Feb  8 10:42 disable
 -r--r--r-- 1 root root 4096 Feb  8 10:42 latency
 -r--r--r-- 1 root root 4096 Feb  8 10:42 name
 -r--r--r-- 1 root root 4096 Feb  8 10:42 power
@@ -72,6 +76,7 @@ total 0
 
 
 * desc : Small description about the idle state (string)
+* disable : Option to disable this idle state (bool)
 * latency : Latency to exit out of this idle state (in microseconds)
 * name : Name of the idle state (string)
 * power : Power consumed while in this idle state (in milliwatts)
diff -puN drivers/cpuidle/cpuidle.c~cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose
+++ a/drivers/cpuidle/cpuidle.c
@@ -245,6 +245,7 @@ static void poll_idle_init(struct cpuidl
 	state->power_usage = -1;
 	state->flags = 0;
 	state->enter = poll_idle;
+	state->disable = 0;
 }
 #else
 static void poll_idle_init(struct cpuidle_driver *drv) {}
diff -puN drivers/cpuidle/governors/menu.c~cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose
+++ a/drivers/cpuidle/governors/menu.c
@@ -280,7 +280,8 @@ static int menu_select(struct cpuidle_dr
 	 * We want to default to C1 (hlt), not to busy polling
 	 * unless the timer is happening really really soon.
 	 */
-	if (data->expected_us > 5)
+	if (data->expected_us > 5 &&
+		drv->states[CPUIDLE_DRIVER_STATE_START].disable == 0)
 		data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
 
 	/*
@@ -290,6 +291,8 @@ static int menu_select(struct cpuidle_dr
 	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
 		struct cpuidle_state *s = &drv->states[i];
 
+		if (s->disable)
+			continue;
 		if (s->target_residency > data->predicted_us)
 			continue;
 		if (s->exit_latency > latency_req)
diff -puN drivers/cpuidle/sysfs.c~cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose drivers/cpuidle/sysfs.c
--- a/drivers/cpuidle/sysfs.c~cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose
+++ a/drivers/cpuidle/sysfs.c
@@ -11,6 +11,7 @@
 #include <linux/sysfs.h>
 #include <linux/slab.h>
 #include <linux/cpu.h>
+#include <linux/capability.h>
 
 #include "cpuidle.h"
 
@@ -222,6 +223,9 @@ struct cpuidle_state_attr {
 #define define_one_state_ro(_name, show) \
 static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0444, show, NULL)
 
+#define define_one_state_rw(_name, show, store) \
+static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0644, show, store)
+
 #define define_show_state_function(_name) \
 static ssize_t show_state_##_name(struct cpuidle_state *state, \
 			 struct cpuidle_state_usage *state_usage, char *buf) \
@@ -229,6 +233,21 @@ static ssize_t show_state_##_name(struct
 	return sprintf(buf, "%u\n", state->_name);\
 }
 
+#define define_store_state_function(_name) \
+static ssize_t store_state_##_name(struct cpuidle_state *state, \
+		const char *buf, size_t size) \
+{ \
+	long value; \
+	if (!capable(CAP_SYS_ADMIN)) \
+		return -EPERM; \
+	kstrtol(buf, 0, &value); \
+	if (value) \
+		state->disable = 1; \
+	else \
+		state->disable = 0; \
+	return size; \
+}
+
 #define define_show_state_ull_function(_name) \
 static ssize_t show_state_##_name(struct cpuidle_state *state, \
 			struct cpuidle_state_usage *state_usage, char *buf) \
@@ -251,6 +270,8 @@ define_show_state_ull_function(usage)
 define_show_state_ull_function(time)
 define_show_state_str_function(name)
 define_show_state_str_function(desc)
+define_show_state_function(disable)
+define_store_state_function(disable)
 
 define_one_state_ro(name, show_state_name);
 define_one_state_ro(desc, show_state_desc);
@@ -258,6 +279,7 @@ define_one_state_ro(latency, show_state_
 define_one_state_ro(power, show_state_power_usage);
 define_one_state_ro(usage, show_state_usage);
 define_one_state_ro(time, show_state_time);
+define_one_state_rw(disable, show_state_disable, store_state_disable);
 
 static struct attribute *cpuidle_state_default_attrs[] = {
 	&attr_name.attr,
@@ -266,6 +288,7 @@ static struct attribute *cpuidle_state_d
 	&attr_power.attr,
 	&attr_usage.attr,
 	&attr_time.attr,
+	&attr_disable.attr,
 	NULL
 };
 
@@ -287,8 +310,22 @@ static ssize_t cpuidle_state_show(struct
 	return ret;
 }
 
+static ssize_t cpuidle_state_store(struct kobject *kobj,
+	struct attribute *attr, const char *buf, size_t size)
+{
+	int ret = -EIO;
+	struct cpuidle_state *state = kobj_to_state(kobj);
+	struct cpuidle_state_attr *cattr = attr_to_stateattr(attr);
+
+	if (cattr->store)
+		ret = cattr->store(state, buf, size);
+
+	return ret;
+}
+
 static const struct sysfs_ops cpuidle_state_sysfs_ops = {
 	.show = cpuidle_state_show,
+	.store = cpuidle_state_store,
 };
 
 static void cpuidle_state_sysfs_release(struct kobject *kobj)
diff -puN include/linux/cpuidle.h~cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose include/linux/cpuidle.h
--- a/include/linux/cpuidle.h~cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose
+++ a/include/linux/cpuidle.h
@@ -46,6 +46,7 @@ struct cpuidle_state {
 	unsigned int	exit_latency; /* in US */
 	unsigned int	power_usage; /* in mW */
 	unsigned int	target_residency; /* in US */
+	unsigned int    disable;
 
 	int (*enter)	(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,
_
Subject: Subject: cpuidle: add a sysfs entry to disable specific C state for debug purpose.

Patches currently in -mm which might be from shuox.liu@intel.com are

cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch

