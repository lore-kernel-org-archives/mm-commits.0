From: akpm@linux-foundation.org
Subject: - sched-cpu-hotplug-events-must-not-destroy-scheduler-domains-created-by-the-cpusets.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:38:06 -0700
Message-ID: <200806122038.m5CKc66l005504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754697AbYFLUjK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:39:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxk@qualcomm.com, mingo@elte.hu, pj@sgi.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sched: CPU hotplug events must not destroy scheduler domains created by the cpusets
has been removed from the -mm tree.  Its filename was
     sched-cpu-hotplug-events-must-not-destroy-scheduler-domains-created-by-the-cpusets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: CPU hotplug events must not destroy scheduler domains created by the cpusets
From: Max Krasnyansky <maxk@qualcomm.com>

Currently sched domains created by the cpusets are completely destroyed
during CPU hotplug event handling.  For each CPU hotplug event scheduler
attaches all CPUs to the NULL domain and then puts them all into a single
domain thereby destroying domains created by the cpusets.

The solution is simple, when cpusets are enabled scheduler should not
create the default domain and instead let cpusets rebuild the domains
based on the current settings.  Which is exactly what the patch does.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Jackson <pj@sgi.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    6 ++++++
 kernel/sched.c  |    8 ++++++++
 2 files changed, 14 insertions(+)

diff -puN kernel/cpuset.c~sched-cpu-hotplug-events-must-not-destroy-scheduler-domains-created-by-the-cpusets kernel/cpuset.c
--- a/kernel/cpuset.c~sched-cpu-hotplug-events-must-not-destroy-scheduler-domains-created-by-the-cpusets
+++ a/kernel/cpuset.c
@@ -1890,6 +1890,12 @@ static void common_cpu_mem_hotplug_unplu
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 	scan_for_empty_cpusets(&top_cpuset);
 
+	/*
+	 * Scheduler destroys domains on hotplug events.
+	 * Rebuild them based on the current settings.
+	 */
+	rebuild_sched_domains();
+
 	cgroup_unlock();
 }
 
diff -puN kernel/sched.c~sched-cpu-hotplug-events-must-not-destroy-scheduler-domains-created-by-the-cpusets kernel/sched.c
--- a/kernel/sched.c~sched-cpu-hotplug-events-must-not-destroy-scheduler-domains-created-by-the-cpusets
+++ a/kernel/sched.c
@@ -7537,8 +7537,16 @@ static int update_sched_domains(struct n
 		return NOTIFY_DONE;
 	}
 
+#ifndef CONFIG_CPUSETS
+	/*
+	 * Create default domain partitioning if cpusets are disabled.
+	 * Otherwise we let cpusets rebuild the domains based on the
+	 * current setup.
+	 */
+
 	/* The hotplug lock is already held by cpu_up/cpu_down */
 	arch_init_sched_domains(&cpu_online_map);
+#endif
 
 	return NOTIFY_OK;
 }
_

Patches currently in -mm which might be from maxk@qualcomm.com are

linux-next.patch

