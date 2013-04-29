From: akpm@linux-foundation.org
Subject: + linux-next-rejects.patch added to -mm tree
Date: Mon, 29 Apr 2013 16:38:08 -0700
Message-ID: <20130429233808.671F531C07C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:36538 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab3D2XiJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 19:38:09 -0400
Received: by mail-gh0-f201.google.com with SMTP id r13so393165ghr.4
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 16:38:08 -0700 (PDT)
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

 include/linux/blk_types.h |    1 +
 kernel/rcutree.c          |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/proc/internal.h~linux-next-rejects fs/proc/internal.h
diff -puN include/linux/blk_types.h~linux-next-rejects include/linux/blk_types.h
--- a/include/linux/blk_types.h~linux-next-rejects
+++ a/include/linux/blk_types.h
@@ -118,6 +118,7 @@ struct bio {
  * BIO_POOL_IDX()
  */
 #define BIO_RESET_BITS	13
+#define BIO_OWNS_VEC	13	/* bio_free() should free bvec */
 
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
diff -puN kernel/rcutree.c~linux-next-rejects kernel/rcutree.c
--- a/kernel/rcutree.c~linux-next-rejects
+++ a/kernel/rcutree.c
@@ -1451,7 +1451,8 @@ static int rcu_gp_init(struct rcu_state
 					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irq(&rnp->lock);
 #ifdef CONFIG_PROVE_RCU_DELAY
-		if ((prandom_u32() % (rcu_num_nodes * 8)) == 0)
+		if ((prandom_u32() % (rcu_num_nodes * 8)) == 0 &&
+		    system_state == SYSTEM_RUNNING)
 			schedule_timeout_uninterruptible(2);
 #endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
 		cond_resched();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
auditsc-use-kzalloc-instead-of-kmallocmemset.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch
mm-shmemc-remove-an-ifdef.patch
memcg-relax-memcg-iter-caching.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
kexec-vmalloc-export-additional-vmalloc-layer-information.patch
mm-hugetlb-include-hugepages-in-meminfo.patch
mm-speedup-in-__early_pfn_to_nid.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
ipc-utilc-use-register_hotmemory_notifier.patch
mm-slubc-use-register_hotmemory_notifier.patch
drivers-base-nodec-switch-to-register_hotmemory_notifier.patch
fs-proc-kcorec-use-register_hotmemory_notifier.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch
resource-add-release_mem_region_adjustable.patch
mm-madvise-complete-input-validation-before-taking-lock.patch
clear_refs-sanitize-accepted-commands-declaration.patch
memcg-add-memorypressure_level-events.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io.patch
mem-hotunplug-fix-kfree-of-bootmem-memory.patch
genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device.patch
misc-generic-on-chip-sram-allocation-driver.patch
early_printk-consolidate-random-copies-of-identical-code.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra.patch
init-mainc-convert-to-pr_foo.patch
rtc-ds1307-long-block-operations-bugfix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
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

