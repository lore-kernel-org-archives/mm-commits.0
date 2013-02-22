From: akpm@linux-foundation.org
Subject: [merged] bugh-fix-build_bug_on-macro-in-__checker__.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:37:17 -0800
Message-ID: <20130222203717.C400231C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:33105 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab3BVUhT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:19 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so103613qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.santos@pobox.com, ak@linux.intel.com, bp@alien8.de, joe@perches.com, josh@joshtriplett.org, paul.gortmaker@windriver.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bug.h: fix BUILD_BUG_ON macro in __CHECKER__
has been removed from the -mm tree.  Its filename was
     bugh-fix-build_bug_on-macro-in-__checker__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Santos <daniel.santos@pobox.com>
Subject: bug.h: fix BUILD_BUG_ON macro in __CHECKER__

When __CHECKER__ is defined, we disable all of the BUILD_BUG.* macros. 
However, both BUILD_BUG_ON_NOT_POWER_OF_2 and BUILD_BUG_ON was evaluating
to nothing in this case, and we want (0) since this is a function-like
macro that will be followed by a semicolon.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/bug.h~bugh-fix-build_bug_on-macro-in-__checker__ include/linux/bug.h
--- a/include/linux/bug.h~bugh-fix-build_bug_on-macro-in-__checker__
+++ a/include/linux/bug.h
@@ -12,11 +12,11 @@ enum bug_trap_type {
 struct pt_regs;
 
 #ifdef __CHECKER__
-#define BUILD_BUG_ON_NOT_POWER_OF_2(n)
+#define BUILD_BUG_ON_NOT_POWER_OF_2(n) (0)
 #define BUILD_BUG_ON_ZERO(e) (0)
 #define BUILD_BUG_ON_NULL(e) ((void*)0)
 #define BUILD_BUG_ON_INVALID(e) (0)
-#define BUILD_BUG_ON(condition)
+#define BUILD_BUG_ON(condition) (0)
 #define BUILD_BUG() (0)
 #else /* __CHECKER__ */
 
_

Patches currently in -mm which might be from daniel.santos@pobox.com are

origin.patch

