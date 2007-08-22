From: akpm@linux-foundation.org
Subject: - git-block-fixup.patch removed from -mm tree
Date: Wed, 22 Aug 2007 13:12:46 -0700
Message-ID: <200708222012.l7MKCk3d001885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52409 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760179AbXHVUNI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 16:13:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     git-block-fixup
has been removed from the -mm tree.  Its filename was
     git-block-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-block-fixup
From: Andrew Morton <akpm@linux-foundation.org>

fix git-rejects in git-block (badly and wrongly)

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/sim/simscsi.c |   18 ---
 drivers/scsi/advansys.c    |  169 -----------------------------------
 2 files changed, 187 deletions(-)

diff -puN arch/ia64/hp/sim/simscsi.c~git-block-fixup arch/ia64/hp/sim/simscsi.c
--- a/arch/ia64/hp/sim/simscsi.c~git-block-fixup
+++ a/arch/ia64/hp/sim/simscsi.c
@@ -147,11 +147,8 @@ simscsi_sg_readwrite (struct scsi_cmnd *
 			return;
 		}
 		offset +=  sl->length;
-<<<<<<< HEAD/arch/ia64/hp/sim/simscsi.c
-=======
 		sl = sg_next(sl);
 		list_len--;
->>>>>>> /arch/ia64/hp/sim/simscsi.c
 	}
 	sc->result = GOOD;
 }
