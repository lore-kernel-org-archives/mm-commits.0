From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-fix-bitmap_parse-on-64-bit-big-endian-archs-fix.patch removed from -mm
 tree
Date: Wed, 10 Jun 2020 18:19:23 -0700
Message-ID: <20200611011923.31_jhe4wb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbgFKBT1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:19:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@redhat.com, agordeev@linux.ibm.com, amritha.nambiar@intel.com, andriy.shevchenko@linux.intel.com, chris@chris-wilson.co.uk, keescook@chromium.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, mszeredi@redhat.com, steffen.klassert@secunet.com, tobin@kernel.org, vineet.gupta1@synopsys.com, will.deacon@arm.com, willemb@google.com, willy@infradead.org, yury.norov@gmail.com


The patch titled
     Subject: lib/bitmap: convert infinite while loop to a for loop
has been removed from the -mm tree.  Its filename was
     lib-fix-bitmap_parse-on-64-bit-big-endian-archs-fix.patch

This patch was dropped because it was folded into lib-fix-bitmap_parse-on-64-bit-big-endian-archs.patch

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/bitmap: convert infinite while loop to a for loop

Convert infinite while loop to a for loop in order to be more explicit in
one place what we are doing with chunks.

Link: http://lkml.kernel.org/r/20200609140535.87160-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Yury Norov <yury.norov@gmail.com>
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

 lib/bitmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/lib/bitmap.c~lib-fix-bitmap_parse-on-64-bit-big-endian-archs-fix
+++ a/lib/bitmap.c
@@ -740,10 +740,10 @@ int bitmap_parse(const char *start, unsi
 	const char *end = strnchrnul(start, buflen, '\n') - 1;
 	int chunks = BITS_TO_U32(nmaskbits);
 	u32 *bitmap = (u32 *)maskp;
-	int chunk = 0;
 	int unset_bit;
+	int chunk;
 
-	while (1) {
+	for (chunk = 0; ; chunk++) {
 		end = bitmap_find_region_reverse(start, end);
 		if (start > end)
 			break;
@@ -758,7 +758,6 @@ int bitmap_parse(const char *start, unsi
 #endif
 		if (IS_ERR(end))
 			return PTR_ERR(end);
-		chunk++;
 	}
 
 	unset_bit = (BITS_TO_U32(nmaskbits) - chunks) * 32;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-fix-bitmap_parse-on-64-bit-big-endian-archs.patch
