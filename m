From: akpm@linux-foundation.org
Subject: [folded-merged] lib-add-test-for-bitmap_parse-fix.patch
 removed from -mm tree
Date: Mon, 03 Feb 2020 17:13:23 -0800
Message-ID: <20200204011323.xPHmRNNaV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbgBDBNZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:13:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@redhat.com, amritha.nambiar@intel.com, andriy.shevchenko@linux.intel.com, chris@chris-wilson.co.uk, keescook@chromium.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, mszeredi@redhat.com, steffen.klassert@secunet.com, tobin@kernel.org, vineet.gupta1@synopsys.com, will.deacon@arm.com, willemb@google.com, willy@infradead.org, yury.norov@gmail.com


The patch titled
     Subject: fix rebase issue
has been removed from the -mm tree.  Its filename was
     lib-add-test-for-bitmap_parse-fix.patch

This patch was dropped because it was folded into lib-add-test-for-bitmap_parse.patch

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: fix rebase issue

Link: http://lkml.kernel.org/r/20200102182659.6685-1-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: "Tobin C . Harding" <tobin@kernel.org>
Cc: Vineet Gupta <vineet.gupta1@synopsys.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_bitmap.c~lib-add-test-for-bitmap_parse-fix
+++ a/lib/test_bitmap.c
@@ -350,7 +350,6 @@ static const struct test_bitmap_parselis
 	{-EINVAL, "0-31:a/1", NULL, 8, 0},
 	{-EINVAL, "0-\n", NULL, 8, 0},
 
-#undef step
 };
 
 static void __init __test_bitmap_parselist(int is_user)
@@ -431,6 +430,7 @@ static const struct test_bitmap_parselis
 	{-EOVERFLOW, "badf00d,deadbeef,1,0",	NULL, 90, 0},
 	{-EOVERFLOW, "fbadf00d,deadbeef,1,0",	NULL, 95, 0},
 	{-EOVERFLOW, "badf00d,deadbeef,1,0",	NULL, 100, 0},
+#undef step
 };
 
 static void __init __test_bitmap_parse(int is_user)
_

Patches currently in -mm which might be from yury.norov@gmail.com are

lib-string-add-strnchrnul.patch
bitops-more-bits_to_-macros.patch
lib-add-test-for-bitmap_parse.patch
lib-make-bitmap_parse_user-a-wrapper-on-bitmap_parse.patch
lib-rework-bitmap_parse.patch
lib-new-testcases-for-bitmap_parse_user.patch
cpumask-dont-calculate-length-of-the-input-string.patch
