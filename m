From: akpm@linux-foundation.org
Subject: + compilerh-bugh-prevent-double-error-messages-with-build_bug_on.patch added to -mm tree
Date: Wed, 02 Jan 2013 13:48:20 -0800
Message-ID: <20130102214821.B1451200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f73.google.com ([209.85.214.73]:36861 "EHLO
	mail-bk0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab3ABVsZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 16:48:25 -0500
Received: by mail-bk0-f73.google.com with SMTP id jf3so908253bkc.4
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 13:48:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.santos@pobox.com, ak@linux.intel.com, bp@alien8.de, joe@perches.com, josh@joshtriplett.org, paul.gortmaker@windriver.com, rientjes@google.com


The patch titled
     Subject: compiler.h, bug.h: Prevent double error messages with BUILD_BUG{,_ON}
has been added to the -mm tree.  Its filename is
     compilerh-bugh-prevent-double-error-messages-with-build_bug_on.patch

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
Subject: compiler.h, bug.h: Prevent double error messages with BUILD_BUG{,_ON}

Prior to the introduction of __attribute__((error("msg"))) in gcc 4.3,
creating compile-time errors required a little trickery.  BUILD_BUG{,_ON}
uses this attribute when available to generate compile-time errors, but
also uses the negative-sized array trick for older compilers, resulting in
two error messages in some cases.  The reason it's "some" cases is that as
of gcc 4.4, the negative-sized array will not create an error in some
situations, like inline functions.

This patch replaces the negative-sized array code with the new
__compiletime_error_fallback() macro which expands to the same thing
unless the the error attribute is available, in which case it expands to
do{}while(0), resulting in exactly one compile-time error on all versions
of gcc.

Note that we are not changing the negative-sized array code for the
unoptimized version of BUILD_BUG_ON, since it has the potential to catch
problems that would be disabled in later versions of gcc were
__compiletime_error_fallback used.  The reason is that that an unoptimized
build can't always remove calls to an error-attributed function call (like
we are using) that should effectively become dead code if it were
optimized.  However, using a negative-sized array with a similar value
will not result in an false-positive (error).  The only caveat being that
it will also fail to catch valid conditions, which we should be expecting
in an unoptimized build anyway.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h      |    2 +-
 include/linux/compiler.h |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN include/linux/bug.h~compilerh-bugh-prevent-double-error-messages-with-build_bug_on include/linux/bug.h
--- a/include/linux/bug.h~compilerh-bugh-prevent-double-error-messages-with-build_bug_on
+++ a/include/linux/bug.h
@@ -67,7 +67,7 @@ struct pt_regs;
 			__compiletime_error("BUILD_BUG_ON failed");	\
 		if (__cond)						\
 			__build_bug_on_failed();			\
-		((void)sizeof(char[1 - 2 * __cond]));			\
+		__compiletime_error_fallback(__cond);			\
 	} while(0)
 #endif
 
diff -puN include/linux/compiler.h~compilerh-bugh-prevent-double-error-messages-with-build_bug_on include/linux/compiler.h
--- a/include/linux/compiler.h~compilerh-bugh-prevent-double-error-messages-with-build_bug_on
+++ a/include/linux/compiler.h
@@ -307,7 +307,12 @@ void ftrace_likely_update(struct ftrace_
 #endif
 #ifndef __compiletime_error
 # define __compiletime_error(message)
+# define __compiletime_error_fallback(condition) \
+	do { ((void)sizeof(char[1 - 2*!!(condition)])); } while (0)
+#else
+# define __compiletime_error_fallback(condition) do { } while (0)
 #endif
+
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
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

