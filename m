From: akpm@linux-foundation.org
Subject: [merged] compilerh-bugh-prevent-double-error-messages-with-build_bug_on.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:37:26 -0800
Message-ID: <20130222203726.D8D6031C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:36282 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011Ab3BVUh2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:28 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so103649ghb.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.santos@pobox.com, ak@linux.intel.com, bp@alien8.de, joe@perches.com, josh@joshtriplett.org, paul.gortmaker@windriver.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler.h, bug.h: prevent double error messages with BUILD_BUG{,_ON}
has been removed from the -mm tree.  Its filename was
     compilerh-bugh-prevent-double-error-messages-with-build_bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Santos <daniel.santos@pobox.com>
Subject: compiler.h, bug.h: prevent double error messages with BUILD_BUG{,_ON}

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
 	} while (0)
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

origin.patch

