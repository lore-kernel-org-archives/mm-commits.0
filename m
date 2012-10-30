From: akpm@linux-foundation.org
Subject: + mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry.patch added to -mm tree
Date: Tue, 30 Oct 2012 14:39:16 -0700
Message-ID: <20121030213916.AEF4C1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:61818 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab2J3VjR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 17:39:17 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so86253qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 14:39:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: js1304@gmail.com, a.p.zijlstra@chello.nl, mel@csn.ul.ie, minchan@kernel.org


The patch titled
     Subject: mm, highmem: makes flush_all_zero_pkmaps() return index of last flushed entry
has been added to the -mm tree.  Its filename is
     mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry.patch

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
Subject: mm, highmem: makes flush_all_zero_pkmaps() return index of last flushed entry

In current code, after flush_all_zero_pkmaps() is invoked we re-iterate
all pkmaps.  This can be optimized if flush_all_zero_pkmaps() returns an
index of flushed entry.  With this index, we can immediately map highmem
page to virtual address represented by index.  So change return type of
flush_all_zero_pkmaps() and return index of last flushed entry.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    1 
 mm/highmem.c            |   68 +++++++++++++++++++++-----------------
 2 files changed, 39 insertions(+), 30 deletions(-)

diff -puN include/linux/highmem.h~mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry include/linux/highmem.h
--- a/include/linux/highmem.h~mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry
+++ a/include/linux/highmem.h
@@ -32,6 +32,7 @@ static inline void invalidate_kernel_vma
 
 #ifdef CONFIG_HIGHMEM
 #include <asm/highmem.h>
+#define PKMAP_INDEX_INVAL (-1)
 
 /* declarations for linux/mm/highmem.c */
 unsigned int nr_free_highpages(void);
diff -puN mm/highmem.c~mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry mm/highmem.c
--- a/mm/highmem.c~mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry
+++ a/mm/highmem.c
@@ -107,10 +107,10 @@ struct page *kmap_to_page(void *vaddr)
 }
 EXPORT_SYMBOL(kmap_to_page);
 
-static void flush_all_zero_pkmaps(void)
+static int flush_all_zero_pkmaps(void)
 {
 	int i;
-	int need_flush = 0;
+	int index = PKMAP_INDEX_INVAL;
 
 	flush_cache_kmaps();
 
@@ -142,10 +142,12 @@ static void flush_all_zero_pkmaps(void)
 			  &pkmap_page_table[i]);
 
 		set_page_address(page, NULL);
-		need_flush = 1;
+		index = i;
 	}
-	if (need_flush)
+	if (index != PKMAP_INDEX_INVAL)
 		flush_tlb_kernel_range(PKMAP_ADDR(0), PKMAP_ADDR(LAST_PKMAP));
+
+	return index;
 }
 
 /**
@@ -161,6 +163,7 @@ void kmap_flush_unused(void)
 static inline unsigned long map_new_virtual(struct page *page)
 {
 	unsigned long vaddr;
+	int index = PKMAP_INDEX_INVAL;
 	int count;
 
 start:
@@ -169,40 +172,45 @@ start:
 	for (;;) {
 		last_pkmap_nr = (last_pkmap_nr + 1) & LAST_PKMAP_MASK;
 		if (!last_pkmap_nr) {
-			flush_all_zero_pkmaps();
-			count = LAST_PKMAP;
+			index = flush_all_zero_pkmaps();
+			if (index != PKMAP_INDEX_INVAL)
+				break; /* Found a usable entry */
 		}
-		if (!pkmap_count[last_pkmap_nr])
+		if (!pkmap_count[last_pkmap_nr]) {
+			index = last_pkmap_nr;
 			break;	/* Found a usable entry */
-		if (--count)
-			continue;
+		}
+		if (--count == 0)
+			break;
+	}
 
-		/*
-		 * Sleep for somebody else to unmap their entries
-		 */
-		{
-			DECLARE_WAITQUEUE(wait, current);
+	/*
+	 * Sleep for somebody else to unmap their entries
+	 */
+	if (index == PKMAP_INDEX_INVAL) {
+		DECLARE_WAITQUEUE(wait, current);
 
-			__set_current_state(TASK_UNINTERRUPTIBLE);
-			add_wait_queue(&pkmap_map_wait, &wait);
-			unlock_kmap();
-			schedule();
-			remove_wait_queue(&pkmap_map_wait, &wait);
-			lock_kmap();
-
-			/* Somebody else might have mapped it while we slept */
-			if (page_address(page))
-				return (unsigned long)page_address(page);
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		add_wait_queue(&pkmap_map_wait, &wait);
+		unlock_kmap();
+		schedule();
+		remove_wait_queue(&pkmap_map_wait, &wait);
+		lock_kmap();
+
+		/* Somebody else might have mapped it while we slept */
+		vaddr = (unsigned long)page_address(page);
+		if (vaddr)
+			return vaddr;
 
-			/* Re-start */
-			goto start;
-		}
+		/* Re-start */
+		goto start;
 	}
-	vaddr = PKMAP_ADDR(last_pkmap_nr);
+
+	vaddr = PKMAP_ADDR(index);
 	set_pte_at(&init_mm, vaddr,
-		   &(pkmap_page_table[last_pkmap_nr]), mk_pte(page, kmap_prot));
+		   &(pkmap_page_table[index]), mk_pte(page, kmap_prot));
 
-	pkmap_count[last_pkmap_nr] = 1;
+	pkmap_count[index] = 1;
 	set_page_address(page, (void *)vaddr);
 
 	return vaddr;
_

Patches currently in -mm which might be from js1304@gmail.com are

linux-next.patch
mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap.patch
mm-highmem-remove-useless-pool_lock.patch
mm-highmem-remove-page_address_pool-list.patch
mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry.patch
mm-highmem-get-virtual-address-of-the-page-using-pkmap_addr.patch

