From: akpm@linux-foundation.org
Subject: - introduce-fixed-sys_sync_file_range2-syscall-implement-on.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:41:10 -0700
Message-ID: <200706292041.l5TKfAQH022556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34905 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755240AbXF2Uux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwmw2@infradead.org, arnd@arndb.de, paulus@samba.org, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Introduce fixed sys_sync_file_range2() syscall, implement on PowerPC and ARM
has been removed from the -mm tree.  Its filename was
     introduce-fixed-sys_sync_file_range2-syscall-implement-on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Introduce fixed sys_sync_file_range2() syscall, implement on PowerPC and ARM
From: David Woodhouse <dwmw2@infradead.org>

Not all the world is an i386.  Many architectures need 64-bit arguments to be
aligned in suitable pairs of registers, and the original
sys_sync_file_range(int, loff_t, loff_t, int) was therefore wasting an
argument register for padding after the first integer.  Since we don't
normally have more than 6 arguments for system calls, that left no room for
the final argument on some architectures.

Fix this by introducing sys_sync_file_range2(int, int, loff_t, loff_t) which
all fits nicely.  In fact, ARM already had that, but called it
sys_arm_sync_file_range.  Move it to fs/sync.c and rename it, then implement
the needed compatibility routine.  And stop the missing syscall check from
bitching about the absence of sys_sync_file_range() if we've implemented
sys_sync_file_range2() instead.

Tested on PPC32 and with 32-bit and 64-bit userspace on PPC64.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/calls.S         |    2 +-
 arch/arm/kernel/sys_arm.c       |   13 -------------
 arch/powerpc/kernel/sys_ppc32.c |    9 +++++++++
 fs/sync.c                       |    8 ++++++++
 include/asm-arm/unistd.h        |    1 +
 include/asm-powerpc/systbl.h    |    1 +
 include/asm-powerpc/unistd.h    |    3 ++-
 include/linux/syscalls.h        |    2 ++
 scripts/checksyscalls.sh        |    5 +++++
 9 files changed, 29 insertions(+), 15 deletions(-)

diff -puN arch/arm/kernel/calls.S~introduce-fixed-sys_sync_file_range2-syscall-implement-on arch/arm/kernel/calls.S
--- a/arch/arm/kernel/calls.S~introduce-fixed-sys_sync_file_range2-syscall-implement-on
+++ a/arch/arm/kernel/calls.S
@@ -350,7 +350,7 @@
 		CALL(sys_set_robust_list)
 		CALL(sys_get_robust_list)
 /* 340 */	CALL(sys_splice)
-		CALL(sys_arm_sync_file_range)
+		CALL(sys_sync_file_range2)
 		CALL(sys_tee)
 		CALL(sys_vmsplice)
 		CALL(sys_move_pages)
diff -puN arch/arm/kernel/sys_arm.c~introduce-fixed-sys_sync_file_range2-syscall-implement-on arch/arm/kernel/sys_arm.c
--- a/arch/arm/kernel/sys_arm.c~introduce-fixed-sys_sync_file_range2-syscall-implement-on
+++ a/arch/arm/kernel/sys_arm.c
@@ -328,16 +328,3 @@ asmlinkage long sys_arm_fadvise64_64(int
 {
 	return sys_fadvise64_64(fd, offset, len, advice);
 }
-
-/*
- * Yet more syscall fsckage - we can't fit sys_sync_file_range's
- * arguments into the available registers with EABI.  So, let's
- * create an ARM specific syscall for this which has _sane_
- * arguments.  (This incidentally also has an ABI-independent
- * argument layout.)
- */
-asmlinkage long sys_arm_sync_file_range(int fd, unsigned int flags,
-					loff_t offset, loff_t nbytes)
-{
-	return sys_sync_file_range(fd, offset, nbytes, flags);
-}
diff -puN arch/powerpc/kernel/sys_ppc32.c~introduce-fixed-sys_sync_file_range2-syscall-implement-on arch/powerpc/kernel/sys_ppc32.c
--- a/arch/powerpc/kernel/sys_ppc32.c~introduce-fixed-sys_sync_file_range2-syscall-implement-on
+++ a/arch/powerpc/kernel/sys_ppc32.c
@@ -810,3 +810,12 @@ asmlinkage long compat_sys_request_key(c
 	return sys_request_key(_type, _description, _callout_info, destringid);
 }
 
+asmlinkage long compat_sys_sync_file_range2(int fd, unsigned int flags,
+				   unsigned offset_hi, unsigned offset_lo,
+				   unsigned nbytes_hi, unsigned nbytes_lo)
+{
+	loff_t offset = ((loff_t)offset_hi << 32) | offset_lo;
+	loff_t nbytes = ((loff_t)nbytes_hi << 32) | nbytes_lo;
+
+	return sys_sync_file_range(fd, offset, nbytes, flags);
+}
diff -puN fs/sync.c~introduce-fixed-sys_sync_file_range2-syscall-implement-on fs/sync.c
--- a/fs/sync.c~introduce-fixed-sys_sync_file_range2-syscall-implement-on
+++ a/fs/sync.c
@@ -236,6 +236,14 @@ out:
 	return ret;
 }
 
