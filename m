From: akpm@linux-foundation.org
Subject: [merged]
 bug-when-config_bug-simplify-warn_on_once-and-family.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:34:25 -0700
Message-ID: <53446b61.5FPaMekyL2gEhpkO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbaDHVeZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:34:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, arnd@arndb.de, josh@joshtriplett.org

Subject: [merged] bug-when-config_bug-simplify-warn_on_once-and-family.patch removed from -mm tree
To: josh@joshtriplett.org,arnd@arndb.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:34:25 -0700


The patch titled
     Subject: bug: when !CONFIG_BUG, simplify WARN_ON_ONCE and family
has been removed from the -mm tree.  Its filename was
     bug-when-config_bug-simplify-warn_on_once-and-family.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: bug: when !CONFIG_BUG, simplify WARN_ON_ONCE and family

When !CONFIG_BUG, WARN_ON and family become simple passthroughs of their
condition argument; however, WARN_ON_ONCE and family still have conditions
and a boolean to detect one-time invocation, even though the warning
they'd emit doesn't exist.  Make the existing definitions conditional on
CONFIG_BUG, and add definitions for !CONFIG_BUG that map to the
passthrough versions of WARN and WARN_ON.

This saves 4.4k on a minimized configuration (smaller than allnoconfig),
and 20.6k with defconfig plus CONFIG_BUG=n.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |   57 ++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff -puN include/asm-generic/bug.h~bug-when-config_bug-simplify-warn_on_once-and-family include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~bug-when-config_bug-simplify-warn_on_once-and-family
+++ a/include/asm-generic/bug.h
@@ -106,33 +106,6 @@ extern void warn_slowpath_null(const cha
 	unlikely(__ret_warn_on);					\
 })
 
-#else /* !CONFIG_BUG */
-#ifndef HAVE_ARCH_BUG
-#define BUG() do {} while(0)
-#endif
-
-#ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (condition) ; } while(0)
-#endif
-
-#ifndef HAVE_ARCH_WARN_ON
-#define WARN_ON(condition) ({						\
-	int __ret_warn_on = !!(condition);				\
-	unlikely(__ret_warn_on);					\
-})
-#endif
-
-#ifndef WARN
-#define WARN(condition, format...) ({					\
-	int __ret_warn_on = !!(condition);				\
-	unlikely(__ret_warn_on);					\
-})
-#endif
-
-#define WARN_TAINT(condition, taint, format...) WARN_ON(condition)
-
-#endif
-
 #define WARN_ON_ONCE(condition)	({				\
 	static bool __section(.data.unlikely) __warned;		\
 	int __ret_warn_once = !!(condition);			\
@@ -163,6 +136,36 @@ extern void warn_slowpath_null(const cha
 	unlikely(__ret_warn_once);				\
 })
 
+#else /* !CONFIG_BUG */
+#ifndef HAVE_ARCH_BUG
+#define BUG() do {} while(0)
+#endif
+
+#ifndef HAVE_ARCH_BUG_ON
+#define BUG_ON(condition) do { if (condition) ; } while(0)
+#endif
+
+#ifndef HAVE_ARCH_WARN_ON
+#define WARN_ON(condition) ({						\
+	int __ret_warn_on = !!(condition);				\
+	unlikely(__ret_warn_on);					\
+})
+#endif
+
+#ifndef WARN
+#define WARN(condition, format...) ({					\
+	int __ret_warn_on = !!(condition);				\
+	unlikely(__ret_warn_on);					\
+})
+#endif
+
+#define WARN_ON_ONCE(condition) WARN_ON(condition)
+#define WARN_ONCE(condition, format...) WARN(condition, format)
+#define WARN_TAINT(condition, taint, format...) WARN(condition, format)
+#define WARN_TAINT_ONCE(condition, taint, format...) WARN(condition, format)
+
+#endif
+
 /*
  * WARN_ON_SMP() is for cases that the warning is either
  * meaningless for !SMP or may even cause failures.
_

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch

