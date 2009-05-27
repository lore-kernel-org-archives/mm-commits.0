From: akpm@linux-foundation.org
Subject: [merged] cpufreq-change-print_once-to-printk_once.patch removed from -mm tree
Date: Wed, 27 May 2009 13:55:52 -0700
Message-ID: <200905272055.n4RKtq1a026062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760270AbZE0U43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 16:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, davej@codemonkey.org.uk, hsweeten@visionengravers.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq: change print_once to printk_once
has been removed from the -mm tree.  Its filename was
     cpufreq-change-print_once-to-printk_once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: change print_once to printk_once
From: H Hartley Sweeten <hartleys@visionengravers.com>

Replace the print_once code blocks with the printk_once macro.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_conservative.c |   16 ++++------------
 drivers/cpufreq/cpufreq_ondemand.c     |   16 ++++------------
 2 files changed, 8 insertions(+), 24 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-change-print_once-to-printk_once arch/x86/kernel/cpu/cpufreq/powernow-k8.c
diff -puN drivers/cpufreq/cpufreq_conservative.c~cpufreq-change-print_once-to-printk_once drivers/cpufreq/cpufreq_conservative.c
--- a/drivers/cpufreq/cpufreq_conservative.c~cpufreq-change-print_once-to-printk_once
+++ a/drivers/cpufreq/cpufreq_conservative.c
@@ -179,26 +179,18 @@ static struct notifier_block dbs_cpufreq
 /************************** sysfs interface ************************/
 static ssize_t show_sampling_rate_max(struct cpufreq_policy *policy, char *buf)
 {
-	static int print_once;
-
-	if (!print_once) {
-		printk(KERN_INFO "CPUFREQ: conservative sampling_rate_max "
+	printk_once(KERN_INFO "CPUFREQ: conservative sampling_rate_max "
 		       "sysfs file is deprecated - used by: %s\n",
 		       current->comm);
-		print_once = 1;
-	}
+
 	return sprintf(buf, "%u\n", MAX_SAMPLING_RATE);
 }
 
 static ssize_t show_sampling_rate_min(struct cpufreq_policy *policy, char *buf)
 {
-	static int print_once;
-
-	if (!print_once) {
-		printk(KERN_INFO "CPUFREQ: conservative sampling_rate_max "
+	printk_once(KERN_INFO "CPUFREQ: conservative sampling_rate_max "
 		       "sysfs file is deprecated - used by: %s\n", current->comm);
-		print_once = 1;
-	}
+
 	return sprintf(buf, "%u\n", MIN_SAMPLING_RATE);
 }
 
diff -puN drivers/cpufreq/cpufreq_ondemand.c~cpufreq-change-print_once-to-printk_once drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~cpufreq-change-print_once-to-printk_once
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -216,27 +216,19 @@ static void ondemand_powersave_bias_init
 /************************** sysfs interface ************************/
 static ssize_t show_sampling_rate_max(struct cpufreq_policy *policy, char *buf)
 {
-	static int print_once;
-
-	if (!print_once) {
-		printk(KERN_INFO "CPUFREQ: ondemand sampling_rate_max "
+	printk_once(KERN_INFO "CPUFREQ: ondemand sampling_rate_max "
 		       "sysfs file is deprecated - used by: %s\n",
 		       current->comm);
-		print_once = 1;
-	}
+
 	return sprintf(buf, "%u\n", MAX_SAMPLING_RATE);
 }
 
 static ssize_t show_sampling_rate_min(struct cpufreq_policy *policy, char *buf)
 {
-	static int print_once;
