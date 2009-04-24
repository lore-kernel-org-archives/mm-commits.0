From: akpm@linux-foundation.org
Subject: + cpufreq-fix-timer-teardown-in-conservative-governor-2630-rc2.patch added to -mm tree
Date: Fri, 24 Apr 2009 12:55:45 -0700
Message-ID: <200904241955.n3OJtkDi030122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753162AbZDXUDy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 16:03:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, davej@redhat.com, greg@kroah.com, lenb@kernel.org, mingo@elte.hu, rjw@sisk.pl, sluskyb@paranoiacs.org, stable@kernel.org


The patch titled
     cpufreq: fix timer teardown in conservative governor
has been added to the -mm tree.  Its filename is
     cpufreq-fix-timer-teardown-in-conservative-governor-2630-rc2.patch

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
Subject: cpufreq: fix timer teardown in conservative governor
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

The problem is that dbs_timer_exit() uses cancel_delayed_work() when it
should use cancel_delayed_work_sync().  cancel_delayed_work() does not
wait for the workqueue handler to exit.

The ondemand governor does not seem to be affected because the "if
(!dbs_info->enable)" check at the beginning of the workqueue handler
returns immediately without rescheduling the work.  The conservative
governor in 2.6.30-rc has the same check as the ondemand governor, which
makes things usually run smoothly.  However, if the governor is quickly
stopped and then started, this could lead to the following race :

dbs_enable could be reenabled and multiple do_dbs_timer handlers would
run.  This is why a synchronized teardown is required.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ben Slusky <sluskyb@paranoiacs.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_conservative.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/cpufreq/cpufreq_conservative.c~cpufreq-fix-timer-teardown-in-conservative-governor-2630-rc2 drivers/cpufreq/cpufreq_conservative.c
--- a/drivers/cpufreq/cpufreq_conservative.c~cpufreq-fix-timer-teardown-in-conservative-governor-2630-rc2
+++ a/drivers/cpufreq/cpufreq_conservative.c
@@ -91,6 +91,9 @@ static unsigned int dbs_enable;	/* numbe
  * (like __cpufreq_driver_target()) is being called with dbs_mutex taken, then
  * cpu_hotplug lock should be taken before that. Note that cpu_hotplug lock
  * is recursive for the same process. -Venki
+ * DEADLOCK ALERT! (2) : do_dbs_timer() must not take the dbs_mutex, because it
+ * would deadlock with cancel_delayed_work_sync(), which is needed for proper
+ * raceless workqueue teardown.
  */
 static DEFINE_MUTEX(dbs_mutex);
 
@@ -542,7 +545,7 @@ static inline void dbs_timer_init(struct
 static inline void dbs_timer_exit(struct cpu_dbs_info_s *dbs_info)
 {
 	dbs_info->enable = 0;
-	cancel_delayed_work(&dbs_info->work);
+	cancel_delayed_work_sync(&dbs_info->work);
 }
 
 static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

linux-next.patch
cpufreq-fix-timer-teardown-in-conservative-governor-2630-rc2.patch

