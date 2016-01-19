From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-eliminate-potential-race-in-string.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:14:58 -0800
Message-ID: <569e9942.MgRIetM7tN9nsGmj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUO7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: eliminate potential race in string()
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-eliminate-potential-race-in-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: eliminate potential race in string()

If the string corresponding to a %s specifier can change under us, we
might end up copying a \0 byte to the output buffer. There might be
callers who expect the output buffer to contain a genuine C string
whose length is exactly the snprintf return value (assuming truncation
hasn't happened or has been checked for).

We can avoid this by only passing over the source string once,
stopping the first time we meet a nul byte (or when we reach the given
precision), and then letting widen_string() handle left/right space
padding. As a small bonus, this code reuse also makes the generated
code slightly smaller.

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

 lib/vsprintf.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-eliminate-potential-race-in-string lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-eliminate-potential-race-in-string
+++ a/lib/vsprintf.c
@@ -560,32 +560,22 @@ char *widen_string(char *buf, int n, cha
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
