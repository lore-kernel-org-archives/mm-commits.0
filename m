From: akpm@linux-foundation.org
Subject: [merged] add-generic-sys_ipc-wrapper.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:55:31 -0400
Message-ID: <201003150656.o2F6u5Od016183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935031Ab0COG66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, arnd@arndb.de, benh@kernel.crashing.org, dhowells@redhat.com, heiko.carstens@de.ibm.com, hpa@zytor.com, jdike@addtoit.com, jesper.nilsson@axis.com, jmorris@namei.org, kyle


The patch titled
     Add generic sys_ipc wrapper
has been removed from the -mm tree.  Its filename was
     add-generic-sys_ipc-wrapper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add generic sys_ipc wrapper
From: Christoph Hellwig <hch@lst.de>

Add a generic implementation of the ipc demultiplexer syscall.  Except for
s390 and sparc64 all implementations of the sys_ipc are nearly identical.

There are slight differences in the types of the parameters, where mips
and powerpc as the only 64-bit architectures with sys_ipc use unsigned
long for the "third" argument as it gets casted to a pointer later, while
it traditionally is an "int" like most other paramters.  frv goes even
further and uses unsigned long for all parameters execept for "ptr" which
is a pointer type everywhere.  The change from int to unsigned long for
"third" and back to "int" for the others on frv should be fine due to the
in-register calling conventions for syscalls (we already had a similar
issue with the generic sys_ptrace), but I'd prefer to have the arch
maintainers looks over this in details.

Except for that h8300, m68k and m68knommu lack an impplementation of the
semtimedop sub call which this patch adds, and various architectures have
gets used - at least on i386 it seems superflous as the compat code on
x86-64 and ia64 doesn't even bother to implement it.

[akpm@linux-foundation.org: add sys_ipc to sys_ni.c]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/unistd.h       |    1 
 arch/arm/kernel/sys_arm.c           |   82 ------------------
 arch/arm/kernel/sys_oabi-compat.c   |    3 
 arch/cris/include/asm/unistd.h      |    1 
 arch/cris/kernel/sys_cris.c         |   78 -----------------
 arch/frv/include/asm/unistd.h       |    1 
 arch/frv/kernel/sys_frv.c           |   89 --------------------
 arch/h8300/include/asm/unistd.h     |    1 
 arch/h8300/kernel/sys_h8300.c       |   88 --------------------
 arch/m32r/include/asm/unistd.h      |    1 
 arch/m32r/kernel/sys_m32r.c         |   81 ------------------
 arch/m68k/include/asm/unistd.h      |    1 
 arch/m68k/kernel/sys_m68k.c         |   81 ------------------
 arch/m68knommu/kernel/sys_m68k.c    |   86 -------------------
 arch/mips/include/asm/unistd.h      |    1 
 arch/mips/kernel/syscall.c          |   88 --------------------
 arch/mn10300/include/asm/unistd.h   |    1 
 arch/mn10300/kernel/sys_mn10300.c   |   88 --------------------
 arch/powerpc/include/asm/syscalls.h |    2 
 arch/powerpc/include/asm/unistd.h   |    1 
 arch/powerpc/kernel/syscalls.c      |   94 ---------------------
 arch/s390/kernel/entry.h            |    2 
 arch/s390/kernel/sys_s390.c         |    2 
 arch/s390/kernel/syscalls.S         |    2 
 arch/sh/include/asm/syscalls.h      |    2 
 arch/sh/include/asm/unistd_32.h     |    1 
 arch/sh/include/asm/unistd_64.h     |    1 
 arch/sh/kernel/sys_sh.c             |  104 -----------------------
 arch/sparc/include/asm/unistd.h     |    4 
 arch/sparc/kernel/sys_sparc_32.c    |  113 --------------------------
 arch/sparc/kernel/sys_sparc_64.c    |    2 
 arch/sparc/kernel/systbls.h         |    2 
 arch/sparc/kernel/systbls_64.S      |    2 
 arch/um/sys-i386/syscalls.c         |   86 -------------------
 arch/x86/include/asm/syscalls.h     |    1 
 arch/x86/include/asm/unistd_32.h    |    1 
 arch/x86/kernel/sys_i386_32.c       |   85 -------------------
 include/linux/syscalls.h            |    2 
 ipc/Makefile                        |    2 
 ipc/syscall.c                       |   99 ++++++++++++++++++++++
 kernel/sys_ni.c                     |    1 
 41 files changed, 124 insertions(+), 1259 deletions(-)

diff -puN arch/arm/include/asm/unistd.h~add-generic-sys_ipc-wrapper arch/arm/include/asm/unistd.h
--- a/arch/arm/include/asm/unistd.h~add-generic-sys_ipc-wrapper
+++ a/arch/arm/include/asm/unistd.h
@@ -448,6 +448,7 @@
 
 #if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
 #define __ARCH_WANT_SYS_TIME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_OLDUMOUNT
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_UTIME
diff -puN arch/arm/kernel/sys_arm.c~add-generic-sys_ipc-wrapper arch/arm/kernel/sys_arm.c
--- a/arch/arm/kernel/sys_arm.c~add-generic-sys_ipc-wrapper
+++ a/arch/arm/kernel/sys_arm.c
@@ -28,88 +28,6 @@
 #include <linux/ipc.h>
 #include <linux/uaccess.h>
 
-#if !defined(CONFIG_AEABI) || defined(CONFIG_OABI_COMPAT)
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage int sys_ipc(uint call, int first, int second, int third,
-		       void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	switch (call) {
-	case SEMOP:
-		return sys_semtimedop (first, (struct sembuf __user *)ptr, second, NULL);
-	case SEMTIMEDOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr, second,
-					(const struct timespec __user *)fifth);
-
-	case SEMGET:
-		return sys_semget (first, second, third);
-	case SEMCTL: {
-		union semun fourth;
-		if (!ptr)
-			return -EINVAL;
-		if (get_user(fourth.__pad, (void __user * __user *) ptr))
-			return -EFAULT;
-		return sys_semctl (first, second, third, fourth);
-	}
-
-	case MSGSND:
-		return sys_msgsnd(first, (struct msgbuf __user *) ptr, 
-				  second, third);
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-			if (!ptr)
-				return -EINVAL;
-			if (copy_from_user(&tmp,(struct ipc_kludge __user *)ptr,
-					   sizeof (tmp)))
-				return -EFAULT;
-			return sys_msgrcv (first, tmp.msgp, second,
-					   tmp.msgtyp, third);
-		}
-		default:
-			return sys_msgrcv (first,
-					   (struct msgbuf __user *) ptr,
-					   second, fifth, third);
-		}
-	case MSGGET:
-		return sys_msgget ((key_t) first, second);
-	case MSGCTL:
-		return sys_msgctl(first, second, (struct msqid_ds __user *)ptr);
-
-	case SHMAT:
-		switch (version) {
-		default: {
-			ulong raddr;
-			ret = do_shmat(first, (char __user *)ptr, second, &raddr);
-			if (ret)
-				return ret;
-			return put_user(raddr, (ulong __user *)third);
-		}
-		case 1: /* Of course, we don't support iBCS2! */
-			return -EINVAL;
-		}
-	case SHMDT: 
-		return sys_shmdt ((char __user *)ptr);
-	case SHMGET:
-		return sys_shmget (first, second, third);
-	case SHMCTL:
-		return sys_shmctl (first, second,
-				   (struct shmid_ds __user *) ptr);
-	default:
-		return -ENOSYS;
-	}
-}
-#endif
-
 /* Fork a new task - this creates a new program thread.
  * This is called indirectly via a small wrapper
  */
diff -puN arch/arm/kernel/sys_oabi-compat.c~add-generic-sys_ipc-wrapper arch/arm/kernel/sys_oabi-compat.c
--- a/arch/arm/kernel/sys_oabi-compat.c~add-generic-sys_ipc-wrapper
+++ a/arch/arm/kernel/sys_oabi-compat.c
@@ -346,9 +346,6 @@ asmlinkage long sys_oabi_semop(int semid
 	return sys_oabi_semtimedop(semid, tsops, nsops, NULL);
 }
 
