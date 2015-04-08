From: akpm@linux-foundation.org
Subject: + lto-add-__noreorder-and-mark-initcalls-__noreorder.patch added
 to -mm tree
Date: Wed, 08 Apr 2015 15:36:35 -0700
Message-ID: <5525ad73.PQKQ7A+LnuNtrGnW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbbDHWgf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Apr 2015 18:36:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: lto: add __noreorder and mark initcalls __noreorder
has been added to the -mm tree.  Its filename is
     lto-add-__noreorder-and-mark-initcalls-__noreorder.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lto-add-__noreorder-and-mark-initcalls-__noreorder.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lto-add-__noreorder-and-mark-initcalls-__noreorder.patch

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
Subject: lto: add __noreorder and mark initcalls __noreorder

gcc 5 has a new no_reorder attribute that prevents top level reordering
only for that symbol.

Kernels don't like any reordering of initcalls between files, as several
initcalls depend on each other.  LTO previously needed to use
-fno-toplevel-reordering to prevent boot failures.

Add a __noreorder wrapper for the no_reorder attribute and use
it for initcalls.

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
@@ -334,6 +334,10 @@ static __always_inline void __write_once
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

mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-v3.patch
dont-let-latencytop-and-lockdep-select-kallsyms_all.patch
test-hexdumpc-fix-initconst-confusion.patch
lto-add-__noreorder-and-mark-initcalls-__noreorder.patch
linux-next.patch
gitignore-ignore-tar.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

