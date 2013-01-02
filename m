From: akpm@linux-foundation.org
Subject: + bugh-prevent-double-evaulation-of-in-build_bug_on.patch added to -mm tree
Date: Wed, 02 Jan 2013 13:48:13 -0800
Message-ID: <20130102214814.385A082004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:62492 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab3ABVsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 16:48:15 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so1549480qcq.3
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 13:48:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.santos@pobox.com, ak@linux.intel.com, bp@alien8.de, joe@perches.com, josh@joshtriplett.org, paul.gortmaker@windriver.com, rientjes@google.com


The patch titled
     Subject: bug.h: Prevent double evaulation of in BUILD_BUG_ON
has been added to the -mm tree.  Its filename is
     bugh-prevent-double-evaulation-of-in-build_bug_on.patch

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
Subject: bug.h: Prevent double evaulation of in BUILD_BUG_ON

When calling BUILD_BUG_ON in an optimized build using gcc 4.3 and later,
the condition will be evaulated twice, possibily with side-effects.  This
patch eliminates that error.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/bug.h~bugh-prevent-double-evaulation-of-in-build_bug_on include/linux/bug.h
--- a/include/linux/bug.h~bugh-prevent-double-evaulation-of-in-build_bug_on
+++ a/include/linux/bug.h
@@ -59,8 +59,9 @@ struct pt_regs;
 extern int __build_bug_on_failed;
 #define BUILD_BUG_ON(condition)					\
 	do {							\
-		((void)sizeof(char[1 - 2*!!(condition)]));	\
-		if (condition) __build_bug_on_failed = 1;	\
+		bool __cond = !!(condition);			\
+		((void)sizeof(char[1 - 2 * __cond]));		\
+		if (__cond) __build_bug_on_failed = 1;		\
 	} while(0)
 #endif
 
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

