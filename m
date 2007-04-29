From: akpm@linux-foundation.org
Subject: + add-unitialized_var-macro-for-suppressing-gcc-warnings.patch added to -mm tree
Date: Sun, 29 Apr 2007 02:25:10 -0700
Message-ID: <200704290925.l3T9PAe1012835@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755055AbXD2JZT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Apr 2007 05:25:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bbpetkov@yahoo.de


The patch titled
     Add unitialized_var() macro for suppressing gcc warnings
has been added to the -mm tree.  Its filename is
     add-unitialized_var-macro-for-suppressing-gcc-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 3 files changed, 14 insertions(+)

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
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

origin.patch
git-acpi.patch
add-unitialized_var-macro-for-suppressing-gcc-warnings.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
alphabetically-sorted-entries-in.patch
kill-warnings-when-building-mandocs.patch
