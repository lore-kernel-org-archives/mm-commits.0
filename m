From: akpm@linux-foundation.org
Subject: [to-be-updated]
 lib-vsprintfc-move-string-below-widen_string.patch removed from -mm tree
Date: Wed, 02 Dec 2015 13:25:25 -0800
Message-ID: <565f61c5.yUMftjc3u637HkFU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbbLBVZZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 16:25:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: move string() below widen_string()
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-move-string-below-widen_string.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: move string() below widen_string()

This is pure code movement, making sure the widen_string() helper is
defined before the string() function.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   62 +++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-move-string-below-widen_string lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-move-string-below-widen_string
+++ a/lib/vsprintf.c
@@ -508,37 +508,6 @@ char *number(char *buf, char *end, unsig
 	return buf;
 }
 
-static noinline_for_stack
-char *string(char *buf, char *end, const char *s, struct printf_spec spec)
-{
-	int len, i;
-
-	if ((unsigned long)s < PAGE_SIZE)
-		s = "(null)";
-
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
-		if (buf < end)
-			*buf = *s;
-		++buf; ++s;
-	}
-	while (len < spec.field_width--) {
-		if (buf < end)
-			*buf = ' ';
-		++buf;
-	}
-
-	return buf;
-}
-
 static void move_right(char *buf, char *end, unsigned len, unsigned spaces)
 {
 	size_t size;
@@ -586,6 +555,37 @@ char *widen_string(char *buf, int n, cha
 	return buf;
 }
 
+static noinline_for_stack
+char *string(char *buf, char *end, const char *s, struct printf_spec spec)
+{
+	int len, i;
+
+	if ((unsigned long)s < PAGE_SIZE)
+		s = "(null)";
+
+	len = strnlen(s, spec.precision);
+
+	if (!(spec.flags & LEFT)) {
+		while (len < spec.field_width--) {
+			if (buf < end)
+				*buf = ' ';
+			++buf;
+		}
+	}
+	for (i = 0; i < len; ++i) {
+		if (buf < end)
+			*buf = *s;
+		++buf; ++s;
+	}
+	while (len < spec.field_width--) {
+		if (buf < end)
+			*buf = ' ';
+		++buf;
+	}
+
+	return buf;
+}
+
 static noinline_for_stack
 char *dentry_name(char *buf, char *end, const struct dentry *d, struct printf_spec spec,
 		  const char *fmt)
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-vsprintfc-eliminate-potential-race-in-string.patch
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

