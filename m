From: akpm@linux-foundation.org
Subject: + git-block-fixup.patch added to -mm tree
Date: Mon, 30 Jul 2007 11:16:19 -0700
Message-ID: <200707301816.l6UIGJQ2023492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38887 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966127AbXG3SQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 14:16:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com


The patch titled
     git-block-fixup
has been added to the -mm tree.  Its filename is
     git-block-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-block-fixup
From: Andrew Morton <akpm@linux-foundation.org>

fix git-rejects in git-block (badly and wrongly)

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/sim/simscsi.c |   18 ---------
 drivers/scsi/advansys.c    |   67 -----------------------------------
 2 files changed, 85 deletions(-)

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
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
parport_pc-locking-fix.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
kdebugh-forward-declare-struct-struct-notifier_block.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-mark_tsc_unstable-build-fix.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
dma-arch-fix.patch
git-dvb.patch
git-hwmon.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
iforce-warning-fix.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
libata-store-bus-addresses-versus-mm-for-testing-fix.patch
libata-store-bus-addresses-versus-mm-for-testing-fix-2.patch
fix-ide-ide-add-ide-set-pio-take3.patch
ide-bodge-things-around-to-make-arm-work.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
ax88796-printk-fixes.patch
ip_auto_config-fix-fix.patch
fib_trie-cleanup-fix.patch
git-ocfs2.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
aacraid-rename-check_reset.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
git-block-whoops.patch
git-unionfs.patch
git-unionfs-fixup.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
git-watchdog.patch
merge-the-sonics-silicon-backplane-subsystem-fix.patch
revert-x86_64-mm-pci-mmconfig-eax.patch
fix-x86_64-mm-early-quirks-unification.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-kgdb-fixup.patch
git-kgdb-arm-fix.patch
git-kgdb-mips-fix.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
ip2main-warning-fix.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
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
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
tpm_tis-debug.patch
w1-build-fix.patch
