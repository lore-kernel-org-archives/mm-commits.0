From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 06 Aug 2014 12:02:08 -0700
Message-ID: <53e27bb0.guwqx+1lvaPDiVfr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f201.google.com ([209.85.160.201]:50966 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbaHFTCK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 15:02:10 -0400
Received: by mail-yk0-f201.google.com with SMTP id 142so394406ykq.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 12:02:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |    3 ---
 kernel/workqueue.c     |    8 --------
 2 files changed, 11 deletions(-)

diff -puN drivers/pnp/pnpacpi/core.c~linux-next-git-rejects drivers/pnp/pnpacpi/core.c
diff -puN include/linux/percpu.h~linux-next-git-rejects include/linux/percpu.h
--- a/include/linux/percpu.h~linux-next-git-rejects
+++ a/include/linux/percpu.h
@@ -130,8 +130,6 @@ extern phys_addr_t per_cpu_ptr_to_phys(v
 #define alloc_percpu(type)	\
 	(typeof(type) __percpu *)__alloc_percpu(sizeof(type), __alignof__(type))
 
-<<<<<<< HEAD
-=======
 /*
  * percpu_pool is an automatically managed percpu allocation cache which
  * can be used to allocate percpu areas from atomic contexts.
@@ -221,5 +219,4 @@ extern void percpu_pool_fill(struct perc
 extern void percpu_pool_empty(struct percpu_pool *pool);
 extern void __percpu *percpu_pool_alloc(struct percpu_pool *pool);
 
->>>>>>> linux-next/akpm-base
 #endif /* __LINUX_PERCPU_H */
diff -puN kernel/workqueue.c~linux-next-git-rejects kernel/workqueue.c
--- a/kernel/workqueue.c~linux-next-git-rejects
+++ a/kernel/workqueue.c
@@ -1962,10 +1962,6 @@ __acquires(&pool->lock)
 
 	lockdep_copy_map(&lockdep_map, &work->lockdep_map);
 #endif
-<<<<<<< HEAD
-	/* ensure we're on the correct CPU */
-=======
->>>>>>> linux-next/akpm-base
 	WARN_ON_ONCE(!(pool->flags & POOL_DISASSOCIATED) &&
 		     raw_smp_processor_id() != pool->cpu);
 
@@ -4578,11 +4574,7 @@ static int workqueue_cpu_up_callback(str
 		for_each_pool(pool, pi) {
 			mutex_lock(&pool->attach_mutex);
 
-<<<<<<< HEAD
-			if (pool->cpu == cpu)
-=======
 			if (pool->cpu == cpu) {
->>>>>>> linux-next/akpm-base
 				rebind_workers(pool);
 			else if (pool->cpu < 0)
 				restore_unbound_workers_cpumask(pool, cpu);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
kernel-smpc-on_each_cpu_cond-fix-warning-in-fallback-path.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
rtc-add-pcf85063-support-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

