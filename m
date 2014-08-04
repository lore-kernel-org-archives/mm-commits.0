From: akpm@linux-foundation.org
Subject: + mm-highmem-make-kmap-cache-coloring-aware.patch added to -mm
 tree
Date: Mon, 04 Aug 2014 16:05:01 -0700
Message-ID: <53e0119d.YUBa4/1hhxKBcNcb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:50544 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaHDXFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2014 19:05:03 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so30734obb.2
        for <mm-commits@vger.kernel.org>; Mon, 04 Aug 2014 16:05:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jcmvbkbc@gmail.com, Leonid.Yegoshin@imgtec.com, Steven.Hill@imgtec.com, chris@zankel.net, marc@cadence.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: make kmap cache coloring aware
has been added to the -mm tree.  Its filename is
     mm-highmem-make-kmap-cache-coloring-aware.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-highmem-make-kmap-cache-coloring-aware.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-highmem-make-kmap-cache-coloring-aware.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Max Filippov <jcmvbkbc@gmail.com>
Subject: mm/highmem: make kmap cache coloring aware

User-visible effect:
Architectures that choose this method of maintaining cache coherency
(MIPS and xtensa currently) are able to use high memory on cores with
aliasing data cache. Without this fix such architectures can not use
high memory (in case of xtensa it means that at most 128 MBytes of
physical memory is available).

The problem:
VIPT cache with way size larger than MMU page size may suffer from
aliasing problem: a single physical address accessed via different
virtual addresses may end up in multiple locations in the cache.
Virtual mappings of a physical address that always get cached in
L1 caching hardware usually doesn't handle this situation leaving it
up to software. Software must avoid this situation as it leads to
data corruption.

What can be done:
One way to handle this is to flush and invalidate data cache every time
page mapping changes color. The other way is to always map physical page
at a virtual address with the same color. Low memory pages already have
this property. Giving architecture a way to control color of high memory
page mapping allows reusing of existing low memory cache alias handling
code.

How this is done with this patch:
Provide hooks that allow architectures with aliasing cache to align
mapping address of high pages according to their color. Such architectures
may enforce similar coloring of low- and high-memory page mappings and
reuse existing cache management functions to support highmem.

This code is based on the implementation of similar feature for MIPS by
Leonid Yegoshin.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Marc Gauthier <marc@cadence.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Steven Hill <Steven.Hill@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |   86 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 75 insertions(+), 11 deletions(-)

diff -puN mm/highmem.c~mm-highmem-make-kmap-cache-coloring-aware mm/highmem.c
--- a/mm/highmem.c~mm-highmem-make-kmap-cache-coloring-aware
+++ a/mm/highmem.c
@@ -44,6 +44,66 @@ DEFINE_PER_CPU(int, __kmap_atomic_idx);
  */
 #ifdef CONFIG_HIGHMEM
 
+/*
+ * Architecture with aliasing data cache may define the following family of
+ * helper functions in its asm/highmem.h to control cache color of virtual
+ * addresses where physical memory pages are mapped by kmap.
+ */
+#ifndef get_pkmap_color
+
+/*
+ * Determine color of virtual address where the page should be mapped.
+ */
+static inline unsigned int get_pkmap_color(struct page *page)
+{
+	return 0;
+}
+#define get_pkmap_color get_pkmap_color
+
+/*
+ * Get next index for mapping inside PKMAP region for page with given color.
+ */
+static inline unsigned int get_next_pkmap_nr(unsigned int color)
+{
+	static unsigned int last_pkmap_nr;
+
+	last_pkmap_nr = (last_pkmap_nr + 1) & LAST_PKMAP_MASK;
+	return last_pkmap_nr;
+}
+
+/*
+ * Determine if page index inside PKMAP region (pkmap_nr) of given color
+ * has wrapped around PKMAP region end. When this happens an attempt to
+ * flush all unused PKMAP slots is made.
+ */
+static inline int no_more_pkmaps(unsigned int pkmap_nr, unsigned int color)
+{
+	return pkmap_nr == 0;
+}
+
+/*
+ * Get the number of PKMAP entries of the given color. If no free slot is
+ * found after checking that many entries, kmap will sleep waiting for
+ * someone to call kunmap and free PKMAP slot.
+ */
+static inline int get_pkmap_entries_count(unsigned int color)
+{
+	return LAST_PKMAP;
+}
+
+/*
+ * Get head of a wait queue for PKMAP entries of the given color.
+ * Wait queues for different mapping colors should be independent to avoid
+ * unnecessary wakeups caused by freeing of slots of other colors.
+ */
+static inline wait_queue_head_t *get_pkmap_wait_queue_head(unsigned int color)
+{
+	static DECLARE_WAIT_QUEUE_HEAD(pkmap_map_wait);
+
+	return &pkmap_map_wait;
+}
+#endif
+
 unsigned long totalhigh_pages __read_mostly;
 EXPORT_SYMBOL(totalhigh_pages);
 
