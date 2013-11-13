From: akpm@linux-foundation.org
Subject: [merged]
 kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:40:00 -0800
Message-ID: <5283e3a0.0ksBgOpd9qDg/UQH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3KMUkA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen@asianux.com

Subject: [merged] kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk.patch removed from -mm tree
To: gang.chen@asianux.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:00 -0800


The patch titled
     Subject: kernel/delayacct.c: remove redundant checking in __delayacct_add_tsk()
has been removed from the -mm tree.  Its filename was
     kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
