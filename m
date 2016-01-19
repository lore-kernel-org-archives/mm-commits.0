From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-move-string-below-widen_string.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:14:56 -0800
Message-ID: <569e9940.r0BbccQnWryGErIV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUO5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: move string() below widen_string()
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-move-string-below-widen_string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -510,37 +510,6 @@ char *number(char *buf, char *end, unsig
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
@@ -588,6 +557,37 @@ char *widen_string(char *buf, int n, cha
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

powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

