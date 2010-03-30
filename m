From: akpm@linux-foundation.org
Subject: + cpufreq-unify-sysfs-attribute-definition-macros.patch added to -mm tree
Date: Tue, 30 Mar 2010 15:44:02 -0700
Message-ID: <201003302244.o2UMi3UC009311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703Ab0C3Wo7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Mar 2010 18:44:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: borislav.petkov@amd.com, davej@codemonkey.org.uk, hpa@zytor.com, mark.langsdorf@amd.com, mingo@elte.hu, tglx@linutronix.de, trenn@suse.de


The patch titled
     cpufreq: unify sysfs attribute definition macros
has been added to the -mm tree.  Its filename is
     cpufreq-unify-sysfs-attribute-definition-macros.patch

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
Subject: cpufreq: unify sysfs attribute definition macros
From: Borislav Petkov <borislav.petkov@amd.com>

Multiple modules used to define those which are with identical
functionality and were needlessly replicated among the different cpufreq
drivers.  Push them into the header and remove duplication.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Reviewed-by: Thomas Renninger <trenn@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c              |   40 ++++++-------------
 drivers/cpufreq/cpufreq_conservative.c |   48 +++++++----------------
 drivers/cpufreq/cpufreq_ondemand.c     |   40 +++++--------------
 include/linux/cpufreq.h                |   30 ++++++++++++++
 4 files changed, 72 insertions(+), 86 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~cpufreq-unify-sysfs-attribute-definition-macros drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-unify-sysfs-attribute-definition-macros
+++ a/drivers/cpufreq/cpufreq.c
@@ -662,32 +662,20 @@ static ssize_t show_bios_limit(struct cp
 	return sprintf(buf, "%u\n", policy->cpuinfo.max_freq);
 }
 
