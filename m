From: akpm@linux-foundation.org
Subject: + lib-hexdump-return-einval-in-case-of-error-in-hex2bin.patch
 added to -mm tree
Date: Mon, 31 Jul 2017 14:38:22 -0700
Message-ID: <597fa34e.ukatTJqT7wqeY4TU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45672 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751699AbdGaViX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jul 2017 17:38:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, arnd@arndb.de, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/hexdump.c: return -EINVAL in case of error in hex2bin()
has been added to the -mm tree.  Its filename is
     lib-hexdump-return-einval-in-case-of-error-in-hex2bin.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-hexdump-return-einval-in-case-of-error-in-hex2bin.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-hexdump-return-einval-in-case-of-error-in-hex2bin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/hexdump.c: return -EINVAL in case of error in hex2bin()

In some cases caller would like to use error code directly without
shadowing.

-EINVAL feels a rightful code to return in case of error in hex2bin().

Link: http://lkml.kernel.org/r/20170731135510.68023-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/hexdump.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN lib/hexdump.c~lib-hexdump-return-einval-in-case-of-error-in-hex2bin lib/hexdump.c
--- a/lib/hexdump.c~lib-hexdump-return-einval-in-case-of-error-in-hex2bin
+++ a/lib/hexdump.c
@@ -9,6 +9,7 @@
 
 #include <linux/types.h>
 #include <linux/ctype.h>
+#include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <asm/unaligned.h>
@@ -42,7 +43,7 @@ EXPORT_SYMBOL(hex_to_bin);
  * @src: ascii hexadecimal string
  * @count: result length
  *
- * Return 0 on success, -1 in case of bad input.
+ * Return 0 on success, -EINVAL in case of bad input.
  */
 int hex2bin(u8 *dst, const char *src, size_t count)
 {
@@ -51,7 +52,7 @@ int hex2bin(u8 *dst, const char *src, si
 		int lo = hex_to_bin(*src++);
 
 		if ((hi < 0) || (lo < 0))
-			return -1;
+			return -EINVAL;
 
 		*dst++ = (hi << 4) | lo;
 	}
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-hexdump-return-einval-in-case-of-error-in-hex2bin.patch

