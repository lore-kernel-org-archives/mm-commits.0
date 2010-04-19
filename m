From: akpm@linux-foundation.org
Subject: + ondemand-solve-the-big-performance-issue-with-ondemand-during-disk-io.patch added to -mm tree
Date: Mon, 19 Apr 2010 15:35:47 -0700
Message-ID: <201004192235.o3JMZl4n013705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752801Ab0DSWft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Apr 2010 18:35:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     ondemand: Solve the big performance issue with ondemand during disk IO
has been added to the -mm tree.  Its filename is
     ondemand-solve-the-big-performance-issue-with-ondemand-during-disk-io.patch

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
Subject: ondemand: Solve the big performance issue with ondemand during disk IO
From: Arjan van de Ven <arjan@linux.intel.com>

The ondemand cpufreq governor uses CPU busy time (e.g. not-idle time) as
a measure for scaling the CPU frequency up or down.
If the CPU is busy, the CPU frequency scales up, if it's idle, the CPU
frequency scales down. Effectively, it uses the CPU busy time as proxy
variable for the more nebulous "how critical is performance right now"
question.

This algorithm falls flat on its face in the light of workloads where
you're alternatingly disk and CPU bound, such as the ever popular
"git grep", but also things like startup of programs and maildir using
email clients... much to the chagarin of Andrew Morton.

This patch changes the ondemand algorithm to count iowait time as busy,
not idle, time. As shown in the breakdown cases above, iowait is performance
critical often, and by counting iowait, the proxy variable becomes a more
accurate representation of the "how critical is performance" question.

The problem and fix are both verified with the "perf timechar" tool.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_ondemand.c |   30 +++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff -puN drivers/cpufreq/cpufreq_ondemand.c~ondemand-solve-the-big-performance-issue-with-ondemand-during-disk-io drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~ondemand-solve-the-big-performance-issue-with-ondemand-during-disk-io
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -73,6 +73,7 @@ enum {DBS_NORMAL_SAMPLE, DBS_SUB_SAMPLE}
 
 struct cpu_dbs_info_s {
 	cputime64_t prev_cpu_idle;
+	cputime64_t prev_cpu_iowait;
 	cputime64_t prev_cpu_wall;
 	cputime64_t prev_cpu_nice;
 	struct cpufreq_policy *cur_policy;
@@ -148,6 +149,16 @@ static inline cputime64_t get_cpu_idle_t
 	return idle_time;
 }
 
+static inline cputime64_t get_cpu_iowait_time(unsigned int cpu, cputime64_t *wall)
+{
+	u64 iowait_time = get_cpu_iowait_time_us(cpu, wall);
+
+	if (iowait_time == -1ULL)
+		return 0;
+
+	return iowait_time;
+}
+
 /*
  * Find right freq to be set now with powersave_bias on.
  * Returns the freq_hi to be used right now and will set freq_hi_jiffies,
@@ -465,14 +476,15 @@ static void dbs_check_cpu(struct cpu_dbs
 
 	for_each_cpu(j, policy->cpus) {
 		struct cpu_dbs_info_s *j_dbs_info;
-		cputime64_t cur_wall_time, cur_idle_time;
-		unsigned int idle_time, wall_time;
+		cputime64_t cur_wall_time, cur_idle_time, cur_iowait_time;
+		unsigned int idle_time, wall_time, iowait_time;
 		unsigned int load, load_freq;
 		int freq_avg;
 
 		j_dbs_info = &per_cpu(od_cpu_dbs_info, j);
 
 		cur_idle_time = get_cpu_idle_time(j, &cur_wall_time);
+		cur_iowait_time = get_cpu_iowait_time(j, &cur_wall_time);
 
 		wall_time = (unsigned int) cputime64_sub(cur_wall_time,
 				j_dbs_info->prev_cpu_wall);
@@ -482,6 +494,10 @@ static void dbs_check_cpu(struct cpu_dbs
 				j_dbs_info->prev_cpu_idle);
 		j_dbs_info->prev_cpu_idle = cur_idle_time;
 
+		iowait_time = (unsigned int) cputime64_sub(cur_iowait_time,
+				j_dbs_info->prev_cpu_iowait);
+		j_dbs_info->prev_cpu_iowait = cur_iowait_time;
+
 		if (dbs_tuners_ins.ignore_nice) {
 			cputime64_t cur_nice;
 			unsigned long cur_nice_jiffies;
@@ -499,6 +515,16 @@ static void dbs_check_cpu(struct cpu_dbs
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
+		/*
+		 * For the purpose of ondemand, waiting for disk IO is an
+		 * indication that you're performance critical, and not that
+		 * the system is actually idle. So subtract the iowait time
+		 * from the cpu idle time.
+		 */
+
+		if (idle_time >= iowait_time)
+			idle_time -= iowait_time;
+
 		if (unlikely(!wall_time || wall_time < idle_time))
 			continue;
 
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
sched-add-a-comment-to-get_cpu_idle_time_us.patch
sched-introduce-a-function-to-update-the-idle-statistics.patch
sched-update-the-idle-statistics-in-get_cpu_idle_time_us.patch
sched-fold-updating-of-the-last-update-time-into-update_ts_time_stats.patch
sched-eliminate-the-ts-idle_lastupdate-field.patch
sched-introduce-get_cpu_iowait_time_us.patch
ondemand-solve-the-big-performance-issue-with-ondemand-during-disk-io.patch

