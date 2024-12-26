Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BE713C80D
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249626; cv=none; b=OaWLHrxOFB5vdyuSpHtmwqZtpHXxktZ1KC3jDfdlHC35hLMuSJQ5gI1uYbWM3u61iHn2RPs7KIb1mJZsg7AQejN+aVZaxi5Tj3kvOpBwUC5GnvMq4t/W3k47eGfrilWkR/A6IaooKO1Kt+hb2TnewyB3Jyomf32Y9GA4cM95eO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249626; c=relaxed/simple;
	bh=z0nJ+CG4/KA+uA7dPxWV4GbohcV4aVcgAmubLm8AOoI=;
	h=Date:To:From:Subject:Message-Id; b=dJOK3d163VSK389DNHlE8jNZIB7ZCBycX9eJkS6970Re8UPuVNZiHk50RdELf0T83JRfGxJ0A5nWZSq56rixY91r/IozD8fEUyI7ZHuvmAaV61RgK5c5ubVlCk60guu/WI6p0vBJHS/rk/5BSt0p75SbwJAplRxXdGwmarIclYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YBfJgqtz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YBfJgqtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C543AC4CED1;
	Thu, 26 Dec 2024 21:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249625;
	bh=z0nJ+CG4/KA+uA7dPxWV4GbohcV4aVcgAmubLm8AOoI=;
	h=Date:To:From:Subject:From;
	b=YBfJgqtzYbWRTTatXchKWa6tTtiuGMqonr0HNiBwlARnbUjuSHKACoMFtBSyFO0JJ
	 7Hfl0V3tbGMGnrBYdroXGhCu7aNHB9aj+ECGB1rP/67TtWjPoYLtNXnEZhYr5iyo2A
	 CW9vKhgHc6cVLEkCSKW0g8p2tnznyik6kxaLi3Oc=
Date: Thu, 26 Dec 2024 13:47:05 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-convert-obj_allocated-and-related-helpers-to-use-zpdesc.patch added to mm-unstable branch
Message-Id: <20241226214705.C543AC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: convert obj_allocated() and related helpers to use zpdesc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-convert-obj_allocated-and-related-helpers-to-use-zpdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-convert-obj_allocated-and-related-helpers-to-use-zpdesc.patch

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
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/zsmalloc: convert obj_allocated() and related helpers to use zpdesc
Date: Tue, 17 Dec 2024 00:04:38 +0900

Convert obj_allocated(), and related helpers to take zpdesc.  Also make
its callers to cast (struct page *) to (struct zpdesc *) when calling
them.  The users will be converted gradually as there are many.

Link: https://lkml.kernel.org/r/20241216150450.1228021-8-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-obj_allocated-and-related-helpers-to-use-zpdesc
+++ a/mm/zsmalloc.c
@@ -823,15 +823,15 @@ static unsigned long handle_to_obj(unsig
 	return *(unsigned long *)handle;
 }
 
-static inline bool obj_allocated(struct page *page, void *obj,
+static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
 				 unsigned long *phandle)
 {
 	unsigned long handle;
-	struct zspage *zspage = get_zspage(page);
+	struct zspage *zspage = get_zspage(zpdesc_page(zpdesc));
 
 	if (unlikely(ZsHugePage(zspage))) {
-		VM_BUG_ON_PAGE(!is_first_page(page), page);
-		handle = page->index;
+		VM_BUG_ON_PAGE(!is_first_zpdesc(zpdesc), zpdesc_page(zpdesc));
+		handle = zpdesc->handle;
 	} else
 		handle = *(unsigned long *)obj;
 
@@ -1569,18 +1569,18 @@ static void zs_object_copy(struct size_c
  * return handle.
  */
 static unsigned long find_alloced_obj(struct size_class *class,
-				      struct page *page, int *obj_idx)
+				      struct zpdesc *zpdesc, int *obj_idx)
 {
 	unsigned int offset;
 	int index = *obj_idx;
 	unsigned long handle = 0;
-	void *addr = kmap_local_page(page);
+	void *addr = kmap_local_zpdesc(zpdesc);
 
-	offset = get_first_obj_offset(page);
+	offset = get_first_obj_offset(zpdesc_page(zpdesc));
 	offset += class->size * index;
 
 	while (offset < PAGE_SIZE) {
-		if (obj_allocated(page, addr + offset, &handle))
+		if (obj_allocated(zpdesc, addr + offset, &handle))
 			break;
 
 		offset += class->size;
@@ -1604,7 +1604,7 @@ static void migrate_zspage(struct zs_poo
 	struct size_class *class = pool->size_class[src_zspage->class];
 
 	while (1) {
-		handle = find_alloced_obj(class, s_page, &obj_idx);
+		handle = find_alloced_obj(class, page_zpdesc(s_page), &obj_idx);
 		if (!handle) {
 			s_page = get_next_page(s_page);
 			if (!s_page)
@@ -1837,7 +1837,7 @@ static int zs_page_migrate(struct page *
 
 	for (addr = s_addr + offset; addr < s_addr + PAGE_SIZE;
 					addr += class->size) {
-		if (obj_allocated(page, addr, &handle)) {
+		if (obj_allocated(page_zpdesc(page), addr, &handle)) {
 
 			old_obj = handle_to_obj(handle);
 			obj_to_location(old_obj, &dummy, &obj_idx);
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mm-migrate-remove-slab-checks-in-isolate_movable_page.patch
mm-zsmalloc-convert-__zs_map_object-__zs_unmap_object-to-use-zpdesc.patch
mm-zsmalloc-add-and-use-pfn-zpdesc-seeking-funcs.patch
mm-zsmalloc-convert-obj_malloc-to-use-zpdesc.patch
mm-zsmalloc-convert-obj_allocated-and-related-helpers-to-use-zpdesc.patch
mm-zsmalloc-convert-init_zspage-to-use-zpdesc.patch
mm-zsmalloc-convert-obj_to_page-and-zs_free-to-use-zpdesc.patch
mm-zsmalloc-add-two-helpers-for-zs_page_migrate-and-make-it-use-zpdesc.patch
mm-zsmalloc-convert-__free_zspage-to-use-zpdesc.patch
mm-zsmalloc-convert-location_to_obj-to-take-zpdesc.patch
mm-zsmalloc-convert-migrate_zspage-to-use-zpdesc.patch
mm-zsmalloc-convert-get_zspage-to-take-zpdesc.patch

