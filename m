From: akpm@linux-foundation.org
Subject: + vmscan-factor-out-page-reference-checks.patch added to -mm tree
Date: Wed, 24 Feb 2010 13:46:03 -0800
Message-ID: <201002242146.o1OLk3s5022144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758098Ab0BXVqg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 16:46:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan: factor out page reference checks
has been added to the -mm tree.  Its filename is
     vmscan-factor-out-page-reference-checks.patch

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
Subject: vmscan: factor out page reference checks
From: Johannes Weiner <hannes@cmpxchg.org>

The used-once mapped file page detection patchset.


It is meant to help workloads with large amounts of shortly used file
mappings, like rtorrent hashing a file or git when dealing with loose
objects (git gc on a bigger site?).

Right now, the VM activates referenced mapped file pages on first
encounter on the inactive list and it takes a full memory cycle to
reclaim them again.  When those pages dominate memory, the system
no longer has a meaningful notion of 'working set' and is required
to give up the active list to make reclaim progress.  Obviously,
this results in rather bad scanning latencies and the wrong pages
being reclaimed.

This patch makes the VM be more careful about activating mapped file
pages in the first place.  The minimum granted lifetime without
another memory access becomes an inactive list cycle instead of the
full memory cycle, which is more natural given the mentioned loads.

This test resembles a hashing rtorrent process.  Sequentially, 32MB
chunks of a file are mapped into memory, hashed (sha1) and unmapped
again.  While this happens, every 5 seconds a process is launched and
its execution time taken:

	python2.4 -c 'import pydoc'
	old: max=2.31s mean=1.26s (0.34)
	new: max=1.25s mean=0.32s (0.32)

	find /etc -type f
	old: max=2.52s mean=1.44s (0.43)
	new: max=1.92s mean=0.12s (0.17)

	vim -c ':quit'
	old: max=6.14s mean=4.03s (0.49)
	new: max=3.48s mean=2.41s (0.25)

	mplayer --help
	old: max=8.08s mean=5.74s (1.02)
	new: max=3.79s mean=1.32s (0.81)

	overall hash time (stdev):
	old: time=1192.30 (12.85) thruput=25.78mb/s (0.27)
	new: time=1060.27 (32.58) thruput=29.02mb/s (0.88) (-11%)

I also tested kernbench with regular IO streaming in the background to
see whether the delayed activation of frequently used mapped file
pages had a negative impact on performance in the presence of pressure
on the inactive list.  The patch made no significant difference in
timing, neither for kernbench nor for the streaming IO throughput.

The first patch submission raised concerns about the cost of the extra
faults for actually activated pages on machines that have no hardware
support for young page table entries.

I created an artificial worst case scenario on an ARM machine with
around 300MHz and 64MB of memory to figure out the dimensions
involved.  The test would mmap a file of 20MB, then

  1. touch all its pages to fault them in
  2. force one full scan cycle on the inactive file LRU
  -- old: mapping pages activated
  -- new: mapping pages inactive
  3. touch the mapping pages again
  -- old and new: fault exceptions to set the young bits
  4. force another full scan cycle on the inactive file LRU
  5. touch the mapping pages one last time
  -- new: fault exceptions to set the young bits

The test showed an overall increase of 6% in time over 100 iterations
of the above (old: ~212sec, new: ~225sec).  13 secs total overhead /
(100 * 5k pages), ignoring the execution time of the test itself,
makes for about 25us overhead for every page that gets actually
activated.  Note:

  1. File mapping the size of one third of main memory, _completely_
  in active use across memory pressure - i.e., most pages referenced
  within one LRU cycle.  This should be rare to non-existant,
  especially on such embedded setups.

  2. Many huge activation batches.  Those batches only occur when the
  working set fluctuates.  If it changes completely between every full
  LRU cycle, you have problematic reclaim overhead anyway.

  3. Access of activated pages at maximum speed: sequential loads from
  every single page without doing anything in between.  In reality,
  the extra faults will get distributed between actual operations on
  the data.

So even if a workload manages to get the VM into the situation of
activating a third of memory in one go on such a setup, it will take
2.2 seconds instead 2.1 without the patch.

Comparing the numbers (and my user-experience over several months),
I think this change is an overall improvement to the VM.

