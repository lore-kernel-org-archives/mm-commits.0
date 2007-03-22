From: akpm@linux-foundation.org
Subject: - export-deferrable-timer-through-workqueue-and-use-it-in-ondemand-governor.patch removed from -mm tree
Date: Thu, 22 Mar 2007 03:19:23 -0800
Message-ID: <200703221119.l2MBJNe1019077@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50308 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161023AbXCVLTs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 07:19:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, davej@codemonkey.org.uk, johnstul@us.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Export deferrable timer through workqueue and use it in ondemand governor
has been removed from the -mm tree.  Its filename was
     export-deferrable-timer-through-workqueue-and-use-it-in-ondemand-governor.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Export deferrable timer through workqueue and use it in ondemand governor
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Add a new deferrable delayed work init.  This can be used to schedule work
that are 'unimportant' when CPU is idle and can be called later, when CPU
eventually comes out of idle.

Use this init in cpufreq ondemand governor.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_ondemand.c |    2 +-
 include/linux/workqueue.h          |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/cpufreq/cpufreq_ondemand.c~export-deferrable-timer-through-workqueue-and-use-it-in-ondemand-governor drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~export-deferrable-timer-through-workqueue-and-use-it-in-ondemand-governor
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -470,7 +470,7 @@ static inline void dbs_timer_init(struct
 	dbs_info->enable = 1;
 	ondemand_powersave_bias_init();
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
-	INIT_DELAYED_WORK(&dbs_info->work, do_dbs_timer);
+	INIT_DELAYED_WORK_DEFERRABLE(&dbs_info->work, do_dbs_timer);
 	queue_delayed_work_on(dbs_info->cpu, kondemand_wq, &dbs_info->work,
 	                      delay);
 }
diff -puN include/linux/workqueue.h~export-deferrable-timer-through-workqueue-and-use-it-in-ondemand-governor include/linux/workqueue.h
--- a/include/linux/workqueue.h~export-deferrable-timer-through-workqueue-and-use-it-in-ondemand-governor
+++ a/include/linux/workqueue.h
@@ -89,6 +89,12 @@ struct execute_work {
 		init_timer(&(_work)->timer);			\
 	} while (0)
 
+#define INIT_DELAYED_WORK_DEFERRABLE(_work, _func)		\
+	do {							\
+		INIT_WORK(&(_work)->work, (_func));		\
+		init_timer_deferrable(&(_work)->timer);		\
+	} while (0)
+
 /**
  * work_pending - Find out whether a work item is currently pending
  * @work: The work item in question
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
cpuidle-fix-boot-hang.patch
cpuidle-unsigned-bitfield.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
export-deferrable-timer-through-workqueue-and-use-it-in-ondemand-governor.patch
