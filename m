From: akpm@linux-foundation.org
Subject: [to-be-updated] cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch removed from -mm tree
Date: Tue, 06 Mar 2012 15:58:26 -0800
Message-ID: <20120306235826.D2193A01B8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:48058 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706Ab2CFX63 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 18:58:29 -0500
Received: by eaaq10 with SMTP id q10so212075eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 15:58:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuox.liu@intel.com, hpa@zytor.com, len.brown@intel.com, lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de, yanmin_zhang@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpuidle: add a sysfs entry to disable specific C state for debug purpose.
has been removed from the -mm tree.  Its filename was
     cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/cpuidle.c        |    1 
 drivers/cpuidle/governors/menu.c |    5 +++-
 drivers/cpuidle/sysfs.c          |   34 +++++++++++++++++++++++++++++
 include/linux/cpuidle.h          |    1 
 4 files changed, 40 insertions(+), 1 deletion(-)

diff -puN drivers/cpuidle/cpuidle.c~cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose
+++ a/drivers/cpuidle/cpuidle.c
@@ -197,6 +197,7 @@ static void poll_idle_init(struct cpuidl
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
@@ -222,6 +222,9 @@ struct cpuidle_state_attr {
 #define define_one_state_ro(_name, show) \
 static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0444, show, NULL)
 
+#define define_one_state_rw(_name, show, store) \
+static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0644, show, store)
+
 #define define_show_state_function(_name) \
 static ssize_t show_state_##_name(struct cpuidle_state *state, \
 			 struct cpuidle_state_usage *state_usage, char *buf) \
@@ -229,6 +232,19 @@ static ssize_t show_state_##_name(struct
 	return sprintf(buf, "%u\n", state->_name);\
 }
 
+#define define_store_state_function(_name) \
+static ssize_t store_state_##_name(struct cpuidle_state *state, \
+		const char *buf, size_t size) \
+{ \
+	int value; \
+	sscanf(buf, "%d", &value); \
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
@@ -251,6 +267,8 @@ define_show_state_ull_function(usage)
 define_show_state_ull_function(time)
 define_show_state_str_function(name)
 define_show_state_str_function(desc)
+define_show_state_function(disable)
+define_store_state_function(disable)
 
 define_one_state_ro(name, show_state_name);
 define_one_state_ro(desc, show_state_desc);
@@ -258,6 +276,7 @@ define_one_state_ro(latency, show_state_
 define_one_state_ro(power, show_state_power_usage);
 define_one_state_ro(usage, show_state_usage);
 define_one_state_ro(time, show_state_time);
+define_one_state_rw(disable, show_state_disable, store_state_disable);
 
 static struct attribute *cpuidle_state_default_attrs[] = {
 	&attr_name.attr,
@@ -266,6 +285,7 @@ static struct attribute *cpuidle_state_d
 	&attr_power.attr,
 	&attr_usage.attr,
 	&attr_time.attr,
+	&attr_disable.attr,
 	NULL
 };
 
@@ -287,8 +307,22 @@ static ssize_t cpuidle_state_show(struct
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
@@ -45,6 +45,7 @@ struct cpuidle_state {
 	unsigned int	exit_latency; /* in US */
 	unsigned int	power_usage; /* in mW */
 	unsigned int	target_residency; /* in US */
+	unsigned int    disable;
 
 	int (*enter)	(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,
_

Patches currently in -mm which might be from shuox.liu@intel.com are


