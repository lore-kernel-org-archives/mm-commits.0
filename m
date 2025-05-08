Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6693920012B;
	Thu,  8 May 2025 06:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686459; cv=none; b=B5xh+xnef7PZkzjENSeqrI7rFka7LKrGfYM2cFuSdI/QJF838XGzz4p/y/y1uf4aAoK4SxdpBdIJxYvwUmg2HwQicOw3BqeU8XaqSbU3GNEpIb0G4w7oumIW0R40UGFziiICAh+8g5+2T4koS8+gY630YrIdSnTa5/mXd3azJPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686459; c=relaxed/simple;
	bh=MVIj8TzxqnkLLgVAew034q4d86G4PsXKPmtcioSHJog=;
	h=Date:To:From:Subject:Message-Id; b=FyzxTiOb6wwUHjKrh2jZWRCTY0Ms2016aFp4in2tJ22xZU2XM8Azn4npChGBKgpUFWGW0xVepCWbfxypo96IMkxtkrbeEGqoOMs3qTaP5Fua8tR2U+PTzIcTqKaJ61F53sBiBsIQieHpNx3RWDxdxfNog2mm13EokfT0DVa1f+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vkjmlzx4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vkjmlzx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A946C4CEEE;
	Thu,  8 May 2025 06:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686459;
	bh=MVIj8TzxqnkLLgVAew034q4d86G4PsXKPmtcioSHJog=;
	h=Date:To:From:Subject:From;
	b=Vkjmlzx4PQrG8XVKM+Dmq7cjss+A6jhg19v5dR4DlVEqVXmy7t2OhgaPk5zXQNPob
	 0pbqjMB4JGFMuLET4UcYUEc1/2TzPQHlFP1vydpzv2+IwwF03Xnu/B0EXgIxxZui/e
	 Di9oEMElxY0oyL1TjAoZ2QQZeFUmrVr42lz9QXm8=
Date: Wed, 07 May 2025 23:40:58 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shi.changkuo@h3c.com,piaojun@huawei.com,m.masimov@mt-integration.ru,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-stop-quota-recovery-before-disabling-quotas.patch removed from -mm tree
Message-Id: <20250508064059.3A946C4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: stop quota recovery before disabling quotas
has been removed from the -mm tree.  Its filename was
     ocfs2-stop-quota-recovery-before-disabling-quotas.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: stop quota recovery before disabling quotas
Date: Thu, 24 Apr 2025 15:45:13 +0200

Currently quota recovery is synchronized with unmount using sb->s_umount
semaphore.  That is however prone to deadlocks because
flush_workqueue(osb->ocfs2_wq) called from umount code can wait for quota
recovery to complete while ocfs2_finish_quota_recovery() waits for
sb->s_umount semaphore.

Grabbing of sb->s_umount semaphore in ocfs2_finish_quota_recovery() is
only needed to protect that function from disabling of quotas from
ocfs2_dismount_volume().  Handle this problem by disabling quota recovery
early during unmount in ocfs2_dismount_volume() instead so that we can
drop acquisition of sb->s_umount from ocfs2_finish_quota_recovery().

Link: https://lkml.kernel.org/r/20250424134515.18933-6-jack@suse.cz
Fixes: 5f530de63cfc ("ocfs2: Use s_umount for quota recovery protection")
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Shichangkuo <shi.changkuo@h3c.com>
Reported-by: Murad Masimov <m.masimov@mt-integration.ru>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Tested-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c     |   20 ++++++++++++++++++--
 fs/ocfs2/journal.h     |    1 +
 fs/ocfs2/ocfs2.h       |    6 ++++++
 fs/ocfs2/quota_local.c |    9 ++-------
 fs/ocfs2/super.c       |    3 +++
 5 files changed, 30 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/journal.c~ocfs2-stop-quota-recovery-before-disabling-quotas
+++ a/fs/ocfs2/journal.c
@@ -225,6 +225,11 @@ out_lock:
 		flush_workqueue(osb->ocfs2_wq);
 }
 
+void ocfs2_recovery_disable_quota(struct ocfs2_super *osb)
+{
+	ocfs2_recovery_disable(osb, OCFS2_REC_QUOTA_WANT_DISABLE);
+}
+
 void ocfs2_recovery_exit(struct ocfs2_super *osb)
 {
 	struct ocfs2_recovery_map *rm;
@@ -1489,6 +1494,18 @@ static int __ocfs2_recovery_thread(void
 		}
 	}
 restart:
