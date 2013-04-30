From: akpm@linux-foundation.org
Subject: [merged] ipc-utilc-use-register_hotmemory_notifier.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:48:39 -0700
Message-ID: <20130430184839.6EA055A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:43441 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3Ssk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:48:40 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so85058yen.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:48:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/util.c: use register_hotmemory_notifier()
has been removed from the -mm tree.  Its filename was
     ipc-utilc-use-register_hotmemory_notifier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc/util.c: use register_hotmemory_notifier()

Squishes a statement-with-no-effect warning, removes some ifdefs and
shrinks .text by one byte!

Note that this code fails to check for blocking_notifier_chain_register()
failures.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN ipc/util.c~ipc-utilc-use-register_hotmemory_notifier ipc/util.c
--- a/ipc/util.c~ipc-utilc-use-register_hotmemory_notifier
+++ a/ipc/util.c
@@ -23,6 +23,7 @@
 #include <linux/msg.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
+#include <linux/notifier.h>
 #include <linux/capability.h>
 #include <linux/highuid.h>
 #include <linux/security.h>
@@ -47,19 +48,16 @@ struct ipc_proc_iface {
 	int (*show)(struct seq_file *, void *);
 };
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-
 static void ipc_memory_notifier(struct work_struct *work)
 {
 	ipcns_notify(IPCNS_MEMCHANGED);
 }
 
-static DECLARE_WORK(ipc_memory_wq, ipc_memory_notifier);
-
-
 static int ipc_memory_callback(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
+	static DECLARE_WORK(ipc_memory_wq, ipc_memory_notifier);
+
 	switch (action) {
 	case MEM_ONLINE:    /* memory successfully brought online */
 	case MEM_OFFLINE:   /* or offline: it's time to recompute msgmni */
@@ -85,7 +83,10 @@ static int ipc_memory_callback(struct no
 	return NOTIFY_OK;
 }
 
-#endif /* CONFIG_MEMORY_HOTPLUG */
+static struct notifier_block ipc_memory_nb = {
+	.notifier_call = ipc_memory_callback,
+	.priority = IPC_CALLBACK_PRI,
+};
 
 /**
  *	ipc_init	-	initialise IPC subsystem
@@ -102,7 +103,7 @@ static int __init ipc_init(void)
 	sem_init();
 	msg_init();
 	shm_init();
-	hotplug_memory_notifier(ipc_memory_callback, IPC_CALLBACK_PRI);
+	register_hotmemory_notifier(&ipc_memory_nb);
 	register_ipcns_notifier(&init_ipc_ns);
 	return 0;
 }
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

