From: akpm@linux-foundation.org
Subject: + cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch added to -mm tree
Date: Fri, 22 Jan 2010 14:25:26 -0800
Message-ID: <201001222225.o0MMPQak032252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754724Ab0AVW0M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 17:26:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jocelyn.falempe@motorola.com, davej@codemonkey.org.uk, mike@android.com


The patch titled
     cpufreq: ondemand: don't synchronize sample rate unless mulitple cpus present
has been added to the -mm tree.  Its filename is
     cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch

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
Subject: cpufreq: ondemand: don't synchronize sample rate unless mulitple cpus present
From: Jocelyn Falempe <jocelyn.falempe@motorola.com>

For UP systems this is not required, and results in a more consistent
sample interval.

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
+ 		delay -= jiffies % delay;
 
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
 	INIT_DELAYED_WORK_DEFERRABLE(&dbs_info->work, do_dbs_timer);
_

Patches currently in -mm which might be from jocelyn.falempe@motorola.com are

cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch

