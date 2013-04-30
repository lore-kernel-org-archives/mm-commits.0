From: akpm@linux-foundation.org
Subject: + linux-next-rejects.patch added to -mm tree
Date: Tue, 30 Apr 2013 15:36:47 -0700
Message-ID: <20130430223647.6464831C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:57199 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933772Ab3D3Wgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:36:48 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so115936qcs.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:36:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

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
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/Kconfig                |    4 +++-
 fs/coredump.c                    |    2 ++
 fs/fs-writeback.c                |    1 +
 tools/testing/selftests/Makefile |    1 +
 4 files changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/tile/Kconfig~linux-next-rejects arch/tile/Kconfig
--- a/arch/tile/Kconfig~linux-next-rejects
+++ a/arch/tile/Kconfig
@@ -16,13 +16,15 @@ config TILE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
 	select HAVE_DEBUG_BUGVERBOSE
-	select HAVE_SYSCALL_WRAPPERS if TILEGX
 	select VIRT_TO_BUS
 	select SYS_HYPERVISOR
 	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
+	select HAVE_ARCH_TRACEHOOK
+	select HAVE_SYSCALL_TRACEPOINTS
+	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
diff -puN fs/coredump.c~linux-next-rejects fs/coredump.c
--- a/fs/coredump.c~linux-next-rejects
+++ a/fs/coredump.c
@@ -654,7 +654,9 @@ void do_coredump(siginfo_t *siginfo)
 		goto close_fail;
 	if (displaced)
 		put_files_struct(displaced);
+	file_start_write(cprm.file);
 	core_dumped = !dump_interrupted() && binfmt->core_dump(&cprm);
+	file_end_write(cprm.file);
 
 	if (ispipe && core_pipe_limit)
 		wait_for_dump_helpers(cprm.file);
diff -puN fs/fs-writeback.c~linux-next-rejects fs/fs-writeback.c
--- a/fs/fs-writeback.c~linux-next-rejects
+++ a/fs/fs-writeback.c
@@ -1009,6 +1009,7 @@ void bdi_writeback_workfn(struct work_st
 	struct backing_dev_info *bdi = wb->bdi;
 	long pages_written;
 
+	set_worker_desc("flush-%s", dev_name(bdi->dev));
 	current->flags |= PF_SWAPWRITE;
 
 	if (likely(!current_is_workqueue_rescuer() ||
diff -puN tools/testing/selftests/Makefile~linux-next-rejects tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~linux-next-rejects
+++ a/tools/testing/selftests/Makefile
@@ -4,6 +4,7 @@ TARGETS += efivarfs
 TARGETS += kcmp
 TARGETS += memory-hotplug
 TARGETS += mqueue
+TARGETS += net
 TARGETS += ptrace
 TARGETS += soft-dirty
 TARGETS += vm
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-usb-storage-realtek_crc-fix-build.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
kernel-smpc-cleanups.patch
lib-string_helpers-introduce-generic-string_unescape.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid.patch
usermodehelper-export-_exec-and-_setup-functions.patch
kexec-use-min_t-to-simplify-logic.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap.patch
pid_namespacec-h-simplify-defines.patch
revert-1.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects1.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-ipc-dont-allocate-a-copy-larger-than-max.patch
clear_refs-sanitize-accepted-commands-declaration.patch
include-linux-mmh-complete-the-mm_walk-definition.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
revert-ipc_schedule_free-can-do-vfree-now.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix-checkpatch-fixes.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic-fix.patch
ipc-sysv-shared-memory-limited-to-8tib-fix.patch
rapidio-make-enumeration-discovery-configurable-fix.patch
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

