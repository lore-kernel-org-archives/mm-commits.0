From: akpm@linux-foundation.org
Subject: [folded-merged]
 shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch removed
 from -mm tree
Date: Tue, 10 Sep 2013 15:32:48 -0700
Message-ID: <522f9e10.GkXoTJYXEpYTt60G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3IJWct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 18:32:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@openvz.org, dchinner@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,dchinner@redhat.com,glommer@openvz.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 15:32:48 -0700


The patch titled
     Subject: shrinker-convert-remaining-shrinkers-to-count-scan-api-fix
has been removed from the -mm tree.  Its filename was
     shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch

This patch was dropped because it was folded into shrinker-convert-remaining-shrinkers-to-count-scan-api.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: shrinker-convert-remaining-shrinkers-to-count-scan-api-fix

fix warnings

Cc: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/mmu.c |   10 ++++++----
 net/sunrpc/auth.c  |    6 +++---
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN arch/x86/kvm/mmu.c~shrinker-convert-remaining-shrinkers-to-count-scan-api-fix arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~shrinker-convert-remaining-shrinkers-to-count-scan-api-fix
+++ a/arch/x86/kvm/mmu.c
@@ -4421,12 +4421,12 @@ void kvm_mmu_invalidate_mmio_sptes(struc
 	}
 }
 
-static long
+static unsigned long
 mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct kvm *kvm;
 	int nr_to_scan = sc->nr_to_scan;
-	long freed = 0;
+	unsigned long freed = 0;
 
 	raw_spin_lock(&kvm_lock);
 
@@ -4461,7 +4461,8 @@ mmu_shrink_scan(struct shrinker *shrink,
 			goto unlock;
 		}
 
-		freed += prepare_zap_oldest_mmu_page(kvm, &invalid_list);
+		if (prepare_zap_oldest_mmu_page(kvm, &invalid_list))
+			freed++;
 		kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
 unlock:
@@ -4482,7 +4483,8 @@ unlock:
 
 }
 
-static long mmu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
+static unsigned long
+mmu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
 	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
 }
diff -puN net/sunrpc/auth.c~shrinker-convert-remaining-shrinkers-to-count-scan-api-fix net/sunrpc/auth.c
--- a/net/sunrpc/auth.c~shrinker-convert-remaining-shrinkers-to-count-scan-api-fix
+++ a/net/sunrpc/auth.c
@@ -454,12 +454,12 @@ rpcauth_prune_expired(struct list_head *
 /*
  * Run memory cache shrinker.
  */
-static long
+static unsigned long
 rpcauth_cache_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 
 {
 	LIST_HEAD(free);
-	long freed;
+	unsigned long freed;
 
 	if ((sc->gfp_mask & GFP_KERNEL) != GFP_KERNEL)
 		return SHRINK_STOP;
@@ -476,7 +476,7 @@ rpcauth_cache_shrink_scan(struct shrinke
 	return freed;
 }
 
-static long
+static unsigned long
 rpcauth_cache_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch
block-support-embedded-device-command-line-partition.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
mm-track-vma-changes-with-vm_softdirty-bit-fix.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch
mm-page-writebackc-add-strictlimit-feature-fix.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch
vfs-allow-umount-to-handle-mountpoints-without-revalidating-them-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
revert-1.patch
memcg-trivial-cleanups.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

