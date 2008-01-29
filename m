From: akpm@linux-foundation.org
Subject: - hotfix-libata-scsi-corruption.patch removed from -mm tree
Date: Mon, 28 Jan 2008 16:36:55 -0800
Message-ID: <200801290036.m0T0at6b024720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43502 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754100AbYA2AhE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 19:37:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     hotfix libata-scsi corruption
has been removed from the -mm tree.  Its filename was
     hotfix-libata-scsi-corruption.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hotfix libata-scsi corruption
From: Hugh Dickins <hugh@veritas.com>

2.6.24-rc8-mm1 is corrupting.  smartd does some sg_ioctl into its stack,
and depending on how its stack randomization worked out, this is liable
to end up writing into the adjacent physical page too.  If you're lucky
you have highmem, and ioread16_rep oopses on the virtual address beyond
what ata_pio_sector's kmap_atomic set up; when you're unlucky, it'll go
ahead and corrupt the next page more obscurely.

Bisect led to scsi-misc-2.6.git's 465ff3185e0cb76d46137335a4d21d0d9d3ac8a2
[SCSI] relax scsi dma alignment, and the patch below is good for a hot-fix.
Though I doubt it'll be the final fix, since it appears to undo the whole
point of blk_queue_update_dma_alignment: perhaps libata is at fault to be
going through sectory code for unsectory I/O - I wouldn't know.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/libata-scsi.c~hotfix-libata-scsi-corruption drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~hotfix-libata-scsi-corruption
+++ a/drivers/ata/libata-scsi.c
@@ -826,7 +826,7 @@ static void ata_scsi_sdev_config(struct 
 	sdev->max_device_blocked = 1;
 
 	/* set the min alignment */
-	blk_queue_update_dma_alignment(sdev->request_queue, ATA_DMA_PAD_SZ - 1);
+	blk_queue_update_dma_alignment(sdev->request_queue, ATA_SECT_SIZE - 1);
 }
 
 static void ata_scsi_dev_config(struct scsi_device *sdev,
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
hotfix-libata-scsi-corruption.patch
git-unionfs.patch
swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
swapoff-scan-ptes-preemptibly.patch
shmem-factor-out-sbi-free_inodes-manipulations.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch
tmpfs-move-swap_state-stats-update.patch
tmpfs-shuffle-add_to_swap_caches.patch
tmpfs-move-swap-swizzling-into-shmem.patch
tmpfs-allow-filepage-alongside-swappage.patch
tmpfs-allocate-on-read-when-stacked.patch
tmpfs-make-shmem_unuse-more-preemptible.patch
tmpfs-open-a-window-in-shmem_unuse_inode.patch
tmpfs-radix_tree_preloading.patch
tmpfs-fix-shmem_swaplist-races.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
mm-dont-waste-swap-on-locked-pages.patch
skip-writing-data-pages-when-inode-is-under-i_sync.patch
printk-trivial-optimizations-fix.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
prio_tree-debugging-patch.patch
