From: akpm@linux-foundation.org
Subject: - lutimesat-simplify-utime2.patch removed from -mm tree
Date: Fri, 27 Apr 2007 14:08:14 -0700
Message-ID: <200704272108.l3RL8E3I007791@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757299AbXD0VI0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 17:08:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@openvz.org, ak@suse.de, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     lutimesat: simplify utime(2)
has been removed from the -mm tree.  Its filename was
     lutimesat-simplify-utime2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: lutimesat: simplify utime(2)
From: Alexey Dobriyan <adobriyan@openvz.org>

Rewrite via do_utimes() like compat_sys_utime().

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/utimes.c |   50 +++++++-------------------------------------------
 1 file changed, 7 insertions(+), 43 deletions(-)

diff -puN fs/utimes.c~lutimesat-simplify-utime2 fs/utimes.c
--- a/fs/utimes.c~lutimesat-simplify-utime2
+++ a/fs/utimes.c
@@ -22,52 +22,16 @@
  */
 asmlinkage long sys_utime(char __user * filename, struct utimbuf __user * times)
 {
-	int error;
-	struct nameidata nd;
-	struct inode * inode;
-	struct iattr newattrs;
+	struct timeval tv[2];
 
-	error = user_path_walk(filename, &nd);
-	if (error)
-		goto out;
-	inode = nd.dentry->d_inode;
-
-	error = -EROFS;
-	if (IS_RDONLY(inode))
-		goto dput_and_out;
-
-	/* Don't worry, the checks are done in inode_change_ok() */
-	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
 	if (times) {
-		error = -EPERM;
-		if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
-			goto dput_and_out;
-
-		error = get_user(newattrs.ia_atime.tv_sec, &times->actime);
-		newattrs.ia_atime.tv_nsec = 0;
-		if (!error)
-			error = get_user(newattrs.ia_mtime.tv_sec, &times->modtime);
-		newattrs.ia_mtime.tv_nsec = 0;
-		if (error)
-			goto dput_and_out;
-
-		newattrs.ia_valid |= ATTR_ATIME_SET | ATTR_MTIME_SET;
-	} else {
-                error = -EACCES;
-                if (IS_IMMUTABLE(inode))
-                        goto dput_and_out;
-
-		if (current->fsuid != inode->i_uid &&
-		    (error = vfs_permission(&nd, MAY_WRITE)) != 0)
-			goto dput_and_out;
+		if (get_user(tv[0].tv_sec, &times->actime) ||
+		    get_user(tv[1].tv_sec, &times->modtime))
+			return -EFAULT;
+		tv[0].tv_usec = 0;
+		tv[1].tv_usec = 0;
 	}
-	mutex_lock(&inode->i_mutex);
-	error = notify_change(nd.dentry, &newattrs);
-	mutex_unlock(&inode->i_mutex);
-dput_and_out:
-	path_release(&nd);
-out:
-	return error;
+	return do_utimes(AT_FDCWD, filename, times ? tv : NULL);
 }
 
 #endif
_

Patches currently in -mm which might be from adobriyan@openvz.org are

git-parisc.patch
allow-access-to-proc-pid-fd-after-setuid.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
utimensat-implementation.patch
lutimesat-simplify-utime2.patch
lutimesat-extend-do_utimes-with-flags.patch
lutimesat-actual-syscall-and-wire-up-on-i386.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
