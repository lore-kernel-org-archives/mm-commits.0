From: akpm@linux-foundation.org
Subject: [merged]
 lib-bitmapc-correct-a-code-style-and-do-some-optimization.patch removed
 from -mm tree
Date: Fri, 11 Sep 2015 11:11:53 -0700
Message-ID: <55f31969.JL2hhPgPjwdUdpY2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbbIKSLy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:11:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xinhuix.pan@intel.com, cmetcalf@ezchip.com, linux@rasmusvillemoes.dk, sudeep.holla@arm.com, yury.norov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: correct a code style and do some, optimization
has been removed from the -mm tree.  Its filename was
     lib-bitmapc-correct-a-code-style-and-do-some-optimization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pan Xinhui <xinhuix.pan@intel.com>
Subject: lib/bitmap.c: correct a code style and do some, optimization

We can avoid in-loop incrementation of ndigits.  Save current totaldigits
to ndigits before loop, and check ndigits against totaldigits after the
loop.

Signed-off-by: Pan Xinhui <xinhuix.pan@intel.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN lib/bitmap.c~lib-bitmapc-correct-a-code-style-and-do-some-optimization lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-correct-a-code-style-and-do-some-optimization
+++ a/lib/bitmap.c
@@ -367,7 +367,8 @@ int __bitmap_parse(const char *buf, unsi
 
 	nchunks = nbits = totaldigits = c = 0;
 	do {
-		chunk = ndigits = 0;
+		chunk = 0;
+		ndigits = totaldigits;
 
 		/* Get the next chunk of the bitmap */
 		while (buflen) {
@@ -406,9 +407,9 @@ int __bitmap_parse(const char *buf, unsi
 				return -EOVERFLOW;
 
 			chunk = (chunk << 4) | hex_to_bin(c);
-			ndigits++; totaldigits++;
+			totaldigits++;
 		}
-		if (ndigits == 0)
+		if (ndigits == totaldigits)
 			return -EINVAL;
 		if (nchunks == 0 && chunk == 0)
 			continue;
_

Patches currently in -mm which might be from xinhuix.pan@intel.com are


