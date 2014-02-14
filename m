From: akpm@linux-foundation.org
Subject: +
 dma-debug-account-for-cachelines-and-read-only-mappings-in-overlap-tracking-v2.patch added to -mm tree
Date: Thu, 13 Feb 2014 16:08:43 -0800
Message-ID: <52fd5e8b.FZMx3jBV9YXp7WbJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaBNAIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 19:08:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wei.liu2@citrix.com, romieu@fr.zoreil.com, linux@eikelenboom.it, konrad.wilk@oracle.com, eric.dumazet@gmail.com, davej@redhat.com, dan.j.williams@intel.com

Subject: + dma-debug-account-for-cachelines-and-read-only-mappings-in-overlap-tracking-v2.patch added to -mm tree
To: dan.j.williams@intel.com,davej@redhat.com,eric.dumazet@gmail.com,konrad.wilk@oracle.com,linux@eikelenboom.it,romieu@fr.zoreil.com,wei.liu2@citrix.com
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 16:08:43 -0800


The patch titled
     Subject: dma-debug-account-for-cachelines-and-read-only-mappings-in-overlap-tracking-v2
has been added to the -mm tree.  Its filename is
     dma-debug-account-for-cachelines-and-read-only-mappings-in-overlap-tracking-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-account-for-cachelines-and-read-only-mappings-in-overlap-tracking-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-debug-account-for-cachelines-and-read-only-mappings-in-overlap-tracking-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: dma-debug-account-for-cachelines-and-read-only-mappings-in-overlap-tracking-v2

Changes in v2:
1/ replaced 'cln' acronym with 'cacheline'. Now 'cln' is only a local
   variable name

2/ renamed 'to_cln()' to 'to_cacheline_number()'

3/ made the storage for a 'cacheline number' phys_addr_t since...
   "unsigned long cln = page_to_pfn(page) << CACHELINE_PER_PAGE_SHIFT;"
   ...may drop bits on some archs/memory-models.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Dave Jones <davej@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Wei Liu <wei.liu2@citrix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |   64 +++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-account-for-cachelines-and-read-only-mappings-in-overlap-tracking-v2 lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-account-for-cachelines-and-read-only-mappings-in-overlap-tracking-v2
+++ a/lib/dma-debug.c
@@ -448,17 +448,17 @@ EXPORT_SYMBOL(debug_dma_dump_mappings);
  */
 static RADIX_TREE(dma_active_cacheline, GFP_NOWAIT);
 static DEFINE_SPINLOCK(radix_lock);
-#define ACTIVE_CLN_MAX_OVERLAP ((1 << RADIX_TREE_MAX_TAGS) - 1)
+#define ACTIVE_CACHELINE_MAX_OVERLAP ((1 << RADIX_TREE_MAX_TAGS) - 1)
 #define CACHELINE_PER_PAGE_SHIFT (PAGE_SHIFT - L1_CACHE_SHIFT)
 #define CACHELINES_PER_PAGE (1 << CACHELINE_PER_PAGE_SHIFT)
 
-unsigned long to_cln(struct dma_debug_entry *entry)
+static phys_addr_t to_cacheline_number(struct dma_debug_entry *entry)
 {
 	return (entry->pfn << CACHELINE_PER_PAGE_SHIFT) +
 		(entry->offset >> L1_CACHE_SHIFT);
 }
 
