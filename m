From: akpm@linux-foundation.org
Subject: + bugh-work-around-gcc-pr82365-in-bug.patch added to -mm tree
Date: Tue, 19 Dec 2017 15:31:30 -0800
Message-ID: <5a39a152.raMbIF2gwdJLvckb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33748 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753433AbdLSXbc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Dec 2017 18:31:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, davem@davemloft.net, fenghua.yu@intel.com, geert@linux-m68k.org, jesper.nilsson@axis.com, jpoimboe@redhat.com, keescook@chromium.org, mark.rutland@arm.com, mingo@kernel.org, peterz@infradead.org, rostedt@goodmis.org, sparse@chrisli.org, starvik@axis.com, tglx@linutronix.de, tony.luck@intel.com, vgupta@synopsys.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bug.h: work around GCC PR82365 in BUG()
has been added to the -mm tree.  Its filename is
     bugh-work-around-gcc-pr82365-in-bug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bugh-work-around-gcc-pr82365-in-bug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bugh-work-around-gcc-pr82365-in-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: bug.h: work around GCC PR82365 in BUG()

Looking at functions with large stack frames across all architectures led
me discovering that BUG() suffers from the same problem as
fortify_panic(), which I've added a workaround for already.  In short,
variables that go out of scope by calling a noreturn function or
__builtin_unreachable() keep using stack space in functions afterwards.

A workaround that was identified is to insert an empty assembler statement
just before calling the function that doesn't return.  I'm adding a macro
"barrier_before_unreachable()" to document this, and insert calls to that
in all instances of BUG() that currently suffer from this problem.

The files that saw the largest change from this had these frame sizes
before, and much less with my patch:

fs/ext4/inode.c:82:1: warning: the frame size of 1672 bytes is larger than 800 bytes [-Wframe-larger-than=]
fs/ext4/namei.c:434:1: warning: the frame size of 904 bytes is larger than 800 bytes [-Wframe-larger-than=]
fs/ext4/super.c:2279:1: warning: the frame size of 1160 bytes is larger than 800 bytes [-Wframe-larger-than=]
fs/ext4/xattr.c:146:1: warning: the frame size of 1168 bytes is larger than 800 bytes [-Wframe-larger-than=]
fs/f2fs/inode.c:152:1: warning: the frame size of 1424 bytes is larger than 800 bytes [-Wframe-larger-than=]
net/netfilter/ipvs/ip_vs_core.c:1195:1: warning: the frame size of 1068 bytes is larger than 800 bytes [-Wframe-larger-than=]
net/netfilter/ipvs/ip_vs_core.c:395:1: warning: the frame size of 1084 bytes is larger than 800 bytes [-Wframe-larger-than=]
net/netfilter/ipvs/ip_vs_ftp.c:298:1: warning: the frame size of 928 bytes is larger than 800 bytes [-Wframe-larger-than=]
net/netfilter/ipvs/ip_vs_ftp.c:418:1: warning: the frame size of 908 bytes is larger than 800 bytes [-Wframe-larger-than=]
net/netfilter/ipvs/ip_vs_lblcr.c:718:1: warning: the frame size of 960 bytes is larger than 800 bytes [-Wframe-larger-than=]
drivers/net/xen-netback/netback.c:1500:1: warning: the frame size of 1088 bytes is larger than 800 bytes [-Wframe-larger-than=]

In case of ARC and CRIS, it turns out that the BUG() implementation
actually does return (or at least the compiler thinks it does), resulting
in lots of warnings about uninitialized variable use and leaving noreturn
functions, such as:

block/cfq-iosched.c: In function 'cfq_async_queue_prio':
block/cfq-iosched.c:3804:1: error: control reaches end of non-void function [-Werror=return-type]
include/linux/dmaengine.h: In function 'dma_maxpq':
include/linux/dmaengine.h:1123:1: error: control reaches end of non-void function [-Werror=return-type]

