Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82811EA84
	for <mm-commits@vger.kernel.org>; Thu, 24 Apr 2025 22:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745533347; cv=none; b=BKqWBgosAEYSHALURMKxJjcWOOcfb87Kc8u09+8VwPlW5MJOpMQRIek1/GpgAUndcYx0U4UX9wJZUiFFhoDkJEchFgGrkmUoaYlEJm2PsFhIQjoLGHEAI55oYrVsrA+KpUa6QYNlAZ2gQR0o798oFFgh3RVyb0Cz6nQhzQWoZEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745533347; c=relaxed/simple;
	bh=S50/vmvZXDjzVtigyv///JDJyRRJBfdJJqAxr1nFmic=;
	h=Date:To:From:Subject:Message-Id; b=jXNiUu3WWbAt4xLKMC82ULRcKdPEUrO2zxRjk2kMCmdOcRE3Ss+U65MOamwRpZo8i3w0N04EJkIk7/30RhXfG8+8m8Fu1y/Y9Jg13Wx8cXgaF0hj4Gnw7wzJGP1yzZ93GYZQuL7+mfqBSuq6sKSlEUpd4fiyDN6nFIy4n+YfaOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yMu33gih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yMu33gih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BF2C4CEEA;
	Thu, 24 Apr 2025 22:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745533347;
	bh=S50/vmvZXDjzVtigyv///JDJyRRJBfdJJqAxr1nFmic=;
	h=Date:To:From:Subject:From;
	b=yMu33gihUDlYNQLlWLImYxsWt3Sjjly7X3df4+248HhxxvYrUoY/YRnhQETBGpo5K
	 F6ktwk3xH8jxHKuEByCAwuZ3gFuVQjjLDUr4auqafwzM+LwYrzlmo4X0jD7R+Itdba
	 30EmDchmyI5wOicKilLoabgCuLpc5FG7FCeOzsMw=
Date: Thu, 24 Apr 2025 15:22:26 -0700
To: mm-commits@vger.kernel.org,shi.changkuo@h3c.com,piaojun@huawei.com,m.masimov@mt-integration.ru,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-stop-quota-recovery-before-disabling-quotas.patch added to mm-nonmm-unstable branch
Message-Id: <20250424222227.17BF2C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: stop quota recovery before disabling quotas
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-stop-quota-recovery-before-disabling-quotas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-stop-quota-recovery-before-disabling-quotas.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

ocfs2-switch-osb-disable_recovery-to-enum.patch
ocfs2-implement-handshaking-with-ocfs2-recovery-thread.patch
ocfs2-stop-quota-recovery-before-disabling-quotas.patch

