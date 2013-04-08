From: akpm@linux-foundation.org
Subject: + include-linux-memoryh-implement-register_hotmemory_notifier.patch added to -mm tree
Date: Mon, 08 Apr 2013 13:37:31 -0700
Message-ID: <20130408203731.DE8B65A4201@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:62112 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936032Ab3DHUhe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 16:37:34 -0400
Received: by mail-ia0-f202.google.com with SMTP id p22so1572036iad.3
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 13:37:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, agshew@gmail.com


The patch titled
     Subject: include/linux/memory.h: implement register_hotmemory_notifier()
has been added to the -mm tree.  Its filename is
     include-linux-memoryh-implement-register_hotmemory_notifier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 include/linux/memory.h   |   15 ++++++++++++---
 include/linux/notifier.h |    5 ++++-
 2 files changed, 16 insertions(+), 4 deletions(-)

diff -puN include/linux/memory.h~include-linux-memoryh-implement-register_hotmemory_notifier include/linux/memory.h
--- a/include/linux/memory.h~include-linux-memoryh-implement-register_hotmemory_notifier
+++ a/include/linux/memory.h
@@ -18,6 +18,7 @@
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/mutex.h>
+#include <linux/notifier.h>
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
@@ -127,13 +128,21 @@ enum mem_add_context { BOOT, HOTPLUG };
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-#define hotplug_memory_notifier(fn, pri) {			\
+#define hotplug_memory_notifier(fn, pri) ({			\
 	static __meminitdata struct notifier_block fn##_mem_nb =\
 		{ .notifier_call = fn, .priority = pri };	\
 	register_memory_notifier(&fn##_mem_nb);			\
-}
+})
+#define register_hotmemory_notifier(nb)		register_memory_notifier(nb)
+#define unregister_hotmemory_notifier(nb) 	unregister_memory_notifier(nb)
 #else
-#define hotplug_memory_notifier(fn, pri) do { } while (0)
+static inline int hotplug_memory_notifier(notifier_fn_t fn, int priority)
+{
+	return 0;
+}
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

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-ipc-dont-allocate-a-copy-larger-than-max.patch
mips-define-kvm_user_mem_slots.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
misc-generic-on-chip-sram-allocation-driver-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-mainc-convert-to-pr_foo.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
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
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

