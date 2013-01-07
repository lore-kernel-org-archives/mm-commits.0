From: akpm@linux-foundation.org
Subject: + mm-bootmem-fix-free_all_bootmem_core-with-odd-bitmap-alignment.patch added to -mm tree
Date: Mon, 07 Jan 2013 14:35:15 -0800
Message-ID: <20130107223515.D2819100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:38221 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab3AGWfR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 17:35:17 -0500
Received: by mail-vc0-f201.google.com with SMTP id p1so2144832vcq.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 14:35:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jcmvbkbc@gmail.com, hannes@cmpxchg.org, js1304@gmail.com, shangw@linux.vnet.ibm.com, tj@kernel.org, yinghai@kernel.org


The patch titled
     Subject: mm: bootmem: fix free_all_bootmem_core() with odd bitmap alignment
has been added to the -mm tree.  Its filename is
     mm-bootmem-fix-free_all_bootmem_core-with-odd-bitmap-alignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Max Filippov <jcmvbkbc@gmail.com>
Subject: mm: bootmem: fix free_all_bootmem_core() with odd bitmap alignment

Currently free_all_bootmem_core ignores that node_min_pfn may be not
multiple of BITS_PER_LONG.  E.g.  commit 6dccdcbe "mm: bootmem: fix
checking the bitmap when finally freeing bootmem" shifts vec by lower bits
of start instead of lower bits of idx.  Also

  if (IS_ALIGNED(start, BITS_PER_LONG) && vec == ~0UL)

assumes that vec bit 0 corresponds to start pfn, which is only true when
node_min_pfn is a multiple of BITS_PER_LONG.  Also loop in the else clause
can double-free pages (e.g.  with node_min_pfn == start == 1, map[0] == ~0
on 32-bit machine page 32 will be double-freed).

This bug causes the following message during xtensa kernel boot:

[    0.000000] bootmem::free_all_bootmem_core nid=0 start=1 end=8000
[    0.000000] BUG: Bad page state in process swapper  pfn:00001
[    0.000000] page:d04bd020 count:0 mapcount:-127 mapping:  (null) index:0x2
[    0.000000] page flags: 0x0()
[    0.000000]
[    0.000000] Stack: 00000000 00000002 00000004 ffffffff d0193e44 ffffff81 00000000 00000002
[    0.000000]        90038c66 d0193e90 d04bd020 000001a8 00000000 ffffffff 00000000 00000020
[    0.000000]        90039a4c d0193eb0 d04bd020 00000001 d04b7b20 ffff8ad0 00000000 00000000
[    0.000000] Call Trace:
[    0.000000]  [<d0038bf8>] bad_page+0x8c/0x9c
[    0.000000]  [<d0038c66>] free_pages_prepare+0x5e/0x88
[    0.000000]  [<d0039a4c>] free_hot_cold_page+0xc/0xa0
[    0.000000]  [<d0039b28>] __free_pages+0x24/0x38
[    0.000000]  [<d01b8230>] __free_pages_bootmem+0x54/0x56
[    0.000000]  [<d01b1667>] free_all_bootmem_core$part$11+0xeb/0x138
[    0.000000]  [<d01b179e>] free_all_bootmem+0x46/0x58
[    0.000000]  [<d01ae7a9>] mem_init+0x25/0xa4
[    0.000000]  [<d01ad13e>] start_kernel+0x11e/0x25c
[    0.000000]  [<d01a9121>] should_never_return+0x0/0x3be7

The fix is the following:
- always align vec so that its bit 0 corresponds to start
- provide BITS_PER_LONG bits in vec, if those bits are available in the map
- don't free pages past next start position in the else clause.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff -puN mm/bootmem.c~mm-bootmem-fix-free_all_bootmem_core-with-odd-bitmap-alignment mm/bootmem.c
--- a/mm/bootmem.c~mm-bootmem-fix-free_all_bootmem_core-with-odd-bitmap-alignment
+++ a/mm/bootmem.c
@@ -185,10 +185,23 @@ static unsigned long __init free_all_boo
 
 	while (start < end) {
 		unsigned long *map, idx, vec;
+		unsigned shift;
 
 		map = bdata->node_bootmem_map;
 		idx = start - bdata->node_min_pfn;
+		shift = idx & (BITS_PER_LONG - 1);
+		/*
+		 * vec holds at most BITS_PER_LONG map bits,
+		 * bit 0 corresponds to start.
+		 */
 		vec = ~map[idx / BITS_PER_LONG];
+
+		if (shift) {
+			vec >>= shift;
+			if (end - start >= BITS_PER_LONG)
+				vec |= ~map[idx / BITS_PER_LONG + 1] <<
+					(BITS_PER_LONG - shift);
+		}
 		/*
 		 * If we have a properly aligned and fully unreserved
 		 * BITS_PER_LONG block of pages in front of us, free
@@ -201,19 +214,18 @@ static unsigned long __init free_all_boo
 			count += BITS_PER_LONG;
 			start += BITS_PER_LONG;
 		} else {
-			unsigned long off = 0;
+			unsigned long cur = start;
 
-			vec >>= start & (BITS_PER_LONG - 1);
-			while (vec) {
+			start = ALIGN(start + 1, BITS_PER_LONG);
+			while (vec && cur != start) {
 				if (vec & 1) {
-					page = pfn_to_page(start + off);
+					page = pfn_to_page(cur);
 					__free_pages_bootmem(page, 0);
 					count++;
 				}
 				vec >>= 1;
-				off++;
+				++cur;
 			}
-			start = ALIGN(start + 1, BITS_PER_LONG);
 		}
 	}
 
_

Patches currently in -mm which might be from jcmvbkbc@gmail.com are

linux-next.patch
mm-bootmem-fix-free_all_bootmem_core-with-odd-bitmap-alignment.patch

