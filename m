From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-eliminate-potential-race-in-string.patch added to -mm tree
Date: Thu, 03 Dec 2015 15:35:25 -0800
Message-ID: <5660d1bd.x5mpGNI3TmHqhkU9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbbLCXf0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2015 18:35:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: eliminate potential race in string()
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-eliminate-potential-race-in-string.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-eliminate-potential-race-in-string.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-eliminate-potential-race-in-string.patch

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
@@ -557,32 +557,22 @@ char *widen_string(char *buf, int n, cha
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

