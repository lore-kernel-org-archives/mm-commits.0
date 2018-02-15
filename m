From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-optimize-memory-hotplug.patch added to -mm
 tree
Date: Thu, 15 Feb 2018 14:46:40 -0800
Message-ID: <5a860dd0.SivQZylVWK1RHoeV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42042 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756384AbeBOWrG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Feb 2018 17:47:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, bharata@linux.vnet.ibm.com, bhe@redhat.com, daniel.m.jordan@oracle.com, dan.j.williams@intel.com, gregkh@linuxfoundation.org, hpa@zytor.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, mingo@kernel.org, steven.sistare@oracle.com, tglx@linutronix.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: optimize memory hotplug
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-optimize-memory-hotplug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-optimize-memory-hotplug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-optimize-memory-hotplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm/memory_hotplug: optimize memory hotplug

During memory hotplugging we traverse struct pages three times:

1. memset(0) in sparse_add_one_section()
2. loop in __add_section() to set do: set_page_node(page, nid); and
   SetPageReserved(page);
3. loop in memmap_init_zone() to call __init_single_pfn()

This patch remove the first two loops, and leaves only loop 3. All struct
pages are initialized in one place, the same as it is done during boot.

The benefits:
- We improve the memory hotplug performance because we are not evicting
  cache several times and also reduce loop branching overheads.

- Remove condition from hotpath in __init_single_pfn(), that was added in
  order to fix the problem that was reported by Bharata in the above email
  thread, thus also improve the performance during normal boot.

- Make memory hotplug more similar to boot memory initialization path
  because we zero and initialize struct pages only in one function.

- Simplifies memory hotplug strut page initialization code, and thus
  enables future improvements, such as multi-threading the initialization
  of struct pages in order to improve the hotplug performance even further
  on larger machines.

Link: http://lkml.kernel.org/r/20180215165920.8570-7-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   21 ++++++---------------
 mm/page_alloc.c     |   28 ++++++++++------------------
 mm/sparse.c         |    9 ++++++++-
 3 files changed, 24 insertions(+), 34 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-optimize-memory-hotplug mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-optimize-memory-hotplug
+++ a/mm/memory_hotplug.c
@@ -250,7 +250,7 @@ static int __meminit __add_section(int n
 		struct vmem_altmap *altmap, bool want_memblock)
 {
 	int ret;
-	int i;
+	struct page *page;
 
 	if (pfn_valid(phys_start_pfn))
 		return -EEXIST;
@@ -260,21 +260,12 @@ static int __meminit __add_section(int n
 		return ret;
 
 	/*
-	 * Make all the pages reserved so that nobody will stumble over half
-	 * initialized state.
-	 * FIXME: We also have to associate it with a node because page_to_nid
-	 * relies on having page with the proper node.
+	 * The first page in every section holds node id, this is because we
+	 * will need it in online_pages().
 	 */
-	for (i = 0; i < PAGES_PER_SECTION; i++) {
-		unsigned long pfn = phys_start_pfn + i;
-		struct page *page;
-		if (!pfn_valid(pfn))
-			continue;
-
-		page = pfn_to_page(pfn);
-		set_page_node(page, nid);
-		SetPageReserved(page);
-	}
+	page = pfn_to_page(phys_start_pfn);
+	mm_zero_struct_page(page);
+	set_page_node(page, nid);
 
 	if (!want_memblock)
 		return 0;
diff -puN mm/page_alloc.c~mm-memory_hotplug-optimize-memory-hotplug mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory_hotplug-optimize-memory-hotplug
+++ a/mm/page_alloc.c
@@ -1139,10 +1139,9 @@ static void free_one_page(struct zone *z
 }
 
 static void __meminit __init_single_page(struct page *page, unsigned long pfn,
-				unsigned long zone, int nid, bool zero)
+				unsigned long zone, int nid)
 {
-	if (zero)
-		mm_zero_struct_page(page);
+	mm_zero_struct_page(page);
 	set_page_links(page, zone, nid, pfn);
 	init_page_count(page);
 	page_mapcount_reset(page);
@@ -1156,12 +1155,6 @@ static void __meminit __init_single_page
 #endif
 }
 
-static void __meminit __init_single_pfn(unsigned long pfn, unsigned long zone,
-					int nid, bool zero)
-{
-	return __init_single_page(pfn_to_page(pfn), pfn, zone, nid, zero);
-}
-
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static void __meminit init_reserved_page(unsigned long pfn)
 {
@@ -1180,7 +1173,7 @@ static void __meminit init_reserved_page
 		if (pfn >= zone->zone_start_pfn && pfn < zone_end_pfn(zone))
 			break;
 	}
-	__init_single_pfn(pfn, zid, nid, true);
+	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
 }
 #else
 static inline void init_reserved_page(unsigned long pfn)
