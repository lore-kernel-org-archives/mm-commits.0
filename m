From: akpm@linux-foundation.org
Subject: + lib-lcmc-ensure-correct-result-whenever-it-fits.patch added to
 -mm tree
Date: Tue, 09 Dec 2014 13:58:30 -0800
Message-ID: <54877086.foCbVx/PC4/nnCCl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbaLIV6b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2014 16:58:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, martin.petersen@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/lcm.c: ensure correct result whenever it fits
has been added to the -mm tree.  Its filename is
     lib-lcmc-ensure-correct-result-whenever-it-fits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-lcmc-ensure-correct-result-whenever-it-fits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-lcmc-ensure-correct-result-whenever-it-fits.patch

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

lib-lcmc-ensure-correct-result-whenever-it-fits.patch
lib-lcmc-lcmn0=lcm0n-is-0-not-n.patch
linux-next.patch