-#define define_one_ro(_name) \
-static struct freq_attr _name = \
-__ATTR(_name, 0444, show_##_name, NULL)
-
-#define define_one_ro0400(_name) \
-static struct freq_attr _name = \
-__ATTR(_name, 0400, show_##_name, NULL)
-
-#define define_one_rw(_name) \
-static struct freq_attr _name = \
-__ATTR(_name, 0644, show_##_name, store_##_name)
-
-define_one_ro0400(cpuinfo_cur_freq);
-define_one_ro(cpuinfo_min_freq);
-define_one_ro(cpuinfo_max_freq);
-define_one_ro(cpuinfo_transition_latency);
-define_one_ro(scaling_available_governors);
-define_one_ro(scaling_driver);
-define_one_ro(scaling_cur_freq);
-define_one_ro(bios_limit);
-define_one_ro(related_cpus);
-define_one_ro(affected_cpus);
-define_one_rw(scaling_min_freq);
-define_one_rw(scaling_max_freq);
-define_one_rw(scaling_governor);
-define_one_rw(scaling_setspeed);
+cpufreq_freq_attr_ro_perm(cpuinfo_cur_freq, 0400);
+cpufreq_freq_attr_ro(cpuinfo_min_freq);
+cpufreq_freq_attr_ro(cpuinfo_max_freq);
+cpufreq_freq_attr_ro(cpuinfo_transition_latency);
+cpufreq_freq_attr_ro(scaling_available_governors);
+cpufreq_freq_attr_ro(scaling_driver);
+cpufreq_freq_attr_ro(scaling_cur_freq);
+cpufreq_freq_attr_ro(bios_limit);
+cpufreq_freq_attr_ro(related_cpus);
+cpufreq_freq_attr_ro(affected_cpus);
+cpufreq_freq_attr_rw(scaling_min_freq);
+cpufreq_freq_attr_rw(scaling_max_freq);
+cpufreq_freq_attr_rw(scaling_governor);
+cpufreq_freq_attr_rw(scaling_setspeed);
 
 static struct attribute *default_attrs[] = {
 	&cpuinfo_min_freq.attr,
diff -puN drivers/cpufreq/cpufreq_conservative.c~cpufreq-unify-sysfs-attribute-definition-macros drivers/cpufreq/cpufreq_conservative.c
--- a/drivers/cpufreq/cpufreq_conservative.c~cpufreq-unify-sysfs-attribute-definition-macros
+++ a/drivers/cpufreq/cpufreq_conservative.c
@@ -178,12 +178,8 @@ static ssize_t show_sampling_rate_min(st
 	return sprintf(buf, "%u\n", min_sampling_rate);
 }
 
-#define define_one_ro(_name)		\
-static struct global_attr _name =	\
-__ATTR(_name, 0444, show_##_name, NULL)
-
-define_one_ro(sampling_rate_max);
-define_one_ro(sampling_rate_min);
+define_one_global_ro(sampling_rate_max);
+define_one_global_ro(sampling_rate_min);
 
 /* cpufreq_conservative Governor Tunables */
 #define show_one(file_name, object)					\
@@ -221,12 +217,8 @@ show_one_old(freq_step);
 show_one_old(sampling_rate_min);
 show_one_old(sampling_rate_max);
 
-#define define_one_ro_old(object, _name)	\
-static struct freq_attr object =		\
-__ATTR(_name, 0444, show_##_name##_old, NULL)
-
-define_one_ro_old(sampling_rate_min_old, sampling_rate_min);
-define_one_ro_old(sampling_rate_max_old, sampling_rate_max);
+cpufreq_freq_attr_ro_old(sampling_rate_min);
+cpufreq_freq_attr_ro_old(sampling_rate_max);
 
 /*** delete after deprecation time ***/
 
@@ -364,16 +356,12 @@ static ssize_t store_freq_step(struct ko
 	return count;
 }
 
-#define define_one_rw(_name) \
-static struct global_attr _name = \
-__ATTR(_name, 0644, show_##_name, store_##_name)
-
-define_one_rw(sampling_rate);
-define_one_rw(sampling_down_factor);
-define_one_rw(up_threshold);
-define_one_rw(down_threshold);
-define_one_rw(ignore_nice_load);
-define_one_rw(freq_step);
+define_one_global_rw(sampling_rate);
+define_one_global_rw(sampling_down_factor);
+define_one_global_rw(up_threshold);
+define_one_global_rw(down_threshold);
+define_one_global_rw(ignore_nice_load);
+define_one_global_rw(freq_step);
 
 static struct attribute *dbs_attributes[] = {
 	&sampling_rate_max.attr,
@@ -409,16 +397,12 @@ write_one_old(down_threshold);
 write_one_old(ignore_nice_load);
 write_one_old(freq_step);
 
-#define define_one_rw_old(object, _name)	\
-static struct freq_attr object =		\
-__ATTR(_name, 0644, show_##_name##_old, store_##_name##_old)
-
-define_one_rw_old(sampling_rate_old, sampling_rate);
-define_one_rw_old(sampling_down_factor_old, sampling_down_factor);
-define_one_rw_old(up_threshold_old, up_threshold);
-define_one_rw_old(down_threshold_old, down_threshold);
-define_one_rw_old(ignore_nice_load_old, ignore_nice_load);
-define_one_rw_old(freq_step_old, freq_step);
+cpufreq_freq_attr_rw_old(sampling_rate);
+cpufreq_freq_attr_rw_old(sampling_down_factor);
+cpufreq_freq_attr_rw_old(up_threshold);
+cpufreq_freq_attr_rw_old(down_threshold);
+cpufreq_freq_attr_rw_old(ignore_nice_load);
+cpufreq_freq_attr_rw_old(freq_step);
 
 static struct attribute *dbs_attributes_old[] = {
 	&sampling_rate_max_old.attr,
diff -puN drivers/cpufreq/cpufreq_ondemand.c~cpufreq-unify-sysfs-attribute-definition-macros drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~cpufreq-unify-sysfs-attribute-definition-macros
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -234,12 +234,8 @@ static ssize_t show_sampling_rate_min(st
 	return sprintf(buf, "%u\n", min_sampling_rate);
 }
 
-#define define_one_ro(_name)		\
-static struct global_attr _name =	\
-__ATTR(_name, 0444, show_##_name, NULL)
-
-define_one_ro(sampling_rate_max);
-define_one_ro(sampling_rate_min);
+define_one_global_ro(sampling_rate_max);
+define_one_global_ro(sampling_rate_min);
 
 /* cpufreq_ondemand Governor Tunables */
 #define show_one(file_name, object)					\
@@ -274,12 +270,8 @@ show_one_old(powersave_bias);
 show_one_old(sampling_rate_min);
 show_one_old(sampling_rate_max);
 
-#define define_one_ro_old(object, _name)       \
-static struct freq_attr object =               \
-__ATTR(_name, 0444, show_##_name##_old, NULL)
-
-define_one_ro_old(sampling_rate_min_old, sampling_rate_min);
-define_one_ro_old(sampling_rate_max_old, sampling_rate_max);
+cpufreq_freq_attr_ro_old(sampling_rate_min);
+cpufreq_freq_attr_ro_old(sampling_rate_max);
 
 /*** delete after deprecation time ***/
 
@@ -376,14 +368,10 @@ static ssize_t store_powersave_bias(stru
 	return count;
 }
 
-#define define_one_rw(_name) \
-static struct global_attr _name = \
-__ATTR(_name, 0644, show_##_name, store_##_name)
-
-define_one_rw(sampling_rate);
-define_one_rw(up_threshold);
-define_one_rw(ignore_nice_load);
-define_one_rw(powersave_bias);
+define_one_global_rw(sampling_rate);
+define_one_global_rw(up_threshold);
+define_one_global_rw(ignore_nice_load);
+define_one_global_rw(powersave_bias);
 
 static struct attribute *dbs_attributes[] = {
 	&sampling_rate_max.attr,
@@ -415,14 +403,10 @@ write_one_old(up_threshold);
 write_one_old(ignore_nice_load);
 write_one_old(powersave_bias);
 
-#define define_one_rw_old(object, _name)       \
-static struct freq_attr object =               \
-__ATTR(_name, 0644, show_##_name##_old, store_##_name##_old)
-
-define_one_rw_old(sampling_rate_old, sampling_rate);
-define_one_rw_old(up_threshold_old, up_threshold);
-define_one_rw_old(ignore_nice_load_old, ignore_nice_load);
-define_one_rw_old(powersave_bias_old, powersave_bias);
+cpufreq_freq_attr_rw_old(sampling_rate);
+cpufreq_freq_attr_rw_old(up_threshold);
+cpufreq_freq_attr_rw_old(ignore_nice_load);
+cpufreq_freq_attr_rw_old(powersave_bias);
 
 static struct attribute *dbs_attributes_old[] = {
        &sampling_rate_max_old.attr,
diff -puN include/linux/cpufreq.h~cpufreq-unify-sysfs-attribute-definition-macros include/linux/cpufreq.h
--- a/include/linux/cpufreq.h~cpufreq-unify-sysfs-attribute-definition-macros
+++ a/include/linux/cpufreq.h
@@ -278,6 +278,27 @@ struct freq_attr {
 	ssize_t (*store)(struct cpufreq_policy *, const char *, size_t count);
 };
 
+#define cpufreq_freq_attr_ro(_name)		\
+static struct freq_attr _name =			\
+__ATTR(_name, 0444, show_##_name, NULL)
+
+#define cpufreq_freq_attr_ro_perm(_name, _perm)	\
+static struct freq_attr _name =			\
+__ATTR(_name, _perm, show_##_name, NULL)
+
+#define cpufreq_freq_attr_ro_old(_name)		\
+static struct freq_attr _name##_old =		\
+__ATTR(_name, 0444, show_##_name##_old, NULL)
+
+#define cpufreq_freq_attr_rw(_name)		\
+static struct freq_attr _name =			\
+__ATTR(_name, 0644, show_##_name, store_##_name)
+
+#define cpufreq_freq_attr_rw_old(_name)		\
+static struct freq_attr _name##_old =		\
+__ATTR(_name, 0644, show_##_name##_old, store_##_name##_old)
+
+
 struct global_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct kobject *kobj,
@@ -286,6 +307,15 @@ struct global_attr {
 			 const char *c, size_t count);
 };
 
+#define define_one_global_ro(_name)		\
+static struct global_attr _name =		\
+__ATTR(_name, 0444, show_##_name, NULL)
+
+#define define_one_global_rw(_name)		\
+static struct global_attr _name =		\
+__ATTR(_name, 0644, show_##_name, store_##_name)
+
+
 /*********************************************************************
  *                        CPUFREQ 2.6. INTERFACE                     *
  *********************************************************************/
_

Patches currently in -mm which might be from borislav.petkov@amd.com are

x86-cpu-add-amd-core-boosting-feature-flag-to-proc-cpuinfo.patch
powernow-k8-add-core-performance-boost-support.patch
x86-unify-aperf-mperf-support.patch
cpufreq-add-aperf-mperf-support-for-amd-processors.patch
powernow-k8-fix-frequency-reporting.patch
cpufreq-unify-sysfs-attribute-definition-macros.patch
x86-add-optimized-popcnt-variants.patch

