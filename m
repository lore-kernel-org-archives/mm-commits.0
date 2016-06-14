From: akpm@linux-foundation.org
Subject: + zsmalloc-page-migration-support-fix-2.patch added to -mm tree
Date: Tue, 14 Jun 2016 15:34:44 -0700
Message-ID: <57608684.7KovOic5vvIYnrMn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbcFNWep (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2016 18:34:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: keep first object offset in struct page
has been added to the -mm tree.  Its filename is
     zsmalloc-page-migration-support-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-page-migration-support-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-page-migration-support-fix-2.patch

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
Subject: zsmalloc: keep first object offset in struct page

In early draft of zspage migration, we couldn't use page._mapcount because
it was used for storing movable flag so we added runtime calculation to
get first object offset in a page but it causes rather many instruction
and even bug.

Since then, we don't use page._mapcount as page flag any more so now
there is no problem to use the field to store first object offset.

Link: http://lkml.kernel.org/r/1465788015-23195-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   44 ++++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 28 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-page-migration-support-fix-2 mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-page-migration-support-fix-2
+++ a/mm/zsmalloc.c
@@ -509,6 +509,16 @@ static inline struct page *get_first_pag
 	return first_page;
 }
 
+static inline int get_first_obj_offset(struct page *page)
+{
+	return page->units;
+}
+
+static inline void set_first_obj_offset(struct page *page, int offset)
+{
+	page->units = offset;
+}
+
 static inline unsigned int get_freeobj(struct zspage *zspage)
 {
 	return zspage->freeobj;
@@ -869,31 +879,6 @@ static struct page *get_next_page(struct
 	return page->freelist;
 }
 
-/* Get byte offset of first object in the @page */
-static int get_first_obj_offset(struct size_class *class,
-				struct page *first_page, struct page *page)
-{
-	int pos;
-	int page_idx = 0;
-	int ofs = 0;
-	struct page *cursor = first_page;
-
-	if (first_page == page)
-		goto out;
-
-	while (page != cursor) {
-		page_idx++;
-		cursor = get_next_page(cursor);
-	}
-
-	pos = class->objs_per_zspage * class->size *
-		page_idx / class->pages_per_zspage;
-
-	ofs = (pos + class->size) % PAGE_SIZE;
-out:
-	return ofs;
-}
-
 /**
  * obj_to_location - get (<page>, <obj_idx>) from encoded object value
  * @page: page object resides in zspage
@@ -963,6 +948,7 @@ static void reset_page(struct page *page
 	clear_bit(PG_private, &page->flags);
 	clear_bit(PG_private_2, &page->flags);
 	set_page_private(page, 0);
+	page_mapcount_reset(page);
 	ClearPageHugeObject(page);
 	page->freelist = NULL;
 }
@@ -1060,6 +1046,8 @@ static void init_zspage(struct size_clas
 		struct link_free *link;
 		void *vaddr;
 
+		set_first_obj_offset(page, off);
+
 		vaddr = kmap_atomic(page);
 		link = (struct link_free *)vaddr + off / sizeof(*link);
 
@@ -1754,9 +1742,8 @@ static unsigned long find_alloced_obj(st
 	int offset = 0;
 	unsigned long handle = 0;
 	void *addr = kmap_atomic(page);
-	struct zspage *zspage = get_zspage(page);
 
-	offset = get_first_obj_offset(class, get_first_page(zspage), page);
+	offset = get_first_obj_offset(page);
 	offset += class->size * index;
 
 	while (offset < PAGE_SIZE) {
@@ -1968,6 +1955,7 @@ static void replace_sub_page(struct size
 	} while ((page = get_next_page(page)) != NULL);
 
 	create_page_chain(class, zspage, pages);
+	set_first_obj_offset(newpage, get_first_obj_offset(oldpage));
 	if (unlikely(PageHugeObject(oldpage)))
 		newpage->index = oldpage->index;
 	__SetPageMovable(newpage, page_mapping(oldpage));
@@ -2054,7 +2042,7 @@ int zs_page_migrate(struct address_space
 	get_zspage_mapping(zspage, &class_idx, &fullness);
 	pool = mapping->private_data;
 	class = pool->size_class[class_idx];
-	offset = get_first_obj_offset(class, get_first_page(zspage), page);
+	offset = get_first_obj_offset(page);
 
 	spin_lock(&class->lock);
 	if (!get_zspage_inuse(zspage)) {
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
zsmalloc-page-migration-support-fix-2.patch
zram-use-__gfp_movable-for-memory-allocation.patch
zsmalloc-use-obj_tag_bit-for-bit-shifter.patch
mm-add-nr_zsmalloc-to-vmstat.patch
mm-add-nr_zsmalloc-to-vmstat-fix-2.patch
mm-fix-build-warnings-in-linux-compactionh.patch

