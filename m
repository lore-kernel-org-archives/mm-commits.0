From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-fix-potential-null-deref-in-hex_string.patch
 added to -mm tree
Date: Wed, 04 Mar 2015 13:25:48 -0800
Message-ID: <54f7785c.ye56K+p/XxPXrRD1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbbCDVZt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 16:25:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: fix potential NULL deref in hex_string
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-fix-potential-null-deref-in-hex_string.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-fix-potential-null-deref-in-hex_string.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-fix-potential-null-deref-in-hex_string.patch

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
Subject: lib/vsprintf.c: fix potential NULL deref in hex_string

The helper hex_string() is broken in two ways.  First, it doesn't
increment buf regardless of whether there is room to print, so callers
such as kasprintf() that try to probe the correct storage to allocate will
get a too small return value.  But even worse, kasprintf() (and likely
anyone else trying to find the size of the result) pass NULL for buf and 0
for size, so we also have end == NULL.  But this means that the end-1 in
hex_string() is (char*)-1, so buf < end-1 is true and we get a NULL
pointer deref.  I double-checked this with a trivial kernel module that
just did a kasprintf(GFP_KERNEL, "%14ph", "CrashBoomBang").

Nobody seems to be using %ph with kasprintf, but we might as well fix it
before it hits someone.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-fix-potential-null-deref-in-hex_string lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-fix-potential-null-deref-in-hex_string
+++ a/lib/vsprintf.c
@@ -777,11 +777,19 @@ char *hex_string(char *buf, char *end, u
 	if (spec.field_width > 0)
 		len = min_t(int, spec.field_width, 64);
 
-	for (i = 0; i < len && buf < end - 1; i++) {
-		buf = hex_byte_pack(buf, addr[i]);
+	for (i = 0; i < len; ++i) {
+		if (buf < end)
+			*buf = hex_asc_hi(addr[i]);
+		++buf;
+		if (buf < end)
+			*buf = hex_asc_lo(addr[i]);
+		++buf;
 
-		if (buf < end && separator && i != len - 1)
-			*buf++ = separator;
+		if (separator && i != len - 1) {
+			if (buf < end)
+				*buf = separator;
+			++buf;
+		}
 	}
 
 	return buf;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
include-linux-remove-empty-conditionals.patch
lib-vsprintfc-eliminate-some-branches.patch
lib-vsprintfc-reduce-stack-use-in-number.patch
lib-vsprintfc-eliminate-duplicate-hex-string-array.patch
lib-vsprintfc-another-small-hack.patch
lib-vsprintfc-fix-potential-null-deref-in-hex_string.patch
lib-string_helpersc-refactor-string_escape_mem.patch
lib-string_helpersc-change-semantics-of-string_escape_mem.patch
linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
lib-find__bit-reimplementation.patch
lib-find__bit-reimplementation-fix.patch
lib-move-find_last_bit-to-lib-find_next_bitc.patch
lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch
binfmt_misc-simplify-entry_status.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch
lib-lz4-pull-out-constant-tables.patch
linux-next.patch

