From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-locking-lockdepc-convert-hash-tables-to-hlists-fix.patch removed
 from -mm tree
Date: Tue, 09 Feb 2016 12:14:10 -0800
Message-ID: <56ba4892.CTHrVDkcBzdE3Wl6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353AbcBIUOL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2016 15:14:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, dan.carpenter@oracle.com, krinkin.m.u@gmail.com, mingo@elte.hu, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-locking-lockdepc-convert-hash-tables-to-hlists-fix
has been removed from the -mm tree.  Its filename was
     kernel-locking-lockdepc-convert-hash-tables-to-hlists-fix.patch

This patch was dropped because it was folded into kernel-locking-lockdepc-convert-hash-tables-to-hlists.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-locking-lockdepc-convert-hash-tables-to-hlists-fix

`head' is never NULL here

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Krinkin <krinkin.m.u@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/locking/lockdep.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN kernel/locking/lockdep.c~kernel-locking-lockdepc-convert-hash-tables-to-hlists-fix kernel/locking/lockdep.c
--- a/kernel/locking/lockdep.c~kernel-locking-lockdepc-convert-hash-tables-to-hlists-fix
+++ a/kernel/locking/lockdep.c
@@ -3930,8 +3930,6 @@ void lockdep_free_key_range(void *start,
 	 */
 	for (i = 0; i < CLASSHASH_SIZE; i++) {
 		head = classhash_table + i;
-		if (!head)
-			continue;
 		hlist_for_each_entry_rcu(class, head, hash_entry) {
 			if (within(class->key, start, size))
 				zap_class(class);
@@ -3987,8 +3985,6 @@ void lockdep_reset_lock(struct lockdep_m
 	locked = graph_lock();
 	for (i = 0; i < CLASSHASH_SIZE; i++) {
 		head = classhash_table + i;
-		if (!head)
-			continue;
 		hlist_for_each_entry_rcu(class, head, hash_entry) {
 			int match = 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
vsprintf-kptr_restrict-is-okay-in-irq-when-2-checkpatch-fixes.patch
kernel-locking-lockdepc-convert-hash-tables-to-hlists.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
mm-slab-clean-up-debug_pagealloc-processing-code-fix.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-fix.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch
mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch
sound-query-dynamic-debug_pagealloc-setting-fix.patch
mm-config_nr_zones_extended-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

