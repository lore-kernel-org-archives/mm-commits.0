From: akpm@linux-foundation.org
Subject: + mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes.patch added to -mm tree
Date: Wed, 27 Mar 2013 14:35:21 -0700
Message-ID: <20130327213521.E816831C254@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:52791 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3C0VfX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 17:35:23 -0400
Received: by mail-gh0-f201.google.com with SMTP id r13so396383ghr.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 14:35:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, agshew@gmail.com


The patch titled
     Subject: mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes.patch

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
@@ -169,7 +169,7 @@ int __vm_enough_memory(struct mm_struct
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
@@ -1933,7 +1933,7 @@ int __vm_enough_memory(struct mm_struct
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
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes.patch
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

