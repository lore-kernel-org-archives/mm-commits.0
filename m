From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintf-factor-out-%pn-handler-as-netdev_bits.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:15:32 -0800
Message-ID: <569e9964.Ma/5gTLPB7Tofvq8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933223AbcASUPd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:15:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, joe@perches.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf: factor out %pN[F] handler as netdev_bits()
has been removed from the -mm tree.  Its filename was
     lib-vsprintf-factor-out-%pn-handler-as-netdev_bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/vsprintf: factor out %pN[F] handler as netdev_bits()

Move switch case to the netdev_features_string() and rename it to
netdev_bits(). In the future we can extend it as needed.

Here we replace the fallback of %pN from '%p' with possible flags to sticter
'0x%p' without any flags variation.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintf-factor-out-%pn-handler-as-netdev_bits lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-factor-out-%pn-handler-as-netdev_bits
+++ a/lib/vsprintf.c
@@ -1345,11 +1345,22 @@ char *uuid_string(char *buf, char *end,
 	return string(buf, end, uuid, spec);
 }
 
-static
-char *netdev_feature_string(char *buf, char *end, const void *addr)
+static noinline_for_stack
+char *netdev_bits(char *buf, char *end, const void *addr, const char *fmt)
 {
-	unsigned long long num = *(const netdev_features_t *)addr;
-	int size = sizeof(netdev_features_t);
+	unsigned long long num;
+	int size;
+
+	switch (fmt[1]) {
+	case 'F':
+		num = *(const netdev_features_t *)addr;
+		size = sizeof(netdev_features_t);
+		break;
+	default:
+		num = (unsigned long)addr;
+		size = sizeof(unsigned long);
+		break;
+	}
 
 	return special_hex_number(buf, end, num, size);
 }
@@ -1621,11 +1632,7 @@ char *pointer(const char *fmt, char *buf
 		break;
 
 	case 'N':
-		switch (fmt[1]) {
-		case 'F':
-			return netdev_feature_string(buf, end, ptr);
-		}
-		break;
+		return netdev_bits(buf, end, ptr, fmt);
 	case 'a':
 		return address_val(buf, end, ptr, fmt);
 	case 'd':
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

test_hexdump-rename-to-test_hexdump.patch
test_hexdump-introduce-test_hexdump_prepare_test-helper.patch
test_hexdump-define-fill_char-constant.patch
test_hexdump-go-through-all-possible-lengths-of-buffer.patch
test_hexdump-replace-magic-numbers-by-their-meaning.patch
test_hexdump-switch-to-memcmp.patch
test_hexdump-check-all-bytes-in-real-buffer.patch
test_hexdump-test-all-possible-group-sizes-for-overflow.patch
test_hexdump-print-statistics-at-the-end.patch

