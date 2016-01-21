From: akpm@linux-foundation.org
Subject: [merged] string_helpers-fix-precision-loss-for-some-inputs.patch
 removed from -mm tree
Date: Thu, 21 Jan 2016 14:58:41 -0800
Message-ID: <56a162a1.fQ3+PjpnjQZlyXsq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbcAUW6m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:58:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBottomley@Odin.com, stable@vger.kernel.org, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: string_helpers: fix precision loss for some inputs
has been removed from the -mm tree.  Its filename was
     string_helpers-fix-precision-loss-for-some-inputs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: James Bottomley <JBottomley@Odin.com>
Subject: string_helpers: fix precision loss for some inputs

It was noticed that we lose precision in the final calculation for some
inputs.  The most egregious example is size=3000 blk_size=1900 in units of
10 should yield 5.70 MB but in fact yields 3.00 MB (oops).  This is
because the current algorithm doesn't correctly account for all the
remainders in the logarithms.  Fix this by doing a correct calculation in
the remainders based on napier's algorithm.  Additionally, now we have the
correct result, we have to account for arithmetic rounding because we're
printing 3 digits of precision.  This means that if the fourth digit is
five or greater, we have to round up, so add a section to ensure correct
rounding.  Finally account for all possible inputs correctly, including
zero for block size.

Fixes: b9f28d863594c429e1df35a0474d2663ca28b307
Signed-off-by: James Bottomley <JBottomley@Odin.com>
Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: <stable@vger.kernel.org>	[delay until after 4.4 release]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |   63 +++++++++++++++++++++++++++--------------
 1 file changed, 43 insertions(+), 20 deletions(-)

diff -puN lib/string_helpers.c~string_helpers-fix-precision-loss-for-some-inputs lib/string_helpers.c
--- a/lib/string_helpers.c~string_helpers-fix-precision-loss-for-some-inputs
+++ a/lib/string_helpers.c
@@ -43,50 +43,73 @@ void string_get_size(u64 size, u64 blk_s
 		[STRING_UNITS_10] = 1000,
 		[STRING_UNITS_2] = 1024,
 	};
-	int i, j;
-	u32 remainder = 0, sf_cap, exp;
+	static const unsigned int rounding[] = { 500, 50, 5 };
+	int i = 0, j;
+	u32 remainder = 0, sf_cap;
 	char tmp[8];
 	const char *unit;
 
 	tmp[0] = '\0';
-	i = 0;
-	if (!size)
+
+	if (blk_size == 0)
+		size = 0;
+	if (size == 0)
 		goto out;
 
-	while (blk_size >= divisor[units]) {
-		remainder = do_div(blk_size, divisor[units]);
+	/* This is Napier's algorithm.  Reduce the original block size to
+	 *
+	 * coefficient * divisor[units]^i
+	 *
+	 * we do the reduction so both coefficients are just under 32 bits so
+	 * that multiplying them together won't overflow 64 bits and we keep
+	 * as much precision as possible in the numbers.
+	 *
+	 * Note: it's safe to throw away the remainders here because all the
+	 * precision is in the coefficients.
+	 */
+	while (blk_size >> 32) {
+		do_div(blk_size, divisor[units]);
 		i++;
 	}
 
-	exp = divisor[units] / (u32)blk_size;
-	/*
-	 * size must be strictly greater than exp here to ensure that remainder
-	 * is greater than divisor[units] coming out of the if below.
-	 */
-	if (size > exp) {
-		remainder = do_div(size, divisor[units]);
-		remainder *= blk_size;
+	while (size >> 32) {
+		do_div(size, divisor[units]);
 		i++;
-	} else {
-		remainder *= size;
 	}
 
+	/* now perform the actual multiplication keeping i as the sum of the
+	 * two logarithms */
 	size *= blk_size;
-	size += remainder / divisor[units];
-	remainder %= divisor[units];
 
+	/* and logarithmically reduce it until it's just under the divisor */
 	while (size >= divisor[units]) {
 		remainder = do_div(size, divisor[units]);
 		i++;
 	}
 
+	/* work out in j how many digits of precision we need from the
+	 * remainder */
 	sf_cap = size;
 	for (j = 0; sf_cap*10 < 1000; j++)
 		sf_cap *= 10;
 
-	if (j) {
+	if (units == STRING_UNITS_2) {
+		/* express the remainder as a decimal.  It's currently the
+		 * numerator of a fraction whose denominator is
+		 * divisor[units], which is 1 << 10 for STRING_UNITS_2 */
 		remainder *= 1000;
-		remainder /= divisor[units];
+		remainder >>= 10;
+	}
+
+	/* add a 5 to the digit below what will be printed to ensure
+	 * an arithmetical round up and carry it through to size */
+	remainder += rounding[j];
+	if (remainder >= 1000) {
+		remainder -= 1000;
+		size += 1;
+	}
+
+	if (j) {
 		snprintf(tmp, sizeof(tmp), ".%03u", remainder);
 		tmp[j+1] = '\0';
 	}
_

Patches currently in -mm which might be from JBottomley@Odin.com are


