From: akpm@linux-foundation.org
Subject: [merged]
 test_bitmap-use-ull-suffix-for-64-bit-constants.patch removed from -mm tree
Date: Fri, 15 Sep 2017 10:51:19 -0700
Message-ID: <20170915175119.Yxm2MzFBT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35386 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbdIORvU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2017 13:51:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org, ynorov@caviumnetworks.com


The patch titled
     Subject: lib/test_bitmap.c: use ULL suffix for 64-bit constants
has been removed from the -mm tree.  Its filename was
     test_bitmap-use-ull-suffix-for-64-bit-constants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from geert@linux-m68k.org are


