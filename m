Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DD37346F
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006228; cv=none; b=Z9lP+wGEwOzmNpk1sCq5Jxqn/GCdbJg5UEBV0P7ofP24pMjQt1VHwsZ0oXs25R9ThR9KNwcd2cOYWi0G2KwBTDdZW+aNo9U9aoEY+ghnIf1iO0dGrxGldNe6XS31DlD8iCu6dVUZX+b1Hfb+/JyVXbTs56FCPh0FxJPN+uRyD/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006228; c=relaxed/simple;
	bh=q7v1KtnFFSD1VTVWiyDcX0XImlq+BdlQcWSxn1g4NtI=;
	h=Date:To:From:Subject:Message-Id; b=Omq/cBVQwAnrT+m2XIqty7XvlPbg4OD+KzX006XasbpUPR9xqDqjXVTTOa2PexSmGFpf7/MNd04Xc880i2+mk/4HwkU4vp2K1t0fePuft/4CnRBTAi/CClm5LV1RzEA+01EWCCNWBlCuNBQaQmD7RXW5IzU/c5wg4o4g02iNAk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uleoQOtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uleoQOtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3345EC4CED6;
	Thu, 16 Jan 2025 05:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006228;
	bh=q7v1KtnFFSD1VTVWiyDcX0XImlq+BdlQcWSxn1g4NtI=;
	h=Date:To:From:Subject:From;
	b=uleoQOtMdN6GFXBJuxHgVzRjwUIyCvrm/IIjhpYLXri4VUpjwwfJ2H/HfWvS0TsTD
	 DWHTIwJ2RlJkHjHl8HxFLL40UtGg8c+cETv4WcunjsoyAVFDOnlv3jH9OZoNpC552f
	 2seI6r1YfM1wgj/gJTMGDhwNSPFsfYofOuxt2/qk=
Date: Wed, 15 Jan 2025 21:43:47 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-add-two-helpers-for-zs_page_migrate-and-make-it-use-zpdesc.patch removed from -mm tree
Message-Id: <20250116054348.3345EC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: add two helpers for zs_page_migrate() and make it use zpdesc
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-add-two-helpers-for-zs_page_migrate-and-make-it-use-zpdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/zsmalloc: add two helpers for zs_page_migrate() and make it use zpdesc
Date: Tue, 17 Dec 2024 00:04:41 +0900

To convert page to zpdesc in zs_page_migrate(), we added
zpdesc_is_isolated()/zpdesc_zone() helpers.  No functional change.
Link: https://lkml.kernel.org/r/20241216150450.1228021-11-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpdesc.h   |   11 +++++++++++
 mm/zsmalloc.c |   30 ++++++++++++++++--------------
 2 files changed, 27 insertions(+), 14 deletions(-)

--- a/mm/zpdesc.h~mm-zsmalloc-add-two-helpers-for-zs_page_migrate-and-make-it-use-zpdesc
+++ a/mm/zpdesc.h
@@ -154,4 +154,15 @@ static inline void __zpdesc_set_movable(
 {
 	__SetPageMovable(zpdesc_page(zpdesc), mops);
 }
+
+static inline bool zpdesc_is_isolated(struct zpdesc *zpdesc)
+{
+	return PageIsolated(zpdesc_page(zpdesc));
+}
+
+static inline struct zone *zpdesc_zone(struct zpdesc *zpdesc)
+{
+	return page_zone(zpdesc_page(zpdesc));
+}
+
 #endif
--- a/mm/zsmalloc.c~mm-zsmalloc-add-two-helpers-for-zs_page_migrate-and-make-it-use-zpdesc
+++ a/mm/zsmalloc.c
@@ -1796,19 +1796,21 @@ static int zs_page_migrate(struct page *
 	struct size_class *class;
 	struct zspage *zspage;
 	struct zpdesc *dummy;
+	struct zpdesc *newzpdesc = page_zpdesc(newpage);
+	struct zpdesc *zpdesc = page_zpdesc(page);
 	void *s_addr, *d_addr, *addr;
 	unsigned int offset;
 	unsigned long handle;
 	unsigned long old_obj, new_obj;
 	unsigned int obj_idx;
 
-	VM_BUG_ON_PAGE(!PageIsolated(page), page);
+	VM_BUG_ON_PAGE(!zpdesc_is_isolated(zpdesc), zpdesc_page(zpdesc));
 
 	/* We're committed, tell the world that this is a Zsmalloc page. */
-	__SetPageZsmalloc(newpage);
+	__SetPageZsmalloc(zpdesc_page(newzpdesc));
 
 	/* The page is locked, so this pointer must remain valid */
-	zspage = get_zspage(page);
+	zspage = get_zspage(zpdesc_page(zpdesc));
 	pool = zspage->pool;
 
 	/*
@@ -1825,30 +1827,30 @@ static int zs_page_migrate(struct page *
 	/* the migrate_write_lock protects zpage access via zs_map_object */
 	migrate_write_lock(zspage);
 
-	offset = get_first_obj_offset(page);
-	s_addr = kmap_local_page(page);
+	offset = get_first_obj_offset(zpdesc_page(zpdesc));
+	s_addr = kmap_local_zpdesc(zpdesc);
 
 	/*
 	 * Here, any user cannot access all objects in the zspage so let's move.
 	 */
-	d_addr = kmap_local_page(newpage);
+	d_addr = kmap_local_zpdesc(newzpdesc);
 	copy_page(d_addr, s_addr);
 	kunmap_local(d_addr);
 
 	for (addr = s_addr + offset; addr < s_addr + PAGE_SIZE;
 					addr += class->size) {
-		if (obj_allocated(page_zpdesc(page), addr, &handle)) {
+		if (obj_allocated(zpdesc, addr, &handle)) {
 
 			old_obj = handle_to_obj(handle);
 			obj_to_location(old_obj, &dummy, &obj_idx);
-			new_obj = (unsigned long)location_to_obj(newpage,
+			new_obj = (unsigned long)location_to_obj(zpdesc_page(newzpdesc),
 								obj_idx);
 			record_obj(handle, new_obj);
 		}
 	}
 	kunmap_local(s_addr);
 
-	replace_sub_page(class, zspage, page_zpdesc(newpage), page_zpdesc(page));
+	replace_sub_page(class, zspage, newzpdesc, zpdesc);
 	/*
 	 * Since we complete the data copy and set up new zspage structure,
 	 * it's okay to release migration_lock.
@@ -1857,14 +1859,14 @@ static int zs_page_migrate(struct page *
 	spin_unlock(&class->lock);
 	migrate_write_unlock(zspage);
 
-	get_page(newpage);
-	if (page_zone(newpage) != page_zone(page)) {
-		dec_zone_page_state(page, NR_ZSPAGES);
-		inc_zone_page_state(newpage, NR_ZSPAGES);
+	zpdesc_get(newzpdesc);
+	if (zpdesc_zone(newzpdesc) != zpdesc_zone(zpdesc)) {
+		zpdesc_dec_zone_page_state(zpdesc);
+		zpdesc_inc_zone_page_state(newzpdesc);
 	}
 
 	reset_page(page);
-	put_page(page);
+	zpdesc_put(zpdesc);
 
 	return MIGRATEPAGE_SUCCESS;
 }
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are


