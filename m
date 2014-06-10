From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 10 Jun 2014 12:48:15 -0700
Message-ID: <539760ff.iL23D5n2slImNRwU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaFJTsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 15:48:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-git-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 12:48:15 -0700


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                       |    3 ---
 drivers/scsi/qla2xxx/qla_target.c |   20 --------------------
 drivers/scsi/virtio_scsi.c        |    8 --------
 fs/cifs/inode.c                   |    4 ----
 fs/f2fs/data.c                    |    5 -----
 fs/f2fs/file.c                    |    7 -------
 6 files changed, 47 deletions(-)

diff -puN MAINTAINERS~linux-next-git-rejects MAINTAINERS
--- a/MAINTAINERS~linux-next-git-rejects
+++ a/MAINTAINERS
@@ -4421,7 +4421,6 @@ F:	drivers/net/ethernet/ibm/ibmveth.*
 
 IBM Power Virtual SCSI Device Drivers
 M:	Nathan Fontenot <nfont@linux.vnet.ibm.com>
-<<<<<<< HEAD
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/ibmvscsi/ibmvscsi*
@@ -4431,7 +4430,6 @@ IBM Power Virtual FC Device Drivers
 M:	Brian King <brking@linux.vnet.ibm.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
-=======
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/ibmvscsi/ibmvscsi*
@@ -4441,7 +4439,6 @@ IBM Power Virtual FC Device Drivers
 M:	Brian King <brking@linux.vnet.ibm.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
->>>>>>> linux-next/akpm-base
 F:	drivers/scsi/ibmvscsi/ibmvfc*
 
 IBM ServeRAID RAID DRIVER
