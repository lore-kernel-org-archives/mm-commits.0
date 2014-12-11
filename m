From: akpm@linux-foundation.org
Subject: [merged] lib-lcmc-ensure-correct-result-whenever-it-fits.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 11:05:16 -0800
Message-ID: <5489eaec.ugPKXr8rujWN/s20%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaLKTFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, martin.petersen@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/lcm.c: ensure correct result whenever it fits
has been removed from the -mm tree.  Its filename was
     lib-lcmc-ensure-correct-result-whenever-it-fits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/lcm.c: ensure correct result whenever it fits

Ensure that lcm(a,b) returns the mathematically correct result, provided
it fits in an unsigned long.  The current version returns garbage if a*b
overflows, even if the final result would fit.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/lcm.c~lib-lcmc-ensure-correct-result-whenever-it-fits lib/lcm.c
--- a/lib/lcm.c~lib-lcmc-ensure-correct-result-whenever-it-fits
+++ a/lib/lcm.c
@@ -7,7 +7,7 @@
 unsigned long lcm(unsigned long a, unsigned long b)
 {
 	if (a && b)
-		return (a * b) / gcd(a, b);
+		return (a / gcd(a, b)) * b;
 	else if (b)
 		return b;
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

