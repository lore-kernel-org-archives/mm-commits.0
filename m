From: akpm@linux-foundation.org
Subject: + devpts-must-release-s_umount-on-error.patch added to -mm tree
Date: Mon, 02 Feb 2009 15:14:37 -0800
Message-ID: <200902022314.n12NEbc5014429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752786AbZBBXPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 18:15:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk, hch@lst.de, hpa@zytor.com, viro@zeniv.linux.org.uk


The patch titled
     devpts: must release s_umount on error
has been added to the -mm tree.  Its filename is
     devpts-must-release-s_umount-on-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devpts: must release s_umount on error
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

We should drop the ->s_umount mutex if an error occurs after the
sget()/grab_super() call. This was introduced when adding support
for multiple instances of devpts and noticed during a code review/reorg.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/devpts/inode.c~devpts-must-release-s_umount-on-error fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-must-release-s_umount-on-error
+++ a/fs/devpts/inode.c
@@ -390,6 +390,7 @@ static int new_pts_mount(struct file_sys
 
 fail:
 	dput(mnt->mnt_sb->s_root);
+	up_write(&mnt->mnt_sb->s_umount);
 	deactivate_super(mnt->mnt_sb);
 	return err;
 }
@@ -478,6 +479,7 @@ static int init_pts_mount(struct file_sy
 	err = mknod_ptmx(mnt->mnt_sb);
 	if (err) {
 		dput(mnt->mnt_sb->s_root);
+		up_write(&mnt->mnt_sb->s_umount);
 		deactivate_super(mnt->mnt_sb);
 	}
 
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are

devpts-must-release-s_umount-on-error.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

