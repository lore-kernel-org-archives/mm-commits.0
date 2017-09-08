From: akpm@linux-foundation.org
Subject: [patch 084/126] lib/bitmap.c: make bitmap_parselist()
 thread-safe and much faster
Date: Fri, 08 Sep 2017 16:15:34 -0700
Message-ID: <20170908231534.Y06VOF1Oj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53088 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753026AbdIHXPg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:15:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mchehab@kernel.org, mm-commits@vger.kernel.org, noamca@mellanox.com, torvalds@linux-foundation.org, ynorov@caviumnetworks.com

From: Yury Norov <ynorov@caviumnetworks.com>
Subject: lib/bitmap.c: make bitmap_parselist() thread-safe and much faster

Current implementation of bitmap_parselist() uses a static variable to
save local state while setting bits in the bitmap.  It is obviously wrong
if we assume execution in multiprocessor environment.  Fortunately, it's
possible to rewrite this portion of code to avoid using the static
variable.

It is also possible to set bits in the mask per-range with bitmap_set(),
not per-bit, as it is implemented now, with set_bit(); which is way
faster.

The important side effect of this change is that setting bits in this
function from now is not per-bit atomic and less memory-ordered.  This is
because set_bit() guarantees the order of memory accesses, while
bitmap_set() does not.  I think that it is the advantage of the new
approach, because the bitmap_parselist() is intended to initialise bit
arrays, and user should protect the whole bitmap during initialisation if
needed.  So protecting individual bits looks expensive and useless.  Also,
other range-oriented functions in lib/bitmap.c don't worry much about
atomicity.

With all that, setting 2k bits in map with the pattern like 0-2047:128/256
becomes ~50 times faster after applying the patch in my testing
environment (arm64 hosted on qemu).

The second patch of the series adds the test for bitmap_parselist().  It's
not intended to cover all tricky cases, just to make sure that I didn't
screw up during rework.

Link: http://lkml.kernel.org/r/20170807225438.16161-1-ynorov@caviumnetworks.com
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Cc: Noam Camus <noamca@mellanox.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN lib/bitmap.c~lib-make-bitmap_parselist-thread-safe-and-much-faster lib/bitmap.c
--- a/lib/bitmap.c~lib-make-bitmap_parselist-thread-safe-and-much-faster
+++ a/lib/bitmap.c
@@ -513,7 +513,7 @@ static int __bitmap_parselist(const char
 		int nmaskbits)
 {
 	unsigned int a, b, old_a, old_b;
-	unsigned int group_size, used_size;
+	unsigned int group_size, used_size, off;
 	int c, old_c, totaldigits, ndigits;
 	const char __user __force *ubuf = (const char __user __force *)buf;
 	int at_start, in_range, in_partial_range;
@@ -599,6 +599,8 @@ static int __bitmap_parselist(const char
 			a = old_a;
 			b = old_b;
 			old_a = old_b = 0;
+		} else {
+			used_size = group_size = b - a + 1;
 		}
 		/* if no digit is after '-', it's wrong*/
 		if (at_start && in_range)
@@ -608,17 +610,9 @@ static int __bitmap_parselist(const char
 		if (b >= nmaskbits)
 			return -ERANGE;
 		while (a <= b) {
-			if (in_partial_range) {
-				static int pos_in_group = 1;
-
-				if (pos_in_group <= used_size)
-					set_bit(a, maskp);
