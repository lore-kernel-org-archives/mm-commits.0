From: akpm@linux-foundation.org
Subject: + compat-fs-generic-compat_sys_sendfile-implementation.patch added to -mm tree
Date: Wed, 19 Sep 2012 13:16:33 -0700
Message-ID: <20120919201633.B4D3E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:45284 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2ISUQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Sep 2012 16:16:35 -0400
Received: by yenq6 with SMTP id q6so195026yen.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Sep 2012 13:16:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, arnd@arndb.de, benh@kernel.crashing.org, davem@davemloft.net, paulus@samba.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: compat: fs: generic compat_sys_sendfile() implementation
has been added to the -mm tree.  Its filename is
     compat-fs-generic-compat_sys_sendfile-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: compat: fs: generic compat_sys_sendfile() implementation

This function is used by sparc, powerpc and arm64 for compat support.  The
patch adds a generic implementation which calls do_sendfile() directly and
avoids set_fs().

The sparc architecture has wrappers for the sign extensions while powerpc
relies on the compiler to do the this.  The patch adds wrappers for
powerpc to handle the u32->int type conversion.

compat_sys_sendfile64() can be replaced by a sys_sendfile() call since
compat_loff_t has the same size as off_t on a 64-bit system.

On powerpc, the patch also changes the 64-bit sendfile call from
sys_sendile64 to sys_sendfile.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/systbl.h |    4 +-
 arch/powerpc/include/asm/unistd.h |    1 
 arch/powerpc/kernel/sys_ppc32.c   |   45 ++++-----------------------
 arch/sparc/include/asm/unistd.h   |    1 
 arch/sparc/kernel/sys32.S         |    2 -
 arch/sparc/kernel/sys_sparc32.c   |   46 ----------------------------
 fs/compat.c                       |   22 +++++++++++++
 fs/read_write.c                   |    4 +-
 fs/read_write.h                   |    2 +
 include/linux/compat.h            |    3 +
 10 files changed, 41 insertions(+), 89 deletions(-)

diff -puN arch/powerpc/include/asm/systbl.h~compat-fs-generic-compat_sys_sendfile-implementation arch/powerpc/include/asm/systbl.h
--- a/arch/powerpc/include/asm/systbl.h~compat-fs-generic-compat_sys_sendfile-implementation
+++ a/arch/powerpc/include/asm/systbl.h
@@ -189,7 +189,7 @@ SYSCALL_SPU(getcwd)
 SYSCALL_SPU(capget)
 SYSCALL_SPU(capset)
 COMPAT_SYS(sigaltstack)
-SYSX_SPU(sys_sendfile64,compat_sys_sendfile,sys_sendfile)
+SYSX_SPU(sys_sendfile,compat_sys_sendfile_wrapper,sys_sendfile)
 SYSCALL(ni_syscall)
 SYSCALL(ni_syscall)
 PPC_SYS(vfork)
@@ -229,7 +229,7 @@ COMPAT_SYS_SPU(sched_setaffinity)
 COMPAT_SYS_SPU(sched_getaffinity)
 SYSCALL(ni_syscall)
 SYSCALL(ni_syscall)
-SYS32ONLY(sendfile64)
+SYSX(sys_ni_syscall,compat_sys_sendfile64_wrapper,sys_sendfile64)
 COMPAT_SYS_SPU(io_setup)
 SYSCALL_SPU(io_destroy)
 COMPAT_SYS_SPU(io_getevents)
diff -puN arch/powerpc/include/asm/unistd.h~compat-fs-generic-compat_sys_sendfile-implementation arch/powerpc/include/asm/unistd.h
--- a/arch/powerpc/include/asm/unistd.h~compat-fs-generic-compat_sys_sendfile-implementation
+++ a/arch/powerpc/include/asm/unistd.h
@@ -419,6 +419,7 @@
 #define __ARCH_WANT_COMPAT_SYS_TIME
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
 #define __ARCH_WANT_SYS_NEWFSTATAT
+#define __ARCH_WANT_COMPAT_SYS_SENDFILE
 #endif
 
 /*
diff -puN arch/powerpc/kernel/sys_ppc32.c~compat-fs-generic-compat_sys_sendfile-implementation arch/powerpc/kernel/sys_ppc32.c
--- a/arch/powerpc/kernel/sys_ppc32.c~compat-fs-generic-compat_sys_sendfile-implementation
+++ a/arch/powerpc/kernel/sys_ppc32.c
@@ -143,48 +143,17 @@ long compat_sys_ipc(u32 call, u32 first,
  * proper conversion (sign extension) between the register representation of a signed int (msr in 32-bit mode)
  * and the register representation of a signed int (msr in 64-bit mode) is performed.
  */
