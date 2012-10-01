From: akpm@linux-foundation.org
Subject: [to-be-updated] compiler-gcc4h-correct-verion-check-for-__compiletime_error.patch removed from -mm tree
Date: Mon, 01 Oct 2012 13:48:06 -0700
Message-ID: <20121001204806.E1D0820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:57152 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab2JAUsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 16:48:09 -0400
Received: by eaaq10 with SMTP id q10so346035eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 13:48:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.santos@pobox.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-gcc4.h: correct verion check for __compiletime_error
has been removed from the -mm tree.  Its filename was
     compiler-gcc4h-correct-verion-check-for-__compiletime_error.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Daniel Santos <daniel.santos@pobox.com>
Subject: compiler-gcc4.h: correct verion check for __compiletime_error

__attribute__((error(msg))) was introduced in gcc 4.3 (not 4.4) and as I
was unable to find any gcc bugs pertaining to it, I'm presuming that it
has functioned as advertised since 4.3.0.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc4.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc4.h~compiler-gcc4h-correct-verion-check-for-__compiletime_error include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~compiler-gcc4h-correct-verion-check-for-__compiletime_error
+++ a/include/linux/compiler-gcc4.h
@@ -59,7 +59,7 @@
 #if __GNUC_MINOR__ > 0
 #define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
 #endif
-#if __GNUC_MINOR__ >= 4 && !defined(__CHECKER__)
+#if __GNUC_MINOR__ >= 3 && !defined(__CHECKER__)
 #define __compiletime_warning(message) __attribute__((warning(message)))
 #define __compiletime_error(message) __attribute__((error(message)))
 #endif
_

Patches currently in -mm which might be from daniel.santos@pobox.com are

compiler-gcc4h-reorder-macros-based-upon-gcc-ver.patch
compiler-gcch-add-gcc-recommended-gcc_version-macro.patch
compiler-gcc34h-use-gcc_version-macro.patch
compiler-gcc4h-remove-duplicate-macros.patch
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

