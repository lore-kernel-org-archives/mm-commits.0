From: akpm@linux-foundation.org
Subject: +
 nfs-hangs-in-__ocfs2_cluster_lock-due-to-race-with-ocfs2_unblock_lock.patch added to -mm tree
Date: Tue, 22 Dec 2015 15:00:58 -0800
Message-ID: <5679d62a.TGhxMzELvgjYvjNL%akpm__22322.7571267218$1450825272$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbLVXA7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Dec 2015 18:00:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tariq.x.saeed@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, santosh.shilimkar@oracle.com, stable@vger.kernel.org, wen.gang.wang@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: NFS hangs in __ocfs2_cluster_lock due to race with ocfs2_unblock_lock
has been added to the -mm tree.  Its filename is
     nfs-hangs-in-__ocfs2_cluster_lock-due-to-race-with-ocfs2_unblock_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nfs-hangs-in-__ocfs2_cluster_lock-due-to-race-with-ocfs2_unblock_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nfs-hangs-in-__ocfs2_cluster_lock-due-to-race-with-ocfs2_unblock_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tariq Saeed <tariq.x.saeed@oracle.com>
Subject: ocfs2: NFS hangs in __ocfs2_cluster_lock due to race with ocfs2_unblock_lock

Orabug: 20933419

NFS on a 2 node ocfs2 cluster each node exporting dir.  The lock causing
the hang is the global bit map inode lock.  Node 1 is master, has the lock
granted in PR mode; Node 2 is in the converting list (PR -> EX).  There
are no holders of the lock on the master node so it should downconvert to
NL and grant EX to node 2 but that does not happen.  BLOCKED + QUEUED in
lock res are set and it is on osb blocked list.  Threads are waiting in
__ocfs2_cluster_lock on BLOCKED.  One thread wants EX, rest want PR.  So
it is as though the downconvert thread needs to be kicked to complete the
conv.

The hang is caused by an EX req coming into __ocfs2_cluster_lock on the
heels of a PR req after it sets BUSY (drops l_lock, releasing EX thread),
forcing the incoming EX to wait on BUSY without doing anything.  PR has
called ocfs2_dlm_lock, which sets the node 1 lock from NL -> PR, queues
ast.

At this time, upconvert (PR ->EX) arrives from node 2, finds conflict with
node 1 lock in PR, so the lock res is put on dlm thread's dirty listt.

After ret from ocf2_dlm_lock, PR thread now waits behind EX on BUSY till
awoken by ast.

Now it is dlm_thread that serially runs dlm_shuffle_lists, ast, bast, in
that order.  dlm_shuffle_lists ques a bast on behalf of node 2 (which will
be run by dlm_thread right after the ast).  ast does its part, sets
UPCONVERT_FINISHING, clears BUSY and wakes its waiters.  Next, dlm_thread
runs bast.  It sets BLOCKED and kicks dc thread.  dc thread runs
ocfs2_unblock_lock, but since UPCONVERT_FINISHING set, skips doing
anything and reques.

Inside of __ocfs2_cluster_lock, since EX has been waiting on BUSY ahead of
PR, it wakes up first, finds BLOCKED set and skips doing anything but
clearing UPCONVERT_FINISHING (which was actually "meant" for the PR
thread), and this time waits on BLOCKED.  Next, the PR thread comes out of
wait but since UPCONVERT_FINISHING is not set, it skips updating the
l_ro_holders and goes straight to wait on BLOCKED.  So there, we have a
hang!  Threads in __ocfs2_cluster_lock wait on BLOCKED, lock res in osb
blocked list.  Only when dc thread is awoken, it will run
ocfs2_unblock_lock and things will unhang.

One way to fix this is to wake the dc thread on the flag after clearing
UPCONVERT_FINISHING

Signed-off-by: Tariq Saeed <tariq.x.saeed@oracle.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Reviewed-by: Wengang Wang <wen.gang.wang@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/ocfs2/dlmglue.c~nfs-hangs-in-__ocfs2_cluster_lock-due-to-race-with-ocfs2_unblock_lock fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~nfs-hangs-in-__ocfs2_cluster_lock-due-to-race-with-ocfs2_unblock_lock
+++ a/fs/ocfs2/dlmglue.c
@@ -1390,6 +1390,7 @@ static int __ocfs2_cluster_lock(struct o
 	unsigned int gen;
 	int noqueue_attempted = 0;
 	int dlm_locked = 0;
+	int kick_dc = 0;
 
 	if (!(lockres->l_flags & OCFS2_LOCK_INITIALIZED)) {
 		mlog_errno(-EINVAL);
@@ -1524,7 +1525,12 @@ update_holders:
 unlock:
 	lockres_clear_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
 
+	/* ocfs2_unblock_lock reques on seeing OCFS2_LOCK_UPCONVERT_FINISHING */
+	kick_dc = (lockres->l_flags & OCFS2_LOCK_BLOCKED);
+
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
+	if (kick_dc)
+		ocfs2_wake_downconvert_thread(osb);
 out:
 	/*
 	 * This is helping work around a lock inversion between the page lock
_

Patches currently in -mm which might be from tariq.x.saeed@oracle.com are

nfs-hangs-in-__ocfs2_cluster_lock-due-to-race-with-ocfs2_unblock_lock.patch

