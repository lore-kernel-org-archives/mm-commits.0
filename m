From: akpm@linux-foundation.org
Subject: + lib-lcmc-lcmn0=lcm0n-is-0-not-n.patch added to -mm tree
Date: Tue, 09 Dec 2014 13:58:32 -0800
Message-ID: <54877088.kDKf3KOZJwUzMNAC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaLIV6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2014 16:58:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, martin.petersen@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/lcm.c: lcm(n,0)=lcm(0,n) is 0, not n
has been added to the -mm tree.  Its filename is
     lib-lcmc-lcmn0=lcm0n-is-0-not-n.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-lcmc-lcmn0%3Dlcm0n-is-0-not-n.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-lcmc-lcmn0%3Dlcm0n-is-0-not-n.patch

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
