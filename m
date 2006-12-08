From: akpm@osdl.org
Subject: - s390-fix-in-user-atomic-futex-operation.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:04:27 -0800
Message-ID: <200612081104.kB8B4RFN018551@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48648 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938034AbWLHLE7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:04:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: fix in-user atomic futex operation.
has been removed from the -mm tree.  Its filename was
     s390-fix-in-user-atomic-futex-operation.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: s390: fix in-user atomic futex operation.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>


__futex_atomic_op needs to do an atomic operation in the user address space,
not the kernel address space.  Add the missing sacf 256/sacf 0 to switch to
the secondary mode before doing the compare-and-swap.  In addition add
another fixup for catch specification exceptions if the compare-and-swap
address is not aligned.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-s390/futex.h |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN include/asm-s390/futex.h~s390-fix-in-user-atomic-futex-operation include/asm-s390/futex.h
--- devel/include/asm-s390/futex.h~s390-fix-in-user-atomic-futex-operation	2006-06-08 01:33:53.000000000 -0700
+++ devel-akpm/include/asm-s390/futex.h	2006-06-08 01:33:53.000000000 -0700
@@ -11,23 +11,24 @@
 #define __futex_atomic_fixup \
 		     ".section __ex_table,\"a\"\n"			\
 		     "   .align 4\n"					\
-		     "   .long  0b,2b,1b,2b\n"				\
+		     "   .long  0b,4b,2b,4b,3b,4b\n"			\
 		     ".previous"
 #else /* __s390x__ */
 #define __futex_atomic_fixup \
 		     ".section __ex_table,\"a\"\n"			\
 		     "   .align 8\n"					\
-		     "   .quad  0b,2b,1b,2b\n"				\
+		     "   .quad  0b,4b,2b,4b,3b,4b\n"			\
 		     ".previous"
 #endif /* __s390x__ */
 
 #define __futex_atomic_op(insn, ret, oldval, newval, uaddr, oparg)	\
-	asm volatile("   l   %1,0(%6)\n"				\
-		     "0: " insn						\
-		     "   cs  %1,%2,0(%6)\n"				\
-		     "1: jl  0b\n"					\
+	asm volatile("   sacf 256\n"					\
+		     "0: l   %1,0(%6)\n"				\
+		     "1: " insn						\
+		     "2: cs  %1,%2,0(%6)\n"				\
+		     "3: jl  1b\n"					\
 		     "   lhi %0,0\n"					\
-		     "2:\n"						\
+		     "4: sacf 0\n"					\
 		     __futex_atomic_fixup				\
 		     : "=d" (ret), "=&d" (oldval), "=&d" (newval),	\
 		       "=m" (*uaddr)					\
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

origin.patch
tty-signal-tty-locking.patch
generic-ioremap_page_range-s390-conversion.patch
git-s390.patch
s390-workqueue-fixes.patch

