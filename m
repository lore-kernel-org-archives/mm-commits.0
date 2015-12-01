From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-help-gcc-make-number-smaller.patch added to -mm
 tree
Date: Tue, 01 Dec 2015 15:39:16 -0800
Message-ID: <565e2fa4.TDdJ1F2NJrcuTgzU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337AbbLAXjR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2015 18:39:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: help gcc make number() smaller
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-help-gcc-make-number-smaller.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-help-gcc-make-number-smaller.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-help-gcc-make-number-smaller.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: help gcc make number() smaller

One consequence of the reorganization of struct printf_spec to make
field_width 24 bits was that number() gained about 180 bytes.  Since spec
is never passed to other functions, we can help gcc make number() lose
most of that extra weight by using local variables for the field width and
precision.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-help-gcc-make-number-smaller lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-help-gcc-make-number-smaller
+++ a/lib/vsprintf.c
@@ -399,6 +399,8 @@ char *number(char *buf, char *end, unsig
 	int need_pfx = ((spec.flags & SPECIAL) && spec.base != 10);
 	int i;
 	bool is_zero = num == 0LL;
+	int field_width = spec.field_width;
+	int precision = spec.precision;
 
 	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
 	 * produces same digits or (maybe lowercased) letters */
@@ -410,20 +412,20 @@ char *number(char *buf, char *end, unsig
 		if ((signed long long)num < 0) {
 			sign = '-';
 			num = -(signed long long)num;
-			spec.field_width--;
+			field_width--;
 		} else if (spec.flags & PLUS) {
 			sign = '+';
-			spec.field_width--;
+			field_width--;
 		} else if (spec.flags & SPACE) {
 			sign = ' ';
-			spec.field_width--;
+			field_width--;
 		}
 	}
 	if (need_pfx) {
 		if (spec.base == 16)
-			spec.field_width -= 2;
+			field_width -= 2;
 		else if (!is_zero)
-			spec.field_width--;
+			field_width--;
 	}
 
 	/* generate full string in tmp[], in reverse order */
@@ -445,12 +447,12 @@ char *number(char *buf, char *end, unsig
 	}
 
 	/* printing 100 using %2d gives "100", not "00" */
-	if (i > spec.precision)
-		spec.precision = i;
+	if (i > precision)
+		precision = i;
 	/* leading space padding */
-	spec.field_width -= spec.precision;
+	field_width -= precision;
 	if (!(spec.flags & (ZEROPAD | LEFT))) {
-		while (--spec.field_width >= 0) {
+		while (--field_width >= 0) {
 			if (buf < end)
 				*buf = ' ';
 			++buf;
@@ -479,14 +481,14 @@ char *number(char *buf, char *end, unsig
 	if (!(spec.flags & LEFT)) {
 		char c = ' ' + (spec.flags & ZEROPAD);
 		BUILD_BUG_ON(' ' + ZEROPAD != '0');
-		while (--spec.field_width >= 0) {
+		while (--field_width >= 0) {
 			if (buf < end)
 				*buf = c;
 			++buf;
 		}
 	}
 	/* hmm even more zero padding? */
-	while (i <= --spec.precision) {
+	while (i <= --precision) {
 		if (buf < end)
 			*buf = '0';
 		++buf;
@@ -498,7 +500,7 @@ char *number(char *buf, char *end, unsig
 		++buf;
 	}
 	/* trailing space padding */
-	while (--spec.field_width >= 0) {
+	while (--field_width >= 0) {
 		if (buf < end)
 			*buf = ' ';
 		++buf;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-vsprintfc-pull-out-padding-code-from-dentry_name.patch
lib-vsprintfc-move-string-below-widen_string.patch
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

