From: akpm@linux-foundation.org
Subject: [merged]
 kernel-stop_machinec-remove-config_smp-dependencies.patch removed from -mm
 tree
Date: Tue, 19 Jan 2016 12:14:46 -0800
Message-ID: <569e9936.SDoe+1Qfo0FBnpgT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUOr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chris-wilson.co.uk, mingo@kernel.org, valentinrothberg@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/stop_machine.c: remove CONFIG_SMP dependencies
has been removed from the -mm tree.  Its filename was
     kernel-stop_machinec-remove-config_smp-dependencies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/stop_machine.c: remove CONFIG_SMP dependencies

stop_machine.o is only built if CONFIG_SMP=y, so this ifdef always
evaluates to true.

[akpm@linux-foundation.org: remove now-unneeded ifdef]
Reported-by: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN kernel/stop_machine.c~kernel-stop_machinec-remove-config_smp-dependencies kernel/stop_machine.c
--- a/kernel/stop_machine.c~kernel-stop_machinec-remove-config_smp-dependencies
+++ a/kernel/stop_machine.c
@@ -529,8 +529,6 @@ static int __init cpu_stop_init(void)
 }
 early_initcall(cpu_stop_init);
 
-#if defined(CONFIG_SMP) || defined(CONFIG_HOTPLUG_CPU)
-
 static int __stop_machine(cpu_stop_fn_t fn, void *data, const struct cpumask *cpus)
 {
 	struct multi_stop_data msdata = {
@@ -628,5 +626,3 @@ int stop_machine_from_inactive_cpu(cpu_s
 	mutex_unlock(&stop_cpus_mutex);
 	return ret ?: done.ret;
 }
-
-#endif	/* CONFIG_SMP || CONFIG_HOTPLUG_CPU */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sched-add-schedule_timeout_idle.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
printk-nmi-generic-solution-for-safe-printk-in-nmi-v4-fix-fix.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ptrace-use-fsuid-fsgid-effective-creds-for-fs-access-checks-fix.patch
fs-coredump-prevent-core-path-components-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix-3.patch
linux-next-rejects.patch
fs-overlayfs-superc-needs-pagemaph.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-adfs-adfsh-tidy-up-comments.patch
net-drop-tcp_memcontrolc-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix.patch
mm-memcontrol-reign-in-the-config-space-madness-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

