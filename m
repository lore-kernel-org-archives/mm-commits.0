From: akpm@linux-foundation.org
Subject: + test-hash-fix-warning-in-two-dimensional-array-init.patch added to -mm tree
Date: Mon, 29 Aug 2016 16:45:07 -0700
Message-ID: <57c4c903.TOSYv5/dbv7r4Y7i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40570 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756271AbcH2Xpg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 19:45:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, arnd@arndb.de, linux@sciencehorizons.net, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_hash.c: fix warning in two-dimensional array init
has been added to the -mm tree.  Its filename is
     test-hash-fix-warning-in-two-dimensional-array-init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test-hash-fix-warning-in-two-dimensional-array-init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test-hash-fix-warning-in-two-dimensional-array-init.patch

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
Subject: lib/test_hash.c: fix warning in two-dimensional array init

lib/test_hash.c: In function 'test_hash_init':
lib/test_hash.c:146:2: warning: missing braces around initializer [-Wmissing-braces]

Fixes: 468a9428521e7d00 ("<linux/hash.h>: Add support for architecture-specific functions")
Link: http://lkml.kernel.org/r/20160829214952.1334674-3-arnd@arndb.de
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: George Spelvin <linux@sciencehorizons.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/test_hash.c~test-hash-fix-warning-in-two-dimensional-array-init lib/test_hash.c
--- a/lib/test_hash.c~test-hash-fix-warning-in-two-dimensional-array-init
+++ a/lib/test_hash.c
@@ -143,7 +143,7 @@ static int __init
 test_hash_init(void)
 {
 	char buf[SIZE+1];
-	u32 string_or = 0, hash_or[2][33] = { 0 };
+	u32 string_or = 0, hash_or[2][33] = { { 0, } };
 	unsigned tests = 0;
 	unsigned long long h64 = 0;
 	int i, j;
_

Patches currently in -mm which might be from geert@linux-m68k.org are

test-hash-fix-warning-in-two-dimensional-array-init.patch
test-hash-fix-warning-in-preprocessor-symbol-evaluation.patch

