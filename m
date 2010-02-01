From: akpm@linux-foundation.org
Subject: [to-be-updated] cpufreq-ondemand-refactor-frequency-increase-code.patch removed from -mm tree
Date: Mon, 01 Feb 2010 11:37:08 -0800
Message-ID: <201002011937.o11Jb8jF007855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755775Ab0BAThx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 14:37:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@android.com, davej@codemonkey.org.uk, trenn@suse.de, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq: ondemand: refactor frequency increase code
has been removed from the -mm tree.  Its filename was
     cpufreq-ondemand-refactor-frequency-increase-code.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: ondemand: refactor frequency increase code
From: Mike Chan <mike@android.com>

Make simpler to read and call.

Signed-off-by: Mike Chan <mike@android.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_ondemand.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/cpufreq/cpufreq_ondemand.c~cpufreq-ondemand-refactor-frequency-increase-code drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~cpufreq-ondemand-refactor-frequency-increase-code
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -443,6 +443,17 @@ static struct attribute_group dbs_attr_g
 
 /************************** sysfs end ************************/
 
+static int dbs_freq_increase(struct cpufreq_policy *p, unsigned int target_freq)
+{
+	if (dbs_tuners_ins.powersave_bias)
+		target_freq = powersave_bias_target(p, target_freq,
+				CPUFREQ_RELATION_H);
+
+	__cpufreq_driver_target(p, target_freq,
+			dbs_tuners_ins.powersave_bias ?
+			CPUFREQ_RELATION_L : CPUFREQ_RELATION_H);
+}
+
 static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 {
 	unsigned int max_load_freq;
@@ -520,19 +531,8 @@ static void dbs_check_cpu(struct cpu_dbs
 
 	/* Check for frequency increase */
 	if (max_load_freq > dbs_tuners_ins.up_threshold * policy->cur) {
-		/* if we are already at full speed then break out early */
-		if (!dbs_tuners_ins.powersave_bias) {
-			if (policy->cur == policy->max)
-				return;
