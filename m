From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race.patch removed
 from -mm tree
Date: Fri, 31 Jan 2014 12:34:58 -0800
Message-ID: <52ec08f2.3hVFuihKLXYrg7dT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaAaUe7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 15:34:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, aarcange@redhat.com, oleg@redhat.com

Subject: [obsolete] mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race.patch removed from -mm tree
To: oleg@redhat.com,aarcange@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 12:34:58 -0800


The patch titled
     Subject: mm: fix the theoretical compound_lock() vs prep_new_page() race
has been removed from the -mm tree.  Its filename was
     mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm: fix the theoretical compound_lock() vs prep_new_page() race

get/put_page(thp_tail) paths do get_page_unless_zero(page_head) +
compound_lock().  In theory this page_head can be already freed and
reallocated as alloc_pages(__GFP_COMP, smaller_order).  In this case
get_page_unless_zero() can succeed right after set_page_refcounted(), and
compound_lock() can race with the non-atomic __SetPageHead() in
prep_compound_page().

Perhaps we should rework the thp locking (under discussion), but until
then this patch moves set_page_refcounted() and adds wmb() to ensure that
page->_count != 0 comes as a last change.

I am not sure about other callers of set_page_refcounted(), but at first
glance they look fine to me.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race
+++ a/mm/page_alloc.c
@@ -890,8 +890,6 @@ static int prep_new_page(struct page *pa
 	}
 
 	set_page_private(page, 0);
-	set_page_refcounted(page);
-
 	arch_alloc_page(page, order);
 	kernel_map_pages(page, 1 << order, 1);
 
@@ -901,6 +899,16 @@ static int prep_new_page(struct page *pa
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
+	/*
+	 * Make sure the caller of get_page_unless_zero() will see the
+	 * fully initialized page. Say, to ensure that compound_lock()
+	 * can't race with the non-atomic __SetPage*() above.
+	 */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	smp_wmb();
+#endif
+	set_page_refcounted(page);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch

