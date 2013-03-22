From: akpm@linux-foundation.org
Subject: [folded-merged] printk-provide-a-wake_up_klogd-off-case-fix.patch removed from -mm tree
Date: Fri, 22 Mar 2013 14:58:47 -0700
Message-ID: <20130322215847.BDAD25A402F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:57663 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423048Ab3CVV6t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Mar 2013 17:58:49 -0400
Received: by mail-yh0-f74.google.com with SMTP id i57so129141yha.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2013 14:58:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fweisbec@gmail.com, james.hogan@imgtec.com, mingo@kernel.org, peterz@infradead.org, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-provide-a-wake_up_klogd-off-case-fix
has been removed from the -mm tree.  Its filename was
     printk-provide-a-wake_up_klogd-off-case-fix.patch

This patch was dropped because it was folded into printk-provide-a-wake_up_klogd-off-case.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: printk-provide-a-wake_up_klogd-off-case-fix

include printk.h in bust_spinlocks.c.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bust_spinlocks.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/bust_spinlocks.c~printk-provide-a-wake_up_klogd-off-case-fix lib/bust_spinlocks.c
--- a/lib/bust_spinlocks.c~printk-provide-a-wake_up_klogd-off-case-fix
+++ a/lib/bust_spinlocks.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/spinlock.h>
 #include <linux/tty.h>
 #include <linux/wait.h>
@@ -28,5 +29,3 @@ void __attribute__((weak)) bust_spinlock
 			wake_up_klogd();
 	}
 }
-
-
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

printk-provide-a-wake_up_klogd-off-case.patch
mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting-fix.patch
dma-debug-fix-locking-bug-in-check_unmap-fix.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mips-define-kvm_user_mem_slots.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes.patch
loop-cleanup-partitions-when-detaching-loop-device-fix.patch
loop-cleanup-partitions-when-detaching-loop-device-fix-fix.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
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
aio-kill-ki_retry.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
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

