From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-use-obj_tag_bit-for-bit-shifter.patch removed
 from -mm tree
Date: Wed, 27 Jul 2016 12:00:40 -0700
Message-ID: <579904d8.6UZvXq8Zr8CuoNX8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508AbcG0TAl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:00:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, dan.carpenter@oracle.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use OBJ_TAG_BIT for bit shifter
has been removed from the -mm tree.  Its filename was
     zsmalloc-use-obj_tag_bit-for-bit-shifter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: use OBJ_TAG_BIT for bit shifter

Static check warns using tag as bit shifter.  It doesn't break current
working but not good for redability.  Let's use OBJ_TAG_BIT as bit shifter
instead of OBJ_ALLOCATED_TAG.

Link: http://lkml.kernel.org/r/20160607045146.GF26230@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-use-obj_tag_bit-for-bit-shifter mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-use-obj_tag_bit-for-bit-shifter
+++ a/mm/zsmalloc.c
@@ -1052,7 +1052,7 @@ static void init_zspage(struct size_clas
 		link = (struct link_free *)vaddr + off / sizeof(*link);
 
 		while ((off += class->size) < PAGE_SIZE) {
-			link->next = freeobj++ << OBJ_ALLOCATED_TAG;
+			link->next = freeobj++ << OBJ_TAG_BITS;
 			link += class->size / sizeof(*link);
 		}
 
@@ -1063,13 +1063,13 @@ static void init_zspage(struct size_clas
 		 */
 		next_page = get_next_page(page);
 		if (next_page) {
-			link->next = freeobj++ << OBJ_ALLOCATED_TAG;
+			link->next = freeobj++ << OBJ_TAG_BITS;
 		} else {
 			/*
-			 * Reset OBJ_ALLOCATED_TAG bit to last link to tell
+			 * Reset OBJ_TAG_BITS bit to last link to tell
 			 * whether it's allocated object or not.
 			 */
-			link->next = -1 << OBJ_ALLOCATED_TAG;
+			link->next = -1 << OBJ_TAG_BITS;
 		}
 		kunmap_atomic(vaddr);
 		page = next_page;
@@ -1514,7 +1514,7 @@ static unsigned long obj_malloc(struct s
 
 	vaddr = kmap_atomic(m_page);
 	link = (struct link_free *)vaddr + m_offset / sizeof(*link);
-	set_freeobj(zspage, link->next >> OBJ_ALLOCATED_TAG);
+	set_freeobj(zspage, link->next >> OBJ_TAG_BITS);
 	if (likely(!PageHugeObject(m_page)))
 		/* record handle in the header of allocated chunk */
 		link->handle = handle;
@@ -1616,7 +1616,7 @@ static void obj_free(struct size_class *
 
 	/* Insert this object in containing zspage's freelist */
 	link = (struct link_free *)(vaddr + f_offset);
-	link->next = get_freeobj(zspage) << OBJ_ALLOCATED_TAG;
+	link->next = get_freeobj(zspage) << OBJ_TAG_BITS;
 	kunmap_atomic(vaddr);
 	set_freeobj(zspage, f_objidx);
 	mod_zspage_inuse(zspage, -1);
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-page_alloc-fix-dirtyable-highmem-calculation.patch
mm-show-node_pages_scanned-per-node-not-zone.patch
mm-show-node_pages_scanned-per-node-not-zone-fix.patch
mm-add-per-zone-lru-list-stat.patch
mm-bail-out-in-shrin_inactive_list.patch

