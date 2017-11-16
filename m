From: akpm@linux-foundation.org
Subject: [folded-merged] mm-deferred_init_memmap-improvements-fix-3.patch
 removed from -mm tree
Date: Wed, 15 Nov 2017 17:04:14 -0800
Message-ID: <5a0ce40e.DZkhz+QcYwJ9REc6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36112 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdKPBEQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:04:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, aryabinin@virtuozzo.com, bob.picco@oracle.com, daniel.m.jordan@oracle.com, dvyukov@google.com, mgorman@techsingularity.net, mhocko@suse.com, steven.sistare@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: buddy page accessed before initialized
has been removed from the -mm tree.  Its filename was
     mm-deferred_init_memmap-improvements-fix-3.patch

This patch was dropped because it was folded into mm-deferred_init_memmap-improvements.patch

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm: buddy page accessed before initialized

This problem is seen when machine is rebooted after kexec:
A message like this is printed:
==========================================================================
WARNING: CPU: 21 PID: 249 at linux/lib/list_debug.c:53__listd+0x83/0xa0
Modules linked in:
CPU: 21 PID: 249 Comm: pgdatinit0 Not tainted 4.14.0-rc6_pt_deferred #90
Hardware name: Oracle Corporation ORACLE SERVER X6-2/ASM,MOTHERBOARD,1U,
BIOS 3016
node 1 initialised, 32444607 pages in 1679ms
task: ffff880180e75a00 task.stack: ffffc9000cdb0000
RIP: 0010:__list_del_entry_valid+0x83/0xa0
RSP: 0000:ffffc9000cdb3d18 EFLAGS: 00010046
RAX: 0000000000000054 RBX: 0000000000000009 RCX: ffffffff81c5f3e8
RDX: 0000000000000000 RSI: 0000000000000086 RDI: 0000000000000046
RBP: ffffc9000cdb3d18 R08: 00000000fffffffe R09: 0000000000000154
R10: 0000000000000005 R11: 0000000000000153 R12: 0000000001fcdc00
R13: 0000000001fcde00 R14: ffff88207ffded00 R15: ffffea007f370000
FS:  0000000000000000(0000) GS:ffff881fffac0000(0000) knlGS:0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000407ec09001 CR4: 00000000003606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 free_one_page+0x103/0x390
 __free_pages_ok+0x1cf/0x2d0
 __free_pages+0x19/0x30
 __free_pages_boot_core+0xae/0xba
 deferred_free_range+0x60/0x94
 deferred_init_memmap+0x324/0x372
 kthread+0x109/0x140
 ? __free_pages_bootmem+0x2e/0x2e
 ? kthread_park+0x60/0x60
 ret_from_fork+0x25/0x30

list_del corruption. next->prev should be ffffea007f428020, but was
ffffea007f1d8020
==========================================================================

The problem happens in this path:

page_alloc_init_late
  deferred_init_memmap
    deferred_init_range
      __def_free
        deferred_free_range
          __free_pages_boot_core(page, order)
            __free_pages()
              __free_pages_ok()
                free_one_page()
                  __free_one_page(page, pfn, zone, order, migratetype);

deferred_init_range() initializes one page at a time by calling
__init_single_page(), once it initializes pageblock_nr_pages pages, it
calls deferred_free_range() to free the initialized pages to the buddy
allocator. Eventually, we reach __free_one_page(), where we compute buddy
page:
	buddy_pfn = __find_buddy_pfn(pfn, order);
	buddy = page + (buddy_pfn - pfn);

buddy_pfn is computed as pfn ^ (1 << order), or pfn + pageblock_nr_pages.
Thefore, buddy page becomes a page one after the range that currently was
initialized, and we access this page in this function. Also, later when we
return back to deferred_init_range(), the buddy page is initialized again.

So, in order to avoid this issue, we must initialize the buddy page prior
to calling deferred_free_range().

Link: http://lkml.kernel.org/r/20171102170221.7401-2-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Bob Picco <bob.picco@oracle.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   66 +++++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 23 deletions(-)

diff -puN mm/page_alloc.c~mm-deferred_init_memmap-improvements-fix-3 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-deferred_init_memmap-improvements-fix-3
+++ a/mm/page_alloc.c
@@ -1448,9 +1448,9 @@ static inline void __init pgdat_init_rep
  * Helper for deferred_init_range, free the given range, reset the counters, and
  * return number of pages freed.
  */
-static inline unsigned long __def_free(unsigned long *nr_free,
-				       unsigned long *free_base_pfn,
-				       struct page **page)
+static inline unsigned long __init __def_free(unsigned long *nr_free,
+					      unsigned long *free_base_pfn,
+					      struct page **page)
 {
 	unsigned long nr = *nr_free;
 
@@ -1462,8 +1462,9 @@ static inline unsigned long __def_free(u
 	return nr;
 }
 
-static unsigned long deferred_init_range(int nid, int zid, unsigned long pfn,
-					 unsigned long end_pfn)
+static unsigned long __init deferred_init_range(int nid, int zid,
+						unsigned long start_pfn,
+						unsigned long end_pfn)
 {
 	struct mminit_pfnnid_cache nid_init_state = { };
 	unsigned long nr_pgmask = pageblock_nr_pages - 1;
@@ -1471,23 +1472,44 @@ static unsigned long deferred_init_range
 	unsigned long nr_pages = 0;
 	unsigned long nr_free = 0;
 	struct page *page = NULL;
+	unsigned long pfn;
 
-	for (; pfn < end_pfn; pfn++) {
-		/*
-		 * First we check if pfn is valid on architectures where it is
-		 * possible to have holes within pageblock_nr_pages. On systems
-		 * where it is not possible, this function is optimized out.
-		 *
-		 * Then, we check if a current large page is valid by only
-		 * checking the validity of the head pfn.
-		 *
-		 * meminit_pfn_in_nid is checked on systems where pfns can
-		 * interleave within a node: a pfn is between start and end
-		 * of a node, but does not belong to this memory node.
-		 *
-		 * Finally, we minimize pfn page lookups and scheduler checks by
-		 * performing it only once every pageblock_nr_pages.
-		 */
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
 		if (!pfn_valid_within(pfn)) {
 			nr_pages += __def_free(&nr_free, &free_base_pfn, &page);
 		} else if (!(pfn & nr_pgmask) && !pfn_valid(pfn)) {
@@ -1496,12 +1518,10 @@ static unsigned long deferred_init_range
 			nr_pages += __def_free(&nr_free, &free_base_pfn, &page);
 		} else if (page && (pfn & nr_pgmask)) {
 			page++;
-			__init_single_page(page, pfn, zid, nid);
 			nr_free++;
 		} else {
 			nr_pages += __def_free(&nr_free, &free_base_pfn, &page);
 			page = pfn_to_page(pfn);
-			__init_single_page(page, pfn, zid, nid);
 			free_base_pfn = pfn;
 			nr_free = 1;
 			cond_resched();
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-deferred_init_memmap-improvements.patch
x86-mm-setting-fields-in-deferred-pages.patch
sparc64-mm-setting-fields-in-deferred-pages.patch
sparc64-simplify-vmemmap_populate.patch
mm-defining-memblock_virt_alloc_try_nid_raw.patch
mm-zero-reserved-and-unavailable-struct-pages.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap.patch
sparc64-optimized-struct-page-zeroing.patch
mm-broken-deferred-calculation.patch

