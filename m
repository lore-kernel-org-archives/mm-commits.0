From: akpm@linux-foundation.org
Subject: + mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch added to -mm tree
Date: Mon, 01 Aug 2011 15:54:32 -0700
Message-ID: <201108012254.p71MsW9f019450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829Ab1HAWyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2011 18:54:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, fengguang.wu@intel.com, mgorman@suse.de, mhocko@suse.cz


The patch titled
     mm/page-writeback.c: make determine_dirtyable_memory static again
has been added to the -mm tree.  Its filename is
     mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch

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
Subject: mm/page-writeback.c: make determine_dirtyable_memory static again
From: Johannes Weiner <hannes@cmpxchg.org>

The tracing ring-buffer used this function briefly, but not anymore.
Make it local to the writeback code again.

Also, move the function so that no forward declaration needs to be
reintroduced.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    2 
 mm/page-writeback.c       |  122 +++++++++++++++++-------------------
 2 files changed, 60 insertions(+), 64 deletions(-)

diff -puN include/linux/writeback.h~mm-page-writebackc-make-determine_dirtyable_memory-static-again include/linux/writeback.h
--- a/include/linux/writeback.h~mm-page-writebackc-make-determine_dirtyable_memory-static-again
+++ a/include/linux/writeback.h
@@ -129,8 +129,6 @@ extern int vm_highmem_is_dirtyable;
 extern int block_dump;
 extern int laptop_mode;
 
-extern unsigned long determine_dirtyable_memory(void);
-
 extern int dirty_background_ratio_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
diff -puN mm/page-writeback.c~mm-page-writebackc-make-determine_dirtyable_memory-static-again mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writebackc-make-determine_dirtyable_memory-static-again
+++ a/mm/page-writeback.c
@@ -143,6 +143,66 @@ static struct prop_descriptor vm_complet
 static struct prop_descriptor vm_dirties;
 
 /*
+ * Work out the current dirty-memory clamping and background writeout
+ * thresholds.
+ *
+ * The main aim here is to lower them aggressively if there is a lot of mapped
+ * memory around.  To avoid stressing page reclaim with lots of unreclaimable
+ * pages.  It is better to clamp down on writers than to start swapping, and
+ * performing lots of scanning.
+ *
+ * We only allow 1/2 of the currently-unmapped memory to be dirtied.
+ *
+ * We don't permit the clamping level to fall below 5% - that is getting rather
+ * excessive.
+ *
+ * We make sure that the background writeout level is below the adjusted
+ * clamping level.
+ */
+static unsigned long highmem_dirtyable_memory(unsigned long total)
+{
+#ifdef CONFIG_HIGHMEM
+	int node;
+	unsigned long x = 0;
+
+	for_each_node_state(node, N_HIGH_MEMORY) {
+		struct zone *z =
+			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
+
+		x += zone_page_state(z, NR_FREE_PAGES) +
+		     zone_reclaimable_pages(z);
+	}
+	/*
+	 * Make sure that the number of highmem pages is never larger
+	 * than the number of the total dirtyable memory. This can only
+	 * occur in very strange VM situations but we want to make sure
+	 * that this does not occur.
+	 */
+	return min(x, total);
+#else
+	return 0;
+#endif
+}
+
+/**
+ * determine_dirtyable_memory - amount of memory that may be used
+ *
+ * Returns the numebr of pages that can currently be freed and used
+ * by the kernel for direct mappings.
+ */
+static unsigned long determine_dirtyable_memory(void)
+{
+	unsigned long x;
+
+	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
+
+	if (!vm_highmem_is_dirtyable)
+		x -= highmem_dirtyable_memory(x);
+
+	return x + 1;	/* Ensure that we never return 0 */
+}
+
+/*
  * couple the period to the dirty_ratio:
  *
  *   period/2 ~ roundup_pow_of_two(dirty limit)
@@ -208,7 +268,6 @@ int dirty_ratio_handler(struct ctl_table
 	return ret;
 }
 
-
 int dirty_bytes_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
@@ -350,67 +409,6 @@ int bdi_set_max_ratio(struct backing_dev
 }
 EXPORT_SYMBOL(bdi_set_max_ratio);
 
-/*
- * Work out the current dirty-memory clamping and background writeout
- * thresholds.
- *
- * The main aim here is to lower them aggressively if there is a lot of mapped
- * memory around.  To avoid stressing page reclaim with lots of unreclaimable
- * pages.  It is better to clamp down on writers than to start swapping, and
- * performing lots of scanning.
- *
- * We only allow 1/2 of the currently-unmapped memory to be dirtied.
- *
- * We don't permit the clamping level to fall below 5% - that is getting rather
- * excessive.
- *
- * We make sure that the background writeout level is below the adjusted
- * clamping level.
- */
-
-static unsigned long highmem_dirtyable_memory(unsigned long total)
-{
-#ifdef CONFIG_HIGHMEM
-	int node;
-	unsigned long x = 0;
-
-	for_each_node_state(node, N_HIGH_MEMORY) {
-		struct zone *z =
-			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
-
-		x += zone_page_state(z, NR_FREE_PAGES) +
-		     zone_reclaimable_pages(z);
-	}
-	/*
-	 * Make sure that the number of highmem pages is never larger
-	 * than the number of the total dirtyable memory. This can only
-	 * occur in very strange VM situations but we want to make sure
-	 * that this does not occur.
-	 */
-	return min(x, total);
-#else
-	return 0;
-#endif
-}
-
-/**
- * determine_dirtyable_memory - amount of memory that may be used
- *
- * Returns the numebr of pages that can currently be freed and used
- * by the kernel for direct mappings.
- */
-unsigned long determine_dirtyable_memory(void)
-{
-	unsigned long x;
-
-	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
-
-	if (!vm_highmem_is_dirtyable)
-		x -= highmem_dirtyable_memory(x);
-
-	return x + 1;	/* Ensure that we never return 0 */
-}