-extern asmlinkage int sys_ipc(uint call, int first, int second, int third,
-			      void __user *ptr, long fifth);
-
 asmlinkage int sys_oabi_ipc(uint call, int first, int second, int third,
 			    void __user *ptr, long fifth)
 {
diff -puN arch/cris/include/asm/unistd.h~add-generic-sys_ipc-wrapper arch/cris/include/asm/unistd.h
--- a/arch/cris/include/asm/unistd.h~add-generic-sys_ipc-wrapper
+++ a/arch/cris/include/asm/unistd.h
@@ -352,6 +352,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
diff -puN arch/cris/kernel/sys_cris.c~add-generic-sys_ipc-wrapper arch/cris/kernel/sys_cris.c
--- a/arch/cris/kernel/sys_cris.c~add-generic-sys_ipc-wrapper
+++ a/arch/cris/kernel/sys_cris.c
@@ -33,81 +33,3 @@ sys_mmap2(unsigned long addr, unsigned l
 	/* bug(?): 8Kb pages here */
         return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
 }
-
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly. (same as arch/i386)
- */
-
-asmlinkage int sys_ipc (uint call, int first, int second,
-			int third, void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	switch (call) {
-	case SEMOP:
-		return sys_semtimedop (first, (struct sembuf __user *)ptr, second, NULL);
-	case SEMTIMEDOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr, second,
-					(const struct timespec __user *)fifth);
-
-	case SEMGET:
-		return sys_semget (first, second, third);
-	case SEMCTL: {
-		union semun fourth;
-		if (!ptr)
-			return -EINVAL;
-		if (get_user(fourth.__pad, (void * __user *) ptr))
-			return -EFAULT;
-		return sys_semctl (first, second, third, fourth);
-	}
-
-	case MSGSND:
-		return sys_msgsnd (first, (struct msgbuf __user *) ptr, 
-				   second, third);
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-			if (!ptr)
-				return -EINVAL;
-			
-			if (copy_from_user(&tmp,
-					   (struct ipc_kludge __user *) ptr, 
-					   sizeof (tmp)))
-				return -EFAULT;
-			return sys_msgrcv (first, tmp.msgp, second,
-					   tmp.msgtyp, third);
-		}
-		default:
-			return sys_msgrcv (first,
-					   (struct msgbuf __user *) ptr,
-					   second, fifth, third);
-		}
-	case MSGGET:
-		return sys_msgget ((key_t) first, second);
-	case MSGCTL:
-		return sys_msgctl (first, second, (struct msqid_ds __user *) ptr);
-
-	case SHMAT: {
-                ulong raddr;
-                ret = do_shmat (first, (char __user *) ptr, second, &raddr);
-                if (ret)
-                        return ret;
-                return put_user (raddr, (ulong __user *) third);
-        }
-	case SHMDT: 
-		return sys_shmdt ((char __user *)ptr);
-	case SHMGET:
-		return sys_shmget (first, second, third);
-	case SHMCTL:
-		return sys_shmctl (first, second,
-				   (struct shmid_ds __user *) ptr);
-	default:
-		return -ENOSYS;
-	}
-}
diff -puN arch/frv/include/asm/unistd.h~add-generic-sys_ipc-wrapper arch/frv/include/asm/unistd.h
--- a/arch/frv/include/asm/unistd.h~add-generic-sys_ipc-wrapper
+++ a/arch/frv/include/asm/unistd.h
@@ -354,6 +354,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 /* #define __ARCH_WANT_SYS_GETHOSTNAME */
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 /* #define __ARCH_WANT_SYS_SGETMASK */
 /* #define __ARCH_WANT_SYS_SIGNAL */
diff -puN arch/frv/kernel/sys_frv.c~add-generic-sys_ipc-wrapper arch/frv/kernel/sys_frv.c
--- a/arch/frv/kernel/sys_frv.c~add-generic-sys_ipc-wrapper
+++ a/arch/frv/kernel/sys_frv.c
@@ -42,92 +42,3 @@ asmlinkage long sys_mmap2(unsigned long 
 	return sys_mmap_pgoff(addr, len, prot, flags, fd,
 			      pgoff >> (PAGE_SHIFT - 12));
 }
-
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage long sys_ipc(unsigned long call,
-			unsigned long first,
-			unsigned long second,
-			unsigned long third,
-			void __user *ptr,
-			unsigned long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	switch (call) {
-	case SEMOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr, second, NULL);
-	case SEMTIMEDOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr, second,
-				      (const struct timespec __user *)fifth);
-
-	case SEMGET:
-		return sys_semget (first, second, third);
-	case SEMCTL: {
-		union semun fourth;
-		if (!ptr)
-			return -EINVAL;
-		if (get_user(fourth.__pad, (void * __user *) ptr))
-			return -EFAULT;
-		return sys_semctl (first, second, third, fourth);
-	}
-
-	case MSGSND:
-		return sys_msgsnd (first, (struct msgbuf __user *) ptr,
-				   second, third);
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-			if (!ptr)
-				return -EINVAL;
-
-			if (copy_from_user(&tmp,
-					   (struct ipc_kludge __user *) ptr,
-					   sizeof (tmp)))
-				return -EFAULT;
-			return sys_msgrcv (first, tmp.msgp, second,
-					   tmp.msgtyp, third);
-		}
-		default:
-			return sys_msgrcv (first,
-					   (struct msgbuf __user *) ptr,
-					   second, fifth, third);
-		}
-	case MSGGET:
-		return sys_msgget ((key_t) first, second);
-	case MSGCTL:
-		return sys_msgctl (first, second, (struct msqid_ds __user *) ptr);
-
-	case SHMAT:
-		switch (version) {
-		default: {
-			ulong raddr;
-			ret = do_shmat (first, (char __user *) ptr, second, &raddr);
-			if (ret)
-				return ret;
-			return put_user (raddr, (ulong __user *) third);
-		}
-		case 1:	/* iBCS2 emulator entry point */
-			if (!segment_eq(get_fs(), get_ds()))
-				return -EINVAL;
-			/* The "(ulong *) third" is valid _only_ because of the kernel segment thing */
-			return do_shmat (first, (char __user *) ptr, second, (ulong *) third);
-		}
-	case SHMDT:
-		return sys_shmdt ((char __user *)ptr);
-	case SHMGET:
-		return sys_shmget (first, second, third);
-	case SHMCTL:
-		return sys_shmctl (first, second,
-				   (struct shmid_ds __user *) ptr);
-	default:
-		return -ENOSYS;
-	}
-}
diff -puN arch/h8300/include/asm/unistd.h~add-generic-sys_ipc-wrapper arch/h8300/include/asm/unistd.h
--- a/arch/h8300/include/asm/unistd.h~add-generic-sys_ipc-wrapper
+++ a/arch/h8300/include/asm/unistd.h
@@ -336,6 +336,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
diff -puN arch/h8300/kernel/sys_h8300.c~add-generic-sys_ipc-wrapper arch/h8300/kernel/sys_h8300.c
--- a/arch/h8300/kernel/sys_h8300.c~add-generic-sys_ipc-wrapper
+++ a/arch/h8300/kernel/sys_h8300.c
@@ -26,94 +26,6 @@
 #include <asm/traps.h>
 #include <asm/unistd.h>
 
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage int sys_ipc (uint call, int first, int second,
-			int third, void *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	if (call <= SEMCTL)
-		switch (call) {
-		case SEMOP:
-			return sys_semop (first, (struct sembuf *)ptr, second);
-		case SEMGET:
-			return sys_semget (first, second, third);
-		case SEMCTL: {
-			union semun fourth;
-			if (!ptr)
-				return -EINVAL;
-			if (get_user(fourth.__pad, (void **) ptr))
-				return -EFAULT;
-			return sys_semctl (first, second, third, fourth);
-			}
-		default:
-			return -EINVAL;
-		}
-	if (call <= MSGCTL) 
-		switch (call) {
-		case MSGSND:
-			return sys_msgsnd (first, (struct msgbuf *) ptr, 
-					  second, third);
-		case MSGRCV:
-			switch (version) {
-			case 0: {
-				struct ipc_kludge tmp;
-				if (!ptr)
-					return -EINVAL;
-				if (copy_from_user (&tmp,
-						    (struct ipc_kludge *)ptr,
-						    sizeof (tmp)))
-					return -EFAULT;
-				return sys_msgrcv (first, tmp.msgp, second,
-						   tmp.msgtyp, third);
-				}
-			default:
-				return sys_msgrcv (first,
-						   (struct msgbuf *) ptr,
-						   second, fifth, third);
-			}
-		case MSGGET:
-			return sys_msgget ((key_t) first, second);
-		case MSGCTL:
-			return sys_msgctl (first, second,
-					   (struct msqid_ds *) ptr);
-		default:
-			return -EINVAL;
-		}
-	if (call <= SHMCTL) 
-		switch (call) {
-		case SHMAT:
-			switch (version) {
-			default: {
-				ulong raddr;
-				ret = do_shmat (first, (char *) ptr,
-						 second, &raddr);
-				if (ret)
-					return ret;
-				return put_user (raddr, (ulong *) third);
-			}
-			}
-		case SHMDT: 
-			return sys_shmdt ((char *)ptr);
-		case SHMGET:
-			return sys_shmget (first, second, third);
-		case SHMCTL:
-			return sys_shmctl (first, second,
-					   (struct shmid_ds *) ptr);
-		default:
-			return -EINVAL;
-		}
-
-	return -EINVAL;
-}
-
 /* sys_cacheflush -- no support.  */
 asmlinkage int
 sys_cacheflush (unsigned long addr, int scope, int cache, unsigned long len)
