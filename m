Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49375C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbiAVGOH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiAVGOH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:14:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE068C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:14:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F53A60FB0
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66F7C340E0;
        Sat, 22 Jan 2022 06:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832045;
        bh=WmugM2/cvcUsr4xW3wxYITY0kgRVHqfoF7JJDYfGylI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tYQXdFL8iyNnaYc4qvar1CGLTu5qix3rubmwrZSV2JAm4dvbEDvTXZ03Hk8Al7ghj
         7KIMP4F+GNwCbivuycqvDRNw+D0JGVvMRLzQA6hZqLIVMU4SQ9Iu0RO/3WEsqHowfg
         RFn1wVYY90yNBl5jQQjsymFXm4HnC9z+ssq7de5g=
Date:   Fri, 21 Jan 2022 22:14:04 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        linux-mm@kvack.org, minchan@kernel.org, mm-commits@vger.kernel.org,
        peterz@infradead.org, senozhatsky@chromium.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, umgwanakikbuti@gmail.com
Subject:  [patch 48/69] zsmalloc: move huge compressed obj from
 page to zspage
Message-ID: <20220122061404.N-2iFdJtx%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: move huge compressed obj from page to zspage

The flag aims for zspage, not per page.  Let's move it to zspage.

Link: https://lkml.kernel.org/r/20211115185909.3949505-6-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
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
 
 	return (struct page *)page->index;
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
 	page->index = 0;
 }
 
@@ -1062,7 +1061,7 @@ static void create_page_chain(struct siz
 			SetPagePrivate(page);
 			if (unlikely(class->objs_per_zspage == 1 &&
 					class->pages_per_zspage == 1))
-				SetPageHugeObject(page);
+				SetZsHugePage(zspage);
 		} else {
 			prev_page->index = (unsigned long)page;
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
