From: akpm@linux-foundation.org
Subject: [merged]
 __bitmap_parselist-fix-bug-in-empty-string-handling.patch removed from -mm
 tree
Date: Mon, 29 Jun 2015 13:47:53 -0700
Message-ID: <5591aef9.FZ7IsYYs/JuMzYva%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbbF2Ury (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:47:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@ezchip.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: __bitmap_parselist: fix bug in empty string handling
has been removed from the -mm tree.  Its filename was
     __bitmap_parselist-fix-bug-in-empty-string-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: __bitmap_parselist: fix bug in empty string handling

bitmap_parselist("", &mask, nmaskbits) will erroneously set bit zero in
the mask.  The same bug is visible in cpumask_parselist() since it is
layered on top of the bitmask code, e.g.  if you boot with "isolcpus=",
you will actually end up with cpu zero isolated.

The bug was introduced in commit 4b060420a596 ("bitmap, irq: add
smp_affinity_list interface to /proc/irq") when bitmap_parselist() was
generalized to support userspace as well as kernelspace.

Fixes: 4b060420a596 ("bitmap, irq: add smp_affinity_list interface to /proc/irq")
Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN lib/bitmap.c~__bitmap_parselist-fix-bug-in-empty-string-handling lib/bitmap.c
--- a/lib/bitmap.c~__bitmap_parselist-fix-bug-in-empty-string-handling
+++ a/lib/bitmap.c
@@ -506,12 +506,12 @@ static int __bitmap_parselist(const char
 	unsigned a, b;
 	int c, old_c, totaldigits;
 	const char __user __force *ubuf = (const char __user __force *)buf;
-	int exp_digit, in_range;
+	int at_start, in_range;
 
 	totaldigits = c = 0;
 	bitmap_zero(maskp, nmaskbits);
 	do {
-		exp_digit = 1;
+		at_start = 1;
 		in_range = 0;
 		a = b = 0;
 
@@ -540,11 +540,10 @@ static int __bitmap_parselist(const char
 				break;
 
 			if (c == '-') {
-				if (exp_digit || in_range)
+				if (at_start || in_range)
 					return -EINVAL;
 				b = 0;
 				in_range = 1;
-				exp_digit = 1;
 				continue;
 			}
 
@@ -554,16 +553,18 @@ static int __bitmap_parselist(const char
 			b = b * 10 + (c - '0');
 			if (!in_range)
 				a = b;
-			exp_digit = 0;
+			at_start = 0;
 			totaldigits++;
 		}
 		if (!(a <= b))
 			return -EINVAL;
 		if (b >= nmaskbits)
 			return -ERANGE;
-		while (a <= b) {
-			set_bit(a, maskp);
-			a++;
+		if (!at_start) {
+			while (a <= b) {
+				set_bit(a, maskp);
+				a++;
+			}
 		}
 	} while (buflen && c == ',');
 	return 0;
_

Patches currently in -mm which might be from cmetcalf@ezchip.com are

origin.patch
linux-next.patch

