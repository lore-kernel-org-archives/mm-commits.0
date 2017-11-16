From: akpm@linux-foundation.org
Subject: [patch 081/131] mm: deferred_init_memmap improvements
Date: Wed, 15 Nov 2017 17:36:09 -0800
Message-ID: <20171116013609.ixtfx4rFT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39776 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933615AbdKPBgM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:36:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, bob.picco@oracle.com, borntraeger@de.ibm.com, catalin.marinas@arm.com, daniel.m.jordan@oracle.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, heiko.carstens@de.ibm.com, hpa@zytor.com, mark.rutland@arm.com, mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org, pasha.tatashin@oracle.com, sam@ravnborg.org, steven.sistare@oracle.com, tglx@linutronix.de, torvalds@linux-foundation.org, will.deacon@arm.com, willy@infradead.org

From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm: deferred_init_memmap improvements

Patch series "complete deferred page initialization", v12.

SMP machines can benefit from the DEFERRED_STRUCT_PAGE_INIT config option,
which defers initializing struct pages until all cpus have been started so
it can be done in parallel.

However, this feature is sub-optimal, because the deferred page
initialization code expects that the struct pages have already been
zeroed, and the zeroing is done early in boot with a single thread only. 
Also, we access that memory and set flags before struct pages are
initialized.  All of this is fixed in this patchset.

In this work we do the following:
- Never read access struct page until it was initialized
- Never set any fields in struct pages before they are initialized
- Zero struct page at the beginning of struct page initialization


==========================================================================
Performance improvements on x86 machine with 8 nodes:
Intel(R) Xeon(R) CPU E7-8895 v3 @ 2.60GHz and 1T of memory:
                        TIME          SPEED UP
base no deferred:       95.796233s
fix no deferred:        79.978956s    19.77%

base deferred:          77.254713s
fix deferred:           55.050509s    40.34%
==========================================================================
SPARC M6 3600 MHz with 15T of memory
                        TIME          SPEED UP
base no deferred:       358.335727s
fix no deferred:        302.320936s   18.52%

base deferred:          237.534603s
fix deferred:           182.103003s   30.44%
==========================================================================
Raw dmesg output with timestamps:
x86 base no deferred:    https://hastebin.com/ofunepurit.scala
x86 base deferred:       https://hastebin.com/ifazegeyas.scala
x86 fix no deferred:     https://hastebin.com/pegocohevo.scala
x86 fix deferred:        https://hastebin.com/ofupevikuk.scala
sparc base no deferred:  https://hastebin.com/ibobeteken.go
sparc base deferred:     https://hastebin.com/fariqimiyu.go
sparc fix no deferred:   https://hastebin.com/muhegoheyi.go
sparc fix deferred:      https://hastebin.com/xadinobutu.go



This patch (of 11):

deferred_init_memmap() is called when struct pages are initialized later
in boot by slave CPUs.  This patch simplifies and optimizes this function,
and also fixes a couple issues (described below).

The main change is that now we are iterating through free memblock areas
instead of all configured memory.  Thus, we do not have to check if the
struct page has already been initialized.

=====
In deferred_init_memmap() where all deferred struct pages are initialized
we have a check like this:

if (page->flags) {
	VM_BUG_ON(page_zone(page) != zone);
	goto free_range;
}

This way we are checking if the current deferred page has already been
initialized.  It works, because memory for struct pages has been zeroed,
and the only way flags are not zero if it went through
__init_single_page() before.  But, once we change the current behavior and
won't zero the memory in memblock allocator, we cannot trust anything
inside "struct page"es until they are initialized.  This patch fixes this.

The deferred_init_memmap() is re-written to loop through only free memory
ranges provided by memblock.

Note, this first issue is relevant only when the following change is
merged:

=====
This patch fixes another existing issue on systems that have holes in
zones i.e CONFIG_HOLES_IN_ZONE is defined.

In for_each_mem_pfn_range() we have code like this:

