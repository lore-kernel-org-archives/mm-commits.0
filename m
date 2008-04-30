From: akpm@linux-foundation.org
Subject: - cpufreq-expose-cpufreq-coordination-requirements-regardless-of-coordination-mechanism.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:54 -0700
Message-ID: <200804300550.m3U5osJp030167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759172AbYD3FvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:51:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     cpufreq: expose cpufreq coordination requirements regardless of coordination mechanism
has been removed from the -mm tree.  Its filename was
     cpufreq-expose-cpufreq-coordination-requirements-regardless-of-coordination-mechanism.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: expose cpufreq coordination requirements regardless of coordination mechanism
From: "Darrick J. Wong" <djwong@us.ibm.com>

Currently, affected_cpus shows which CPUs need to have their frequency
coordinated in software.  When hardware coordination is in use, the contents
of this file appear the same as when no coordination is required.  This can
lead to some confusion among user-space programs, for example, that do not
know that extra coordination is required to force a CPU core to a particular
speed to control power consumption.

To fix this, create a "related_cpus" attribute that always displays the
coordination map regardless of whatever coordination strategy the cpufreq
driver uses (sw or hw).  If the cpufreq driver does not provide a value, fall
back to policy->cpus.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    1 
 drivers/cpufreq/cpufreq.c                  |   29 +++++++++++++++----
 include/linux/cpufreq.h                    |    3 +
 3 files changed, 27 insertions(+), 6 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~cpufreq-expose-cpufreq-coordination-requirements-regardless-of-coordination-mechanism arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~cpufreq-expose-cpufreq-coordination-requirements-regardless-of-coordination-mechanism
+++ a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -591,6 +591,7 @@ static int acpi_cpufreq_cpu_init(struct 
 	    policy->shared_type == CPUFREQ_SHARED_TYPE_ANY) {
 		policy->cpus = perf->shared_cpu_map;
 	}
+	policy->related_cpus = perf->shared_cpu_map;
 
 #ifdef CONFIG_SMP
 	dmi_check_system(sw_any_bug_dmi_table);
diff -puN drivers/cpufreq/cpufreq.c~cpufreq-expose-cpufreq-coordination-requirements-regardless-of-coordination-mechanism drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-expose-cpufreq-coordination-requirements-regardless-of-coordination-mechanism
+++ a/drivers/cpufreq/cpufreq.c
@@ -583,15 +583,13 @@ out:
 	i += sprintf(&buf[i], "\n");
 	return i;
 }
-/**
- * show_affected_cpus - show the CPUs affected by each transition
- */
-static ssize_t show_affected_cpus(struct cpufreq_policy *policy, char *buf)
+
+static ssize_t show_cpus(cpumask_t mask, char *buf)
 {
 	ssize_t i = 0;
 	unsigned int cpu;
 
-	for_each_cpu_mask(cpu, policy->cpus) {
+	for_each_cpu_mask(cpu, mask) {
 		if (i)
 			i += scnprintf(&buf[i], (PAGE_SIZE - i - 2), " ");
 		i += scnprintf(&buf[i], (PAGE_SIZE - i - 2), "%u", cpu);
@@ -602,6 +600,25 @@ static ssize_t show_affected_cpus(struct
 	return i;
 }
 
+/**
+ * show_related_cpus - show the CPUs affected by each transition even if
+ * hw coordination is in use
+ */
+static ssize_t show_related_cpus(struct cpufreq_policy *policy, char *buf)
+{
+	if (cpus_empty(policy->related_cpus))
+		return show_cpus(policy->cpus, buf);
+	return show_cpus(policy->related_cpus, buf);
+}
+
+/**
+ * show_affected_cpus - show the CPUs affected by each transition
+ */
+static ssize_t show_affected_cpus(struct cpufreq_policy *policy, char *buf)
+{
+	return show_cpus(policy->cpus, buf);
+}
+
 static ssize_t store_scaling_setspeed(struct cpufreq_policy *policy,
 					const char *buf, size_t count)
 {
@@ -646,6 +663,7 @@ define_one_ro(cpuinfo_max_freq);
 define_one_ro(scaling_available_governors);
 define_one_ro(scaling_driver);
 define_one_ro(scaling_cur_freq);
+define_one_ro(related_cpus);
 define_one_ro(affected_cpus);
 define_one_rw(scaling_min_freq);
 define_one_rw(scaling_max_freq);
@@ -658,6 +676,7 @@ static struct attribute *default_attrs[]
 	&scaling_min_freq.attr,
 	&scaling_max_freq.attr,
 	&affected_cpus.attr,
+	&related_cpus.attr,
 	&scaling_governor.attr,
 	&scaling_driver.attr,
 	&scaling_available_governors.attr,
diff -puN include/linux/cpufreq.h~cpufreq-expose-cpufreq-coordination-requirements-regardless-of-coordination-mechanism include/linux/cpufreq.h
--- a/include/linux/cpufreq.h~cpufreq-expose-cpufreq-coordination-requirements-regardless-of-coordination-mechanism
+++ a/include/linux/cpufreq.h
@@ -83,7 +83,8 @@ struct cpufreq_real_policy {
 };
 
 struct cpufreq_policy {
-	cpumask_t		cpus;	/* affected CPUs */
+	cpumask_t		cpus;	/* CPUs requiring sw coordination */
+	cpumask_t		related_cpus; /* CPUs with any coordination */
 	unsigned int		shared_type; /* ANY or ALL affected CPUs
 						should set cpufreq */
 	unsigned int		cpu;    /* cpu nr of registered CPU */
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
git-hwmon.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
adt7473-minor-documentation-update.patch

