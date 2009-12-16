From: akpm@linux-foundation.org
Subject: [merged] gru-add-hugepage-support.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:41:07 -0800
Message-ID: <200912162041.nBGKf7FF013709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965029AbZLPUlJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:41:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: add hugepage support
has been removed from the -mm tree.  Its filename was
     gru-add-hugepage-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: add hugepage support
From: Jack Steiner <steiner@sgi.com>

Add support for hugepages. Easier than I originally thought.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-add-hugepage-support drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-add-hugepage-support
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -192,10 +192,11 @@ static int non_atomic_pte_lookup(struct 
 {
 	struct page *page;
 
-	/* ZZZ Need to handle HUGE pages */
-	if (is_vm_hugetlb_page(vma))
-		return -EFAULT;
+#ifdef CONFIG_HUGETLB_PAGE
+	*pageshift = is_vm_hugetlb_page(vma) ? HPAGE_SHIFT : PAGE_SHIFT;
+#else
 	*pageshift = PAGE_SHIFT;
+#endif
 	if (get_user_pages
 	    (current, current->mm, vaddr, 1, write, 0, &page, NULL) <= 0)
 		return -EFAULT;
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

