From: akpm@linux-foundation.org
Subject: [merged] ratelimit-fix-the-return-value-when-__ratelimit-fails-to-acquire-the-lock.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:50:25 -0400
Message-ID: <201004071851.o37IppZ9001332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960Ab0DGSv6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:51:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yong.zhang@windriver.com, borntraeger@de.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     ratelimit: fix the return value when __ratelimit() fails to acquire the lock
has been removed from the -mm tree.  Its filename was
     ratelimit-fix-the-return-value-when-__ratelimit-fails-to-acquire-the-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ratelimit: fix the return value when __ratelimit() fails to acquire the lock
From: Yong Zhang <yong.zhang@windriver.com>

The log of commit edaac8e3167501cda336231d00611bf59c164346 ("ratelimit:
Fix/allow use in atomic contexts"), indicates that we want to suppress the
callback when the trylock fails.

Signed-off-by: Yong Zhang <yong.zhang@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ratelimit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/ratelimit.c~ratelimit-fix-the-return-value-when-__ratelimit-fails-to-acquire-the-lock lib/ratelimit.c
--- a/lib/ratelimit.c~ratelimit-fix-the-return-value-when-__ratelimit-fails-to-acquire-the-lock
+++ a/lib/ratelimit.c
@@ -40,7 +40,7 @@ int ___ratelimit(struct ratelimit_state 
 	 * the entity that is holding the lock already:
 	 */
 	if (!spin_trylock_irqsave(&rs->lock, flags))
-		return 1;
+		return 0;
 
 	if (!rs->begin)
 		rs->begin = jiffies;
_

Patches currently in -mm which might be from yong.zhang@windriver.com are

origin.patch

