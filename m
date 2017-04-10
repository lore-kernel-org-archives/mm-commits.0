From: akpm@linux-foundation.org
Subject: + remove-cpuset_update_active_cpuss-parameter.patch added to -mm
 tree
Date: Mon, 10 Apr 2017 15:18:46 -0700
Message-ID: <58ec04c6.1ZCwLAeGvQ92qe2I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59556 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752151AbdDJWSr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 18:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject:  cpusets: remove cpuset_update_active_cpus()'s parameter
has been added to the -mm tree.  Its filename is
     remove-cpuset_update_active_cpuss-parameter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/remove-cpuset_update_active_cpuss-parameter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/remove-cpuset_update_active_cpuss-parameter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rakib Mullick <rakib.mullick@gmail.com>
Subject:  cpusets: remove cpuset_update_active_cpus()'s parameter

In cpuset_update_active_cpus(), cpu_online isn't used anymore.  Remove it.

Link: http://lkml.kernel.org/r/20170409013614.7138-1-rakib.mullick@gmail.com
Signed-off-by: Rakib Mullick<rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |    4 ++--
 kernel/cgroup/cpuset.c |    2 +-
 kernel/sched/core.c    |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/cpuset.h~remove-cpuset_update_active_cpuss-parameter include/linux/cpuset.h
--- a/include/linux/cpuset.h~remove-cpuset_update_active_cpuss-parameter
+++ a/include/linux/cpuset.h
@@ -42,7 +42,7 @@ static inline void cpuset_dec(void)
 
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
-extern void cpuset_update_active_cpus(bool cpu_online);
+extern void cpuset_update_active_cpus(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
@@ -155,7 +155,7 @@ static inline bool cpusets_enabled(void)
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
 
-static inline void cpuset_update_active_cpus(bool cpu_online)
+static inline void cpuset_update_active_cpus(void)
 {
 	partition_sched_domains(1, NULL, NULL);
 }
diff -puN kernel/cgroup/cpuset.c~remove-cpuset_update_active_cpuss-parameter kernel/cgroup/cpuset.c
--- a/kernel/cgroup/cpuset.c~remove-cpuset_update_active_cpuss-parameter
+++ a/kernel/cgroup/cpuset.c
@@ -2354,7 +2354,7 @@ static void cpuset_hotplug_workfn(struct
 		rebuild_sched_domains();
 }
 
-void cpuset_update_active_cpus(bool cpu_online)
+void cpuset_update_active_cpus(void)
 {
 	/*
 	 * We're inside cpu hotplug critical region which usually nests
diff -puN kernel/sched/core.c~remove-cpuset_update_active_cpuss-parameter kernel/sched/core.c
--- a/kernel/sched/core.c~remove-cpuset_update_active_cpuss-parameter
+++ a/kernel/sched/core.c
@@ -5732,7 +5732,7 @@ static void cpuset_cpu_active(void)
 		 * cpuset configurations.
 		 */
 	}
-	cpuset_update_active_cpus(true);
+	cpuset_update_active_cpus();
 }
 
 static int cpuset_cpu_inactive(unsigned int cpu)
@@ -5755,7 +5755,7 @@ static int cpuset_cpu_inactive(unsigned
 
 		if (overflow)
 			return -EBUSY;
-		cpuset_update_active_cpus(false);
+		cpuset_update_active_cpus();
 	} else {
 		num_cpus_frozen++;
 		partition_sched_domains(1, NULL, NULL);
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

remove-cpuset_update_active_cpuss-parameter.patch

