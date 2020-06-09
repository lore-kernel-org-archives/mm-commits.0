From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 lib-fix-bitmap_parse-on-64-bit-big-endian-archs-fix.patch added to -mm tree
Date: Tue, 09 Jun 2020 15:49:08 -0700
Message-ID: <20200609224908.ssojtmYv8%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728108AbgFIWtJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 18:49:09 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@redhat.com, agordeev@linux.ibm.com, amritha.nambiar@intel.com, andriy.shevchenko@linux.intel.com, chris@chris-wilson.co.uk, keescook@chromium.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, mszeredi@redhat.com, steffen.klassert@secunet.com, tobin@kernel.org, vineet.gupta1@synopsys.com, will.deacon@arm.com, willemb@google.com, willy@infradead.org, yury.norov@gmail.com


The patch titled
     Subject: lib/bitmap: convert infinite while loop to a for loop
has been added to the -mm tree.  Its filename is
     lib-fix-bitmap_parse-on-64-bit-big-endian-archs-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-fix-bitmap_parse-on-64-bit-big-endian-archs-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-fix-bitmap_parse-on-64-bit-big-endian-archs-fix.patch

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

lib-fix-bitmap_parse-on-64-bit-big-endian-archs-fix.patch
