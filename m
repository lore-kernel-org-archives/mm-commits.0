Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A293B7346F
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006237; cv=none; b=RJykHLAdwcaNLtXT+b8uOG9PWEBNFNEeGwiEQppYd5HtsOO8QNVdh50eRsvlni3TFF8bCkrt/ZSxUC/PRL9CmFksn90ewmdJox7D7wHXCWFsHRcPfatB4dvQ+GJSg5uHQvrMC0munrC7ySXBJ8vow/lfw7Gkx8zmNkzrJf47bpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006237; c=relaxed/simple;
	bh=hZftCTCoTcUAH4ce8WH2VsRqP+UV7Qh6oQDgoOoXSrA=;
	h=Date:To:From:Subject:Message-Id; b=LujSPEGXI1XrH/ljbQa1b4MJIhU66Ig7dVmIveyNesYTPYCs+TnwWTFiUVG3SS24+k0B/zEvESIqre61HUSzils3G6aDUO1v8jHU/i86HylIRtxZTWToqaw8V/Qinv/fchmkL1426HpmCG5zcAtv9fqqZjU+G4PxtxAA6t/pBuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oVMRGPdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oVMRGPdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A156C4CED6;
	Thu, 16 Jan 2025 05:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006237;
	bh=hZftCTCoTcUAH4ce8WH2VsRqP+UV7Qh6oQDgoOoXSrA=;
	h=Date:To:From:Subject:From;
	b=oVMRGPdSRe8QgXsE4wQcZgDzb9dsEa6EX5eYz6BzOpnyRIHqR0oY8MOByvHOM+2AW
	 DclOJJ6mwhxdhzVJAeX7yr/WSGpzmal8CYZgzkrU1x2rO0mNZcJ8btqNDxB4G2IP20
	 alla2VdB8Hx151TF00zAdSMyKrVKlk9SeVMUVI5s=
Date: Wed, 15 Jan 2025 21:43:56 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,42.hyeyoo@gmail.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-convert-get-set_first_obj_offset-to-take-zpdesc.patch removed from -mm tree
Message-Id: <20250116054357.7A156C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: convert get/set_first_obj_offset() to take zpdesc
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-convert-get-set_first_obj_offset-to-take-zpdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


