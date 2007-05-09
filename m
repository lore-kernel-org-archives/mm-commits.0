From: akpm@linux-foundation.org
Subject: - add-a-new-deferrable-delayed-work-init.patch removed from -mm tree
Date: Tue, 08 May 2007 19:48:00 -0700
Message-ID: <200705090248.l492m0q2009042@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934820AbXEICsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:48:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, davej@codemonkey.org.uk, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     Add a new deferrable delayed work init
has been removed from the -mm tree.  Its filename was
     add-a-new-deferrable-delayed-work-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add a new deferrable delayed work init
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Add a new deferrable delayed work init.  This can be used to schedule work
that are 'unimportant' when CPU is idle and can be called later, when CPU
eventually comes out of idle.

Use this init in cpufreq ondemand governor.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_ondemand.c |    2 +-
 include/linux/workqueue.h          |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/cpufreq/cpufreq_ondemand.c~add-a-new-deferrable-delayed-work-init drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~add-a-new-deferrable-delayed-work-init
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
diff -puN include/linux/workqueue.h~add-a-new-deferrable-delayed-work-init include/linux/workqueue.h
--- a/include/linux/workqueue.h~add-a-new-deferrable-delayed-work-init
+++ a/include/linux/workqueue.h
@@ -121,6 +121,12 @@ struct execute_work {
 		init_timer(&(_work)->timer);			\
 	} while (0)
 
+#define INIT_DELAYED_WORK_DEFERRABLE(_work, _func)			\
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

origin.patch
git-acpi.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
