From: akpm@linux-foundation.org
Subject: [merged] lib-bitmapc-quiet-sparse-noise-about-address-space.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:15:57 -0700
Message-ID: <201111012115.pA1LFvRm015960@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16668 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:16:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, ak@linux.intel.com, andy.shevchenko@gmail.com, hsweeten@visionengravers.com, len.brown@intel.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: quiet sparse noise about address space
has been removed from the -mm tree.  Its filename was
     lib-bitmapc-quiet-sparse-noise-about-address-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: lib/bitmap.c: quiet sparse noise about address space

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
+	const char __user __force *ubuf = (const char __user __force *)buf;
 
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
+	const char __user __force *ubuf = (const char __user __force *)buf;
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

origin.patch
linux-next.patch
arch-x86-kernel-e820c-quiet-sparse-noise-about-plain-integer-as-null-pointer.patch
arch-x86-kernel-ptracec-quiet-sparse-noise.patch
arch-x86-mm-pageattrc-quiet-sparse-noise-local-functions-should-be-static.patch
ceph-mds_clientc-quiet-sparse-noise.patch
mm-page_cgroupc-quiet-sparse-noise.patch

