From: akpm@linux-foundation.org
Subject: - softlockup-automatically-detect-hung-task_uninterruptible-tasks.patch removed from -mm tree
Date: Thu, 07 Feb 2008 00:13:46 -0800
Message-ID: <200802070813.m178DRgg023671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35390 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758216AbYBGIZQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2008 03:25:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     fix "softlockup: automatically detect hung TASK_UNINTERRUPTIBLE tasks"
has been removed from the -mm tree.  Its filename was
     softlockup-automatically-detect-hung-task_uninterruptible-tasks.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix "softlockup: automatically detect hung TASK_UNINTERRUPTIBLE tasks"
From: Ingo Molnar <mingo@elte.hu>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/reboot.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/reboot.c~softlockup-automatically-detect-hung-task_uninterruptible-tasks arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c~softlockup-automatically-detect-hung-task_uninterruptible-tasks
+++ a/arch/x86/kernel/reboot.c
@@ -396,8 +396,20 @@ void machine_shutdown(void)
 	if (!cpu_isset(reboot_cpu_id, cpu_online_map))
 		reboot_cpu_id = smp_processor_id();
 
-	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed(current, cpumask_of_cpu(reboot_cpu_id));
+	/*
+	 * Make certain we only run on the appropriate processor,
+	 * and with sufficient priority:
+	 */
+	{
+		struct sched_param schedparm;
+		schedparm.sched_priority = 99;
+		int ret;
+
+		ret = sched_setscheduler(current, SCHED_RR, &schedparm);
+		WARN_ON_ONCE(1);
+
+		set_cpus_allowed(current, cpumask_of_cpu(reboot_cpu_id));
+	}
 
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
documentation-create-new-scheduler-subdirectory.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
