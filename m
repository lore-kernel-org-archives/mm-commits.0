From: akpm@linux-foundation.org
Subject: + sys_pipe-fix-file-descriptor-leaks.patch added to -mm tree
Date: Mon, 05 May 2008 19:34:40 -0700
Message-ID: <200805060234.m462Ye26017576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759248AbYEFCfY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 22:35:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drepper@redhat.com, dm.n9107@gmail.com, stable@kernel.org


The patch titled
     sys_pipe(): fix file descriptor leaks
has been added to the -mm tree.  Its filename is
     sys_pipe-fix-file-descriptor-leaks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_pipe(): fix file descriptor leaks
From: Ulrich Drepper <drepper@redhat.com>

Remember to close the files if copy_to_user() failed.

Spotted by dm.n9107@gmail.com.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Cc: DM <dm.n9107@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/kernel/sys_cris.c |    5 ++++-
 arch/m32r/kernel/sys_m32r.c |    5 ++++-
 fs/pipe.c                   |    6 +++++-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff -puN arch/cris/kernel/sys_cris.c~sys_pipe-fix-file-descriptor-leaks arch/cris/kernel/sys_cris.c
--- a/arch/cris/kernel/sys_cris.c~sys_pipe-fix-file-descriptor-leaks
+++ a/arch/cris/kernel/sys_cris.c
@@ -40,8 +40,11 @@ asmlinkage int sys_pipe(unsigned long __
         error = do_pipe(fd);
         unlock_kernel();
         if (!error) {
-                if (copy_to_user(fildes, fd, 2*sizeof(int)))
+                if (copy_to_user(fildes, fd, 2*sizeof(int))) {
+			sys_close(fd[0]);
+			sys_close(fd[1]);
                         error = -EFAULT;
+		}
         }
         return error;
 }
diff -puN arch/m32r/kernel/sys_m32r.c~sys_pipe-fix-file-descriptor-leaks arch/m32r/kernel/sys_m32r.c
--- a/arch/m32r/kernel/sys_m32r.c~sys_pipe-fix-file-descriptor-leaks
+++ a/arch/m32r/kernel/sys_m32r.c
@@ -90,8 +90,11 @@ sys_pipe(unsigned long r0, unsigned long
 
 	error = do_pipe(fd);
 	if (!error) {
-		if (copy_to_user((void __user *)r0, fd, 2*sizeof(int)))
+		if (copy_to_user((void __user *)r0, fd, 2*sizeof(int))) {
+			sys_close(fd[0]);
+			sys_close(fd[1]);
 			error = -EFAULT;
+		}
 	}
 	return error;
 }
diff -puN fs/pipe.c~sys_pipe-fix-file-descriptor-leaks fs/pipe.c
--- a/fs/pipe.c~sys_pipe-fix-file-descriptor-leaks
+++ a/fs/pipe.c
@@ -17,6 +17,7 @@
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
 #include <linux/audit.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
@@ -1086,8 +1087,11 @@ asmlinkage long __weak sys_pipe(int __us
 
 	error = do_pipe(fd);
 	if (!error) {
-		if (copy_to_user(fildes, fd, sizeof(fd)))
+		if (copy_to_user(fildes, fd, sizeof(fd))) {
+			sys_close(fd[0]);
+			sys_close(fd[1]);
 			error = -EFAULT;
+		}
 	}
 	return error;
 }
_

Patches currently in -mm which might be from drepper@redhat.com are

origin.patch
sys_pipe-fix-file-descriptor-leaks.patch
execve-filename-document-and-export-via-auxiliary-vector.patch

