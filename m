From: akpm@linux-foundation.org
Subject: + kstrtox-fix-compile-warnings-in-test.patch added to -mm tree
Date: Wed, 30 Mar 2011 14:48:39 -0700
Message-ID: <201103302148.p2ULmdSj012724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933066Ab1C3WOQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 18:14:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, geert@linux-m68k.org


The patch titled
     kstrtox: fix compile warnings in test
has been added to the -mm tree.  Its filename is
     kstrtox-fix-compile-warnings-in-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kstrtox: fix compile warnings in test
From: Alexey Dobriyan <adobriyan@gmail.com>

Fix the following warnings:

  CC [M]  lib/test-kstrtox.o
lib/test-kstrtox.c: In function 'test_kstrtou64_ok':
lib/test-kstrtox.c:318: warning: this decimal constant is unsigned only in ISO C90
	...

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test-kstrtox.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN lib/test-kstrtox.c~kstrtox-fix-compile-warnings-in-test lib/test-kstrtox.c
--- a/lib/test-kstrtox.c~kstrtox-fix-compile-warnings-in-test
+++ a/lib/test-kstrtox.c
@@ -315,12 +315,12 @@ static void __init test_kstrtou64_ok(voi
 		{"65537",	10,	65537},
 		{"2147483646",	10,	2147483646},
 		{"2147483647",	10,	2147483647},
-		{"2147483648",	10,	2147483648},
-		{"2147483649",	10,	2147483649},
-		{"4294967294",	10,	4294967294},
-		{"4294967295",	10,	4294967295},
-		{"4294967296",	10,	4294967296},
-		{"4294967297",	10,	4294967297},
+		{"2147483648",	10,	2147483648ULL},
+		{"2147483649",	10,	2147483649ULL},
+		{"4294967294",	10,	4294967294ULL},
+		{"4294967295",	10,	4294967295ULL},
+		{"4294967296",	10,	4294967296ULL},
+		{"4294967297",	10,	4294967297ULL},
 		{"9223372036854775806",	10,	9223372036854775806ULL},
 		{"9223372036854775807",	10,	9223372036854775807ULL},
 		{"9223372036854775808",	10,	9223372036854775808ULL},
@@ -369,12 +369,12 @@ static void __init test_kstrtos64_ok(voi
 		{"65537",	10,	65537},
 		{"2147483646",	10,	2147483646},
 		{"2147483647",	10,	2147483647},
-		{"2147483648",	10,	2147483648},
-		{"2147483649",	10,	2147483649},
-		{"4294967294",	10,	4294967294},
-		{"4294967295",	10,	4294967295},
-		{"4294967296",	10,	4294967296},
-		{"4294967297",	10,	4294967297},
+		{"2147483648",	10,	2147483648LL},
+		{"2147483649",	10,	2147483649LL},
+		{"4294967294",	10,	4294967294LL},
+		{"4294967295",	10,	4294967295LL},
+		{"4294967296",	10,	4294967296LL},
+		{"4294967297",	10,	4294967297LL},
 		{"9223372036854775806",	10,	9223372036854775806LL},
 		{"9223372036854775807",	10,	9223372036854775807LL},
 	};
@@ -418,10 +418,10 @@ static void __init test_kstrtou32_ok(voi
 		{"65537",	10,	65537},
 		{"2147483646",	10,	2147483646},
 		{"2147483647",	10,	2147483647},
-		{"2147483648",	10,	2147483648},
-		{"2147483649",	10,	2147483649},
-		{"4294967294",	10,	4294967294},
-		{"4294967295",	10,	4294967295},
+		{"2147483648",	10,	2147483648U},
+		{"2147483649",	10,	2147483649U},
+		{"4294967294",	10,	4294967294U},
+		{"4294967295",	10,	4294967295U},
 	};
 	TEST_OK(kstrtou32, u32, "%u", test_u32_ok);
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

kstrtox-fix-compile-warnings-in-test.patch
kstrtox-convert-fs-proc.patch
proc-constify-status-array.patch
proc-stat-use-defined-macro-kmalloc_max_size.patch
sysctl-add-proc_dointvec_bool-handler.patch

