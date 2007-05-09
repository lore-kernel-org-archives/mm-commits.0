From: akpm@linux-foundation.org
Subject: - declare-compat_sys_utimensat.patch removed from -mm tree
Date: Wed, 09 May 2007 14:47:45 -0700
Message-ID: <200705092147.l49LljW9002503@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756477AbXEIVrx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:47:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Declare {compat_}sys_utimensat
has been removed from the -mm tree.  Its filename was
     declare-compat_sys_utimensat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Declare {compat_}sys_utimensat
From: Stephen Rothwell <sfr@canb.auug.org.au>

This is needed before Powerpc can wire up the syscall.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h   |    3 +++
 include/linux/syscalls.h |    2 ++
 2 files changed, 5 insertions(+)

diff -puN include/linux/compat.h~declare-compat_sys_utimensat include/linux/compat.h
--- a/include/linux/compat.h~declare-compat_sys_utimensat
+++ a/include/linux/compat.h
@@ -253,5 +253,8 @@ asmlinkage long compat_sys_epoll_pwait(i
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
early_pfn_to_nid-needs-to-be-__meminit.patch
consolidate-asm-pollh.patch
