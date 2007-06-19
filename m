From: akpm@linux-foundation.org
Subject: + mm-more-__meminit-annotations.patch added to -mm tree
Date: Tue, 19 Jun 2007 13:23:09 -0700
Message-ID: <200706192023.l5JKN9u5020371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762312AbXFSUXT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 16:23:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, y-goto@jp.fujitsu.com


The patch titled
     mm: more __meminit annotations
has been added to the -mm tree.  Its filename is
     mm-more-__meminit-annotations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: more __meminit annotations
From: Paul Mundt <lethal@linux-sh.org>

Currently zone_spanned_pages_in_node() and zone_absent_pages_in_node() are
non-static for ARCH_POPULATES_NODE_MAP and static otherwise.  However, only
the non-static versions are __meminit annotated, despite only being called
from __meminit functions in either case.

zone_init_free_lists() is currently non-static and not __meminit annotated
either, despite only being called once in the entire tree by
init_currently_empty_zone(), which too is __meminit.  So make it static and
properly annotated.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~mm-more-__meminit-annotations mm/page_alloc.c
--- a/mm/page_alloc.c~mm-more-__meminit-annotations
+++ a/mm/page_alloc.c
@@ -2189,8 +2189,8 @@ void __meminit memmap_init_zone(unsigned
 	}
 }
 
-void zone_init_free_lists(struct pglist_data *pgdat, struct zone *zone,
-				unsigned long size)
+static void __meminit zone_init_free_lists(struct pglist_data *pgdat,
+				struct zone *zone, unsigned long size)
 {
 	int order;
 	for (order = 0; order < MAX_ORDER ; order++) {
@@ -2667,7 +2667,7 @@ void __meminit get_pfn_range_for_nid(uns
  * Return the number of pages a zone spans in a node, including holes
  * present_pages = zone_spanned_pages_in_node() - zone_absent_pages_in_node()
  */
-unsigned long __meminit zone_spanned_pages_in_node(int nid,
+static unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
 					unsigned long *ignored)
 {
@@ -2755,7 +2755,7 @@ unsigned long __init absent_pages_in_ran
 }
 
 /* Return the number of page frames in holes in a zone on a node */
-unsigned long __meminit zone_absent_pages_in_node(int nid,
+static unsigned long __meminit zone_absent_pages_in_node(int nid,
 					unsigned long zone_type,
 					unsigned long *ignored)
 {
@@ -2772,14 +2772,14 @@ unsigned long __meminit zone_absent_page
 }
 
 #else
-static inline unsigned long zone_spanned_pages_in_node(int nid,
+static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
 					unsigned long *zones_size)
 {
 	return zones_size[zone_type];
 }
 
-static inline unsigned long zone_absent_pages_in_node(int nid,
+static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
 						unsigned long zone_type,
 						unsigned long *zholes_size)
 {
_

Patches currently in -mm which might be from lethal@linux-sh.org are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
numa-mempolicy-trivial-debug-fixes.patch
mm-more-__meminit-annotations.patch
pvr2fb-fix-pseudo_palette-array-overrun-and-typecast.patch
fb-epson1355fb-kill-off-dead-sh-support.patch
