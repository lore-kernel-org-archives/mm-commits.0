From: akpm@linux-foundation.org
Subject: [merged] sched-add-schedule_timeout_idle.patch removed from -mm
 tree
Date: Sat, 26 Mar 2016 20:29:50 -0700
Message-ID: <56f753ae.h7jlmucNiPhilWcU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbcC0D3v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2016 23:29:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, mhocko@suse.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: sched: add schedule_timeout_idle()
has been removed from the -mm tree.  Its filename was
     sched-add-schedule_timeout_idle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sched: add schedule_timeout_idle()

This will be needed in the patch "mm, oom: introduce oom reaper".

Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 +
 kernel/time/timer.c   |   11 +++++++++++
 2 files changed, 12 insertions(+)

diff -puN include/linux/sched.h~sched-add-schedule_timeout_idle include/linux/sched.h
--- a/include/linux/sched.h~sched-add-schedule_timeout_idle
+++ a/include/linux/sched.h
@@ -426,6 +426,7 @@ extern signed long schedule_timeout(sign
 extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
+extern signed long schedule_timeout_idle(signed long timeout);
 asmlinkage void schedule(void);
 extern void schedule_preempt_disabled(void);
 
diff -puN kernel/time/timer.c~sched-add-schedule_timeout_idle kernel/time/timer.c
--- a/kernel/time/timer.c~sched-add-schedule_timeout_idle
+++ a/kernel/time/timer.c
@@ -1566,6 +1566,17 @@ signed long __sched schedule_timeout_uni
 }
 EXPORT_SYMBOL(schedule_timeout_uninterruptible);
 
+/*
+ * Like schedule_timeout_uninterruptible(), except this task will not contribute
+ * to load average.
+ */
+signed long __sched schedule_timeout_idle(signed long timeout)
+{
+	__set_current_state(TASK_IDLE);
+	return schedule_timeout(timeout);
+}
+EXPORT_SYMBOL(schedule_timeout_idle);
+
 #ifdef CONFIG_HOTPLUG_CPU
 static void migrate_timer_list(struct tvec_base *new_base, struct hlist_head *head)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

