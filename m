From: akpm@linux-foundation.org
Subject: + procfs-improve-scaling-in-proc-fix.patch added to -mm tree
Date: Tue, 05 Mar 2013 14:34:29 -0800
Message-ID: <20130305223429.6456D5A415F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:60822 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab3CEWea (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 17:34:30 -0500
Received: by mail-vb0-f73.google.com with SMTP id fj18so265302vbb.4
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 14:34:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sasha.levin@oracle.com, nzimmer@sgi.com


The patch titled
     Subject: procfs: missing rcu unlock in proc_reg_release
has been added to the -mm tree.  Its filename is
     procfs-improve-scaling-in-proc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
watchdog-trigger-all-cpu-backtrace-when-locked-up-and-going-to-panic.patch
epoll-support-for-disabling-items-and-a-self-test-app-fix.patch
procfs-improve-scaling-in-proc-fix.patch

