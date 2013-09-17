From: akpm@linux-foundation.org
Subject: +
 kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk.patch
 added to -mm tree
Date: Tue, 17 Sep 2013 15:37:16 -0700
Message-ID: <5238d99c.LODgu49Zy4ZvLtzu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3IQWhR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Sep 2013 18:37:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen@asianux.com

Subject: + kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk.patch added to -mm tree
To: gang.chen@asianux.com
From: akpm@linux-foundation.org
Date: Tue, 17 Sep 2013 15:37:16 -0700


The patch titled
     Subject: kernel/delayacct.c: remove redundant checking in __delayacct_add_tsk()
has been added to the -mm tree.  Its filename is
     kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: kernel/delayacct.c: remove redundant checking in __delayacct_add_tsk()

The wrapper function delayacct_add_tsk() already checked 'tsk->delays',
and __delayacct_add_tsk() has no another direct callers, so can remove the
redundancy checking code.

And the label 'done' is also useless, so remove it, too.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/delayacct.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN kernel/delayacct.c~kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk kernel/delayacct.c
--- a/kernel/delayacct.c~kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk
+++ a/kernel/delayacct.c
@@ -108,12 +108,6 @@ int __delayacct_add_tsk(struct taskstats
 	struct timespec ts;
 	cputime_t utime, stime, stimescaled, utimescaled;
 
-	/* Though tsk->delays accessed later, early exit avoids
-	 * unnecessary returning of other data
-	 */
-	if (!tsk->delays)
-		goto done;
