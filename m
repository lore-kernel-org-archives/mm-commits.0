From: akpm@linux-foundation.org
Subject: [to-be-updated] cpufreq-add-sysfs-knob-for-toggling-core-performance-boost.patch removed from -mm tree
Date: Thu, 04 Mar 2010 14:04:38 -0800
Message-ID: <201003042204.o24M4cnD032618@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755436Ab0CDWFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 17:05:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.langsdorf@amd.com, borislav.petkov@amd.com, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     cpufreq: add sysfs knob for toggling core performance boost
has been removed from the -mm tree.  Its filename was
     cpufreq-add-sysfs-knob-for-toggling-core-performance-boost.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: add sysfs knob for toggling core performance boost
From: Mark Langsdorf <mark.langsdorf@amd.com>

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Tested-by: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN drivers/cpufreq/cpufreq.c~cpufreq-add-sysfs-knob-for-toggling-core-performance-boost drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-add-sysfs-knob-for-toggling-core-performance-boost
+++ a/drivers/cpufreq/cpufreq.c
@@ -662,6 +662,30 @@ static ssize_t show_bios_limit(struct cp
 	return sprintf(buf, "%u\n", policy->cpuinfo.max_freq);
 }
 
+static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
+				 size_t count)
+{
+	int ret = -EINVAL;
+	unsigned long val = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (!ret && (val == 0 || val == 1))
+		policy->flags.cpb = val;
+	else
+		return -EINVAL;
+
+	ret = __cpufreq_driver_target(policy, policy->cur, CPUFREQ_RELATION_H);
+	if (ret)
+		return -EINVAL;
+
+	return count;
+}
+
+static ssize_t show_cpb(struct cpufreq_policy *policy, char *buf)
+{
+	return sprintf(buf, "%u\n", policy->flags.cpb);
+}
+
 #define define_one_ro(_name) \
 static struct freq_attr _name = \
 __ATTR(_name, 0444, show_##_name, NULL)
@@ -688,6 +712,7 @@ define_one_rw(scaling_min_freq);
 define_one_rw(scaling_max_freq);
 define_one_rw(scaling_governor);
 define_one_rw(scaling_setspeed);
+define_one_rw(cpb);
 
 static struct attribute *default_attrs[] = {
 	&cpuinfo_min_freq.attr,
@@ -701,6 +726,7 @@ static struct attribute *default_attrs[]
 	&scaling_driver.attr,
 	&scaling_available_governors.attr,
 	&scaling_setspeed.attr,
+	&cpb.attr,
 	NULL
 };
 
_

Patches currently in -mm which might be from mark.langsdorf@amd.com are

cpufreq-add-sysfs-knob-for-toggling-core-performance-boost.patch

