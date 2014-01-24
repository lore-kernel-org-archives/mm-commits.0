From: akpm@linux-foundation.org
Subject: [merged]
 autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 11:02:18 -0800
Message-ID: <52e2b8ba.tAdAz3/SD+7+5eS4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbaAXTCT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, serge.hallyn@canonical.com, raven@themaw.net, oleg@redhat.com, mszeredi@suse.cz, ebiederm@xmission.com, miklos@szeredi.hu

Subject: [merged] autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch removed from -mm tree
To: miklos@szeredi.hu,ebiederm@xmission.com,mszeredi@suse.cz,oleg@redhat.com,raven@themaw.net,serge.hallyn@canonical.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:18 -0800


The patch titled
     Subject: autofs4: translate pids to the right namespace for the daemon
has been removed from the -mm tree.  Its filename was
     autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miklos Szeredi <miklos@szeredi.hu>
Subject: autofs4: translate pids to the right namespace for the daemon

The PID and the TGID of the process triggering the mount are sent to the
daemon.  Currently the global pid values are sent (ones valid in the
initial pid namespace) but this is wrong if the autofs daemon itself is
not running in the initial pid namespace.

So send the pid values that are valid in the namespace of the autofs daemon.

The namespace to use is taken from the oz_pgrp pid pointer, which was set
at mount time to the mounting process' pid namespace.

If the pid translation fails (the triggering process is in an unrelated
pid namespace) then the automount fails with ENOENT.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Acked-by: Ian Kent <raven@themaw.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN fs/autofs4/waitq.c~autofs4-translate-pids-to-the-right-namespace-for-the-daemon fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-translate-pids-to-the-right-namespace-for-the-daemon
+++ a/fs/autofs4/waitq.c
@@ -347,11 +347,23 @@ int autofs4_wait(struct autofs_sb_info *
 	struct qstr qstr;
 	char *name;
 	int status, ret, type;
+	pid_t pid;
+	pid_t tgid;
 
 	/* In catatonic mode, we don't wait for nobody */
 	if (sbi->catatonic)
 		return -ENOENT;
 
+	/*
+	 * Try translating pids to the namespace of the daemon.
+	 *
+	 * Zero means failure: we are in an unrelated pid namespace.
+	 */
+	pid = task_pid_nr_ns(current, ns_of_pid(sbi->oz_pgrp));
+	tgid = task_tgid_nr_ns(current, ns_of_pid(sbi->oz_pgrp));
+	if (pid == 0 || tgid == 0)
+		return -ENOENT;
+
 	if (!dentry->d_inode) {
 		/*
 		 * A wait for a negative dentry is invalid for certain
@@ -417,8 +429,8 @@ int autofs4_wait(struct autofs_sb_info *
 		wq->ino = autofs4_get_ino(sbi);
 		wq->uid = current_uid();
 		wq->gid = current_gid();
-		wq->pid = current->pid;
-		wq->tgid = current->tgid;
+		wq->pid = pid;
+		wq->tgid = tgid;
 		wq->status = -EINTR; /* Status return if interrupted */
 		wq->wait_ctr = 2;
 
_

Patches currently in -mm which might be from miklos@szeredi.hu are

origin.patch

