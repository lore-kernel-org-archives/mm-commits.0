Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523C81EA84
	for <mm-commits@vger.kernel.org>; Thu, 24 Apr 2025 22:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745533346; cv=none; b=rDRNcbN5r1U40e9qjvnQYiBfgztaCW7s8OTU0iQxJ3FsJrygCevgci6vvxwNAKR0kTGvWdQVx1lrTcYK+PzqfItHCG/S9bBqDOpFhhrzFUJ7GRDiWfWeSP5cxPbzuRsb0fKazrASzi3p1Bj4iuLuaRQ/p8hZ1cBR/tujZloEYqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745533346; c=relaxed/simple;
	bh=OZ0t+lrqXD7U6IFuX97fidpZR1fr/UrUORSvJEI7oWE=;
	h=Date:To:From:Subject:Message-Id; b=Zyx4ZtnRIwaBwjuHVriNoVhPRd1mShMmNMz7cVhwO8rHuGjES2+sNXuUPP+BHmVFxpAb0hxkG6wv79KlMjJcOoDIhuESLV/GcDwJosHdm3iWTdu2xbf2xUohxjjp6AReXvi0tnkcAdGPswhIE9V+JGeTCvzll/xMrpNIqUOSUdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W8hVIxBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W8hVIxBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7CFC4CEE3;
	Thu, 24 Apr 2025 22:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745533345;
	bh=OZ0t+lrqXD7U6IFuX97fidpZR1fr/UrUORSvJEI7oWE=;
	h=Date:To:From:Subject:From;
	b=W8hVIxBpudy3NFCsDLj1LnQfGqIns7ekd/wWdspSVypTxcRlhvJa7+FCYa5s4QFhv
	 YWaNm1hjZsJaVnkW8xN6JHrtVC0+qzpGdpDBkzQH7AucM7I9yYvOSjtUhfaHgr1LxI
	 Sh15q/qctD2xtI72uT/Hfys0VsNztZ7/FwQWQQek=
Date: Thu, 24 Apr 2025 15:22:24 -0700
To: mm-commits@vger.kernel.org,shi.changkuo@h3c.com,piaojun@huawei.com,m.masimov@mt-integration.ru,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-implement-handshaking-with-ocfs2-recovery-thread.patch added to mm-nonmm-unstable branch
Message-Id: <20250424222225.AA7CFC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: implement handshaking with ocfs2 recovery thread
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-implement-handshaking-with-ocfs2-recovery-thread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-implement-handshaking-with-ocfs2-recovery-thread.patch

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
Subject: ocfs2: implement handshaking with ocfs2 recovery thread
Date: Thu, 24 Apr 2025 15:45:12 +0200

We will need ocfs2 recovery thread to acknowledge transitions of
recovery_state when disabling particular types of recovery.  This is
similar to what currently happens when disabling recovery completely, just
more general.  Implement the handshake and use it for exit from recovery.

Link: https://lkml.kernel.org/r/20250424134515.18933-5-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Tested-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Murad Masimov <m.masimov@mt-integration.ru>
Cc: Shichangkuo <shi.changkuo@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |   52 ++++++++++++++++++++++++++++---------------
 fs/ocfs2/ocfs2.h   |    4 +++
 2 files changed, 39 insertions(+), 17 deletions(-)

--- a/fs/ocfs2/journal.c~ocfs2-implement-handshaking-with-ocfs2-recovery-thread
+++ a/fs/ocfs2/journal.c
@@ -190,31 +190,48 @@ int ocfs2_recovery_init(struct ocfs2_sup
 	return 0;
 }
 
-/* we can't grab the goofy sem lock from inside wait_event, so we use
- * memory barriers to make sure that we'll see the null task before
- * being woken up */
 static int ocfs2_recovery_thread_running(struct ocfs2_super *osb)
 {
-	mb();
 	return osb->recovery_thread_task != NULL;
 }
 