if (!pfn_valid_within(pfn)
	goto free_range;

Note: 'page' is not set to NULL and is not incremented but 'pfn' advances.
Thus means if deferred struct pages are enabled on systems with these
kind of holes, linux would get memory corruptions.  I have fixed this
issue by defining a new macro that performs all the necessary operations
when we free the current set of pages.

[pasha.tatashin@oracle.com: buddy page accessed before initialized]
  Link: http://lkml.kernel.org/r/20171102170221.7401-2-pasha.tatashin@oracle.com
Link: http://lkml.kernel.org/r/20171013173214.27300-2-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reviewed-by: Steven Sistare <steven.sistare@oracle.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Bob Picco <bob.picco@oracle.com>
Tested-by: Bob Picco <bob.picco@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  188 +++++++++++++++++++++++++---------------------
 1 file changed, 105 insertions(+), 83 deletions(-)

diff -puN mm/page_alloc.c~mm-deferred_init_memmap-improvements mm/page_alloc.c
--- a/mm/page_alloc.c~mm-deferred_init_memmap-improvements
+++ a/mm/page_alloc.c
@@ -1408,14 +1408,17 @@ void clear_zone_contiguous(struct zone *
 }
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
-static void __init deferred_free_range(struct page *page,
-					unsigned long pfn, int nr_pages)
+static void __init deferred_free_range(unsigned long pfn,
+				       unsigned long nr_pages)
 {
-	int i;
+	struct page *page;
+	unsigned long i;
 
-	if (!page)
+	if (!nr_pages)
 		return;
 
+	page = pfn_to_page(pfn);
+
 	/* Free a large naturally-aligned chunk if possible */
 	if (nr_pages == pageblock_nr_pages &&
 	    (pfn & (pageblock_nr_pages - 1)) == 0) {
@@ -1441,19 +1444,109 @@ static inline void __init pgdat_init_rep
 		complete(&pgdat_init_all_done_comp);
 }
 
+/*
+ * Helper for deferred_init_range, free the given range, reset the counters, and
+ * return number of pages freed.
+ */
+static inline unsigned long __init __def_free(unsigned long *nr_free,
+					      unsigned long *free_base_pfn,
+					      struct page **page)
+{
+	unsigned long nr = *nr_free;
+
+	deferred_free_range(*free_base_pfn, nr);
+	*free_base_pfn = 0;
+	*nr_free = 0;
+	*page = NULL;
+
+	return nr;
+}
+
+static unsigned long __init deferred_init_range(int nid, int zid,
+						unsigned long start_pfn,
+						unsigned long end_pfn)
+{
+	struct mminit_pfnnid_cache nid_init_state = { };
+	unsigned long nr_pgmask = pageblock_nr_pages - 1;
+	unsigned long free_base_pfn = 0;
+	unsigned long nr_pages = 0;
+	unsigned long nr_free = 0;
+	struct page *page = NULL;
+	unsigned long pfn;
+
+	/*
+	 * First we check if pfn is valid on architectures where it is possible
+	 * to have holes within pageblock_nr_pages. On systems where it is not
+	 * possible, this function is optimized out.
+	 *
+	 * Then, we check if a current large page is valid by only checking the
+	 * validity of the head pfn.
+	 *
+	 * meminit_pfn_in_nid is checked on systems where pfns can interleave
+	 * within a node: a pfn is between start and end of a node, but does not
+	 * belong to this memory node.
+	 *
+	 * Finally, we minimize pfn page lookups and scheduler checks by
+	 * performing it only once every pageblock_nr_pages.
+	 *
+	 * We do it in two loops: first we initialize struct page, than free to
+	 * buddy allocator, becuse while we are freeing pages we can access
+	 * pages that are ahead (computing buddy page in __free_one_page()).
+	 */
+	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+		if (!pfn_valid_within(pfn))
+			continue;
+		if ((pfn & nr_pgmask) || pfn_valid(pfn)) {
+			if (meminit_pfn_in_nid(pfn, nid, &nid_init_state)) {
+				if (page && (pfn & nr_pgmask))
+					page++;
+				else
+					page = pfn_to_page(pfn);
+				__init_single_page(page, pfn, zid, nid);
+				cond_resched();
+			}
+		}
+	}
+
+	page = NULL;
+	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+		if (!pfn_valid_within(pfn)) {
+			nr_pages += __def_free(&nr_free, &free_base_pfn, &page);
+		} else if (!(pfn & nr_pgmask) && !pfn_valid(pfn)) {
+			nr_pages += __def_free(&nr_free, &free_base_pfn, &page);
+		} else if (!meminit_pfn_in_nid(pfn, nid, &nid_init_state)) {
+			nr_pages += __def_free(&nr_free, &free_base_pfn, &page);
+		} else if (page && (pfn & nr_pgmask)) {
+			page++;
+			nr_free++;
+		} else {
+			nr_pages += __def_free(&nr_free, &free_base_pfn, &page);
+			page = pfn_to_page(pfn);
+			free_base_pfn = pfn;
+			nr_free = 1;
+			cond_resched();
+		}
+	}
+	/* Free the last block of pages to allocator */
+	nr_pages += __def_free(&nr_free, &free_base_pfn, &page);
+
+	return nr_pages;
+}
+
 /* Initialise remaining memory on a node */
 static int __init deferred_init_memmap(void *data)
 {
 	pg_data_t *pgdat = data;
 	int nid = pgdat->node_id;
-	struct mminit_pfnnid_cache nid_init_state = { };
 	unsigned long start = jiffies;
 	unsigned long nr_pages = 0;
-	unsigned long walk_start, walk_end;
-	int i, zid;
+	unsigned long spfn, epfn;
+	phys_addr_t spa, epa;
+	int zid;
 	struct zone *zone;
 	unsigned long first_init_pfn = pgdat->first_deferred_pfn;
 	const struct cpumask *cpumask = cpumask_of_node(pgdat->node_id);
+	u64 i;
 
 	if (first_init_pfn == ULONG_MAX) {
 		pgdat_init_report_one_done();
@@ -1475,83 +1568,12 @@ static int __init deferred_init_memmap(v
 		if (first_init_pfn < zone_end_pfn(zone))
 			break;
 	}
+	first_init_pfn = max(zone->zone_start_pfn, first_init_pfn);
 
-	for_each_mem_pfn_range(i, nid, &walk_start, &walk_end, NULL) {
-		unsigned long pfn, end_pfn;
-		struct page *page = NULL;
-		struct page *free_base_page = NULL;
-		unsigned long free_base_pfn = 0;
-		int nr_to_free = 0;
-
-		end_pfn = min(walk_end, zone_end_pfn(zone));
-		pfn = first_init_pfn;
-		if (pfn < walk_start)
-			pfn = walk_start;
-		if (pfn < zone->zone_start_pfn)
-			pfn = zone->zone_start_pfn;
-
-		for (; pfn < end_pfn; pfn++) {
-			if (!pfn_valid_within(pfn))
-				goto free_range;
-
-			/*
-			 * Ensure pfn_valid is checked every
-			 * pageblock_nr_pages for memory holes
-			 */
-			if ((pfn & (pageblock_nr_pages - 1)) == 0) {
-				if (!pfn_valid(pfn)) {
-					page = NULL;
-					goto free_range;
-				}
-			}
-
-			if (!meminit_pfn_in_nid(pfn, nid, &nid_init_state)) {
-				page = NULL;
-				goto free_range;
-			}
-
-			/* Minimise pfn page lookups and scheduler checks */
-			if (page && (pfn & (pageblock_nr_pages - 1)) != 0) {
-				page++;
-			} else {
-				nr_pages += nr_to_free;
-				deferred_free_range(free_base_page,
-						free_base_pfn, nr_to_free);
-				free_base_page = NULL;
-				free_base_pfn = nr_to_free = 0;
-
-				page = pfn_to_page(pfn);
-				cond_resched();
-			}
-
-			if (page->flags) {
-				VM_BUG_ON(page_zone(page) != zone);
-				goto free_range;
-			}
-
-			__init_single_page(page, pfn, zid, nid);
-			if (!free_base_page) {
-				free_base_page = page;
-				free_base_pfn = pfn;
-				nr_to_free = 0;
-			}
-			nr_to_free++;
-
-			/* Where possible, batch up pages for a single free */
-			continue;
-free_range:
-			/* Free the current block of pages to allocator */
-			nr_pages += nr_to_free;
-			deferred_free_range(free_base_page, free_base_pfn,
-								nr_to_free);
-			free_base_page = NULL;
-			free_base_pfn = nr_to_free = 0;
-		}
-		/* Free the last block of pages to allocator */
-		nr_pages += nr_to_free;
-		deferred_free_range(free_base_page, free_base_pfn, nr_to_free);
