From: akpm@linux-foundation.org
Subject: + lib-scatterlistc-fix-kunmap-argument-in-sg_miter_stop.patch added to -mm tree
Date: Sat, 15 Nov 2008 12:50:47 -0800
Message-ID: <200811152050.mAFKolVo007571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbYKOUvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Nov 2008 15:51:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@infradead.org, arjan@linux.intel.com, hugh@veritas.com, stable@kernel.org, tj@kernel.org


The patch titled
     lib/scatterlist.c: fix kunmap() argument in sg_miter_stop()
has been added to the -mm tree.  Its filename is
     lib-scatterlistc-fix-kunmap-argument-in-sg_miter_stop.patch

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
Subject: lib/scatterlist.c: fix kunmap() argument in sg_miter_stop()
From: Arjan van de Ven <arjan@infradead.org>

kunmap() takes as argument the struct page that orginally got kmap()'d,
however the sg_miter_stop() function passed it the kernel virtual address
instead, resulting in weird stuff.

Somehow I ended up fixing this bug by accident while looking for a bug in
the same area.

Reported-by: kerneloops.org
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: <stable@kernel.org>		[2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/scatterlist.c~lib-scatterlistc-fix-kunmap-argument-in-sg_miter_stop lib/scatterlist.c
--- a/lib/scatterlist.c~lib-scatterlistc-fix-kunmap-argument-in-sg_miter_stop
+++ a/lib/scatterlist.c
@@ -395,7 +395,7 @@ void sg_miter_stop(struct sg_mapping_ite
 			WARN_ON(!irqs_disabled());
 			kunmap_atomic(miter->addr, KM_BIO_SRC_IRQ);
 		} else
-			kunmap(miter->addr);
+			kunmap(miter->page);
 
 		miter->page = NULL;
 		miter->addr = NULL;
_

Patches currently in -mm which might be from arjan@infradead.org are

lib-scatterlistc-fix-kunmap-argument-in-sg_miter_stop.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
jbd-improve-fsync-batching.patch
jbd-improve-fsync-batching-update.patch

