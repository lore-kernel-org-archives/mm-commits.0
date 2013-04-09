From: akpm@linux-foundation.org
Subject: + kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch added to -mm tree
Date: Tue, 09 Apr 2013 13:27:08 -0700
Message-ID: <20130409202709.3A5615A429A@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:53502 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936203Ab3DIU1K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Apr 2013 16:27:10 -0400
Received: by mail-ob0-f202.google.com with SMTP id va7so730119obc.3
        for <mm-commits@vger.kernel.org>; Tue, 09 Apr 2013 13:27:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, linux@roeck-us.net, sfr@canb.auug.org.au, tglx@linutronix.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch

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
Subject: kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes

WARNING: space prohibited between function name and open parenthesis '('
#244: FILE: kernel/sys.c:2453:
+	    __put_user (s.uptime, &info->uptime) ||

WARNING: space prohibited between function name and open parenthesis '('
#245: FILE: kernel/sys.c:2454:
+	    __put_user (s.loads[0], &info->loads[0]) ||

WARNING: space prohibited between function name and open parenthesis '('
#246: FILE: kernel/sys.c:2455:
+	    __put_user (s.loads[1], &info->loads[1]) ||

WARNING: space prohibited between function name and open parenthesis '('
#247: FILE: kernel/sys.c:2456:
+	    __put_user (s.loads[2], &info->loads[2]) ||

WARNING: space prohibited between function name and open parenthesis '('
#248: FILE: kernel/sys.c:2457:
+	    __put_user (s.totalram, &info->totalram) ||

WARNING: space prohibited between function name and open parenthesis '('
#249: FILE: kernel/sys.c:2458:
+	    __put_user (s.freeram, &info->freeram) ||

WARNING: space prohibited between function name and open parenthesis '('
#250: FILE: kernel/sys.c:2459:
+	    __put_user (s.sharedram, &info->sharedram) ||

WARNING: space prohibited between function name and open parenthesis '('
#251: FILE: kernel/sys.c:2460:
+	    __put_user (s.bufferram, &info->bufferram) ||

WARNING: space prohibited between function name and open parenthesis '('
#252: FILE: kernel/sys.c:2461:
+	    __put_user (s.totalswap, &info->totalswap) ||

WARNING: space prohibited between function name and open parenthesis '('
#253: FILE: kernel/sys.c:2462:
+	    __put_user (s.freeswap, &info->freeswap) ||

WARNING: space prohibited between function name and open parenthesis '('
#254: FILE: kernel/sys.c:2463:
+	    __put_user (s.procs, &info->procs) ||

WARNING: space prohibited between function name and open parenthesis '('
#255: FILE: kernel/sys.c:2464:
+	    __put_user (s.totalhigh, &info->totalhigh) ||

WARNING: space prohibited between function name and open parenthesis '('
#256: FILE: kernel/sys.c:2465:
+	    __put_user (s.freehigh, &info->freehigh) ||

WARNING: space prohibited between function name and open parenthesis '('
#257: FILE: kernel/sys.c:2466:
+	    __put_user (s.mem_unit, &info->mem_unit))

total: 0 errors, 14 warnings, 452 lines checked

./patches/kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN kernel/sys.c~kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes kernel/sys.c
--- a/kernel/sys.c~kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes
+++ a/kernel/sys.c
@@ -2450,20 +2450,20 @@ COMPAT_SYSCALL_DEFINE1(sysinfo, struct c
 	}
 
 	if (!access_ok(VERIFY_WRITE, info, sizeof(struct compat_sysinfo)) ||
-	    __put_user (s.uptime, &info->uptime) ||
-	    __put_user (s.loads[0], &info->loads[0]) ||
-	    __put_user (s.loads[1], &info->loads[1]) ||
-	    __put_user (s.loads[2], &info->loads[2]) ||
-	    __put_user (s.totalram, &info->totalram) ||
-	    __put_user (s.freeram, &info->freeram) ||
-	    __put_user (s.sharedram, &info->sharedram) ||
-	    __put_user (s.bufferram, &info->bufferram) ||
-	    __put_user (s.totalswap, &info->totalswap) ||
-	    __put_user (s.freeswap, &info->freeswap) ||
-	    __put_user (s.procs, &info->procs) ||
-	    __put_user (s.totalhigh, &info->totalhigh) ||
-	    __put_user (s.freehigh, &info->freehigh) ||
-	    __put_user (s.mem_unit, &info->mem_unit))
+	    __put_user(s.uptime, &info->uptime) ||
+	    __put_user(s.loads[0], &info->loads[0]) ||
+	    __put_user(s.loads[1], &info->loads[1]) ||
+	    __put_user(s.loads[2], &info->loads[2]) ||
+	    __put_user(s.totalram, &info->totalram) ||
+	    __put_user(s.freeram, &info->freeram) ||
+	    __put_user(s.sharedram, &info->sharedram) ||
+	    __put_user(s.bufferram, &info->bufferram) ||
+	    __put_user(s.totalswap, &info->totalswap) ||
+	    __put_user(s.freeswap, &info->freeswap) ||
+	    __put_user(s.procs, &info->procs) ||
+	    __put_user(s.totalhigh, &info->totalhigh) ||
+	    __put_user(s.freehigh, &info->freehigh) ||
+	    __put_user(s.mem_unit, &info->mem_unit))
 		return -EFAULT;
 
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-ipc-dont-allocate-a-copy-larger-than-max.patch
mips-define-kvm_user_mem_slots.patch
auditsc-use-kzalloc-instead-of-kmallocmemset-fix.patch
drivers-video-implement-a-simple-framebuffer-driver-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
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
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch
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
aio-kill-ki_retry-fix.patch
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