+	if (quota_enabled) {
+		mutex_lock(&osb->recovery_lock);
+		/* Confirm that recovery thread will no longer recover quotas */
+		if (osb->recovery_state == OCFS2_REC_QUOTA_WANT_DISABLE) {
+			osb->recovery_state = OCFS2_REC_QUOTA_DISABLED;
+			wake_up(&osb->recovery_event);
+		}
+		if (osb->recovery_state >= OCFS2_REC_QUOTA_DISABLED)
+			quota_enabled = 0;
+		mutex_unlock(&osb->recovery_lock);
+	}
+
 	status = ocfs2_super_lock(osb, 1);
 	if (status < 0) {
 		mlog_errno(status);
@@ -1592,8 +1609,7 @@ bail:
 
 	mutex_unlock(&osb->recovery_lock);
 
-	if (quota_enabled)
-		kfree(rm_quota);
+	kfree(rm_quota);
 
 	return status;
 }
--- a/fs/ocfs2/journal.h~ocfs2-stop-quota-recovery-before-disabling-quotas
+++ a/fs/ocfs2/journal.h
@@ -148,6 +148,7 @@ void ocfs2_wait_for_recovery(struct ocfs
 
 int ocfs2_recovery_init(struct ocfs2_super *osb);
 void ocfs2_recovery_exit(struct ocfs2_super *osb);
+void ocfs2_recovery_disable_quota(struct ocfs2_super *osb);
 
 int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
 void ocfs2_free_replay_slots(struct ocfs2_super *osb);
--- a/fs/ocfs2/ocfs2.h~ocfs2-stop-quota-recovery-before-disabling-quotas
+++ a/fs/ocfs2/ocfs2.h
@@ -310,6 +310,12 @@ void ocfs2_initialize_journal_triggers(s
 
 enum ocfs2_recovery_state {
 	OCFS2_REC_ENABLED = 0,
+	OCFS2_REC_QUOTA_WANT_DISABLE,
+	/*
+	 * Must be OCFS2_REC_QUOTA_WANT_DISABLE + 1 for
+	 * ocfs2_recovery_disable_quota() to work.
+	 */
+	OCFS2_REC_QUOTA_DISABLED,
 	OCFS2_REC_WANT_DISABLE,
 	/*
 	 * Must be OCFS2_REC_WANT_DISABLE + 1 for ocfs2_recovery_exit() to work
--- a/fs/ocfs2/quota_local.c~ocfs2-stop-quota-recovery-before-disabling-quotas
+++ a/fs/ocfs2/quota_local.c
@@ -453,8 +453,7 @@ out:
 
 /* Sync changes in local quota file into global quota file and
  * reinitialize local quota file.
- * The function expects local quota file to be already locked and
- * s_umount locked in shared mode. */
+ * The function expects local quota file to be already locked. */
 static int ocfs2_recover_local_quota_file(struct inode *lqinode,
 					  int type,
 					  struct ocfs2_quota_recovery *rec)
@@ -588,7 +587,6 @@ int ocfs2_finish_quota_recovery(struct o
 {
 	unsigned int ino[OCFS2_MAXQUOTAS] = { LOCAL_USER_QUOTA_SYSTEM_INODE,
 					      LOCAL_GROUP_QUOTA_SYSTEM_INODE };
-	struct super_block *sb = osb->sb;
 	struct ocfs2_local_disk_dqinfo *ldinfo;
 	struct buffer_head *bh;
 	handle_t *handle;
@@ -600,7 +598,6 @@ int ocfs2_finish_quota_recovery(struct o
 	printk(KERN_NOTICE "ocfs2: Finishing quota recovery on device (%s) for "
 	       "slot %u\n", osb->dev_str, slot_num);
 
-	down_read(&sb->s_umount);
 	for (type = 0; type < OCFS2_MAXQUOTAS; type++) {
 		if (list_empty(&(rec->r_list[type])))
 			continue;
@@ -677,7 +674,6 @@ out_put:
 			break;
 	}
 out:
-	up_read(&sb->s_umount);
 	kfree(rec);
 	return status;
 }
@@ -843,8 +839,7 @@ static int ocfs2_local_free_info(struct
 	ocfs2_release_local_quota_bitmaps(&oinfo->dqi_chunk);
 
 	/*
-	 * s_umount held in exclusive mode protects us against racing with
-	 * recovery thread...
+	 * ocfs2_dismount_volume() has already aborted quota recovery...
 	 */
 	if (oinfo->dqi_rec) {
 		ocfs2_free_quota_recovery(oinfo->dqi_rec);
--- a/fs/ocfs2/super.c~ocfs2-stop-quota-recovery-before-disabling-quotas
+++ a/fs/ocfs2/super.c
@@ -1812,6 +1812,9 @@ static void ocfs2_dismount_volume(struct
 	/* Orphan scan should be stopped as early as possible */
 	ocfs2_orphan_scan_stop(osb);
 
+	/* Stop quota recovery so that we can disable quotas */
+	ocfs2_recovery_disable_quota(osb);
+
 	ocfs2_disable_quotas(osb);
 
 	/* All dquots should be freed by now */
_

Patches currently in -mm which might be from jack@suse.cz are