-static int active_cln_read_overlap(unsigned long cln)
+static int active_cacheline_read_overlap(phys_addr_t cln)
 {
 	int overlap = 0, i;
 
@@ -468,11 +468,11 @@ static int active_cln_read_overlap(unsig
 	return overlap;
 }
 
-static int active_cln_set_overlap(unsigned long cln, int overlap)
+static int active_cacheline_set_overlap(phys_addr_t cln, int overlap)
 {
 	int i;
 
-	if (overlap > ACTIVE_CLN_MAX_OVERLAP || overlap < 0)
+	if (overlap > ACTIVE_CACHELINE_MAX_OVERLAP || overlap < 0)
 		return overlap;
 
 	for (i = RADIX_TREE_MAX_TAGS - 1; i >= 0; i--)
@@ -484,32 +484,33 @@ static int active_cln_set_overlap(unsign
 	return overlap;
 }
 
-static void active_cln_inc_overlap(unsigned long cln)
+static void active_cacheline_inc_overlap(phys_addr_t cln)
 {
-	int overlap = active_cln_read_overlap(cln);
+	int overlap = active_cacheline_read_overlap(cln);
 
-	overlap = active_cln_set_overlap(cln, ++overlap);
+	overlap = active_cacheline_set_overlap(cln, ++overlap);
 
 	/* If we overflowed the overlap counter then we're potentially
 	 * leaking dma-mappings.  Otherwise, if maps and unmaps are
 	 * balanced then this overflow may cause false negatives in
-	 * debug_dma_assert_idle() as the cln may be marked idle
+	 * debug_dma_assert_idle() as the cacheline may be marked idle
 	 * prematurely.
 	 */
-	WARN_ONCE(overlap > ACTIVE_CLN_MAX_OVERLAP,
-		  "DMA-API: exceeded %d overlapping mappings of cln %lx\n",
-		  ACTIVE_CLN_MAX_OVERLAP, cln);
+	WARN_ONCE(overlap > ACTIVE_CACHELINE_MAX_OVERLAP,
+		  "DMA-API: exceeded %d overlapping mappings of cacheline %pa\n",
+		  ACTIVE_CACHELINE_MAX_OVERLAP, &cln);
 }
 
-static int active_cln_dec_overlap(unsigned long cln)
+static int active_cacheline_dec_overlap(phys_addr_t cln)
 {
-	int overlap = active_cln_read_overlap(cln);
+	int overlap = active_cacheline_read_overlap(cln);
 
-	return active_cln_set_overlap(cln, --overlap);
+	return active_cacheline_set_overlap(cln, --overlap);
 }
 
-static int active_cln_insert(struct dma_debug_entry *entry)
+static int active_cacheline_insert(struct dma_debug_entry *entry)
 {
+	phys_addr_t cln = to_cacheline_number(entry);
 	unsigned long flags;
 	int rc;
 
@@ -521,16 +522,17 @@ static int active_cln_insert(struct dma_
 		return 0;
 
 	spin_lock_irqsave(&radix_lock, flags);
-	rc = radix_tree_insert(&dma_active_cacheline, to_cln(entry), entry);
+	rc = radix_tree_insert(&dma_active_cacheline, cln, entry);
 	if (rc == -EEXIST)
-		active_cln_inc_overlap(to_cln(entry));
+		active_cacheline_inc_overlap(cln);
 	spin_unlock_irqrestore(&radix_lock, flags);
 
 	return rc;
 }
 
-static void active_cln_remove(struct dma_debug_entry *entry)
+static void active_cacheline_remove(struct dma_debug_entry *entry)
 {
+	phys_addr_t cln = to_cacheline_number(entry);
 	unsigned long flags;
 
 	/* ...mirror the insert case */
@@ -540,10 +542,10 @@ static void active_cln_remove(struct dma
 	spin_lock_irqsave(&radix_lock, flags);
 	/* since we are counting overlaps the final put of the
 	 * cacheline will occur when the overlap count is 0.
-	 * active_cln_dec_overlap() returns -1 in that case
+	 * active_cacheline_dec_overlap() returns -1 in that case
 	 */
-	if (active_cln_dec_overlap(to_cln(entry)) < 0)
-		radix_tree_delete(&dma_active_cacheline, to_cln(entry));
+	if (active_cacheline_dec_overlap(cln) < 0)
+		radix_tree_delete(&dma_active_cacheline, cln);
 	spin_unlock_irqrestore(&radix_lock, flags);
 }
 
@@ -557,24 +559,27 @@ static void active_cln_remove(struct dma
  */
 void debug_dma_assert_idle(struct page *page)
 {
-	unsigned long cln = page_to_pfn(page) << CACHELINE_PER_PAGE_SHIFT;
 	static struct dma_debug_entry *ents[CACHELINES_PER_PAGE];
 	struct dma_debug_entry *entry = NULL;
 	void **results = (void **) &ents;
 	unsigned int nents, i;
 	unsigned long flags;
+	phys_addr_t cln;
 
 	if (!page)
 		return;
 
+	cln = (phys_addr_t) page_to_pfn(page) << CACHELINE_PER_PAGE_SHIFT;
 	spin_lock_irqsave(&radix_lock, flags);
 	nents = radix_tree_gang_lookup(&dma_active_cacheline, results, cln,
 				       CACHELINES_PER_PAGE);
 	for (i = 0; i < nents; i++) {
-		if (to_cln(ents[i]) == cln) {
+		phys_addr_t ent_cln = to_cacheline_number(ents[i]);
+
+		if (ent_cln == cln) {
 			entry = ents[i];
 			break;
-		} else if (to_cln(ents[i]) >= cln + CACHELINES_PER_PAGE)
+		} else if (ent_cln >= cln + CACHELINES_PER_PAGE)
 			break;
 	}
 	spin_unlock_irqrestore(&radix_lock, flags);
@@ -582,9 +587,10 @@ void debug_dma_assert_idle(struct page *
 	if (!entry)
 		return;
 
+	cln = to_cacheline_number(entry);
 	err_printk(entry->dev, entry,
-		   "DMA-API: cpu touching an active dma mapped page [cln=0x%lx]\n",
-		   to_cln(entry));
+		   "DMA-API: cpu touching an active dma mapped cacheline [cln=%pa]\n",
+		   &cln);
 }
 
 /*
@@ -601,7 +607,7 @@ static void add_dma_entry(struct dma_deb
 	hash_bucket_add(bucket, entry);
 	put_hash_bucket(bucket, &flags);
 
-	rc = active_cln_insert(entry);
+	rc = active_cacheline_insert(entry);
 	if (rc == -ENOMEM) {
 		pr_err("DMA-API: cacheline tracking ENOMEM, dma-debug disabled\n");
 		global_disable = true;
@@ -664,7 +670,7 @@ static void dma_entry_free(struct dma_de
 {
 	unsigned long flags;
 
-	active_cln_remove(entry);
+	active_cacheline_remove(entry);
 
 	/*
 	 * add to beginning of the list - this way the entries are
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dma-debug-account-for-cachelines-and-read-only-mappings-in-overlap-tracking.patch
dma-debug-account-for-cachelines-and-read-only-mappings-in-overlap-tracking-v2.patch
linux-next.patch