This makes them call __builtin_trap() instead, which should normally dump
the stack and kill the current process, like some of the other
architectures already do.

I tried adding barrier_before_unreachable() to panic() and fortify_panic()
as well, but that had very little effect, so I'm not submitting that
patch.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82365
Link: http://lkml.kernel.org/r/20171219114112.939391-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Christopher Li <sparse@chrisli.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/bug.h            |    3 ++-
 arch/cris/include/arch-v10/arch/bug.h |   11 +++++++++--
 arch/ia64/include/asm/bug.h           |    6 +++++-
 arch/m68k/include/asm/bug.h           |    3 +++
 arch/sparc/include/asm/bug.h          |    6 +++++-
 include/asm-generic/bug.h             |    1 +
 include/linux/compiler-gcc.h          |   15 ++++++++++++++-
 include/linux/compiler.h              |    5 +++++
 8 files changed, 44 insertions(+), 6 deletions(-)

diff -puN arch/arc/include/asm/bug.h~bugh-work-around-gcc-pr82365-in-bug arch/arc/include/asm/bug.h
--- a/arch/arc/include/asm/bug.h~bugh-work-around-gcc-pr82365-in-bug
+++ a/arch/arc/include/asm/bug.h
@@ -23,7 +23,8 @@ void die(const char *str, struct pt_regs
 
 #define BUG()	do {								\
 	pr_warn("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
-	dump_stack();								\
+	barrier_before_unreachable();						\
+	__builtin_trap();							\
 } while (0)
 
 #define HAVE_ARCH_BUG
diff -puN arch/cris/include/arch-v10/arch/bug.h~bugh-work-around-gcc-pr82365-in-bug arch/cris/include/arch-v10/arch/bug.h
--- a/arch/cris/include/arch-v10/arch/bug.h~bugh-work-around-gcc-pr82365-in-bug
+++ a/arch/cris/include/arch-v10/arch/bug.h
@@ -44,18 +44,25 @@ struct bug_frame {
  * not be used like this with newer versions of gcc.
  */
 #define BUG()								\
+do {									\
 	__asm__ __volatile__ ("clear.d [" __stringify(BUG_MAGIC) "]\n\t"\
 			      "movu.w " __stringify(__LINE__) ",$r0\n\t"\
 			      "jump 0f\n\t"				\
 			      ".section .rodata\n"			\
 			      "0:\t.string \"" __FILE__ "\"\n\t"	\
-			      ".previous")
+			      ".previous");				\
+	unreachable();							\
+} while (0)
 #endif
 
 #else
 
 /* This just causes an oops. */
-#define BUG() (*(int *)0 = 0)
+#define BUG()								\
+do {									\
+	barrier_before_unreachable();					\
+	__builtin_trap();						\
+} while (0)
 
 #endif
 
diff -puN arch/ia64/include/asm/bug.h~bugh-work-around-gcc-pr82365-in-bug arch/ia64/include/asm/bug.h
--- a/arch/ia64/include/asm/bug.h~bugh-work-around-gcc-pr82365-in-bug
+++ a/arch/ia64/include/asm/bug.h
@@ -4,7 +4,11 @@
 
 #ifdef CONFIG_BUG
 #define ia64_abort()	__builtin_trap()
-#define BUG() do { printk("kernel BUG at %s:%d!\n", __FILE__, __LINE__); ia64_abort(); } while (0)
+#define BUG() do {						\
+	printk("kernel BUG at %s:%d!\n", __FILE__, __LINE__);	\
+	barrier_before_unreachable();				\
+	ia64_abort();						\
+} while (0)
 
 /* should this BUG be made generic? */
 #define HAVE_ARCH_BUG
diff -puN arch/m68k/include/asm/bug.h~bugh-work-around-gcc-pr82365-in-bug arch/m68k/include/asm/bug.h
--- a/arch/m68k/include/asm/bug.h~bugh-work-around-gcc-pr82365-in-bug
+++ a/arch/m68k/include/asm/bug.h
@@ -8,16 +8,19 @@
 #ifndef CONFIG_SUN3
 #define BUG() do { \
 	pr_crit("kernel BUG at %s:%d!\n", __FILE__, __LINE__); \
