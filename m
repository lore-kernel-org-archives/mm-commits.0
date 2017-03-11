From: akpm@linux-foundation.org
Subject: + z3fold-fix-spinlock-unlocking-in-page-reclaim.patch added to
 -mm tree
Date: Sat, 11 Mar 2017 15:21:48 -0800
Message-ID: <58c4868c.jq9eqexDA5eBonoH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57782 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751325AbdCKXVu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 11 Mar 2017 18:21:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, ddstreet@ieee.org, khoroshilov@ispras.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold: fix spinlock unlocking in page reclaim
has been added to the -mm tree.  Its filename is
     z3fold-fix-spinlock-unlocking-in-page-reclaim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/z3fold-fix-spinlock-unlocking-in-page-reclaim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/z3fold-fix-spinlock-unlocking-in-page-reclaim.patch

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
Subject: z3fold: fix spinlock unlocking in page reclaim

5a27aa8220290b64 ("z3fold: add kref refcounting") introduced a bug in
z3fold_reclaim_page() with function exit that may leave pool->lock
spinlock held.  Here comes the trivial fix.

Fixes: 5a27aa8220290b ("z3fold: add kref refcounting")
Link: http://lkml.kernel.org/r/20170311222239.7b83d8e7ef1914e05497649f@gmail.com
Reported-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/z3fold.c~z3fold-fix-spinlock-unlocking-in-page-reclaim mm/z3fold.c
--- a/mm/z3fold.c~z3fold-fix-spinlock-unlocking-in-page-reclaim
+++ a/mm/z3fold.c
@@ -667,6 +667,7 @@ next:
 			z3fold_page_unlock(zhdr);
 			spin_lock(&pool->lock);
 			if (kref_put(&zhdr->refcount, release_z3fold_page)) {
+				spin_unlock(&pool->lock);
 				atomic64_dec(&pool->pages_nr);
 				return 0;
 			}
_

Patches currently in -mm which might be from vitalywool@gmail.com are

z3fold-fix-spinlock-unlocking-in-page-reclaim.patch

