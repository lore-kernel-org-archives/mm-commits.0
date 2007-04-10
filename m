From: akpm@linux-foundation.org
Subject: + slub-core-minor-fixes.patch added to -mm tree
Date: Mon, 09 Apr 2007 22:28:40 -0700
Message-ID: <200704100528.l3A5SeRq032253@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44785 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966096AbXDJF2n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 01:28:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slub: minor fixes
has been added to the -mm tree.  Its filename is
     slub-core-minor-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: minor fixes
From: Christoph Lameter <clameter@sgi.com>

1. Correct spelling

2. Partial pages should go to the front of the partial list since they are
   cache hot.

3. Remove stray printk.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/slub.c~slub-core-minor-fixes mm/slub.c
--- a/mm/slub.c~slub-core-minor-fixes
+++ a/mm/slub.c
@@ -277,7 +277,7 @@ static void print_track(const char *s, s
 	} else
 #endif
 		printk(KERN_ERR "%s: 0x%p", s, t->addr);
-	printk(" jiffies since=%lu cpu=%u pid=%d\n", jiffies - t->when, t->cpu, t->pid);
+	printk(" jiffies_ago=%lu cpu=%u pid=%d\n", jiffies - t->when, t->cpu, t->pid);
 }
 
 static void print_trailer(struct kmem_cache *s, u8 *p)
@@ -579,7 +579,7 @@ static int alloc_object_checks(struct km
 		goto bad;
 
 	if (object && !on_freelist(s, page, object)) {
-		printk(KERN_ERR "SLAB: %s Object 0x%p@0x%p "
+		printk(KERN_ERR "SLUB: %s Object 0x%p@0x%p "
 			"already allocated.\n",
 			s->name, object, page);
 		goto dump;
@@ -862,7 +862,7 @@ static void add_partial(struct kmem_cach
 
 	spin_lock(&n->list_lock);
 	n->nr_partial++;
-	list_add_tail(&page->lru, &n->partial);
+	list_add(&page->lru, &n->partial);
 	spin_unlock(&n->list_lock);
 }
 
@@ -2520,7 +2520,6 @@ static ssize_t trace_store(struct kmem_c
 							size_t length)
 {
 	s->flags &= ~SLAB_TRACE;
-	printk("_trace_store = %s\n", buf);
 	if (buf[0] == '1')
 		s->flags |= SLAB_TRACE;
 	return length;
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-core-minor-fixes.patch
slub-add-slabinfo-tool.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
use-enum-for-tracking-modes-instead-of-integers.patch
fix-object-tracking.patch
fix-another-numa-bootstrap-issue.patch
update-slabinfoc.patch
quicklists-for-page-table-pages.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
