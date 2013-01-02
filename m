From: akpm@linux-foundation.org
Subject: + bugh-fix-build_bug_on-macro-in-__checker__.patch added to -mm tree
Date: Wed, 02 Jan 2013 13:48:09 -0800
Message-ID: <20130102214810.83AE120005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:45595 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab3ABVsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 16:48:14 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so907511fav.2
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 13:48:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.santos@pobox.com, ak@linux.intel.com, bp@alien8.de, joe@perches.com, josh@joshtriplett.org, paul.gortmaker@windriver.com, rientjes@google.com


The patch titled
     Subject: bug.h: Fix BUILD_BUG_ON macro in __CHECKER__
has been added to the -mm tree.  Its filename is
     bugh-fix-build_bug_on-macro-in-__checker__.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Santos <daniel.santos@pobox.com>
Subject: bug.h: Fix BUILD_BUG_ON macro in __CHECKER__

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

compiler-gcc4h-reorder-macros-based-upon-gcc-ver.patch
compiler-gcch-add-gcc-recommended-gcc_version-macro.patch
compiler-gcc34h-use-gcc_version-macro.patch
compiler-gcc4h-bugh-remove-duplicate-macros.patch
bugh-fix-build_bug_on-macro-in-__checker__.patch
bugh-prevent-double-evaulation-of-in-build_bug_on.patch
bugh-make-build_bug_on-generate-compile-time-error.patch
compilerh-bugh-prevent-double-error-messages-with-build_bug_on.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg.patch

