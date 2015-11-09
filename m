From: akpm@linux-foundation.org
Subject: [merged]
 lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch removed from -mm tree
Date: Mon, 09 Nov 2015 12:12:34 -0800
Message-ID: <5640fe32.4SPE7+tb2wm9mTfa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbbKIUMf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:12:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/halfmd4.c: use rol32 inline function in the ROUND macro
has been removed from the -mm tree.  Its filename was
     lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


