Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F173C43219
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 21:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03B2461BF8
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 21:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348747AbhKOVg0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 16:36:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349389AbhKOVJq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 16:09:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E273E61B3E;
        Mon, 15 Nov 2021 21:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637010408;
        bh=iCn/gE4HR/oEHZa0tz2wZLWzilDIp4j4XuKOeyedqgo=;
        h=Date:From:To:Subject:From;
        b=VkO427ycqdvaFAqp4naBnP/fZKwoOlUKl6aS+Wj6Wgr4zTRmgkgOTSYZpnPLoS66W
         2klaBQIARRNtO4RA0YZdjvmtCThIABgqQviEhuyZ19HDWkHh48Zjs1OVN3dTflRgWo
         rek11Biv/e65wMqIdwKBm20g5Abl+185NTXrvtjQ=
Date:   Mon, 15 Nov 2021 13:06:47 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        senozhatsky@chromium.org, tglx@linutronix.de,
        umgwanakikbuti@gmail.com
Subject:  +
 zsmalloc-move-huge-compressed-obj-from-page-to-zspage.patch added to -mm
 tree
Message-ID: <20211115210647.edqxjSeCM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: move huge compressed obj from page to zspage
has been added to the -mm tree.  Its filename is
     zsmalloc-move-huge-compressed-obj-from-page-to-zspage.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-move-huge-compressed-obj-from-page-to-zspage.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-move-huge-compressed-obj-from-page-to-zspage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: move huge compressed obj from page to zspage

The flag aims for zspage, not per page.  Let's move it to zspage.

Link: https://lkml.kernel.org/r/20211115185909.3949505-6-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   50 ++++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-move-huge-compressed-obj-from-page-to-zspage
+++ a/mm/zsmalloc.c
@@ -121,6 +121,7 @@
 #define OBJ_INDEX_BITS	(BITS_PER_LONG - _PFN_BITS - OBJ_TAG_BITS)
 #define OBJ_INDEX_MASK	((_AC(1, UL) << OBJ_INDEX_BITS) - 1)
 
+#define HUGE_BITS	1
 #define FULLNESS_BITS	2
 #define CLASS_BITS	8
 #define ISOLATED_BITS	3
@@ -213,22 +214,6 @@ struct size_class {
 	struct zs_size_stat stats;
 };
 
-/* huge object: pages_per_zspage == 1 && maxobj_per_zspage == 1 */
-static void SetPageHugeObject(struct page *page)
-{
-	SetPageOwnerPriv1(page);
-}
-
-static void ClearPageHugeObject(struct page *page)
-{
-	ClearPageOwnerPriv1(page);
-}
-
-static int PageHugeObject(struct page *page)
-{
-	return PageOwnerPriv1(page);
-}
-
 /*
  * Placed within free objects to form a singly linked list.
  * For every zspage, zspage->freeobj gives head of this list.
@@ -278,6 +263,7 @@ struct zs_pool {
 
 struct zspage {
 	struct {
+		unsigned int huge:HUGE_BITS;
 		unsigned int fullness:FULLNESS_BITS;
 		unsigned int class:CLASS_BITS + 1;
 		unsigned int isolated:ISOLATED_BITS;
@@ -298,6 +284,17 @@ struct mapping_area {
 	enum zs_mapmode vm_mm; /* mapping mode */
 };
 
+/* huge object: pages_per_zspage == 1 && maxobj_per_zspage == 1 */
+static void SetZsHugePage(struct zspage *zspage)
+{
+	zspage->huge = 1;
+}
+
+static bool ZsHugePage(struct zspage *zspage)
+{
+	return zspage->huge;
+}
+
 #ifdef CONFIG_COMPACTION
 static int zs_register_migration(struct zs_pool *pool);
 static void zs_unregister_migration(struct zs_pool *pool);
@@ -830,7 +827,9 @@ static struct zspage *get_zspage(struct
 
 static struct page *get_next_page(struct page *page)
 {
-	if (unlikely(PageHugeObject(page)))
+	struct zspage *zspage = get_zspage(page);
+
+	if (unlikely(ZsHugePage(zspage)))
 		return NULL;
 
 	return page->freelist;
@@ -880,8 +879,9 @@ static unsigned long handle_to_obj(unsig
 static bool obj_allocated(struct page *page, void *obj, unsigned long *phandle)
 {
 	unsigned long handle;
+	struct zspage *zspage = get_zspage(page);
 
-	if (unlikely(PageHugeObject(page))) {
+	if (unlikely(ZsHugePage(zspage))) {
 		VM_BUG_ON_PAGE(!is_first_page(page), page);
 		handle = page->index;
 	} else
@@ -920,7 +920,6 @@ static void reset_page(struct page *page
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
 	page_mapcount_reset(page);
-	ClearPageHugeObject(page);
 	page->freelist = NULL;
 }
 
@@ -1062,7 +1061,7 @@ static void create_page_chain(struct siz
 			SetPagePrivate(page);
 			if (unlikely(class->objs_per_zspage == 1 &&
 					class->pages_per_zspage == 1))
-				SetPageHugeObject(page);
+				SetZsHugePage(zspage);
 		} else {
 			prev_page->freelist = page;
 		}
@@ -1307,7 +1306,7 @@ void *zs_map_object(struct zs_pool *pool
 
 	ret = __zs_map_object(area, pages, off, class->size);
 out:
-	if (likely(!PageHugeObject(page)))
+	if (likely(!ZsHugePage(zspage)))
 		ret += ZS_HANDLE_SIZE;
 
 	return ret;
@@ -1395,7 +1394,7 @@ static unsigned long obj_malloc(struct z
 	vaddr = kmap_atomic(m_page);
 	link = (struct link_free *)vaddr + m_offset / sizeof(*link);
 	set_freeobj(zspage, link->next >> OBJ_TAG_BITS);
-	if (likely(!PageHugeObject(m_page)))
+	if (likely(!ZsHugePage(zspage)))
 		/* record handle in the header of allocated chunk */
 		link->handle = handle;
 	else
@@ -1496,7 +1495,10 @@ static void obj_free(int class_size, uns
 
 	/* Insert this object in containing zspage's freelist */
 	link = (struct link_free *)(vaddr + f_offset);
-	link->next = get_freeobj(zspage) << OBJ_TAG_BITS;
+	if (likely(!ZsHugePage(zspage)))
+		link->next = get_freeobj(zspage) << OBJ_TAG_BITS;
+	else
+		f_page->index = 0;
 	kunmap_atomic(vaddr);
 	set_freeobj(zspage, f_objidx);
 	mod_zspage_inuse(zspage, -1);
@@ -1867,7 +1869,7 @@ static void replace_sub_page(struct size
 
 	create_page_chain(class, zspage, pages);
 	set_first_obj_offset(newpage, get_first_obj_offset(oldpage));
-	if (unlikely(PageHugeObject(oldpage)))
+	if (unlikely(ZsHugePage(zspage)))
 		newpage->index = oldpage->index;
 	__SetPageMovable(newpage, page_mapping(oldpage));
 }
_

Patches currently in -mm which might be from minchan@kernel.org are

zsmalloc-introduce-some-helper-functions.patch
zsmalloc-rename-zs_stat_type-to-class_stat_type.patch
zsmalloc-decouple-class-actions-from-zspage-works.patch
zsmalloc-introduce-obj_allocated.patch
zsmalloc-move-huge-compressed-obj-from-page-to-zspage.patch
zsmalloc-remove-zspage-isolation-for-migration.patch
locking-rwlocks-introduce-write_lock_nested.patch
zsmalloc-replace-per-zpage-lock-with-pool-migrate_lock.patch

