From: akpm@linux-foundation.org
Subject: + mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole.patch added to -mm tree
Date: Thu, 05 Feb 2009 09:29:54 -0800
Message-ID: <200902051729.n15HTsCC000590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759488AbZBERbV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 12:31:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, davem@davemlloft.net, heiko.carstens@de.ibm.com, mel@csn.ul.ie, stable@kernel.org


The patch titled
     mm: fix memmap init to initialize valid memmap for memory hole
has been added to the -mm tree.  Its filename is
     mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole.patch

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
Subject: mm: fix memmap init to initialize valid memmap for memory hole
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

If PFN is not in early_node_map[] then struct page for it is not
initialized.  If there are holes within a MAX_ORDER_NE_PAGES range of
pages, then PG_reserved will not be set.  Code that walks PFNs within
MAX_ORDER_NR_PAGES will the use uninitialized struct pages.

To avoid any problems, this patch initializes holes within a
MAX_ORDER_NR_PAGES that valid memmap exists but is otherwise unused.

Sayeth davem:

What's happening is that the assertion in mm/page_alloc.c:move_freepages()
is triggering:

	BUG_ON(page_zone(start_page) != page_zone(end_page));

Once I knew this is what was happening, I added some annotations:

	if (unlikely(page_zone(start_page) != page_zone(end_page))) {
		printk(KERN_ERR "move_freepages: Bogus zones: "
		       "start_page[%p] end_page[%p] zone[%p]\n",
		       start_page, end_page, zone);
		printk(KERN_ERR "move_freepages: "
		       "start_zone[%p] end_zone[%p]\n",
		       page_zone(start_page), page_zone(end_page));
		printk(KERN_ERR "move_freepages: "
		       "start_pfn[0x%lx] end_pfn[0x%lx]\n",
		       page_to_pfn(start_page), page_to_pfn(end_page));
		printk(KERN_ERR "move_freepages: "
		       "start_nid[%d] end_nid[%d]\n",
		       page_to_nid(start_page), page_to_nid(end_page));
 ...

And here's what I got:

	move_freepages: Bogus zones: start_page[2207d0000] end_page[2207dffc0] zone[fffff8103effcb00]
	move_freepages: start_zone[fffff8103effcb00] end_zone[fffff8003fffeb00]
	move_freepages: start_pfn[0x81f600] end_pfn[0x81f7ff]
	move_freepages: start_nid[1] end_nid[0]

My memory layout on this box is:

[    0.000000] Zone PFN ranges:
[    0.000000]   Normal   0x00000000 -> 0x0081ff5d
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[8] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00020000
[    0.000000]     1: 0x00800000 -> 0x0081f7ff
[    0.000000]     1: 0x0081f800 -> 0x0081fe50
[    0.000000]     1: 0x0081fed1 -> 0x0081fed8
[    0.000000]     1: 0x0081feda -> 0x0081fedb
[    0.000000]     1: 0x0081fedd -> 0x0081fee5
[    0.000000]     1: 0x0081fee7 -> 0x0081ff51
[    0.000000]     1: 0x0081ff59 -> 0x0081ff5d

So it's a block move in that 0x81f600-->0x81f7ff region which triggers
the problem.

So I did a lot (and I do mean _A LOT_) of digging.  And it seems that
unless you set HOLES_IN_ZONE you have to make sure that all of the
memmap regions of free space in a zone begin and end on an HPAGE_SIZE
boundary (the requirement used to be that it had to be MAX_ORDER
sized).

Well, this assumption enterred the tree back in 2005 (!!!) from
the following commit in the history-2.6 tree:

commit 69fba2dd0335abec0b0de9ac53d5bbb67c31fc60
Author: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date:   Fri Jan 7 22:01:35 2005 -0800

    [PATCH] no buddy bitmap patch revisit: for mm/page_alloc.c


Reported-by: David Miller <davem@davemlloft.net>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 ------
 mm/page_alloc.c        |   13 +++++++++++--
 2 files changed, 11 insertions(+), 8 deletions(-)

diff -puN include/linux/mmzone.h~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole
+++ a/include/linux/mmzone.h
@@ -1070,12 +1070,6 @@ void sparse_init(void);
 #define sparse_index_init(_sec, _nid)  do {} while (0)
 #endif /* CONFIG_SPARSEMEM */
 
-#ifdef CONFIG_NODES_SPAN_OTHER_NODES
-#define early_pfn_in_nid(pfn, nid)	(early_pfn_to_nid(pfn) == (nid))
-#else
-#define early_pfn_in_nid(pfn, nid)	(1)
-#endif
-
 #ifndef early_pfn_valid
 #define early_pfn_valid(pfn)	(1)
 #endif
diff -puN mm/page_alloc.c~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole
+++ a/mm/page_alloc.c
@@ -2633,9 +2633,18 @@ void __meminit memmap_init_zone(unsigned
 		 * exist on hotplugged memory.
 		 */
 		if (context == MEMMAP_EARLY) {
+			int nid_from_node_memory_map;
+
 			if (!early_pfn_valid(pfn))
 				continue;
-			if (!early_pfn_in_nid(pfn, nid))
+			/*
+			 * early_pfn_to_nid() returns -1 if the page doesn't
+			 * exist in early_node_map[]. Initialize it in force
+			 * and set PG_reserved at el.
+			 */
+			nid_from_node_memory_map = early_pfn_to_nid(pfn);
+			if (nid_from_node_memory_map > -1 &&
+				nid_from_node_memory_map != nid)
 				continue;
 		}
 		page = pfn_to_page(pfn);
@@ -3002,7 +3011,7 @@ int __meminit early_pfn_to_nid(unsigned 
 			return early_node_map[i].nid;
 	}
 
-	return 0;
+	return -1;
 }
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-fix-memmap-init-to-initialize-valid-memmap-for-memory-hole.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch

