From: akpm@linux-foundation.org
Subject: +
 lib-vsprintf-refactor-duplicate-code-to-special_hex_number.patch added to
 -mm tree
Date: Tue, 29 Dec 2015 12:49:34 -0800
Message-ID: <5682f1de.+q3vuXSNaaWc2aBD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbbL2Utf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Dec 2015 15:49:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, joe@perches.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf: refactor duplicate code to special_hex_number()
has been added to the -mm tree.  Its filename is
     lib-vsprintf-refactor-duplicate-code-to-special_hex_number.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintf-refactor-duplicate-code-to-special_hex_number.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintf-refactor-duplicate-code-to-special_hex_number.patch

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
Subject: lib/vsprintf: refactor duplicate code to special_hex_number()

special_hex_number() is a helper to print a fixed size type in a hex
format with '0x' prefix, zero padding, and small letters.  In the module
we have already several copies of such code.  Consolidate them under
special_hex_number() helper.

There are couple of differences though.

It seems nobody cared about the output in case of CONFIG_KALLSYMS=n, when
printing symbol address, because the asked field width is not enough to
care last 2 characters in the string represantation of the pointer.  Fixed
here.

The %pNF specifier used to be allowed with a specific field width, though
there is neither any user of it nor mention the possibility in the
documentation.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   53 +++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintf-refactor-duplicate-code-to-special_hex_number lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-refactor-duplicate-code-to-special_hex_number
+++ a/lib/vsprintf.c
@@ -514,6 +514,20 @@ char *number(char *buf, char *end, unsig
 	return buf;
 }
 
+static noinline_for_stack
+char *special_hex_number(char *buf, char *end, unsigned long long num, int size)
+{
+	struct printf_spec spec;
+
+	spec.type = FORMAT_TYPE_PTR;
+	spec.field_width = 2 + 2 * size;	/* 0x + hex */
+	spec.flags = SPECIAL | SMALL | ZEROPAD;
+	spec.base = 16;
+	spec.precision = -1;
+
+	return number(buf, end, num, spec);
+}
+
 static void move_right(char *buf, char *end, unsigned len, unsigned spaces)
 {
 	size_t size;
@@ -649,11 +663,7 @@ char *symbol_string(char *buf, char *end
 
 	return string(buf, end, sym, spec);
 #else
-	spec.field_width = 2 * sizeof(void *);
-	spec.flags |= SPECIAL | SMALL | ZEROPAD;
-	spec.base = 16;
-
-	return number(buf, end, value, spec);
+	return special_hex_number(buf, end, value, sizeof(void *));
 #endif
 }
 
@@ -1315,39 +1325,33 @@ char *uuid_string(char *buf, char *end,
 }
 
 static
-char *netdev_feature_string(char *buf, char *end, const u8 *addr,
-		      struct printf_spec spec)
+char *netdev_feature_string(char *buf, char *end, const void *addr)
 {
-	spec.flags |= SPECIAL | SMALL | ZEROPAD;
-	if (spec.field_width == -1)
-		spec.field_width = 2 + 2 * sizeof(netdev_features_t);
-	spec.base = 16;
+	unsigned long long num = *(const netdev_features_t *)addr;
+	int size = sizeof(netdev_features_t);
 
-	return number(buf, end, *(const netdev_features_t *)addr, spec);
+	return special_hex_number(buf, end, num, size);
 }
 
 static noinline_for_stack
-char *address_val(char *buf, char *end, const void *addr,
-		  struct printf_spec spec, const char *fmt)
+char *address_val(char *buf, char *end, const void *addr, const char *fmt)
 {
 	unsigned long long num;
-
-	spec.flags |= SPECIAL | SMALL | ZEROPAD;
-	spec.base = 16;
+	int size;
 
 	switch (fmt[1]) {
 	case 'd':
 		num = *(const dma_addr_t *)addr;
-		spec.field_width = sizeof(dma_addr_t) * 2 + 2;
+		size = sizeof(dma_addr_t);
 		break;
 	case 'p':
 	default:
 		num = *(const phys_addr_t *)addr;
-		spec.field_width = sizeof(phys_addr_t) * 2 + 2;
+		size = sizeof(phys_addr_t);
 		break;
 	}
 
-	return number(buf, end, num, spec);
+	return special_hex_number(buf, end, num, size);
 }
 
 static noinline_for_stack
@@ -1366,10 +1370,7 @@ char *clock(char *buf, char *end, struct
 #ifdef CONFIG_COMMON_CLK
 		return string(buf, end, __clk_get_name(clk), spec);
 #else
-		spec.base = 16;
-		spec.field_width = sizeof(unsigned long) * 2 + 2;
-		spec.flags |= SPECIAL | SMALL | ZEROPAD;
-		return number(buf, end, (unsigned long)clk, spec);
+		return special_hex_number(buf, end, (unsigned long)clk, sizeof(unsigned long));
 #endif
 	}
 }
@@ -1672,11 +1673,11 @@ char *pointer(const char *fmt, char *buf
 	case 'N':
 		switch (fmt[1]) {
 		case 'F':
-			return netdev_feature_string(buf, end, ptr, spec);
+			return netdev_feature_string(buf, end, ptr);
 		}
 		break;
 	case 'a':
-		return address_val(buf, end, ptr, spec, fmt);
+		return address_val(buf, end, ptr, fmt);
 	case 'd':
 		return dentry_name(buf, end, ptr, spec, fmt);
 	case 'C':
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

