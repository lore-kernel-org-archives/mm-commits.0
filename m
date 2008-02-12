From: akpm@linux-foundation.org
Subject: + cpufreq-change-cpu-freq-tables-to-per_cpu-variables.patch added to -mm tree
Date: Tue, 12 Feb 2008 15:35:05 -0800
Message-ID: <200802122335.m1CNZ5ZQ028787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58318 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752617AbYBLXfS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 18:35:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, davej@codemonkey.org.uk


The patch titled
     cpufreq: change cpu freq tables to per_cpu variables
has been added to the -mm tree.  Its filename is
     cpufreq-change-cpu-freq-tables-to-per_cpu-variables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: change cpu freq tables to per_cpu variables
From: Mike Travis <travis@sgi.com>

Change cpu frequency tables from arrays to per_cpu variables.

Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_userspace.c |   70 +++++++++++++-------------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff -puN drivers/cpufreq/cpufreq_userspace.c~cpufreq-change-cpu-freq-tables-to-per_cpu-variables drivers/cpufreq/cpufreq_userspace.c
--- a/drivers/cpufreq/cpufreq_userspace.c~cpufreq-change-cpu-freq-tables-to-per_cpu-variables
+++ a/drivers/cpufreq/cpufreq_userspace.c
@@ -30,11 +30,11 @@
 /**
  * A few values needed by the userspace governor
  */
-static unsigned int	cpu_max_freq[NR_CPUS];
-static unsigned int	cpu_min_freq[NR_CPUS];
-static unsigned int	cpu_cur_freq[NR_CPUS]; /* current CPU freq */
-static unsigned int	cpu_set_freq[NR_CPUS]; /* CPU freq desired by userspace */
-static unsigned int	cpu_is_managed[NR_CPUS];
+DEFINE_PER_CPU(int, cpu_max_freq);
+DEFINE_PER_CPU(int, cpu_min_freq);
+DEFINE_PER_CPU(int, cpu_cur_freq); /* current CPU freq */
+DEFINE_PER_CPU(int, cpu_set_freq); /* CPU freq desired by userspace */
+DEFINE_PER_CPU(int, cpu_is_managed);
 
 static DEFINE_MUTEX	(userspace_mutex);
 static int cpus_using_userspace_governor;
