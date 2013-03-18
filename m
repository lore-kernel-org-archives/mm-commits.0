From: akpm@linux-foundation.org
Subject: [folded-merged] generic-dynamic-per-cpu-refcounting-doc-fix.patch removed from -mm tree
Date: Mon, 18 Mar 2013 13:33:41 -0700
Message-ID: <20130318203341.9D2705A44D1@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:50251 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3CRUdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 16:33:42 -0400
Received: by mail-gh0-f201.google.com with SMTP id z19so614371ghb.4
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 13:33:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: generic-dynamic-per-cpu-refcounting-doc-fix
has been removed from the -mm tree.  Its filename was
     generic-dynamic-per-cpu-refcounting-doc-fix.patch

This patch was dropped because it was folded into generic-dynamic-per-cpu-refcounting.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: generic-dynamic-per-cpu-refcounting-doc-fix

a little tidy

Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-refcount.h |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN include/linux/percpu-refcount.h~generic-dynamic-per-cpu-refcounting-doc-fix include/linux/percpu-refcount.h
--- a/include/linux/percpu-refcount.h~generic-dynamic-per-cpu-refcounting-doc-fix
+++ a/include/linux/percpu-refcount.h
@@ -21,19 +21,18 @@
  * BACKGROUND:
  *
  * Percpu refcounts are quite useful for performance, but if we blindly
- * converted all refcounts to percpu counters we'd waste quite a bit of memory
- * think about all the refcounts embedded in kobjects, files, etc. most of which
- * aren't used much.
+ * converted all refcounts to percpu counters we'd waste quite a bit of memory.
  *
- * These start out as simple atomic counters - a little bigger than a bare
- * atomic_t, 16 bytes instead of 4 - but if we exceed some arbitrary number of
- * gets in one second, we then switch to percpu counters.
+ * Think about all the refcounts embedded in kobjects, files, etc. most of which
+ * aren't used much. These start out as simple atomic counters - a little bigger
+ * than a bare atomic_t, 16 bytes instead of 4 - but if we exceed some arbitrary
+ * number of gets in one second, we then switch to percpu counters.
  *
  * This heuristic isn't perfect because it'll fire if the refcount was only
  * being used on one cpu; ideally we'd be able to count the number of cache
  * misses on percpu_ref_get() or something similar, but that'd make the non
  * percpu path significantly heavier/more complex. We can count the number of
- * gets() without any extra atomic instructions, on arches that support
+ * gets() without any extra atomic instructions on arches that support
  * atomic64_t - simply by changing the atomic_inc() to atomic_add_return().
  *
  * USAGE:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
printk-provide-a-wake_up_klogd-off-case-fix.patch
mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting-fix.patch
mips-define-kvm_user_mem_slots.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
aio-kiocb_cancel.patch
wait-add-wait_event_hrtimeout.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

