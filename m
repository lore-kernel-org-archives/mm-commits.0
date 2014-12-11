From: akpm@linux-foundation.org
Subject: [merged] lib-lcmc-lcmn0=lcm0n-is-0-not-n.patch removed from -mm
 tree
Date: Thu, 11 Dec 2014 11:05:18 -0800
Message-ID: <5489eaee.BkZcKb30pWq+OmO0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaLKTFT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:05:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, martin.petersen@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/lcm.c: lcm(n,0)=lcm(0,n) is 0, not n
has been removed from the -mm tree.  Its filename was
     lib-lcmc-lcmn0=lcm0n-is-0-not-n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/lcm.c: lcm(n,0)=lcm(0,n) is 0, not n

Return the mathematically correct answer when an argument is 0.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lcm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN lib/lcm.c~lib-lcmc-lcmn0=lcm0n-is-0-not-n lib/lcm.c
--- a/lib/lcm.c~lib-lcmc-lcmn0=lcm0n-is-0-not-n
+++ a/lib/lcm.c
@@ -8,9 +8,7 @@ unsigned long lcm(unsigned long a, unsig
 {
 	if (a && b)
 		return (a / gcd(a, b)) * b;
-	else if (b)
-		return b;
