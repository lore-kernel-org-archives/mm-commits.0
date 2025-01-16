Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347397346F
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006217; cv=none; b=f55+Q+AsJB9reobzu1F136wbAAnNLehcNLFDo2BKIt+XYL+9Y2LVvYMsMBymnXhbFUTvoSfc/MhCq0Yqd3+lO8PyH5t458iqRvZELXB7UFHfa952DTbQTFhDZi/1HSQx77i2EGM1MDC78JHJxgwbz9LAQGzbW2Xpgp/i1mgM/MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006217; c=relaxed/simple;
	bh=lX8akDqaKoGackGqMamxGS2sPxlbrBCHQZownyk866Y=;
	h=Date:To:From:Subject:Message-Id; b=bACSdXH5zAoEVbTpeiGXUZHI0tMqD85HT7Y7/LHC0VvDK+1IKow3eZOduaXshHzcM4S1kqRJ6faMZyASFdfjbNzso2zyxVodkiAi6zOnKKZCPTf7931UmZLak6XZzYjBNAj3eznJJlQLR3EnCEW5f+twjRMRRk9W7gZBOwv1pmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KGGWhyOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KGGWhyOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5D7C4CED6;
	Thu, 16 Jan 2025 05:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006216;
	bh=lX8akDqaKoGackGqMamxGS2sPxlbrBCHQZownyk866Y=;
	h=Date:To:From:Subject:From;
	b=KGGWhyOox5wq/fhIZMdD95KN8e5N8t3imB/2g3piLB2GZcDXvw8cE7lq9znu/Wksl
	 aCGp7h0PVgSg4lbYVQUeWqMbzWy1DH1Wl2DvULPriSxd18Escqw9xuYFiKtsXLj/Mk
	 +RCkg0h4nM+15y0SA9FxK81BrIQrSi6dItXOnD6A=
Date: Wed, 15 Jan 2025 21:43:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,rdunlap@infradead.org,minchan@kernel.org,42.hyeyoo@gmail.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool.patch removed from -mm tree
Message-Id: <20250116054336.8C5D7C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: add zpdesc memory descriptor for zswap.zpool
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alex Shi <alexs@kernel.org>
Subject: mm/zsmalloc: add zpdesc memory descriptor for zswap.zpool
Date: Tue, 17 Dec 2024 00:04:32 +0900

Patch series "Add zpdesc memory descriptor for zswap.zpool", v9.

This patch series introduces a new memory descriptor for zswap.zpool that
currently overlaps with struct page for now.  This is part of the effort
to reduce the size of struct page and to enable dynamic allocation of
memory descriptors [1].

This series does not bloat anything for zsmalloc and no functional change
is intended (except for using zpdesc and folios).

In the near future, the removal of page->index from struct page [2] will
be addressed and the project also depends on this patch series.

Thanks to everyone got involved in this series, especially, Alex who's
been pushing it forward this year.

[1] https://lore.kernel.org/linux-mm/ZvRKzKizOfEWBtJp@casper.infradead.org
[2] https://lore.kernel.org/linux-mm/Z09hOy-UY9KC8WMb@casper.infradead.org


This patch (of 18):

The 1st patch introduces new memory descriptor zpdesc and renames
zspage.first_page to zspage.first_zpdesc, with no functional change.