@@ -68,13 +128,10 @@ unsigned int nr_free_highpages (void)
 }
 
 static int pkmap_count[LAST_PKMAP];
-static unsigned int last_pkmap_nr;
 static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kmap_lock);
 
 pte_t * pkmap_page_table;
 
-static DECLARE_WAIT_QUEUE_HEAD(pkmap_map_wait);
-
 /*
  * Most architectures have no use for kmap_high_get(), so let's abstract
  * the disabling of IRQ out of the locking in that case to save on a
@@ -161,15 +218,17 @@ static inline unsigned long map_new_virt
 {
 	unsigned long vaddr;
 	int count;
+	unsigned int last_pkmap_nr;
+	unsigned int color = get_pkmap_color(page);
 
 start:
-	count = LAST_PKMAP;
+	count = get_pkmap_entries_count(color);
 	/* Find an empty entry */
 	for (;;) {
-		last_pkmap_nr = (last_pkmap_nr + 1) & LAST_PKMAP_MASK;
-		if (!last_pkmap_nr) {
+		last_pkmap_nr = get_next_pkmap_nr(color);
+		if (no_more_pkmaps(last_pkmap_nr, color)) {
 			flush_all_zero_pkmaps();
-			count = LAST_PKMAP;
+			count = get_pkmap_entries_count(color);
 		}
 		if (!pkmap_count[last_pkmap_nr])
 			break;	/* Found a usable entry */
@@ -181,12 +240,14 @@ start:
 		 */
 		{
 			DECLARE_WAITQUEUE(wait, current);
+			wait_queue_head_t *pkmap_map_wait =
+				get_pkmap_wait_queue_head(color);
 
 			__set_current_state(TASK_UNINTERRUPTIBLE);
-			add_wait_queue(&pkmap_map_wait, &wait);
+			add_wait_queue(pkmap_map_wait, &wait);
 			unlock_kmap();
 			schedule();
-			remove_wait_queue(&pkmap_map_wait, &wait);
+			remove_wait_queue(pkmap_map_wait, &wait);
 			lock_kmap();
 
 			/* Somebody else might have mapped it while we slept */
@@ -274,6 +335,8 @@ void kunmap_high(struct page *page)
 	unsigned long nr;
 	unsigned long flags;
 	int need_wakeup;
+	unsigned int color = get_pkmap_color(page);
+	wait_queue_head_t *pkmap_map_wait;
 
 	lock_kmap_any(flags);
 	vaddr = (unsigned long)page_address(page);
@@ -299,13 +362,14 @@ void kunmap_high(struct page *page)
 		 * no need for the wait-queue-head's lock.  Simply
 		 * test if the queue is empty.
 		 */
-		need_wakeup = waitqueue_active(&pkmap_map_wait);
+		pkmap_map_wait = get_pkmap_wait_queue_head(color);
+		need_wakeup = waitqueue_active(pkmap_map_wait);
 	}
 	unlock_kmap_any(flags);
 
 	/* do wake-up, if needed, race-free outside of the spin lock */
 	if (need_wakeup)
-		wake_up(&pkmap_map_wait);
+		wake_up(pkmap_map_wait);
 }
 
 EXPORT_SYMBOL(kunmap_high);
_

Patches currently in -mm which might be from jcmvbkbc@gmail.com are

mm-highmem-make-kmap-cache-coloring-aware.patch
linux-next.patch