@@ -210,23 +207,9 @@ simscsi_readwrite10 (struct scsi_cmnd *s
 static void simscsi_fillresult(struct scsi_cmnd *sc, char *buf, unsigned len)
 {
 
-<<<<<<< HEAD/arch/ia64/hp/sim/simscsi.c
-	int i;
-	unsigned thislen;
-	struct scatterlist *slp;
-=======
 	int scatterlen = sc->use_sg, i;
 	struct scatterlist *sg;
->>>>>>> /arch/ia64/hp/sim/simscsi.c
 
-<<<<<<< HEAD/arch/ia64/hp/sim/simscsi.c
-	scsi_for_each_sg(sc, slp, scsi_sg_count(sc), i) {
-		if (!len)
-			break;
-		thislen = min(len, slp->length);
-		memcpy(page_address(slp->page) + slp->offset, buf, thislen);
-		len -= thislen;
-=======
 	if (scatterlen == 0)
 		memcpy(sc->request_buffer, buf, len);
 	else {
@@ -240,7 +223,6 @@ static void simscsi_fillresult(struct sc
 			memcpy(page_address(sg->page) + sg->offset, buf, thislen);
 			len -= thislen;
 		}
->>>>>>> /arch/ia64/hp/sim/simscsi.c
 	}
 }
 
diff -puN drivers/scsi/advansys.c~git-block-fixup drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c~git-block-fixup
+++ a/drivers/scsi/advansys.c
@@ -5217,7 +5217,6 @@ static int asc_build_req(asc_board_t *bo
 		ASC_STATS_ADD(scp->device->host, sg_elem,
 			      asc_sg_head.entry_cnt);
 
-<<<<<<< HEAD/drivers/scsi/advansys.c
 		/*
 		 * Convert scatter-gather list into ASC_SG_HEAD list.
 		 */
@@ -5230,72 +5229,6 @@ static int asc_build_req(asc_board_t *bo
 				      ASC_CEILING(sg_dma_len(slp), 512));
 		}
 	}
-=======
-    /*
-     * Build ASC_SCSI_Q for a contiguous buffer or a scatter-gather
-     * buffer command.
-     */
-    if (scp->use_sg == 0) {
-        /*
-         * CDB request of single contiguous buffer.
-         */
-        ASC_STATS(scp->device->host, cont_cnt);
-	scp->SCp.dma_handle = scp->request_bufflen ?
-	    dma_map_single(dev, scp->request_buffer,
-			   scp->request_bufflen, scp->sc_data_direction) : 0;
-	asc_scsi_q.q1.data_addr = cpu_to_le32(scp->SCp.dma_handle);
-        asc_scsi_q.q1.data_cnt = cpu_to_le32(scp->request_bufflen);
-        ASC_STATS_ADD(scp->device->host, cont_xfer,
-                      ASC_CEILING(scp->request_bufflen, 512));
-        asc_scsi_q.q1.sg_queue_cnt = 0;
-        asc_scsi_q.sg_head = NULL;
-    } else {
-        /*
-         * CDB scatter-gather request list.
-         */
-        int                     sgcnt;
-	int			use_sg;
-        struct scatterlist      *slp, *sg;
-
-	slp = (struct scatterlist *)scp->request_buffer;
-	use_sg = dma_map_sg(dev, slp, scp->use_sg, scp->sc_data_direction);
-
-	if (use_sg > scp->device->host->sg_tablesize) {
-            ASC_PRINT3(
-"asc_build_req: board %d: use_sg %d > sg_tablesize %d\n",
-		boardp->id, use_sg, scp->device->host->sg_tablesize);
-	    dma_unmap_sg(dev, slp, scp->use_sg, scp->sc_data_direction);
-            scp->result = HOST_BYTE(DID_ERROR);
-            asc_enqueue(&boardp->done, scp, ASC_BACK);
-            return ASC_ERROR;
-        }
-
-        ASC_STATS(scp->device->host, sg_cnt);
-
-        /*
-         * Use global ASC_SG_HEAD structure and set the ASC_SCSI_Q
-         * structure to point to it.
-         */
-        memset(&asc_sg_head, 0, sizeof(ASC_SG_HEAD));
-
-        asc_scsi_q.q1.cntl |= QC_SG_HEAD;
-        asc_scsi_q.sg_head = &asc_sg_head;
-        asc_scsi_q.q1.data_cnt = 0;
-        asc_scsi_q.q1.data_addr = 0;
-        /* This is a byte value, otherwise it would need to be swapped. */
-	asc_sg_head.entry_cnt = asc_scsi_q.q1.sg_queue_cnt = use_sg;
-        ASC_STATS_ADD(scp->device->host, sg_elem, asc_sg_head.entry_cnt);
-
-        /*
-         * Convert scatter-gather list into ASC_SG_HEAD list.
-         */
-	scsi_for_each_sg(scp, sg, use_sg, sgcnt) {
-	    asc_sg_head.sg_list[sgcnt].addr = cpu_to_le32(sg_dma_address(sg));
-	    asc_sg_head.sg_list[sgcnt].bytes = cpu_to_le32(sg_dma_len(sg));
-	    ASC_STATS_ADD(scp->device->host, sg_xfer, ASC_CEILING(sg_dma_len(sg), 512));
-        }
-    }
->>>>>>> /drivers/scsi/advansys.c
 
 	ASC_DBG_PRT_ASC_SCSI_Q(2, &asc_scsi_q);
 	ASC_DBG_PRT_CDB(1, scp->cmnd, scp->cmd_len);
@@ -5493,107 +5426,6 @@ static int
 adv_get_sglist(asc_board_t *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
 	       int use_sg)
 {
-<<<<<<< HEAD/drivers/scsi/advansys.c
-	adv_sgblk_t *sgblkp;
-	ADV_SCSI_REQ_Q *scsiqp;
-	struct scatterlist *slp;
-	int sg_elem_cnt;
-	ADV_SG_BLOCK *sg_block, *prev_sg_block;
-	ADV_PADDR sg_block_paddr;
-	int i;
-
-	scsiqp = (ADV_SCSI_REQ_Q *)ADV_32BALIGN(&reqp->scsi_req_q);
-	slp = (struct scatterlist *)scp->request_buffer;
-	sg_elem_cnt = use_sg;
-	prev_sg_block = NULL;
-	reqp->sgblkp = NULL;
-
-	do {
-		/*
-		 * Allocate a 'adv_sgblk_t' structure from the board free
-		 * list. One 'adv_sgblk_t' structure holds NO_OF_SG_PER_BLOCK
-		 * (15) scatter-gather elements.
-		 */
-		if ((sgblkp = boardp->adv_sgblkp) == NULL) {
-			ASC_DBG(1, "adv_get_sglist: no free adv_sgblk_t\n");
-			ASC_STATS(scp->device->host, adv_build_nosg);
-
-			/*
-			 * Allocation failed. Free 'adv_sgblk_t' structures already
-			 * allocated for the request.
-			 */
-			while ((sgblkp = reqp->sgblkp) != NULL) {
-				/* Remove 'sgblkp' from the request list. */
-				reqp->sgblkp = sgblkp->next_sgblkp;
-
-				/* Add 'sgblkp' to the board free list. */
-				sgblkp->next_sgblkp = boardp->adv_sgblkp;
-				boardp->adv_sgblkp = sgblkp;
-			}
-			return ASC_BUSY;
-		} else {
-			/* Complete 'adv_sgblk_t' board allocation. */
-			boardp->adv_sgblkp = sgblkp->next_sgblkp;
-			sgblkp->next_sgblkp = NULL;
-
-			/*
-			 * Get 8 byte aligned virtual and physical addresses for
-			 * the allocated ADV_SG_BLOCK structure.
-			 */
-			sg_block =
-			    (ADV_SG_BLOCK *)ADV_8BALIGN(&sgblkp->sg_block);
-			sg_block_paddr = virt_to_bus(sg_block);
-
-			/*
-			 * Check if this is the first 'adv_sgblk_t' for the request.
-			 */
-			if (reqp->sgblkp == NULL) {
-				/* Request's first scatter-gather block. */
-				reqp->sgblkp = sgblkp;
-
-				/*
-				 * Set ADV_SCSI_REQ_T ADV_SG_BLOCK virtual and physical
-				 * address pointers.
-				 */
-				scsiqp->sg_list_ptr = sg_block;
-				scsiqp->sg_real_addr =
-				    cpu_to_le32(sg_block_paddr);
-			} else {
-				/* Request's second or later scatter-gather block. */
-				sgblkp->next_sgblkp = reqp->sgblkp;
-				reqp->sgblkp = sgblkp;
-
-				/*
-				 * Point the previous ADV_SG_BLOCK structure to
-				 * the newly allocated ADV_SG_BLOCK structure.
-				 */
-				ASC_ASSERT(prev_sg_block != NULL);
-				prev_sg_block->sg_ptr =
-				    cpu_to_le32(sg_block_paddr);
-			}
-		}
-
-		for (i = 0; i < NO_OF_SG_PER_BLOCK; i++) {
-			sg_block->sg_list[i].sg_addr =
-			    cpu_to_le32(sg_dma_address(slp));
-			sg_block->sg_list[i].sg_count =
-			    cpu_to_le32(sg_dma_len(slp));
-			ASC_STATS_ADD(scp->device->host, sg_xfer,
-				      ASC_CEILING(sg_dma_len(slp), 512));
-
-			if (--sg_elem_cnt == 0) {	/* Last ADV_SG_BLOCK and scatter-gather entry. */
-				sg_block->sg_cnt = i + 1;
-				sg_block->sg_ptr = 0L;	/* Last ADV_SG_BLOCK in list. */
-				return ADV_SUCCESS;
-			}
-			slp++;
-		}
-		sg_block->sg_cnt = NO_OF_SG_PER_BLOCK;
-		prev_sg_block = sg_block;
-	}
-	while (1);
-	/* NOTREACHED */
-=======
     adv_sgblk_t         *sgblkp;
     ADV_SCSI_REQ_Q      *scsiqp;
     struct scatterlist  *slp, *sg;
@@ -5692,7 +5524,6 @@ adv_get_sglist(asc_board_t *boardp, adv_
     }
     while (1);
     /* NOTREACHED */
->>>>>>> /drivers/scsi/advansys.c
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
free_irq-fix-debug_shirq-handling.patch
selectionh-add-tty_struct-forward-declaration.patch
newport_con-warning-fix.patch
remove-bdput-from-do_open-in-fs-block_devc-fix.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
fix-2-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
fix-3-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
fix-4-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
revert-gregkh-driver-block-device.patch
git-dma.patch
git-dma-makefile-fix.patch
disable-ioat.patch
git-dvb.patch
git-dvb-fixup-2.patch
infiniband-work-around-gcc-slub-problem.patch
adbhid-produce-all-capslock-key-events.patch
iforce-warning-fix.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
git-kvm.patch
git-libata-all.patch
ide-arm-hack.patch
git-mmc-fixup.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
git-netdev-all.patch
e1000e-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
git-net.patch
git-backlight.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
git-scsi-misc.patch
advansys-printk-fix.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
git-sparc64.patch
git-unionfs.patch
git-unionfs-build-fix.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-watchdog.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
git-wireless-printk-fixes.patch
net-add-ath5k-wireless-driver-fix.patch
ath5k-printk-fix.patch
ath5k-kconfig-fix.patch
ath5k-needs-pci.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
git-xfs.patch
git-kgdb-fixup.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
binfmt_flat-warning-fixes.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
