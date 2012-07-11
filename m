From: akpm@linux-foundation.org
Subject: [folded] tmpfs-implement-numa-node-interleaving-fix.patch removed from -mm tree
Date: Wed, 11 Jul 2012 15:33:07 -0700
Message-ID: <20120711223308.494785C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:39681 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933468Ab2GKWdL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 18:33:11 -0400
Received: by wibhr14 with SMTP id hr14so86913wib.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 15:33:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, hughd@google.com, lee.schermerhorn@hp.com, npiggin@gmail.com, nzimmer@sgi.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs-implement-numa-node-interleaving-fix
has been removed from the -mm tree.  Its filename was
     tmpfs-implement-numa-node-interleaving-fix.patch

This patch was dropped because it was folded into tmpfs-implement-numa-node-interleaving.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: tmpfs-implement-numa-node-interleaving-fix

add comment

Cc: Christoph Lameter <cl@linux.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nathan T Zimmer <nzimmer@sgi.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/shmem.c~tmpfs-implement-numa-node-interleaving-fix mm/shmem.c
--- a/mm/shmem.c~tmpfs-implement-numa-node-interleaving-fix
+++ a/mm/shmem.c
@@ -938,9 +938,12 @@ static struct page *shmem_alloc_page(gfp
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
 
 	/*
-	 * alloc_page_vma() will drop the shared policy reference
+	 * alloc_page_vma() will drop the shared policy reference.
+	 *
+	 * To avoid allocating all tmpfs pages on node 0, we fake up a virtual
+	 * address based on this file's predetermined preferred node.
 	 */
-	return alloc_page_vma(gfp, &pvma, info->node_offset << PAGE_SHIFT );
+	return alloc_page_vma(gfp, &pvma, info->node_offset << PAGE_SHIFT);
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer.patch
rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled.patch
drivers-gpio-gpio-tps65910c-fix-config_of_gpio=n-build.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-cpu-perf_event_intel_uncoreh-make-uncore_pmu_hrtimer_interval-64-bit.patch
sysfs-fail-dentry-revalidation-after-namespace-change-fix.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix.patch
mm-hugetlb-add-new-hugetlb-cgroup-fix-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool-fix.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise-checkpatch-fixes.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix-fix.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3-typo.patch
tmpfs-implement-numa-node-interleaving.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
printk-add-generic-functions-to-find-kern_level-headers-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
drivers-rtc-rtc-r9701c-check-that-r9701_set_datetime-succeeded.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
include-linux-aioh-cpp-c-conversions.patch
resource-make-sure-requested-range-intersects-root-range-fix.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

