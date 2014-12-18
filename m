From: akpm@linux-foundation.org
Subject: +
 mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
 added to -mm tree
Date: Thu, 18 Dec 2014 14:47:24 -0800
Message-ID: <5493597c.VrrXoSOZ/Y6tRH89%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaLRWrZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 17:47:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, cl@linux.com, hannes@cmpxchg.org, jmarchan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add fields for compound destructor and order into struct page
has been added to the -mm tree.  Its filename is
     mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch

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
Subject: mm: add fields for compound destructor and order into struct page

Currently, we use lru.next/lru.prev plus cast to access or set
destructor and order of compound page.

Let's replace it with explicit fields in struct page.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |    9 ++++-----
 include/linux/mm_types.h |    8 ++++++++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff -puN include/linux/mm.h~mm-add-fields-for-compound-destructor-and-order-into-struct-page include/linux/mm.h
--- a/include/linux/mm.h~mm-add-fields-for-compound-destructor-and-order-into-struct-page
+++ a/include/linux/mm.h
@@ -603,29 +603,28 @@ int split_free_page(struct page *page);
  * prototype for that function and accessor functions.
  * These are _only_ valid on the head of a PG_compound page.
  */
-typedef void compound_page_dtor(struct page *);
 
 static inline void set_compound_page_dtor(struct page *page,
 						compound_page_dtor *dtor)
 {
-	page[1].lru.next = (void *)dtor;
+	page[1].compound_dtor = dtor;
 }
 
 static inline compound_page_dtor *get_compound_page_dtor(struct page *page)
 {
-	return (compound_page_dtor *)page[1].lru.next;
+	return page[1].compound_dtor;
 }
 
 static inline int compound_order(struct page *page)
 {
 	if (!PageHead(page))
 		return 0;
-	return (unsigned long)page[1].lru.prev;
+	return page[1].compound_order;
 }
 
 static inline void set_compound_order(struct page *page, unsigned long order)
 {
-	page[1].lru.prev = (void *)order;
+	page[1].compound_order = order;
 }
 
 #ifdef CONFIG_MMU
diff -puN include/linux/mm_types.h~mm-add-fields-for-compound-destructor-and-order-into-struct-page include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-add-fields-for-compound-destructor-and-order-into-struct-page
+++ a/include/linux/mm_types.h
@@ -28,6 +28,8 @@ struct mem_cgroup;
 		IS_ENABLED(CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK))
 #define ALLOC_SPLIT_PTLOCKS	(SPINLOCK_SIZE > BITS_PER_LONG/8)
 
+typedef void compound_page_dtor(struct page *);
+
 /*
  * Each physical page in the system has a struct page associated with
  * it to keep track of whatever it is we are using the page for at the
@@ -142,6 +144,12 @@ struct page {
 		struct rcu_head rcu_head;	/* Used by SLAB
 						 * when destroying via RCU
 						 */
+		/* First tail page of compound page */
+		struct {
+			compound_page_dtor *compound_dtor;
+			unsigned long compound_order;
+		};
+
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
 		pgtable_t pmd_huge_pte; /* protected by page->ptl */
 #endif
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-protect-set_page_dirty-from-ongoing-truncation.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch

