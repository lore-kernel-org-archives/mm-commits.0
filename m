From: akpm@linux-foundation.org
Subject: [patch 079/119] mm: improve comment on page->mapping
Date: Wed, 31 Jan 2018 16:18:55 -0800
Message-ID: <20180201001855.O1qNMQVbR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35868 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755828AbeBAATA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:19:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, rdunlap@infradead.org, torvalds@linux-foundation.org

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
