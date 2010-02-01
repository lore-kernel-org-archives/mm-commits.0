From: akpm@linux-foundation.org
Subject: [to-be-updated] cpufreq-ondemand-independent-max-speed-for-nice-threads-with-nice_max_freq.patch removed from -mm tree
Date: Mon, 01 Feb 2010 11:37:13 -0800
Message-ID: <201002011937.o11JbEL1007863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755904Ab0BATjQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 14:39:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@android.com, davej@codemonkey.org.uk, trenn@suse.de, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq: ondemand: independent max speed for nice threads with nice_max_freq
has been removed from the -mm tree.  Its filename was
     cpufreq-ondemand-independent-max-speed-for-nice-threads-with-nice_max_freq.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: ondemand: independent max speed for nice threads with nice_max_freq
From: Mike Chan <mike@android.com>

Allow lower priority threads to scale frequency to specified
nice_max_freq.  This allows low priority threads to operate at the most
efficient power/performance frequency.

Often the highest and lowest cpu speeds do not provide the the optimal
performance/power ratios.  Latency requirements for normal and high
priority threads require the maximum speed that are not always optimal
power wise inorder to satisfy the requirements.

To enable set nice_max_freq (to a speed lower than the scaling_max_freq).

The governor will first attempt to scale the cpu to policy->max (default)
only using normal and high priority threads.  It will ignore nice threads.
 If the load is high enough without nice threads then ondemand will scale
to the max speed and exit.

If load for normal and high priority threads are not high enough to
increase the cpu speed, check again including the load from nice threads. 
Only scale to the nice_max_freq specified.

Previous behavior is maintained by setting the values below:

+ When nice_max_freq is set to 0, behavior is the current default (nice
  is counted for load).

+ When nice_max_freq is set to scaling_min_freq, the behavior is the
  same as the original ignore_nice_load == 1.  Which counts all nice
  threads as idle time when computing cpu load.

+ The ignore_nice_load sysfs still behaves the same as before (0/1) and
  is kept around for legacy support.  Userspace scripts should now use
  nice_max_freq.

Signed-off-by: Mike Chan <mike@android.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_ondemand.c |  163 +++++++++++++++++++--------
 1 file changed, 118 insertions(+), 45 deletions(-)

diff -puN drivers/cpufreq/cpufreq_ondemand.c~cpufreq-ondemand-independent-max-speed-for-nice-threads-with-nice_max_freq drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~cpufreq-ondemand-independent-max-speed-for-nice-threads-with-nice_max_freq
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -108,11 +108,13 @@ static struct dbs_tuners {
 	unsigned int down_differential;
 	unsigned int ignore_nice;
 	unsigned int powersave_bias;
+	unsigned int nice_max_freq;
 } dbs_tuners_ins = {
 	.up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
 	.down_differential = DEF_FREQUENCY_DOWN_DIFFERENTIAL,
 	.ignore_nice = 0,
 	.powersave_bias = 0,
+	.nice_max_freq = 0,
 };
 
 static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
@@ -251,6 +253,7 @@ static ssize_t show_##file_name						\
 show_one(sampling_rate, sampling_rate);
 show_one(up_threshold, up_threshold);
 show_one(ignore_nice_load, ignore_nice);
+show_one(nice_max_freq, nice_max_freq);
 show_one(powersave_bias, powersave_bias);
 
 /*** delete after deprecation time ***/
@@ -318,10 +321,48 @@ static ssize_t store_up_threshold(struct
 	return count;
 }
 
