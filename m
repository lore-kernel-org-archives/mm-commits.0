From: akpm@linux-foundation.org
Subject: [merged]
 fs-compat-fix-parameter-handling-for-compat-readv-writev-syscalls.patch
 removed from -mm tree
Date: Thu, 30 Jan 2014 12:05:10 -0800
Message-ID: <52eab076.nazmlMbOOMuptWjS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaA3UFL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 15:05:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, stable@vger.kernel.org, schwidefsky@de.ibm.com, mingo@kernel.org, hpa@zytor.com, brueckner@linux.vnet.ibm.com, heiko.carstens@de.ibm.com

Subject: [merged] fs-compat-fix-parameter-handling-for-compat-readv-writev-syscalls.patch removed from -mm tree
To: heiko.carstens@de.ibm.com,brueckner@linux.vnet.ibm.com,hpa@zytor.com,mingo@kernel.org,schwidefsky@de.ibm.com,stable@vger.kernel.org,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 12:05:10 -0800


The patch titled
     Subject: fs/compat: fix parameter handling for compat readv/writev syscalls
has been removed from the -mm tree.  Its filename was
     fs-compat-fix-parameter-handling-for-compat-readv-writev-syscalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: fs/compat: fix parameter handling for compat readv/writev syscalls

We got a report that the pwritev syscall does not work correctly in compat
mode on s390.

It turned out that with 72ec35163f9f "switch compat readv/writev variants
to COMPAT_SYSCALL_DEFINE" we lost the zero extension of a couple of
syscall parameters because the some parameter types haven't been converted
from unsigned long to compat_ulong_t.

This is needed for architectures where the ABI requires that the caller of
a function performed zero and/or sign extension to 64 bit of all
parameters.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: <stable@vger.kernel.org>	[v3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c        |   16 ++++++++--------
 include/linux/compat.h |   16 ++++++++--------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff -puN fs/read_write.c~fs-compat-fix-parameter-handling-for-compat-readv-writev-syscalls fs/read_write.c
--- a/fs/read_write.c~fs-compat-fix-parameter-handling-for-compat-readv-writev-syscalls
+++ a/fs/read_write.c
@@ -964,9 +964,9 @@ out:
 	return ret;
 }
 
-COMPAT_SYSCALL_DEFINE3(readv, unsigned long, fd,
+COMPAT_SYSCALL_DEFINE3(readv, compat_ulong_t, fd,
 		const struct compat_iovec __user *,vec,
-		unsigned long, vlen)
+		compat_ulong_t, vlen)
 {
 	struct fd f = fdget(fd);
 	ssize_t ret;
@@ -1001,9 +1001,9 @@ COMPAT_SYSCALL_DEFINE4(preadv64, unsigne
 	return ret;
 }
 
-COMPAT_SYSCALL_DEFINE5(preadv, unsigned long, fd,
+COMPAT_SYSCALL_DEFINE5(preadv, compat_ulong_t, fd,
 		const struct compat_iovec __user *,vec,
-		unsigned long, vlen, u32, pos_low, u32, pos_high)
+		compat_ulong_t, vlen, u32, pos_low, u32, pos_high)
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	return compat_sys_preadv64(fd, vec, vlen, pos);
@@ -1031,9 +1031,9 @@ out:
 	return ret;
 }
 
-COMPAT_SYSCALL_DEFINE3(writev, unsigned long, fd,
+COMPAT_SYSCALL_DEFINE3(writev, compat_ulong_t, fd,
 		const struct compat_iovec __user *, vec,
-		unsigned long, vlen)
+		compat_ulong_t, vlen)
 {
 	struct fd f = fdget(fd);
 	ssize_t ret;
@@ -1068,9 +1068,9 @@ COMPAT_SYSCALL_DEFINE4(pwritev64, unsign
 	return ret;
 }
 
-COMPAT_SYSCALL_DEFINE5(pwritev, unsigned long, fd,
+COMPAT_SYSCALL_DEFINE5(pwritev, compat_ulong_t, fd,
 		const struct compat_iovec __user *,vec,
-		unsigned long, vlen, u32, pos_low, u32, pos_high)
+		compat_ulong_t, vlen, u32, pos_low, u32, pos_high)
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	return compat_sys_pwritev64(fd, vec, vlen, pos);
diff -puN include/linux/compat.h~fs-compat-fix-parameter-handling-for-compat-readv-writev-syscalls include/linux/compat.h
--- a/include/linux/compat.h~fs-compat-fix-parameter-handling-for-compat-readv-writev-syscalls
+++ a/include/linux/compat.h
@@ -327,16 +327,16 @@ asmlinkage long compat_sys_keyctl(u32 op
 			      u32 arg2, u32 arg3, u32 arg4, u32 arg5);
 asmlinkage long compat_sys_ustat(unsigned dev, struct compat_ustat __user *u32);
 
-asmlinkage ssize_t compat_sys_readv(unsigned long fd,
-		const struct compat_iovec __user *vec, unsigned long vlen);
-asmlinkage ssize_t compat_sys_writev(unsigned long fd,
-		const struct compat_iovec __user *vec, unsigned long vlen);
-asmlinkage ssize_t compat_sys_preadv(unsigned long fd,
+asmlinkage ssize_t compat_sys_readv(compat_ulong_t fd,
+		const struct compat_iovec __user *vec, compat_ulong_t vlen);
+asmlinkage ssize_t compat_sys_writev(compat_ulong_t fd,
+		const struct compat_iovec __user *vec, compat_ulong_t vlen);
+asmlinkage ssize_t compat_sys_preadv(compat_ulong_t fd,
 		const struct compat_iovec __user *vec,
-		unsigned long vlen, u32 pos_low, u32 pos_high);
-asmlinkage ssize_t compat_sys_pwritev(unsigned long fd,
+		compat_ulong_t vlen, u32 pos_low, u32 pos_high);
+asmlinkage ssize_t compat_sys_pwritev(compat_ulong_t fd,
 		const struct compat_iovec __user *vec,
-		unsigned long vlen, u32 pos_low, u32 pos_high);
+		compat_ulong_t vlen, u32 pos_low, u32 pos_high);
 asmlinkage long comat_sys_lseek(unsigned int, compat_off_t, unsigned int);
 
 asmlinkage long compat_sys_execve(const char __user *filename, const compat_uptr_t __user *argv,
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
linux-next.patch

