From: akpm@linux-foundation.org
Subject: [merged] thp-clear-page-compound.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:01 -0800
Message-ID: <201101142249.p0EMnpf6005330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861Ab1ANWuA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, cl@linux-foundation.org, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: clear page compound
has been removed from the -mm tree.  Its filename was
     thp-clear-page-compound.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: clear page compound
From: Andrea Arcangeli <aarcange@redhat.com>

split_huge_page must transform a compound page to a regular page and needs
ClearPageCompound.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -puN include/linux/page-flags.h~thp-clear-page-compound include/linux/page-flags.h
--- a/include/linux/page-flags.h~thp-clear-page-compound
+++ a/include/linux/page-flags.h
@@ -347,7 +347,7 @@ static inline void set_page_writeback(st
  * tests can be used in performance sensitive paths. PageCompound is
  * generally not used in hot code paths.
  */
-__PAGEFLAG(Head, head)
+__PAGEFLAG(Head, head) CLEARPAGEFLAG(Head, head)
 __PAGEFLAG(Tail, tail)
 
 static inline int PageCompound(struct page *page)
@@ -355,6 +355,13 @@ static inline int PageCompound(struct pa
 	return page->flags & ((1L << PG_head) | (1L << PG_tail));
 
 }
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline void ClearPageCompound(struct page *page)
+{
+	BUG_ON(!PageHead(page));
+	ClearPageHead(page);
+}
+#endif
 #else
 /*
  * Reduce page flag use as much as possible by overlapping
@@ -392,6 +399,14 @@ static inline void __ClearPageTail(struc
 	page->flags &= ~PG_head_tail_mask;
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline void ClearPageCompound(struct page *page)
+{
+	BUG_ON((page->flags & PG_head_tail_mask) != (1 << PG_compound));
+	clear_bit(PG_compound, &page->flags);
+}
+#endif
+
 #endif /* !PAGEFLAGS_EXTENDED */
 
 #ifdef CONFIG_MMU
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

