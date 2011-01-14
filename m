From: akpm@linux-foundation.org
Subject: [merged] thp-put_page-recheck-pagehead-after-releasing-the-compound_lock.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:28 -0800
Message-ID: <201101142249.p0EMnIJO005281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753781Ab1ANWt2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: put_page: recheck PageHead after releasing the compound_lock
has been removed from the -mm tree.  Its filename was
     thp-put_page-recheck-pagehead-after-releasing-the-compound_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: put_page: recheck PageHead after releasing the compound_lock
From: Andrea Arcangeli <aarcange@redhat.com>

After releasing the compound_lock split_huge_page can still run and release the
page before put_page_testzero runs.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/swap.c~thp-put_page-recheck-pagehead-after-releasing-the-compound_lock mm/swap.c
--- a/mm/swap.c~thp-put_page-recheck-pagehead-after-releasing-the-compound_lock
+++ a/mm/swap.c
@@ -131,8 +131,12 @@ static void put_compound_page(struct pag
 			atomic_dec(&page->_count);
 			VM_BUG_ON(atomic_read(&page_head->_count) <= 0);
 			compound_unlock_irqrestore(page_head, flags);
-			if (put_page_testzero(page_head))
-				__put_compound_page(page_head);
+			if (put_page_testzero(page_head)) {
+				if (PageHead(page_head))
+					__put_compound_page(page_head);
+				else
+					__put_single_page(page_head);
+			}
 		} else {
 			/* page_head is a dangling pointer */
 			VM_BUG_ON(PageTail(page));
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

