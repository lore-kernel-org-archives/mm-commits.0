From: akpm@linux-foundation.org
Subject: [folded-merged]
 z3fold-add-kref-refcounting-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 24 Feb 2017 14:49:58 -0800
Message-ID: <58b0b896.Gd2CGilL5ANUbL63%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36682 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdBXWt7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:49:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vitalywool@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: z3fold-add-kref-refcounting-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     z3fold-add-kref-refcounting-checkpatch-fixes.patch

This patch was dropped because it was folded into z3fold-add-kref-refcounting.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: z3fold-add-kref-refcounting-checkpatch-fixes

WARNING: Missing a blank line after declarations
#93: FILE: mm/z3fold.c:172:
+	struct page *page = virt_to_page(zhdr);
+	if (!list_empty(&zhdr->buddy))

total: 0 errors, 1 warnings, 261 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/z3fold-add-kref-refcounting.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Vitaly Wool <vitalywool@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/z3fold.c~z3fold-add-kref-refcounting-checkpatch-fixes mm/z3fold.c
--- a/mm/z3fold.c~z3fold-add-kref-refcounting-checkpatch-fixes
+++ a/mm/z3fold.c
@@ -166,9 +166,12 @@ static void free_z3fold_page(struct page
 
 static void release_z3fold_page(struct kref *ref)
 {
-	struct z3fold_header *zhdr = container_of(ref, struct z3fold_header,
-						refcount);
-	struct page *page = virt_to_page(zhdr);
+	struct z3fold_header *zhdr;
+	struct page *page;
+
+	zhdr = container_of(ref, struct z3fold_header, refcount);
+	page = virt_to_page(zhdr);
+
 	if (!list_empty(&zhdr->buddy))
 		list_del(&zhdr->buddy);
 	if (!list_empty(&page->lru))
@@ -188,7 +191,6 @@ static inline void z3fold_page_unlock(st
 	spin_unlock(&zhdr->page_lock);
 }
 
