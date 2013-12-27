From: akpm@linux-foundation.org
Subject: + autofs-fix-symlinks-arent-checked-for-expiry.patch added to -mm tree
Date: Fri, 27 Dec 2013 14:02:34 -0800
Message-ID: <52bdf8fa.TH0tYuuM9vYj9XfZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab3L0WCf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Dec 2013 17:02:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ikent@redhat.com

Subject: + autofs-fix-symlinks-arent-checked-for-expiry.patch added to -mm tree
To: ikent@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 27 Dec 2013 14:02:34 -0800


The patch titled
     Subject: autofs: fix symlinks aren't checked for expiry
has been added to the -mm tree.  Its filename is
     autofs-fix-symlinks-arent-checked-for-expiry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-fix-symlinks-arent-checked-for-expiry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-fix-symlinks-arent-checked-for-expiry.patch

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
Subject: autofs: fix symlinks aren't checked for expiry

The autofs4 module doesn't consider symlinks for expire as it did in the
older autofs v3 module (so it's actually a long stnding regression).

The user space daemon has focused on the use of bind mounts instead of
symlinks for a long time now and that's why this has not been noticed. 
But with the future addition of amd map parsing to automount(8), not to
mention amd itself (of am-utils), symlink expiry will be needed.

The direct and offset mount types can't be symlinks and the tree mounts of
version 4 were always real mounts so only indirect mounts need expire
symlinks.

Since the current users of the autofs4 module haven't reproted this as a
problem to date this patch probably isn't a candidate for backport to
stable.

Signed-off-by: Ian Kent <ikent@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/expire.c  |   14 ++++++++++++++
 fs/autofs4/symlink.c |    4 ++++
 2 files changed, 18 insertions(+)

diff -puN fs/autofs4/expire.c~autofs-fix-symlinks-arent-checked-for-expiry fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs-fix-symlinks-arent-checked-for-expiry
+++ a/fs/autofs4/expire.c
@@ -402,6 +402,20 @@ struct dentry *autofs4_expire_indirect(s
 			goto next;
 		}
 
+		if (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)) {
+			DPRINTK("checking symlink %p %.*s",
+				dentry, (int)dentry->d_name.len, dentry->d_name.name);
+			/*
+			 * A symlink can't be "busy" in the usual sense so
+			 * just check last used for expire timeout.
+			 */
+			if (autofs4_can_expire(dentry, timeout, do_now)) {
+				expired = dentry;
+				goto found;
+			}
+			goto next;
+		}
+
 		if (simple_empty(dentry))
 			goto next;
 
diff -puN fs/autofs4/symlink.c~autofs-fix-symlinks-arent-checked-for-expiry fs/autofs4/symlink.c
--- a/fs/autofs4/symlink.c~autofs-fix-symlinks-arent-checked-for-expiry
+++ a/fs/autofs4/symlink.c
@@ -14,6 +14,10 @@
 
 static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino && !autofs4_oz_mode(sbi))
+		ino->last_used = jiffies;
 	nd_set_link(nd, dentry->d_inode->i_private);
 	return NULL;
 }
_

Patches currently in -mm which might be from ikent@redhat.com are

autofs-fix-symlinks-arent-checked-for-expiry.patch

