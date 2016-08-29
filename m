From: akpm@linux-foundation.org
Subject: + test-hash-fix-warning-in-preprocessor-symbol-evaluation.patch
 added to -mm tree
Date: Mon, 29 Aug 2016 16:45:09 -0700
Message-ID: <57c4c905.XtgkufcXcaF3UYrD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40575 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756493AbcH2Xpg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 19:45:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, arnd@arndb.de, linux@sciencehorizons.net, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_hash.c: fix warning in preprocessor symbol evaluation
has been added to the -mm tree.  Its filename is
     test-hash-fix-warning-in-preprocessor-symbol-evaluation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test-hash-fix-warning-in-preprocessor-symbol-evaluation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test-hash-fix-warning-in-preprocessor-symbol-evaluation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: lib/test_hash.c: fix warning in preprocessor symbol evaluation

Some versions of gcc don't like tests for the value of an undefined
preprocessor symbol, even in the #else branch of an #ifndef:

    lib/test_hash.c:224:7: warning: "HAVE_ARCH__HASH_32" is not defined [-Wundef]
     #elif HAVE_ARCH__HASH_32 != 1
	   ^
    lib/test_hash.c:229:7: warning: "HAVE_ARCH_HASH_32" is not defined [-Wundef]
     #elif HAVE_ARCH_HASH_32 != 1
	   ^
    lib/test_hash.c:234:7: warning: "HAVE_ARCH_HASH_64" is not defined [-Wundef]
     #elif HAVE_ARCH_HASH_64 != 1
	   ^

Seen with gcc 4.9, not seen with 4.1.2.

Change the logic to only check the value inside an #ifdef to fix this.

Fixes: 468a9428521e7d00 ("<linux/hash.h>: Add support for architecture-specific functions")
Link: http://lkml.kernel.org/r/20160829214952.1334674-4-arnd@arndb.de
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: George Spelvin <linux@sciencehorizons.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hash.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff -puN lib/test_hash.c~test-hash-fix-warning-in-preprocessor-symbol-evaluation lib/test_hash.c
--- a/lib/test_hash.c~test-hash-fix-warning-in-preprocessor-symbol-evaluation
+++ a/lib/test_hash.c
@@ -219,21 +219,27 @@ test_hash_init(void)
 	}
 
 	/* Issue notices about skipped tests. */
-#ifndef HAVE_ARCH__HASH_32
-	pr_info("__hash_32() has no arch implementation to test.");
-#elif HAVE_ARCH__HASH_32 != 1
+#ifdef HAVE_ARCH__HASH_32
+#if HAVE_ARCH__HASH_32 != 1
 	pr_info("__hash_32() is arch-specific; not compared to generic.");
 #endif
-#ifndef HAVE_ARCH_HASH_32
-	pr_info("hash_32() has no arch implementation to test.");
-#elif HAVE_ARCH_HASH_32 != 1
+#else
+	pr_info("__hash_32() has no arch implementation to test.");
+#endif
+#ifdef HAVE_ARCH_HASH_32
+#if HAVE_ARCH_HASH_32 != 1
 	pr_info("hash_32() is arch-specific; not compared to generic.");
 #endif
-#ifndef HAVE_ARCH_HASH_64
-	pr_info("hash_64() has no arch implementation to test.");
-#elif HAVE_ARCH_HASH_64 != 1
+#else
+	pr_info("hash_32() has no arch implementation to test.");
+#endif
+#ifdef HAVE_ARCH_HASH_64
+#if HAVE_ARCH_HASH_64 != 1
 	pr_info("hash_64() is arch-specific; not compared to generic.");
 #endif
+#else
+	pr_info("hash_64() has no arch implementation to test.");
+#endif
 
 	pr_notice("%u tests passed.", tests);
 
_

Patches currently in -mm which might be from geert@linux-m68k.org are

test-hash-fix-warning-in-two-dimensional-array-init.patch
test-hash-fix-warning-in-preprocessor-symbol-evaluation.patch

