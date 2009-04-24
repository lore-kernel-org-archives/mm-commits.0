From: akpm@linux-foundation.org
Subject: + alpha-futex-implementation.patch added to -mm tree
Date: Fri, 24 Apr 2009 13:12:47 -0700
Message-ID: <200904242012.n3OKCljf006350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262AbZDXUPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 16:15:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, rth@twiddle.net, viro@ZenIV.linux.org.uk


The patch titled
     alpha: futex implementation
has been added to the -mm tree.  Its filename is
     alpha-futex-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: futex implementation
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Richard Henderson <rth@twiddle.net
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/barrier.h |    2 
 arch/alpha/include/asm/futex.h   |  118 ++++++++++++++++++++++++++++-
 2 files changed, 116 insertions(+), 4 deletions(-)

diff -puN arch/alpha/include/asm/barrier.h~alpha-futex-implementation arch/alpha/include/asm/barrier.h
--- a/arch/alpha/include/asm/barrier.h~alpha-futex-implementation
+++ a/arch/alpha/include/asm/barrier.h
@@ -16,11 +16,13 @@ __asm__ __volatile__("wmb": : :"memory")
 __asm__ __volatile__("mb": : :"memory")
 
 #ifdef CONFIG_SMP
+#define __ASM_SMP_MB	"\tmb\n"
 #define smp_mb()	mb()
 #define smp_rmb()	rmb()
 #define smp_wmb()	wmb()
 #define smp_read_barrier_depends()	read_barrier_depends()
 #else
+#define __ASM_SMP_MB
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
diff -puN arch/alpha/include/asm/futex.h~alpha-futex-implementation arch/alpha/include/asm/futex.h
--- a/arch/alpha/include/asm/futex.h~alpha-futex-implementation
+++ a/arch/alpha/include/asm/futex.h
@@ -1,6 +1,116 @@
-#ifndef _ASM_FUTEX_H
-#define _ASM_FUTEX_H
+#ifndef _ASM_ALPHA_FUTEX_H
+#define _ASM_ALPHA_FUTEX_H
 
-#include <asm-generic/futex.h>
+#ifdef __KERNEL__
 
-#endif
+#include <linux/futex.h>
+#include <linux/uaccess.h>
+#include <asm/errno.h>
+#include <asm/barrier.h>
+
+#define __futex_atomic_op(insn, ret, oldval, uaddr, oparg)	\
+	__asm__ __volatile__(					\
+		__ASM_SMP_MB					\
+	"1:	ldl_l	%0,0(%2)\n"				\
+		insn						\
+	"2:	stl_c	%1,0(%2)\n"				\
+	"	beq	%1,4f\n"				\
+	"	mov	$31,%1\n"				\
+	"3:	.subsection 2\n"				\
+	"4:	br	1b\n"					\
+	"	.previous\n"					\
+	"	.section __ex_table,\"a\"\n"			\
+	"	.long	1b-.\n"					\
+	"	lda	$31,3b-1b(%1)\n"			\
+	"	.long	2b-.\n"					\
+	"	lda	$31,3b-2b(%1)\n"			\
+	"	.previous\n"					\
+	:	"=&r" (oldval), "=&r"(ret)			\
+	:	"r" (uaddr), "r"(oparg)				\
+	:	"memory")
+
+static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
+{
+	int op = (encoded_op >> 28) & 7;
+	int cmp = (encoded_op >> 24) & 15;
+	int oparg = (encoded_op << 8) >> 20;
+	int cmparg = (encoded_op << 20) >> 20;
+	int oldval = 0, ret;
+	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
+		oparg = 1 << oparg;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+		return -EFAULT;
+
+	pagefault_disable();
+
+	switch (op) {
+	case FUTEX_OP_SET:
+		__futex_atomic_op("mov %3,%1\n", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_ADD:
+		__futex_atomic_op("addl %0,%3,%1\n", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_OR:
+		__futex_atomic_op("or %0,%3,%1\n", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_ANDN:
+		__futex_atomic_op("andnot %0,%3,%1\n", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_XOR:
+		__futex_atomic_op("xor %0,%3,%1\n", ret, oldval, uaddr, oparg);
+		break;
+	default:
+		ret = -ENOSYS;
+	}
+
+	pagefault_enable();
+
+	if (!ret) {
+		switch (cmp) {
+		case FUTEX_OP_CMP_EQ: ret = (oldval == cmparg); break;
+		case FUTEX_OP_CMP_NE: ret = (oldval != cmparg); break;
+		case FUTEX_OP_CMP_LT: ret = (oldval < cmparg); break;
+		case FUTEX_OP_CMP_GE: ret = (oldval >= cmparg); break;
+		case FUTEX_OP_CMP_LE: ret = (oldval <= cmparg); break;
+		case FUTEX_OP_CMP_GT: ret = (oldval > cmparg); break;
+		default: ret = -ENOSYS;
+		}
+	}
+	return ret;
+}
+
+static inline int
+futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+{
+	int prev, cmp;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+		return -EFAULT;
+
+	__asm__ __volatile__ (
+		__ASM_SMP_MB
+	"1:	ldl_l	%0,0(%2)\n"
+	"	cmpeq	%0,%3,%1\n"
+	"	beq	%1,3f\n"
+	"	mov	%4,%1\n"
+	"2:	stl_c	%1,0(%2)\n"
+	"	beq	%1,4f\n"
+	"3:	.subsection 2\n"
+	"4:	br	1b\n"
+	"	.previous\n"
+	"	.section __ex_table,\"a\"\n"
+	"	.long	1b-.\n"
+	"	lda	$31,3b-1b(%0)\n"
+	"	.long	2b-.\n"
+	"	lda	$31,3b-2b(%0)\n"
+	"	.previous\n"
+	:	"=&r"(prev), "=&r"(cmp)
+	:	"r"(uaddr), "r"((long)oldval), "r"(newval)
+	:	"memory");
+
+	return prev;
+}
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_ALPHA_FUTEX_H */
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

linux-next.patch
time-create-arch_gettimeoffset-infrastructure-for-use-in-the-generic-timekeeping-core.patch
alpha-titan-and-marvel-build-fixes.patch
alpha-exception-table-sorting.patch
alpha-futex-implementation.patch
alpha-binfmt_aout-fix.patch
kmap_types-make-most-arches-use-generic-header-file.patch
make-sure-nobodys-leaking-resources.patch