We removed the comment about PG_owner_priv_1 since it is no longer used
after commit a41ec880aa7b ("zsmalloc: move huge compressed obj from page
to zspage").

[rdunlap@infradead.org: fix function parameter kernel-doc notation]
  Link: https://lkml.kernel.org/r/20250111063305.911010-1-rdunlap@infradead.org
[42.hyeyoo@gmail.com: rework comments a little bit]
Link: https://lkml.kernel.org/r/20241216150450.1228021-1-42.hyeyoo@gmail.com
Link: https://lkml.kernel.org/r/20241216150450.1228021-2-42.hyeyoo@gmail.com
Originally-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpdesc.h   |  107 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/zsmalloc.c |   28 ++----------
 2 files changed, 112 insertions(+), 23 deletions(-)

diff --git a/mm/zpdesc.h a/mm/zpdesc.h
new file mode 100644
--- /dev/null
+++ a/mm/zpdesc.h
@@ -0,0 +1,107 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* zpdesc.h: zswap.zpool memory descriptor
+ *
+ * Written by Alex Shi <alexs@kernel.org>
+ *	      Hyeonggon Yoo <42.hyeyoo@gmail.com>
+ */
+#ifndef __MM_ZPDESC_H__
+#define __MM_ZPDESC_H__
+
+/*
+ * struct zpdesc -	Memory descriptor for zpool memory.
+ * @flags:		Page flags, mostly unused by zsmalloc.
+ * @lru:		Indirectly used by page migration.
+ * @movable_ops:	Used by page migration.
+ * @next:		Next zpdesc in a zspage in zsmalloc zpool.
+ * @handle:		For huge zspage in zsmalloc zpool.
+ * @zspage:		Points to the zspage this zpdesc is a part of.
+ * @first_obj_offset:	First object offset in zsmalloc zpool.
+ * @_refcount:		The number of references to this zpdesc.
+ *
+ * This struct overlays struct page for now. Do not modify without a good
+ * understanding of the issues. In particular, do not expand into the overlap
+ * with memcg_data.
+ *
+ * Page flags used:
+ * * PG_private identifies the first component page.
+ * * PG_locked is used by page migration code.
+ */
+struct zpdesc {
+	unsigned long flags;
+	struct list_head lru;
+	unsigned long movable_ops;
+	union {
+		struct zpdesc *next;
+		unsigned long handle;
+	};
+	struct zspage *zspage;
+	/*
+	 * Only the lower 24 bits are available for offset, limiting a page
+	 * to 16 MiB. The upper 8 bits are reserved for PGTY_zsmalloc.
+	 *
+	 * Do not access this field directly.
+	 * Instead, use {get,set}_first_obj_offset() helpers.
+	 */
+	unsigned int first_obj_offset;
+	atomic_t _refcount;
+};
+#define ZPDESC_MATCH(pg, zp) \
+	static_assert(offsetof(struct page, pg) == offsetof(struct zpdesc, zp))
+
+ZPDESC_MATCH(flags, flags);
+ZPDESC_MATCH(lru, lru);
+ZPDESC_MATCH(mapping, movable_ops);
+ZPDESC_MATCH(index, next);
+ZPDESC_MATCH(index, handle);
+ZPDESC_MATCH(private, zspage);
+ZPDESC_MATCH(page_type, first_obj_offset);
+ZPDESC_MATCH(_refcount, _refcount);
+#undef ZPDESC_MATCH
+static_assert(sizeof(struct zpdesc) <= sizeof(struct page));
+
+/*
+ * zpdesc_page - The first struct page allocated for a zpdesc
+ * @zp: The zpdesc.
+ *
+ * A convenience wrapper for converting zpdesc to the first struct page of the
+ * underlying folio, to communicate with code not yet converted to folio or
+ * struct zpdesc.
+ *
+ */
+#define zpdesc_page(zp)			(_Generic((zp),			\
+	const struct zpdesc *:		(const struct page *)(zp),	\
+	struct zpdesc *:		(struct page *)(zp)))
+
+/**
+ * zpdesc_folio - The folio allocated for a zpdesc
+ * @zp: The zpdesc.
+ *
+ * Zpdescs are descriptors for zpool memory. The zpool memory itself is
+ * allocated as folios that contain the zpool objects, and zpdesc uses specific
+ * fields in the first struct page of the folio - those fields are now accessed
+ * by struct zpdesc.
+ *
+ * It is occasionally necessary convert to back to a folio in order to
+ * communicate with the rest of the mm. Please use this helper function
+ * instead of casting yourself, as the implementation may change in the future.
+ */
+#define zpdesc_folio(zp)		(_Generic((zp),			\
+	const struct zpdesc *:		(const struct folio *)(zp),	\
+	struct zpdesc *:		(struct folio *)(zp)))
+/**
+ * page_zpdesc - Converts from first struct page to zpdesc.
+ * @p: The first (either head of compound or single) page of zpdesc.
+ *
+ * A temporary wrapper to convert struct page to struct zpdesc in situations
+ * where we know the page is the compound head, or single order-0 page.
+ *
+ * Long-term ideally everything would work with struct zpdesc directly or go
+ * through folio to struct zpdesc.
+ *
+ * Return: The zpdesc which contains this page
+ */
+#define page_zpdesc(p)			(_Generic((p),			\
+	const struct page *:		(const struct zpdesc *)(p),	\
+	struct page *:			(struct zpdesc *)(p)))
+
+#endif
--- a/mm/zsmalloc.c~mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool
+++ a/mm/zsmalloc.c
@@ -13,24 +13,6 @@
  * Released under the terms of GNU General Public License Version 2.0
  */
 
-/*
- * Following is how we use various fields and flags of underlying
- * struct page(s) to form a zspage.
- *
- * Usage of struct page fields:
- *	page->private: points to zspage
- *	page->index: links together all component pages of a zspage
- *		For the huge page, this is always 0, so we use this field
- *		to store handle.
- *	page->page_type: PGTY_zsmalloc, lower 24 bits locate the first object
- *		offset in a subpage of a zspage
- *
- * Usage of struct page flags:
- *	PG_private: identifies the first component page
- *	PG_owner_priv_1: identifies the huge component page
- *
- */
-
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 /*
@@ -67,6 +49,7 @@
 #include <linux/pagemap.h>
 #include <linux/fs.h>
 #include <linux/local_lock.h>
+#include "zpdesc.h"
 
 #define ZSPAGE_MAGIC	0x58
 
@@ -254,7 +237,7 @@ struct zspage {
 	};
 	unsigned int inuse;
 	unsigned int freeobj;
-	struct page *first_page;
+	struct zpdesc *first_zpdesc;
 	struct list_head list; /* fullness list */
 	struct zs_pool *pool;
 	rwlock_t lock;
@@ -459,7 +442,7 @@ static inline void mod_zspage_inuse(stru
 
 static inline struct page *get_first_page(struct zspage *zspage)
 {
-	struct page *first_page = zspage->first_page;
+	struct page *first_page = zpdesc_page(zspage->first_zpdesc);
 
 	VM_BUG_ON_PAGE(!is_first_page(first_page), first_page);
 	return first_page;
@@ -952,7 +935,7 @@ static void create_page_chain(struct siz
 		set_page_private(page, (unsigned long)zspage);
 		page->index = 0;
 		if (i == 0) {
-			zspage->first_page = page;
+			zspage->first_zpdesc = page_zpdesc(page);
 			SetPagePrivate(page);
 			if (unlikely(class->objs_per_zspage == 1 &&
 					class->pages_per_zspage == 1))
@@ -1317,8 +1300,7 @@ static unsigned long obj_malloc(struct z
 		/* record handle in the header of allocated chunk */
 		link->handle = handle | OBJ_ALLOCATED_TAG;
 	else
-		/* record handle to page->index */
-		zspage->first_page->index = handle | OBJ_ALLOCATED_TAG;
+		zspage->first_zpdesc->handle = handle | OBJ_ALLOCATED_TAG;
 
 	kunmap_local(vaddr);
 	mod_zspage_inuse(zspage, 1);
_

Patches currently in -mm which might be from alexs@kernel.org are


