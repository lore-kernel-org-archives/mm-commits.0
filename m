From: akpm@linux-foundation.org
Subject: [folded-merged]
 drivers-base-cpuc-fix-maxcpus-boot-option-fix.patch removed from -mm tree
Date: Wed, 12 Jun 2013 13:58:07 -0700
Message-ID: <51b8e0df.I3JIu8RW7F+UgLkp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3FLU6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jun 2013 16:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, youquan.song@intel.com, greg@kroah.com, akpm@linux-foundation.org

Subject: [folded-merged] drivers-base-cpuc-fix-maxcpus-boot-option-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,greg@kroah.com,youquan.song@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 12 Jun 2013 13:58:07 -0700


The patch titled
     Subject: drivers-base-cpuc-fix-maxcpus-boot-option-fix
has been removed from the -mm tree.  Its filename was
     drivers-base-cpuc-fix-maxcpus-boot-option-fix.patch

This patch was dropped because it was folded into drivers-base-cpuc-fix-maxcpus-boot-option.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-base-cpuc-fix-maxcpus-boot-option-fix

fix CONFIG_SMP=n build

Cc: Greg KH <greg@kroah.com>
Cc: Youquan Song <youquan.song@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/cpu.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/base/cpu.c~drivers-base-cpuc-fix-maxcpus-boot-option-fix drivers/base/cpu.c
--- a/drivers/base/cpu.c~drivers-base-cpuc-fix-maxcpus-boot-option-fix
+++ a/drivers/base/cpu.c
@@ -275,9 +275,11 @@ int __cpuinit register_cpu(struct cpu *c
 {
 	int error;
 
+#ifdef CONFIG_SMP
 	/* return when cpu number greater than maximum number of CPUs */
 	if (num >= setup_max_cpus)
 		return 0;
+#endif
 
 	cpu->node_id = cpu_to_node(num);
 	memset(&cpu->dev, 0x00, sizeof(struct device));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch
drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel.patch
drivers-base-cpuc-fix-maxcpus-boot-option.patch
include-linux-math64h-add-div64_ul-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-tune-vm_committed_as-percpu_counter-batching-size-fix.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
rbtree-remove-unneeded-include-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch
wait-introduce-wait_event_commonwq-condition-state-timeout-checkpatch-fixes.patch
wait-introduce-prepare_to_wait_event-checkpatch-fixes.patch
dev-oldmem-remove-the-interface-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fixes.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

