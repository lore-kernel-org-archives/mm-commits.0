From: akpm@linux-foundation.org
Subject: - add-unitialized_var-macro-for-suppressing-gcc-warnings.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:17 -0700
Message-ID: <200705080002.l4802H6U008832@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967318AbXEHACp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:02:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbpetkov@yahoo.de, mm-commits@vger.kernel.org


The patch titled
     Add unitialized_var() macro for suppressing gcc warnings
has been removed from the -mm tree.  Its filename was
     add-unitialized_var-macro-for-suppressing-gcc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add unitialized_var() macro for suppressing gcc warnings
From: Borislav Petkov <bbpetkov@yahoo.de>

Introduce a macro for suppressing gcc from generating a warning about a
probable uninitialized state of a variable.

Example:

-	spinlock_t *ptl;
+	spinlock_t *uninitialized_var(ptl);

Not a happy solution, but those warnings are obnoxious.

- Using the usual pointlessly-set-it-to-zero approach wastes several
  bytes of text.

- Using a macro means we can (hopefully) do something else if gcc changes
  cause the `x = x' hack to stop working

- Using a macro means that people who are worried about hiding true bugs
  can easily turn it off.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc3.h  |    6 ++++++
 include/linux/compiler-gcc4.h  |    6 ++++++
 include/linux/compiler-intel.h |    2 ++
 mm/memory.c                    |    2 +-
 4 files changed, 15 insertions(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc3.h~add-unitialized_var-macro-for-suppressing-gcc-warnings include/linux/compiler-gcc3.h
--- a/include/linux/compiler-gcc3.h~add-unitialized_var-macro-for-suppressing-gcc-warnings
+++ a/include/linux/compiler-gcc3.h
@@ -13,4 +13,10 @@
 #define __must_check		__attribute__((warn_unused_result))
 #endif
 
+/*
+ * A trick to suppress uninitialized variable warning without generating any
+ * code
+ */
+#define uninitialized_var(x) x = x
+
 #define __always_inline		inline __attribute__((always_inline))
diff -puN include/linux/compiler-gcc4.h~add-unitialized_var-macro-for-suppressing-gcc-warnings include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~add-unitialized_var-macro-for-suppressing-gcc-warnings
+++ a/include/linux/compiler-gcc4.h
@@ -16,3 +16,9 @@
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
 #define __always_inline		inline __attribute__((always_inline))
+
+/*
+ * A trick to suppress uninitialized variable warning without generating any
+ * code
+ */
+#define uninitialized_var(x) x = x
diff -puN include/linux/compiler-intel.h~add-unitialized_var-macro-for-suppressing-gcc-warnings include/linux/compiler-intel.h
--- a/include/linux/compiler-intel.h~add-unitialized_var-macro-for-suppressing-gcc-warnings
+++ a/include/linux/compiler-intel.h
@@ -22,3 +22,5 @@
     (typeof(ptr)) (__ptr + (off)); })
 
 #endif
+
+#define uninitialized_var(x) x
diff -puN mm/memory.c~add-unitialized_var-macro-for-suppressing-gcc-warnings mm/memory.c
--- a/mm/memory.c~add-unitialized_var-macro-for-suppressing-gcc-warnings
+++ a/mm/memory.c
@@ -1455,7 +1455,7 @@ static int apply_to_pte_range(struct mm_
 	pte_t *pte;
 	int err;
 	struct page *pmd_page;
-	spinlock_t *ptl = ptl;		/* Suppress gcc warning */
+	spinlock_t *uninitialized_var(ptl);
 
 	pte = (mm == &init_mm) ?
 		pte_alloc_kernel(pmd, addr) :
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

origin.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
kill-warnings-when-building-mandocs.patch