+/* It would be nice if people remember that not all the world's an i386
+   when they introduce new system calls */
+asmlinkage long sys_sync_file_range2(int fd, unsigned int flags,
+				     loff_t offset, loff_t nbytes)
+{
+	return sys_sync_file_range(fd, offset, nbytes, flags);
+}
+
 /*
  * `endbyte' is inclusive
  */
diff -puN include/asm-arm/unistd.h~introduce-fixed-sys_sync_file_range2-syscall-implement-on include/asm-arm/unistd.h
--- a/include/asm-arm/unistd.h~introduce-fixed-sys_sync_file_range2-syscall-implement-on
+++ a/include/asm-arm/unistd.h
@@ -367,6 +367,7 @@
 #define __NR_get_robust_list		(__NR_SYSCALL_BASE+339)
 #define __NR_splice			(__NR_SYSCALL_BASE+340)
 #define __NR_arm_sync_file_range	(__NR_SYSCALL_BASE+341)
+#define __NR_sync_file_range2		__NR_arm_sync_file_range
 #define __NR_tee			(__NR_SYSCALL_BASE+342)
 #define __NR_vmsplice			(__NR_SYSCALL_BASE+343)
 #define __NR_move_pages			(__NR_SYSCALL_BASE+344)
diff -puN include/asm-powerpc/systbl.h~introduce-fixed-sys_sync_file_range2-syscall-implement-on include/asm-powerpc/systbl.h
--- a/include/asm-powerpc/systbl.h~introduce-fixed-sys_sync_file_range2-syscall-implement-on
+++ a/include/asm-powerpc/systbl.h
@@ -311,3 +311,4 @@ COMPAT_SYS_SPU(utimensat)
 COMPAT_SYS_SPU(signalfd)
 COMPAT_SYS_SPU(timerfd)
 SYSCALL_SPU(eventfd)
+COMPAT_SYS_SPU(sync_file_range2)
diff -puN include/asm-powerpc/unistd.h~introduce-fixed-sys_sync_file_range2-syscall-implement-on include/asm-powerpc/unistd.h
--- a/include/asm-powerpc/unistd.h~introduce-fixed-sys_sync_file_range2-syscall-implement-on
+++ a/include/asm-powerpc/unistd.h
@@ -330,10 +330,11 @@
 #define __NR_signalfd		305
 #define __NR_timerfd		306
 #define __NR_eventfd		307
+#define __NR_sync_file_range2	308
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		308
+#define __NR_syscalls		309
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
diff -puN include/linux/syscalls.h~introduce-fixed-sys_sync_file_range2-syscall-implement-on include/linux/syscalls.h
--- a/include/linux/syscalls.h~introduce-fixed-sys_sync_file_range2-syscall-implement-on
+++ a/include/linux/syscalls.h
@@ -598,6 +598,8 @@ asmlinkage long sys_tee(int fdin, int fd
 
 asmlinkage long sys_sync_file_range(int fd, loff_t offset, loff_t nbytes,
 					unsigned int flags);
+asmlinkage long sys_sync_file_range2(int fd, unsigned int flags,
+				     loff_t offset, loff_t nbytes);
 asmlinkage long sys_get_robust_list(int pid,
 				    struct robust_list_head __user * __user *head_ptr,
 				    size_t __user *len_ptr);
diff -puN scripts/checksyscalls.sh~introduce-fixed-sys_sync_file_range2-syscall-implement-on scripts/checksyscalls.sh
--- a/scripts/checksyscalls.sh~introduce-fixed-sys_sync_file_range2-syscall-implement-on
+++ a/scripts/checksyscalls.sh
@@ -99,6 +99,11 @@ cat << EOF
 #define __IGNORE_setfsuid32
 #define __IGNORE_setfsgid32
 
+/* sync_file_range had a stupid ABI. Allow sync_file_range2 instead */
+#ifdef __NR_sync_file_range2
+#define __IGNORE_sync_file_range
+#endif
+
 /* Unmerged syscalls for AFS, STREAMS, etc. */
 #define __IGNORE_afs_syscall
 #define __IGNORE_getpmsg
_

Patches currently in -mm which might be from dwmw2@infradead.org are

origin.patch
git-powerpc.patch
powerpc-enable-arbitary-speed-tty-ioctls-and-split.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-ubi.patch
git-battery.patch
git-nfs.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used-fix.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used-fix-fix.patch
jffs2-convert-to-new-aops.patch
char-n_r3964-use-wait_event_interruptible.patch
introduce-compat_u64-and-compat_s64-types.patch
mismatching-declarations-of-revision-strings-in-hisax.patch