Patch 1 is only refactoring to break up that ugly compound conditional
in shrink_page_list() and make it easy to document and add new checks
in a readable fashion.

Patch 2 gets rid of the obsolete page_mapping_inuse().  It's not
strictly related to #3, but it was in the original submission and is a
net simplification, so I kept it.

Patch 3 implements used-once detection of mapped file pages.



This patch:

Moving the big conditional into its own predicate function makes the code
a bit easier to read and allows for better commenting on the checks
one-by-one.

This is just cleaning up, no semantics should have been changed.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: OSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   53 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 13 deletions(-)

diff -puN mm/vmscan.c~vmscan-factor-out-page-reference-checks mm/vmscan.c
--- a/mm/vmscan.c~vmscan-factor-out-page-reference-checks
+++ a/mm/vmscan.c
@@ -579,6 +579,37 @@ redo:
 	put_page(page);		/* drop ref from isolate */
 }
 
+enum page_references {
+	PAGEREF_RECLAIM,
+	PAGEREF_RECLAIM_CLEAN,
+	PAGEREF_ACTIVATE,
+};
+
+static enum page_references page_check_references(struct page *page,
+						  struct scan_control *sc)
+{
+	unsigned long vm_flags;
+	int referenced;
+
+	referenced = page_referenced(page, 1, sc->mem_cgroup, &vm_flags);
+	if (!referenced)
+		return PAGEREF_RECLAIM;
+
+	/* Lumpy reclaim - ignore references */
+	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
+		return PAGEREF_RECLAIM;
+
+	/* Mlock lost isolation race - let try_to_unmap() handle it */
+	if (vm_flags & VM_LOCKED)
+		return PAGEREF_RECLAIM;
+
+	if (page_mapping_inuse(page))
+		return PAGEREF_ACTIVATE;
+
+	/* Reclaim if clean, defer dirty pages to writeback */
+	return PAGEREF_RECLAIM_CLEAN;
+}
+
 /*
  * shrink_page_list() returns the number of reclaimed pages
  */
@@ -590,16 +621,15 @@ static unsigned long shrink_page_list(st
 	struct pagevec freed_pvec;
 	int pgactivate = 0;
 	unsigned long nr_reclaimed = 0;
-	unsigned long vm_flags;
 
 	cond_resched();
 
 	pagevec_init(&freed_pvec, 1);
 	while (!list_empty(page_list)) {
+		enum page_references references;
 		struct address_space *mapping;
 		struct page *page;
 		int may_enter_fs;
-		int referenced;
 
 		cond_resched();
 
@@ -641,17 +671,14 @@ static unsigned long shrink_page_list(st
 				goto keep_locked;
 		}
 
-		referenced = page_referenced(page, 1,
-						sc->mem_cgroup, &vm_flags);
-		/*
-		 * In active use or really unfreeable?  Activate it.
-		 * If page which have PG_mlocked lost isoltation race,
-		 * try_to_unmap moves it to unevictable list
-		 */
-		if (sc->order <= PAGE_ALLOC_COSTLY_ORDER &&
-					referenced && page_mapping_inuse(page)
-					&& !(vm_flags & VM_LOCKED))
+		references = page_check_references(page, sc);
+		switch (references) {
+		case PAGEREF_ACTIVATE:
 			goto activate_locked;
+		case PAGEREF_RECLAIM:
+		case PAGEREF_RECLAIM_CLEAN:
+			; /* try to reclaim the page below */
+		}
 
 		/*
 		 * Anonymous process memory has backing store?
@@ -685,7 +712,7 @@ static unsigned long shrink_page_list(st
 		}
 
 		if (PageDirty(page)) {
-			if (sc->order <= PAGE_ALLOC_COSTLY_ORDER && referenced)
+			if (references == PAGEREF_RECLAIM_CLEAN)
 				goto keep_locked;
 			if (!may_enter_fs)
 				goto keep_locked;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

bootmem-avoid-dma32-zone-by-default.patch
vmscan-factor-out-page-reference-checks.patch
vmscan-factor-out-page-reference-checks-fix.patch
vmscan-drop-page_mapping_inuse.patch
vmscan-detect-mapped-file-pages-used-only-once.patch

