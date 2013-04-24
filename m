From: akpm@linux-foundation.org
Subject: + bpf-add-comments-explaining-the-schedule_work-operation.patch added to -mm tree
Date: Wed, 24 Apr 2013 15:33:34 -0700
Message-ID: <20130424223334.E6D8231C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:45106 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab3DXWdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 18:33:36 -0400
Received: by mail-vb0-f73.google.com with SMTP id p13so146399vbe.2
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 15:33:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, daniel.borkmann@tik.ee.ethz.ch, davem@davemloft.net, linux@arm.linux.org.uk, mgherzan@gmail.com, nschichan@freebox.fr, wad@chromium.org


The patch titled
     Subject: bpf: add comments explaining the schedule_work() operation
has been added to the -mm tree.  Its filename is
     bpf-add-comments-explaining-the-schedule_work-operation.patch

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
Subject: bpf: add comments explaining the schedule_work() operation

Cc: Will Drewry <wad@chromium.org>
Cc: Mircea Gherzan <mgherzan@gmail.com>
Cc: Nicolas Schichan <nschichan@freebox.fr>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/net/bpf_jit_32.c       |    8 ++++++++
 arch/powerpc/net/bpf_jit_comp.c |    4 ++++
 arch/s390/net/bpf_jit_comp.c    |    4 ++++
 arch/sparc/net/bpf_jit_comp.c   |    4 ++++
 arch/x86/net/bpf_jit_comp.c     |    4 ++++
 5 files changed, 24 insertions(+)

diff -puN arch/arm/net/bpf_jit_32.c~bpf-add-comments-explaining-the-schedule_work-operation arch/arm/net/bpf_jit_32.c
--- a/arch/arm/net/bpf_jit_32.c~bpf-add-comments-explaining-the-schedule_work-operation
+++ a/arch/arm/net/bpf_jit_32.c
@@ -958,6 +958,10 @@ void bpf_jit_free(struct sk_filter *fp)
 	struct work_struct *work;
 
 	if (fp->bpf_func != sk_run_filter) {
+		/*
+		 * bpf_jit_free() can be called from softirq; module_free()
+		 * requires process context.
+		 */
 		work = (struct work_struct *)fp->bpf_func;
 
 		INIT_WORK(work, bpf_jit_free_worker);
@@ -985,6 +989,10 @@ void seccomp_jit_free(struct seccomp_fil
 	void *bpf_func = seccomp_filter_get_bpf_func(fp);
 
 	if (bpf_func != sk_run_filter) {
+		/*
+		 * seccomp_jit_free() can be called from softirq; module_free()
+		 * requires process context.
+		 */
 		work = (struct work_struct *)bpf_func;
 
 		INIT_WORK(work, bpf_jit_free_worker);
diff -puN arch/powerpc/net/bpf_jit_comp.c~bpf-add-comments-explaining-the-schedule_work-operation arch/powerpc/net/bpf_jit_comp.c
--- a/arch/powerpc/net/bpf_jit_comp.c~bpf-add-comments-explaining-the-schedule_work-operation
+++ a/arch/powerpc/net/bpf_jit_comp.c
@@ -699,6 +699,10 @@ static void jit_free_defer(struct work_s
 void bpf_jit_free(struct sk_filter *fp)
 {
 	if (fp->bpf_func != sk_run_filter) {
+		/*
+		 * bpf_jit_free() can be called from softirq; module_free()
+		 * requires process context.
+		 */
 		struct work_struct *work = (struct work_struct *)fp->bpf_func;
 
 		INIT_WORK(work, jit_free_defer);
diff -puN arch/s390/net/bpf_jit_comp.c~bpf-add-comments-explaining-the-schedule_work-operation arch/s390/net/bpf_jit_comp.c
--- a/arch/s390/net/bpf_jit_comp.c~bpf-add-comments-explaining-the-schedule_work-operation
+++ a/arch/s390/net/bpf_jit_comp.c
@@ -818,6 +818,10 @@ void bpf_jit_free(struct sk_filter *fp)
 
 	if (fp->bpf_func == sk_run_filter)
 		return;
+	/*
+	 * bpf_jit_free() can be called from softirq; module_free() requires
+	 * process context.
+	 */
 	work = (struct work_struct *)fp->bpf_func;
 	INIT_WORK(work, jit_free_defer);
 	schedule_work(work);
diff -puN arch/sparc/net/bpf_jit_comp.c~bpf-add-comments-explaining-the-schedule_work-operation arch/sparc/net/bpf_jit_comp.c
--- a/arch/sparc/net/bpf_jit_comp.c~bpf-add-comments-explaining-the-schedule_work-operation
+++ a/arch/sparc/net/bpf_jit_comp.c
@@ -817,6 +817,10 @@ static void jit_free_defer(struct work_s
 void bpf_jit_free(struct sk_filter *fp)
 {
 	if (fp->bpf_func != sk_run_filter) {
+		/*
+		 * bpf_jit_free() can be called from softirq; module_free()
+		 * requires process context.
+		 */
 		struct work_struct *work = (struct work_struct *)fp->bpf_func;
 
 		INIT_WORK(work, jit_free_defer);
diff -puN arch/x86/net/bpf_jit_comp.c~bpf-add-comments-explaining-the-schedule_work-operation arch/x86/net/bpf_jit_comp.c
--- a/arch/x86/net/bpf_jit_comp.c~bpf-add-comments-explaining-the-schedule_work-operation
+++ a/arch/x86/net/bpf_jit_comp.c
@@ -749,6 +749,10 @@ static void jit_free_defer(struct work_s
 void bpf_jit_free(struct sk_filter *fp)
 {
 	if (fp->bpf_func != sk_run_filter) {
+		/*
+		 * bpf_jit_free() can be called from softirq; module_free()
+		 * requires process context.
+		 */
 		struct work_struct *work = (struct work_struct *)fp->bpf_func;
 
 		INIT_WORK(work, jit_free_defer);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-ipc-dont-allocate-a-copy-larger-than-max.patch
auditsc-use-kzalloc-instead-of-kmallocmemset-fix.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees-fix.patch
drivers-video-implement-a-simple-framebuffer-driver-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
ipc-utilc-use-register_hotmemory_notifier.patch
mm-slubc-use-register_hotmemory_notifier.patch
drivers-base-nodec-switch-to-register_hotmemory_notifier.patch
fs-proc-kcorec-use-register_hotmemory_notifier.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes.patch
resource-add-release_mem_region_adjustable-fix.patch
resource-add-release_mem_region_adjustable-fix-fix.patch
resource-add-release_mem_region_adjustable-fix-fix-fix.patch
mm-madvise-complete-input-validation-before-taking-lock-fix.patch
clear_refs-sanitize-accepted-commands-declaration-fix.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
memcg-add-memorypressure_level-events-checkpatch-fixes.patch
memcg-add-memorypressure_level-events-fix.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix-fix.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix.patch
genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix-fix.patch
misc-generic-on-chip-sram-allocation-driver-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
lib-string_helpers-introduce-generic-string_unescape-fix.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-mainc-convert-to-pr_foo.patch
init-mainc-convert-to-pr_foo-fix.patch
init-mainc-convert-to-pr_foo-fix-fix.patch
rtc-ds1307-long-block-operations-bugfix.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
fat-additions-to-support-fat_fallocate-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix-checkpatch-fixes.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic-fix.patch
ipc-sysv-shared-memory-limited-to-8tib-fix.patch
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

