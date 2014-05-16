From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Fri, 16 May 2014 13:45:46 -0700
Message-ID: <537678fa.YivK9I+qRIVvfRRT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbaEPUpr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 May 2014 16:45:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 16 May 2014 13:45:46 -0700


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apic/hw_nmi.c |    2 +-
 mm/memblock.c                 |    2 +-
 mm/memcontrol.c               |   23 ++++++++++++-----------
 3 files changed, 14 insertions(+), 13 deletions(-)

diff -puN arch/x86/kernel/apic/hw_nmi.c~linux-next-rejects arch/x86/kernel/apic/hw_nmi.c
--- a/arch/x86/kernel/apic/hw_nmi.c~linux-next-rejects
+++ a/arch/x86/kernel/apic/hw_nmi.c
@@ -65,7 +65,7 @@ void arch_trigger_all_cpu_backtrace(bool
 	}
 
 	clear_bit(0, &backtrace_flag);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	put_cpu();
 }
 
diff -puN mm/memblock.c~linux-next-rejects mm/memblock.c
--- a/mm/memblock.c~linux-next-rejects
+++ a/mm/memblock.c
@@ -692,7 +692,7 @@ int __init_memblock memblock_free(phys_a
 		     (void *)_RET_IP_);
 
 	kmemleak_free_part(__va(base), size);
-	return __memblock_remove(&memblock.reserved, base, size);
+	return memblock_remove_range(&memblock.reserved, base, size);
 }
 
 static int __init_memblock memblock_reserve_region(phys_addr_t base,
diff -puN mm/memcontrol.c~linux-next-rejects mm/memcontrol.c
--- a/mm/memcontrol.c~linux-next-rejects
+++ a/mm/memcontrol.c
@@ -4786,10 +4786,11 @@ static int mem_cgroup_force_empty(struct
 	return 0;
 }
 
-static int mem_cgroup_force_empty_write(struct cgroup_subsys_state *css,
-					unsigned int event)
+static ssize_t mem_cgroup_force_empty_write(struct kernfs_open_file *of,
+					    char *buf, size_t nbytes,
+					    loff_t off)
 {
-	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 
 	if (mem_cgroup_is_root(memcg))
 		return -EINVAL;
@@ -4797,7 +4798,7 @@ static int mem_cgroup_force_empty_write(
 		     "removed.  Let us know if it is needed in your usecase at "
 		     "linux-mm@kvack.org\n",
 		     current->comm, task_pid_nr(current));
-	return mem_cgroup_force_empty(memcg);
+	return mem_cgroup_force_empty(memcg) ?: nbytes;
 }
 
 static u64 mem_cgroup_hierarchy_read(struct cgroup_subsys_state *css,
@@ -5084,7 +5085,7 @@ static ssize_t mem_cgroup_write(struct k
 			ret = -EINVAL;
 			break;
 		}
-		ret = res_counter_memparse_write_strategy(buffer, &val);
+		ret = res_counter_memparse_write_strategy(buf, &val);
 		if (ret)
 			break;
 		if (type == _MEM) {
@@ -6013,31 +6014,31 @@ static struct cftype mem_cgroup_files[]
 	{
 		.name = "max_usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_MAX_USAGE),
-		.trigger = mem_cgroup_reset,
+		.write = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read_u64,
 	},
 	{
 		.name = "limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_LIMIT),
-		.write_string = mem_cgroup_write,
+		.write = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read_u64,
 	},
 	{
 		.name = "low_limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_LOW_LIMIT),
-		.write_string = mem_cgroup_write,
+		.write = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read_u64,
 	},
 	{
 		.name = "soft_limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
-		.write_string = mem_cgroup_write,
+		.write = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read_u64,
 	},
 	{
 		.name = "failcnt",
 		.private = MEMFILE_PRIVATE(_MEM, RES_FAILCNT),
-		.trigger = mem_cgroup_reset,
+		.write = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read_u64,
 	},
 	{
@@ -6047,7 +6048,7 @@ static struct cftype mem_cgroup_files[]
 	{
 		.name = "force_empty",
 		.flags = CFTYPE_INSANE,
-		.trigger = mem_cgroup_force_empty_write,
+		.write = mem_cgroup_force_empty_write,
 	},
 	{
 		.name = "use_hierarchy",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
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
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site-checkpatch-fixes.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
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
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
lib-test_bpfc-dont-use-gcc-union-shortcut.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
rwsem-support-optimistic-spinning-checkpatch-fixes.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

