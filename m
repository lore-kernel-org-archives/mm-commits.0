From: akpm@linux-foundation.org
Subject: [patch 080/119] mm: introduce _slub_counter_t
Date: Wed, 31 Jan 2018 16:18:58 -0800
Message-ID: <20180201001858.fkHqHKtGw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35868 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755813AbeBAATB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:19:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, kirill.shutemov@linux.intel.com, mawilcox@microsoft.com, mhocko@suse.com, mm-commits@vger.kernel.org, rdunlap@infradead.org, torvalds@linux-foundation.org

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
