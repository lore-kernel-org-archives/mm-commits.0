From: akpm@linux-foundation.org
Subject: +
 lib-string-make-all-calls-to-strnicmp-into-calls-to-strncasecmp.patch added to -mm tree
Date: Fri, 12 Sep 2014 10:59:15 -0700
Message-ID: <54133473.ctsklN0HrErNSEy6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaILR7Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Sep 2014 13:59:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: string: Make all calls to strnicmp into calls to strncasecmp
has been added to the -mm tree.  Its filename is
     lib-string-make-all-calls-to-strnicmp-into-calls-to-strncasecmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string-make-all-calls-to-strnicmp-into-calls-to-strncasecmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string-make-all-calls-to-strnicmp-into-calls-to-strncasecmp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib: string: Make all calls to strnicmp into calls to strncasecmp

The previous patch made strnicmp into a wrapper for strncasecmp.  This
patch makes all in-tree users of strnicmp call strncasecmp directly, while
still making sure that the strnicmp symbol can be used by out-of-tree
modules.  It should be considered a temporary hack until all in-tree
callers have been converted.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    2 +-
 lib/string.c           |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/string.h~lib-string-make-all-calls-to-strnicmp-into-calls-to-strncasecmp include/linux/string.h
--- a/include/linux/string.h~lib-string-make-all-calls-to-strnicmp-into-calls-to-strncasecmp
+++ a/include/linux/string.h
@@ -41,7 +41,7 @@ extern int strcmp(const char *,const cha
 extern int strncmp(const char *,const char *,__kernel_size_t);
 #endif
 #ifndef __HAVE_ARCH_STRNICMP
-extern int strnicmp(const char *, const char *, __kernel_size_t);
+#define strnicmp strncasecmp
 #endif
 #ifndef __HAVE_ARCH_STRCASECMP
 extern int strcasecmp(const char *s1, const char *s2);
diff -puN lib/string.c~lib-string-make-all-calls-to-strnicmp-into-calls-to-strncasecmp lib/string.c
--- a/lib/string.c~lib-string-make-all-calls-to-strnicmp-into-calls-to-strncasecmp
+++ a/lib/string.c
@@ -59,6 +59,7 @@ int strncasecmp(const char *s1, const ch
 EXPORT_SYMBOL(strncasecmp);
 #endif
 #ifndef __HAVE_ARCH_STRNICMP
+#undef strnicmp
 int strnicmp(const char *s1, const char *s2, size_t len)
 {
 	return strncasecmp(s1, s2, len);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

kcmp-fix-standard-comparison-bug.patch
lib-string-remove-duplicated-function.patch
lib-string-make-all-calls-to-strnicmp-into-calls-to-strncasecmp.patch
linux-next.patch

