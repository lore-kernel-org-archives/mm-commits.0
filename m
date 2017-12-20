From: akpm@linux-foundation.org
Subject: + mm-align-struct-page-more-aesthetically.patch added to -mm tree
Date: Wed, 20 Dec 2017 15:42:37 -0800
Message-ID: <5a3af56d.xklJtgh/gfVItRFQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57580 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755637AbdLTXmj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Dec 2017 18:42:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, cl@linux.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: align struct page more aesthetically
has been added to the -mm tree.  Its filename is
     mm-align-struct-page-more-aesthetically.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-align-struct-page-more-aesthetically.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-align-struct-page-more-aesthetically.patch

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
Subject: mm: align struct page more aesthetically

Patch series "Restructure struct page", v2.

This series does not attempt any grand restructuring.  Instead, it cures
the worst of the indentitis, fixes the documentation and reduces the
ifdeffery.  The only layout change is compound_dtor and compound_order are
each reduced to one byte.


This patch (of 8):

Instead of an ifdef block at the end of the struct, which needed its own
comment, define _struct_page_alignment up at the top where it fits nicely
with the existing comment.

Link: http://lkml.kernel.org/r/20171220155552.15884-2-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN include/linux/mm_types.h~mm-align-struct-page-more-aesthetically include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-align-struct-page-more-aesthetically
+++ a/include/linux/mm_types.h
@@ -39,6 +39,12 @@ struct hmm;
  * allows the use of atomic double word operations on the flags/mapping
  * and lru list pointers also.
  */
+#ifdef CONFIG_HAVE_ALIGNED_STRUCT_PAGE
+#define _struct_page_alignment	__aligned(2 * sizeof(unsigned long))
+#else
+#define _struct_page_alignment
+#endif
+
 struct page {
 	/* First double word block */
 	unsigned long flags;		/* Atomic flags, some possibly
@@ -212,15 +218,7 @@ struct page {
 #ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
 	int _last_cpupid;
 #endif
-}
-/*
- * The struct page can be forced to be double word aligned so that atomic ops
- * on double words work. The SLUB allocator can make use of such a feature.
- */
-#ifdef CONFIG_HAVE_ALIGNED_STRUCT_PAGE
-	__aligned(2 * sizeof(unsigned long))
-#endif
-;
+} _struct_page_alignment;
 
 #define PAGE_FRAG_CACHE_MAX_SIZE	__ALIGN_MASK(32768, ~PAGE_MASK)
 #define PAGE_FRAG_CACHE_MAX_ORDER	get_order(PAGE_FRAG_CACHE_MAX_SIZE)
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

