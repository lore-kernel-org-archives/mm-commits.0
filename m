From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 07/25] lib: fix bitmap_parse() on 64-bit big
 endian archs
Date: Wed, 10 Jun 2020 18:41:41 -0700
Message-ID: <20200611014141.jChxhHGSk%akpm@linux-foundation.org>
References: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgFKBln (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:41:43 -0400
In-Reply-To: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@redhat.com, agordeev@linux.ibm.com, akpm@linux-foundation.org, amritha.nambiar@intel.com, andriy.shevchenko@linux.intel.com, andy.shevchenko@gmail.com, chris@chris-wilson.co.uk, keescook@chromium.org, linux-mm@kvack.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, mszeredi@redhat.com, stable@vger.kernel.org, steffen.klassert@secunet.com, tobin@kernel.org, torvalds@linux-foundation.org, vineet.gupta1@synopsys.com, will.deacon@arm.com, willemb@google.com, willy@infradead.org, yury.norov@gmail.com

From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: lib: fix bitmap_parse() on 64-bit big endian archs

Commit 2d6261583be0 ("lib: rework bitmap_parse()") does not take into
account order of halfwords on 64-bit big endian architectures.  As result
(at least) Receive Packet Steering, IRQ affinity masks and runtime kernel
test "test_bitmap" get broken on s390.

[andriy.shevchenko@linux.intel.com: convert infinite while loop to a for loop]
  Link: http://lkml.kernel.org/r/20200609140535.87160-1-andriy.shevchenko@linux.intel.com
Link: http://lkml.kernel.org/r/1591634471-17647-1-git-send-email-agordeev@linux.ibm.com
Fixes: 2d6261583be0 ("lib: rework bitmap_parse()")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/lib/bitmap.c~lib-fix-bitmap_parse-on-64-bit-big-endian-archs
+++ a/lib/bitmap.c
@@ -741,8 +741,9 @@ int bitmap_parse(const char *start, unsi
 	int chunks = BITS_TO_U32(nmaskbits);
 	u32 *bitmap = (u32 *)maskp;
 	int unset_bit;
+	int chunk;
 
-	while (1) {
+	for (chunk = 0; ; chunk++) {
 		end = bitmap_find_region_reverse(start, end);
 		if (start > end)
 			break;
@@ -750,7 +751,11 @@ int bitmap_parse(const char *start, unsi
 		if (!chunks--)
 			return -EOVERFLOW;
 
-		end = bitmap_get_x32_reverse(start, end, bitmap++);
+#if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
+		end = bitmap_get_x32_reverse(start, end, &bitmap[chunk ^ 1]);
+#else
+		end = bitmap_get_x32_reverse(start, end, &bitmap[chunk]);
+#endif
 		if (IS_ERR(end))
 			return PTR_ERR(end);
 	}
_