diff -puN drivers/scsi/qla2xxx/qla_target.c~linux-next-git-rejects drivers/scsi/qla2xxx/qla_target.c
--- a/drivers/scsi/qla2xxx/qla_target.c~linux-next-git-rejects
+++ a/drivers/scsi/qla2xxx/qla_target.c
@@ -1996,11 +1996,7 @@ qlt_set_t10dif_tags(struct se_cmd *se_cm
 	 * have been immplemented by TCM, before AppTag is avail.
 	 * Look for modesense_handlers[]
 	 */
-<<<<<<< HEAD
-	ctx->app_tag = __constant_cpu_to_le16(0);
-=======
 	ctx->app_tag = 0;
->>>>>>> linux-next/akpm-base
 	ctx->app_tag_mask[0] = 0x0;
 	ctx->app_tag_mask[1] = 0x0;
 
@@ -2082,10 +2078,7 @@ qlt_build_ctio_crc2_pkt(struct qla_tgt_p
 	struct se_cmd		*se_cmd = &cmd->se_cmd;
 	uint32_t h;
 	struct atio_from_isp *atio = &prm->cmd->atio;
-<<<<<<< HEAD
-=======
 	uint16_t t16;
->>>>>>> linux-next/akpm-base
 
 	sgc = 0;
 	ha = vha->hw;
@@ -2182,10 +2175,6 @@ qlt_build_ctio_crc2_pkt(struct qla_tgt_p
 	pkt->initiator_id[1] = atio->u.isp24.fcp_hdr.s_id[1];
 	pkt->initiator_id[2] = atio->u.isp24.fcp_hdr.s_id[0];
 	pkt->exchange_addr   = atio->u.isp24.exchange_addr;
-<<<<<<< HEAD
-	pkt->ox_id  = swab16(atio->u.isp24.fcp_hdr.ox_id);
-	pkt->flags |= (atio->u.isp24.attr << 9);
-=======
 
 	/* silence compile warning */
 	t16 = be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id);
@@ -2193,7 +2182,6 @@ qlt_build_ctio_crc2_pkt(struct qla_tgt_p
 
 	t16 = (atio->u.isp24.attr << 9);
 	pkt->flags |= cpu_to_le16(t16);
->>>>>>> linux-next/akpm-base
 	pkt->relative_offset = cpu_to_le32(prm->cmd->offset);
 
 	/* Set transfer direction */
@@ -2268,12 +2256,7 @@ qlt_build_ctio_crc2_pkt(struct qla_tgt_p
 
 	if (bundling && prm->prot_seg_cnt) {
 		/* Walks dif segments */
-<<<<<<< HEAD
-		pkt->add_flags |=
-			__constant_cpu_to_le16(CTIO_CRC2_AF_DIF_DSD_ENA);
-=======
 		pkt->add_flags |= CTIO_CRC2_AF_DIF_DSD_ENA;
->>>>>>> linux-next/akpm-base
 
 		cur_dsd = (uint32_t *) &crc_ctx_pkt->u.bundling.dif_address;
 		if (qla24xx_walk_and_build_prot_sglist(ha, NULL, cur_dsd,
@@ -2726,11 +2709,8 @@ done:
 
 void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 {
-<<<<<<< HEAD
-=======
 	struct qla_tgt_sess *sess = cmd->sess;
 
->>>>>>> linux-next/akpm-base
 	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe074,
 	    "%s: se_cmd[%p] ox_id %04x\n",
 	    __func__, &cmd->se_cmd,
diff -puN drivers/scsi/virtio_scsi.c~linux-next-git-rejects drivers/scsi/virtio_scsi.c
--- a/drivers/scsi/virtio_scsi.c~linux-next-git-rejects
+++ a/drivers/scsi/virtio_scsi.c
@@ -498,10 +498,7 @@ static int virtscsi_queuecommand(struct
 				 struct virtio_scsi_vq *req_vq,
 				 struct scsi_cmnd *sc)
 {
-<<<<<<< HEAD
-=======
 	int req_size;
->>>>>>> linux-next/akpm-base
 	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
 	struct virtio_scsi_cmd *cmd = scsi_cmd_priv(sc);
 
@@ -518,10 +515,6 @@ static int virtscsi_queuecommand(struct
 
 	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
 
-<<<<<<< HEAD
-	if (virtscsi_kick_cmd(req_vq, cmd,
-			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
-=======
 	if (virtio_has_feature(vscsi->vdev, VIRTIO_SCSI_F_T10_PI)) {
 		virtio_scsi_init_hdr_pi(&cmd->req.cmd_pi, sc);
 		memcpy(cmd->req.cmd_pi.cdb, sc->cmnd, sc->cmd_len);
@@ -533,7 +526,6 @@ static int virtscsi_queuecommand(struct
 	}
 
 	if (virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd),
->>>>>>> linux-next/akpm-base
 			      GFP_ATOMIC) != 0)
 		return SCSI_MLQUEUE_HOST_BUSY;
 	return 0;
diff -puN fs/cifs/inode.c~linux-next-git-rejects fs/cifs/inode.c
--- a/fs/cifs/inode.c~linux-next-git-rejects
+++ a/fs/cifs/inode.c
@@ -1806,11 +1806,7 @@ cifs_revalidate_mapping(struct inode *in
 	}
 
 	clear_bit_unlock(CIFS_INO_LOCK, flags);
-<<<<<<< HEAD
-	smp_mb__after_atomic();
-=======
 	smp_mb__after_clear_bit();
->>>>>>> linux-next/akpm-base
 	wake_up_bit(flags, CIFS_INO_LOCK);
 
 	return rc;
diff -puN fs/f2fs/data.c~linux-next-git-rejects fs/f2fs/data.c
--- a/fs/f2fs/data.c~linux-next-git-rejects
+++ a/fs/f2fs/data.c
@@ -1049,13 +1049,8 @@ static ssize_t f2fs_direct_IO(int rw, st
 	/* clear fsync mark to recover these blocks */
 	fsync_mark_clear(F2FS_SB(inode->i_sb), inode->i_ino);
 
-<<<<<<< HEAD
-	return blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-							get_data_block);
-=======
 	return blockdev_direct_IO(rw, iocb, inode, iter, offset,
 				  get_data_block);
->>>>>>> linux-next/akpm-base
 }
 
 static void f2fs_invalidate_data_page(struct page *page, unsigned int offset,
diff -puN fs/f2fs/file.c~linux-next-git-rejects fs/f2fs/file.c
--- a/fs/f2fs/file.c~linux-next-git-rejects
+++ a/fs/f2fs/file.c
@@ -808,17 +808,10 @@ long f2fs_compat_ioctl(struct file *file
 
 const struct file_operations f2fs_file_operations = {
 	.llseek		= f2fs_llseek,
-<<<<<<< HEAD
-	.read		= do_sync_read,
-	.write		= do_sync_write,
-	.aio_read	= generic_file_aio_read,
-	.aio_write	= generic_file_aio_write,
-=======
 	.read		= new_sync_read,
 	.write		= new_sync_write,
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
->>>>>>> linux-next/akpm-base
 	.open		= generic_file_open,
 	.mmap		= f2fs_file_mmap,
 	.fsync		= f2fs_sync_file,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch

