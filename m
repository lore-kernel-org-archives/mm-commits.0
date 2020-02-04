From: akpm@linux-foundation.org
Subject: [folded-merged] lib-add-test-for-bitmap_parse-fix-2.patch
 removed from -mm tree
Date: Mon, 03 Feb 2020 17:13:27 -0800
Message-ID: <20200204011327.ydd7G8Pcu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbgBDBN2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:13:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, linux@roeck-us.net, mm-commits@vger.kernel.org, yury.norov@gmail.com


The patch titled
     Subject: lib/test_bitmap: fix address space when test user buffer
has been removed from the -mm tree.  Its filename was
     lib-add-test-for-bitmap_parse-fix-2.patch

This patch was dropped because it was folded into lib-add-test-for-bitmap_parse.patch

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/test_bitmap: fix address space when test user buffer

Force address space to avoid the following warning:

lib/test_bitmap.c:461:53: warning: incorrect type in argument 1 (different address spaces)
lib/test_bitmap.c:461:53:    expected char const [noderef] <asn:1> *ubuf
lib/test_bitmap.c:461:53:    got char const *in

Link: http://lkml.kernel.org/r/20200109103601.45929-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/test_bitmap.c~lib-add-test-for-bitmap_parse-fix-2
+++ a/lib/test_bitmap.c
@@ -450,7 +450,8 @@ static void __init __test_bitmap_parse(i
 
 			set_fs(KERNEL_DS);
 			time = ktime_get();
-			err = bitmap_parse_user(test.in, len, bmap, test.nbits);
+			err = bitmap_parse_user((__force const char __user *)test.in, len,
+						bmap, test.nbits);
 			time = ktime_get() - time;
 			set_fs(orig_fs);
 		} else {
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-add-test-for-bitmap_parse.patch
