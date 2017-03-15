From: akpm@linux-foundation.org
Subject: + x86-atomic-move-__atomic_add_unless-out-of-line.patch added to
 -mm tree
Date: Wed, 15 Mar 2017 14:53:48 -0700
Message-ID: <58c9b7ec.yUaeZKeGeAsKi8He%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54606 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752035AbdCOVxu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2017 17:53:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/atomic: move __arch_atomic_add_unless out of line
has been added to the -mm tree.  Its filename is
     x86-atomic-move-__atomic_add_unless-out-of-line.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-atomic-move-__atomic_add_unless-out-of-line.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-atomic-move-__atomic_add_unless-out-of-line.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: x86/atomic: move __arch_atomic_add_unless out of line

__arch_atomic_add_unless is fairly big and often used, so it's quite
expensive to inline it.  But it's unlikely that a call makes much
difference for such a complex function doing an expensive atomic.  So out
of line it.

This saves around 12k of text.

   text    data     bss     dec     hex filename
9084246 5367600 11116544        25568390        1862486 vmlinux-atomic-add
9096494 5367568 11116544        25580606        186543e vmlinux-before-atomic-add

Link: http://lkml.kernel.org/r/20170315021431.13107-3-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/atomic.h |   24 ------------------------
 arch/x86/lib/Makefile         |    1 +
 arch/x86/lib/atomic.c         |   27 +++++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 24 deletions(-)

diff -puN arch/x86/include/asm/atomic.h~x86-atomic-move-__atomic_add_unless-out-of-line arch/x86/include/asm/atomic.h
--- a/arch/x86/include/asm/atomic.h~x86-atomic-move-__atomic_add_unless-out-of-line
+++ a/arch/x86/include/asm/atomic.h
@@ -236,30 +236,6 @@ ATOMIC_OPS(xor, ^)
 #undef ATOMIC_OP
 
 /**
- * __arch_atomic_add_unless - add unless the number is already a given value
- * @v: pointer of type atomic_t
- * @a: the amount to add to v...
- * @u: ...unless v is equal to u.
- *
- * Atomically adds @a to @v, so long as @v was not already @u.
- * Returns the old value of @v.
- */
-static __always_inline int __arch_atomic_add_unless(atomic_t *v, int a, int u)
-{
-	int c, old;
-	c = arch_atomic_read(v);
-	for (;;) {
-		if (unlikely(c == (u)))
-			break;
-		old = arch_atomic_cmpxchg((v), c, c + (a));
-		if (likely(old == c))
-			break;
-		c = old;
-	}
-	return c;
-}
-
-/**
  * arch_atomic_inc_short - increment of a short integer
  * @v: pointer to type int
  *
diff -puN arch/x86/lib/Makefile~x86-atomic-move-__atomic_add_unless-out-of-line arch/x86/lib/Makefile
--- a/arch/x86/lib/Makefile~x86-atomic-move-__atomic_add_unless-out-of-line
+++ a/arch/x86/lib/Makefile
@@ -25,6 +25,7 @@ lib-y += memcpy_$(BITS).o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o
 lib-$(CONFIG_RANDOMIZE_BASE) += kaslr.o
+lib-y += atomic.o
 
 obj-y += msr.o msr-reg.o msr-reg-export.o hweight.o
 
diff -puN /dev/null arch/x86/lib/atomic.c
--- /dev/null
+++ a/arch/x86/lib/atomic.c
@@ -0,0 +1,27 @@
+#include <linux/module.h>
+#include <asm/atomic.h>
+
+/**
+ * __arch_atomic_add_unless - add unless the number is already a given value
+ * @v: pointer of type atomic_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as @v was not already @u.
+ * Returns the old value of @v.
+ */
+int __arch_atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = arch_atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = arch_atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c;
+}
+EXPORT_SYMBOL(__arch_atomic_add_unless);
_

Patches currently in -mm which might be from ak@linux.intel.com are

trace-move-trace_seq_overflowed-out-of-line.patch
x86-atomic-move-__atomic_add_unless-out-of-line.patch
sched-out-of-line-__update_load_avg.patch
kref-remove-warn_on-for-null-release-functions.patch
out-of-line-dma_alloc-free_attrs.patch
megasas-remove-expensive-inline-from-megasas_return_cmd.patch
remove-expensive-warn_on-in-pagefault_disabled_dec.patch