diff -puN arch/m32r/include/asm/unistd.h~add-generic-sys_ipc-wrapper arch/m32r/include/asm/unistd.h
--- a/arch/m32r/include/asm/unistd.h~add-generic-sys_ipc-wrapper
+++ a/arch/m32r/include/asm/unistd.h
@@ -339,6 +339,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_TIME
 #define __ARCH_WANT_SYS_UTIME
diff -puN arch/m32r/kernel/sys_m32r.c~add-generic-sys_ipc-wrapper arch/m32r/kernel/sys_m32r.c
--- a/arch/m32r/kernel/sys_m32r.c~add-generic-sys_ipc-wrapper
+++ a/arch/m32r/kernel/sys_m32r.c
@@ -76,87 +76,6 @@ asmlinkage int sys_tas(int __user *addr)
 	return oldval;
 }
 
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage int sys_ipc(uint call, int first, int second,
-		       int third, void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	switch (call) {
-	case SEMOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr,
-				      second, NULL);
-	case SEMTIMEDOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr,
-				      second, (const struct timespec __user *)fifth);
-	case SEMGET:
-		return sys_semget (first, second, third);
-	case SEMCTL: {
-		union semun fourth;
-		if (!ptr)
-			return -EINVAL;
-		if (get_user(fourth.__pad, (void __user * __user *) ptr))
-			return -EFAULT;
-		return sys_semctl (first, second, third, fourth);
-		}
-
-	case MSGSND:
-		return sys_msgsnd (first, (struct msgbuf __user *) ptr,
-				   second, third);
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-			if (!ptr)
-				return -EINVAL;
-
-			if (copy_from_user(&tmp,
-					   (struct ipc_kludge __user *) ptr,
-					   sizeof (tmp)))
-				return -EFAULT;
-			return sys_msgrcv (first, tmp.msgp, second,
-					   tmp.msgtyp, third);
-			}
-		default:
-			return sys_msgrcv (first,
-					   (struct msgbuf __user *) ptr,
-					   second, fifth, third);
-		}
-	case MSGGET:
-		return sys_msgget ((key_t) first, second);
-	case MSGCTL:
-		return sys_msgctl (first, second,
-				   (struct msqid_ds __user *) ptr);
-	case SHMAT: {
-		ulong raddr;
-
-		if (!access_ok(VERIFY_WRITE, (ulong __user *) third,
-				      sizeof(ulong)))
-			return -EFAULT;
-		ret = do_shmat (first, (char __user *) ptr, second, &raddr);
-		if (ret)
-			return ret;
-		return put_user (raddr, (ulong __user *) third);
-		}
-	case SHMDT:
-		return sys_shmdt ((char __user *)ptr);
-	case SHMGET:
-		return sys_shmget (first, second, third);
-	case SHMCTL:
-		return sys_shmctl (first, second,
-				   (struct shmid_ds __user *) ptr);
-	default:
-		return -ENOSYS;
-	}
-}
-
 asmlinkage int sys_uname(struct old_utsname __user * name)
 {
 	int err;
diff -puN arch/m68k/include/asm/unistd.h~add-generic-sys_ipc-wrapper arch/m68k/include/asm/unistd.h
--- a/arch/m68k/include/asm/unistd.h~add-generic-sys_ipc-wrapper
+++ a/arch/m68k/include/asm/unistd.h
@@ -351,6 +351,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
diff -puN arch/m68k/kernel/sys_m68k.c~add-generic-sys_ipc-wrapper arch/m68k/kernel/sys_m68k.c
--- a/arch/m68k/kernel/sys_m68k.c~add-generic-sys_ipc-wrapper
+++ a/arch/m68k/kernel/sys_m68k.c
@@ -46,87 +46,6 @@ asmlinkage long sys_mmap2(unsigned long 
 	return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
 }
 
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage int sys_ipc (uint call, int first, int second,
-			int third, void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	if (call <= SEMCTL)
-		switch (call) {
-		case SEMOP:
-			return sys_semop (first, ptr, second);
-		case SEMGET:
-			return sys_semget (first, second, third);
-		case SEMCTL: {
-			union semun fourth;
-			if (!ptr)
-				return -EINVAL;
-			if (get_user(fourth.__pad, (void __user *__user *) ptr))
-				return -EFAULT;
-			return sys_semctl (first, second, third, fourth);
-			}
-		default:
-			return -ENOSYS;
-		}
-	if (call <= MSGCTL)
-		switch (call) {
-		case MSGSND:
-			return sys_msgsnd (first, ptr, second, third);
-		case MSGRCV:
-			switch (version) {
-			case 0: {
-				struct ipc_kludge tmp;
-				if (!ptr)
-					return -EINVAL;
-				if (copy_from_user (&tmp, ptr, sizeof (tmp)))
-					return -EFAULT;
-				return sys_msgrcv (first, tmp.msgp, second,
-						   tmp.msgtyp, third);
-				}
-			default:
-				return sys_msgrcv (first, ptr,
-						   second, fifth, third);
-			}
-		case MSGGET:
-			return sys_msgget ((key_t) first, second);
-		case MSGCTL:
-			return sys_msgctl (first, second, ptr);
-		default:
-			return -ENOSYS;
-		}
-	if (call <= SHMCTL)
-		switch (call) {
-		case SHMAT:
-			switch (version) {
-			default: {
-				ulong raddr;
-				ret = do_shmat (first, ptr, second, &raddr);
-				if (ret)
-					return ret;
-				return put_user (raddr, (ulong __user *) third);
-			}
-			}
-		case SHMDT:
-			return sys_shmdt (ptr);
-		case SHMGET:
-			return sys_shmget (first, second, third);
-		case SHMCTL:
-			return sys_shmctl (first, second, ptr);
-		default:
-			return -ENOSYS;
-		}
-
-	return -EINVAL;
-}
-
 /* Convert virtual (user) address VADDR to physical address PADDR */
 #define virt_to_phys_040(vaddr)						\
 ({									\
diff -puN arch/m68knommu/kernel/sys_m68k.c~add-generic-sys_ipc-wrapper arch/m68knommu/kernel/sys_m68k.c
--- a/arch/m68knommu/kernel/sys_m68k.c~add-generic-sys_ipc-wrapper
+++ a/arch/m68knommu/kernel/sys_m68k.c
@@ -27,92 +27,6 @@
 #include <asm/cacheflush.h>
 #include <asm/unistd.h>
 
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage int sys_ipc (uint call, int first, int second,
-			int third, void *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	if (call <= SEMCTL)
-		switch (call) {
-		case SEMOP:
-			return sys_semop (first, (struct sembuf *)ptr, second);
-		case SEMGET:
-			return sys_semget (first, second, third);
-		case SEMCTL: {
-			union semun fourth;
-			if (!ptr)
-				return -EINVAL;
-			if (get_user(fourth.__pad, (void **) ptr))
-				return -EFAULT;
-			return sys_semctl (first, second, third, fourth);
-			}
-		default:
-			return -EINVAL;
-		}
-	if (call <= MSGCTL) 
-		switch (call) {
-		case MSGSND:
-			return sys_msgsnd (first, (struct msgbuf *) ptr, 
-					  second, third);
-		case MSGRCV:
-			switch (version) {
-			case 0: {
-				struct ipc_kludge tmp;
-				if (!ptr)
-					return -EINVAL;
-				if (copy_from_user (&tmp,
-						    (struct ipc_kludge *)ptr,
-						    sizeof (tmp)))
-					return -EFAULT;
-				return sys_msgrcv (first, tmp.msgp, second,
-						   tmp.msgtyp, third);
-				}
-			default:
-				return sys_msgrcv (first,
-						   (struct msgbuf *) ptr,
-						   second, fifth, third);
-			}
-		case MSGGET:
-			return sys_msgget ((key_t) first, second);
-		case MSGCTL:
-			return sys_msgctl (first, second,
-					   (struct msqid_ds *) ptr);
-		default:
-			return -EINVAL;
-		}
-	if (call <= SHMCTL)
-		switch (call) {
-		case SHMAT:
-			switch (version) {
-			default: {
-				ulong raddr;
-				ret = do_shmat (first, ptr, second, &raddr);
-				if (ret)
-					return ret;
-				return put_user (raddr, (ulong __user *) third);
-			}
-			}
-		case SHMDT:
-			return sys_shmdt (ptr);
-		case SHMGET:
-			return sys_shmget (first, second, third);
-		case SHMCTL:
-			return sys_shmctl (first, second, ptr);
-		default:
-			return -ENOSYS;
-		}
-
-	return -EINVAL;
-}
-
 /* sys_cacheflush -- flush (part of) the processor cache.  */
 asmlinkage int
 sys_cacheflush (unsigned long addr, int scope, int cache, unsigned long len)
diff -puN arch/mips/include/asm/unistd.h~add-generic-sys_ipc-wrapper arch/mips/include/asm/unistd.h
--- a/arch/mips/include/asm/unistd.h~add-generic-sys_ipc-wrapper
+++ a/arch/mips/include/asm/unistd.h
@@ -1004,6 +1004,7 @@
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_UTIME
diff -puN arch/mips/kernel/syscall.c~add-generic-sys_ipc-wrapper arch/mips/kernel/syscall.c
--- a/arch/mips/kernel/syscall.c~add-generic-sys_ipc-wrapper
+++ a/arch/mips/kernel/syscall.c
@@ -407,94 +407,6 @@ _sys_sysmips(nabi_no_regargs struct pt_r
 }
 
 /*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-SYSCALL_DEFINE6(ipc, unsigned int, call, int, first, int, second,
-	unsigned long, third, void __user *, ptr, long, fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	switch (call) {
-	case SEMOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr,
-		                      second, NULL);
-	case SEMTIMEDOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr,
-				      second,
-				      (const struct timespec __user *)fifth);
-	case SEMGET:
-		return sys_semget(first, second, third);
-	case SEMCTL: {
-		union semun fourth;
-		if (!ptr)
-			return -EINVAL;
-		if (get_user(fourth.__pad, (void __user *__user *) ptr))
-			return -EFAULT;
-		return sys_semctl(first, second, third, fourth);
-	}
-
-	case MSGSND:
-		return sys_msgsnd(first, (struct msgbuf __user *) ptr,
-				  second, third);
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-			if (!ptr)
-				return -EINVAL;
-
-			if (copy_from_user(&tmp,
-					   (struct ipc_kludge __user *) ptr,
-					   sizeof(tmp)))
-				return -EFAULT;
-			return sys_msgrcv(first, tmp.msgp, second,
-					  tmp.msgtyp, third);
-		}
-		default:
-			return sys_msgrcv(first,
-					  (struct msgbuf __user *) ptr,
-					  second, fifth, third);
-		}
-	case MSGGET:
-		return sys_msgget((key_t) first, second);
-	case MSGCTL:
-		return sys_msgctl(first, second,
-				  (struct msqid_ds __user *) ptr);
-
-	case SHMAT:
-		switch (version) {
-		default: {
-			unsigned long raddr;
-			ret = do_shmat(first, (char __user *) ptr, second,
-				       &raddr);
-			if (ret)
-				return ret;
-			return put_user(raddr, (unsigned long __user *) third);
-		}
-		case 1:	/* iBCS2 emulator entry point */
-			if (!segment_eq(get_fs(), get_ds()))
-				return -EINVAL;
-			return do_shmat(first, (char __user *) ptr, second,
-				        (unsigned long *) third);
-		}
-	case SHMDT:
-		return sys_shmdt((char __user *)ptr);
-	case SHMGET:
-		return sys_shmget(first, second, third);
-	case SHMCTL:
-		return sys_shmctl(first, second,
-				  (struct shmid_ds __user *) ptr);
-	default:
-		return -ENOSYS;
-	}
-}
-
-/*
  * No implemented yet ...
  */
 SYSCALL_DEFINE3(cachectl, char *, addr, int, nbytes, int, op)
