From: akpm@linux-foundation.org
Subject: +
 filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert.patch
 added to -mm tree
Date: Tue, 15 Nov 2016 16:11:28 -0800
Message-ID: <582ba430.VgLpAXdV/SsILD/C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44766 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752263AbcKPALa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2016 19:11:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, hannes@cmpxchg.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap.c: add comment for confusing logic in page_cache_tree_insert()
has been added to the -mm tree.  Its filename is
     filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/filemap.c: add comment for confusing logic in page_cache_tree_insert()

Unlike THP, hugetlb pages are represented by one entry in the radix-tree.

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
+	/* hugetlb pages represented by one entry on radix-tree */
+	nr = PageHuge(page) ? 1 : hpage_nr_pages(page);
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageTail(page), page);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-bug-in-munlock_vma_pages_range.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert.patch