+	barrier_before_unreachable(); \
 	__builtin_trap(); \
 } while (0)
 #else
 #define BUG() do { \
 	pr_crit("kernel BUG at %s:%d!\n", __FILE__, __LINE__); \
+	barrier_before_unreachable(); \
 	panic("BUG!"); \
 } while (0)
 #endif
 #else
 #define BUG() do { \
+	barrier_before_unreachable(); \
 	__builtin_trap(); \
 } while (0)
 #endif
diff -puN arch/sparc/include/asm/bug.h~bugh-work-around-gcc-pr82365-in-bug arch/sparc/include/asm/bug.h
--- a/arch/sparc/include/asm/bug.h~bugh-work-around-gcc-pr82365-in-bug
+++ a/arch/sparc/include/asm/bug.h
@@ -9,10 +9,14 @@
 void do_BUG(const char *file, int line);
 #define BUG() do {					\
 	do_BUG(__FILE__, __LINE__);			\
+	barrier_before_unreachable();			\
 	__builtin_trap();				\
 } while (0)
 #else
-#define BUG()		__builtin_trap()
+#define BUG() do {					\
+	barrier_before_unreachable();			\
+	__builtin_trap();				\
+} while (0)
 #endif
 
 #define HAVE_ARCH_BUG
diff -puN include/asm-generic/bug.h~bugh-work-around-gcc-pr82365-in-bug include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~bugh-work-around-gcc-pr82365-in-bug
+++ a/include/asm-generic/bug.h
@@ -52,6 +52,7 @@ struct bug_entry {
 #ifndef HAVE_ARCH_BUG
 #define BUG() do { \
 	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
+	barrier_before_unreachable(); \
 	panic("BUG!"); \
 } while (0)
 #endif
diff -puN include/linux/compiler-gcc.h~bugh-work-around-gcc-pr82365-in-bug include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~bugh-work-around-gcc-pr82365-in-bug
+++ a/include/linux/compiler-gcc.h
@@ -205,6 +205,15 @@
 #endif
 
 /*
+ * calling noreturn functions, __builtin_unreachable() and __builtin_trap()
+ * confuse the stack allocation in gcc, leading to overly large stack
+ * frames, see https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82365
+ *
+ * Adding an empty inline assembly before it works around the problem
+ */
+#define barrier_before_unreachable() asm volatile("")
+
+/*
  * Mark a position in code as unreachable.  This can be used to
  * suppress control flow warnings after asm blocks that transfer
  * control elsewhere.
@@ -214,7 +223,11 @@
  * unreleased.  Really, we need to have autoconf for the kernel.
  */
 #define unreachable() \
-	do { annotate_unreachable(); __builtin_unreachable(); } while (0)
+	do {					\
+		annotate_unreachable();		\
+		barrier_before_unreachable();	\
+		__builtin_unreachable();	\
+	} while (0)
 
 /* Mark a function definition as prohibited from being cloned. */
 #define __noclone	__attribute__((__noclone__, __optimize__("no-tracer")))
diff -puN include/linux/compiler.h~bugh-work-around-gcc-pr82365-in-bug include/linux/compiler.h
--- a/include/linux/compiler.h~bugh-work-around-gcc-pr82365-in-bug
+++ a/include/linux/compiler.h
@@ -86,6 +86,11 @@ void ftrace_likely_update(struct ftrace_
 # define barrier_data(ptr) barrier()
 #endif
 
+/* workaround for GCC PR82365 if needed */
+#ifndef barrier_before_unreachable
+# define barrier_before_unreachable() do { } while (0)
+#endif
+
 /* Unreachable code */
 #ifdef CONFIG_STACK_VALIDATION
 /*
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-2.patch
bugh-work-around-gcc-pr82365-in-bug.patch

