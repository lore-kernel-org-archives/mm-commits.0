From: akpm@linux-foundation.org
Subject: + cpufreq-fix-ondemand-governor-powersave_bias-execution-time-misuse.patch added to -mm tree
Date: Fri, 05 Nov 2010 12:23:49 -0700
Message-ID: <201011051923.oA5JNnY1028187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202Ab0KETYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Nov 2010 15:24:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: youquan.song@linux.intel.com, youquan.song@intel.com


The patch titled
     cpufreq: fix ondemand governor powersave_bias execution time misuse
has been added to the -mm tree.  Its filename is
     cpufreq-fix-ondemand-governor-powersave_bias-execution-time-misuse.patch

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
@@ -666,6 +666,8 @@ static void do_dbs_timer(struct work_str
 	} else {
 		__cpufreq_driver_target(dbs_info->cur_policy,
 			dbs_info->freq_lo, CPUFREQ_RELATION_H);
+		if (dbs_info->sample_type == DBS_SUB_SAMPLE)
+			delay = dbs_info->freq_lo_jiffies;
 	}
 	queue_delayed_work_on(cpu, kondemand_wq, &dbs_info->work, delay);
 	mutex_unlock(&dbs_info->timer_mutex);
_

Patches currently in -mm which might be from youquan.song@linux.intel.com are

cpufreq-fix-ondemand-governor-powersave_bias-execution-time-misuse.patch

