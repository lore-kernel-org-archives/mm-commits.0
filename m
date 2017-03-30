From: akpm@linux-foundation.org
Subject: [to-be-updated]
 asm-generic-fix-compilation-failure-in-cmpxchg_double.patch removed from
 -mm tree
Date: Thu, 30 Mar 2017 15:28:18 -0700
Message-ID: <58dd8682.2xTzl+sn5xwy/qoJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40122 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932201AbdC3W2T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Mar 2017 18:28:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: asm-generic: fix compilation failure in cmpxchg_double()
has been removed from the -mm tree.  Its filename was
     asm-generic-fix-compilation-failure-in-cmpxchg_double.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: asm-generic: fix compilation failure in cmpxchg_double()

Arnd reported that the new code leads to compilation failures with some
versions of gcc.  I've filed gcc issue 72873, but we need a kernel fix as
well.

Remove instrumentation from cmpxchg_double() for now.

Link: http://lkml.kernel.org/r/20170322111022.85745-1-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic-instrumented.h |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN include/asm-generic/atomic-instrumented.h~asm-generic-fix-compilation-failure-in-cmpxchg_double include/asm-generic/atomic-instrumented.h
--- a/include/asm-generic/atomic-instrumented.h~asm-generic-fix-compilation-failure-in-cmpxchg_double
+++ a/include/asm-generic/atomic-instrumented.h
@@ -240,18 +240,23 @@ INSTR_RET_BOOL2(add_negative);
 	arch_cmpxchg64_local(____ptr, (old), (new));	\
 })
 
+/*
+ * Originally we had the following code here:
+ *	__typeof__(p1) ____p1 = (p1);
+ *	kasan_check_write(____p1, 2 * sizeof(*____p1));
+ *	arch_cmpxchg_double(____p1, (p2), (o1), (o2), (n1), (n2));
+ * But it leads to compilation failures (see gcc issue 72873).
+ * So for now it's left non-instrumented.
+ * There are few callers of cmpxchg_double(), so it's not critical.
+ */
 #define cmpxchg_double(p1, p2, o1, o2, n1, n2)				\
 ({									\
-	__typeof__(p1) ____p1 = (p1);					\
-	kasan_check_write(____p1, 2 * sizeof(*____p1));			\
-	arch_cmpxchg_double(____p1, (p2), (o1), (o2), (n1), (n2));	\
+	arch_cmpxchg_double((p1), (p2), (o1), (o2), (n1), (n2));	\
 })
 
 #define cmpxchg_double_local(p1, p2, o1, o2, n1, n2)			\
 ({									\
-	__typeof__(p1) ____p1 = (p1);					\
-	kasan_check_write(____p1, 2 * sizeof(*____p1));			\
-	arch_cmpxchg_double_local(____p1, (p2), (o1), (o2), (n1), (n2));\
+	arch_cmpxchg_double_local((p1), (p2), (o1), (o2), (n1), (n2));	\
 })
 
 #endif /* _LINUX_ATOMIC_INSTRUMENTED_H */
_

Patches currently in -mm which might be from dvyukov@google.com are

kcov-simplify-interrupt-check.patch
fault-inject-use-correct-check-for-interrupts.patch
fault-inject-support-systematic-fault-injection.patch
x86-remove-unused-atomic_inc_short.patch
x86-asm-generic-add-kasan-instrumentation-to-bitops.patch

