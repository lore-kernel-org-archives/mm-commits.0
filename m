From: akpm@linux-foundation.org
Subject: + introduce-sys_syncfs-to-sync-a-single-file-system-v3.patch added to -mm tree
Date: Thu, 10 Mar 2011 14:13:53 -0800
Message-ID: <201103102213.p2AMDsJI031632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158Ab1CJWOF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Mar 2011 17:14:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sage@newdream.net, arnd@arndb.de, hch@lst.de, jrnieder@gmail.com, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     introduce-sys_syncfs-to-sync-a-single-file-system-v3
has been added to the -mm tree.  Its filename is
     introduce-sys_syncfs-to-sync-a-single-file-system-v3.patch

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
Subject: introduce-sys_syncfs-to-sync-a-single-file-system-v3
From: Sage Weil <sage@newdream.net>

Signed-off-by: Sage Weil <sage@newdream.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Jonathan Nieder <jrnieder@gmail.com
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/unistd.h |    4 +++-
 include/linux/syscalls.h     |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/unistd.h~introduce-sys_syncfs-to-sync-a-single-file-system-v3 include/asm-generic/unistd.h
--- a/include/asm-generic/unistd.h~introduce-sys_syncfs-to-sync-a-single-file-system-v3
+++ a/include/asm-generic/unistd.h
@@ -646,9 +646,11 @@ __SYSCALL(__NR_prlimit64, sys_prlimit64)
 __SYSCALL(__NR_fanotify_init, sys_fanotify_init)
 #define __NR_fanotify_mark 263
 __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
+#define __NR_syncfs 264
+__SYSCALL(__NR_syncfs, sys_syncfs)
 
 #undef __NR_syscalls
-#define __NR_syscalls 264
+#define __NR_syscalls 265
 
 /*
  * All syscalls below here should go away really,
diff -puN include/linux/syscalls.h~introduce-sys_syncfs-to-sync-a-single-file-system-v3 include/linux/syscalls.h
--- a/include/linux/syscalls.h~introduce-sys_syncfs-to-sync-a-single-file-system-v3
+++ a/include/linux/syscalls.h
@@ -824,6 +824,7 @@ asmlinkage long sys_fanotify_init(unsign
 asmlinkage long sys_fanotify_mark(int fanotify_fd, unsigned int flags,
 				  u64 mask, int fd,
 				  const char  __user *pathname);
+asmlinkage long sys_syncfs(int fd);
 
 int kernel_execve(const char *filename, const char *const argv[], const char *const envp[]);
 
_

Patches currently in -mm which might be from sage@newdream.net are

introduce-sys_syncfs-to-sync-a-single-file-system.patch
introduce-sys_syncfs-to-sync-a-single-file-system-v3.patch

