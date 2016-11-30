From: akpm@linux-foundation.org
Subject: + autofs-dont-hold-spin-lock-over-direct-mount-expire.patch added to -mm tree
Date: Wed, 30 Nov 2016 14:25:44 -0800
Message-ID: <583f51e8.tlbDcN0SEWiDIOWf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36132 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751631AbcK3W0n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2016 17:26:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, ebiederm@xmission.com, osandov@osandov.com, raven@themaw.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: don't hold spinlock over direct mount expire
has been added to the -mm tree.  Its filename is
     autofs-dont-hold-spin-lock-over-direct-mount-expire.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-dont-hold-spin-lock-over-direct-mount-expire.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-dont-hold-spin-lock-over-direct-mount-expire.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ian Kent <ikent@redhat.com>
Subject: autofs: don't hold spinlock over direct mount expire

Commit 7cbdb4a286 ("autofs: use dentry flags to block walks during
expire") altered the autofs indirect mount expire to not hold a spin lock
during the expire check.

The direct mount expire needs the same treatment because to
make autofs expires namespace aware may_umount_tree() needs to
to use a similar method to may_umount() when checking if a mount
tree is in use.

This means may_umount_tree() will end up taking the namespace_sem
for the check so the autofs direct mount expire won't be allowed
to hold a spin lock over the check.

Link: http://lkml.kernel.org/r/148029913453.27779.15747032937407838983.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/expire.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN fs/autofs4/expire.c~autofs-dont-hold-spin-lock-over-direct-mount-expire fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs-dont-hold-spin-lock-over-direct-mount-expire
+++ a/fs/autofs4/expire.c
@@ -310,26 +310,29 @@ struct dentry *autofs4_expire_direct(str
 	now = jiffies;
 	timeout = sbi->exp_timeout;
 
-	spin_lock(&sbi->fs_lock);
-	ino = autofs4_dentry_ino(root);
-	/* No point expiring a pending mount */
-	if (ino->flags & AUTOFS_INF_PENDING)
-		goto out;
 	if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
+		spin_lock(&sbi->fs_lock);
+		ino = autofs4_dentry_ino(root);
+		/* No point expiring a pending mount */
+		if (ino->flags & AUTOFS_INF_PENDING) {
+			spin_unlock(&sbi->fs_lock);
+			goto out;
+		}
 		ino->flags |= AUTOFS_INF_WANT_EXPIRE;
 		spin_unlock(&sbi->fs_lock);
 		synchronize_rcu();
-		spin_lock(&sbi->fs_lock);
 		if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
+			spin_lock(&sbi->fs_lock);
 			ino->flags |= AUTOFS_INF_EXPIRING;
 			init_completion(&ino->expire_complete);
 			spin_unlock(&sbi->fs_lock);
 			return root;
 		}
+		spin_lock(&sbi->fs_lock);
 		ino->flags &= ~AUTOFS_INF_WANT_EXPIRE;
+		spin_unlock(&sbi->fs_lock);
 	}
 out:
-	spin_unlock(&sbi->fs_lock);
 	dput(root);
 
 	return NULL;
_

Patches currently in -mm which might be from ikent@redhat.com are

vfs-change-d_manage-to-take-a-struct-path.patch
vfs-add-path_is_mountpoint-helper.patch
vfs-add-path_has_submounts.patch
autofs-change-autofs4_expire_wait-to-take-struct-path.patch
autofs-change-autofs4_wait-to-take-struct-path.patch
autofs-use-path_is_mountpoint-to-fix-unreliable-d_mountpoint-checks.patch
autofs-use-path_has_submounts-to-fix-unreliable-have_submount-checks.patch
vfs-remove-unused-have_submounts-function.patch
vfs-merge-path_is_mountpoint-and-path_is_mountpoint_rcu.patch
autofs-make-struct-path-const-in-autofs4_dir_open.patch
autofs-change-struct-path-to-const-in-autofs4_expire_wait-and-autofs4_wait.patch
vfs-change-struct-path-to-const-in-d_manage.patch
vfs-constify-path-parameter-of-path_has_submounts.patch
autofs-dont-hold-spin-lock-over-direct-mount-expire.patch
vfs-make-may_umount_tree-mount-propogation-aware.patch

