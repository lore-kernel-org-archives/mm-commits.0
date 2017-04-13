From: akpm@linux-foundation.org
Subject: [patch 01/11] z3fold: fix page locking in z3fold_alloc()
Date: Thu, 13 Apr 2017 14:56:14 -0700
Message-ID: <58eff3fe.VPuVBxkuN3Y5lAMc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53584 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751139AbdDMV4P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 17:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vitalywool@gmail.com, Oleksiy.Avramchenko@sony.com, ddstreet@ieee.org

From: Vitaly Wool <vitalywool@gmail.com>
Subject: z3fold: fix page locking in z3fold_alloc()

Stress testing of the current z3fold implementation on a 8-core system
revealed it was possible that a z3fold page deleted from its unbuddied
list in z3fold_alloc() would be put on another unbuddied list by
z3fold_free() while z3fold_alloc() is still processing it.  This has been
introduced with commit 5a27aa822 ("z3fold: add kref refcounting") due to
the removal of special handling of a z3fold page not on any list in
z3fold_free().

To fix this, the z3fold page lock should be taken in z3fold_alloc() before
the pool lock is released.  To avoid deadlocking, we just try to lock the
page as soon as we get a hold of it, and if trylock fails, we drop this
page and take the next one.

Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: <Oleksiy.Avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/z3fold.c~z3fold-fix-page-locking-in-z3fold_alloc mm/z3fold.c
--- a/mm/z3fold.c~z3fold-fix-page-locking-in-z3fold_alloc
+++ a/mm/z3fold.c
@@ -185,6 +185,12 @@ static inline void z3fold_page_lock(stru
 	spin_lock(&zhdr->page_lock);
 }
 
+/* Try to lock a z3fold page */
+static inline int z3fold_page_trylock(struct z3fold_header *zhdr)
+{
+	return spin_trylock(&zhdr->page_lock);
+}
+
 /* Unlock a z3fold page */
 static inline void z3fold_page_unlock(struct z3fold_header *zhdr)
 {
@@ -385,7 +391,7 @@ static int z3fold_alloc(struct z3fold_po
 			spin_lock(&pool->lock);
 			zhdr = list_first_entry_or_null(&pool->unbuddied[i],
 						struct z3fold_header, buddy);
-			if (!zhdr) {
+			if (!zhdr || !z3fold_page_trylock(zhdr)) {
 				spin_unlock(&pool->lock);
 				continue;
 			}
@@ -394,7 +400,6 @@ static int z3fold_alloc(struct z3fold_po
 			spin_unlock(&pool->lock);
 
 			page = virt_to_page(zhdr);
-			z3fold_page_lock(zhdr);
 			if (zhdr->first_chunks == 0) {
 				if (zhdr->middle_chunks != 0 &&
 				    chunks >= zhdr->start_middle)
_
