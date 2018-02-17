From: akpm@linux-foundation.org
Subject: + z3fold-limit-use-of-stale-list-for-allocation.patch added to
 -mm tree
Date: Fri, 16 Feb 2018 16:28:41 -0800
Message-ID: <5a877739.DK8nO073sj0LBKq6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46886 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbeBQA2m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 19:28:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, akpm@linux-foundation.org, Oleksiy.Avramchenko@sony.com, vitaly.vul@sony.com, mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold: limit use of stale list for allocation
has been added to the -mm tree.  Its filename is
     z3fold-limit-use-of-stale-list-for-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/z3fold-limit-use-of-stale-list-for-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/z3fold-limit-use-of-stale-list-for-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vitaly Wool <vitalywool@gmail.com>
Subject: z3fold: limit use of stale list for allocation

Currently if z3fold couldn't find an unbuddied page it would first try to
pull a page off the stale list.  The problem with this approach is that we
can't 100% guarantee that the page is not processed by the workqueue
thread at the same time unless we run cancel_work_sync() on it, which we
can't do if we're in an atomic context.  So let's just limit stale list
usage to non-atomic contexts only.

Link: http://lkml.kernel.org/r/47ab51e7-e9c1-d30e-ab17-f734dbc3abce@gmail.com
Signed-off-by: Vitaly Vul <vitaly.vul@sony.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <Oleksiy.Avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff -puN mm/z3fold.c~z3fold-limit-use-of-stale-list-for-allocation mm/z3fold.c
--- a/mm/z3fold.c~z3fold-limit-use-of-stale-list-for-allocation
+++ a/mm/z3fold.c
@@ -620,24 +620,27 @@ lookup:
 		bud = FIRST;
 	}
 
-	spin_lock(&pool->stale_lock);
-	zhdr = list_first_entry_or_null(&pool->stale,
-					struct z3fold_header, buddy);
-	/*
-	 * Before allocating a page, let's see if we can take one from the
-	 * stale pages list. cancel_work_sync() can sleep so we must make
-	 * sure it won't be called in case we're in atomic context.
-	 */
-	if (zhdr && (can_sleep || !work_pending(&zhdr->work))) {
-		list_del(&zhdr->buddy);
-		spin_unlock(&pool->stale_lock);
-		if (can_sleep)
+	page = NULL;
+	if (can_sleep) {
+		spin_lock(&pool->stale_lock);
+		zhdr = list_first_entry_or_null(&pool->stale,
+						struct z3fold_header, buddy);
+		/*
+		 * Before allocating a page, let's see if we can take one from
+		 * the stale pages list. cancel_work_sync() can sleep so we
+		 * limit this case to the contexts where we can sleep
+		 */
+		if (zhdr) {
+			list_del(&zhdr->buddy);
+			spin_unlock(&pool->stale_lock);
 			cancel_work_sync(&zhdr->work);
-		page = virt_to_page(zhdr);
-	} else {
-		spin_unlock(&pool->stale_lock);
-		page = alloc_page(gfp);
+			page = virt_to_page(zhdr);
+		} else {
+			spin_unlock(&pool->stale_lock);
+		}
 	}
+	if (!page)
+		page = alloc_page(gfp);
 
 	if (!page)
 		return -ENOMEM;
_

Patches currently in -mm which might be from vitalywool@gmail.com are

z3fold-limit-use-of-stale-list-for-allocation.patch

