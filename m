From: akpm@linux-foundation.org
Subject: + lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch
 added to -mm tree
Date: Mon, 14 Sep 2015 14:10:58 -0700
Message-ID: <55f737e2.+tXKduaIhAe+9aJ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbbINVK7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:10:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/halfmd4.c: use rol32 inline function in the ROUND macro
has been added to the -mm tree.  Its filename is
     lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: lib/halfmd4.c: use rol32 inline function in the ROUND macro

<linux/bitops.h> provides rol32() inline function, let's use already
predefined function instead of direct expression.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/halfmd4.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/halfmd4.c~lib-halfmd4-use-rol32-inline-function-in-the-round-macro lib/halfmd4.c
--- a/lib/halfmd4.c~lib-halfmd4-use-rol32-inline-function-in-the-round-macro
+++ a/lib/halfmd4.c
@@ -1,6 +1,7 @@
 #include <linux/compiler.h>
 #include <linux/export.h>
 #include <linux/cryptohash.h>
+#include <linux/bitops.h>
 
 /* F, G and H are basic MD4 functions: selection, majority, parity */
 #define F(x, y, z) ((z) ^ ((x) & ((y) ^ (z))))
@@ -14,7 +15,7 @@
  * Rotation is separate from addition to prevent recomputation
  */
 #define ROUND(f, a, b, c, d, x, s)	\
-	(a += f(b, c, d) + x, a = (a << s) | (a >> (32 - s)))
+	(a += f(b, c, d) + x, a = rol32(a, s))
 #define K1 0
 #define K2 013240474631UL
 #define K3 015666365641UL
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

