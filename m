From: akpm@linux-foundation.org
Subject: [merged] pidns-fix-a-leak-in-proc-dentries-and-inodes-with-pid-namespaces.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:26:32 -0800
Message-ID: <200911131926.nADJQWAm028488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757221AbZKMT1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:27:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@linux.vnet.ibm.com, andrea@cpushare.com, dlezcano@fr.ibm.com, ebiederm@xmission.com, jack@ucw.cz, serue@us.ibm.com, stable@kernel.org, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     pidns: fix a leak in /proc dentries and inodes with pid namespaces.
has been removed from the -mm tree.  Its filename was
     pidns-fix-a-leak-in-proc-dentries-and-inodes-with-pid-namespaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pidns: fix a leak in /proc dentries and inodes with pid namespaces.
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Daniel Lezcano reported a leak in 'struct pid' and 'struct pid_namespace'
that is discussed in:

	http://lkml.org/lkml/2009/10/2/159.

To summarize the thread, when container-init is terminated, it sets the
PF_EXITING flag, zaps other processes in the container and waits to reap
them.  As a part of reaping, the container-init should flush any /proc
dentries associated with the processes.  But because the container-init is
itself exiting and the following PF_EXITING check, the dentries are not
flushed, resulting in leak in /proc inodes and dentries.

This fix reverts the commit 7766755a2f249e7e0 ("Fix /proc dcache deadlock
in do_exit") which introduced the check for PF_EXITING.  At the time of
the commit, shrink_dcache_parent() flushed dentries from other filesystems
also and could have caused a deadlock which the commit fixed.  But as
pointed out by Eric Biederman, after commit 0feae5c47aabdde59,
shrink_dcache_parent() no longer affects other filesystems.  So reverting
the commit is now safe.

As pointed out by Jan Kara, the leak is not as critical since the
unclaimed space will be reclaimed under memory pressure or by:

	echo 3 > /proc/sys/vm/drop_caches

But since this check is no longer required, its best to remove it.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Reported-by: Daniel Lezcano <dlezcano@fr.ibm.com>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Jan Kara <jack@ucw.cz>
Cc: Andrea Arcangeli <andrea@cpushare.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/proc/base.c~pidns-fix-a-leak-in-proc-dentries-and-inodes-with-pid-namespaces fs/proc/base.c
--- a/fs/proc/base.c~pidns-fix-a-leak-in-proc-dentries-and-inodes-with-pid-namespaces
+++ a/fs/proc/base.c
@@ -2597,8 +2597,7 @@ static void proc_flush_task_mnt(struct v
 	name.len = snprintf(buf, sizeof(buf), "%d", pid);
 	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
 	if (dentry) {
-		if (!(current->flags & PF_EXITING))
-			shrink_dcache_parent(dentry);
+		shrink_dcache_parent(dentry);
 		d_drop(dentry);
 		dput(dentry);
 	}
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are