@@ -48,12 +48,12 @@ userspace_cpufreq_notifier(struct notifi
 {
         struct cpufreq_freqs *freq = data;
 
-	if (!cpu_is_managed[freq->cpu])
+	if (!per_cpu(cpu_is_managed, freq->cpu))
 		return 0;
 
 	dprintk("saving cpu_cur_freq of cpu %u to be %u kHz\n",
 			freq->cpu, freq->new);
-	cpu_cur_freq[freq->cpu] = freq->new;
+	per_cpu(cpu_cur_freq, freq->cpu) = freq->new;
 
         return 0;
 }
@@ -77,15 +77,15 @@ static int cpufreq_set(struct cpufreq_po
 	dprintk("cpufreq_set for cpu %u, freq %u kHz\n", policy->cpu, freq);
 
 	mutex_lock(&userspace_mutex);
-	if (!cpu_is_managed[policy->cpu])
+	if (!per_cpu(cpu_is_managed, policy->cpu))
 		goto err;
 
-	cpu_set_freq[policy->cpu] = freq;
+	per_cpu(cpu_set_freq, policy->cpu) = freq;
 
-	if (freq < cpu_min_freq[policy->cpu])
-		freq = cpu_min_freq[policy->cpu];
-	if (freq > cpu_max_freq[policy->cpu])
-		freq = cpu_max_freq[policy->cpu];
+	if (freq < per_cpu(cpu_min_freq, policy->cpu))
+		freq = per_cpu(cpu_min_freq, policy->cpu);
+	if (freq > per_cpu(cpu_max_freq, policy->cpu))
+		freq = per_cpu(cpu_max_freq, policy->cpu);
 
 	/*
 	 * We're safe from concurrent calls to ->target() here
@@ -101,10 +101,9 @@ static int cpufreq_set(struct cpufreq_po
 	return ret;
 }
 
-
 static ssize_t show_speed(struct cpufreq_policy *policy, char *buf)
 {
-	return sprintf(buf, "%u\n", cpu_cur_freq[policy->cpu]);
+	return sprintf (buf, "%u\n", per_cpu(cpu_cur_freq, policy->cpu));
 }
 
 static int cpufreq_governor_userspace(struct cpufreq_policy *policy,
@@ -127,13 +126,16 @@ static int cpufreq_governor_userspace(st
 		}
 		cpus_using_userspace_governor++;
 
-		cpu_is_managed[cpu] = 1;
-		cpu_min_freq[cpu] = policy->min;
-		cpu_max_freq[cpu] = policy->max;
-		cpu_cur_freq[cpu] = policy->cur;
-		cpu_set_freq[cpu] = policy->cur;
-		dprintk("managing cpu %u started (%u - %u kHz, currently %u kHz)\n", cpu, cpu_min_freq[cpu], cpu_max_freq[cpu], cpu_cur_freq[cpu]);
-
+		per_cpu(cpu_is_managed, cpu) = 1;
+		per_cpu(cpu_min_freq, cpu) = policy->min;
+		per_cpu(cpu_max_freq, cpu) = policy->max;
+		per_cpu(cpu_cur_freq, cpu) = policy->cur;
+		per_cpu(cpu_set_freq, cpu) = policy->cur;
+		dprintk("managing cpu %u started "
+			"(%u - %u kHz, currently %u kHz)\n", cpu,
+				per_cpu(cpu_min_freq, cpu),
+				per_cpu(cpu_max_freq, cpu),
+				per_cpu(cpu_cur_freq, cpu));
 		mutex_unlock(&userspace_mutex);
 		break;
 	case CPUFREQ_GOV_STOP:
@@ -145,10 +147,10 @@ static int cpufreq_governor_userspace(st
 					CPUFREQ_TRANSITION_NOTIFIER);
 		}
 
-		cpu_is_managed[cpu] = 0;
-		cpu_min_freq[cpu] = 0;
-		cpu_max_freq[cpu] = 0;
-		cpu_set_freq[cpu] = 0;
+		per_cpu(cpu_is_managed, cpu) = 0;
+		per_cpu(cpu_min_freq, cpu) = 0;
+		per_cpu(cpu_max_freq, cpu) = 0;
+		per_cpu(cpu_set_freq, cpu) = 0;
 		dprintk("managing cpu %u stopped\n", cpu);
 		mutex_unlock(&userspace_mutex);
 		break;
@@ -157,22 +159,24 @@ static int cpufreq_governor_userspace(st
 		dprintk("limit event for cpu %u: %u - %u kHz,"
 			"currently %u kHz, last set to %u kHz\n",
 			cpu, policy->min, policy->max,
-			cpu_cur_freq[cpu], cpu_set_freq[cpu]);
-		if (policy->max < cpu_set_freq[cpu]) {
+			per_cpu(cpu_cur_freq, cpu),
+			per_cpu(cpu_set_freq, cpu));
+		if (policy->max < per_cpu(cpu_set_freq, cpu)) {
 			__cpufreq_driver_target(policy, policy->max,
 						CPUFREQ_RELATION_H);
 		}
-		else if (policy->min > cpu_set_freq[cpu]) {
+		else if (policy->min > per_cpu(cpu_set_freq, cpu)) {
 			__cpufreq_driver_target(policy, policy->min,
 						CPUFREQ_RELATION_L);
 		}
 		else {
-			__cpufreq_driver_target(policy, cpu_set_freq[cpu],
+			__cpufreq_driver_target(policy,
+						per_cpu(cpu_set_freq, cpu),
 						CPUFREQ_RELATION_L);
 		}
-		cpu_min_freq[cpu] = policy->min;
-		cpu_max_freq[cpu] = policy->max;
-		cpu_cur_freq[cpu] = policy->cur;
+		per_cpu(cpu_min_freq, cpu) = policy->min;
+		per_cpu(cpu_max_freq, cpu) = policy->max;
+		per_cpu(cpu_cur_freq, cpu) = policy->cur;
 		mutex_unlock(&userspace_mutex);
 		break;
 	}
_

Patches currently in -mm which might be from travis@sgi.com are

origin.patch
cpufreq-change-cpu-freq-tables-to-per_cpu-variables.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
x86-minor-cleanup-of-comments-in-processorh.patch
