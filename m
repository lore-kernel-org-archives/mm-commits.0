From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 64/67] lib: new testcases for bitmap_parse{_user}
Date: Mon, 03 Feb 2020 17:37:38 -0800
Message-ID: <20200204013738.kRc4a54jr%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgBDBhj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:37:39 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@redhat.com, akpm@linux-foundation.org, amritha.nambiar@intel.com, andriy.shevchenko@linux.intel.com, chris@chris-wilson.co.uk, keescook@chromium.org, linux-mm@kvack.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, mszeredi@redhat.com, steffen.klassert@secunet.com, tobin@kernel.org, torvalds@linux-foundation.org, vineet.gupta1@synopsys.com, will.deacon@arm.com, willemb@google.com, willy@infradead.org, yury.norov@gmail.com

From: Yury Norov <yury.norov@gmail.com>
Subject: lib: new testcases for bitmap_parse{_user}

New version of bitmap_parse() is unified with bitmap_parse_list(),
and therefore:

- weakens rules on whitespaces and commas between hex chunks;

- in addition to

- allows passing UINT_MAX or any other big number as the length of input
  string instead of actual string length.

The patch covers the cases.

Link: http://lkml.kernel.org/r/20200102043031.30357-7-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Amritha Nambiar <amritha.nambiar@intel.com>
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

 lib/test_bitmap.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/lib/test_bitmap.c~lib-new-testcases-for-bitmap_parse_user
+++ a/lib/test_bitmap.c
@@ -415,14 +415,22 @@ static const unsigned long parse_test2[]
 };
 
 static const struct test_bitmap_parselist parse_tests[] __initconst = {
+	{0, "",				&parse_test[0 * step], 32, 0},
+	{0, " ",			&parse_test[0 * step], 32, 0},
 	{0, "0",			&parse_test[0 * step], 32, 0},
+	{0, "0\n",			&parse_test[0 * step], 32, 0},
 	{0, "1",			&parse_test[1 * step], 32, 0},
 	{0, "deadbeef",			&parse_test[2 * step], 32, 0},
 	{0, "1,0",			&parse_test[3 * step], 33, 0},
+	{0, "deadbeef,\n,0,1",		&parse_test[2 * step], 96, 0},
 
 	{0, "deadbeef,1,0",		&parse_test2[0 * 2 * step], 96, 0},
 	{0, "baadf00d,deadbeef,1,0",	&parse_test2[1 * 2 * step], 128, 0},
 	{0, "badf00d,deadbeef,1,0",	&parse_test2[2 * 2 * step], 124, 0},
+	{0, "badf00d,deadbeef,1,0",	&parse_test2[2 * 2 * step], 124, NO_LEN},
+	{0, "  badf00d,deadbeef,1,0  ",	&parse_test2[2 * 2 * step], 124, 0},
+	{0, " , badf00d,deadbeef,1,0 , ",	&parse_test2[2 * 2 * step], 124, 0},
+	{0, " , badf00d, ,, ,,deadbeef,1,0 , ",	&parse_test2[2 * 2 * step], 124, 0},
 
 	{-EINVAL,    "goodfood,deadbeef,1,0",	NULL, 128, 0},
 	{-EOVERFLOW, "3,0",			NULL, 33, 0},
_