diff -puN arch/mn10300/include/asm/unistd.h~add-generic-sys_ipc-wrapper arch/mn10300/include/asm/unistd.h
--- a/arch/mn10300/include/asm/unistd.h~add-generic-sys_ipc-wrapper
+++ a/arch/mn10300/include/asm/unistd.h
@@ -363,6 +363,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
diff -puN arch/mn10300/kernel/sys_mn10300.c~add-generic-sys_ipc-wrapper arch/mn10300/kernel/sys_mn10300.c
--- a/arch/mn10300/kernel/sys_mn10300.c~add-generic-sys_ipc-wrapper
+++ a/arch/mn10300/kernel/sys_mn10300.c
@@ -31,91 +31,3 @@ asmlinkage long old_mmap(unsigned long a
 		return -EINVAL;
 	return sys_mmap_pgoff(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
 }
-
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage long sys_ipc(uint call, int first, int second,
-			int third, void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	switch (call) {
-	case SEMOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr,
-				      second, NULL);
-	case SEMTIMEDOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr,
-				      second,
-				      (const struct timespec __user *)fifth);
-	case SEMGET:
-		return sys_semget(first, second, third);
-	case SEMCTL: {
-		union semun fourth;
-		if (!ptr)
-			return -EINVAL;
-		if (get_user(fourth.__pad, (void __user * __user *) ptr))
-			return -EFAULT;
-		return sys_semctl(first, second, third, fourth);
-	}
-
-	case MSGSND:
-		return sys_msgsnd(first, (struct msgbuf __user *) ptr,
-				  second, third);
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-			if (!ptr)
-				return -EINVAL;
-
-			if (copy_from_user(&tmp,
-					   (struct ipc_kludge __user *) ptr,
-					   sizeof(tmp)))
-				return -EFAULT;
-			return sys_msgrcv(first, tmp.msgp, second,
-					  tmp.msgtyp, third);
-		}
-		default:
-			return sys_msgrcv(first,
-					  (struct msgbuf __user *) ptr,
-					   second, fifth, third);
-		}
-	case MSGGET:
-		return sys_msgget((key_t) first, second);
-	case MSGCTL:
-		return sys_msgctl(first, second,
-				   (struct msqid_ds __user *) ptr);
-
-	case SHMAT:
-		switch (version) {
-		default: {
-			ulong raddr;
-			ret = do_shmat(first, (char __user *) ptr, second,
-				       &raddr);
-			if (ret)
-				return ret;
-			return put_user(raddr, (ulong *) third);
-		}
-		case 1:	/* iBCS2 emulator entry point */
-			if (!segment_eq(get_fs(), get_ds()))
-				return -EINVAL;
-			return do_shmat(first, (char __user *) ptr, second,
-					(ulong *) third);
-		}
-	case SHMDT:
-		return sys_shmdt((char __user *)ptr);
-	case SHMGET:
-		return sys_shmget(first, second, third);
-	case SHMCTL:
-		return sys_shmctl(first, second,
-				  (struct shmid_ds __user *) ptr);
-	default:
-		return -EINVAL;
-	}
-}
diff -puN arch/powerpc/include/asm/syscalls.h~add-generic-sys_ipc-wrapper arch/powerpc/include/asm/syscalls.h
--- a/arch/powerpc/include/asm/syscalls.h~add-generic-sys_ipc-wrapper
+++ a/arch/powerpc/include/asm/syscalls.h
@@ -35,8 +35,6 @@ asmlinkage long sys_pipe2(int __user *fi
 asmlinkage long sys_rt_sigaction(int sig,
 		const struct sigaction __user *act,
 		struct sigaction __user *oact, size_t sigsetsize);
-asmlinkage int sys_ipc(uint call, int first, unsigned long second,
-		long third, void __user *ptr, long fifth);
 asmlinkage long ppc64_personality(unsigned long personality);
 asmlinkage int ppc_rtas(struct rtas_args __user *uargs);
 asmlinkage time_t sys64_time(time_t __user * tloc);
diff -puN arch/powerpc/include/asm/unistd.h~add-generic-sys_ipc-wrapper arch/powerpc/include/asm/unistd.h
--- a/arch/powerpc/include/asm/unistd.h~add-generic-sys_ipc-wrapper
+++ a/arch/powerpc/include/asm/unistd.h
@@ -364,6 +364,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
diff -puN arch/powerpc/kernel/syscalls.c~add-generic-sys_ipc-wrapper arch/powerpc/kernel/syscalls.c
--- a/arch/powerpc/kernel/syscalls.c~add-generic-sys_ipc-wrapper
+++ a/arch/powerpc/kernel/syscalls.c
@@ -42,100 +42,6 @@
 #include <asm/time.h>
 #include <asm/unistd.h>
 
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-int sys_ipc(uint call, int first, unsigned long second, long third,
-	    void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	ret = -ENOSYS;
-	switch (call) {
-	case SEMOP:
-		ret = sys_semtimedop(first, (struct sembuf __user *)ptr,
-				      (unsigned)second, NULL);
-		break;
-	case SEMTIMEDOP:
-		ret = sys_semtimedop(first, (struct sembuf __user *)ptr,
-				      (unsigned)second,
-				      (const struct timespec __user *) fifth);
-		break;
-	case SEMGET:
-		ret = sys_semget (first, (int)second, third);
-		break;
-	case SEMCTL: {
-		union semun fourth;
-
-		ret = -EINVAL;
-		if (!ptr)
-			break;
-		if ((ret = get_user(fourth.__pad, (void __user * __user *)ptr)))
-			break;
-		ret = sys_semctl(first, (int)second, third, fourth);
-		break;
-	}
-	case MSGSND:
-		ret = sys_msgsnd(first, (struct msgbuf __user *)ptr,
-				 (size_t)second, third);
-		break;
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-
-			ret = -EINVAL;
-			if (!ptr)
-				break;
-			if ((ret = copy_from_user(&tmp,
-						(struct ipc_kludge __user *) ptr,
-						sizeof (tmp)) ? -EFAULT : 0))
-				break;
-			ret = sys_msgrcv(first, tmp.msgp, (size_t) second,
-					  tmp.msgtyp, third);
-			break;
-		}
-		default:
-			ret = sys_msgrcv (first, (struct msgbuf __user *) ptr,
-					  (size_t)second, fifth, third);
-			break;
-		}
-		break;
-	case MSGGET:
-		ret = sys_msgget((key_t)first, (int)second);
-		break;
-	case MSGCTL:
-		ret = sys_msgctl(first, (int)second,
-				  (struct msqid_ds __user *)ptr);
-		break;
-	case SHMAT: {
-		ulong raddr;
-		ret = do_shmat(first, (char __user *)ptr, (int)second, &raddr);
-		if (ret)
-			break;
-		ret = put_user(raddr, (ulong __user *) third);
-		break;
-	}
-	case SHMDT:
-		ret = sys_shmdt((char __user *)ptr);
-		break;
-	case SHMGET:
-		ret = sys_shmget(first, (size_t)second, third);
-		break;
-	case SHMCTL:
-		ret = sys_shmctl(first, (int)second,
-				 (struct shmid_ds __user *)ptr);
-		break;
-	}
-
-	return ret;
-}
-
 static inline unsigned long do_mmap2(unsigned long addr, size_t len,
 			unsigned long prot, unsigned long flags,
 			unsigned long fd, unsigned long off, int shift)
