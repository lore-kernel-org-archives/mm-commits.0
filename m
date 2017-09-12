From: akpm@linux-foundation.org
Subject: + test_bitmap-use-ull-suffix-for-64-bit-constants.patch added to
 -mm tree
Date: Tue, 12 Sep 2017 16:15:09 -0700
Message-ID: <59b86a7d.pUlwq5akUdhsFIKl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53364 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbdILXPK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Sep 2017 19:15:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_bitmap.c: use ULL suffix for 64-bit constants
has been added to the -mm tree.  Its filename is
     test_bitmap-use-ull-suffix-for-64-bit-constants.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_bitmap-use-ull-suffix-for-64-bit-constants.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_bitmap-use-ull-suffix-for-64-bit-constants.patch

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

test_bitmap-use-ull-suffix-for-64-bit-constants.patch

