From: akpm@linux-foundation.org
Subject: [merged]
 filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:25:06 -0800
Message-ID: <58519c92.ojKZ5a0a8c5hPW4F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44412 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756564AbcLNTZH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:25:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, hannes@cmpxchg.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap.c: add comment for confusing logic in page_cache_tree_insert()
has been removed from the -mm tree.  Its filename was
     filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/filemap.c: add comment for confusing logic in page_cache_tree_insert()

Unlike THP, hugetlb pages are represented by one entry in the radix-tree.

[akpm@linux-foundation.org: tweak comment]
Link: http://lkml.kernel.org/r/20161110163640.126124-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert mm/filemap.c
--- a/mm/filemap.c~filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert
+++ a/mm/filemap.c
@@ -169,7 +169,10 @@ static int page_cache_tree_insert(struct
 static void page_cache_tree_delete(struct address_space *mapping,
 				   struct page *page, void *shadow)
 {
-	int i, nr = PageHuge(page) ? 1 : hpage_nr_pages(page);
+	int i, nr;
+
+	/* hugetlb pages are represented by one entry in the radix tree */
+	nr = PageHuge(page) ? 1 : hpage_nr_pages(page);
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageTail(page), page);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


