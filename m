From: akpm@linux-foundation.org
Subject: + declare-compat_sys_utimensat.patch added to -mm tree
Date: Wed, 09 May 2007 00:13:03 -0700
Message-ID: <200705090713.l497D5LL016783@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709AbXEIHNM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 03:13:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au


The patch titled
     Declare {compat_}sys_utimensat
has been added to the -mm tree.  Its filename is
     declare-compat_sys_utimensat.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Declare {compat_}sys_utimensat
From: Stephen Rothwell <sfr@canb.auug.org.au>

This is needed before Powerpc can wire up the syscall.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h   |    3 +++
 include/linux/syscalls.h |    2 ++
 2 files changed, 5 insertions(+)

diff -puN include/linux/compat.h~declare-compat_sys_utimensat include/linux/compat.h
--- a/include/linux/compat.h~declare-compat_sys_utimensat
+++ a/include/linux/compat.h
@@ -258,5 +258,8 @@ asmlinkage long compat_sys_epoll_pwait(i
 			const compat_sigset_t __user *sigmask,
 			compat_size_t sigsetsize);
 
+asmlinkage long compat_sys_utimensat(unsigned int dfd, char __user *filename,
+				struct compat_timespec __user *t, int flags);
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
diff -puN include/linux/syscalls.h~declare-compat_sys_utimensat include/linux/syscalls.h
--- a/include/linux/syscalls.h~declare-compat_sys_utimensat
+++ a/include/linux/syscalls.h
@@ -576,6 +576,8 @@ asmlinkage long sys_fstatat64(int dfd, c
 			       struct stat64 __user *statbuf, int flag);
 asmlinkage long sys_readlinkat(int dfd, const char __user *path, char __user *buf,
 			       int bufsiz);
+asmlinkage long sys_utimensat(int dfd, char __user *filename,
+				struct timespec __user *utimes, int flags);
 asmlinkage long compat_sys_futimesat(unsigned int dfd, char __user *filename,
 				     struct compat_timeval __user *t);
 asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user * filename,
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
declare-compat_sys_utimensat.patch
