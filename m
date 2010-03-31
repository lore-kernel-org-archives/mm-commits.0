From: akpm@linux-foundation.org
Subject: [merged] cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch removed from -mm tree
Date: Wed, 31 Mar 2010 11:53:28 -0400
Message-ID: <201003311854.o2VIscDk002126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755508Ab0CaSyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 14:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jocelyn.falempe@motorola.com, davej@codemonkey.org.uk, mike@android.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq: ondemand: don't synchronize sample rate unless mulitple cpus present
has been removed from the -mm tree.  Its filename was
     cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: ondemand: don't synchronize sample rate unless mulitple cpus present
From: Jocelyn Falempe <jocelyn.falempe@motorola.com>

For UP systems this is not required, and results in a more consistent
sample interval.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jocelyn Falempe <jocelyn.falempe@motorola.com>
Signed-off-by: Mike Chan <mike@android.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_ondemand.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/cpufreq/cpufreq_ondemand.c~cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -579,7 +579,9 @@ static void do_dbs_timer(struct work_str
 	/* We want all CPUs to do sampling nearly on same jiffy */
 	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
 
-	delay -= jiffies % delay;
+	if (num_online_cpus() > 1)
+		delay -= jiffies % delay;
+
 	mutex_lock(&dbs_info->timer_mutex);
 
 	/* Common NORMAL_SAMPLE setup */
@@ -604,7 +606,9 @@ static inline void dbs_timer_init(struct
 {
 	/* We want all CPUs to do sampling nearly on same jiffy */
 	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
-	delay -= jiffies % delay;
+
+	if (num_online_cpus() > 1)
+		delay -= jiffies % delay;
 
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
 	INIT_DELAYED_WORK_DEFERRABLE(&dbs_info->work, do_dbs_timer);
_

Patches currently in -mm which might be from jocelyn.falempe@motorola.com are

linux-next.patch

