From: akpm@linux-foundation.org
Subject: + autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch added to -mm tree
Date: Thu, 09 May 2013 11:09:06 -0700
Message-ID: <20130509180906.D3C915A426B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:65464 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3EISJI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 14:09:08 -0400
Received: by mail-ye0-f202.google.com with SMTP id r13so316000yen.5
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 11:09:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miklos@szeredi.hu, ebiederm@xmission.com, mszeredi@suse.cz, oleg@redhat.com, raven@themaw.net, serge.hallyn@canonical.com


The patch titled
     Subject: autofs4: translate pids to the right namespace for the daemon
has been added to the -mm tree.  Its filename is
     autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Ian Kent <raven@themaw.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN fs/autofs4/waitq.c~autofs4-translate-pids-to-the-right-namespace-for-the-daemon fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-translate-pids-to-the-right-namespace-for-the-daemon
+++ a/fs/autofs4/waitq.c
@@ -353,11 +353,23 @@ int autofs4_wait(struct autofs_sb_info *
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
@@ -423,8 +435,8 @@ int autofs4_wait(struct autofs_sb_info *
 		wq->ino = autofs4_get_ino(sbi);
 		wq->uid = current_uid();
 		wq->gid = current_gid();
-		wq->pid = current->pid;
-		wq->tgid = current->tgid;
+		wq->pid = pid;
+		wq->tgid = tgid;
 		wq->status = -EINTR; /* Status return if interrupted */
 		wq->wait_ctr = 2;
 		mutex_unlock(&sbi->wq_mutex);
_

Patches currently in -mm which might be from miklos@szeredi.hu are

autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch

