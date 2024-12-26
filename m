Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C7A13C80D
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249612; cv=none; b=rHqORpJhRmUA4yCme/pXHsSXhhYzzA/if7wA3mDk3bcBSeDX5dl5bC1Yc+wY2KhpJ+ZKILOfih3ktdDK/mbuKyUW9ZI90sC/wy1faCHX3KAC/vKoOMT0i1KO4yD2zwTryKPgXcN83e2ULgl5BpVg4kx2v9Y3AKrfjRd3hIFA+JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249612; c=relaxed/simple;
	bh=vOgncFLXlVx4OV4u3qWiNGkbrzfXoIOsSHUlOD6zYWA=;
	h=Date:To:From:Subject:Message-Id; b=KvorzSyGdWr9NCYbNKSitO+hvKVsX5N3sTW3tJjukcLk5V5968CslMbk/4aQGYYJUdTgvb5LVMmcf6ziAhpBh2qGK9U1tEtQvtTnWUvJHnN/5auh/lsJGfb7HkfPFV3TxZM4XBfjEGz55jy7mP3QoIi2+T6S/K/Or4tDzFZBnNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GRbJUTxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GRbJUTxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5B9C4CED1;
	Thu, 26 Dec 2024 21:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249611;
	bh=vOgncFLXlVx4OV4u3qWiNGkbrzfXoIOsSHUlOD6zYWA=;
	h=Date:To:From:Subject:From;
	b=GRbJUTxrGv+K03PJrXZLviGI3CgNFzsY+7uAXcjsxz8jU+TXY1Y0QBRXymn6DPzKR
	 ggl14o2igRa4K6Lmc4b/ZGqwTQZOY9zJklV1mMbW9bo0zMEX0pMxidBjdnE6FBVJDR
	 CuKL78gbQk4g+N93UW/8lyiQILU4w5NLoNGlT/uk=
Date: Thu, 26 Dec 2024 13:46:50 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,42.hyeyoo@gmail.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool.patch added to mm-unstable branch
Message-Id: <20241226214651.8C5B9C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: add zpdesc memory descriptor for zswap.zpool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

[42.hyeyoo@gmail.com: rework comments a little bit]
Link: https://lkml.kernel.org/r/20241216150450.1228021-1-42.hyeyoo@gmail.com
Link: https://lkml.kernel.org/r/20241216150450.1228021-2-42.hyeyoo@gmail.com
Originally-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
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
+ * @zpdesc: The zpdesc.
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

mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool.patch
mm-zsmalloc-use-zpdesc-in-trylock_zspage-lock_zspage.patch
mm-zsmalloc-convert-create_page_chain-and-its-users-to-use-zpdesc.patch
mm-zsmalloc-convert-reset_page-to-reset_zpdesc.patch
mm-zsmalloc-convert-setzspagemovable-and-remove-unused-funcs.patch
mm-zsmalloc-convert-get-set_first_obj_offset-to-take-zpdesc.patch
mm-zsmalloc-introduce-__zpdesc_clear-set_zsmalloc.patch

