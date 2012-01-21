From: akpm@linux-foundation.org
Subject: + include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch added to -mm tree
Date: Fri, 20 Jan 2012 16:25:46 -0800
Message-ID: <20120121002546.8E93E1E005F@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:55407 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab2AUAZr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 19:25:47 -0500
Received: by ggnv2 with SMTP id v2so95111ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 16:25:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     Subject: include/ and checkpatch: prefer __scanf to __attribute__((format(scanf,...)
has been added to the -mm tree.  Its filename is
     include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: include/ and checkpatch: prefer __scanf to __attribute__((format(scanf,...)

It's equivalent to __printf, so prefer __scanf.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    3 ++-
 include/linux/kernel.h       |    8 ++++----
 include/xen/xenbus.h         |    4 ++--
 scripts/checkpatch.pl        |    6 ++++++
 4 files changed, 14 insertions(+), 7 deletions(-)

diff -puN include/linux/compiler-gcc.h~include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf
+++ a/include/linux/compiler-gcc.h
@@ -87,7 +87,8 @@
  */
 #define __pure				__attribute__((pure))
 #define __aligned(x)			__attribute__((aligned(x)))
-#define __printf(a,b)			__attribute__((format(printf,a,b)))
+#define __printf(a, b)			__attribute__((format(printf, a, b)))
+#define __scanf(a, b)			__attribute__((format(scanf, a, b)))
 #define  noinline			__attribute__((noinline))
 #define __attribute_const__		__attribute__((__const__))
 #define __maybe_unused			__attribute__((unused))
diff -puN include/linux/kernel.h~include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf include/linux/kernel.h
--- a/include/linux/kernel.h~include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf
+++ a/include/linux/kernel.h
@@ -315,10 +315,10 @@ extern __printf(2, 3)
 char *kasprintf(gfp_t gfp, const char *fmt, ...);
 extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
 
-extern int sscanf(const char *, const char *, ...)
-	__attribute__ ((format (scanf, 2, 3)));
-extern int vsscanf(const char *, const char *, va_list)
-	__attribute__ ((format (scanf, 2, 0)));
+extern __scanf(2, 3)
+int sscanf(const char *, const char *, ...);
+extern __scanf(2, 0)
+int vsscanf(const char *, const char *, va_list);
 
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
diff -puN include/xen/xenbus.h~include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf include/xen/xenbus.h
--- a/include/xen/xenbus.h~include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf
+++ a/include/xen/xenbus.h
@@ -139,9 +139,9 @@ int xenbus_transaction_start(struct xenb
 int xenbus_transaction_end(struct xenbus_transaction t, int abort);
 
 /* Single read and scanf: returns -errno or num scanned if > 0. */
+__scanf(4, 5)
 int xenbus_scanf(struct xenbus_transaction t,
-		 const char *dir, const char *node, const char *fmt, ...)
-	__attribute__((format(scanf, 4, 5)));
+		 const char *dir, const char *node, const char *fmt, ...);
 
 /* Single printf and write: returns -errno or 0. */
 __printf(4, 5)
diff -puN scripts/checkpatch.pl~include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf
+++ a/scripts/checkpatch.pl
@@ -3117,6 +3117,12 @@ sub process {
 			     "__printf(string-index, first-to-check) is preferred over __attribute__((format(printf, string-index, first-to-check)))\n" . $herecurr);
 		}
 
+# Check for __attribute__ format(scanf, prefer __scanf
+		if ($line =~ /\b__attribute__\s*\(\s*\(\s*format\s*\(\s*scanf\b/) {
+			WARN("PREFER_SCANF",
+			     "__scanf(string-index, first-to-check) is preferred over __attribute__((format(scanf, string-index, first-to-check)))\n" . $herecurr);
+		}
+
 # check for sizeof(&)
 		if ($line =~ /\bsizeof\s*\(\s*\&/) {
 			WARN("SIZEOF_ADDRESS",
_
Subject: Subject: include/ and checkpatch: prefer __scanf to __attribute__((format(scanf,...)

Patches currently in -mm which might be from joe@perches.com are

maintainers-update-partitions-block-f-patterns.patch
maintainers-remove-imx5-section.patch
maintainers-remove-staging-sections.patch
maintainers-update-lguest-f-patterns.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
maintainers-fix-remoteproc-f-typo.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch

