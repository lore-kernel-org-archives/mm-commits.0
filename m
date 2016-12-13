From: akpm@linux-foundation.org
Subject: [patch 054/123] mm/filemap.c: add comment for confusing logic in
 page_cache_tree_insert()
Date: Mon, 12 Dec 2016 16:43:17 -0800
Message-ID: <584f4425.vuagkStgwYog37xb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41184 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbcLMAnT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:43:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, hannes@cmpxchg.org, jack@suse.cz

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
