From: akpm@linux-foundation.org
Subject: - sched-fix-memory-leak-in-the-cpu-hotplug-handing-logic.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:38:04 -0700
Message-ID: <200806122038.m5CKc48s005500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756731AbYFLUi7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:38:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxk@qualcomm.com, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sched: fix memory leak in the cpu hotplug handing logic
has been removed from the -mm tree.  Its filename was
     sched-fix-memory-leak-in-the-cpu-hotplug-handing-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: fix memory leak in the cpu hotplug handing logic
From: Max Krasnyansky <maxk@qualcomm.com>

The issue is that we are leaking doms_cur on cpu hotplug events.  doms_cur
is allocated in the arch_init_sched_domains() which is called for every
hotplug event.  So we just keep reallocating doms_cur without freeing it. 
This patch introduces free_sched_domains() function that cleans things up.

Note that doms_cur can also come from cpusets via partition_sched_domains().
That path is already handled correctly.

Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN kernel/sched.c~sched-fix-memory-leak-in-the-cpu-hotplug-handing-logic kernel/sched.c
--- a/kernel/sched.c~sched-fix-memory-leak-in-the-cpu-hotplug-handing-logic
+++ a/kernel/sched.c
@@ -7273,6 +7273,19 @@ void __attribute__((weak)) arch_update_c
 }
 
 /*
+ * Free current domain masks.
+ * Called after all cpus are attached to NULL domain.
+ */
+static void free_sched_domains(void)
+{
+	ndoms_cur = 0;
+	if (doms_cur != &fallback_doms) {
+		kfree(doms_cur);
+		doms_cur = &fallback_doms;
+	}
+}
+
+/*
  * Set up scheduler domains and groups. Callers must hold the hotplug lock.
  * For now this just excludes isolated cpus, but could be used to
  * exclude other special cases in the future.
@@ -7419,6 +7432,7 @@ int arch_reinit_sched_domains(void)
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
 	detach_destroy_domains(&cpu_online_map);
+	free_sched_domains();
 	err = arch_init_sched_domains(&cpu_online_map);
 	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
@@ -7504,6 +7518,7 @@ static int update_sched_domains(struct n
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		detach_destroy_domains(&cpu_online_map);
+		free_sched_domains();
 		return NOTIFY_OK;
 
 	case CPU_UP_CANCELED:
_

Patches currently in -mm which might be from maxk@qualcomm.com are

linux-next.patch

