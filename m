From: akpm@linux-foundation.org
Subject: [to-be-updated] compiler-gcc4h-introduce-__flatten-function-attribute.patch removed from -mm tree
Date: Mon, 01 Oct 2012 13:48:30 -0700
Message-ID: <20121001204831.30C9420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:33709 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab2JAUsc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 16:48:32 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so386584fae.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 13:48:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.santos@pobox.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler{,-gcc4}.h: introduce __flatten function attribute
has been removed from the -mm tree.  Its filename was
     compiler-gcc4h-introduce-__flatten-function-attribute.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Daniel Santos <daniel.santos@pobox.com>
Subject: compiler{,-gcc4}.h: introduce __flatten function attribute

For gcc 4.1 & later, expands to __attribute__((flatten)) which forces the
compiler to inline everything it can into the function.  This is useful in
combination with noinline when you want to control the depth of inlining,
or create a single function where inline expansions will occur.  (see
http://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html#index-g_t_0040code_007bflatten_007d-function-attribute-2512)

Normally, it's best to leave this type of thing up to the compiler. 
However, the generic rbtree code uses inline functions just to be able to
inject compile-time constant data that specifies how the caller wants the
function to behave (via struct rb_relationship).  This data can be thought
of as the template parameters of a C++ templatized function.  Since some
of these functions, once expanded, become quite large, gcc sometimes
decides not to perform some important inlining, in one case, even
generating a few bytes more code by not doing so.  (Note: I have not
eliminated the possibility that this was an optimization bug, but the
flatten attribute fixes it in either case.)

Combining __flatten and noinline insures that important optimizations
occur in these cases and that the inline expansion occurs in exactly one
place, thus not leading to unnecissary bloat.  However, it also can
eliminate some opportunities for optimization should gcc otherwise decide
the function its self is a good candidate for inlining.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc4.h |    7 ++++++-
 include/linux/compiler.h      |    4 ++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc4.h~compiler-gcc4h-introduce-__flatten-function-attribute include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~compiler-gcc4h-introduce-__flatten-function-attribute
+++ a/include/linux/compiler-gcc4.h
@@ -15,7 +15,12 @@
 
 #if GCC_VERSION >= 40102
 # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
-#endif
+
+/* flatten introduced in 4.1, but broken in 4.6.0 (gcc bug #48731)*/
+# if GCC_VERSION != 40600
+#  define __flatten __attribute__((flatten))
+# endif
+#endif /* GCC_VERSION >= 40102 */
 
 #if GCC_VERSION >= 40300
 /* Mark functions as cold. gcc will assume any path leading to a call
diff -puN include/linux/compiler.h~compiler-gcc4h-introduce-__flatten-function-attribute include/linux/compiler.h
--- a/include/linux/compiler.h~compiler-gcc4h-introduce-__flatten-function-attribute
+++ a/include/linux/compiler.h
@@ -244,6 +244,10 @@ void ftrace_likely_update(struct ftrace_
 #define __always_inline inline
 #endif
 
+#ifndef __flatten
+#define __flatten
+#endif
+
 #endif /* __KERNEL__ */
 
 /*
_

Patches currently in -mm which might be from daniel.santos@pobox.com are

rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-performance-and-correctness-test.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch
rbtree-optimize-fetching-of-sibling-node.patch
mm-interval-tree-updates.patch
mm-anon-rmap-remove-anon_vma_moveto_tail.patch
mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree.patch
mm-rmap-remove-vma_address-check-for-address-inside-vma.patch
mm-add-config_debug_vm_rb-build-option.patch
mm-avoid-taking-rmap-locks-in-move_ptes.patch

