From: akpm@linux-foundation.org
Subject: [merged]
 lib-vsprintfc-fix-potential-null-deref-in-hex_string.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:54:55 -0700
Message-ID: <552fe95f.B35ohZaBh1XgR8/s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbbDPQt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: fix potential NULL deref in hex_string
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-fix-potential-null-deref-in-hex_string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
lib-find__bit-reimplementation.patch
lib-find__bit-reimplementation-fix.patch
lib-move-find_last_bit-to-lib-find_next_bitc.patch
lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
lib-vsprintfc-even-faster-decimal-conversion-fix.patch
lib-vsprintfc-improve-put_dec_trunc8-slightly.patch
lib-bitmap_-remove-code-duplication.patch
binfmt_misc-simplify-entry_status.patch
binfmt_misc-simplify-entry_status-fix.patch
linux-next.patch

