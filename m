From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-pull-out-padding-code-from-dentry_name.patch
 added to -mm tree
Date: Tue, 01 Dec 2015 15:39:08 -0800
Message-ID: <565e2f9c.MSJjdVcSKUfyQcrY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503AbbLAXjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2015 18:39:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mingo@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: pull out padding code from dentry_name()
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-pull-out-padding-code-from-dentry_name.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-pull-out-padding-code-from-dentry_name.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-pull-out-padding-code-from-dentry_name.patch

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
Subject: lib/vsprintf.c: pull out padding code from dentry_name()

Pull out the logic in dentry_name() which handles field width space
padding, in preparation for reusing it from string().  Rename the widen()
helper to move_right(), since it is used for handling the !(flags & LEFT)
case.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-pull-out-padding-code-from-dentry_name lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-pull-out-padding-code-from-dentry_name
+++ a/lib/vsprintf.c
@@ -538,7 +538,7 @@ char *string(char *buf, char *end, const
 	return buf;
 }
 
-static void widen(char *buf, char *end, unsigned len, unsigned spaces)
+static void move_right(char *buf, char *end, unsigned len, unsigned spaces)
 {
 	size_t size;
 	if (buf >= end)	/* nowhere to put anything */
@@ -556,6 +556,35 @@ static void widen(char *buf, char *end,
 	memset(buf, ' ', spaces);
 }
 
+/*
+ * Handle field width padding for a string.
+ * @buf: current buffer position
+ * @n: length of string
+ * @end: end of output buffer
+ * @spec: for field width and flags
+ * Returns: new buffer position after padding.
+ */
+static noinline_for_stack
+char *widen_string(char *buf, int n, char *end, struct printf_spec spec)
+{
+	unsigned spaces;
+
+	if (likely(n >= spec.field_width))
+		return buf;
+	/* we want to pad the sucker */
+	spaces = spec.field_width - n;
+	if (!(spec.flags & LEFT)) {
+		move_right(buf - n, end, n, spaces);
+		return buf + spaces;
+	}
+	while (spaces--) {
+		if (buf < end)
+			*buf = ' ';
+		++buf;
+	}
+	return buf;
+}
+
 static noinline_for_stack
 char *dentry_name(char *buf, char *end, const struct dentry *d, struct printf_spec spec,
 		  const char *fmt)
@@ -597,20 +626,7 @@ char *dentry_name(char *buf, char *end,
 			*buf = c;
 	}
 	rcu_read_unlock();
-	if (n < spec.field_width) {
-		/* we want to pad the sucker */
-		unsigned spaces = spec.field_width - n;
-		if (!(spec.flags & LEFT)) {
-			widen(buf - n, end, n, spaces);
-			return buf + spaces;
-		}
-		while (spaces--) {
-			if (buf < end)
-				*buf = ' ';
-			++buf;
-		}
-	}
-	return buf;
+	return widen_string(buf, n, end, spec);
 }
 
 static noinline_for_stack
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

