From: akpm@linux-foundation.org
Subject: [merged] compiler-gcc4h-bugh-remove-duplicate-macros.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:37:13 -0800
Message-ID: <20130222203714.4183F5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:44953 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab3BVUhP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:15 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so103360yen.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.santos@pobox.com, ak@linux.intel.com, bp@alien8.de, joe@perches.com, josh@joshtriplett.org, paul.gortmaker@windriver.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler{,-gcc4}.h, bug.h: Remove duplicate macros
has been removed from the -mm tree.  Its filename was
     compiler-gcc4h-bugh-remove-duplicate-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Santos <daniel.santos@pobox.com>
Subject: compiler{,-gcc4}.h, bug.h: Remove duplicate macros

__linktime_error() does the same thing as __compiletime_error() and is
only used in bug.h.  Since the macro defines a function attribute that
will cause a failure at compile-time (not link-time), it makes more sense
to keep __compiletime_error(), which is also neatly mated with
__compiletime_warning().

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h           |    2 +-
 include/linux/compiler-gcc4.h |    2 --
 include/linux/compiler.h      |    3 ---
 3 files changed, 1 insertion(+), 6 deletions(-)

diff -puN include/linux/bug.h~compiler-gcc4h-bugh-remove-duplicate-macros include/linux/bug.h
--- a/include/linux/bug.h~compiler-gcc4h-bugh-remove-duplicate-macros
+++ a/include/linux/bug.h
@@ -74,7 +74,7 @@ extern int __build_bug_on_failed;
 #define BUILD_BUG()						\
 	do {							\
 		extern void __build_bug_failed(void)		\
-			__linktime_error("BUILD_BUG failed");	\
+			__compiletime_error("BUILD_BUG failed");\
 		__build_bug_failed();				\
 	} while (0)
 
diff -puN include/linux/compiler-gcc4.h~compiler-gcc4h-bugh-remove-duplicate-macros include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~compiler-gcc4h-bugh-remove-duplicate-macros
+++ a/include/linux/compiler-gcc4.h
@@ -33,8 +33,6 @@
    the kernel context */
 #define __cold			__attribute__((__cold__))
 
-#define __linktime_error(message) __attribute__((__error__(message)))
