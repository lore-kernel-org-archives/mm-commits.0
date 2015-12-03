From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-move-string-below-widen_string.patch added to -mm tree
Date: Thu, 03 Dec 2015 15:35:23 -0800
Message-ID: <5660d1bb.ggjVNk3C9zSKesRx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbbLCXfY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2015 18:35:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: move string() below widen_string()
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-move-string-below-widen_string.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-move-string-below-widen_string.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-move-string-below-widen_string.patch

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
Subject: lib/vsprintf.c: move string() below widen_string()

This is pure code movement, making sure the widen_string() helper is
defined before the string() function.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   62 +++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-move-string-below-widen_string lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-move-string-below-widen_string
+++ a/lib/vsprintf.c
@@ -507,37 +507,6 @@ char *number(char *buf, char *end, unsig
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
@@ -585,6 +554,37 @@ char *widen_string(char *buf, int n, cha
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

lib-vsprintfc-pull-out-padding-code-from-dentry_name.patch
lib-vsprintfc-move-string-below-widen_string.patch
lib-vsprintfc-eliminate-potential-race-in-string.patch
lib-vsprintfc-expand-field_width-to-24-bits.patch
lib-vsprintfc-help-gcc-make-number-smaller.patch
lib-vsprintfc-warn-about-too-large-precisions-and-field-widths.patch
lib-kasprintfc-add-sanity-check-to-kvasprintf.patch
lib-test_printfc-dont-bug.patch
lib-test_printfc-check-for-out-of-bound-writes.patch
lib-test_printfc-test-precision-quirks.patch
lib-test_printfc-add-a-few-number-tests.patch
lib-test_printfc-account-for-kvasprintf-tests.patch
lib-test_printfc-add-test-for-large-bitmaps.patch
lib-test_printfc-test-dentry-printing.patch
powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

