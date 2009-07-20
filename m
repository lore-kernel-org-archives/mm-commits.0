From: akpm@linux-foundation.org
Subject: [nacked] sys_pipe-fix-fd-leak-if-pipe-is-called-with-an-invalid-address.patch removed from -mm tree
Date: Mon, 20 Jul 2009 14:06:34 -0700
Message-ID: <200907202106.n6KL6ZK2014660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693AbZGTVGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jul 2009 17:06:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaosuo@gmail.com, chris@zankel.net, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sys_pipe(): fix fd leak if pipe() is called with an invalid address
has been removed from the -mm tree.  Its filename was
     sys_pipe-fix-fd-leak-if-pipe-is-called-with-an-invalid-address.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_pipe(): fix fd leak if pipe() is called with an invalid address
From: Changli Gao <xiaosuo@gmail.com>

fd leak if pipe() is called with an invalid address.

Though -EFAULT is returned, the file descriptors opened by pipe() call are
left open.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/sys_ia32.c     |    5 ++++-
 arch/xtensa/kernel/syscall.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN arch/x86/ia32/sys_ia32.c~sys_pipe-fix-fd-leak-if-pipe-is-called-with-an-invalid-address arch/x86/ia32/sys_ia32.c
--- a/arch/x86/ia32/sys_ia32.c~sys_pipe-fix-fd-leak-if-pipe-is-called-with-an-invalid-address
+++ a/arch/x86/ia32/sys_ia32.c
@@ -197,8 +197,11 @@ asmlinkage long sys32_pipe(int __user *f
 	retval = do_pipe_flags(fds, 0);
 	if (retval)
 		goto out;
-	if (copy_to_user(fd, fds, sizeof(fds)))
+	if (copy_to_user(fd, fds, sizeof(fds))) {
+		sys_close(fd[0]);
+		sys_close(fd[1]);
 		retval = -EFAULT;
+	}
 out:
 	return retval;
 }
diff -puN arch/xtensa/kernel/syscall.c~sys_pipe-fix-fd-leak-if-pipe-is-called-with-an-invalid-address arch/xtensa/kernel/syscall.c
--- a/arch/xtensa/kernel/syscall.c~sys_pipe-fix-fd-leak-if-pipe-is-called-with-an-invalid-address
+++ a/arch/xtensa/kernel/syscall.c
@@ -51,8 +51,11 @@ asmlinkage long xtensa_pipe(int __user *
 
 	error = do_pipe_flags(fd, 0);
 	if (!error) {
-		if (copy_to_user(userfds, fd, 2 * sizeof(int)))
+		if (copy_to_user(userfds, fd, 2 * sizeof(int))) {
+			sys_close(fd[0]);
+			sys_close(fd[1]);
 			error = -EFAULT;
+		}
 	}
 	return error;
 }
_

Patches currently in -mm which might be from xiaosuo@gmail.com are

sys_pipe-fix-fd-leak-if-pipe-is-called-with-an-invalid-address.patch
linux-next.patch

