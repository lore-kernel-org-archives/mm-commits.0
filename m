From: akpm@linux-foundation.org
Subject: + mm-document-how-to-use-struct-page.patch added to -mm tree
Date: Wed, 20 Dec 2017 15:42:55 -0800
Message-ID: <5a3af57f.+ODdLa+U2nwV/Ahx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58224 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755928AbdLTXnH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Dec 2017 18:43:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, cl@linux.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: document how to use struct page
has been added to the -mm tree.  Its filename is
     mm-document-how-to-use-struct-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-document-how-to-use-struct-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-document-how-to-use-struct-page.patch

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
Subject: mm: document how to use struct page

Be really explicit about what bits / bytes are reserved for users that
want to store extra information about the pages they allocate.

Link: http://lkml.kernel.org/r/20171220155552.15884-8-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff -puN include/linux/mm_types.h~mm-document-how-to-use-struct-page include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-document-how-to-use-struct-page
+++ a/include/linux/mm_types.h
@@ -31,7 +31,29 @@ struct hmm;
  * it to keep track of whatever it is we are using the page for at the
  * moment. Note that we have no way to track which tasks are using
  * a page, though if it is a pagecache page, rmap structures can tell us
- * who is mapping it.
+ * who is mapping it. If you allocate the page using alloc_pages(), you
+ * can use some of the space in struct page for your own purposes.
+ *
+ * Pages that were once in the page cache may be found under the RCU lock
+ * even after they have been recycled to a different purpose.  The page
+ * cache reads and writes some of the fields in struct page to pin the
+ * page before checking that it's still in the page cache.  It is vital
+ * that all users of struct page:
+ * 1. Use the first word as PageFlags.
+ * 2. Clear or preserve bit 0 of page->compound_head.  It is used as
+ *    PageTail for compound pages, and the page cache must not see false
+ *    positives.  Some users put a pointer here (guaranteed to be at least
+ *    4-byte aligned), other users avoid using the field altogether.
+ * 3. page->_refcount must either not be used, or must be used in such a
+ *    way that other CPUs temporarily incrementing and then decrementing the
+ *    refcount does not cause problems.  On receiving the page from
+ *    alloc_pages(), the refcount will be positive.
+ * 4. Either preserve page->_mapcount or restore it to -1 before freeing it.
+ *
+ * If you allocate pages of order > 0, you can use the fields in the struct
+ * page associated with each page, but bear in mind that the pages may have
+ * been inserted individually into the page cache, so you must use the above
+ * four fields in a compatible way for each struct page.
  *
  * SLUB uses cmpxchg_double() to atomically update its freelist and
  * counters.  That requires that freelist & counters be adjacent and
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

