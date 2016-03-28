From: akpm@linux-foundation.org
Subject: + mm-rename-_count-field-of-the-struct-page-to-_refcount.patch
 added to -mm tree
Date: Mon, 28 Mar 2016 13:52:32 -0700
Message-ID: <56f99990.c2R6pZ/y1eRQR5Pr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbcC1Uwe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 16:52:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cmetcalf@mellanox.com, davem@davemloft.net, hughd@google.com, johannes@sipsolutions.net, sgoutham@cavium.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename _count, field of the struct page, to _refcount
has been added to the -mm tree.  Its filename is
     mm-rename-_count-field-of-the-struct-page-to-_refcount.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-rename-_count-field-of-the-struct-page-to-_refcount.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-_count-field-of-the-struct-page-to-_refcount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm: rename _count, field of the struct page, to _refcount

Many developers already know that field for reference count of the struct
page is _count and atomic type.  They would try to handle it directly and
this could break the purpose of page reference count tracepoint.  To
prevent direct _count modification, this patch rename it to _refcount and
add warning message on the code.  After that, developer who need to handle
reference count will find that field should not be accessed directly.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Sunil Goutham <sgoutham@cavium.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/mm/init.c      |    2 +-
 include/linux/mm_types.h |    8 ++++++--
 include/linux/page_ref.h |   26 +++++++++++++-------------
 kernel/kexec_core.c      |    2 +-
 4 files changed, 21 insertions(+), 17 deletions(-)

diff -puN arch/tile/mm/init.c~mm-rename-_count-field-of-the-struct-page-to-_refcount arch/tile/mm/init.c
--- a/arch/tile/mm/init.c~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/arch/tile/mm/init.c
@@ -679,7 +679,7 @@ static void __init init_free_pfn_range(u
 			 * Hacky direct set to avoid unnecessary
 			 * lock take/release for EVERY page here.
 			 */
-			p->_count.counter = 0;
+			p->_refcount.counter = 0;
 			p->_mapcount.counter = -1;
 		}
 		init_page_count(page);
diff -puN include/linux/mm_types.h~mm-rename-_count-field-of-the-struct-page-to-_refcount include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/include/linux/mm_types.h
@@ -97,7 +97,11 @@ struct page {
 					};
 					int units;	/* SLOB */
 				};
-				atomic_t _count;		/* Usage count, see below. */
+				/*
+				 * Usage count, *USE WRAPPER FUNCTION*
+				 * when manual accounting. See page_ref.h
+				 */
+				atomic_t _refcount;
 			};
 			unsigned int active;	/* SLAB */
 		};
@@ -248,7 +252,7 @@ struct page_frag_cache {
 	__u32 offset;
 #endif
 	/* we maintain a pagecount bias, so that we dont dirty cache line
-	 * containing page->_count every time we allocate a fragment.
+	 * containing page->_refcount every time we allocate a fragment.
 	 */
 	unsigned int		pagecnt_bias;
 	bool pfmemalloc;
diff -puN include/linux/page_ref.h~mm-rename-_count-field-of-the-struct-page-to-_refcount include/linux/page_ref.h
--- a/include/linux/page_ref.h~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/include/linux/page_ref.h
@@ -63,17 +63,17 @@ static inline void __page_ref_unfreeze(s
 
 static inline int page_ref_count(struct page *page)
 {
-	return atomic_read(&page->_count);
+	return atomic_read(&page->_refcount);
 }
 
 static inline int page_count(struct page *page)
 {
-	return atomic_read(&compound_head(page)->_count);
+	return atomic_read(&compound_head(page)->_refcount);
 }
 
 static inline void set_page_count(struct page *page, int v)
 {
-	atomic_set(&page->_count, v);
+	atomic_set(&page->_refcount, v);
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_set))
 		__page_ref_set(page, v);
 }
@@ -89,35 +89,35 @@ static inline void init_page_count(struc
 
 static inline void page_ref_add(struct page *page, int nr)
 {
-	atomic_add(nr, &page->_count);
+	atomic_add(nr, &page->_refcount);
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod))
 		__page_ref_mod(page, nr);
 }
 
 static inline void page_ref_sub(struct page *page, int nr)
 {
-	atomic_sub(nr, &page->_count);
+	atomic_sub(nr, &page->_refcount);
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod))
 		__page_ref_mod(page, -nr);
 }
 
 static inline void page_ref_inc(struct page *page)
 {
-	atomic_inc(&page->_count);
+	atomic_inc(&page->_refcount);
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod))
 		__page_ref_mod(page, 1);
 }
 
 static inline void page_ref_dec(struct page *page)
 {
-	atomic_dec(&page->_count);
+	atomic_dec(&page->_refcount);
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod))
 		__page_ref_mod(page, -1);
 }
 
 static inline int page_ref_sub_and_test(struct page *page, int nr)
 {
-	int ret = atomic_sub_and_test(nr, &page->_count);
+	int ret = atomic_sub_and_test(nr, &page->_refcount);
 
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -nr, ret);
@@ -126,7 +126,7 @@ static inline int page_ref_sub_and_test(
 
 static inline int page_ref_dec_and_test(struct page *page)
 {
-	int ret = atomic_dec_and_test(&page->_count);
+	int ret = atomic_dec_and_test(&page->_refcount);
 
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -1, ret);
@@ -135,7 +135,7 @@ static inline int page_ref_dec_and_test(
 
 static inline int page_ref_dec_return(struct page *page)
 {
-	int ret = atomic_dec_return(&page->_count);
+	int ret = atomic_dec_return(&page->_refcount);
 
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod_and_return))
 		__page_ref_mod_and_return(page, -1, ret);
@@ -144,7 +144,7 @@ static inline int page_ref_dec_return(st
 
 static inline int page_ref_add_unless(struct page *page, int nr, int u)
 {
-	int ret = atomic_add_unless(&page->_count, nr, u);
+	int ret = atomic_add_unless(&page->_refcount, nr, u);
 
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod_unless))
 		__page_ref_mod_unless(page, nr, ret);
@@ -153,7 +153,7 @@ static inline int page_ref_add_unless(st
 
 static inline int page_ref_freeze(struct page *page, int count)
 {
-	int ret = likely(atomic_cmpxchg(&page->_count, count, 0) == count);
+	int ret = likely(atomic_cmpxchg(&page->_refcount, count, 0) == count);
 
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_freeze))
 		__page_ref_freeze(page, count, ret);
@@ -165,7 +165,7 @@ static inline void page_ref_unfreeze(str
 	VM_BUG_ON_PAGE(page_count(page) != 0, page);
 	VM_BUG_ON(count == 0);
 
-	atomic_set(&page->_count, count);
+	atomic_set(&page->_refcount, count);
 	if (page_ref_tracepoint_active(__tracepoint_page_ref_unfreeze))
 		__page_ref_unfreeze(page, count);
 }
diff -puN kernel/kexec_core.c~mm-rename-_count-field-of-the-struct-page-to-_refcount kernel/kexec_core.c
--- a/kernel/kexec_core.c~mm-rename-_count-field-of-the-struct-page-to-_refcount
+++ a/kernel/kexec_core.c
@@ -1410,7 +1410,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_STRUCT_SIZE(list_head);
 	VMCOREINFO_SIZE(nodemask_t);
 	VMCOREINFO_OFFSET(page, flags);
-	VMCOREINFO_OFFSET(page, _count);
+	VMCOREINFO_OFFSET(page, _refcount);
 	VMCOREINFO_OFFSET(page, mapping);
 	VMCOREINFO_OFFSET(page, lru);
 	VMCOREINFO_OFFSET(page, _mapcount);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount.patch

