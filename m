From: akpm@linux-foundation.org
Subject: [to-be-updated]
 lib-vsprintfc-eliminate-potential-race-in-string.patch removed from -mm
 tree
Date: Wed, 02 Dec 2015 13:25:27 -0800
Message-ID: <565f61c7.MLe7vQwQohkXYlkA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbbLBVZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 16:25:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: eliminate potential race in string()
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-eliminate-potential-race-in-string.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: eliminate potential race in string()

If the string corresponding to a %s specifier can change under us, we
might end up copying a \0 byte to the output buffer.  There might be
callers who expect the output buffer to contain a genuine C string whose
length is exactly the snprintf return value (assuming truncation hasn't
happened or has been checked for).

We can avoid this by only passing over the source string once, stopping
the first time we meet a nul byte (or when we reach the given precision),
and then letting widen_string() handle left/right space padding.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-eliminate-potential-race-in-string lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-eliminate-potential-race-in-string
+++ a/lib/vsprintf.c
@@ -558,32 +558,22 @@ char *widen_string(char *buf, int n, cha
 static noinline_for_stack
 char *string(char *buf, char *end, const char *s, struct printf_spec spec)
 {
-	int len, i;
+	int len = 0;
+	size_t lim = spec.precision;
 
 	if ((unsigned long)s < PAGE_SIZE)
 		s = "(null)";
 
-	len = strnlen(s, spec.precision);
-
-	if (!(spec.flags & LEFT)) {
-		while (len < spec.field_width--) {
-			if (buf < end)
-				*buf = ' ';
-			++buf;
-		}
-	}
-	for (i = 0; i < len; ++i) {
+	while (lim--) {
+		char c = *s++;
+		if (!c)
+			break;
 		if (buf < end)
-			*buf = *s;
-		++buf; ++s;
-	}
-	while (len < spec.field_width--) {
-		if (buf < end)
-			*buf = ' ';
+			*buf = c;
 		++buf;
+		++len;
 	}
-
-	return buf;
+	return widen_string(buf, len, end, spec);
 }
 
 static noinline_for_stack
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-vsprintfc-expand-field_width-to-24-bits.patch
lib-vsprintfc-help-gcc-make-number-smaller.patch
lib-vsprintfc-warn-about-too-large-precisions-and-field-widths.patch
lib-test_printfc-dont-bug.patch
lib-test_printfc-check-for-out-of-bound-writes.patch
lib-test_printfc-add-a-few-string-tests.patch
lib-test_printfc-account-for-kvasprintf-tests.patch
lib-test_printfc-add-test-for-large-bitmaps.patch
lib-test_printfc-test-dentry-printing.patch
lib-kasprintfc-add-sanity-check-to-kvasprintf.patch
powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

