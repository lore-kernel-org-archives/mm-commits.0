From: akpm@linux-foundation.org
Subject: [merged] compiler-gcc4h-reorder-macros-based-upon-gcc-ver.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:37:05 -0800
Message-ID: <20130222203705.EAB0F31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:63875 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab3BVUhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:08 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so103714vea.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.santos@pobox.com, ak@linux.intel.com, bp@alien8.de, joe@perches.com, josh@joshtriplett.org, paul.gortmaker@windriver.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-gcc4.h: Reorder macros based upon gcc ver
has been removed from the -mm tree.  Its filename was
     compiler-gcc4h-reorder-macros-based-upon-gcc-ver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Santos <daniel.santos@pobox.com>
Subject: compiler-gcc4.h: Reorder macros based upon gcc ver

This helps to keep the file from getting confusing, removes one duplicate
version check and should encourage future editors to put new macros where
they belong.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc4.h |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN include/linux/compiler-gcc4.h~compiler-gcc4h-reorder-macros-based-upon-gcc-ver include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~compiler-gcc4h-reorder-macros-based-upon-gcc-ver
+++ a/include/linux/compiler-gcc4.h
@@ -13,6 +13,10 @@
 #define __must_check 		__attribute__((warn_unused_result))
 #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
 
+#if __GNUC_MINOR__ > 0
+# define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
+#endif
+
 #if __GNUC_MINOR__ >= 3
 /* Mark functions as cold. gcc will assume any path leading to a call
    to them will be unlikely.  This means a lot of manual unlikely()s
@@ -33,6 +37,12 @@
 
 #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
 
+#ifndef __CHECKER__
+# define __compiletime_warning(message) __attribute__((warning(message)))
+# define __compiletime_error(message) __attribute__((error(message)))
+#endif /* __CHECKER__ */
+#endif /* __GNUC_MINOR__ >= 3 */
+
 #if __GNUC_MINOR__ >= 5
 /*
  * Mark a position in code as unreachable.  This can be used to
@@ -48,8 +58,7 @@
 /* Mark a function definition as prohibited from being cloned. */
 #define __noclone	__attribute__((__noclone__))
 
-#endif
-#endif
+#endif /* __GNUC_MINOR__ >= 5 */
 
 #if __GNUC_MINOR__ >= 6
 /*
@@ -58,13 +67,6 @@
 #define __visible __attribute__((externally_visible))
 #endif
 
-#if __GNUC_MINOR__ > 0
-#define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
-#endif
-#if __GNUC_MINOR__ >= 3 && !defined(__CHECKER__)
-#define __compiletime_warning(message) __attribute__((warning(message)))
-#define __compiletime_error(message) __attribute__((error(message)))
-#endif
 
 #ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
 #if __GNUC_MINOR__ >= 4
_

Patches currently in -mm which might be from daniel.santos@pobox.com are

origin.patch

