From: akpm@linux-foundation.org
Subject: [merged] include-linux-memoryh-implement-register_hotmemory_notifier.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:48:36 -0700
Message-ID: <20130430184836.7404931C2AA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:63548 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3Ssh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:48:37 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so84966vbf.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:48:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, agshew@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/memory.h: implement register_hotmemory_notifier()
has been removed from the -mm tree.  Its filename was
     include-linux-memoryh-implement-register_hotmemory_notifier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/memory.h: implement register_hotmemory_notifier()

When CONFIG_MEMORY_HOTPLUG=n, we don't want the memory-hotplug notifier
handlers to be included in the .o files, for space reasons.

The existing hotplug_memory_notifier() tries to handle this but testing
with gcc-4.4.4 shows that it doesn't work - the hotplug functions are
still present in the .o files.

So implement a new register_hotmemory_notifier() which is a copy of
register_hotcpu_notifier(), and which actually works as desired. 
hotplug_memory_notifier() and register_memory_notifier() callsites should
be converted to use this new register_hotmemory_notifier().

While we're there, let's repair the existing hotplug_memory_notifier(): it
simply stomps on the register_memory_notifier() return value, so
well-behaved code cannot check for errors.  Apparently non of the existing
callers were well-behaved :(

Cc: Andrew Shewmaker <agshew@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory.h   |   14 ++++++++++----
 include/linux/notifier.h |    5 ++++-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff -puN include/linux/memory.h~include-linux-memoryh-implement-register_hotmemory_notifier include/linux/memory.h
--- a/include/linux/memory.h~include-linux-memoryh-implement-register_hotmemory_notifier
+++ a/include/linux/memory.h
@@ -18,6 +18,7 @@
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/mutex.h>
+#include <linux/notifier.h>
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
@@ -127,13 +128,18 @@ enum mem_add_context { BOOT, HOTPLUG };
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-#define hotplug_memory_notifier(fn, pri) {			\
+#define hotplug_memory_notifier(fn, pri) ({		\
 	static __meminitdata struct notifier_block fn##_mem_nb =\
-		{ .notifier_call = fn, .priority = pri };	\
+		{ .notifier_call = fn, .priority = pri };\
 	register_memory_notifier(&fn##_mem_nb);			\
-}
+})
+#define register_hotmemory_notifier(nb)		register_memory_notifier(nb)
+#define unregister_hotmemory_notifier(nb) 	unregister_memory_notifier(nb)
 #else
-#define hotplug_memory_notifier(fn, pri) do { } while (0)
+#define hotplug_memory_notifier(fn, pri)	(0)
+/* These aren't inline functions due to a GCC bug. */
+#define register_hotmemory_notifier(nb)    ({ (void)(nb); 0; })
+#define unregister_hotmemory_notifier(nb)  ({ (void)(nb); })
 #endif
 
 /*
diff -puN include/linux/notifier.h~include-linux-memoryh-implement-register_hotmemory_notifier include/linux/notifier.h
--- a/include/linux/notifier.h~include-linux-memoryh-implement-register_hotmemory_notifier
+++ a/include/linux/notifier.h
@@ -47,8 +47,11 @@
  * runtime initialization.
  */
 
+typedef	int (*notifier_fn_t)(struct notifier_block *nb,
+			unsigned long action, void *data);
+
 struct notifier_block {
-	int (*notifier_call)(struct notifier_block *, unsigned long, void *);
+	notifier_fn_t notifier_call;
 	struct notifier_block __rcu *next;
 	int priority;
 };
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