-asmlinkage long compat_sys_sendfile(u32 out_fd, u32 in_fd, compat_off_t __user * offset, u32 count)
+asmlinkage long compat_sys_sendfile_wrapper(u32 out_fd, u32 in_fd,
+					    compat_off_t __user *offset, u32 count)
 {
-	mm_segment_t old_fs = get_fs();
-	int ret;
-	off_t of;
-	off_t __user *up;
-
-	if (offset && get_user(of, offset))
-		return -EFAULT;
-
-	/* The __user pointer cast is valid because of the set_fs() */		
-	set_fs(KERNEL_DS);
-	up = offset ? (off_t __user *) &of : NULL;
-	ret = sys_sendfile((int)out_fd, (int)in_fd, up, count);
-	set_fs(old_fs);
-	
-	if (offset && put_user(of, offset))
-		return -EFAULT;
-		
-	return ret;
+	return compat_sys_sendfile((int)out_fd, (int)in_fd, offset, count);
 }
 
-asmlinkage int compat_sys_sendfile64(int out_fd, int in_fd, compat_loff_t __user *offset, s32 count)
+asmlinkage long compat_sys_sendfile64_wrapper(u32 out_fd, u32 in_fd,
+					      compat_loff_t __user *offset, u32 count)
 {
-	mm_segment_t old_fs = get_fs();
-	int ret;
-	loff_t lof;
-	loff_t __user *up;
-	
-	if (offset && get_user(lof, offset))
-		return -EFAULT;
-		
-	/* The __user pointer cast is valid because of the set_fs() */		
-	set_fs(KERNEL_DS);
-	up = offset ? (loff_t __user *) &lof : NULL;
-	ret = sys_sendfile64(out_fd, in_fd, up, count);
-	set_fs(old_fs);
-	
-	if (offset && put_user(lof, offset))
-		return -EFAULT;
-		
-	return ret;
+	return sys_sendfile((int)out_fd, (int)in_fd,
+			    (off_t __user *)offset, count);
 }
 
 long compat_sys_execve(unsigned long a0, unsigned long a1, unsigned long a2,
diff -puN arch/sparc/include/asm/unistd.h~compat-fs-generic-compat_sys_sendfile-implementation arch/sparc/include/asm/unistd.h
--- a/arch/sparc/include/asm/unistd.h~compat-fs-generic-compat_sys_sendfile-implementation
+++ a/arch/sparc/include/asm/unistd.h
@@ -447,6 +447,7 @@
 #else
 #define __ARCH_WANT_COMPAT_SYS_TIME
 #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
+#define __ARCH_WANT_COMPAT_SYS_SENDFILE
 #endif
 
 /*
diff -puN arch/sparc/kernel/sys32.S~compat-fs-generic-compat_sys_sendfile-implementation arch/sparc/kernel/sys32.S
--- a/arch/sparc/kernel/sys32.S~compat-fs-generic-compat_sys_sendfile-implementation
+++ a/arch/sparc/kernel/sys32.S
@@ -90,7 +90,7 @@ SIGN1(sys32_mkdir, sys_mkdir, %o1)
 SIGN3(sys32_futex, compat_sys_futex, %o1, %o2, %o5)
 SIGN1(sys32_sysfs, compat_sys_sysfs, %o0)
 SIGN2(sys32_sendfile, compat_sys_sendfile, %o0, %o1)
-SIGN2(sys32_sendfile64, compat_sys_sendfile64, %o0, %o1)
+SIGN2(sys32_sendfile64, sys_sendfile, %o0, %o1)
 SIGN1(sys32_prctl, sys_prctl, %o0)
 SIGN1(sys32_sched_rr_get_interval, compat_sys_sched_rr_get_interval, %o0)
 SIGN2(sys32_waitpid, sys_waitpid, %o0, %o2)
diff -puN arch/sparc/kernel/sys_sparc32.c~compat-fs-generic-compat_sys_sendfile-implementation arch/sparc/kernel/sys_sparc32.c
--- a/arch/sparc/kernel/sys_sparc32.c~compat-fs-generic-compat_sys_sendfile-implementation
+++ a/arch/sparc/kernel/sys_sparc32.c
@@ -506,52 +506,6 @@ long compat_sys_fadvise64_64(int fd,
 				advice);
 }
 
-asmlinkage long compat_sys_sendfile(int out_fd, int in_fd,
-				    compat_off_t __user *offset,
-				    compat_size_t count)
-{
-	mm_segment_t old_fs = get_fs();
-	int ret;
-	off_t of;
-	
-	if (offset && get_user(of, offset))
-		return -EFAULT;
-		
-	set_fs(KERNEL_DS);
-	ret = sys_sendfile(out_fd, in_fd,
-			   offset ? (off_t __user *) &of : NULL,
-			   count);
-	set_fs(old_fs);
-	
-	if (offset && put_user(of, offset))
-		return -EFAULT;
-		
-	return ret;
-}
-
-asmlinkage long compat_sys_sendfile64(int out_fd, int in_fd,
-				      compat_loff_t __user *offset,
-				      compat_size_t count)
-{
-	mm_segment_t old_fs = get_fs();
-	int ret;
-	loff_t lof;
-	
-	if (offset && get_user(lof, offset))
-		return -EFAULT;
-		
-	set_fs(KERNEL_DS);
-	ret = sys_sendfile64(out_fd, in_fd,
-			     offset ? (loff_t __user *) &lof : NULL,
-			     count);
-	set_fs(old_fs);
-	
-	if (offset && put_user(lof, offset))
-		return -EFAULT;
-		
-	return ret;
-}
-
 /* This is just a version for 32-bit applications which does
  * not force O_LARGEFILE on.
  */
diff -puN fs/compat.c~compat-fs-generic-compat_sys_sendfile-implementation fs/compat.c
--- a/fs/compat.c~compat-fs-generic-compat_sys_sendfile-implementation
+++ a/fs/compat.c
@@ -1802,3 +1802,25 @@ compat_sys_open_by_handle_at(int mountdi
 	return do_handle_open(mountdirfd, handle, flags);
 }
 #endif
+
+#ifdef __ARCH_WANT_COMPAT_SYS_SENDFILE
+asmlinkage long compat_sys_sendfile(int out_fd, int in_fd,
+				    compat_off_t __user *offset, compat_size_t count)
+{
+	loff_t pos;
+	off_t off;
+	ssize_t ret;
+
+	if (offset) {
+		if (unlikely(get_user(off, offset)))
+			return -EFAULT;
+		pos = off;
+		ret = do_sendfile(out_fd, in_fd, &pos, count, MAX_NON_LFS);
+		if (unlikely(put_user(pos, offset)))
+			return -EFAULT;
+		return ret;
+	}
+
+	return do_sendfile(out_fd, in_fd, NULL, count, 0);
+}
+#endif /* __ARCH_WANT_COMPAT_SYS_SENDFILE */
diff -puN fs/read_write.c~compat-fs-generic-compat_sys_sendfile-implementation fs/read_write.c
--- a/fs/read_write.c~compat-fs-generic-compat_sys_sendfile-implementation
+++ a/fs/read_write.c
@@ -884,8 +884,8 @@ SYSCALL_DEFINE5(pwritev, unsigned long, 
 	return ret;
 }
 
-static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
-			   size_t count, loff_t max)
+ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos, size_t count,
+		    loff_t max)
 {
 	struct file * in_file, * out_file;
 	struct inode * in_inode, * out_inode;
diff -puN fs/read_write.h~compat-fs-generic-compat_sys_sendfile-implementation fs/read_write.h
--- a/fs/read_write.h~compat-fs-generic-compat_sys_sendfile-implementation
+++ a/fs/read_write.h
@@ -12,3 +12,5 @@ ssize_t do_sync_readv_writev(struct file
 		unsigned long nr_segs, size_t len, loff_t *ppos, iov_fn_t fn);
 ssize_t do_loop_readv_writev(struct file *filp, struct iovec *iov,
 		unsigned long nr_segs, loff_t *ppos, io_fn_t fn);
+ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos, size_t count,
+		    loff_t max);
diff -puN include/linux/compat.h~compat-fs-generic-compat_sys_sendfile-implementation include/linux/compat.h
--- a/include/linux/compat.h~compat-fs-generic-compat_sys_sendfile-implementation
+++ a/include/linux/compat.h
@@ -594,6 +594,9 @@ asmlinkage ssize_t compat_sys_process_vm
 		unsigned long liovcnt, const struct compat_iovec __user *rvec,
 		unsigned long riovcnt, unsigned long flags);
 
+asmlinkage long compat_sys_sendfile(int out_fd, int in_fd,
+				    compat_off_t __user *offset, compat_size_t count);
+
 #else
 
 #define is_compat_task() (0)
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

linux-next.patch
rbtree-add-prio-tree-and-interval-tree-tests.patch
mm-replace-vma-prio_tree-with-an-interval-tree.patch
kmemleak-use-rbtree-instead-of-prio-tree.patch
prio_tree-remove.patch
rbtree-move-augmented-rbtree-functionality-to-rbtree_augmentedh.patch
mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear.patch
mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc.patch
compat-fs-generic-compat_sys_sendfile-implementation.patch

