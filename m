From: akpm@linux-foundation.org
Subject: + nr_cpus-replace-nr_cpus-in-cpufreq-userspace-routines.patch added to -mm tree
Date: Sun, 20 Jul 2008 22:27:17 -0700
Message-ID: <200807210527.m6L5RHYh019201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752888AbYGUF1s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 01:27:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, davej@codemonkey.org.uk, jbaron@redhat.com


The patch titled
     NR_CPUS: replace NR_CPUS in cpufreq userspace routines
has been added to the -mm tree.  Its filename is
     nr_cpus-replace-nr_cpus-in-cpufreq-userspace-routines.patch

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
Subject: NR_CPUS: replace NR_CPUS in cpufreq userspace routines
From: Mike Travis <travis@sgi.com>

Replace arrays sized by NR_CPUS with percpu variables.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_userspace.c |   79 ++++++++++++++------------
 1 file changed, 43 insertions(+), 36 deletions(-)

diff -puN drivers/cpufreq/cpufreq_userspace.c~nr_cpus-replace-nr_cpus-in-cpufreq-userspace-routines drivers/cpufreq/cpufreq_userspace.c
--- a/drivers/cpufreq/cpufreq_userspace.c~nr_cpus-replace-nr_cpus-in-cpufreq-userspace-routines
+++ a/drivers/cpufreq/cpufreq_userspace.c
@@ -30,16 +30,18 @@
 /**
  * A few values needed by the userspace governor
  */
-static unsigned int	cpu_max_freq[NR_CPUS];
-static unsigned int	cpu_min_freq[NR_CPUS];
-static unsigned int	cpu_cur_freq[NR_CPUS]; /* current CPU freq */
-static unsigned int	cpu_set_freq[NR_CPUS]; /* CPU freq desired by userspace */
-static unsigned int	cpu_is_managed[NR_CPUS];
+static DEFINE_PER_CPU(unsigned int, cpu_max_freq);
+static DEFINE_PER_CPU(unsigned int, cpu_min_freq);
+static DEFINE_PER_CPU(unsigned int, cpu_cur_freq); /* current CPU freq */
+static DEFINE_PER_CPU(unsigned int, cpu_set_freq); /* CPU freq desired by
+							userspace */
+static DEFINE_PER_CPU(unsigned int, cpu_is_managed);
 
 static DEFINE_MUTEX	(userspace_mutex);
 static int cpus_using_userspace_governor;
 
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_GOVERNOR, "userspace", msg)
+#define dprintk(msg...) \
+	cpufreq_debug_printk(CPUFREQ_DEBUG_GOVERNOR, "userspace", msg)
 
 /* keep track of frequency transitions */
 static int
@@ -48,12 +50,12 @@ userspace_cpufreq_notifier(struct notifi
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
@@ -77,15 +79,15 @@ static int cpufreq_set(struct cpufreq_po
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
@@ -104,7 +106,7 @@ static int cpufreq_set(struct cpufreq_po
 
 static ssize_t show_speed(struct cpufreq_policy *policy, char *buf)
 {
-	return sprintf(buf, "%u\n", cpu_cur_freq[policy->cpu]);
+	return sprintf(buf, "%u\n", per_cpu(cpu_cur_freq, policy->cpu));
 }
 
 static int cpufreq_governor_userspace(struct cpufreq_policy *policy,
@@ -127,12 +129,17 @@ static int cpufreq_governor_userspace(st
 		}
 		cpus_using_userspace_governor++;
 
-		cpu_is_managed[cpu] = 1;
-		cpu_min_freq[cpu] = policy->min;
-		cpu_max_freq[cpu] = policy->max;
-		cpu_cur_freq[cpu] = policy->cur;
-		cpu_set_freq[cpu] = policy->cur;
-		dprintk("managing cpu %u started (%u - %u kHz, currently %u kHz)\n", cpu, cpu_min_freq[cpu], cpu_max_freq[cpu], cpu_cur_freq[cpu]);
+		per_cpu(cpu_is_managed, cpu) = 1;
+		per_cpu(cpu_min_freq, cpu) = policy->min;
+		per_cpu(cpu_max_freq, cpu) = policy->max;
+		per_cpu(cpu_cur_freq, cpu) = policy->cur;
+		per_cpu(cpu_set_freq, cpu) = policy->cur;
+		dprintk("managing cpu %u started "
+			"(%u - %u kHz, currently %u kHz)\n",
+				cpu,
+				per_cpu(cpu_min_freq, cpu),
+				per_cpu(cpu_max_freq, cpu),
+				per_cpu(cpu_cur_freq, cpu));
 
 		mutex_unlock(&userspace_mutex);
 		break;
@@ -145,34 +152,34 @@ static int cpufreq_governor_userspace(st
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
 	case CPUFREQ_GOV_LIMITS:
 		mutex_lock(&userspace_mutex);
-		dprintk("limit event for cpu %u: %u - %u kHz,"
+		dprintk("limit event for cpu %u: %u - %u kHz, "
 			"currently %u kHz, last set to %u kHz\n",
 			cpu, policy->min, policy->max,
-			cpu_cur_freq[cpu], cpu_set_freq[cpu]);
-		if (policy->max < cpu_set_freq[cpu]) {
+			per_cpu(cpu_cur_freq, cpu),
+			per_cpu(cpu_set_freq, cpu));
+		if (policy->max < per_cpu(cpu_set_freq, cpu)) {
 			__cpufreq_driver_target(policy, policy->max,
 						CPUFREQ_RELATION_H);
-		}
-		else if (policy->min > cpu_set_freq[cpu]) {
+		} else if (policy->min > per_cpu(cpu_set_freq, cpu)) {
 			__cpufreq_driver_target(policy, policy->min,
 						CPUFREQ_RELATION_L);
-		}
-		else {
-			__cpufreq_driver_target(policy, cpu_set_freq[cpu],
+		} else {
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
linux-next.patch
adapt-drivers-base-topologyc-to-new-sysfs-api.patch
nr_cpus-replace-nr_cpus-in-cpufreq-userspace-routines.patch
kthread-reduce-stack-pressure-in-create_kthread-and-kthreadd.patch

