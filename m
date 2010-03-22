From: akpm@linux-foundation.org
Subject: + ratelimit-fix-the-return-value-when-__ratelimit-fails-to-acquire-the-lock.patch added to -mm tree
Date: Mon, 22 Mar 2010 13:08:14 -0700
Message-ID: <201003222008.o2MK8Enm024603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753687Ab0CVUI2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 16:08:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yong.zhang@windriver.com, borntraeger@de.ibm.com, mingo@elte.hu


The patch titled
     ratelimit: fix the return value when __ratelimit() fails to acquire the lock
has been added to the -mm tree.  Its filename is
     ratelimit-fix-the-return-value-when-__ratelimit-fails-to-acquire-the-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

ratelimit-annotate-___ratelimit.patch
ratelimit-annotate-___ratelimit-fix.patch
kernelh-fix-wrong-usage-of-__ratelimit.patch
ratelimit-fix-the-return-value-when-__ratelimit-fails-to-acquire-the-lock.patch

