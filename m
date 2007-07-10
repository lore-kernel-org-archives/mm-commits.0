From: akpm@linux-foundation.org
Subject: - fallocate-on-s390.patch removed from -mm tree
Date: Tue, 10 Jul 2007 02:13:54 -0700
Message-ID: <200707100913.l6A9DsgX020918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53583 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755858AbXGJJOg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 05:14:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarora@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, mark.fasheh@oracle.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fallocate() on s390
has been removed from the -mm tree.  Its filename was
     fallocate-on-s390.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: fallocate() on s390
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>

This is the patch suggested by Martin Schwidefsky to support sys_fallocate()
on s390(x) platform.

He also suggested a wrapper in glibc to handle this system call on s390. 
Posting it here so that we get feedback for this too.

.globl __fallocate
ENTRY(__fallocate)
	stm	%r6,%r7,28(%r15)	/* save %r6/%r7 on stack */
	cfi_offset (%r7, -68)
	cfi_offset (%r6, -72)
	lm	%r6,%r7,96(%r15)	/* load loff_t len from stack */
	svc	SYS_ify(fallocate)
	lm	%r6,%r7,28(%r15)	/* restore %r6/%r7 from stack */
	br	%r14
PSEUDO_END(__fallocate)

Here are the comments and the patch to linux kernel from him.


  This patch implements support of fallocate system call on s390(x)
  platform.  A wrapper is added to address the issue which s390 ABI has with
  the arguments of this system call.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/compat_wrapper.S |   10 +++++++++
 arch/s390/kernel/sys_s390.c       |   29 ++++++++++++++++++++++++++++
 arch/s390/kernel/syscalls.S       |    1 
 include/asm-s390/unistd.h         |    3 +-
 4 files changed, 42 insertions(+), 1 deletion(-)

diff -puN arch/s390/kernel/compat_wrapper.S~fallocate-on-s390 arch/s390/kernel/compat_wrapper.S
--- a/arch/s390/kernel/compat_wrapper.S~fallocate-on-s390
+++ a/arch/s390/kernel/compat_wrapper.S
@@ -1710,3 +1710,13 @@ compat_sys_timerfd_wrapper:
 sys_eventfd_wrapper:
 	llgfr	%r2,%r2			# unsigned int
 	jg	sys_eventfd
+
+	.globl  sys_fallocate_wrapper
+sys_fallocate_wrapper:
+	lgfr	%r2,%r2			# int
+	lgfr	%r3,%r3			# int
+	sllg    %r4,%r4,32		# get high word of 64bit loff_t
+	lr      %r4,%r5			# get low word of 64bit loff_t
+	sllg    %r5,%r6,32		# get high word of 64bit loff_t
+	l	%r5,164(%r15)		# get low word of 64bit loff_t
+	jg	sys_fallocate
diff -puN arch/s390/kernel/sys_s390.c~fallocate-on-s390 arch/s390/kernel/sys_s390.c
--- a/arch/s390/kernel/sys_s390.c~fallocate-on-s390
+++ a/arch/s390/kernel/sys_s390.c
@@ -265,3 +265,32 @@ s390_fadvise64_64(struct fadvise64_64_ar
 		return -EFAULT;
 	return sys_fadvise64_64(a.fd, a.offset, a.len, a.advice);
 }
+
+#ifndef CONFIG_64BIT
+/*
+ * This is a wrapper to call sys_fallocate(). For 31 bit s390 the last
+ * 64 bit argument "len" is split into the upper and lower 32 bits. The
+ * system call wrapper in the user space loads the value to %r6/%r7.
+ * The code in entry.S keeps the values in %r2 - %r6 where they are and
+ * stores %r7 to 96(%r15). But the standard C linkage requires that
+ * the whole 64 bit value for len is stored on the stack and doesn't
+ * use %r6 at all. So s390_fallocate has to convert the arguments from
+ *   %r2: fd, %r3: mode, %r4/%r5: offset, %r6/96(%r15)-99(%r15): len
+ * to
+ *   %r2: fd, %r3: mode, %r4/%r5: offset, 96(%r15)-103(%r15): len
+ */
+asmlinkage long s390_fallocate(int fd, int mode, loff_t offset,
+			       u32 len_high, u32 len_low)
+{
+	union {
+		u64 len;
+		struct {
+			u32 high;
+			u32 low;
+		};
+	} cv;
+	cv.high = len_high;
+	cv.low = len_low;
+	return sys_fallocate(fd, mode, offset, cv.len);
+}
+#endif
diff -puN arch/s390/kernel/syscalls.S~fallocate-on-s390 arch/s390/kernel/syscalls.S
--- a/arch/s390/kernel/syscalls.S~fallocate-on-s390
+++ a/arch/s390/kernel/syscalls.S
@@ -327,3 +327,4 @@ SYSCALL(sys_utimensat,sys_utimensat,comp
 SYSCALL(sys_signalfd,sys_signalfd,compat_sys_signalfd_wrapper)
 SYSCALL(sys_timerfd,sys_timerfd,compat_sys_timerfd_wrapper)
 SYSCALL(sys_eventfd,sys_eventfd,sys_eventfd_wrapper)
+SYSCALL(s390_fallocate,sys_fallocate,sys_fallocate_wrapper)
diff -puN include/asm-s390/unistd.h~fallocate-on-s390 include/asm-s390/unistd.h
--- a/include/asm-s390/unistd.h~fallocate-on-s390
+++ a/include/asm-s390/unistd.h
@@ -256,7 +256,8 @@
 #define __NR_signalfd		316
 #define __NR_timerfd		317
 #define __NR_eventfd		318
-#define NR_syscalls 319
+#define __NR_fallocate		319
+#define NR_syscalls 320
 
 /* 
  * There are some system calls that are not present on 64 bit, some
_

Patches currently in -mm which might be from aarora@linux.vnet.ibm.com are

fallocate-implementation-on-i86-x86_64-and-powerpc.patch
fallocate-on-s390.patch
