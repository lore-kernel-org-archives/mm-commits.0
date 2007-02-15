From: akpm@linux-foundation.org
Subject: + add-nr_mlock-zvc.patch added to -mm tree
Date: Wed, 14 Feb 2007 21:42:31 -0800
Message-ID: <200702150542.l1F5gVqM021102@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35566 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276AbXBOFmd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 00:42:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Add NR_MLOCK ZVC
has been added to the -mm tree.  Its filename is
     add-nr_mlock-zvc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add NR_MLOCK ZVC
From: Christoph Lameter <clameter@sgi.com>

Basic infrastructure to support NR_MLOCK

Add a new ZVC to support NR_MLOCK.  NR_MLOCK counts the number of mlocked
pages taken off the LRU.  Get rid of wrong calculation of cache line size in
the comments in mmzone.h.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |    2 ++
 fs/proc/proc_misc.c    |    2 ++
 include/linux/mmzone.h |    3 +--
 mm/vmstat.c            |    1 +
 4 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/base/node.c~add-nr_mlock-zvc drivers/base/node.c
--- a/drivers/base/node.c~add-nr_mlock-zvc
+++ a/drivers/base/node.c
@@ -60,6 +60,7 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d FilePages:    %8lu kB\n"
 		       "Node %d Mapped:       %8lu kB\n"
 		       "Node %d AnonPages:    %8lu kB\n"
+		       "Node %d Mlock:        %8lu KB\n"
 		       "Node %d PageTables:   %8lu kB\n"
 		       "Node %d NFS_Unstable: %8lu kB\n"
 		       "Node %d Bounce:       %8lu kB\n"
@@ -82,6 +83,7 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(node_page_state(nid, NR_FILE_PAGES)),
 		       nid, K(node_page_state(nid, NR_FILE_MAPPED)),
 		       nid, K(node_page_state(nid, NR_ANON_PAGES)),
+		       nid, K(node_page_state(nid, NR_MLOCK)),
 		       nid, K(node_page_state(nid, NR_PAGETABLE)),
 		       nid, K(node_page_state(nid, NR_UNSTABLE_NFS)),
 		       nid, K(node_page_state(nid, NR_BOUNCE)),
diff -puN fs/proc/proc_misc.c~add-nr_mlock-zvc fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~add-nr_mlock-zvc
+++ a/fs/proc/proc_misc.c
@@ -166,6 +166,7 @@ static int meminfo_read_proc(char *page,
 		"Writeback:    %8lu kB\n"
 		"AnonPages:    %8lu kB\n"
 		"Mapped:       %8lu kB\n"
+		"Mlock:        %8lu KB\n"
 		"Slab:         %8lu kB\n"
 		"SReclaimable: %8lu kB\n"
 		"SUnreclaim:   %8lu kB\n"
@@ -196,6 +197,7 @@ static int meminfo_read_proc(char *page,
 		K(global_page_state(NR_WRITEBACK)),
 		K(global_page_state(NR_ANON_PAGES)),
 		K(global_page_state(NR_FILE_MAPPED)),
+		K(global_page_state(NR_MLOCK)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE) +
 				global_page_state(NR_SLAB_UNRECLAIMABLE)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE)),
diff -puN include/linux/mmzone.h~add-nr_mlock-zvc include/linux/mmzone.h
--- a/include/linux/mmzone.h~add-nr_mlock-zvc
+++ a/include/linux/mmzone.h
@@ -47,17 +47,16 @@ struct zone_padding {
 #endif
 
 enum zone_stat_item {
-	/* First 128 byte cacheline (assuming 64 bit words) */
 	NR_FREE_PAGES,
 	NR_INACTIVE,
 	NR_ACTIVE,
+	NR_MLOCK,	/* Mlocked pages */
 	NR_ANON_PAGES,	/* Mapped anonymous pages */
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
 			   only modified from process context */
 	NR_FILE_PAGES,
 	NR_FILE_DIRTY,
 	NR_WRITEBACK,
-	/* Second 128 byte cacheline */
 	NR_SLAB_RECLAIMABLE,
 	NR_SLAB_UNRECLAIMABLE,
 	NR_PAGETABLE,		/* used for pagetables */
diff -puN mm/vmstat.c~add-nr_mlock-zvc mm/vmstat.c
--- a/mm/vmstat.c~add-nr_mlock-zvc
+++ a/mm/vmstat.c
@@ -434,6 +434,7 @@ static const char * const vmstat_text[] 
 	"nr_free_pages",
 	"nr_active",
 	"nr_inactive",
+	"nr_mlock",
 	"nr_anon_pages",
 	"nr_mapped",
 	"nr_file_pages",
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix.patch
make-try_to_unmap-return-a-special-exit-code.patch
add-pagemlocked-page-state-bit-and-lru-infrastructure.patch
add-nr_mlock-zvc.patch
logic-to-move-mlocked-pages.patch
consolidate-new-anonymous-page-code-paths.patch
avoid-putting-new-mlocked-anonymous-pages-on-lru.patch
opportunistically-move-mlocked-pages-off-the-lru.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids-fix.patch
slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
mm-implement-swap-prefetching-vs-zvc-stuff.patch
mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
