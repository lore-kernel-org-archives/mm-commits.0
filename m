From: akpm@linux-foundation.org
Subject: + linux-linkageh-fix-symbol-prefix-handling.patch added to -mm tree
Date: Fri, 08 Mar 2013 15:43:22 -0800
Message-ID: <20130308234322.7807C31C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:36313 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3CHXnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Mar 2013 18:43:23 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so215490vcd.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Mar 2013 15:43:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: james.hogan@imgtec.com


The patch titled
     Subject: linux/linkage.h: fix symbol prefix handling
has been added to the -mm tree.  Its filename is
     linux-linkageh-fix-symbol-prefix-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: James Hogan <james.hogan@imgtec.com>
Subject: linux/linkage.h: fix symbol prefix handling

e1b5bb6d1236d4a ("consolidate cond_syscall and SYSCALL_ALIAS
declarations") broke the build on blackfin and metag due to the following
code:

  #ifndef SYMBOL_NAME
  #ifdef CONFIG_SYMBOL_PREFIX
  #define SYMBOL_NAME(x) CONFIG_SYMBOL_PREFIX ## x
  #else
  #define SYMBOL_NAME(x) x
  #endif
  #endif
  #define __SYMBOL_NAME(x) __stringify(SYMBOL_NAME(x))

__stringify literally stringifies CONFIG_SYMBOL_PREFIX ##x, so you get
lines like this in the assembly output:

  .weak CONFIG_SYMBOL_PREFIXsys_quotactl
  .set
  CONFIG_SYMBOL_PREFIXsys_quotactl,CONFIG_SYMBOL_PREFIXsys_ni_syscall

This is fixed by defining SYMBOL_PREFIX from the command line for c files
in addition to assembly for architectures that set CONFIG_SYMBOL_PREFIX
(scripts/Makefile.lib), and defining __SYMBOL_NAME as:

  #define __SYMBOL_NAME(x) __stringify(SYMBOL_PREFIX) #x

We first have to ensure SYMBOL_PREFIX is defined (which avoids polluting
the command lines for architectures that don't use symbol prefixes).  Also
the definition of SYMBOL_PREFIX in <linux/kernel.h> is removed as it
conflicts, isn't used anywhere, and is defined as a string so differs from
the assembly definition.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h  |    7 -------
 include/linux/linkage.h |   12 +++++-------
 scripts/Makefile.lib    |    1 +
 3 files changed, 6 insertions(+), 14 deletions(-)

diff -puN include/linux/kernel.h~linux-linkageh-fix-symbol-prefix-handling include/linux/kernel.h
--- a/include/linux/kernel.h~linux-linkageh-fix-symbol-prefix-handling
+++ a/include/linux/kernel.h
@@ -723,13 +723,6 @@ static inline void ftrace_dump(enum ftra
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
 
-/* This helps us to avoid #ifdef CONFIG_SYMBOL_PREFIX */
-#ifdef CONFIG_SYMBOL_PREFIX
-#define SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
-#else
-#define SYMBOL_PREFIX ""
-#endif
-
 /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
diff -puN include/linux/linkage.h~linux-linkageh-fix-symbol-prefix-handling include/linux/linkage.h
--- a/include/linux/linkage.h~linux-linkageh-fix-symbol-prefix-handling
+++ a/include/linux/linkage.h
@@ -15,14 +15,12 @@
 #define asmlinkage CPP_ASMLINKAGE
 #endif
 
-#ifndef SYMBOL_NAME
-#ifdef CONFIG_SYMBOL_PREFIX
-#define SYMBOL_NAME(x) CONFIG_SYMBOL_PREFIX ## x
-#else
-#define SYMBOL_NAME(x) x
+/* This helps us to avoid #ifdef SYMBOL_PREFIX */
+#ifndef SYMBOL_PREFIX
+#define SYMBOL_PREFIX
 #endif
-#endif
-#define __SYMBOL_NAME(x) __stringify(SYMBOL_NAME(x))
+
+#define __SYMBOL_NAME(x) __stringify(SYMBOL_PREFIX) #x
 
 #ifndef cond_syscall
 #define cond_syscall(x) asm(".weak\t" __SYMBOL_NAME(x) \
diff -puN scripts/Makefile.lib~linux-linkageh-fix-symbol-prefix-handling scripts/Makefile.lib
--- a/scripts/Makefile.lib~linux-linkageh-fix-symbol-prefix-handling
+++ a/scripts/Makefile.lib
@@ -123,6 +123,7 @@ ifdef CONFIG_SYMBOL_PREFIX
 _sym_flags = -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
 _cpp_flags += $(_sym_flags)
 _a_flags += $(_sym_flags)
+_c_flags += $(_sym_flags)
 endif
 
 
_

Patches currently in -mm which might be from james.hogan@imgtec.com are

linux-next.patch
linux-linkageh-fix-symbol-prefix-handling.patch
debug_locksh-make-warning-more-verbose.patch

