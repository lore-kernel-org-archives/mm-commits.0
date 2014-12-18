From: akpm@linux-foundation.org
Subject: + lib-string_get_size-use-32-bit-arithmetic-when-possible.patch
 added to -mm tree
Date: Thu, 18 Dec 2014 13:46:39 -0800
Message-ID: <54934b3f.x49cDp9H49A4rugg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaLRVqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 16:46:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string_helpers.c:string_get_size(): use 32 bit arithmetic when possible
has been added to the -mm tree.  Its filename is
     lib-string_get_size-use-32-bit-arithmetic-when-possible.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string_get_size-use-32-bit-arithmetic-when-possible.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string_get_size-use-32-bit-arithmetic-when-possible.patch

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
Subject: lib/string_helpers.c:string_get_size(): use 32 bit arithmetic when possible

The remainder from do_div is always a u32, and after size has been reduced
to be below 1000 (or 1024), it certainly fits in u32.  So both remainder
and sf_cap can be made u32s, the format specifiers can be simplified (%lld
wasn't the right thing to use for _unsigned_ long long anyway), and we can
replace a do_div with an ordinary 32/32 bit division.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN lib/string_helpers.c~lib-string_get_size-use-32-bit-arithmetic-when-possible lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_get_size-use-32-bit-arithmetic-when-possible
+++ a/lib/string_helpers.c
@@ -42,7 +42,7 @@ int string_get_size(u64 size, const enum
 		[STRING_UNITS_2] = 1024,
 	};
 	int i, j;
-	u64 remainder = 0, sf_cap;
+	u32 remainder = 0, sf_cap;
 	char tmp[8];
 
 	tmp[0] = '\0';
@@ -59,14 +59,13 @@ int string_get_size(u64 size, const enum
 
 		if (j) {
 			remainder *= 1000;
-			do_div(remainder, divisor[units]);
-			snprintf(tmp, sizeof(tmp), ".%03lld",
-				 (unsigned long long)remainder);
+			remainder /= divisor[units];
+			snprintf(tmp, sizeof(tmp), ".%03u", remainder);
 			tmp[j+1] = '\0';
 		}
 	}
 
-	snprintf(buf, len, "%lld%s %s", (unsigned long long)size,
+	snprintf(buf, len, "%u%s %s", (u32)size,
 		 tmp, units_str[units][i]);
 
 	return 0;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
lib-string_get_size-remove-redundant-prefixes.patch
lib-string_get_size-use-32-bit-arithmetic-when-possible.patch
lib-string_get_size-return-void.patch

