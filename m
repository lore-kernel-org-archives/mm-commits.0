From: akpm@linux-foundation.org
Subject: + vfs-allow-file-truncations-when-both-suid-and-write-permissions-set.patch added to -mm tree
Date: Thu, 20 Aug 2009 14:35:15 -0700
Message-ID: <200908202135.n7KLZGI7031011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751068AbZHTVgA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 17:36:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, eparis@redhat.com, esandeen@redhat.com, eteo@redhat.com, hch@lst.de, hirofumi@mail.parknet.co.jp, viro@zeniv.linux.org.uk


The patch titled
     vfs: allow file truncations when both suid and write permissions set
has been added to the -mm tree.  Its filename is
     vfs-allow-file-truncations-when-both-suid-and-write-permissions-set.patch

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
Subject: vfs: allow file truncations when both suid and write permissions set
From: Amerigo Wang <amwang@redhat.com>

When suid is set and the non-owner user has write permission, any writing
into this file should be allowed and suid should be removed after that.

However, current kernel only allows writing without truncations, when we
do truncations on that file, we get EPERM.  This is a bug.

Steps to reproduce this bug:

% ls -l rootdir/file1
-rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
% echo h > rootdir/file1
zsh: operation not permitted: rootdir/file1
% ls -l rootdir/file1
-rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
% echo h >> rootdir/file1
% ls -l rootdir/file1
-rwxrwxrwx 1 root root 5 Jun 25 16:34 rootdir/file1

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Eric Sandeen <esandeen@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Eugene Teo <eteo@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/open.c~vfs-allow-file-truncations-when-both-suid-and-write-permissions-set fs/open.c
--- a/fs/open.c~vfs-allow-file-truncations-when-both-suid-and-write-permissions-set
+++ a/fs/open.c
@@ -199,7 +199,7 @@ out:
 int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 	struct file *filp)
 {
-	int err;
+	int ret;
 	struct iattr newattrs;
 
 	/* Not pretty: "inode->i_size" shouldn't really be signed. But it is. */
@@ -214,12 +214,14 @@ int do_truncate(struct dentry *dentry, l
 	}
 
 	/* Remove suid/sgid on truncate too */
-	newattrs.ia_valid |= should_remove_suid(dentry);
+	ret = should_remove_suid(dentry);
+	if (ret)
+		newattrs.ia_valid |= ret | ATTR_FORCE;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	err = notify_change(dentry, &newattrs);
+	ret = notify_change(dentry, &newattrs);
 	mutex_unlock(&dentry->d_inode->i_mutex);
-	return err;
+	return ret;
 }
 
 static long do_sys_truncate(const char __user *pathname, loff_t length)
_

Patches currently in -mm which might be from amwang@redhat.com are

origin.patch
linux-next.patch
selinux-adjust-rules-for-attr_force.patch
vfs-allow-file-truncations-when-both-suid-and-write-permissions-set.patch
xtensa-use-generic-sys_pipe.patch
kcore-fix-proc-kcores-statst_size.patch
elf-clean-up-fill_note_info.patch
elf-clean-up-fill_note_info-fix.patch