diff -puN arch/s390/kernel/entry.h~add-generic-sys_ipc-wrapper arch/s390/kernel/entry.h
--- a/arch/s390/kernel/entry.h~add-generic-sys_ipc-wrapper
+++ a/arch/s390/kernel/entry.h
@@ -30,7 +30,7 @@ struct fadvise64_64_args;
 struct old_sigaction;
 
 long sys_mmap2(struct s390_mmap_arg_struct __user  *arg);
-long sys_ipc(uint call, int first, unsigned long second,
+long sys_s390_ipc(uint call, int first, unsigned long second,
 	     unsigned long third, void __user *ptr);
 long sys_s390_newuname(struct new_utsname __user *name);
 long sys_s390_personality(unsigned long personality);
diff -puN arch/s390/kernel/sys_s390.c~add-generic-sys_ipc-wrapper arch/s390/kernel/sys_s390.c
--- a/arch/s390/kernel/sys_s390.c~add-generic-sys_ipc-wrapper
+++ a/arch/s390/kernel/sys_s390.c
@@ -64,7 +64,7 @@ out:
  *
  * This is really horribly ugly.
  */
-SYSCALL_DEFINE5(ipc, uint, call, int, first, unsigned long, second,
+SYSCALL_DEFINE5(s390_ipc, uint, call, int, first, unsigned long, second,
 		unsigned long, third, void __user *, ptr)
 {
         struct ipc_kludge tmp;
diff -puN arch/s390/kernel/syscalls.S~add-generic-sys_ipc-wrapper arch/s390/kernel/syscalls.S
--- a/arch/s390/kernel/syscalls.S~add-generic-sys_ipc-wrapper
+++ a/arch/s390/kernel/syscalls.S
@@ -125,7 +125,7 @@ NI_SYSCALL							/* vm86old for i386 */
 SYSCALL(sys_wait4,sys_wait4,compat_sys_wait4_wrapper)
 SYSCALL(sys_swapoff,sys_swapoff,sys32_swapoff_wrapper)		/* 115 */
 SYSCALL(sys_sysinfo,sys_sysinfo,compat_sys_sysinfo_wrapper)
-SYSCALL(sys_ipc,sys_ipc,sys32_ipc_wrapper)
+SYSCALL(sys_s390_ipc,sys_s390_ipc,sys32_ipc_wrapper)
 SYSCALL(sys_fsync,sys_fsync,sys32_fsync_wrapper)
 SYSCALL(sys_sigreturn,sys_sigreturn,sys32_sigreturn)
 SYSCALL(sys_clone,sys_clone,sys_clone_wrapper)			/* 120 */
diff -puN arch/sh/include/asm/syscalls.h~add-generic-sys_ipc-wrapper arch/sh/include/asm/syscalls.h
--- a/arch/sh/include/asm/syscalls.h~add-generic-sys_ipc-wrapper
+++ a/arch/sh/include/asm/syscalls.h
@@ -11,8 +11,6 @@ asmlinkage int old_mmap(unsigned long ad
 asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 			  unsigned long prot, unsigned long flags,
 			  unsigned long fd, unsigned long pgoff);
-asmlinkage int sys_ipc(uint call, int first, int second,
-		       int third, void __user *ptr, long fifth);
 asmlinkage int sys_uname(struct old_utsname __user *name);
 
 #ifdef CONFIG_SUPERH32
diff -puN arch/sh/include/asm/unistd_32.h~add-generic-sys_ipc-wrapper arch/sh/include/asm/unistd_32.h
--- a/arch/sh/include/asm/unistd_32.h~add-generic-sys_ipc-wrapper
+++ a/arch/sh/include/asm/unistd_32.h
@@ -358,6 +358,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
diff -puN arch/sh/include/asm/unistd_64.h~add-generic-sys_ipc-wrapper arch/sh/include/asm/unistd_64.h
--- a/arch/sh/include/asm/unistd_64.h~add-generic-sys_ipc-wrapper
+++ a/arch/sh/include/asm/unistd_64.h
@@ -398,6 +398,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
diff -puN arch/sh/kernel/sys_sh.c~add-generic-sys_ipc-wrapper arch/sh/kernel/sys_sh.c
--- a/arch/sh/kernel/sys_sh.c~add-generic-sys_ipc-wrapper
+++ a/arch/sh/kernel/sys_sh.c
@@ -53,110 +53,6 @@ asmlinkage long sys_mmap2(unsigned long 
 	return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
 }
 
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage int sys_ipc(uint call, int first, int second,
-		       int third, void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	if (call <= SEMTIMEDOP)
-		switch (call) {
-		case SEMOP:
-			return sys_semtimedop(first,
-					      (struct sembuf __user *)ptr,
-					      second, NULL);
-		case SEMTIMEDOP:
-			return sys_semtimedop(first,
-				(struct sembuf __user *)ptr, second,
-			        (const struct timespec __user *)fifth);
-		case SEMGET:
-			return sys_semget (first, second, third);
-		case SEMCTL: {
-			union semun fourth;
-			if (!ptr)
-				return -EINVAL;
-			if (get_user(fourth.__pad, (void __user * __user *) ptr))
-				return -EFAULT;
-			return sys_semctl (first, second, third, fourth);
-			}
-		default:
-			return -EINVAL;
-		}
-
-	if (call <= MSGCTL)
-		switch (call) {
-		case MSGSND:
-			return sys_msgsnd (first, (struct msgbuf __user *) ptr,
-					  second, third);
-		case MSGRCV:
-			switch (version) {
-			case 0:
-			{
-				struct ipc_kludge tmp;
-
-				if (!ptr)
-					return -EINVAL;
-
-				if (copy_from_user(&tmp,
-					(struct ipc_kludge __user *) ptr,
-						   sizeof (tmp)))
-					return -EFAULT;
-
-				return sys_msgrcv (first, tmp.msgp, second,
-						   tmp.msgtyp, third);
-			}
-			default:
-				return sys_msgrcv (first,
-						   (struct msgbuf __user *) ptr,
-						   second, fifth, third);
-			}
-		case MSGGET:
-			return sys_msgget ((key_t) first, second);
-		case MSGCTL:
-			return sys_msgctl (first, second,
-					   (struct msqid_ds __user *) ptr);
-		default:
-			return -EINVAL;
-		}
-	if (call <= SHMCTL)
-		switch (call) {
-		case SHMAT:
-			switch (version) {
-			default: {
-				ulong raddr;
-				ret = do_shmat (first, (char __user *) ptr,
-						 second, &raddr);
-				if (ret)
-					return ret;
-				return put_user (raddr, (ulong __user *) third);
-			}
-			case 1:	/* iBCS2 emulator entry point */
-				if (!segment_eq(get_fs(), get_ds()))
-					return -EINVAL;
-				return do_shmat (first, (char __user *) ptr,
-						  second, (ulong *) third);
-			}
-		case SHMDT:
-			return sys_shmdt ((char __user *)ptr);
-		case SHMGET:
-			return sys_shmget (first, second, third);
-		case SHMCTL:
-			return sys_shmctl (first, second,
-					   (struct shmid_ds __user *) ptr);
-		default:
-			return -EINVAL;
-		}
-
-	return -EINVAL;
-}
-
 /* sys_cacheflush -- flush (part of) the processor cache.  */
 asmlinkage int sys_cacheflush(unsigned long addr, unsigned long len, int op)
 {
diff -puN arch/sparc/include/asm/unistd.h~add-generic-sys_ipc-wrapper arch/sparc/include/asm/unistd.h
--- a/arch/sparc/include/asm/unistd.h~add-generic-sys_ipc-wrapper
+++ a/arch/sparc/include/asm/unistd.h
@@ -432,7 +432,9 @@
 #define __ARCH_WANT_SYS_SIGPENDING
 #define __ARCH_WANT_SYS_SIGPROCMASK
 #define __ARCH_WANT_SYS_RT_SIGSUSPEND
-#ifndef __32bit_syscall_numbers__
+#ifdef __32bit_syscall_numbers__
+#define __ARCH_WANT_SYS_IPC
+#else
 #define __ARCH_WANT_COMPAT_SYS_TIME
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
 #endif
diff -puN arch/sparc/kernel/sys_sparc_32.c~add-generic-sys_ipc-wrapper arch/sparc/kernel/sys_sparc_32.c
--- a/arch/sparc/kernel/sys_sparc_32.c~add-generic-sys_ipc-wrapper
+++ a/arch/sparc/kernel/sys_sparc_32.c
@@ -98,119 +98,6 @@ out:
 	return error;
 }
 
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-
-asmlinkage int sys_ipc (uint call, int first, int second, int third, void __user *ptr, long fifth)
-{
-	int version, err;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	if (call <= SEMCTL)
-		switch (call) {
-		case SEMOP:
-			err = sys_semtimedop (first, (struct sembuf __user *)ptr, second, NULL);
-			goto out;
-		case SEMTIMEDOP:
-			err = sys_semtimedop (first, (struct sembuf __user *)ptr, second, (const struct timespec __user *) fifth);
-			goto out;
-		case SEMGET:
-			err = sys_semget (first, second, third);
-			goto out;
-		case SEMCTL: {
-			union semun fourth;
-			err = -EINVAL;
-			if (!ptr)
-				goto out;
-			err = -EFAULT;
-			if (get_user(fourth.__pad,
-				     (void __user * __user *)ptr))
-				goto out;
-			err = sys_semctl (first, second, third, fourth);
-			goto out;
-			}
-		default:
-			err = -ENOSYS;
-			goto out;
-		}
-	if (call <= MSGCTL) 
-		switch (call) {
-		case MSGSND:
-			err = sys_msgsnd (first, (struct msgbuf __user *) ptr, 
-					  second, third);
-			goto out;
-		case MSGRCV:
-			switch (version) {
-			case 0: {
-				struct ipc_kludge tmp;
-				err = -EINVAL;
-				if (!ptr)
-					goto out;
-				err = -EFAULT;
-				if (copy_from_user(&tmp, (struct ipc_kludge __user *) ptr, sizeof (tmp)))
-					goto out;
-				err = sys_msgrcv (first, tmp.msgp, second, tmp.msgtyp, third);
-				goto out;
-				}
-			case 1: default:
-				err = sys_msgrcv (first,
-						  (struct msgbuf __user *) ptr,
-						  second, fifth, third);
-				goto out;
-			}
-		case MSGGET:
-			err = sys_msgget ((key_t) first, second);
-			goto out;
-		case MSGCTL:
-			err = sys_msgctl (first, second, (struct msqid_ds __user *) ptr);
-			goto out;
-		default:
-			err = -ENOSYS;
-			goto out;
-		}
-	if (call <= SHMCTL) 
-		switch (call) {
-		case SHMAT:
-			switch (version) {
-			case 0: default: {
-				ulong raddr;
-				err = do_shmat (first, (char __user *) ptr, second, &raddr);
-				if (err)
-					goto out;
-				err = -EFAULT;
-				if (put_user (raddr, (ulong __user *) third))
-					goto out;
-				err = 0;
-				goto out;
-				}
-			case 1:	/* iBCS2 emulator entry point */
-				err = -EINVAL;
-				goto out;
-			}
-		case SHMDT: 
-			err = sys_shmdt ((char __user *)ptr);
-			goto out;
-		case SHMGET:
-			err = sys_shmget (first, second, third);
-			goto out;
-		case SHMCTL:
-			err = sys_shmctl (first, second, (struct shmid_ds __user *) ptr);
-			goto out;
-		default:
-			err = -ENOSYS;
-			goto out;
-		}
-	else
-		err = -ENOSYS;
-out:
-	return err;
-}
-
 int sparc_mmap_check(unsigned long addr, unsigned long len)
 {
 	if (ARCH_SUN4C &&
diff -puN arch/sparc/kernel/sys_sparc_64.c~add-generic-sys_ipc-wrapper arch/sparc/kernel/sys_sparc_64.c
--- a/arch/sparc/kernel/sys_sparc_64.c~add-generic-sys_ipc-wrapper
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -426,7 +426,7 @@ out:
  * This is really horribly ugly.
  */
 
-SYSCALL_DEFINE6(ipc, unsigned int, call, int, first, unsigned long, second,
+SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second,
 		unsigned long, third, void __user *, ptr, long, fifth)
 {
 	long err;
diff -puN arch/sparc/kernel/systbls.h~add-generic-sys_ipc-wrapper arch/sparc/kernel/systbls.h
--- a/arch/sparc/kernel/systbls.h~add-generic-sys_ipc-wrapper
+++ a/arch/sparc/kernel/systbls.h
@@ -10,7 +10,7 @@ struct new_utsname;
 
 extern asmlinkage unsigned long sys_getpagesize(void);
 extern asmlinkage long sparc_pipe(struct pt_regs *regs);
-extern asmlinkage long sys_ipc(unsigned int call, int first,
+extern asmlinkage long sys_sparc_ipc(unsigned int call, int first,
 			       unsigned long second,
 			       unsigned long third,
 			       void __user *ptr, long fifth);
diff -puN arch/sparc/kernel/systbls_64.S~add-generic-sys_ipc-wrapper arch/sparc/kernel/systbls_64.S
--- a/arch/sparc/kernel/systbls_64.S~add-generic-sys_ipc-wrapper
+++ a/arch/sparc/kernel/systbls_64.S
@@ -136,7 +136,7 @@ sys_call_table:
 /*200*/	.word sys_ssetmask, sys_nis_syscall, sys_newlstat, sys_uselib, sys_nis_syscall
 	.word sys_readahead, sys_socketcall, sys_syslog, sys_lookup_dcookie, sys_fadvise64
 /*210*/	.word sys_fadvise64_64, sys_tgkill, sys_waitpid, sys_swapoff, sys_sysinfo
-	.word sys_ipc, sys_nis_syscall, sys_clone, sys_ioprio_get, sys_adjtimex
+	.word sys_sparc_ipc, sys_nis_syscall, sys_clone, sys_ioprio_get, sys_adjtimex
 /*220*/	.word sys_nis_syscall, sys_ni_syscall, sys_delete_module, sys_ni_syscall, sys_getpgid
 	.word sys_bdflush, sys_sysfs, sys_nis_syscall, sys_setfsuid, sys_setfsgid
 /*230*/	.word sys_select, sys_nis_syscall, sys_splice, sys_stime, sys_statfs64
diff -puN arch/um/sys-i386/syscalls.c~add-generic-sys_ipc-wrapper arch/um/sys-i386/syscalls.c
--- a/arch/um/sys-i386/syscalls.c~add-generic-sys_ipc-wrapper
+++ a/arch/um/sys-i386/syscalls.c
@@ -34,92 +34,6 @@ long sys_clone(unsigned long clone_flags
 	return ret;
 }
 
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-long sys_ipc (uint call, int first, int second,
-	     int third, void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	switch (call) {
-	case SEMOP:
-		return sys_semtimedop(first, (struct sembuf __user *) ptr,
-				      second, NULL);
-	case SEMTIMEDOP:
-		return sys_semtimedop(first, (struct sembuf __user *) ptr,
-				      second,
-				      (const struct timespec __user *) fifth);
-	case SEMGET:
-		return sys_semget (first, second, third);
-	case SEMCTL: {
-		union semun fourth;
-		if (!ptr)
-			return -EINVAL;
-		if (get_user(fourth.__pad, (void __user * __user *) ptr))
-			return -EFAULT;
-		return sys_semctl (first, second, third, fourth);
-	}
-
-	case MSGSND:
-		return sys_msgsnd (first, (struct msgbuf *) ptr,
-				   second, third);
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-			if (!ptr)
-				return -EINVAL;
-
-			if (copy_from_user(&tmp,
-					   (struct ipc_kludge *) ptr,
-					   sizeof (tmp)))
-				return -EFAULT;
-			return sys_msgrcv (first, tmp.msgp, second,
-					   tmp.msgtyp, third);
-		}
-		default:
-		        panic("msgrcv with version != 0");
-			return sys_msgrcv (first,
-					   (struct msgbuf *) ptr,
-					   second, fifth, third);
-		}
-	case MSGGET:
-		return sys_msgget ((key_t) first, second);
-	case MSGCTL:
-		return sys_msgctl (first, second, (struct msqid_ds *) ptr);
-
-	case SHMAT:
-		switch (version) {
-		default: {
-			ulong raddr;
-			ret = do_shmat (first, (char *) ptr, second, &raddr);
-			if (ret)
-				return ret;
-			return put_user (raddr, (ulong *) third);
-		}
-		case 1:	/* iBCS2 emulator entry point */
-			if (!segment_eq(get_fs(), get_ds()))
-				return -EINVAL;
-			return do_shmat (first, (char *) ptr, second, (ulong *) third);
-		}
-	case SHMDT:
-		return sys_shmdt ((char *)ptr);
-	case SHMGET:
-		return sys_shmget (first, second, third);
-	case SHMCTL:
-		return sys_shmctl (first, second,
-				   (struct shmid_ds *) ptr);
-	default:
-		return -ENOSYS;
-	}
-}
-
 long sys_sigaction(int sig, const struct old_sigaction __user *act,
 			 struct old_sigaction __user *oact)
 {
diff -puN arch/x86/include/asm/syscalls.h~add-generic-sys_ipc-wrapper arch/x86/include/asm/syscalls.h
--- a/arch/x86/include/asm/syscalls.h~add-generic-sys_ipc-wrapper
+++ a/arch/x86/include/asm/syscalls.h
@@ -54,7 +54,6 @@ unsigned long sys_sigreturn(struct pt_re
 struct oldold_utsname;
 struct old_utsname;
 
-asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
 asmlinkage int sys_uname(struct old_utsname __user *);
 asmlinkage int sys_olduname(struct oldold_utsname __user *);
 
diff -puN arch/x86/include/asm/unistd_32.h~add-generic-sys_ipc-wrapper arch/x86/include/asm/unistd_32.h
--- a/arch/x86/include/asm/unistd_32.h~add-generic-sys_ipc-wrapper
+++ a/arch/x86/include/asm/unistd_32.h
@@ -354,6 +354,7 @@
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
+#define __ARCH_WANT_SYS_IPC
 #define __ARCH_WANT_SYS_PAUSE
 #define __ARCH_WANT_SYS_SGETMASK
 #define __ARCH_WANT_SYS_SIGNAL
diff -puN arch/x86/kernel/sys_i386_32.c~add-generic-sys_ipc-wrapper arch/x86/kernel/sys_i386_32.c
--- a/arch/x86/kernel/sys_i386_32.c~add-generic-sys_ipc-wrapper
+++ a/arch/x86/kernel/sys_i386_32.c
@@ -25,91 +25,6 @@
 #include <asm/syscalls.h>
 
 /*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly.
- */
-asmlinkage int sys_ipc(uint call, int first, int second,
-			int third, void __user *ptr, long fifth)
-{
-	int version, ret;
-
-	version = call >> 16; /* hack for backward compatibility */
-	call &= 0xffff;
-
-	switch (call) {
-	case SEMOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr, second, NULL);
-	case SEMTIMEDOP:
-		return sys_semtimedop(first, (struct sembuf __user *)ptr, second,
-					(const struct timespec __user *)fifth);
-
-	case SEMGET:
-		return sys_semget(first, second, third);
-	case SEMCTL: {
-		union semun fourth;
-		if (!ptr)
-			return -EINVAL;
-		if (get_user(fourth.__pad, (void __user * __user *) ptr))
-			return -EFAULT;
-		return sys_semctl(first, second, third, fourth);
-	}
-
-	case MSGSND:
-		return sys_msgsnd(first, (struct msgbuf __user *) ptr,
-				   second, third);
-	case MSGRCV:
-		switch (version) {
-		case 0: {
-			struct ipc_kludge tmp;
-			if (!ptr)
-				return -EINVAL;
-
-			if (copy_from_user(&tmp,
-					   (struct ipc_kludge __user *) ptr,
-					   sizeof(tmp)))
-				return -EFAULT;
-			return sys_msgrcv(first, tmp.msgp, second,
-					   tmp.msgtyp, third);
-		}
-		default:
-			return sys_msgrcv(first,
-					   (struct msgbuf __user *) ptr,
-					   second, fifth, third);
-		}
-	case MSGGET:
-		return sys_msgget((key_t) first, second);
-	case MSGCTL:
-		return sys_msgctl(first, second, (struct msqid_ds __user *) ptr);
-
-	case SHMAT:
-		switch (version) {
-		default: {
-			ulong raddr;
-			ret = do_shmat(first, (char __user *) ptr, second, &raddr);
-			if (ret)
-				return ret;
-			return put_user(raddr, (ulong __user *) third);
-		}
-		case 1:	/* iBCS2 emulator entry point */
-			if (!segment_eq(get_fs(), get_ds()))
-				return -EINVAL;
-			/* The "(ulong *) third" is valid _only_ because of the kernel segment thing */
-			return do_shmat(first, (char __user *) ptr, second, (ulong *) third);
-		}
-	case SHMDT:
-		return sys_shmdt((char __user *)ptr);
-	case SHMGET:
-		return sys_shmget(first, second, third);
-	case SHMCTL:
-		return sys_shmctl(first, second,
-				   (struct shmid_ds __user *) ptr);
-	default:
-		return -ENOSYS;
-	}
-}
-
-/*
  * Old cruft
  */
 asmlinkage int sys_uname(struct old_utsname __user *name)
diff -puN include/linux/syscalls.h~add-generic-sys_ipc-wrapper include/linux/syscalls.h
--- a/include/linux/syscalls.h~add-generic-sys_ipc-wrapper
+++ a/include/linux/syscalls.h
@@ -684,6 +684,8 @@ asmlinkage long sys_shmat(int shmid, cha
 asmlinkage long sys_shmget(key_t key, size_t size, int flag);
 asmlinkage long sys_shmdt(char __user *shmaddr);
 asmlinkage long sys_shmctl(int shmid, int cmd, struct shmid_ds __user *buf);
+asmlinkage long sys_ipc(unsigned int call, int first, int second,
+		unsigned long third, void __user *ptr, long fifth);
 
 asmlinkage long sys_mq_open(const char __user *name, int oflag, mode_t mode, struct mq_attr __user *attr);
 asmlinkage long sys_mq_unlink(const char __user *name);
diff -puN ipc/Makefile~add-generic-sys_ipc-wrapper ipc/Makefile
--- a/ipc/Makefile~add-generic-sys_ipc-wrapper
+++ a/ipc/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-$(CONFIG_SYSVIPC_COMPAT) += compat.o
-obj-$(CONFIG_SYSVIPC) += util.o msgutil.o msg.o sem.o shm.o ipcns_notifier.o
+obj-$(CONFIG_SYSVIPC) += util.o msgutil.o msg.o sem.o shm.o ipcns_notifier.o syscall.o
 obj-$(CONFIG_SYSVIPC_SYSCTL) += ipc_sysctl.o
 obj_mq-$(CONFIG_COMPAT) += compat_mq.o
 obj-$(CONFIG_POSIX_MQUEUE) += mqueue.o msgutil.o $(obj_mq-y)
diff -puN /dev/null ipc/syscall.c
--- /dev/null
+++ a/ipc/syscall.c
@@ -0,0 +1,99 @@
+/*
+ * sys_ipc() is the old de-multiplexer for the SysV IPC calls.
+ *
+ * This is really horribly ugly, and new architectures should just wire up
+ * the individual syscalls instead.
+ */
+#include <linux/unistd.h>
+
+#ifdef __ARCH_WANT_SYS_IPC
+#include <linux/errno.h>
+#include <linux/ipc.h>
+#include <linux/shm.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+
+SYSCALL_DEFINE6(ipc, unsigned int, call, int, first, int, second,
+		unsigned long, third, void __user *, ptr, long, fifth)
+{
+	int version, ret;
+
+	version = call >> 16; /* hack for backward compatibility */
+	call &= 0xffff;
+
+	switch (call) {
+	case SEMOP:
+		return sys_semtimedop(first, (struct sembuf __user *)ptr,
+				      second, NULL);
+	case SEMTIMEDOP:
+		return sys_semtimedop(first, (struct sembuf __user *)ptr,
+				      second,
+				      (const struct timespec __user *)fifth);
+
+	case SEMGET:
+		return sys_semget(first, second, third);
+	case SEMCTL: {
+		union semun fourth;
+		if (!ptr)
+			return -EINVAL;
+		if (get_user(fourth.__pad, (void __user * __user *) ptr))
+			return -EFAULT;
+		return sys_semctl(first, second, third, fourth);
+	}
+
+	case MSGSND:
+		return sys_msgsnd(first, (struct msgbuf __user *) ptr,
+				  second, third);
+	case MSGRCV:
+		switch (version) {
+		case 0: {
+			struct ipc_kludge tmp;
+			if (!ptr)
+				return -EINVAL;
+
+			if (copy_from_user(&tmp,
+					   (struct ipc_kludge __user *) ptr,
+					   sizeof(tmp)))
+				return -EFAULT;
+			return sys_msgrcv(first, tmp.msgp, second,
+					   tmp.msgtyp, third);
+		}
+		default:
+			return sys_msgrcv(first,
+					   (struct msgbuf __user *) ptr,
+					   second, fifth, third);
+		}
+	case MSGGET:
+		return sys_msgget((key_t) first, second);
+	case MSGCTL:
+		return sys_msgctl(first, second, (struct msqid_ds __user *)ptr);
+
+	case SHMAT:
+		switch (version) {
+		default: {
+			unsigned long raddr;
+			ret = do_shmat(first, (char __user *)ptr,
+				       second, &raddr);
+			if (ret)
+				return ret;
+			return put_user(raddr, (unsigned long __user *) third);
+		}
+		case 1:
+			/*
+			 * This was the entry point for kernel-originating calls
+			 * from iBCS2 in 2.2 days.
+			 */
+			return -EINVAL;
+		}
+	case SHMDT:
+		return sys_shmdt((char __user *)ptr);
+	case SHMGET:
+		return sys_shmget(first, second, third);
+	case SHMCTL:
+		return sys_shmctl(first, second,
+				   (struct shmid_ds __user *) ptr);
+	default:
+		return -ENOSYS;
+	}
+}
+#endif
diff -puN kernel/sys_ni.c~add-generic-sys_ipc-wrapper kernel/sys_ni.c
--- a/kernel/sys_ni.c~add-generic-sys_ipc-wrapper
+++ a/kernel/sys_ni.c
@@ -126,6 +126,7 @@ cond_syscall(sys_setreuid16);
 cond_syscall(sys_setuid16);
 cond_syscall(sys_vm86old);
 cond_syscall(sys_vm86);
+cond_syscall(sys_ipc);
 cond_syscall(compat_sys_ipc);
 cond_syscall(compat_sys_sysctl);
 cond_syscall(sys_flock);
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
xtensa-convert-to-asm-generic-hardirqh.patch
improve-sys_personality-for-compat-architectures.patch