@@ -1497,7 +1490,7 @@ static unsigned long  __init deferred_in
 		} else {
 			page++;
 		}
-		__init_single_page(page, pfn, zid, nid, true);
+		__init_single_page(page, pfn, zid, nid);
 		nr_pages++;
 	}
 	return (nr_pages);
@@ -5417,6 +5410,7 @@ void __meminit memmap_init_zone(unsigned
 	pg_data_t *pgdat = NODE_DATA(nid);
 	unsigned long pfn;
 	unsigned long nr_initialised = 0;
+	struct page *page;
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	struct memblock_region *r = NULL, *tmp;
 #endif
@@ -5478,6 +5472,11 @@ void __meminit memmap_init_zone(unsigned
 #endif
 
 not_early:
+		page = pfn_to_page(pfn);
+		__init_single_page(page, pfn, zone, nid);
+		if (context == MEMMAP_HOTPLUG)
+			SetPageReserved(page);
+
 		/*
 		 * Mark the block movable so that blocks are reserved for
 		 * movable at startup. This will force kernel allocations
@@ -5494,15 +5493,8 @@ not_early:
 		 * because this is done early in sparse_add_one_section
 		 */
 		if (!(pfn & (pageblock_nr_pages - 1))) {
-			struct page *page = pfn_to_page(pfn);
-
-			__init_single_page(page, pfn, zone, nid,
-					context != MEMMAP_HOTPLUG);
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 			cond_resched();
-		} else {
-			__init_single_pfn(pfn, zone, nid,
-					context != MEMMAP_HOTPLUG);
 		}
 	}
 }
diff -puN mm/sparse.c~mm-memory_hotplug-optimize-memory-hotplug mm/sparse.c
--- a/mm/sparse.c~mm-memory_hotplug-optimize-memory-hotplug
+++ a/mm/sparse.c
@@ -816,7 +816,14 @@ int __meminit sparse_add_one_section(str
 		goto out;
 	}
 
-	memset(memmap, 0, sizeof(struct page) * PAGES_PER_SECTION);
+#ifdef CONFIG_DEBUG_VM
+	/*
+	 * poison uninitialized struct pages in order to catch invalid flags
+	 * combinations.
+	 */
+	memset(memmap, PAGE_POISON_PATTERN,
+	       sizeof(struct page) * PAGES_PER_SECTION);
+#endif
 
 	section_mark_present(ms);
 
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-initialize-pages-on-demand-during-boot.patch
mm-initialize-pages-on-demand-during-boot-fix-3.patch
mm-memory_hotplug-enforce-block-size-aligned-range-check.patch
x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory.patch
x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory-v4.patch
mm-uninitialized-struct-page-poisoning-sanity-checking.patch
mm-uninitialized-struct-page-poisoning-sanity-checking-v4.patch
mm-memory_hotplug-optimize-probe-routine.patch
mm-memory_hotplug-dont-read-nid-from-struct-page-during-hotplug.patch
mm-memory_hotplug-optimize-memory-hotplug.patch
sparc64-ng4-memset-32-bits-overflow.patch

