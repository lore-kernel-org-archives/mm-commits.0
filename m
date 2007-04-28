From: akpm@linux-foundation.org
Subject: + utimensat-implementation-update.patch added to -mm tree
Date: Fri, 27 Apr 2007 17:07:54 -0700
Message-ID: <200704280007.l3S07sJa011197@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757934AbXD1AIe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 20:08:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com


The patch titled
     utimensat-implementation update
has been added to the -mm tree.  Its filename is
     utimensat-implementation-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: utimensat-implementation update
From: Ulrich Drepper <drepper@redhat.com>

The completely missing futimensat() functionality is added.  We have such a
function in glibc but we have to resort to using /proc/self/fd/* which not
everybody likes (chroot etc).


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/utimes.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff -puN fs/utimes.c~utimensat-implementation-update fs/utimes.c
--- a/fs/utimes.c~utimensat-implementation-update
+++ a/fs/utimes.c
@@ -1,4 +1,5 @@
 #include <linux/compiler.h>
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/linkage.h>
 #include <linux/namei.h>
@@ -45,18 +46,34 @@ long do_utimes(int dfd, char __user *fil
 {
 	int error;
 	struct nameidata nd;
+	struct dentry *dentry;
 	struct inode *inode;
 	struct iattr newattrs;
+	struct file *f = NULL;
 
 	error = -EINVAL;
 	if (flags & ~AT_SYMLINK_NOFOLLOW)
 		goto out;
 
-	error = __user_walk_fd(dfd, filename, (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW, &nd);
-	if (error)
-		goto out;
+	if (filename == NULL && dfd != AT_FDCWD) {
+		error = -EINVAL;
+		if (flags & AT_SYMLINK_NOFOLLOW)
+			goto out;
+
+		error = -EBADF;
+		f = fget(dfd);
+		if (!f)
+			goto out;
+		dentry = f->f_path.dentry;
+	} else {
+		error = __user_walk_fd(dfd, filename, (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW, &nd);
+		if (error)
+			goto out;
+
+		dentry = nd.dentry;
+	}
 
-	inode = nd.dentry->d_inode;
+	inode = dentry->d_inode;
 
 	error = -EROFS;
 	if (IS_RDONLY(inode))
@@ -94,10 +111,13 @@ long do_utimes(int dfd, char __user *fil
 			goto dput_and_out;
 	}
 	mutex_lock(&inode->i_mutex);
-	error = notify_change(nd.dentry, &newattrs);
+	error = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 dput_and_out:
-	path_release(&nd);
+	if (f)
+		fput(f);
+	else
+		path_release(&nd);
 out:
 	return error;
 }
_

Patches currently in -mm which might be from drepper@redhat.com are

lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
allow-access-to-proc-pid-fd-after-setuid.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
aio-is-unlikely.patch
utimensat-implementation.patch
utimensat-implementation-fix.patch
utimensat-implementation-update.patch
futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix-2.patch
futex_requeue_pi-optimization.patch
