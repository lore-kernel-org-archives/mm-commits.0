From: akpm@linux-foundation.org
Subject: + lib-bitmapc-quiet-sparse-noise-about-address-space.patch added to -mm tree
Date: Fri, 02 Sep 2011 16:33:59 -0700
Message-ID: <201109022333.p82NXxrj016962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735Ab1IBXeB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2011 19:34:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, ak@linux.intel.com, andy.shevchenko@gmail.com, hsweeten@visionengravers.com, len.brown@intel.com, ying.huang@intel.com


The patch titled
     lib/bitmap.c: quiet sparse noise about address space
has been added to the -mm tree.  Its filename is
     lib-bitmapc-quiet-sparse-noise-about-address-space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/bitmap.c: quiet sparse noise about address space
From: H Hartley Sweeten <hartleys@visionengravers.com>

__bitmap_parse() and __bitmap_parselist() both take a pointer to a kernel
buffer as a parameter and then cast it to a pointer to user buffer for use
in cases when the parameter is_user indicates that the buffer is actually
located in user space.  This casting, and the casts in the callers,
results in sparse noise like the following:

	warning: incorrect type in initializer (different address spaces)
	  expected char const [noderef] <asn:1>*ubuf
	  got char const *buf
	warning: cast removes address space of expression

Since these casts are intentional, use __force to quiet the noise.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN lib/bitmap.c~lib-bitmapc-quiet-sparse-noise-about-address-space lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-quiet-sparse-noise-about-address-space
+++ a/lib/bitmap.c
@@ -419,7 +419,7 @@ int __bitmap_parse(const char *buf, unsi
 {
 	int c, old_c, totaldigits, ndigits, nchunks, nbits;
 	u32 chunk;
-	const char __user *ubuf = buf;
+	const char __user __force *ubuf = buf;
 
 	bitmap_zero(maskp, nmaskbits);
 
@@ -504,7 +504,9 @@ int bitmap_parse_user(const char __user 
 {
 	if (!access_ok(VERIFY_READ, ubuf, ulen))
 		return -EFAULT;
-	return __bitmap_parse((const char *)ubuf, ulen, 1, maskp, nmaskbits);
+	return __bitmap_parse((const char __force *)ubuf,
+				ulen, 1, maskp, nmaskbits);
+
 }
 EXPORT_SYMBOL(bitmap_parse_user);
 
@@ -594,7 +596,7 @@ static int __bitmap_parselist(const char
 {
 	unsigned a, b;
 	int c, old_c, totaldigits;
-	const char __user *ubuf = buf;
+	const char __user __force *ubuf = buf;
 	int exp_digit, in_range;
 
 	totaldigits = c = 0;
@@ -694,7 +696,7 @@ int bitmap_parselist_user(const char __u
 {
 	if (!access_ok(VERIFY_READ, ubuf, ulen))
 		return -EFAULT;
-	return __bitmap_parselist((const char *)ubuf,
+	return __bitmap_parselist((const char __force *)ubuf,
 					ulen, 1, maskp, nmaskbits);
 }
 EXPORT_SYMBOL(bitmap_parselist_user);
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

lib-bitmapc-quiet-sparse-noise-about-address-space.patch

