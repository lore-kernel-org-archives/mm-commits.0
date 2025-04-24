Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9583F1EA84
	for <mm-commits@vger.kernel.org>; Thu, 24 Apr 2025 22:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745533344; cv=none; b=N9rl7ZY1DL4A3Oi7pxBQesX9657DxD2WbjHhHus0yuevI/SPzBe8GIUDcEaw0kS3xOfr4dRyNmYSZF+VB8PVYyEeGHU9yOchqer3TbSR06MV4I0CnPcbUNW4A2wDQkjv6hGZ+KUX5Smq2cggpdGjaQ3nQ5e3980/kwszCI3HHIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745533344; c=relaxed/simple;
	bh=6+4s3kVFBUiFtqdSVQwI0kcX71WpbUHvdrV3LMYg56I=;
	h=Date:To:From:Subject:Message-Id; b=lRjwo4t3TYm+9W9LChhij+sp1mZ7Uq7HQBuc2LHAdj/4n2gWKbsC54tbq2kuGWiKcO4fR3BXysuTPVWEBZIyHj61L4WcYYcYpYA/+nf/LhjrxA7bdqGhmlj6wKY8HzAfJyxapqon/qpbgSMlFjgcHZHr45fcn/+scXaa+gPwOCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hmY6b6SR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hmY6b6SR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A1CC4CEE3;
	Thu, 24 Apr 2025 22:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745533344;
	bh=6+4s3kVFBUiFtqdSVQwI0kcX71WpbUHvdrV3LMYg56I=;
	h=Date:To:From:Subject:From;
	b=hmY6b6SRHZ80JwXNVfTH5Bg1DftUsx9APjbSC7M5136sN6mX9UCHcbvwiq4KuFrJK
	 FA9lfoE+blB7wU1TPZo90g1EzjTaFCbFr3ohQPi79qsC71znNtWpmuFXgj0k4Qu82/
	 j7vSb+gFCiLSdsLkFaPVc6HGa5SO3CHfZDEtbvpY=
Date: Thu, 24 Apr 2025 15:22:23 -0700
To: mm-commits@vger.kernel.org,shi.changkuo@h3c.com,piaojun@huawei.com,m.masimov@mt-integration.ru,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-switch-osb-disable_recovery-to-enum.patch added to mm-nonmm-unstable branch
Message-Id: <20250424222224.05A1CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: switch osb->disable_recovery to enum
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-switch-osb-disable_recovery-to-enum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-switch-osb-disable_recovery-to-enum.patch

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

ocfs2-switch-osb-disable_recovery-to-enum.patch
ocfs2-implement-handshaking-with-ocfs2-recovery-thread.patch
ocfs2-stop-quota-recovery-before-disabling-quotas.patch

