From: akpm@linux-foundation.org
Subject: [folded-merged] mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 08 Apr 2013 12:36:41 -0700
Message-ID: <20130408193641.8BE415A421A@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:36479 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935747Ab3DHTgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 15:36:47 -0400
Received: by mail-ie0-f201.google.com with SMTP id a11so1555276iee.0
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 12:36:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, agshew@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes

WARNING: externs should be avoided in .c files
#341: FILE: kernel/sysctl.c:100:
+extern unsigned long sysctl_admin_reserve_kbytes;

WARNING: line over 80 characters
#379: FILE: mm/mmap.c:172:
+			free -= sysctl_admin_reserve_kbytes  >> (PAGE_SHIFT - 10);

WARNING: line over 80 characters
#441: FILE: mm/nommu.c:1936:
+			free -= sysctl_admin_reserve_kbytes  >> (PAGE_SHIFT - 10);

total: 0 errors, 3 warnings, 172 lines checked

./patches/mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrew Shewmaker <agshew@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 kernel/sysctl.c    |    1 -
 mm/mmap.c          |    2 +-
 mm/nommu.c         |    2 +-
 4 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes include/linux/mm.h
--- a/include/linux/mm.h~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes
+++ a/include/linux/mm.h
@@ -45,6 +45,7 @@ extern int sysctl_legacy_va_layout;
 #include <asm/processor.h>
 
 extern unsigned long sysctl_user_reserve_kbytes;
+extern unsigned long sysctl_admin_reserve_kbytes;
 
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 
diff -puN kernel/sysctl.c~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes kernel/sysctl.c
--- a/kernel/sysctl.c~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes
+++ a/kernel/sysctl.c
@@ -97,7 +97,6 @@
 /* External variables not in a header file. */
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
-extern unsigned long sysctl_admin_reserve_kbytes;
 extern int max_threads;
 extern int suid_dumpable;
 #ifdef CONFIG_COREDUMP
diff -puN mm/mmap.c~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes mm/mmap.c
--- a/mm/mmap.c~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes
+++ a/mm/mmap.c
@@ -168,7 +168,7 @@ int __vm_enough_memory(struct mm_struct
 		 * Reserve some for root
 		 */
 		if (!cap_sys_admin)
-			free -= sysctl_admin_reserve_kbytes  >> (PAGE_SHIFT - 10);
+			free -= sysctl_admin_reserve_kbytes >> (PAGE_SHIFT - 10);
 
 		if (free > pages)
 			return 0;
diff -puN mm/nommu.c~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes mm/nommu.c
--- a/mm/nommu.c~mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes
+++ a/mm/nommu.c
@@ -1932,7 +1932,7 @@ int __vm_enough_memory(struct mm_struct
 		 * Reserve some for root
 		 */
 		if (!cap_sys_admin)
-			free -= sysctl_admin_reserve_kbytes  >> (PAGE_SHIFT - 10);
+			free -= sysctl_admin_reserve_kbytes >> (PAGE_SHIFT - 10);
 
 		if (free > pages)
 			return 0;
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
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
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

