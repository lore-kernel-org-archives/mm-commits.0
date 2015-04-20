From: akpm@linux-foundation.org
Subject: [to-be-updated]
 lto-add-__noreorder-and-mark-initcalls-__noreorder.patch removed from -mm
 tree
Date: Mon, 20 Apr 2015 14:56:55 -0700
Message-ID: <55357627.NYVk7KjhxPwT5Gab%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbbDTV44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 17:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: lto: add __noreorder and mark initcalls __noreorder
has been removed from the -mm tree.  Its filename was
     lto-add-__noreorder-and-mark-initcalls-__noreorder.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: lto: add __noreorder and mark initcalls __noreorder

gcc 5 has a new no_reorder attribute that prevents top level reordering
only for that symbol.

Kernels don't like any reordering of initcalls between files, as several
initcalls depend on each other.  LTO previously needed to use
-fno-toplevel-reorder to prevent boot failures.

Add a __noreorder wrapper for the no_reorder attribute and use
it for initcalls.

Background:

The original gcc a long time was function at a time: it read one function,
optimizes and writes it out, then the next.  Then gcc 3.x added
unit-at-a-time where it reads one complete file, optimizes it completely
and writes it out.  This has the advantage that it can make better
inlining decisions, it can remove unused statics, it can propagate
execution frequencies over the call tree before optimizing, and some other
things.  Then it writes it out the unit in the call tree order, which can
also lead to better executable layout.  One side effect of this is that
the order of top level statements gets lost, unless you specify
-fno-toplevel-reorder

We had to fix Linux for this sometime in early 2.6, late 2.4.  Most
problems were in top level asm() statements, assuming they had a defined
order to other variables.  To still support programs doing that gcc added
-fno-toplevel-reorder, which avoided such reordering, but also disabled a
small number of optimizations.

Now 4.x added LTO, where it takes unit-at-a-time one step further and
optimizes the complete program in the same way at link time.  It actually
does not keep it in memory all the time, but uses various tricks to only
look at it in pieces and distribute the work to multiple cores.  To do
that it uses partitioning, where the program is split into different
partitions based on its global call tree, and then each partition is
assigned to a compiler process.  The result is a changed order for
everything in the final program.

Modern Linux was generally fine with reordering, except for initcalls.  We
have a lot of initcalls that assume that some other initcalls already ran
before them, without using priorities.  The order is defined in the
Makefile's object file order for the linker.  Linkers generally do not
reorder, unless told to.  Unfortunately that gets lost with LTO.  

When I started the LTO patchkit I tried to debug and fix some of these
init calls, but it was hopeless.  It was like a many-headed hydra.  So I
needed to use -fno-toplevel-reorder for LTO.  In LTO this both gives worse
partitioning (so the build is less balanced between different cores) and
also disables some optimizations, like eliminating unused variables or
some cross file optimizations.

gcc 5 finally gained a way to specify the no-toplevel-reorder attribute
per symbol with this new attribute.  So it can be only done for the
initcall symbols, and everything else left alone.

That is what this patch is about.

It's not needed without LTO, but I belive it's useful documentation even
without it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc5.h |    3 +++
 include/linux/compiler.h      |    4 ++++
 include/linux/init.h          |    2 +-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc5.h~lto-add-__noreorder-and-mark-initcalls-__noreorder include/linux/compiler-gcc5.h
--- a/include/linux/compiler-gcc5.h~lto-add-__noreorder-and-mark-initcalls-__noreorder
+++ a/include/linux/compiler-gcc5.h
@@ -42,6 +42,9 @@
 /* Mark a function definition as prohibited from being cloned. */
 #define __noclone	__attribute__((__noclone__))
 
+/* Avoid reordering a top level statement */
+#define __noreorder	__attribute__((no_reorder))
+
 /*
  * Tell the optimizer that something else uses this function or variable.
  */
diff -puN include/linux/compiler.h~lto-add-__noreorder-and-mark-initcalls-__noreorder include/linux/compiler.h
--- a/include/linux/compiler.h~lto-add-__noreorder-and-mark-initcalls-__noreorder
+++ a/include/linux/compiler.h
@@ -318,6 +318,10 @@ static __always_inline void __write_once
 #define noinline
 #endif
 
+#ifndef __noreorder
+#define __noreorder		/* unimplemented */
+#endif
+
 /*
  * Rather then using noinline to prevent stack consumption, use
  * noinline_for_stack instead.  For documentation reasons.
diff -puN include/linux/init.h~lto-add-__noreorder-and-mark-initcalls-__noreorder include/linux/init.h
--- a/include/linux/init.h~lto-add-__noreorder-and-mark-initcalls-__noreorder
+++ a/include/linux/init.h
@@ -191,7 +191,7 @@ extern bool initcall_debug;
  */
 
 #define __define_initcall(fn, id) \
-	static initcall_t __initcall_##fn##id __used \
+	static initcall_t __initcall_##fn##id __used __noreorder \
 	__attribute__((__section__(".initcall" #id ".init"))) = fn; \
 	LTO_REFERENCE_INITCALL(__initcall_##fn##id)
 
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
mm-memory-failure-call-shake_page-when-error-hits-thp-tail-page.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

