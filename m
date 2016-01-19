From: akpm@linux-foundation.org
Subject: [merged]
 lib-vsprintfc-pull-out-padding-code-from-dentry_name.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:14:55 -0800
Message-ID: <569e993f.Vu/P2orrLtSkEPjh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUO4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: pull out padding code from dentry_name()
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-pull-out-padding-code-from-dentry_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: pull out padding code from dentry_name()

Pull out the logic in dentry_name() which handles field width space
padding, in preparation for reusing it from string().  Rename the widen()
helper to move_right(), since it is used for handling the !(flags & LEFT)
case.

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

 lib/vsprintf.c |   46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-pull-out-padding-code-from-dentry_name lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-pull-out-padding-code-from-dentry_name
+++ a/lib/vsprintf.c
@@ -541,7 +541,7 @@ char *string(char *buf, char *end, const
 	return buf;
 }
 
-static void widen(char *buf, char *end, unsigned len, unsigned spaces)
+static void move_right(char *buf, char *end, unsigned len, unsigned spaces)
 {
 	size_t size;
 	if (buf >= end)	/* nowhere to put anything */
@@ -559,6 +559,35 @@ static void widen(char *buf, char *end,
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
@@ -600,20 +629,7 @@ char *dentry_name(char *buf, char *end,
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
 
 #ifdef CONFIG_BLOCK
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

