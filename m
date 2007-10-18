From: akpm@linux-foundation.org
Subject: - remove-include-asm-ipch.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:15 -0700
Message-ID: <200710180659.l9I6xFW7030967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47573 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754829AbXJRG7d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 02:59:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     remove include/asm-*/ipc.h
has been removed from the -mm tree.  Its filename was
     remove-include-asm-ipch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove include/asm-*/ipc.h
From: Adrian Bunk <bunk@kernel.org>

All asm/ipc.h files do only #include <asm-generic/ipc.h>.

This patch therefore removes all include/asm-*/ipc.h files and moves the
contents of include/asm-generic/ipc.h to include/linux/ipc.h.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/sys_arm.c         |    2 -
 arch/arm/kernel/sys_oabi-compat.c |    2 -
 arch/cris/kernel/sys_cris.c       |    2 -
 arch/frv/kernel/sys_frv.c         |    2 -
 arch/h8300/kernel/sys_h8300.c     |    2 -
 arch/m32r/kernel/sys_m32r.c       |    2 -
 arch/m68k/kernel/sys_m68k.c       |    2 -
 arch/m68knommu/kernel/sys_m68k.c  |    2 -
 arch/mips/kernel/linux32.c        |    2 -
 arch/mips/kernel/syscall.c        |    2 -
 arch/powerpc/kernel/sys_ppc32.c   |    2 -
 arch/powerpc/kernel/syscalls.c    |    1 
 arch/s390/kernel/compat_linux.c   |    2 -
 arch/s390/kernel/sys_s390.c       |    2 -
 arch/sh/kernel/sys_sh.c           |    2 -
 arch/sh64/kernel/sys_sh64.c       |    2 -
 arch/sparc/kernel/sys_sparc.c     |    2 -
 arch/sparc64/kernel/sys_sparc.c   |    1 
 arch/sparc64/kernel/sys_sparc32.c |    1 
 arch/sparc64/solaris/ipc.c        |    2 -
 arch/um/sys-i386/syscalls.c       |    2 -
 arch/v850/kernel/syscalls.c       |    1 
 arch/x86/ia32/ipc32.c             |    2 -
 arch/x86/kernel/sys_i386_32.c     |    2 -
 include/asm-arm/ipc.h             |    1 
 include/asm-blackfin/ipc.h        |    1 
 include/asm-cris/ipc.h            |    1 
 include/asm-frv/ipc.h             |    1 
 include/asm-generic/Kbuild        |    1 
 include/asm-generic/ipc.h         |   31 ----------------------------
 include/asm-h8300/ipc.h           |    1 
 include/asm-m32r/ipc.h            |    1 
 include/asm-m68k/ipc.h            |    1 
 include/asm-m68knommu/ipc.h       |    1 
 include/asm-mips/ipc.h            |    1 
 include/asm-powerpc/Kbuild        |    1 
 include/asm-powerpc/ipc.h         |    1 
 include/asm-s390/ipc.h            |    1 
 include/asm-sh/ipc.h              |    1 
 include/asm-sh64/ipc.h            |    1 
 include/asm-sparc/ipc.h           |    1 
 include/asm-sparc64/Kbuild        |    1 
 include/asm-sparc64/ipc.h         |    1 
 include/asm-um/ipc.h              |    1 
 include/asm-v850/ipc.h            |    1 
 include/asm-x86/ipc.h             |    1 
 include/linux/ipc.h               |   28 +++++++++++++++++++++++++
 47 files changed, 47 insertions(+), 77 deletions(-)

