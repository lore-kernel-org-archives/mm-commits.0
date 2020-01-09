From: akpm@linux-foundation.org
Subject: + lib-add-test-for-bitmap_parse-fix-2.patch added to -mm
 tree
Date: Thu, 09 Jan 2020 13:53:45 -0800
Message-ID: <20200109215345.BX6ydXre8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgAIVxq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jan 2020 16:53:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, linux@roeck-us.net, mm-commits@vger.kernel.org, yury.norov@gmail.com


The patch titled
     Subject: lib/test_bitmap: fix address space when test user buffer
has been added to the -mm tree.  Its filename is
     lib-add-test-for-bitmap_parse-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-add-test-for-bitmap_parse-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-add-test-for-bitmap_parse-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-test_bitmap-correct-test-data-offsets-for-32-bit.patch
ocfs2-dlm-move-bits_to_bytes-to-bitopsh-for-wider-use.patch
mm-early_remap-use-%pa-to-print-resource_size_t-variables.patch
io-mapping-use-phys_pfn-macro-in-io_mapping_map_atomic_wc.patch
lib-add-test-for-bitmap_parse-fix-2.patch
