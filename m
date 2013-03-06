From: akpm@linux-foundation.org
Subject: [alternative-merged] procfs-improve-scaling-in-proc-fix.patch removed from -mm tree
Date: Tue, 05 Mar 2013 16:01:52 -0800
Message-ID: <20130306000153.269295A415F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:55697 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab3CFABy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 19:01:54 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so803830yen.3
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 16:01:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, nzimmer@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: missing rcu unlock in proc_reg_release
has been removed from the -mm tree.  Its filename was
     procfs-improve-scaling-in-proc-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: procfs: missing rcu unlock in proc_reg_release

Commit "procfs: improve scaling in proc" forgot to unlock rcu read lock
if the proc file didn't have ops struct.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/inode.c~procfs-improve-scaling-in-proc-fix fs/proc/inode.c
--- a/fs/proc/inode.c~procfs-improve-scaling-in-proc-fix
+++ a/fs/proc/inode.c
@@ -400,6 +400,7 @@ static int proc_reg_release(struct inode
 	rcu_read_lock();
 	fops = rcu_dereference(pde->proc_fops);
 	if (!fops) {
+		rcu_read_unlock();
 		/*
 		 * Can't simply exit, __fput() will think that everything is OK,
 		 * and move on to freeing struct file. remove_proc_entry() will
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

linux-next.patch
mm-mempolicyc-fix-wrong-sp_node-insertion.patch
mm-mempolicyc-fix-sp_node_init-argument-ordering.patch
revert-parts-of-hlist-drop-the-node-parameter-from-iterators.patch
watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch
epoll-support-for-disabling-items-and-a-self-test-app-fix.patch