-void ocfs2_recovery_exit(struct ocfs2_super *osb)
+static void ocfs2_recovery_disable(struct ocfs2_super *osb,
+				   enum ocfs2_recovery_state state)
 {
-	struct ocfs2_recovery_map *rm;
-
-	/* disable any new recovery threads and wait for any currently
-	 * running ones to exit. Do this before setting the vol_state. */
 	mutex_lock(&osb->recovery_lock);
-	osb->recovery_state = OCFS2_REC_DISABLED;
+	/*
+	 * If recovery thread is not running, we can directly transition to
+	 * final state.
+	 */
+	if (!ocfs2_recovery_thread_running(osb)) {
+		osb->recovery_state = state + 1;
+		goto out_lock;
+	}
+	osb->recovery_state = state;
+	/* Wait for recovery thread to acknowledge state transition */
+	wait_event_cmd(osb->recovery_event,
+		       !ocfs2_recovery_thread_running(osb) ||
+				osb->recovery_state >= state + 1,
+		       mutex_unlock(&osb->recovery_lock),
+		       mutex_lock(&osb->recovery_lock));
+out_lock:
 	mutex_unlock(&osb->recovery_lock);
-	wait_event(osb->recovery_event, !ocfs2_recovery_thread_running(osb));
 
-	/* At this point, we know that no more recovery threads can be
-	 * launched, so wait for any recovery completion work to
-	 * complete. */
+	/*
+	 * At this point we know that no more recovery work can be queued so
+	 * wait for any recovery completion work to complete.
+	 */
 	if (osb->ocfs2_wq)
 		flush_workqueue(osb->ocfs2_wq);
+}
+
+void ocfs2_recovery_exit(struct ocfs2_super *osb)
+{
+	struct ocfs2_recovery_map *rm;
+
+	/* disable any new recovery threads and wait for any currently
+	 * running ones to exit. Do this before setting the vol_state. */
+	ocfs2_recovery_disable(osb, OCFS2_REC_WANT_DISABLE);
 
 	/*
 	 * Now that recovery is shut down, and the osb is about to be
@@ -1569,7 +1586,8 @@ bail:
 
 	ocfs2_free_replay_slots(osb);
 	osb->recovery_thread_task = NULL;
-	mb(); /* sync with ocfs2_recovery_thread_running */
+	if (osb->recovery_state == OCFS2_REC_WANT_DISABLE)
+		osb->recovery_state = OCFS2_REC_DISABLED;
 	wake_up(&osb->recovery_event);
 
 	mutex_unlock(&osb->recovery_lock);
@@ -1585,13 +1603,13 @@ void ocfs2_recovery_thread(struct ocfs2_
 	int was_set = -1;
 
 	mutex_lock(&osb->recovery_lock);
-	if (osb->recovery_state < OCFS2_REC_DISABLED)
+	if (osb->recovery_state < OCFS2_REC_WANT_DISABLE)
 		was_set = ocfs2_recovery_map_set(osb, node_num);
 
 	trace_ocfs2_recovery_thread(node_num, osb->node_num,
 		osb->recovery_state, osb->recovery_thread_task, was_set);
 
-	if (osb->recovery_state == OCFS2_REC_DISABLED)
+	if (osb->recovery_state >= OCFS2_REC_WANT_DISABLE)
 		goto out;
 
 	if (osb->recovery_thread_task)
--- a/fs/ocfs2/ocfs2.h~ocfs2-implement-handshaking-with-ocfs2-recovery-thread
+++ a/fs/ocfs2/ocfs2.h
@@ -310,6 +310,10 @@ void ocfs2_initialize_journal_triggers(s
 
 enum ocfs2_recovery_state {
 	OCFS2_REC_ENABLED = 0,
+	OCFS2_REC_WANT_DISABLE,
+	/*
+	 * Must be OCFS2_REC_WANT_DISABLE + 1 for ocfs2_recovery_exit() to work
+	 */
 	OCFS2_REC_DISABLED,
 };
 
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-switch-osb-disable_recovery-to-enum.patch
ocfs2-implement-handshaking-with-ocfs2-recovery-thread.patch
ocfs2-stop-quota-recovery-before-disabling-quotas.patch

