Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E3218B477
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249647; cv=none; b=bvLhsHe73UO3vztRhQpXyIQQgrlA7rlCBvlkcxL5PpBOb61rhsMoveGfWHRUiIiaLoVJEP5OwXHTiKLCv2aLncw9oZMQqrLt+0GmH64iFmsP6XgHM60Y4bORL/bo/B5PcF6A5DCsQyfj4w/pe88NHq8xLiGPJ8Jr2HIzPDxdvB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249647; c=relaxed/simple;
	bh=aOhtwCb5qycI4e/n+2qA54I5ocn/oODQc/qauto1bc4=;
	h=Date:To:From:Subject:Message-Id; b=VMUKn0Hr/fhWhi/oT7IHcxLGH9XWawcVjxaWC6m+3OfAfsWWFsI4NEwVYq+XwuLgzewcr8QTFp0wKdbCFo/E5sRAfU2eZdR8rYallkvx/IMwESV7cCQQ57/Quc/kPgMZSze5443a4CwBgsEe+5xhOkqguZ+MTZqYKlD7WSmA+f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eUwbTaat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eUwbTaat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB06C4CED1;
	Thu, 26 Dec 2024 21:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249646;
	bh=aOhtwCb5qycI4e/n+2qA54I5ocn/oODQc/qauto1bc4=;
	h=Date:To:From:Subject:From;
	b=eUwbTaatMvYTU28iKzz47D71sETU0/vQWS+Qp0qjsMr99R/fQ0cYuNPOHOeWMhadF
	 nsDHolPNiWQ0Yq6jsW8CXxaFa6MgIge1/Ccx/WoYZK9JDOrLHDuEAUbHA6xHtXK1Gs
	 gMQJIbZrEiDbYcx9JULND8l4kN/1oxvrcApUrzjo=
Date: Thu, 26 Dec 2024 13:47:25 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,42.hyeyoo@gmail.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-convert-get-set_first_obj_offset-to-take-zpdesc.patch added to mm-unstable branch
Message-Id: <20241226214725.EFB06C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: convert get/set_first_obj_offset() to take zpdesc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-convert-get-set_first_obj_offset-to-take-zpdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-convert-get-set_first_obj_offset-to-take-zpdesc.patch

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
Subject: mm/zsmalloc: convert get/set_first_obj_offset() to take zpdesc
Date: Tue, 17 Dec 2024 00:04:48 +0900

Now that all users of get/set_first_obj_offset() are converted to use
zpdesc, convert them to take zpdesc.

Link: https://lkml.kernel.org/r/20241216150450.1228021-18-42.hyeyoo@gmail.com
Signed-off-by: Alex Shi <alexs@kernel.org>
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-get-set_first_obj_offset-to-take-zpdesc
+++ a/mm/zsmalloc.c
@@ -478,20 +478,20 @@ static struct zpdesc *get_first_zpdesc(s
 
 #define FIRST_OBJ_PAGE_TYPE_MASK	0xffffff
 
-static inline unsigned int get_first_obj_offset(struct page *page)
+static inline unsigned int get_first_obj_offset(struct zpdesc *zpdesc)
 {
-	VM_WARN_ON_ONCE(!PageZsmalloc(page));
-	return page->page_type & FIRST_OBJ_PAGE_TYPE_MASK;
+	VM_WARN_ON_ONCE(!PageZsmalloc(zpdesc_page(zpdesc)));
+	return zpdesc->first_obj_offset & FIRST_OBJ_PAGE_TYPE_MASK;
 }
 
-static inline void set_first_obj_offset(struct page *page, unsigned int offset)
+static inline void set_first_obj_offset(struct zpdesc *zpdesc, unsigned int offset)
 {
 	/* With 24 bits available, we can support offsets into 16 MiB pages. */
 	BUILD_BUG_ON(PAGE_SIZE > SZ_16M);
-	VM_WARN_ON_ONCE(!PageZsmalloc(page));
+	VM_WARN_ON_ONCE(!PageZsmalloc(zpdesc_page(zpdesc)));
 	VM_WARN_ON_ONCE(offset & ~FIRST_OBJ_PAGE_TYPE_MASK);
-	page->page_type &= ~FIRST_OBJ_PAGE_TYPE_MASK;
-	page->page_type |= offset & FIRST_OBJ_PAGE_TYPE_MASK;
+	zpdesc->first_obj_offset &= ~FIRST_OBJ_PAGE_TYPE_MASK;
+	zpdesc->first_obj_offset |= offset & FIRST_OBJ_PAGE_TYPE_MASK;
 }
 
 static inline unsigned int get_freeobj(struct zspage *zspage)
@@ -911,7 +911,7 @@ static void init_zspage(struct size_clas
 		struct link_free *link;
 		void *vaddr;
 
-		set_first_obj_offset(zpdesc_page(zpdesc), off);
+		set_first_obj_offset(zpdesc, off);
 
 		vaddr = kmap_local_zpdesc(zpdesc);
 		link = (struct link_free *)vaddr + off / sizeof(*link);
@@ -1555,7 +1555,7 @@ static unsigned long find_alloced_obj(st
 	unsigned long handle = 0;
 	void *addr = kmap_local_zpdesc(zpdesc);
 
-	offset = get_first_obj_offset(zpdesc_page(zpdesc));
+	offset = get_first_obj_offset(zpdesc);
 	offset += class->size * index;
 
 	while (offset < PAGE_SIZE) {
@@ -1750,8 +1750,8 @@ static void replace_sub_page(struct size
 	} while ((zpdesc = get_next_zpdesc(zpdesc)) != NULL);
 
 	create_page_chain(class, zspage, zpdescs);
-	first_obj_offset = get_first_obj_offset(zpdesc_page(oldzpdesc));
-	set_first_obj_offset(zpdesc_page(newzpdesc), first_obj_offset);
+	first_obj_offset = get_first_obj_offset(oldzpdesc);
+	set_first_obj_offset(newzpdesc, first_obj_offset);
 	if (unlikely(ZsHugePage(zspage)))
 		newzpdesc->handle = oldzpdesc->handle;
 	__zpdesc_set_movable(newzpdesc, &zsmalloc_mops);
@@ -1806,7 +1806,7 @@ static int zs_page_migrate(struct page *
 	/* the migrate_write_lock protects zpage access via zs_map_object */
 	migrate_write_lock(zspage);
 
-	offset = get_first_obj_offset(zpdesc_page(zpdesc));
+	offset = get_first_obj_offset(zpdesc);
 	s_addr = kmap_local_zpdesc(zpdesc);
 
 	/*
_

Patches currently in -mm which might be from alexs@kernel.org are

mm-zsmalloc-add-zpdesc-memory-descriptor-for-zswapzpool.patch
mm-zsmalloc-use-zpdesc-in-trylock_zspage-lock_zspage.patch
mm-zsmalloc-convert-create_page_chain-and-its-users-to-use-zpdesc.patch
mm-zsmalloc-convert-reset_page-to-reset_zpdesc.patch
mm-zsmalloc-convert-setzspagemovable-and-remove-unused-funcs.patch
mm-zsmalloc-convert-get-set_first_obj_offset-to-take-zpdesc.patch
mm-zsmalloc-introduce-__zpdesc_clear-set_zsmalloc.patch

