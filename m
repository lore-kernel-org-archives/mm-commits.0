From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 04 Jun 2013 13:02:18 -0700
Message-ID: <51ae47ca.XxdK9pvFczyp8yLt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3FDUCT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jun 2013 16:02:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Jun 2013 13:02:18 -0700


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

 arch/s390/kernel/smp.c  |    5 -----
 drivers/ata/sata_rcar.c |   12 ------------
 kernel/cgroup.c         |    6 ------
 3 files changed, 23 deletions(-)

diff -puN arch/s390/kernel/smp.c~linux-next-git-rejects arch/s390/kernel/smp.c
--- a/arch/s390/kernel/smp.c~linux-next-git-rejects
+++ a/arch/s390/kernel/smp.c
@@ -437,11 +437,6 @@ static void smp_handle_ext_call(void)
 		smp_stop_cpu();
 	if (test_bit(ec_schedule, &bits))
 		scheduler_ipi();
-<<<<<<< HEAD
-	if (test_bit(ec_call_function, &bits))
-		generic_smp_call_function_interrupt();
-=======
->>>>>>> linux-next/akpm-base
 	if (test_bit(ec_call_function_single, &bits))
 		generic_smp_call_function_single_interrupt();
 }
diff -puN drivers/ata/sata_rcar.c~linux-next-git-rejects drivers/ata/sata_rcar.c
--- a/drivers/ata/sata_rcar.c~linux-next-git-rejects
+++ a/drivers/ata/sata_rcar.c
@@ -544,11 +544,7 @@ static void sata_rcar_bmdma_start(struct
 	u32 dmactl;
 
 	/* start host DMA transaction */
-<<<<<<< HEAD
-	dmactl = ioread32(priv->base + ATAPI_CONTROL1_REG);
-=======
 	dmactl = ioread32(base + ATAPI_CONTROL1_REG);
->>>>>>> linux-next/akpm-base
 	dmactl &= ~ATAPI_CONTROL1_STOP;
 	dmactl |= ATAPI_CONTROL1_START;
 	iowrite32(dmactl, base + ATAPI_CONTROL1_REG);
@@ -684,20 +680,12 @@ static irqreturn_t sata_rcar_interrupt(i
 
 	spin_lock_irqsave(&host->lock, flags);
 
-<<<<<<< HEAD
-	sataintstat = ioread32(priv->base + SATAINTSTAT_REG);
-=======
 	sataintstat = ioread32(base + SATAINTSTAT_REG);
->>>>>>> linux-next/akpm-base
 	sataintstat &= SATA_RCAR_INT_MASK;
 	if (!sataintstat)
 		goto done;
 	/* ack */
-<<<<<<< HEAD
-	iowrite32(~sataintstat & 0x7ff, priv->base + SATAINTSTAT_REG);
-=======
 	iowrite32(~sataintstat & 0x7ff, base + SATAINTSTAT_REG);
->>>>>>> linux-next/akpm-base
 
 	ap = host->ports[0];
 
diff -puN kernel/cgroup.c~linux-next-git-rejects kernel/cgroup.c
--- a/kernel/cgroup.c~linux-next-git-rejects
+++ a/kernel/cgroup.c
@@ -3058,14 +3058,8 @@ struct cgroup *cgroup_next_descendant_pr
 
 	/* no child, visit my or the closest ancestor's next sibling */
 	while (pos != cgroup) {
-<<<<<<< HEAD
-		next = list_entry_rcu(pos->sibling.next, struct cgroup,
-				      sibling);
-		if (&next->sibling != &pos->parent->children)
-=======
 		next = cgroup_next_sibling(pos);
 		if (next)
->>>>>>> linux-next/akpm-base
 			return next;
 		pos = pos->parent;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
drivers-rtc-rtc-cmosc-fix-accidentally-enabling-rtc-channel-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix.patch
mm-correctly-update-zone-managed_pages-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
rbtree-remove-unneeded-include-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch
dev-oldmem-remove-the-interface-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

