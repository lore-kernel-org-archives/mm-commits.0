From: akpm@linux-foundation.org
Subject: [patch 4/9] lib/test_bitmap.c: use ULL suffix for 64-bit
 constants
Date: Wed, 13 Sep 2017 16:28:20 -0700
Message-ID: <59b9bf14.IT03OQ2Po1Ole8WI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56528 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdIMX2V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2017 19:28:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, geert@linux-m68k.org, ynorov@caviumnetworks.com

From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: lib/test_bitmap.c: use ULL suffix for 64-bit constants

With gcc 4.1.2:

    lib/test_bitmap.c:189: warning: integer constant is too large for `long' type
    lib/test_bitmap.c:190: warning: integer constant is too large for `long' type
    lib/test_bitmap.c:194: warning: integer constant is too large for `long' type
    lib/test_bitmap.c:195: warning: integer constant is too large for `long' type

Add the missing "ULL" suffix to fix this.

Link: http://lkml.kernel.org/r/1505040523-31230-1-git-send-email-geert@linux-m68k.org
Fixes: 60ef690018b262dd ("bitmap: introduce BITMAP_FROM_U64()")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/test_bitmap.c~test_bitmap-use-ull-suffix-for-64-bit-constants lib/test_bitmap.c
--- a/lib/test_bitmap.c~test_bitmap-use-ull-suffix-for-64-bit-constants
+++ a/lib/test_bitmap.c
@@ -186,13 +186,13 @@ static const unsigned long exp[] __initc
 	BITMAP_FROM_U64(0x22222222),
 	BITMAP_FROM_U64(0xffffffff),
 	BITMAP_FROM_U64(0xfffffffe),
-	BITMAP_FROM_U64(0x3333333311111111),
-	BITMAP_FROM_U64(0xffffffff77777777)
+	BITMAP_FROM_U64(0x3333333311111111ULL),
+	BITMAP_FROM_U64(0xffffffff77777777ULL)
 };
 
 static const unsigned long exp2[] __initconst = {
-	BITMAP_FROM_U64(0x3333333311111111),
-	BITMAP_FROM_U64(0xffffffff77777777)
+	BITMAP_FROM_U64(0x3333333311111111ULL),
+	BITMAP_FROM_U64(0xffffffff77777777ULL)
 };
 
 static const struct test_bitmap_parselist parselist_tests[] __initconst = {
_
