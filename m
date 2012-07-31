From: akpm@linux-foundation.org
Subject: [merged] ipc-add-compat_shmlba-support.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:54:06 -0700
Message-ID: <20120731185406.C6BDB100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab2GaSyI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:54:08 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:54:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, arnd@arndb.de, catalin.marinas@arm.com, chris@zankel.net, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: add COMPAT_SHMLBA support
has been removed from the -mm tree.  Its filename was
     ipc-add-compat_shmlba-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: ipc: add COMPAT_SHMLBA support

If the SHMLBA definition for a native task differs from the definition for
a compat task, the do_shmat() function would need to handle both.

This patch introduces COMPAT_SHMLBA, which is used by the compat shmat
syscall when calling the ipc code and allows architectures such as AArch64
(where the native SHMLBA is 64k but the compat (AArch32) definition is
16k) to provide the correct semantics for compat IPC system calls.

Cc: David S. Miller <davem@davemloft.net>
Cc: Chris Zankel <chris@zankel.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/sys_sparc_64.c |    2 +-
 arch/xtensa/kernel/syscall.c     |    2 +-
 include/linux/shm.h              |    6 ++++--
 ipc/compat.c                     |    8 ++++++--
 ipc/shm.c                        |    9 +++++----
 ipc/syscall.c                    |    2 +-
 6 files changed, 18 insertions(+), 11 deletions(-)

diff -puN arch/sparc/kernel/sys_sparc_64.c~ipc-add-compat_shmlba-support arch/sparc/kernel/sys_sparc_64.c
--- a/arch/sparc/kernel/sys_sparc_64.c~ipc-add-compat_shmlba-support
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -470,7 +470,7 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int,
 		switch (call) {
 		case SHMAT: {
 			ulong raddr;
-			err = do_shmat(first, ptr, (int)second, &raddr);
+			err = do_shmat(first, ptr, (int)second, &raddr, SHMLBA);
 			if (!err) {
 				if (put_user(raddr,
 					     (ulong __user *) third))
diff -puN arch/xtensa/kernel/syscall.c~ipc-add-compat_shmlba-support arch/xtensa/kernel/syscall.c
--- a/arch/xtensa/kernel/syscall.c~ipc-add-compat_shmlba-support
+++ a/arch/xtensa/kernel/syscall.c
@@ -44,7 +44,7 @@ asmlinkage long xtensa_shmat(int shmid, 
 	unsigned long ret;
 	long err;
 
-	err = do_shmat(shmid, shmaddr, shmflg, &ret);
+	err = do_shmat(shmid, shmaddr, shmflg, &ret, SHMLBA);
 	if (err)
 		return err;
 	return (long)ret;
diff -puN include/linux/shm.h~ipc-add-compat_shmlba-support include/linux/shm.h
--- a/include/linux/shm.h~ipc-add-compat_shmlba-support
+++ a/include/linux/shm.h
@@ -107,12 +107,14 @@ struct shmid_kernel /* private to the ke
 #define SHM_NORESERVE   010000  /* don't check for reservations */
 
 #ifdef CONFIG_SYSVIPC
-long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr);
+long do_shmat(int shmid, char __user *shmaddr, int shmflg, unsigned long *addr,
+	      unsigned long shmlba);
 extern int is_file_shm_hugepages(struct file *file);
 extern void exit_shm(struct task_struct *task);
 #else
 static inline long do_shmat(int shmid, char __user *shmaddr,
-				int shmflg, unsigned long *addr)
+			    int shmflg, unsigned long *addr,
+			    unsigned long shmlba)
 {
 	return -ENOSYS;
 }
diff -puN ipc/compat.c~ipc-add-compat_shmlba-support ipc/compat.c
--- a/ipc/compat.c~ipc-add-compat_shmlba-support
+++ a/ipc/compat.c
@@ -514,6 +514,10 @@ long compat_sys_msgctl(int first, int se
 	return err;
 }
 
+#ifndef COMPAT_SHMLBA
+#define COMPAT_SHMLBA	SHMLBA
+#endif
+
 #ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
 long compat_sys_shmat(int first, int second, compat_uptr_t third, int version,
 			void __user *uptr)
@@ -524,7 +528,7 @@ long compat_sys_shmat(int first, int sec
 
 	if (version == 1)
 		return -EINVAL;
-	err = do_shmat(first, uptr, second, &raddr);
+	err = do_shmat(first, uptr, second, &raddr, COMPAT_SHMLBA);
 	if (err < 0)
 		return err;
 	uaddr = compat_ptr(third);
@@ -536,7 +540,7 @@ long compat_sys_shmat(int shmid, compat_
 	unsigned long ret;
 	long err;
 
-	err = do_shmat(shmid, compat_ptr(shmaddr), shmflg, &ret);
+	err = do_shmat(shmid, compat_ptr(shmaddr), shmflg, &ret, COMPAT_SHMLBA);
 	if (err)
 		return err;
 	force_successful_syscall_return();
diff -puN ipc/shm.c~ipc-add-compat_shmlba-support ipc/shm.c
--- a/ipc/shm.c~ipc-add-compat_shmlba-support
+++ a/ipc/shm.c
@@ -953,7 +953,8 @@ out:
  * "raddr" thing points to kernel space, and there has to be a wrapper around
  * this.
  */
-long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
+long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
+	      unsigned long shmlba)
 {
 	struct shmid_kernel *shp;
 	unsigned long addr;
@@ -973,9 +974,9 @@ long do_shmat(int shmid, char __user *sh
 	if (shmid < 0)
 		goto out;
 	else if ((addr = (ulong)shmaddr)) {
-		if (addr & (SHMLBA-1)) {
+		if (addr & (shmlba - 1)) {
 			if (shmflg & SHM_RND)
-				addr &= ~(SHMLBA-1);	   /* round down */
+				addr &= ~(shmlba - 1);	   /* round down */
 			else
 #ifndef __ARCH_FORCE_SHMLBA
 				if (addr & ~PAGE_MASK)
@@ -1107,7 +1108,7 @@ SYSCALL_DEFINE3(shmat, int, shmid, char 
 	unsigned long ret;
 	long err;
 
-	err = do_shmat(shmid, shmaddr, shmflg, &ret);
+	err = do_shmat(shmid, shmaddr, shmflg, &ret, SHMLBA);
 	if (err)
 		return err;
 	force_successful_syscall_return();
diff -puN ipc/syscall.c~ipc-add-compat_shmlba-support ipc/syscall.c
--- a/ipc/syscall.c~ipc-add-compat_shmlba-support
+++ a/ipc/syscall.c
@@ -73,7 +73,7 @@ SYSCALL_DEFINE6(ipc, unsigned int, call,
 		default: {
 			unsigned long raddr;
 			ret = do_shmat(first, (char __user *)ptr,
-				       second, &raddr);
+				       second, &raddr, SHMLBA);
 			if (ret)
 				return ret;
 			return put_user(raddr, (unsigned long __user *) third);
_

Patches currently in -mm which might be from will.deacon@arm.com are

origin.patch
linux-next.patch

