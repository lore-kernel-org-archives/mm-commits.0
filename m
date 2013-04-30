From: akpm@linux-foundation.org
Subject: [merged] kernel-cpusetc-use-register_hotmemory_notifier.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:48:50 -0700
Message-ID: <20130430184850.737E45A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:49396 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932928Ab3D3Ssv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:48:51 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so85027qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:48:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, lizefan@huawei.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/cpuset.c: use register_hotmemory_notifier()
has been removed from the -mm tree.  Its filename was
     kernel-cpusetc-use-register_hotmemory_notifier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/cpuset.c: use register_hotmemory_notifier()

Use the new interface, remove one ifdef.  No code size changes.

We could/should have been using __meminit/__meminitdata here but there's
now no point in doing that because all this code is elided at compile time.

Cc: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN kernel/cpuset.c~kernel-cpusetc-use-register_hotmemory_notifier kernel/cpuset.c
--- a/kernel/cpuset.c~kernel-cpusetc-use-register_hotmemory_notifier
+++ a/kernel/cpuset.c
@@ -2251,7 +2251,6 @@ void cpuset_update_active_cpus(bool cpu_
 	schedule_work(&cpuset_hotplug_work);
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG
 /*
  * Keep top_cpuset.mems_allowed tracking node_states[N_MEMORY].
  * Call this routine anytime after node_states[N_MEMORY] changes.
@@ -2263,20 +2262,23 @@ static int cpuset_track_online_nodes(str
 	schedule_work(&cpuset_hotplug_work);
 	return NOTIFY_OK;
 }
-#endif
+
+static struct notifier_block cpuset_track_online_nodes_nb = {
+	.notifier_call = cpuset_track_online_nodes,
+	.priority = 10,		/* ??! */
+};
 
 /**
  * cpuset_init_smp - initialize cpus_allowed
  *
  * Description: Finish top cpuset after cpu, node maps are initialized
- **/
-
+ */
 void __init cpuset_init_smp(void)
 {
 	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
 	top_cpuset.mems_allowed = node_states[N_MEMORY];
 
-	hotplug_memory_notifier(cpuset_track_online_nodes, 10);
+	register_hotmemory_notifier(&cpuset_track_online_nodes_nb);
 
 	cpuset_propagate_hotplug_wq =
 		alloc_ordered_workqueue("cpuset_hotplug", 0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
clear_refs-sanitize-accepted-commands-declaration.patch
linux-next.patch
linux-next-git-rejects1.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-usb-storage-realtek_crc-fix-build.patch
revert-ipc-dont-allocate-a-copy-larger-than-max.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
lib-string_helpers-introduce-generic-string_unescape-fix.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
fat-additions-to-support-fat_fallocate-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
revert-ipc_schedule_free-can-do-vfree-now.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix-checkpatch-fixes.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic-fix.patch
ipc-sysv-shared-memory-limited-to-8tib-fix.patch
rapidio-make-enumeration-discovery-configurable-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-dont-include-aioh-in-schedh.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-fix.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-4.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

