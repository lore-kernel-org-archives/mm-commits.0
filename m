From: akpm@linux-foundation.org
Subject: [patch 127/131] mm/page_ext.c: check if page_ext is not
 prepared
Date: Wed, 15 Nov 2017 17:39:07 -0800
Message-ID: <20171116013907.EWBc6fyrK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40748 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933297AbdKPBjJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:39:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jaewon31.kim@samsung.com, js1304@gmail.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz

From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: mm/page_ext.c: check if page_ext is not prepared

online_page_ext() and page_ext_init() allocate page_ext for each section,
but they do not allocate if the first PFN is !pfn_present(pfn) or
!pfn_valid(pfn).  Then section->page_ext remains as NULL.  lookup_page_ext
checks NULL only if CONFIG_DEBUG_VM is enabled.  For a valid PFN,
__set_page_owner will try to get page_ext through lookup_page_ext. 
Without CONFIG_DEBUG_VM lookup_page_ext will misuse NULL pointer as value
0.  This incurrs invalid address access.

This is the panic example when PFN 0x100000 is not valid but PFN 0x13FC00
is being used for page_ext.  section->page_ext is NULL, get_entry returned
invalid page_ext address as 0x1DFA000 for a PFN 0x13FC00.

To avoid this panic, CONFIG_DEBUG_VM should be removed so that page_ext
will be checked at all times.

<1>[   11.618085] Unable to handle kernel paging request at virtual address 01dfa014
<1>[   11.618140] pgd = ffffffc0c6dc9000
<1>[   11.618174] [01dfa014] *pgd=0000000000000000, *pud=0000000000000000
<4>[   11.618240] ------------[ cut here ]------------
<2>[   11.618278] Kernel BUG at ffffff80082371e0 [verbose debug info unavailable]
<0>[   11.618338] Internal error: Oops: 96000045 [#1] PREEMPT SMP
<4>[   11.618381] Modules linked in:
<4>[   11.618524] task: ffffffc0c6ec9180 task.stack: ffffffc0c6f40000
<4>[   11.618569] PC is at __set_page_owner+0x48/0x78
<4>[   11.618607] LR is at __set_page_owner+0x44/0x78
<4>[   11.626025] [<ffffff80082371e0>] __set_page_owner+0x48/0x78
<4>[   11.626071] [<ffffff80081df9f0>] get_page_from_freelist+0x880/0x8e8
<4>[   11.626118] [<ffffff80081e00a4>] __alloc_pages_nodemask+0x14c/0xc48
<4>[   11.626165] [<ffffff80081e610c>] __do_page_cache_readahead+0xdc/0x264
<4>[   11.626214] [<ffffff80081d8824>] filemap_fault+0x2ac/0x550
<4>[   11.626259] [<ffffff80082e5cf8>] ext4_filemap_fault+0x3c/0x58
<4>[   11.626305] [<ffffff800820a2f8>] __do_fault+0x80/0x120
<4>[   11.626347] [<ffffff800820eb4c>] handle_mm_fault+0x704/0xbb0
<4>[   11.626393] [<ffffff800809ba70>] do_page_fault+0x2e8/0x394
<4>[   11.626437] [<ffffff8008080be4>] do_mem_abort+0x88/0x124

Pre-4.7 kernels also need f86e427197 ("mm: check the return value of
lookup_page_ext for all call sites").

Link: http://lkml.kernel.org/r/20171107094131.14621-1-jaewon31.kim@samsung.com
Fixes: eefa864b701d ("mm/page_ext: resurrect struct page extending code for debugging")
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: <stable@vger.kernel.org>	[depends on f86e427197, see above]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/page_ext.c~mm-page_ext-check-if-page_ext-is-not-prepared mm/page_ext.c
--- a/mm/page_ext.c~mm-page_ext-check-if-page_ext-is-not-prepared
+++ a/mm/page_ext.c
@@ -125,7 +125,6 @@ struct page_ext *lookup_page_ext(struct
 	struct page_ext *base;
 
 	base = NODE_DATA(page_to_nid(page))->node_page_ext;
-#if defined(CONFIG_DEBUG_VM)
 	/*
 	 * The sanity checks the page allocator does upon freeing a
 	 * page can reach here before the page_ext arrays are
@@ -134,7 +133,6 @@ struct page_ext *lookup_page_ext(struct
 	 */
 	if (unlikely(!base))
 		return NULL;
-#endif
 	index = pfn - round_down(node_start_pfn(page_to_nid(page)),
 					MAX_ORDER_NR_PAGES);
 	return get_entry(base, index);
@@ -199,7 +197,6 @@ struct page_ext *lookup_page_ext(struct
 {
 	unsigned long pfn = page_to_pfn(page);
 	struct mem_section *section = __pfn_to_section(pfn);
-#if defined(CONFIG_DEBUG_VM)
 	/*
 	 * The sanity checks the page allocator does upon freeing a
 	 * page can reach here before the page_ext arrays are
@@ -208,7 +205,6 @@ struct page_ext *lookup_page_ext(struct
 	 */
 	if (!section->page_ext)
 		return NULL;
-#endif
 	return get_entry(section->page_ext, pfn);
 }
 
_
