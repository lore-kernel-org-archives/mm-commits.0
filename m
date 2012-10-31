From: akpm@linux-foundation.org
Subject: + mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2.patch added to -mm tree
Date: Wed, 31 Oct 2012 16:50:17 -0700
Message-ID: <20121031235018.2D0C5100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:34854 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab2JaXuT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 31 Oct 2012 19:50:19 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so230137qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 31 Oct 2012 16:50:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: js1304@gmail.com, a.p.zijlstra@chello.nl, mel@csn.ul.ie, minchan@kernel.org


The patch titled
     Subject: mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2
has been added to the -mm tree.  Its filename is
     mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2

In current code, after flush_all_zero_pkmaps() is invoked,
then re-iterate all pkmaps. It can be optimized if flush_all_zero_pkmaps()
return index of first flushed entry. With this index,
we can immediately map highmem page to virtual address represented by index.
So change return type of flush_all_zero_pkmaps()
and return index of first flushed entry.

Additionally, update last_pkmap_nr to this index.
It is certain that entry which is below this index is occupied by other mapping,
therefore updating last_pkmap_nr to this index is reasonable optimization.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 +-
 mm/highmem.c            |   24 +++++++++++++++---------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff -puN include/linux/highmem.h~mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2 include/linux/highmem.h
--- a/include/linux/highmem.h~mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2
+++ a/include/linux/highmem.h
@@ -32,7 +32,7 @@ static inline void invalidate_kernel_vma
 
 #ifdef CONFIG_HIGHMEM
 #include <asm/highmem.h>
-#define PKMAP_INDEX_INVAL (-1)
+#define PKMAP_INVALID_INDEX (LAST_PKMAP)
 
 /* declarations for linux/mm/highmem.c */
 unsigned int nr_free_highpages(void);
diff -puN mm/highmem.c~mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2 mm/highmem.c
--- a/mm/highmem.c~mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2
+++ a/mm/highmem.c
@@ -107,10 +107,10 @@ struct page *kmap_to_page(void *vaddr)
 }
 EXPORT_SYMBOL(kmap_to_page);
 
-static int flush_all_zero_pkmaps(void)
+static unsigned int flush_all_zero_pkmaps(void)
 {
 	int i;
-	int index = PKMAP_INDEX_INVAL;
+	unsigned int index = PKMAP_INVALID_INDEX;
 
 	flush_cache_kmaps();
 
@@ -142,9 +142,10 @@ static int flush_all_zero_pkmaps(void)
 			  &pkmap_page_table[i]);
 
 		set_page_address(page, NULL);
-		index = i;
+		if (index == PKMAP_INVALID_INDEX)
+			index = i;
 	}
-	if (index != PKMAP_INDEX_INVAL)
+	if (index != PKMAP_INVALID_INDEX)
 		flush_tlb_kernel_range(PKMAP_ADDR(0), PKMAP_ADDR(LAST_PKMAP));
 
 	return index;
@@ -155,15 +156,19 @@ static int flush_all_zero_pkmaps(void)
  */
 void kmap_flush_unused(void)
 {
+	unsigned int index;
+
 	lock_kmap();
-	flush_all_zero_pkmaps();
+	index = flush_all_zero_pkmaps();
+	if (index != PKMAP_INVALID_INDEX && (index < last_pkmap_nr))
+		last_pkmap_nr = index;
 	unlock_kmap();
 }
 
 static inline unsigned long map_new_virtual(struct page *page)
 {
 	unsigned long vaddr;
-	int index = PKMAP_INDEX_INVAL;
+	unsigned int index = PKMAP_INVALID_INDEX;
 	int count;
 
 start:
@@ -173,8 +178,7 @@ start:
 		last_pkmap_nr = (last_pkmap_nr + 1) & LAST_PKMAP_MASK;
 		if (!last_pkmap_nr) {
 			index = flush_all_zero_pkmaps();
-			if (index != PKMAP_INDEX_INVAL)
-				break; /* Found a usable entry */
+			break;
 		}
 		if (!pkmap_count[last_pkmap_nr]) {
 			index = last_pkmap_nr;
@@ -187,7 +191,7 @@ start:
 	/*
 	 * Sleep for somebody else to unmap their entries
 	 */
-	if (index == PKMAP_INDEX_INVAL) {
+	if (index == PKMAP_INVALID_INDEX) {
 		DECLARE_WAITQUEUE(wait, current);
 
 		__set_current_state(TASK_UNINTERRUPTIBLE);
@@ -211,6 +215,7 @@ start:
 		   &(pkmap_page_table[index]), mk_pte(page, kmap_prot));
 
 	pkmap_count[index] = 1;
+	last_pkmap_nr = index;
 	set_page_address(page, (void *)vaddr);
 
 	return vaddr;
@@ -332,6 +337,7 @@ struct page_address_map {
 	void *virtual;
 	struct list_head list;
 };
+
 static struct page_address_map page_address_maps[LAST_PKMAP];
 
 /*
_

Patches currently in -mm which might be from js1304@gmail.com are

linux-next.patch
mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap.patch
mm-highmem-remove-useless-pool_lock.patch
mm-highmem-remove-page_address_pool-list.patch
mm-highmem-remove-page_address_pool-list-v2.patch
mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry.patch
mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry-v2.patch
mm-highmem-get-virtual-address-of-the-page-using-pkmap_addr.patch

