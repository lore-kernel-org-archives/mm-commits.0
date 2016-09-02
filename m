From: akpm@linux-foundation.org
Subject: [merged]
 test-hash-fix-warning-in-two-dimensional-array-init.patch removed from -mm
 tree
Date: Fri, 02 Sep 2016 12:00:55 -0700
Message-ID: <57c9cc67.Q0ZNJHZnUOEpA65F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32979 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753900AbcIBTA4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2016 15:00:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, arnd@arndb.de, linux@sciencehorizons.net, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_hash.c: fix warning in two-dimensional array init
has been removed from the -mm tree.  Its filename was
     test-hash-fix-warning-in-two-dimensional-array-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


