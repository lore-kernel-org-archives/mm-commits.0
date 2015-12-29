From: akpm@linux-foundation.org
Subject: + lib-vsprintf-factor-out-%pn-handler-as-netdev_bits.patch added
 to -mm tree
Date: Tue, 29 Dec 2015 12:49:36 -0800
Message-ID: <5682f1e0.Gk8xw0V2W767f1QK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbbL2Uth (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Dec 2015 15:49:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, joe@perches.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf: factor out %pN[F] handler as netdev_bits()
has been added to the -mm tree.  Its filename is
     lib-vsprintf-factor-out-%pn-handler-as-netdev_bits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintf-factor-out-%25pn-handler-as-netdev_bits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintf-factor-out-%25pn-handler-as-netdev_bits.patch

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
@@ -1324,11 +1324,22 @@ char *uuid_string(char *buf, char *end,
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
@@ -1671,11 +1682,7 @@ char *pointer(const char *fmt, char *buf
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

lib-vsprintf-refactor-duplicate-code-to-special_hex_number.patch
lib-vsprintf-factor-out-%pn-handler-as-netdev_bits.patch
test_hexdump-rename-to-test_hexdump.patch
test_hexdump-introduce-test_hexdump_prepare_test-helper.patch
test_hexdump-define-fill_char-constant.patch
test_hexdump-go-through-all-possible-lengths-of-buffer.patch
test_hexdump-replace-magic-numbers-by-their-meaning.patch
test_hexdump-switch-to-memcmp.patch
test_hexdump-check-all-bytes-in-real-buffer.patch
test_hexdump-test-all-possible-group-sizes-for-overflow.patch
test_hexdump-print-statistics-at-the-end.patch

