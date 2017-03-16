From: akpm@linux-foundation.org
Subject: [patch 1/6] z3fold: fix spinlock unlocking in page reclaim
Date: Thu, 16 Mar 2017 16:40:19 -0700
Message-ID: <58cb2263.v3n2UXmdgAL+y4ef%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48224 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752072AbdCPXsY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 19:48:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vitalywool@gmail.com, ddstreet@ieee.org, khoroshilov@ispras.ru

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
