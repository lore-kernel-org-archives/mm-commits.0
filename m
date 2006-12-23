From: akpm@osdl.org
Subject: - bug-fix-for-acpi-cpufreq-and-cpufreq_stats-oops-on-frequency-change-notification.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:55:23 -0800
Message-ID: <200612230755.kBN7tN7c010292@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49869 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbWLWHze (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:55:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, davej@codemonkey.org.uk, dhaval.giani@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Bug fix for acpi-cpufreq and cpufreq_stats oops on frequency change notification
has been removed from the -mm tree.  Its filename was
     bug-fix-for-acpi-cpufreq-and-cpufreq_stats-oops-on-frequency-change-notification.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Bug fix for acpi-cpufreq and cpufreq_stats oops on frequency change notification
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Fixes the oops in cpufreq_stats with acpi_cpufreq driver.  The issue was
that the frequency was reported as 0 in acpi-cpufreq.c.  The bug is due to
different indicies for freq_table and ACPI perf table.

Also adds a check in cpufreq_stats to check for error return from
freq_table_get_index() and avoid using the error return value.

Patch fixes the issue reported at
http://www.ussg.iu.edu/hypermail/linux/kernel/0611.2/0629.html
and also other similar issue here
http://bugme.osdl.org/show_bug.cgi?id=7383 comment 53

Signed-off-by: Dhaval Giani <dhaval.giani@gmail.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c |    9 +++++----
 drivers/cpufreq/cpufreq_stats.c             |    4 ++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c~bug-fix-for-acpi-cpufreq-and-cpufreq_stats-oops-on-frequency-change-notification arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c~bug-fix-for-acpi-cpufreq-and-cpufreq_stats-oops-on-frequency-change-notification
+++ a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -390,8 +390,8 @@ static int acpi_cpufreq_target(struct cp
 	cpumask_t online_policy_cpus;
 	struct drv_cmd cmd;
 	unsigned int msr;
-	unsigned int next_state = 0;
-	unsigned int next_perf_state = 0;
+	unsigned int next_state = 0; /* Index into freq_table */
+	unsigned int next_perf_state = 0; /* Index into perf table */
 	unsigned int i;
 	int result = 0;
 
@@ -456,8 +456,8 @@ static int acpi_cpufreq_target(struct cp
 	else
 		cpu_set(policy->cpu, cmd.mask);
 
-	freqs.old = data->freq_table[perf->state].frequency;
-	freqs.new = data->freq_table[next_perf_state].frequency;
+	freqs.old = perf->states[perf->state].core_frequency * 1000;
+	freqs.new = data->freq_table[next_state].frequency;
 	for_each_cpu_mask(i, cmd.mask) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
@@ -694,6 +694,7 @@ static int acpi_cpufreq_cpu_init(struct 
 		valid_states++;
 	}
 	data->freq_table[valid_states].frequency = CPUFREQ_TABLE_END;
+	perf->state = 0;
 
 	result = cpufreq_frequency_table_cpuinfo(policy, data->freq_table);
 	if (result)
diff -puN drivers/cpufreq/cpufreq_stats.c~bug-fix-for-acpi-cpufreq-and-cpufreq_stats-oops-on-frequency-change-notification drivers/cpufreq/cpufreq_stats.c
--- a/drivers/cpufreq/cpufreq_stats.c~bug-fix-for-acpi-cpufreq-and-cpufreq_stats-oops-on-frequency-change-notification
+++ a/drivers/cpufreq/cpufreq_stats.c
@@ -285,6 +285,7 @@ cpufreq_stat_notifier_trans (struct noti
 	stat = cpufreq_stats_table[freq->cpu];
 	if (!stat)
 		return 0;
+
 	old_index = freq_table_get_index(stat, freq->old);
 	new_index = freq_table_get_index(stat, freq->new);
 
@@ -292,6 +293,9 @@ cpufreq_stat_notifier_trans (struct noti
 	if (old_index == new_index)
 		return 0;
 
+	if (old_index == -1 || new_index == -1)
+		return 0;
+
 	spin_lock(&cpufreq_stats_lock);
 	stat->last_index = new_index;
 #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

origin.patch
git-cpufreq.patch

