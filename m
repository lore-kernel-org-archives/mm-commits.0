From: akpm@linux-foundation.org
Subject: + mm-allocate-section_map-for-sparse_init.patch added to -mm tree
Date: Thu, 13 Mar 2008 13:14:48 -0700
Message-ID: <200803132014.m2DKEm3J030839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757410AbYCMUPy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 16:15:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, ak@suse.de, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mingo@elte.hu, y-goto@jp.fujitsu.com


The patch titled
     mm: allocate section_map for sparse_init
has been added to the -mm tree.  Its filename is
     mm-allocate-section_map-for-sparse_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: allocate section_map for sparse_init
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

Allocate section_map in bootmem instead of using __initdata.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN mm/sparse.c~mm-allocate-section_map-for-sparse_init mm/sparse.c
--- a/mm/sparse.c~mm-allocate-section_map-for-sparse_init
+++ a/mm/sparse.c
@@ -287,8 +287,6 @@ struct page __init *sparse_early_mem_map
 	return NULL;
 }
 
-/* section_map pointer array is 64k */
-static __initdata struct page *section_map[NR_MEM_SECTIONS];
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
@@ -298,6 +296,9 @@ void __init sparse_init(void)
 	unsigned long pnum;
 	struct page *map;
 	unsigned long *usemap;
+	struct page **section_map;
+	int size;
+	int node;
 
 	/*
 	 * map is using big page (aka 2M in x86 64 bit)
@@ -307,13 +308,17 @@ void __init sparse_init(void)
 	 * then in big system, the memmory will have a lot hole...
 	 * here try to allocate 2M pages continously.
 	 */
+	size = sizeof(struct page *) * NR_MEM_SECTIONS;
+	section_map = alloc_bootmem(size);
+	if (!section_map)
+		panic("can not allocate section_map\n");
+
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
 			continue;
 		section_map[pnum] = sparse_early_mem_map_alloc(pnum);
 	}
 
