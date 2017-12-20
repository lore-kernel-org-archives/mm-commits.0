From: akpm@linux-foundation.org
Subject: + mm-introduce-_slub_counter_t.patch added to -mm tree
Date: Wed, 20 Dec 2017 15:42:49 -0800
Message-ID: <5a3af579.UpGbQIs0Zgy3FrXx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57966 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755637AbdLTXm4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Dec 2017 18:42:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, cl@linux.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce _slub_counter_t
has been added to the -mm tree.  Its filename is
     mm-introduce-_slub_counter_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-_slub_counter_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-_slub_counter_t.patch

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
Subject: mm: introduce _slub_counter_t

Instead of putting the ifdef in the middle of the definition of struct
page, pull it forward to the rest of the ifdeffery around the SLUB
cmpxchg_double optimisation.

Link: http://lkml.kernel.org/r/20171220155552.15884-6-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN include/linux/mm_types.h~mm-introduce-_slub_counter_t include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-introduce-_slub_counter_t
+++ a/include/linux/mm_types.h
@@ -41,9 +41,15 @@ struct hmm;
  */
 #ifdef CONFIG_HAVE_ALIGNED_STRUCT_PAGE
 #define _struct_page_alignment	__aligned(2 * sizeof(unsigned long))
+#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE)
+#define _slub_counter_t		unsigned long
 #else
-#define _struct_page_alignment
+#define _slub_counter_t		unsigned int
 #endif
+#else /* !CONFIG_HAVE_ALIGNED_STRUCT_PAGE */
+#define _struct_page_alignment
+#define _slub_counter_t		unsigned int
+#endif /* !CONFIG_HAVE_ALIGNED_STRUCT_PAGE */
 
 struct page {
 	/* First double word block */
@@ -66,18 +72,7 @@ struct page {
 	};
 
 	union {
-#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
-	defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
-		/* Used for cmpxchg_double in slub */
-		unsigned long counters;
-#else
-		/*
-		 * Keep _refcount separate from slub cmpxchg_double data.
-		 * As the rest of the double word is protected by slab_lock
-		 * but _refcount is not.
-		 */
-		unsigned counters;
-#endif
+		_slub_counter_t counters;
 		unsigned int active;		/* SLAB */
 		struct {			/* SLUB */
 			unsigned inuse:16;
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

