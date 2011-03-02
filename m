From: akpm@linux-foundation.org
Subject: [alternative-merged] cpufreq-fix-ondemand-governor-powersave_bias-execution-time-misuse.patch removed from -mm tree
Date: Wed, 02 Mar 2011 12:11:11 -0800
Message-ID: <201103022011.p22KBBkV030559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757404Ab1CBULn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2011 15:11:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: youquan.song@linux.intel.com, youquan.song@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq: fix ondemand governor powersave_bias execution time misuse
has been removed from the -mm tree.  Its filename was
     cpufreq-fix-ondemand-governor-powersave_bias-execution-time-misuse.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: fix ondemand governor powersave_bias execution time misuse
From: Youquan Song <youquan.song@linux.intel.com>

Ondemand governor use powersave_bias tunable to do aggressive power save
by decrease CPU average frequency.  The average frequency achieve by
adjust low and high frequency's execution time proportion during one
sample time interval.

Current kernel, only the high frequency executes in time proportion, but
the low frequency wrongly execute in one whole sample time interval when
powersave_bias is set.

The patch fix it by set low frequency execution time to it deserved.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_ondemand.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/cpufreq/cpufreq_ondemand.c~cpufreq-fix-ondemand-governor-powersave_bias-execution-time-misuse drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~cpufreq-fix-ondemand-governor-powersave_bias-execution-time-misuse
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -664,6 +664,8 @@ static void do_dbs_timer(struct work_str
 	} else {
 		__cpufreq_driver_target(dbs_info->cur_policy,
 			dbs_info->freq_lo, CPUFREQ_RELATION_H);
+		if (dbs_info->sample_type == DBS_SUB_SAMPLE)
+			delay = dbs_info->freq_lo_jiffies;
 	}
 	schedule_delayed_work_on(cpu, &dbs_info->work, delay);
 	mutex_unlock(&dbs_info->timer_mutex);
_

Patches currently in -mm which might be from youquan.song@linux.intel.com are


