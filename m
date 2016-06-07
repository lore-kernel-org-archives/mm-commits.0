From: akpm@linux-foundation.org
Subject: + zsmalloc-use-obj_tag_bit-for-bit-shifter.patch added to -mm
 tree
Date: Tue, 07 Jun 2016 14:21:14 -0700
Message-ID: <57573aca.PDfwBbJpREVW/9af%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161337AbcFGVVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2016 17:21:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, dan.carpenter@oracle.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use OBJ_TAG_BIT for bit shifter
has been added to the -mm tree.  Its filename is
     zsmalloc-use-obj_tag_bit-for-bit-shifter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-use-obj_tag_bit-for-bit-shifter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-use-obj_tag_bit-for-bit-shifter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1064,7 +1064,7 @@ static void init_zspage(struct size_clas
 		link = (struct link_free *)vaddr + off / sizeof(*link);
 
 		while ((off += class->size) < PAGE_SIZE) {
-			link->next = freeobj++ << OBJ_ALLOCATED_TAG;
+			link->next = freeobj++ << OBJ_TAG_BITS;
 			link += class->size / sizeof(*link);
 		}
 
@@ -1075,13 +1075,13 @@ static void init_zspage(struct size_clas
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
@@ -1526,7 +1526,7 @@ static unsigned long obj_malloc(struct s
 
 	vaddr = kmap_atomic(m_page);
 	link = (struct link_free *)vaddr + m_offset / sizeof(*link);
-	set_freeobj(zspage, link->next >> OBJ_ALLOCATED_TAG);
+	set_freeobj(zspage, link->next >> OBJ_TAG_BITS);
 	if (likely(!PageHugeObject(m_page)))
 		/* record handle in the header of allocated chunk */
 		link->handle = handle;
@@ -1628,7 +1628,7 @@ static void obj_free(struct size_class *
 
 	/* Insert this object in containing zspage's freelist */
 	link = (struct link_free *)(vaddr + f_offset);
-	link->next = get_freeobj(zspage) << OBJ_ALLOCATED_TAG;
+	link->next = get_freeobj(zspage) << OBJ_TAG_BITS;
 	kunmap_atomic(vaddr);
 	set_freeobj(zspage, f_objidx);
 	mod_zspage_inuse(zspage, -1);
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-use-put_page-to-free-page-instead-of-putback_lru_page.patch
mm-migrate-support-non-lru-movable-page-migration.patch
mm-balloon-use-general-non-lru-movable-page-feature.patch
zsmalloc-keep-max_object-in-size_class.patch
zsmalloc-use-bit_spin_lock.patch
zsmalloc-use-accessor.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-introduce-zspage-structure.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-use-freeobj-for-index.patch
zsmalloc-page-migration-support.patch
zsmalloc-page-migration-support-fix.patch
zram-use-__gfp_movable-for-memory-allocation.patch
zsmalloc-use-obj_tag_bit-for-bit-shifter.patch
mm-add-nr_zsmalloc-to-vmstat.patch
mm-add-nr_zsmalloc-to-vmstat-fix-2.patch

