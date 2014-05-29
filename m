From: akpm@linux-foundation.org
Subject: [folded-merged]
 page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4-fix.patch
 removed from -mm tree
Date: Thu, 29 May 2014 16:12:08 -0700
Message-ID: <5387bec8.audNS7f1EhH67fI5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaE2XMJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 19:12:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, rientjes@google.com, mtosatti@redhat.com, mgorman@suse.de, lizefan@huawei.com, laijs@cn.fujitsu.com, cl@linux.com, akpm@linux-foundation.org

Subject: [folded-merged] page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,cl@linux.com,laijs@cn.fujitsu.com,lizefan@huawei.com,mgorman@suse.de,mtosatti@redhat.com,rientjes@google.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 16:12:08 -0700


The patch titled
     Subject: page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4-fix
has been removed from the -mm tree.  Its filename was
     page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4-fix.patch

This patch was dropped because it was folded into page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4-fix

add comments

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    5 +++++
 mm/page_alloc.c |    5 +++++
 2 files changed, 10 insertions(+)

diff -puN kernel/cpuset.c~page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4-fix kernel/cpuset.c
--- a/kernel/cpuset.c~page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4-fix
+++ a/kernel/cpuset.c
@@ -2388,6 +2388,11 @@ int __cpuset_node_allowed_softwall(int n
 	if (in_interrupt() || (gfp_mask & __GFP_THISNODE))
 		return 1;
 #ifdef CONFIG_NUMA
+	/*
+	 * Zone specific allocations such as GFP_DMA32 should not be restricted
+	 * to cpusets allowed node list: the zones which such allocations
+	 * demand be contained in particular nodes outside the cpuset node list
+	 */
 	if (gfp_zone(gfp_mask) < policy_zone)
 		return 1;
 #endif
diff -puN mm/page_alloc.c~page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4-fix mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4-fix
+++ a/mm/page_alloc.c
@@ -2742,6 +2742,11 @@ retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
 #ifdef CONFIG_NUMA
+	/*
+	 * Zone specific allocations such as GFP_DMA32 should not be restricted
+	 * to cpusets allowed node list: the zones which such allocations
+	 * demand be contained in particular nodes outside the cpuset node list
+	 */
 	if (gfp_zone(gfp_mask) < policy_zone)
 		nodemask = &node_states[N_ONLINE];
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
fs-add-generic-data-flush-to-fsync-fix.patch
fs-add-generic-data-flush-to-fsync-fix-fix.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
mm-update-comment-for-default_max_map_count-fix.patch
memcg-fold-mem_cgroup_stolen-fix.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site-checkpatch-fixes.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix.patch
page_alloc-skip-cpuset-enforcement-for-lower-zone-allocations-v4.patch
mm-document-do_fault_around-feature-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
rtc-da9063-rtc-driver-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-checkpatch-fixes.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
rwsem-support-optimistic-spinning-checkpatch-fixes.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

