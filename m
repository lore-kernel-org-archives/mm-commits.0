From: akpm@linux-foundation.org
Subject: + mm-make-hashed_page_virtual-page_address-struct-page-argument-const.patch added to -mm tree
Date: Wed, 17 Aug 2011 12:22:54 -0700
Message-ID: <201108171922.p7HJMsce022828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534Ab1HQTXz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Aug 2011 15:23:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ian.campbell@citrix.com, aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, walken@google.com


The patch titled
     mm: make HASHED_PAGE_VIRTUAL page_address' struct page argument const
has been added to the -mm tree.  Its filename is
     mm-make-hashed_page_virtual-page_address-struct-page-argument-const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

mm-make-hashed_page_virtual-page_address-struct-page-argument-const.patch
mm-fix-__page_to_pfn-for-a-const-struct-page-argument.patch

