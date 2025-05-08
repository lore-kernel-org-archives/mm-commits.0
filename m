Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116942192E6;
	Thu,  8 May 2025 06:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686457; cv=none; b=k0epVyp/XY7pdCDR1NMT45eHkBDrMaumFxY42ERPxUoBKkfmyd31IK8/QmtXi5MCKQrpX2muDE4PNT4PkLGIvHJeJga1wR8RDzQ8a13bcAqi6VTMV215okG9g6Vj6MTS9ue0H9xkQQjW2xRau4GsKuTAibW1nrSgxteVu2hqnq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686457; c=relaxed/simple;
	bh=9F4er+LAE/rznm9dWpO8LxemrB2gdQAxyZ81HNNg8iY=;
	h=Date:To:From:Subject:Message-Id; b=i43RBf5+ASXzT1XJPWINY9vDnwxHKEOi5DwD8xd6azMToJlALo6K+4gQMA7G9axZ7fFdCds81nS4N3Jzc3uf/GMPMaRV+hbJ8hdAjPWQ1wLc6WG2T4nTQ7MKZS4lrSI/TvunxWMxd8klflpgem4k7/JzIGpVSpIOhGl3x3iUqws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nfvohwmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nfvohwmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C5FC4CEEB;
	Thu,  8 May 2025 06:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686456;
	bh=9F4er+LAE/rznm9dWpO8LxemrB2gdQAxyZ81HNNg8iY=;
	h=Date:To:From:Subject:From;
	b=nfvohwmRgM5woQNmRKdMXadQ66t/Y/cKjlNYyg0md6AZr8rqnRrtlBAn8K8uFsVjz
	 kxmL2JNFd8zJ/liv0Ypg47GypTU3LUyZ9+Thh4Aum6E1PaLUaTy8SQ2+1lt9Z1RIOJ
	 OniIksotIn11fmzrnb3nBNrTOkXIisIRrZkUmAQY=
Date: Wed, 07 May 2025 23:40:56 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shi.changkuo@h3c.com,piaojun@huawei.com,m.masimov@mt-integration.ru,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-switch-osb-disable_recovery-to-enum.patch removed from -mm tree
Message-Id: <20250508064056.C1C5FC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: switch osb->disable_recovery to enum
has been removed from the -mm tree.  Its filename was
     ocfs2-switch-osb-disable_recovery-to-enum.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: switch osb->disable_recovery to enum
Date: Thu, 24 Apr 2025 15:45:11 +0200

Patch series "ocfs2: Fix deadlocks in quota recovery", v3.

This implements another approach to fixing quota recovery deadlocks.  We
avoid grabbing sb->s_umount semaphore from ocfs2_finish_quota_recovery()
and instead stop quota recovery early in ocfs2_dismount_volume().


This patch (of 3):

We will need more recovery states than just pure enable / disable to fix
deadlocks with quota recovery.  Switch osb->disable_recovery to enum.

Link: https://lkml.kernel.org/r/20250424134301.1392-1-jack@suse.cz
Link: https://lkml.kernel.org/r/20250424134515.18933-4-jack@suse.cz
Fixes: 5f530de63cfc ("ocfs2: Use s_umount for quota recovery protection")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Tested-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Murad Masimov <m.masimov@mt-integration.ru>
Cc: Shichangkuo <shi.changkuo@h3c.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |   14 ++++++++------
 fs/ocfs2/ocfs2.h   |    7 ++++++-
 2 files changed, 14 insertions(+), 7 deletions(-)

--- a/fs/ocfs2/journal.c~ocfs2-switch-osb-disable_recovery-to-enum
+++ a/fs/ocfs2/journal.c
@@ -174,7 +174,7 @@ int ocfs2_recovery_init(struct ocfs2_sup
 	struct ocfs2_recovery_map *rm;
 
 	mutex_init(&osb->recovery_lock);
-	osb->disable_recovery = 0;
+	osb->recovery_state = OCFS2_REC_ENABLED;
 	osb->recovery_thread_task = NULL;
 	init_waitqueue_head(&osb->recovery_event);
 
@@ -206,7 +206,7 @@ void ocfs2_recovery_exit(struct ocfs2_su
 	/* disable any new recovery threads and wait for any currently
 	 * running ones to exit. Do this before setting the vol_state. */
 	mutex_lock(&osb->recovery_lock);
-	osb->disable_recovery = 1;
+	osb->recovery_state = OCFS2_REC_DISABLED;
 	mutex_unlock(&osb->recovery_lock);
 	wait_event(osb->recovery_event, !ocfs2_recovery_thread_running(osb));
 
@@ -1582,14 +1582,16 @@ bail:
 
 void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
 {
+	int was_set = -1;
+
 	mutex_lock(&osb->recovery_lock);
+	if (osb->recovery_state < OCFS2_REC_DISABLED)
+		was_set = ocfs2_recovery_map_set(osb, node_num);
 
 	trace_ocfs2_recovery_thread(node_num, osb->node_num,
-		osb->disable_recovery, osb->recovery_thread_task,
-		osb->disable_recovery ?
-		-1 : ocfs2_recovery_map_set(osb, node_num));
+		osb->recovery_state, osb->recovery_thread_task, was_set);
 
-	if (osb->disable_recovery)
+	if (osb->recovery_state == OCFS2_REC_DISABLED)
 		goto out;
 
 	if (osb->recovery_thread_task)
--- a/fs/ocfs2/ocfs2.h~ocfs2-switch-osb-disable_recovery-to-enum
+++ a/fs/ocfs2/ocfs2.h
@@ -308,6 +308,11 @@ enum ocfs2_journal_trigger_type {
 void ocfs2_initialize_journal_triggers(struct super_block *sb,
 				       struct ocfs2_triggers triggers[]);
 
+enum ocfs2_recovery_state {
+	OCFS2_REC_ENABLED = 0,
+	OCFS2_REC_DISABLED,
+};
+
 struct ocfs2_journal;
 struct ocfs2_slot_info;
 struct ocfs2_recovery_map;
@@ -370,7 +375,7 @@ struct ocfs2_super
 	struct ocfs2_recovery_map *recovery_map;
 	struct ocfs2_replay_map *replay_map;
 	struct task_struct *recovery_thread_task;
-	int disable_recovery;
+	enum ocfs2_recovery_state recovery_state;
 	wait_queue_head_t checkpoint_event;
 	struct ocfs2_journal *journal;
 	unsigned long osb_commit_interval;
_

Patches currently in -mm which might be from jack@suse.cz are


