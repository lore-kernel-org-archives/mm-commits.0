From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 06 Mar 2017 11:49:07 -0800
Message-ID: <58bdbd33.Uk0gWL/rUX8zWJqy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35064 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932508AbdCFTud (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 14:50:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


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

 drivers/scsi/qla2xxx/qla_isr.c |   45 -------------------------------
 fs/f2fs/f2fs.h                 |    5 ---
 2 files changed, 50 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_isr.c~linux-next-git-rejects drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c~linux-next-git-rejects
+++ a/drivers/scsi/qla2xxx/qla_isr.c
@@ -572,7 +572,6 @@ qla2x00_find_fcport_by_loopid(scsi_qla_h
 			return f;
 	return NULL;
 }
-<<<<<<< HEAD
 
 fc_port_t *
 qla2x00_find_fcport_by_wwpn(scsi_qla_host_t *vha, u8 *wwpn, u8 incl_deleted)
@@ -592,27 +591,6 @@ qla2x00_find_fcport_by_wwpn(scsi_qla_hos
 }
 
 fc_port_t *
-=======
-
-fc_port_t *
-qla2x00_find_fcport_by_wwpn(scsi_qla_host_t *vha, u8 *wwpn, u8 incl_deleted)
-{
-	fc_port_t *f, *tf;
-
-	f = tf = NULL;
-	list_for_each_entry_safe(f, tf, &vha->vp_fcports, list) {
-		if (memcmp(f->port_name, wwpn, WWN_SIZE) == 0) {
-			if (incl_deleted)
-				return f;
-			else if (f->deleted == 0)
-				return f;
-		}
-	}
-	return NULL;
-}
-
-fc_port_t *
->>>>>>> linux-next/akpm-base
 qla2x00_find_fcport_by_nportid(scsi_qla_host_t *vha, port_id_t *id,
 	u8 incl_deleted)
 {
@@ -1437,28 +1415,6 @@ qla24xxx_nack_iocb_entry(scsi_qla_host_t
 
 	if (pkt->u.isp2x.status != cpu_to_le16(NOTIFY_ACK_SUCCESS))
 		res = QLA_FUNCTION_FAILED;
-<<<<<<< HEAD
-
-	sp->done(sp, res);
-}
-
-static void
-qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
-    sts_entry_t *pkt, int iocb_type)
-{
-	const char func[] = "CT_IOCB";
-	const char *type;
-	srb_t *sp;
-	struct bsg_job *bsg_job;
-	struct fc_bsg_reply *bsg_reply;
-	uint16_t comp_status;
-	int res = 0;
-
-	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
-	if (!sp)
-		return;
-
-=======
 
 	sp->done(sp, res);
 }
@@ -1479,7 +1435,6 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, s
 	if (!sp)
 		return;
 
->>>>>>> linux-next/akpm-base
 	switch (sp->type) {
 	case SRB_CT_CMD:
 	    bsg_job = sp->u.bsg_job;
diff -puN fs/f2fs/f2fs.h~linux-next-git-rejects fs/f2fs/f2fs.h
--- a/fs/f2fs/f2fs.h~linux-next-git-rejects
+++ a/fs/f2fs/f2fs.h
@@ -2040,13 +2040,8 @@ int f2fs_sync_file(struct file *file, lo
 void truncate_data_blocks(struct dnode_of_data *dn);
 int truncate_blocks(struct inode *inode, u64 from, bool lock);
 int f2fs_truncate(struct inode *inode);
-<<<<<<< HEAD
-int f2fs_getattr(const struct path *path, struct kstat *stat,
-			u32 request_mask, unsigned int flags);
-=======
 int f2fs_getattr(const struct path *path, struct kstat *stat, u32 request_mask,
 		 unsigned int query_flags);
->>>>>>> linux-next/akpm-base
 int f2fs_setattr(struct dentry *dentry, struct iattr *attr);
 int truncate_hole(struct inode *inode, pgoff_t pg_start, pgoff_t pg_end);
 int truncate_data_blocks_range(struct dnode_of_data *dn, int count);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
linux-next-rejects.patch
treewide-move-set_memory_-functions-away-from-cacheflushh-fix.patch
arm64-use-set_memoryh-header-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

