From: akpm@linux-foundation.org
Subject: + mm-improve-comment-on-page-mapping.patch added to -mm tree
Date: Wed, 20 Dec 2017 15:42:46 -0800
Message-ID: <5a3af576.wpr+J3+1hEiz9Xfk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57766 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756902AbdLTXmt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Dec 2017 18:42:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, cl@linux.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: improve comment on page->mapping
has been added to the -mm tree.  Its filename is
     mm-improve-comment-on-page-mapping.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-improve-comment-on-page-mapping.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-improve-comment-on-page-mapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: mm: improve comment on page->mapping

The comment on page->mapping is terse, and out of date (it does not
mention the possibility of PAGE_MAPPING_MOVABLE).  Instead, point the
interested reader to page-flags.h where there is a much better comment.

Link: http://lkml.kernel.org/r/20171220155552.15884-5-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN include/linux/mm_types.h~mm-improve-comment-on-page-mapping include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-improve-comment-on-page-mapping
+++ a/include/linux/mm_types.h
@@ -50,15 +50,9 @@ struct page {
 	unsigned long flags;		/* Atomic flags, some possibly
 					 * updated asynchronously */
 	union {
-		struct address_space *mapping;	/* If low bit clear, points to
-						 * inode address_space, or NULL.
-						 * If page mapped as anonymous
-						 * memory, low bit is set, and
-						 * it points to anon_vma object
-						 * or KSM private structure. See
-						 * PAGE_MAPPING_ANON and
-						 * PAGE_MAPPING_KSM.
-						 */
+		/* See page-flags.h for the definition of PAGE_MAPPING_FLAGS */
+		struct address_space *mapping;
+
 		void *s_mem;			/* slab first object */
 		atomic_t compound_mapcount;	/* first tail page */
 		/* page_deferred_list().next	 -- second tail page */
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

provide-useful-debugging-information-for-vm_bug.patch
mm-align-struct-page-more-aesthetically.patch
mm-de-indent-struct-page.patch
mm-remove-misleading-alignment-claims.patch
mm-improve-comment-on-page-mapping.patch
mm-introduce-_slub_counter_t.patch
mm-store-compound_dtor-compound_order-as-bytes.patch
mm-document-how-to-use-struct-page.patch
mm-remove-reference-to-pg_buddy.patch

