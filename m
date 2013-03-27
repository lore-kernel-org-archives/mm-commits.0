From: akpm@linux-foundation.org
Subject: + mm-limit-growth-of-3%-hardcoded-other-user-reserve-checkpatch-fixes.patch added to -mm tree
Date: Wed, 27 Mar 2013 14:33:16 -0700
Message-ID: <20130327213317.184185A4206@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:48465 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab3C0VdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 17:33:18 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so877517qcr.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 14:33:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, agshew@gmail.com


The patch titled
     Subject: mm-limit-growth-of-3%-hardcoded-other-user-reserve-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-limit-growth-of-3%-hardcoded-other-user-reserve-checkpatch-fixes.patch

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
Subject: mm-limit-growth-of-3%-hardcoded-other-user-reserve-checkpatch-fixes

WARNING: externs should be avoided in .c files
#366: FILE: kernel/sysctl.c:100:
+extern unsigned long sysctl_user_reserve_kbytes;

ERROR: code indent should use tabs where possible
#421: FILE: mm/mmap.c:189:
+ ^I * Don't let a single process grow so big a user can't recover$

WARNING: please, no space before tabs
#421: FILE: mm/mmap.c:189:
+ ^I * Don't let a single process grow so big a user can't recover$

ERROR: code indent should use tabs where possible
#422: FILE: mm/mmap.c:190:
+         */$

WARNING: line over 80 characters
#439: FILE: mm/mmap.c:3107:
+ * process, such that they cannot recover (kill the hog) in OVERCOMMIT_NEVER mode.

ERROR: code indent should use tabs where possible
#492: FILE: mm/nommu.c:1953:
+         */$

WARNING: line over 80 characters
#509: FILE: mm/nommu.c:2124:
+ * process, such that they cannot recover (kill the hog) in OVERCOMMIT_NEVER mode.

total: 3 errors, 4 warnings, 202 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrew Shewmaker <agshew@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 kernel/sysctl.c    |    1 -
 mm/mmap.c          |    7 ++++---
 mm/nommu.c         |    5 +++--
 4 files changed, 9 insertions(+), 6 deletions(-)

diff -puN include/linux/mm.h~mm-limit-growth-of-3%-hardcoded-other-user-reserve-checkpatch-fixes include/linux/mm.h
--- a/include/linux/mm.h~mm-limit-growth-of-3%-hardcoded-other-user-reserve-checkpatch-fixes
+++ a/include/linux/mm.h
@@ -44,6 +44,8 @@ extern int sysctl_legacy_va_layout;
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 
+extern unsigned long sysctl_user_reserve_kbytes;
+
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 
 /* to align the pointer to the (next) page boundary */
diff -puN kernel/sysctl.c~mm-limit-growth-of-3%-hardcoded-other-user-reserve-checkpatch-fixes kernel/sysctl.c
--- a/kernel/sysctl.c~mm-limit-growth-of-3%-hardcoded-other-user-reserve-checkpatch-fixes
+++ a/kernel/sysctl.c
@@ -97,7 +97,6 @@
 /* External variables not in a header file. */
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
-extern unsigned long sysctl_user_reserve_kbytes;
 extern int max_threads;
 extern int suid_dumpable;
 #ifdef CONFIG_COREDUMP
diff -puN mm/mmap.c~mm-limit-growth-of-3%-hardcoded-other-user-reserve-checkpatch-fixes mm/mmap.c
--- a/mm/mmap.c~mm-limit-growth-of-3%-hardcoded-other-user-reserve-checkpatch-fixes
+++ a/mm/mmap.c
@@ -186,8 +186,8 @@ int __vm_enough_memory(struct mm_struct
 	allowed += total_swap_pages;
 
 	/*
- 	 * Don't let a single process grow so big a user can't recover
-         */
+	 * Don't let a single process grow so big a user can't recover
+	 */
 	if (mm) {
 		reserve = sysctl_user_reserve_kbytes >> (PAGE_SHIFT - 10);
 		allowed -= min(mm->total_vm / 32, reserve);
@@ -3104,7 +3104,8 @@ void __init mmap_init(void)
  * Initialise sysctl_user_reserve_kbytes.
  *
  * This is intended to prevent a user from starting a single memory hogging
- * process, such that they cannot recover (kill the hog) in OVERCOMMIT_NEVER mode.
+ * process, such that they cannot recover (kill the hog) in OVERCOMMIT_NEVER
+ * mode.
  *
  * The default value is min(3% of free memory, 128MB)
  * 128MB is enough to recover with sshd/login, bash, and top/kill.
diff -puN mm/nommu.c~mm-limit-growth-of-3%-hardcoded-other-user-reserve-checkpatch-fixes mm/nommu.c
--- a/mm/nommu.c~mm-limit-growth-of-3%-hardcoded-other-user-reserve-checkpatch-fixes
+++ a/mm/nommu.c
@@ -1950,7 +1950,7 @@ int __vm_enough_memory(struct mm_struct
 
 	/*
 	 * Don't let a single process grow so big a user can't recover
-         */
+	 */
 	if (mm) {
 		reserve = sysctl_user_reserve_kbytes >> (PAGE_SHIFT - 10);
 		allowed -= min(mm->total_vm / 32, reserve);
@@ -2121,7 +2121,8 @@ int nommu_shrink_inode_mappings(struct i
  * Initialise sysctl_user_reserve_kbytes.
  *
  * This is intended to prevent a user from starting a single memory hogging
- * process, such that they cannot recover (kill the hog) in OVERCOMMIT_NEVER mode.
+ * process, such that they cannot recover (kill the hog) in OVERCOMMIT_NEVER
+ * mode.
  *
  * The default value is min(3% of free memory, 128MB)
  * 128MB is enough to recover with sshd/login, bash, and top/kill.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-ipc-dont-allocate-a-copy-larger-than-max.patch
mips-define-kvm_user_mem_slots.patch
drivers-staging-zcache-zcache-mainc-fix-build.patch
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
mm-limit-growth-of-3%-hardcoded-other-user-reserve-checkpatch-fixes.patch
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

