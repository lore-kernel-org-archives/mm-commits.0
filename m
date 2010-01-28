From: akpm@linux-foundation.org
Subject: + cpufreq-ondemand-refactor-frequency-increase-code.patch added to -mm tree
Date: Wed, 27 Jan 2010 16:17:49 -0800
Message-ID: <201001280017.o0S0Hnar009014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755734Ab0A1ASg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 19:18:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike@android.com, davej@codemonkey.org.uk, trenn@suse.de, venkatesh.pallipadi@intel.com


The patch titled
     cpufreq: ondemand: refactor frequency increase code
has been added to the -mm tree.  Its filename is
     cpufreq-ondemand-refactor-frequency-increase-code.patch

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
