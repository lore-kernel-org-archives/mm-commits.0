From: akpm@linux-foundation.org
Subject: [merged] vfs-add-__fmode_exec.patch removed from -mm tree
Date: Thu, 03 Feb 2011 11:46:32 -0800
Message-ID: <201102031946.p13JkWpK021020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756726Ab1BCTqg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 14:46:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: sparse: add __FMODE_EXEC
has been removed from the -mm tree.  Its filename was
     vfs-add-__fmode_exec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: sparse: add __FMODE_EXEC
From: Namhyung Kim <namhyung@gmail.com>

FMODE_EXEC is a constant type of fmode_t but was used with normal integer
constants.  This results in following warnings from sparse.  Fix it using
new macro __FMODE_EXEC.

 fs/exec.c:116:58: warning: restricted fmode_t degrades to integer
 fs/exec.c:689:58: warning: restricted fmode_t degrades to integer
 fs/fcntl.c:777:9: warning: restricted fmode_t degrades to integer

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |    4 ++--
 fs/fcntl.c         |    2 +-
 include/linux/fs.h |    1 +
 3 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/exec.c~vfs-add-__fmode_exec fs/exec.c
--- a/fs/exec.c~vfs-add-__fmode_exec
+++ a/fs/exec.c
@@ -120,7 +120,7 @@ SYSCALL_DEFINE1(uselib, const char __use
 		goto out;
 
 	file = do_filp_open(AT_FDCWD, tmp,
-				O_LARGEFILE | O_RDONLY | FMODE_EXEC, 0,
+				O_LARGEFILE | O_RDONLY | __FMODE_EXEC, 0,
 				MAY_READ | MAY_EXEC | MAY_OPEN);
 	putname(tmp);
 	error = PTR_ERR(file);
@@ -723,7 +723,7 @@ struct file *open_exec(const char *name)
 	int err;
 
 	file = do_filp_open(AT_FDCWD, name,
-				O_LARGEFILE | O_RDONLY | FMODE_EXEC, 0,
+				O_LARGEFILE | O_RDONLY | __FMODE_EXEC, 0,
 				MAY_EXEC | MAY_OPEN);
 	if (IS_ERR(file))
 		goto out;
diff -puN fs/fcntl.c~vfs-add-__fmode_exec fs/fcntl.c
--- a/fs/fcntl.c~vfs-add-__fmode_exec
+++ a/fs/fcntl.c
@@ -815,7 +815,7 @@ static int __init fcntl_init(void)
 		__O_SYNC	| O_DSYNC	| FASYNC	|
 		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
 		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
-		FMODE_EXEC
+		__FMODE_EXEC
 		));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
diff -puN include/linux/fs.h~vfs-add-__fmode_exec include/linux/fs.h
--- a/include/linux/fs.h~vfs-add-__fmode_exec
+++ a/include/linux/fs.h
@@ -2555,6 +2555,7 @@ int proc_nr_inodes(struct ctl_table *tab
 		   void __user *buffer, size_t *lenp, loff_t *ppos);
 int __init get_filesystem_list(char *buf);
 
+#define __FMODE_EXEC		((__force int) FMODE_EXEC)
 #define __FMODE_NONOTIFY	((__force int) FMODE_NONOTIFY)
 
 #define ACC_MODE(x) ("\004\002\006\006"[(x)&O_ACCMODE])
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
linux-next.patch
select-remove-unused-max_select_seconds.patch

