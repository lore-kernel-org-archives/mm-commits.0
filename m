From: akpm@linux-foundation.org
Subject: [merged] mm-make-hashed_page_virtual-page_address-struct-page-argument-const.patch removed from -mm tree
Date: Thu, 18 Aug 2011 14:08:12 -0700
Message-ID: <201108182105.p7IL5IZn027625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753802Ab1HRVGR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Aug 2011 17:06:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ian.campbell@citrix.com, aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: make HASHED_PAGE_VIRTUAL page_address' struct page argument const
has been removed from the -mm tree.  Its filename was
     mm-make-hashed_page_virtual-page_address-struct-page-argument-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make HASHED_PAGE_VIRTUAL page_address' struct page argument const
From: Ian Campbell <ian.campbell@citrix.com>

Followup to 33dd4e0ec911 ("mm: make some struct page's const") which
missed the HASHED_PAGE_VIRTUAL case.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hash.h |    2 +-
 include/linux/mm.h   |    2 +-
 mm/highmem.c         |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/hash.h~mm-make-hashed_page_virtual-page_address-struct-page-argument-const include/linux/hash.h
--- a/include/linux/hash.h~mm-make-hashed_page_virtual-page_address-struct-page-argument-const
+++ a/include/linux/hash.h
@@ -63,7 +63,7 @@ static inline u32 hash_32(u32 val, unsig
 	return hash >> (32 - bits);
 }
 
-static inline unsigned long hash_ptr(void *ptr, unsigned int bits)
+static inline unsigned long hash_ptr(const void *ptr, unsigned int bits)
 {
 	return hash_long((unsigned long)ptr, bits);
 }
diff -puN include/linux/mm.h~mm-make-hashed_page_virtual-page_address-struct-page-argument-const include/linux/mm.h
--- a/include/linux/mm.h~mm-make-hashed_page_virtual-page_address-struct-page-argument-const
+++ a/include/linux/mm.h
@@ -737,7 +737,7 @@ static __always_inline void *lowmem_page
 #endif
 
 #if defined(HASHED_PAGE_VIRTUAL)
-void *page_address(struct page *page);
+void *page_address(const struct page *page);
 void set_page_address(struct page *page, void *virtual);
 void page_address_init(void);
 #endif
diff -puN mm/highmem.c~mm-make-hashed_page_virtual-page_address-struct-page-argument-const mm/highmem.c
--- a/mm/highmem.c~mm-make-hashed_page_virtual-page_address-struct-page-argument-const
+++ a/mm/highmem.c
@@ -326,7 +326,7 @@ static struct page_address_slot {
 	spinlock_t lock;			/* Protect this bucket's list */
 } ____cacheline_aligned_in_smp page_address_htable[1<<PA_HASH_ORDER];
 
-static struct page_address_slot *page_slot(struct page *page)
+static struct page_address_slot *page_slot(const struct page *page)
 {
 	return &page_address_htable[hash_ptr(page, PA_HASH_ORDER)];
 }
@@ -337,7 +337,7 @@ static struct page_address_slot *page_sl
  *
  * Returns the page's virtual address.
  */
-void *page_address(struct page *page)
+void *page_address(const struct page *page)
 {
 	unsigned long flags;
 	void *ret;
_

Patches currently in -mm which might be from ian.campbell@citrix.com are

origin.patch

