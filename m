From: akpm@linux-foundation.org
Subject: [to-be-updated] compiler-gcc4h-remove-duplicate-macros.patch removed from -mm tree
Date: Mon, 01 Oct 2012 13:48:22 -0700
Message-ID: <20121001204823.396FC20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:47627 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab2JAUsZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 16:48:25 -0400
Received: by wgbdt11 with SMTP id dt11so331270wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 13:48:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.santos@pobox.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler{,-gcc4}.h: remove duplicate macros
has been removed from the -mm tree.  Its filename was
     compiler-gcc4h-remove-duplicate-macros.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Daniel Santos <daniel.santos@pobox.com>
Subject: compiler{,-gcc4}.h: remove duplicate macros

__linktime_error() does the same thing as __compiletime_error() and is
only used in bug.h.  Since the macro defines a function attribute that
will cause a failure at compile-time (not link-time), it makes more sense
to keep __compiletime_error(), which is also neatly mated with
__compiletime_warning().

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc4.h |    2 --
 include/linux/compiler.h      |    3 ---
 2 files changed, 5 deletions(-)

diff -puN include/linux/compiler-gcc4.h~compiler-gcc4h-remove-duplicate-macros include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~compiler-gcc4h-remove-duplicate-macros
+++ a/include/linux/compiler-gcc4.h
@@ -33,8 +33,6 @@
    the kernel context */
 #define __cold			__attribute__((__cold__))
 
-#define __linktime_error(message) __attribute__((__error__(message)))
-
 #ifndef __CHECKER__
 # define __compiletime_warning(message) __attribute__((warning(message)))
 # define __compiletime_error(message) __attribute__((error(message)))
diff -puN include/linux/compiler.h~compiler-gcc4h-remove-duplicate-macros include/linux/compiler.h
--- a/include/linux/compiler.h~compiler-gcc4h-remove-duplicate-macros
+++ a/include/linux/compiler.h
@@ -297,9 +297,6 @@ void ftrace_likely_update(struct ftrace_
 #ifndef __compiletime_error
 # define __compiletime_error(message)
 #endif
-#ifndef __linktime_error
-# define __linktime_error(message)
-#endif
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
_

Patches currently in -mm which might be from daniel.santos@pobox.com are

bugh-replace-__linktime_error-with-__compiletime_error.patch
compiler-gcc4h-introduce-__flatten-function-attribute.patch
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

