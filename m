From: akpm@linux-foundation.org
Subject: - ondemand-governor-restructure-the-work-callback.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:56:01 -0800
Message-ID: <200702112256.l1BMu15F016374@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60698 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932903AbXBKW4T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:56:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, davej@codemonkey.org.uk, ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ondemand governor restructure the work callback
has been removed from the -mm tree.  Its filename was
     ondemand-governor-restructure-the-work-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ondemand governor restructure the work callback
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Restructure the delayed_work callback in ondemand.

This eliminates the need for smp_processor_id in the callback function and
also helps in proper locking and avoiding flush_workqueue when stopping the
governor (done in subsequent patch).

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_ondemand.c |   28 +++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN drivers/cpufreq/cpufreq_ondemand.c~ondemand-governor-restructure-the-work-callback drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~ondemand-governor-restructure-the-work-callback
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -52,19 +52,20 @@ static unsigned int def_sampling_rate;
 static void do_dbs_timer(struct work_struct *work);
 
 /* Sampling types */
-enum dbs_sample {DBS_NORMAL_SAMPLE, DBS_SUB_SAMPLE};
+enum {DBS_NORMAL_SAMPLE, DBS_SUB_SAMPLE};
 
 struct cpu_dbs_info_s {
 	cputime64_t prev_cpu_idle;
 	cputime64_t prev_cpu_wall;
 	struct cpufreq_policy *cur_policy;
  	struct delayed_work work;
-	enum dbs_sample sample_type;
-	unsigned int enable;
 	struct cpufreq_frequency_table *freq_table;
 	unsigned int freq_lo;
 	unsigned int freq_lo_jiffies;
 	unsigned int freq_hi_jiffies;
+	int cpu;
+	unsigned int enable:1,
+	             sample_type:1;
 };
 static DEFINE_PER_CPU(struct cpu_dbs_info_s, cpu_dbs_info);
 
@@ -402,7 +403,7 @@ static void dbs_check_cpu(struct cpu_dbs
 	if (load < (dbs_tuners_ins.up_threshold - 10)) {
 		unsigned int freq_next, freq_cur;
 
-		freq_cur = cpufreq_driver_getavg(policy);
+		freq_cur = __cpufreq_driver_getavg(policy);
 		if (!freq_cur)
 			freq_cur = policy->cur;
 
@@ -423,9 +424,11 @@ static void dbs_check_cpu(struct cpu_dbs
 
 static void do_dbs_timer(struct work_struct *work)
 {
-	unsigned int cpu = smp_processor_id();
-	struct cpu_dbs_info_s *dbs_info = &per_cpu(cpu_dbs_info, cpu);
-	enum dbs_sample sample_type = dbs_info->sample_type;
+	struct cpu_dbs_info_s *dbs_info =
+		container_of(work, struct cpu_dbs_info_s, work.work);
+	unsigned int cpu = dbs_info->cpu;
+	int sample_type = dbs_info->sample_type;
+
 	/* We want all CPUs to do sampling nearly on same jiffy */
 	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
 
@@ -454,17 +457,17 @@ static void do_dbs_timer(struct work_str
 	queue_delayed_work_on(cpu, kondemand_wq, &dbs_info->work, delay);
 }
 
-static inline void dbs_timer_init(unsigned int cpu)
+static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
 {
-	struct cpu_dbs_info_s *dbs_info = &per_cpu(cpu_dbs_info, cpu);
 	/* We want all CPUs to do sampling nearly on same jiffy */
 	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
 	delay -= jiffies % delay;
 
 	ondemand_powersave_bias_init();
-	INIT_DELAYED_WORK_NAR(&dbs_info->work, do_dbs_timer);
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
-	queue_delayed_work_on(cpu, kondemand_wq, &dbs_info->work, delay);
+	INIT_DELAYED_WORK_NAR(&dbs_info->work, do_dbs_timer);
+	queue_delayed_work_on(dbs_info->cpu, kondemand_wq, &dbs_info->work,
+	                      delay);
 }
 
 static inline void dbs_timer_exit(struct cpu_dbs_info_s *dbs_info)
@@ -528,6 +531,7 @@ static int cpufreq_governor_dbs(struct c
 			j_dbs_info->prev_cpu_idle = get_cpu_idle_time(j);
 			j_dbs_info->prev_cpu_wall = get_jiffies_64();
 		}
+		this_dbs_info->cpu = cpu;
 		this_dbs_info->enable = 1;
 		/*
 		 * Start the timerschedule work, when this governor
@@ -548,7 +552,7 @@ static int cpufreq_governor_dbs(struct c
 
 			dbs_tuners_ins.sampling_rate = def_sampling_rate;
 		}
-		dbs_timer_init(policy->cpu);
+		dbs_timer_init(this_dbs_info);
 
 		mutex_unlock(&dbs_mutex);
 		break;
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-cpufreq.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