diff -puN arch/arm/kernel/sys_arm.c~remove-include-asm-ipch arch/arm/kernel/sys_arm.c
--- a/arch/arm/kernel/sys_arm.c~remove-include-asm-ipch
+++ a/arch/arm/kernel/sys_arm.c
@@ -26,9 +26,9 @@
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
+#include <linux/ipc.h>
 
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 
 extern unsigned long do_mremap(unsigned long addr, unsigned long old_len,
 			       unsigned long new_len, unsigned long flags,
diff -puN arch/arm/kernel/sys_oabi-compat.c~remove-include-asm-ipch arch/arm/kernel/sys_oabi-compat.c
--- a/arch/arm/kernel/sys_oabi-compat.c~remove-include-asm-ipch
+++ a/arch/arm/kernel/sys_oabi-compat.c
@@ -80,7 +80,7 @@
 #include <linux/sem.h>
 #include <linux/socket.h>
 #include <linux/net.h>
-#include <asm/ipc.h>
+#include <linux/ipc.h>
 #include <asm/uaccess.h>
 
 struct oldabi_stat64 {
diff -puN arch/cris/kernel/sys_cris.c~remove-include-asm-ipch arch/cris/kernel/sys_cris.c
--- a/arch/cris/kernel/sys_cris.c~remove-include-asm-ipch
+++ a/arch/cris/kernel/sys_cris.c
@@ -21,9 +21,9 @@
 #include <linux/stat.h>
 #include <linux/mman.h>
 #include <linux/file.h>
+#include <linux/ipc.h>
 
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 #include <asm/segment.h>
 
 /*
diff -puN arch/frv/kernel/sys_frv.c~remove-include-asm-ipch arch/frv/kernel/sys_frv.c
--- a/arch/frv/kernel/sys_frv.c~remove-include-asm-ipch
+++ a/arch/frv/kernel/sys_frv.c
@@ -23,10 +23,10 @@
 #include <linux/file.h>
 #include <linux/utsname.h>
 #include <linux/syscalls.h>
+#include <linux/ipc.h>
 
 #include <asm/setup.h>
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 
 /*
  * sys_pipe() is the normal C calling standard for creating
diff -puN arch/h8300/kernel/sys_h8300.c~remove-include-asm-ipch arch/h8300/kernel/sys_h8300.c
--- a/arch/h8300/kernel/sys_h8300.c~remove-include-asm-ipch
+++ a/arch/h8300/kernel/sys_h8300.c
@@ -19,12 +19,12 @@
 #include <linux/file.h>
 #include <linux/utsname.h>
 #include <linux/fs.h>
+#include <linux/ipc.h>
 
 #include <asm/setup.h>
 #include <asm/uaccess.h>
 #include <asm/cachectl.h>
 #include <asm/traps.h>
-#include <asm/ipc.h>
 #include <asm/unistd.h>
 
 /*
diff -puN arch/m32r/kernel/sys_m32r.c~remove-include-asm-ipch arch/m32r/kernel/sys_m32r.c
--- a/arch/m32r/kernel/sys_m32r.c~remove-include-asm-ipch
+++ a/arch/m32r/kernel/sys_m32r.c
@@ -20,11 +20,11 @@
 #include <linux/mman.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
+#include <linux/ipc.h>
 
 #include <asm/uaccess.h>
 #include <asm/cachectl.h>
 #include <asm/cacheflush.h>
-#include <asm/ipc.h>
 #include <asm/syscall.h>
 #include <asm/unistd.h>
 
diff -puN arch/m68k/kernel/sys_m68k.c~remove-include-asm-ipch arch/m68k/kernel/sys_m68k.c
--- a/arch/m68k/kernel/sys_m68k.c~remove-include-asm-ipch
+++ a/arch/m68k/kernel/sys_m68k.c
@@ -21,12 +21,12 @@
 #include <linux/mman.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
+#include <linux/ipc.h>
 
 #include <asm/setup.h>
 #include <asm/uaccess.h>
 #include <asm/cachectl.h>
 #include <asm/traps.h>
-#include <asm/ipc.h>
 #include <asm/page.h>
 #include <asm/unistd.h>
 
diff -puN arch/m68knommu/kernel/sys_m68k.c~remove-include-asm-ipch arch/m68knommu/kernel/sys_m68k.c
--- a/arch/m68knommu/kernel/sys_m68k.c~remove-include-asm-ipch
+++ a/arch/m68knommu/kernel/sys_m68k.c
@@ -18,13 +18,13 @@
 #include <linux/mman.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
+#include <linux/ipc.h>
 #include <linux/fs.h>
 
 #include <asm/setup.h>
 #include <asm/uaccess.h>
 #include <asm/cachectl.h>
 #include <asm/traps.h>
-#include <asm/ipc.h>
 #include <asm/cacheflush.h>
 #include <asm/unistd.h>
 
diff -puN arch/mips/kernel/linux32.c~remove-include-asm-ipch arch/mips/kernel/linux32.c
--- a/arch/mips/kernel/linux32.c~remove-include-asm-ipch
+++ a/arch/mips/kernel/linux32.c
@@ -35,12 +35,12 @@
 #include <linux/security.h>
 #include <linux/compat.h>
 #include <linux/vfs.h>
+#include <linux/ipc.h>
 
 #include <net/sock.h>
 #include <net/scm.h>
 
 #include <asm/compat-signal.h>
-#include <asm/ipc.h>
 #include <asm/sim.h>
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
diff -puN arch/mips/kernel/syscall.c~remove-include-asm-ipch arch/mips/kernel/syscall.c
--- a/arch/mips/kernel/syscall.c~remove-include-asm-ipch
+++ a/arch/mips/kernel/syscall.c
@@ -28,11 +28,11 @@
 #include <linux/shm.h>
 #include <linux/compiler.h>
 #include <linux/module.h>
+#include <linux/ipc.h>
 
 #include <asm/branch.h>
 #include <asm/cachectl.h>
 #include <asm/cacheflush.h>
-#include <asm/ipc.h>
 #include <asm/asm-offsets.h>
 #include <asm/signal.h>
 #include <asm/sim.h>
diff -puN arch/powerpc/kernel/sys_ppc32.c~remove-include-asm-ipch arch/powerpc/kernel/sys_ppc32.c
--- a/arch/powerpc/kernel/sys_ppc32.c~remove-include-asm-ipch
+++ a/arch/powerpc/kernel/sys_ppc32.c
@@ -41,10 +41,10 @@
 #include <linux/compat.h>
 #include <linux/ptrace.h>
 #include <linux/elf.h>
+#include <linux/ipc.h>
 
 #include <asm/ptrace.h>
 #include <asm/types.h>
-#include <asm/ipc.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include <asm/semaphore.h>
diff -puN arch/powerpc/kernel/syscalls.c~remove-include-asm-ipch arch/powerpc/kernel/syscalls.c
--- a/arch/powerpc/kernel/syscalls.c~remove-include-asm-ipch
+++ a/arch/powerpc/kernel/syscalls.c
@@ -38,7 +38,6 @@
 #include <linux/personality.h>
 
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 #include <asm/semaphore.h>
 #include <asm/syscalls.h>
 #include <asm/time.h>
diff -puN arch/s390/kernel/compat_linux.c~remove-include-asm-ipch arch/s390/kernel/compat_linux.c
--- a/arch/s390/kernel/compat_linux.c~remove-include-asm-ipch
+++ a/arch/s390/kernel/compat_linux.c
@@ -58,9 +58,9 @@
 #include <linux/vfs.h>
 #include <linux/ptrace.h>
 #include <linux/fadvise.h>
+#include <linux/ipc.h>
 
 #include <asm/types.h>
-#include <asm/ipc.h>
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 
diff -puN arch/s390/kernel/sys_s390.c~remove-include-asm-ipch arch/s390/kernel/sys_s390.c
--- a/arch/s390/kernel/sys_s390.c~remove-include-asm-ipch
+++ a/arch/s390/kernel/sys_s390.c
@@ -28,9 +28,9 @@
 #include <linux/utsname.h>
 #include <linux/personality.h>
 #include <linux/unistd.h>
+#include <linux/ipc.h>
 
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 
 /*
  * sys_pipe() is the normal C calling standard for creating
diff -puN arch/sh/kernel/sys_sh.c~remove-include-asm-ipch arch/sh/kernel/sys_sh.c
--- a/arch/sh/kernel/sys_sh.c~remove-include-asm-ipch
+++ a/arch/sh/kernel/sys_sh.c
@@ -22,9 +22,9 @@
 #include <linux/utsname.h>
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/ipc.h>
 #include <asm/cacheflush.h>
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 #include <asm/unistd.h>
 
 /*
diff -puN arch/sh64/kernel/sys_sh64.c~remove-include-asm-ipch arch/sh64/kernel/sys_sh64.c
--- a/arch/sh64/kernel/sys_sh64.c~remove-include-asm-ipch
+++ a/arch/sh64/kernel/sys_sh64.c
@@ -29,8 +29,8 @@
 #include <linux/file.h>
 #include <linux/utsname.h>
 #include <linux/syscalls.h>
+#include <linux/ipc.h>
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 #include <asm/ptrace.h>
 #include <asm/unistd.h>
 
diff -puN arch/sparc/kernel/sys_sparc.c~remove-include-asm-ipch arch/sparc/kernel/sys_sparc.c
--- a/arch/sparc/kernel/sys_sparc.c~remove-include-asm-ipch
+++ a/arch/sparc/kernel/sys_sparc.c
@@ -21,9 +21,9 @@
 #include <linux/utsname.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
+#include <linux/ipc.h>
 
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 #include <asm/unistd.h>
 
 /* #define DEBUG_UNIMP_SYSCALL */
diff -puN arch/sparc64/kernel/sys_sparc.c~remove-include-asm-ipch arch/sparc64/kernel/sys_sparc.c
--- a/arch/sparc64/kernel/sys_sparc.c~remove-include-asm-ipch
+++ a/arch/sparc64/kernel/sys_sparc.c
@@ -26,7 +26,6 @@
 #include <linux/random.h>
 
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 #include <asm/utrap.h>
 #include <asm/perfctr.h>
 #include <asm/a.out.h>
diff -puN arch/sparc64/kernel/sys_sparc32.c~remove-include-asm-ipch arch/sparc64/kernel/sys_sparc32.c
--- a/arch/sparc64/kernel/sys_sparc32.c~remove-include-asm-ipch
+++ a/arch/sparc64/kernel/sys_sparc32.c
@@ -54,7 +54,6 @@
 #include <linux/highuid.h>
 
 #include <asm/types.h>
-#include <asm/ipc.h>
 #include <asm/uaccess.h>
 #include <asm/fpumacro.h>
 #include <asm/semaphore.h>
diff -puN arch/sparc64/solaris/ipc.c~remove-include-asm-ipch arch/sparc64/solaris/ipc.c
--- a/arch/sparc64/solaris/ipc.c~remove-include-asm-ipch
+++ a/arch/sparc64/solaris/ipc.c
@@ -11,10 +11,10 @@
 #include <linux/shm.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
+#include <linux/ipc.h>
 
 #include <asm/uaccess.h>
 #include <asm/string.h>
-#include <asm/ipc.h>
 
 #include "conv.h"
 
diff -puN arch/um/sys-i386/syscalls.c~remove-include-asm-ipch arch/um/sys-i386/syscalls.c
--- a/arch/um/sys-i386/syscalls.c~remove-include-asm-ipch
+++ a/arch/um/sys-i386/syscalls.c
@@ -5,7 +5,7 @@
 
 #include "linux/sched.h"
 #include "linux/shm.h"
-#include "asm/ipc.h"
+#include "linux/ipc.h"
 #include "asm/mman.h"
 #include "asm/uaccess.h"
 #include "asm/unistd.h"
diff -puN arch/v850/kernel/syscalls.c~remove-include-asm-ipch arch/v850/kernel/syscalls.c
--- a/arch/v850/kernel/syscalls.c~remove-include-asm-ipch
+++ a/arch/v850/kernel/syscalls.c
@@ -30,7 +30,6 @@
 #include <linux/file.h>
 
 #include <asm/uaccess.h>
-#include <asm/ipc.h>
 #include <asm/semaphore.h>
 #include <asm/unistd.h>
 
diff -puN arch/x86/ia32/ipc32.c~remove-include-asm-ipch arch/x86/ia32/ipc32.c
--- a/arch/x86/ia32/ipc32.c~remove-include-asm-ipch
+++ a/arch/x86/ia32/ipc32.c
@@ -9,8 +9,6 @@
 #include <linux/ipc.h>
 #include <linux/compat.h>
 
-#include <asm/ipc.h>
-
 asmlinkage long
 sys32_ipc(u32 call, int first, int second, int third,
 		compat_uptr_t ptr, u32 fifth)
diff -puN arch/x86/kernel/sys_i386_32.c~remove-include-asm-ipch arch/x86/kernel/sys_i386_32.c
--- a/arch/x86/kernel/sys_i386_32.c~remove-include-asm-ipch
+++ a/arch/x86/kernel/sys_i386_32.c
@@ -17,10 +17,10 @@
 #include <linux/mman.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
+#include <linux/ipc.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
-#include <asm/ipc.h>
 
 /*
  * sys_pipe() is the normal C calling standard for creating
diff -puN include/asm-arm/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-arm/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-blackfin/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-blackfin/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-cris/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-cris/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-frv/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-frv/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-generic/Kbuild~remove-include-asm-ipch include/asm-generic/Kbuild
--- a/include/asm-generic/Kbuild~remove-include-asm-ipch
+++ a/include/asm-generic/Kbuild
@@ -2,7 +2,6 @@ header-y += errno-base.h
 header-y += errno.h
 header-y += fcntl.h
 header-y += ioctl.h
-header-y += ipc.h
 header-y += mman.h
 header-y += poll.h
 header-y += signal.h
diff -puN include/asm-generic/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-generic/ipc.h
+++ /dev/null
@@ -1,31 +0,0 @@
-#ifndef _ASM_GENERIC_IPC_H
-#define _ASM_GENERIC_IPC_H
-/*
- * These are used to wrap system calls.
- *
- * See architecture code for ugly details..
- */
-struct ipc_kludge {
-	struct msgbuf __user *msgp;
-	long msgtyp;
-};
-
-#define SEMOP		 1
-#define SEMGET		 2
-#define SEMCTL		 3
-#define SEMTIMEDOP	 4
-#define MSGSND		11
-#define MSGRCV		12
-#define MSGGET		13
-#define MSGCTL		14
-#define SHMAT		21
-#define SHMDT		22
-#define SHMGET		23
-#define SHMCTL		24
-
-/* Used by the DIPC package, try and avoid reusing it */
-#define DIPC            25
-
-#define IPCCALL(version,op)	((version)<<16 | (op))
-
-#endif	/* _ASM_GENERIC_IPC_H */
diff -puN include/asm-h8300/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-h8300/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-m32r/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-m32r/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-m68k/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-m68k/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-m68knommu/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-m68knommu/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-mips/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-mips/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-powerpc/Kbuild~remove-include-asm-ipch include/asm-powerpc/Kbuild
--- a/include/asm-powerpc/Kbuild~remove-include-asm-ipch
+++ a/include/asm-powerpc/Kbuild
@@ -13,7 +13,6 @@ header-y += shmbuf.h
 header-y += socket.h
 header-y += termbits.h
 header-y += fcntl.h
-header-y += ipc.h
 header-y += poll.h
 header-y += sockios.h
 header-y += ucontext.h
diff -puN include/asm-powerpc/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-powerpc/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-s390/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-s390/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-sh/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-sh/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-sh64/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-sh64/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-sparc/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-sparc/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-sparc64/Kbuild~remove-include-asm-ipch include/asm-sparc64/Kbuild
--- a/include/asm-sparc64/Kbuild~remove-include-asm-ipch
+++ a/include/asm-sparc64/Kbuild
@@ -10,7 +10,6 @@ header-y += bbc.h
 header-y += bpp.h
 header-y += display7seg.h
 header-y += envctrl.h
-header-y += ipc.h
 header-y += openprom.h
 header-y += openpromio.h
 header-y += pconf.h
diff -puN include/asm-sparc64/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-sparc64/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-um/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-um/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-v850/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-v850/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/asm-x86/ipc.h~remove-include-asm-ipch /dev/null
--- a/include/asm-x86/ipc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ipc.h>
diff -puN include/linux/ipc.h~remove-include-asm-ipch include/linux/ipc.h
--- a/include/linux/ipc.h~remove-include-asm-ipch
+++ a/include/linux/ipc.h
@@ -49,6 +49,34 @@ struct ipc_perm
 #define IPC_64  0x0100  /* New version (support 32-bit UIDs, bigger
 			   message sizes, etc. */
 
+/*
+ * These are used to wrap system calls.
+ *
+ * See architecture code for ugly details..
+ */
+struct ipc_kludge {
+	struct msgbuf __user *msgp;
+	long msgtyp;
+};
+
+#define SEMOP		 1
+#define SEMGET		 2
+#define SEMCTL		 3
+#define SEMTIMEDOP	 4
+#define MSGSND		11
+#define MSGRCV		12
+#define MSGGET		13
+#define MSGCTL		14
+#define SHMAT		21
+#define SHMDT		22
+#define SHMGET		23
+#define SHMCTL		24
+
+/* Used by the DIPC package, try and avoid reusing it */
+#define DIPC            25
+
+#define IPCCALL(version,op)	((version)<<16 | (op))
+
 #ifdef __KERNEL__
 
 #include <linux/kref.h>
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-nfs-make-nfs_wb_page_priority-static.patch
drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch
make-kernel-power-maincsuspend_enter-static.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