+/*
+ * Preserve ignore_nice_load behavior, if enabled do not allow low priority
+ * threads to scale beyond the minimum frequency.
+ */
 static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 				      const char *buf, size_t count)
 {
 	unsigned int input;
+	unsigned int j;
+
+	printk_once(KERN_INFO "CPUFREQ: ondemand ignore_nice_load"
+	       "sysfs file is deprecated - use nice_max_freq instead");
+
+	if (sscanf(buf, "%u", &input) != 1)
+		return -EINVAL;
+
+	if (input > 1)
+		input = 1;
+
+	mutex_lock(&dbs_mutex);
+	dbs_tuners_ins.ignore_nice = input;
+
+	for_each_online_cpu(j) {
+		struct cpufreq_policy *policy;
+		struct cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, j);
+		policy = dbs_info->cur_policy;
+
+
+		if (input && policy->min < dbs_tuners_ins.nice_max_freq)
+				dbs_tuners_ins.nice_max_freq = policy->min;
+		else if (!input && policy->max > dbs_tuners_ins.nice_max_freq)
+				dbs_tuners_ins.nice_max_freq = policy->max;
+	}
+	mutex_unlock(&dbs_mutex);
+
+	return count;
+}
+
+static ssize_t store_nice_max_freq(struct kobject *a, struct attribute *b,
+				      const char *buf, size_t count)
+{
+	unsigned int input;
 	int ret;
 
 	unsigned int j;
@@ -330,15 +371,13 @@ static ssize_t store_ignore_nice_load(st
 	if (ret != 1)
 		return -EINVAL;
 
-	if (input > 1)
-		input = 1;
-
 	mutex_lock(&dbs_mutex);
-	if (input == dbs_tuners_ins.ignore_nice) { /* nothing to do */
+	if (input == dbs_tuners_ins.nice_max_freq) { /* nothing to do */
 		mutex_unlock(&dbs_mutex);
 		return count;
 	}
-	dbs_tuners_ins.ignore_nice = input;
+
+	dbs_tuners_ins.nice_max_freq = input;
 
 	/* we need to re-evaluate prev_cpu_idle */
 	for_each_online_cpu(j) {
@@ -346,9 +385,7 @@ static ssize_t store_ignore_nice_load(st
 		dbs_info = &per_cpu(od_cpu_dbs_info, j);
 		dbs_info->prev_cpu_idle = get_cpu_idle_time(j,
 						&dbs_info->prev_cpu_wall);
-		if (dbs_tuners_ins.ignore_nice)
-			dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
-
+		dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
 	}
 	mutex_unlock(&dbs_mutex);
 
@@ -383,6 +420,7 @@ __ATTR(_name, 0644, show_##_name, store_
 define_one_rw(sampling_rate);
 define_one_rw(up_threshold);
 define_one_rw(ignore_nice_load);
+define_one_rw(nice_max_freq);
 define_one_rw(powersave_bias);
 
 static struct attribute *dbs_attributes[] = {
@@ -391,6 +429,7 @@ static struct attribute *dbs_attributes[
 	&sampling_rate.attr,
 	&up_threshold.attr,
 	&ignore_nice_load.attr,
+	&nice_max_freq.attr,
 	&powersave_bias.attr,
 	NULL
 };
@@ -443,20 +482,20 @@ static struct attribute_group dbs_attr_g
 
 /************************** sysfs end ************************/
 
-static int dbs_freq_increase(struct cpufreq_policy *p, unsigned int target_freq)
+static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
 {
 	if (dbs_tuners_ins.powersave_bias)
-		target_freq = powersave_bias_target(p, target_freq,
-				CPUFREQ_RELATION_H);
+		freq = powersave_bias_target(p, freq, CPUFREQ_RELATION_H);
 
-	__cpufreq_driver_target(p, target_freq,
-			dbs_tuners_ins.powersave_bias ?
+	__cpufreq_driver_target(p, freq, dbs_tuners_ins.powersave_bias ?
 			CPUFREQ_RELATION_L : CPUFREQ_RELATION_H);
 }
 
 static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 {
 	unsigned int max_load_freq;
+	unsigned int max_ignore_nice_load_freq;
+	unsigned int down_load_freq;
 
 	struct cpufreq_policy *policy;
 	unsigned int j;
@@ -477,12 +516,14 @@ static void dbs_check_cpu(struct cpu_dbs
 	 */
 
 	/* Get Absolute Load - in terms of freq */
-	max_load_freq = 0;
+	max_load_freq = max_ignore_nice_load_freq = 0;
 
 	for_each_cpu(j, policy->cpus) {
 		struct cpu_dbs_info_s *j_dbs_info;
 		cputime64_t cur_wall_time, cur_idle_time;
+		cputime64_t cur_nice;
 		unsigned int idle_time, wall_time;
+		unsigned long cur_nice_jiffies;
 		unsigned int load, load_freq;
 		int freq_avg;
 
@@ -498,44 +539,59 @@ static void dbs_check_cpu(struct cpu_dbs
 				j_dbs_info->prev_cpu_idle);
 		j_dbs_info->prev_cpu_idle = cur_idle_time;
 
-		if (dbs_tuners_ins.ignore_nice) {
-			cputime64_t cur_nice;
-			unsigned long cur_nice_jiffies;
-
-			cur_nice = cputime64_sub(kstat_cpu(j).cpustat.nice,
-					 j_dbs_info->prev_cpu_nice);
-			/*
-			 * Assumption: nice time between sampling periods will
-			 * be less than 2^32 jiffies for 32 bit sys
-			 */
-			cur_nice_jiffies = (unsigned long)
-					cputime64_to_jiffies64(cur_nice);
-
-			j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
-			idle_time += jiffies_to_usecs(cur_nice_jiffies);
-		}
-
 		if (unlikely(!wall_time || wall_time < idle_time))
 			continue;
 
-		load = 100 * (wall_time - idle_time) / wall_time;
-
 		freq_avg = __cpufreq_driver_getavg(policy, j);
 		if (freq_avg <= 0)
 			freq_avg = policy->cur;
 
+		/* Calculate load with with idle */
+		load = 100 * (wall_time - idle_time) / wall_time;
 		load_freq = load * freq_avg;
 		if (load_freq > max_load_freq)
 			max_load_freq = load_freq;
+
+		cur_nice = cputime64_sub(kstat_cpu(j).cpustat.nice,
+				j_dbs_info->prev_cpu_nice);
+		/*
+		 * Assumption: nice time between sampling periods will
+		 * be less than 2^32 jiffies for 32 bit sys
+		 */
+		cur_nice_jiffies =
+			(unsigned long) cputime64_to_jiffies64(cur_nice);
+
+		j_dbs_info->prev_cpu_nice = kstat_cpu(j).cpustat.nice;
+		idle_time += jiffies_to_usecs(cur_nice_jiffies);
+
+		if (unlikely(!wall_time || wall_time < idle_time))
+			continue;
+
+		/* Calculate load with without idle */
+		load = 100 * (wall_time - idle_time) / wall_time;
+		load_freq = load * freq_avg;
+		if (load_freq > max_ignore_nice_load_freq)
+			max_ignore_nice_load_freq = load_freq;
 	}
 
-	/* Check for frequency increase */
-	if (max_load_freq > dbs_tuners_ins.up_threshold * policy->cur) {
-		if (policy->cur != policy->max)
+	/* Check for frequency increase ignoring nice, scale to max */
+	if (max_ignore_nice_load_freq >
+			dbs_tuners_ins.up_threshold * policy->cur) {
+		if (policy->cur < policy->max)
 			dbs_freq_increase(policy, policy->max);
 		return;
 	}
 
+	/*
+	 * If we failed to increase frequency, check again including nice load.
+	 * This time only scale to the specified maximum speed for nice loads.
+	 */
+	if (max_load_freq > dbs_tuners_ins.up_threshold * policy->cur) {
+		if (policy->cur < dbs_tuners_ins.nice_max_freq)
+			dbs_freq_increase(policy, dbs_tuners_ins.nice_max_freq);
+		return;
+	}
+
 	/* Check for frequency decrease */
 	/* if we cannot reduce the frequency anymore, break out early */
 	if (policy->cur == policy->min)
@@ -546,14 +602,31 @@ static void dbs_check_cpu(struct cpu_dbs
 	 * can support the current CPU usage without triggering the up
 	 * policy. To be safe, we focus 10 points under the threshold.
 	 */
-	if (max_load_freq <
-	    (dbs_tuners_ins.up_threshold - dbs_tuners_ins.down_differential) *
-	     policy->cur) {
+	down_load_freq = (dbs_tuners_ins.up_threshold -
+			dbs_tuners_ins.down_differential) * policy->cur;
+
+	/* First attempt to scale down ignoring low priority threads */
+	if (max_ignore_nice_load_freq < down_load_freq) {
 		unsigned int freq_next;
-		freq_next = max_load_freq /
+		freq_next = max_ignore_nice_load_freq /
+				(dbs_tuners_ins.up_threshold -
+				 dbs_tuners_ins.down_differential);
+
+		/*
+		 * If freq_next is below nice_max, recalculate frequency
+		 * factoring in nice threads. We do not want to cripple
+		 * nice threads.
+		 */
+		if (freq_next < dbs_tuners_ins.nice_max_freq &&
+				max_load_freq < down_load_freq) {
+			freq_next = max_load_freq /
 				(dbs_tuners_ins.up_threshold -
 				 dbs_tuners_ins.down_differential);
 
+			if (freq_next > dbs_tuners_ins.nice_max_freq)
+				freq_next = dbs_tuners_ins.nice_max_freq;
+		}
+
 		if (freq_next < policy->min)
 			freq_next = policy->min;
 
@@ -649,13 +722,13 @@ static int cpufreq_governor_dbs(struct c
 			struct cpu_dbs_info_s *j_dbs_info;
 			j_dbs_info = &per_cpu(od_cpu_dbs_info, j);
 			j_dbs_info->cur_policy = policy;
