From: akpm@linux-foundation.org
Subject: + vfs-add-__fmode_exec.patch added to -mm tree
Date: Tue, 28 Sep 2010 14:39:46 -0700
Message-ID: <201009282139.o8SLdksB019368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754113Ab0I1Vjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Sep 2010 17:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: sparse: add __FMODE_EXEC
has been added to the -mm tree.  Its filename is
     vfs-add-__fmode_exec.patch

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
@@ -113,7 +113,7 @@ SYSCALL_DEFINE1(uselib, const char __use
 		goto out;
 
 	file = do_filp_open(AT_FDCWD, tmp,
-				O_LARGEFILE | O_RDONLY | FMODE_EXEC, 0,
+				O_LARGEFILE | O_RDONLY | __FMODE_EXEC, 0,
 				MAY_READ | MAY_EXEC | MAY_OPEN);
 	putname(tmp);
 	error = PTR_ERR(file);
@@ -686,7 +686,7 @@ struct file *open_exec(const char *name)
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
@@ -781,7 +781,7 @@ static int __init fcntl_init(void)
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
@@ -2485,6 +2485,7 @@ int proc_nr_files(struct ctl_table *tabl
 
 int __init get_filesystem_list(char *buf);
 
+#define __FMODE_EXEC		((__force int) FMODE_EXEC)
 #define __FMODE_NONOTIFY	((__force int) FMODE_NONOTIFY)
 
 #define ACC_MODE(x) ("\004\002\006\006"[(x)&O_ACCMODE])
_

Patches currently in -mm which might be from namhyung@gmail.com are

linux-next.patch
vfs-remove-a-warning-on-open_fmode.patch
vfs-add-__fmode_exec.patch
mm-cleanup-gfp_zone-fix-sparse-warnings.patch
init-mark-__user-address-space-on-string-literals.patch
kernel-userc-add-lock-release-annotation-on-free_user.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
ptrace-annotate-lock-context-change-on-exit_ptrace.patch
signals-annotate-lock_task_sighand.patch
signals-annotate-lock-context-change-on-ptrace_stop.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch

