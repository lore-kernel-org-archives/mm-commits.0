From: akpm@linux-foundation.org
Subject: + fix-cpufreq_stats-attrs-removal.patch added to -mm tree
Date: Thu, 22 Mar 2007 09:57:38 -0800
Message-ID: <200703221757.l2MHvcMR026222@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42785 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934164AbXCVR5u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 13:57:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: malattia@linux.it, davej@codemonkey.org.uk


The patch titled
     fix cpufreq_stats attrs removal
has been added to the -mm tree.  Its filename is
     fix-cpufreq_stats-attrs-removal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix cpufreq_stats attrs removal
From: Mattia Dongili <malattia@linux.it>

After modprobe/rmmod cpufreq/stats directory appears but doesn't get
removed.

There are other symptoms to this same bug:

1. unload p4-clockmod: /sys/.../cpu0/cpufreq is removed all together
2. load p4-clockmod: /sys/.../cpu0/cpufreq appears but no 'stats' subdir
   (yes, cpufreq_stats is loaded)
3. rmmod cpufreq_stats: Ooops!

Call Trace:
 [<c0183f5b>] remove_dir+0x33/0xc4
 [<c0184fca>] remove_files+0x1a/0x28
 [<c018503b>] sysfs_remove_group+0x63/0x71
 [<f898c38d>] cpufreq_stat_cpu_callback+0x51/0x8a [cpufreq_stats]
 [<f898c477>] cpufreq_stats_exit+0x47/0x4b [cpufreq_stats]
 [<c012f145>] sys_delete_module+0x190/0x1b7
 [<c0140073>] do_wp_page+0x231/0x3e7
 [<c0102e17>] syscall_call+0x7/0xb

The problem is cpufreq_stats doesn't know when a cpufreq driver is removed
and doesn't cleanup.  I guess this affects any setup with cpufreq_stats.

The attached patch seems to solve both symptoms and yes... it's quite
invasive as it introduce one more cpufreq policy notification (REMOVED).

Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c       |    4 ++++
 drivers/cpufreq/cpufreq_stats.c |   26 +++++++++++++++-----------
 include/linux/cpufreq.h         |    1 +
 3 files changed, 20 insertions(+), 11 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~fix-cpufreq_stats-attrs-removal drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~fix-cpufreq_stats-attrs-removal
+++ a/drivers/cpufreq/cpufreq.c
@@ -989,6 +989,10 @@ static int __cpufreq_remove_dev (struct 
 
 	unlock_policy_rwsem_write(cpu);
 
+	/* notify of policy cancellation */
+	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
+			CPUFREQ_REMOVE, data);
+
 	kobject_unregister(&data->kobj);
 
 	kobject_put(&data->kobj);
diff -puN drivers/cpufreq/cpufreq_stats.c~fix-cpufreq_stats-attrs-removal drivers/cpufreq/cpufreq_stats.c
--- a/drivers/cpufreq/cpufreq_stats.c~fix-cpufreq_stats-attrs-removal
+++ a/drivers/cpufreq/cpufreq_stats.c
@@ -257,18 +257,23 @@ static int
 cpufreq_stat_notifier_policy (struct notifier_block *nb, unsigned long val,
 		void *data)
 {
-	int ret;
+	int ret = 0;
 	struct cpufreq_policy *policy = data;
 	struct cpufreq_frequency_table *table;
 	unsigned int cpu = policy->cpu;
-	if (val != CPUFREQ_NOTIFY)
-		return 0;
-	table = cpufreq_frequency_get_table(cpu);
-	if (!table)
-		return 0;
-	if ((ret = cpufreq_stats_create_table(policy, table)))
-		return ret;
-	return 0;
+	switch (val) {
+	case CPUFREQ_NOTIFY:
+		table = cpufreq_frequency_get_table(cpu);
+		if (!table)
+			break;
+		ret = cpufreq_stats_create_table(policy, table);
+		break;
+
+	case CPUFREQ_REMOVE:
+		cpufreq_stats_free_table(cpu);
+		break;
+	}
+	return ret;
 }
 
 static int
@@ -371,8 +376,7 @@ __exit cpufreq_stats_exit(void)
 			CPUFREQ_TRANSITION_NOTIFIER);
 	unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
 	for_each_online_cpu(cpu) {
-		cpufreq_stat_cpu_callback(&cpufreq_stat_cpu_notifier,
-						CPU_DEAD, (void *)(long)cpu);
+		cpufreq_stats_free_table(cpu);
 	}
 }
 
diff -puN include/linux/cpufreq.h~fix-cpufreq_stats-attrs-removal include/linux/cpufreq.h
--- a/include/linux/cpufreq.h~fix-cpufreq_stats-attrs-removal
+++ a/include/linux/cpufreq.h
@@ -96,6 +96,7 @@ struct cpufreq_policy {
 #define CPUFREQ_ADJUST		(0)
 #define CPUFREQ_INCOMPATIBLE	(1)
 #define CPUFREQ_NOTIFY		(2)
+#define CPUFREQ_REMOVE		(3)
 
 #define CPUFREQ_SHARED_TYPE_NONE (0) /* None */
 #define CPUFREQ_SHARED_TYPE_HW	 (1) /* HW does needed coordination */
_

Patches currently in -mm which might be from malattia@linux.it are

git-acpi.patch
fix-cpufreq_stats-attrs-removal.patch
