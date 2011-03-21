From: akpm@linux-foundation.org
Subject: [merged] introduce-sys_syncfs-to-sync-a-single-file-system-v3.patch removed from -mm tree
Date: Mon, 21 Mar 2011 12:16:36 -0700
Message-ID: <201103211919.p2LJJo4L020230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811Ab1CUTUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Mar 2011 15:20:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sage@newdream.net, arnd@arndb.de, hch@lst.de, jrnieder@gmail.com, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     introduce-sys_syncfs-to-sync-a-single-file-system-v3
has been removed from the -mm tree.  Its filename was
     introduce-sys_syncfs-to-sync-a-single-file-system-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -650,9 +650,11 @@ __SYSCALL(__NR_fanotify_mark, sys_fanoti
 __SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
 #define __NR_open_by_handle_at		265
 __SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
+#define __NR_syncfs 266
+__SYSCALL(__NR_syncfs, sys_syncfs)
 
 #undef __NR_syscalls
-#define __NR_syscalls 266
+#define __NR_syscalls 267
 
 /*
  * All syscalls below here should go away really,
diff -puN include/linux/syscalls.h~introduce-sys_syncfs-to-sync-a-single-file-system-v3 include/linux/syscalls.h
--- a/include/linux/syscalls.h~introduce-sys_syncfs-to-sync-a-single-file-system-v3
+++ a/include/linux/syscalls.h
@@ -825,6 +825,7 @@ asmlinkage long sys_fanotify_init(unsign
 asmlinkage long sys_fanotify_mark(int fanotify_fd, unsigned int flags,
 				  u64 mask, int fd,
 				  const char  __user *pathname);
+asmlinkage long sys_syncfs(int fd);
 
 int kernel_execve(const char *filename, const char *const argv[], const char *const envp[]);
 
_

Patches currently in -mm which might be from sage@newdream.net are

origin.patch
include-asm-generic-unistdh-fix-syncfs-syscall-number.patch

