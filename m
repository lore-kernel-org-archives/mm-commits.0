From: akpm@linux-foundation.org
Subject: [merged] cpufreq-unexport-unlock_policy_rwsem-functions.patch removed from -mm tree
Date: Wed, 31 Mar 2010 11:53:31 -0400
Message-ID: <201003311854.o2VIsfu7002129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755508Ab0CaSyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 14:54:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, davej@redhat.com, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq: unexport (un)lock_policy_rwsem* functions
has been removed from the -mm tree.  Its filename was
     cpufreq-unexport-unlock_policy_rwsem-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: unexport (un)lock_policy_rwsem* functions
From: Amerigo Wang <amwang@redhat.com>

lock_policy_rwsem_* and unlock_policy_rwsem_* functions are scheduled to
be unexported when 2.6.33.  Now there are no other callers of them out of
cpufreq.c, unexport them and make them static.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   10 ----------
 drivers/cpufreq/cpufreq.c                  |   10 +++-------
 include/linux/cpufreq.h                    |    5 -----
 3 files changed, 3 insertions(+), 22 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~cpufreq-unexport-unlock_policy_rwsem-functions Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~cpufreq-unexport-unlock_policy_rwsem-functions
+++ a/Documentation/feature-removal-schedule.txt
@@ -379,16 +379,6 @@ Who:	Johannes Berg <johannes@sipsolution
 
 ----------------------------
 
-What:	lock_policy_rwsem_* and unlock_policy_rwsem_* will not be
-	exported interface anymore.
-When:	2.6.33
-Why:	cpu_policy_rwsem has a new cleaner definition making it local to
-	cpufreq core and contained inside cpufreq.c. Other dependent
-	drivers should not use it in order to safely avoid lockdep issues.
-Who:	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
-
-----------------------------
-
 What:	sound-slot/service-* module aliases and related clutters in
 	sound/sound_core.c
 When:	August 2010
diff -puN drivers/cpufreq/cpufreq.c~cpufreq-unexport-unlock_policy_rwsem-functions drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-unexport-unlock_policy_rwsem-functions
+++ a/drivers/cpufreq/cpufreq.c
@@ -68,7 +68,7 @@ static DEFINE_PER_CPU(int, cpufreq_polic
 static DEFINE_PER_CPU(struct rw_semaphore, cpu_policy_rwsem);
 
 #define lock_policy_rwsem(mode, cpu)					\
-int lock_policy_rwsem_##mode						\
+static int lock_policy_rwsem_##mode					\
 (int cpu)								\
 {									\
 	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);		\
@@ -83,26 +83,22 @@ int lock_policy_rwsem_##mode						\
 }
 
 lock_policy_rwsem(read, cpu);
-EXPORT_SYMBOL_GPL(lock_policy_rwsem_read);
 
 lock_policy_rwsem(write, cpu);
-EXPORT_SYMBOL_GPL(lock_policy_rwsem_write);
 
-void unlock_policy_rwsem_read(int cpu)
+static void unlock_policy_rwsem_read(int cpu)
 {
 	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);
 	BUG_ON(policy_cpu == -1);
 	up_read(&per_cpu(cpu_policy_rwsem, policy_cpu));
 }
-EXPORT_SYMBOL_GPL(unlock_policy_rwsem_read);
 
-void unlock_policy_rwsem_write(int cpu)
+static void unlock_policy_rwsem_write(int cpu)
 {
 	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);
 	BUG_ON(policy_cpu == -1);
 	up_write(&per_cpu(cpu_policy_rwsem, policy_cpu));
 }
-EXPORT_SYMBOL_GPL(unlock_policy_rwsem_write);
 
 
 /* internal prototypes */
diff -puN include/linux/cpufreq.h~cpufreq-unexport-unlock_policy_rwsem-functions include/linux/cpufreq.h
--- a/include/linux/cpufreq.h~cpufreq-unexport-unlock_policy_rwsem-functions
+++ a/include/linux/cpufreq.h
@@ -196,11 +196,6 @@ extern int __cpufreq_driver_getavg(struc
 int cpufreq_register_governor(struct cpufreq_governor *governor);
 void cpufreq_unregister_governor(struct cpufreq_governor *governor);
 
-int lock_policy_rwsem_read(int cpu);
-int lock_policy_rwsem_write(int cpu);
-void unlock_policy_rwsem_read(int cpu);
-void unlock_policy_rwsem_write(int cpu);
