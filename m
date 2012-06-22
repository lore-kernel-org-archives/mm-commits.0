From: akpm@linux-foundation.org
Subject: + cpuidle-move-field-disable-from-per-driver-to-per-cpu.patch added to -mm tree
Date: Fri, 22 Jun 2012 16:10:35 -0700
Message-ID: <20120622231035.EFC76A026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:63974 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2FVXKi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jun 2012 19:10:38 -0400
Received: by weyu7 with SMTP id u7so132289wey.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Jun 2012 16:10:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shuox.liu@intel.com, aschorr@telemetry-investments.com, len.brown@intel.com, lenb@kernel.org, yanmin_zhang@intel.com


The patch titled
     Subject: cpuidle: move field disable from per-driver to per-cpu
has been added to the -mm tree.  Its filename is
     cpuidle-move-field-disable-from-per-driver-to-per-cpu.patch

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
Subject: cpuidle: move field disable from per-driver to per-cpu

Andrew J.Schorr raises a question.  When he changes the disable setting on
a single CPU, it affects all the other CPUs.  Basically, currently, the
disable field is per-driver instead of per-cpu.  All the C states of the
same driver are shared by all CPU in the same machine.

The patch changes the `disable' field to per-cpu, so we could set this
separately for each cpu.

Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
Reported-by: Andrew J.Schorr <aschorr@telemetry-investments.com>
Reviewed-by: Yanmin Zhang <yanmin_zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/cpuidle.c        |    1 -
 drivers/cpuidle/governors/menu.c |    5 +++--
 drivers/cpuidle/sysfs.c          |   21 ++++++++++++---------
 include/linux/cpuidle.h          |    2 +-
 4 files changed, 16 insertions(+), 13 deletions(-)

diff -puN drivers/cpuidle/cpuidle.c~cpuidle-move-field-disable-from-per-driver-to-per-cpu drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~cpuidle-move-field-disable-from-per-driver-to-per-cpu
+++ a/drivers/cpuidle/cpuidle.c
@@ -276,7 +276,6 @@ static void poll_idle_init(struct cpuidl
 	state->power_usage = -1;
 	state->flags = 0;
 	state->enter = poll_idle;
-	state->disable = 0;
 }
 #else
 static void poll_idle_init(struct cpuidle_driver *drv) {}
diff -puN drivers/cpuidle/governors/menu.c~cpuidle-move-field-disable-from-per-driver-to-per-cpu drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~cpuidle-move-field-disable-from-per-driver-to-per-cpu
+++ a/drivers/cpuidle/governors/menu.c
@@ -281,7 +281,7 @@ static int menu_select(struct cpuidle_dr
 	 * unless the timer is happening really really soon.
 	 */
 	if (data->expected_us > 5 &&
-		drv->states[CPUIDLE_DRIVER_STATE_START].disable == 0)
+		dev->states_usage[CPUIDLE_DRIVER_STATE_START].disable == 0)
 		data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
 
 	/*
@@ -290,8 +290,9 @@ static int menu_select(struct cpuidle_dr
 	 */
 	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
 		struct cpuidle_state *s = &drv->states[i];
+		struct cpuidle_state_usage *su = &dev->states_usage[i];
 
-		if (s->disable)
+		if (su->disable)
 			continue;
 		if (s->target_residency > data->predicted_us)
 			continue;
diff -puN drivers/cpuidle/sysfs.c~cpuidle-move-field-disable-from-per-driver-to-per-cpu drivers/cpuidle/sysfs.c
--- a/drivers/cpuidle/sysfs.c~cpuidle-move-field-disable-from-per-driver-to-per-cpu
+++ a/drivers/cpuidle/sysfs.c
@@ -217,7 +217,8 @@ struct cpuidle_state_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct cpuidle_state *, \
 					struct cpuidle_state_usage *, char *);
-	ssize_t (*store)(struct cpuidle_state *, const char *, size_t);
+	ssize_t (*store)(struct cpuidle_state *, \
+			struct cpuidle_state_usage *, const char *, size_t);
 };
 
 #define define_one_state_ro(_name, show) \
@@ -233,21 +234,22 @@ static ssize_t show_state_##_name(struct
 	return sprintf(buf, "%u\n", state->_name);\
 }
 
-#define define_store_state_function(_name) \
+#define define_store_state_ull_function(_name) \
 static ssize_t store_state_##_name(struct cpuidle_state *state, \
+		struct cpuidle_state_usage *state_usage, \
 		const char *buf, size_t size) \
 { \
-	long value; \
+	unsigned long long value; \
 	int err; \
 	if (!capable(CAP_SYS_ADMIN)) \
 		return -EPERM; \
-	err = kstrtol(buf, 0, &value); \
+	err = kstrtoull(buf, 0, &value); \
 	if (err) \
 		return err; \
 	if (value) \
-		state->disable = 1; \
+		state_usage->_name = 1; \
 	else \
-		state->disable = 0; \
+		state_usage->_name = 0; \
 	return size; \
 }
 
@@ -273,8 +275,8 @@ define_show_state_ull_function(usage)
 define_show_state_ull_function(time)
 define_show_state_str_function(name)
 define_show_state_str_function(desc)
-define_show_state_function(disable)
-define_store_state_function(disable)
+define_show_state_ull_function(disable)
+define_store_state_ull_function(disable)
 
 define_one_state_ro(name, show_state_name);
 define_one_state_ro(desc, show_state_desc);
@@ -318,10 +320,11 @@ static ssize_t cpuidle_state_store(struc
 {
 	int ret = -EIO;
 	struct cpuidle_state *state = kobj_to_state(kobj);
+	struct cpuidle_state_usage *state_usage = kobj_to_state_usage(kobj);
 	struct cpuidle_state_attr *cattr = attr_to_stateattr(attr);
 
 	if (cattr->store)
-		ret = cattr->store(state, buf, size);
+		ret = cattr->store(state, state_usage, buf, size);
 
 	return ret;
 }
diff -puN include/linux/cpuidle.h~cpuidle-move-field-disable-from-per-driver-to-per-cpu include/linux/cpuidle.h
--- a/include/linux/cpuidle.h~cpuidle-move-field-disable-from-per-driver-to-per-cpu
+++ a/include/linux/cpuidle.h
@@ -34,6 +34,7 @@ struct cpuidle_driver;
 struct cpuidle_state_usage {
 	void		*driver_data;
 
+	unsigned long long	disable;
 	unsigned long long	usage;
 	unsigned long long	time; /* in US */
 };
@@ -46,7 +47,6 @@ struct cpuidle_state {
 	unsigned int	exit_latency; /* in US */
 	int		power_usage; /* in mW */
 	unsigned int	target_residency; /* in US */
-	unsigned int    disable;
 
 	int (*enter)	(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,
_
Subject: Subject: cpuidle: move field disable from per-driver to per-cpu

Patches currently in -mm which might be from shuox.liu@intel.com are

cpuidle-move-field-disable-from-per-driver-to-per-cpu.patch

