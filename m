From: akpm@linux-foundation.org
Subject: [merged] lib-lz4-pull-out-constant-tables.patch removed from -mm
 tree
Date: Fri, 27 Mar 2015 11:17:18 -0700
Message-ID: <55159eae.1H+1NeAXgnIW23TC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbbC0SRS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 14:17:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, kyungsik.lee@lge.com, rlaager@wiktel.com, sergey.senozhatsky@gmail.com, yann.collet.73@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/lz4/lz4_decompress.c: pull out constant tables
has been removed from the -mm tree.  Its filename was
     lib-lz4-pull-out-constant-tables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/lz4/lz4_decompress.c: pull out constant tables

There's no reason to allocate the dec{32,64}table on the stack; it just
wastes a bunch of instructions setting them up and, of course, also
consumes quite a bit of stack.  Using size_t for such small integers is a
little excessive.

$ scripts/bloat-o-meter /tmp/built-in.o lib/built-in.o
add/remove: 2/2 grow/shrink: 2/0 up/down: 1304/-1548 (-244)
function                                     old     new   delta
lz4_decompress_unknownoutputsize              55     718    +663
lz4_decompress                                55     632    +577
dec64table                                     -      32     +32
dec32table                                     -      32     +32
lz4_uncompress                               747       -    -747
lz4_uncompress_unknownoutputsize             801       -    -801

The now inlined lz4_uncompress functions used to have a stack footprint of
176 bytes (according to -fstack-usage); their inlinees have increased
their stack use from 32 bytes to 48 and 80 bytes, respectively.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Yann Collet <yann.collet.73@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Richard Laager <rlaager@wiktel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4_decompress.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff -puN lib/lz4/lz4_decompress.c~lib-lz4-pull-out-constant-tables lib/lz4/lz4_decompress.c
--- a/lib/lz4/lz4_decompress.c~lib-lz4-pull-out-constant-tables
+++ a/lib/lz4/lz4_decompress.c
@@ -47,6 +47,11 @@
 
 #include "lz4defs.h"
 
+static const int dec32table[] = {0, 3, 2, 3, 0, 0, 0, 0};
+#if LZ4_ARCH64
+static const int dec64table[] = {0, 0, 0, -1, 0, 1, 2, 3};
+#endif
+
 static int lz4_uncompress(const char *source, char *dest, int osize)
 {
 	const BYTE *ip = (const BYTE *) source;
@@ -56,10 +61,6 @@ static int lz4_uncompress(const char *so
 	BYTE *cpy;
 	unsigned token;
 	size_t length;
-	size_t dec32table[] = {0, 3, 2, 3, 0, 0, 0, 0};
-#if LZ4_ARCH64
-	size_t dec64table[] = {0, 0, 0, -1, 0, 1, 2, 3};
-#endif
 
 	while (1) {
 
@@ -116,7 +117,7 @@ static int lz4_uncompress(const char *so
 		/* copy repeated sequence */
 		if (unlikely((op - ref) < STEPSIZE)) {
 #if LZ4_ARCH64
-			size_t dec64 = dec64table[op - ref];
+			int dec64 = dec64table[op - ref];
 #else
 			const int dec64 = 0;
 #endif
@@ -177,11 +178,6 @@ static int lz4_uncompress_unknownoutputs
 	BYTE * const oend = op + maxoutputsize;
 	BYTE *cpy;
 
-	size_t dec32table[] = {0, 3, 2, 3, 0, 0, 0, 0};
-#if LZ4_ARCH64
-	size_t dec64table[] = {0, 0, 0, -1, 0, 1, 2, 3};
-#endif
-
 	/* Main Loop */
 	while (ip < iend) {
 
@@ -249,7 +245,7 @@ static int lz4_uncompress_unknownoutputs
 		/* copy repeated sequence */
 		if (unlikely((op - ref) < STEPSIZE)) {
 #if LZ4_ARCH64
-			size_t dec64 = dec64table[op - ref];
+			int dec64 = dec64table[op - ref];
 #else
 			const int dec64 = 0;
 #endif
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

include-linux-remove-empty-conditionals.patch
lib-vsprintfc-eliminate-some-branches.patch
lib-vsprintfc-reduce-stack-use-in-number.patch
lib-vsprintfc-eliminate-duplicate-hex-string-array.patch
lib-vsprintfc-another-small-hack.patch
lib-vsprintfc-fix-potential-null-deref-in-hex_string.patch
lib-string_helpersc-refactor-string_escape_mem.patch
lib-string_helpersc-change-semantics-of-string_escape_mem.patch
lib-string_helpersc-change-semantics-of-string_escape_mem-fix.patch
lib-string_helpersc-change-semantics-of-string_escape_mem-fix-fix.patch
linux-bitmaph-improve-bitmap_lastfirst_word_mask.patch
lib-find__bit-reimplementation.patch
lib-find__bit-reimplementation-fix.patch
lib-move-find_last_bit-to-lib-find_next_bitc.patch
lib-rename-lib-find_next_bitc-to-lib-find_bitc.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
lib-vsprintfc-even-faster-decimal-conversion-fix.patch
lib-vsprintfc-improve-put_dec_trunc8-slightly.patch
binfmt_misc-simplify-entry_status.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-mc13xxx-fix-obfuscated-and-wrong-format-string.patch
linux-next.patch

