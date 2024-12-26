Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F361474B7
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249629; cv=none; b=Wp6u935mrsG1z3L/bqho//0YasRbhfVtd2b2z8sHJOItnYlbfj1zKeEzkqjWTZOEvDS2h4VnkpjTh4ReRqv2TWjJMXXvq0ru0j7NwVdLxb98Bfjmj1V7Qq51aPkYy2NllPOaCwHOcrELwqDV6SrODR4KHsQLjecePxCMKrBN7Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249629; c=relaxed/simple;
	bh=h77DRAB54hZTw+TKgxkQw2r30d+HvVaU5VBNWIO/gJI=;
	h=Date:To:From:Subject:Message-Id; b=QR/bd7/OcTFPlJN+3Yj6oVx0vocynUvL88ao7kgj0dLSTkG1XNU5XNZPEy+osv7W1vBemZevQOv+yb2g8S1GB9plgCo/FSWNChC6cNELNyyxYzjURd6RxKlBh5fE/2jKbyzTw24xuheCoA/WHDudUX28otY5/o+LTLc8VxqXs0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kcig348A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kcig348A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFBDC4CED1;
	Thu, 26 Dec 2024 21:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249627;
	bh=h77DRAB54hZTw+TKgxkQw2r30d+HvVaU5VBNWIO/gJI=;
	h=Date:To:From:Subject:From;
	b=kcig348Ahh1NaR27DwzZY9HuaH1GKejwhMH38b41OyTSzISyAQgGFkR+hyXbRUxNq
	 gq2cXXc+drt51jNjYS07spIoel5zO6RXl7EBAY2Vs7KRnn8VMbiLi9Ag/oZMqISBk4
	 iUWuySZHG9bFcCQkfeM2mmJBeE5G7Tq+cxS9o47Q=
Date: Thu, 26 Dec 2024 13:47:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-convert-init_zspage-to-use-zpdesc.patch added to mm-unstable branch
Message-Id: <20241226214707.BAFBDC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: convert init_zspage() to use zpdesc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-convert-init_zspage-to-use-zpdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-convert-init_zspage-to-use-zpdesc.patch

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
Subject: mm/zsmalloc: convert init_zspage() to use zpdesc
Date: Tue, 17 Dec 2024 00:04:39 +0900

Replace get_first/next_page func series and kmap_atomic to new helper, no
functional change.

Link: https://lkml.kernel.org/r/20241216150450.1228021-9-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-init_zspage-to-use-zpdesc
+++ a/mm/zsmalloc.c
@@ -925,16 +925,16 @@ static void init_zspage(struct size_clas
 {
 	unsigned int freeobj = 1;
 	unsigned long off = 0;
-	struct page *page = get_first_page(zspage);
+	struct zpdesc *zpdesc = get_first_zpdesc(zspage);
 
-	while (page) {
-		struct page *next_page;
+	while (zpdesc) {
+		struct zpdesc *next_zpdesc;
 		struct link_free *link;
 		void *vaddr;
 
-		set_first_obj_offset(page, off);
+		set_first_obj_offset(zpdesc_page(zpdesc), off);
 
-		vaddr = kmap_local_page(page);
+		vaddr = kmap_local_zpdesc(zpdesc);
 		link = (struct link_free *)vaddr + off / sizeof(*link);
 
 		while ((off += class->size) < PAGE_SIZE) {
@@ -947,8 +947,8 @@ static void init_zspage(struct size_clas
 		 * page, which must point to the first object on the next
 		 * page (if present)
 		 */
-		next_page = get_next_page(page);
-		if (next_page) {
+		next_zpdesc = get_next_zpdesc(zpdesc);
+		if (next_zpdesc) {
 			link->next = freeobj++ << OBJ_TAG_BITS;
 		} else {
 			/*
@@ -958,7 +958,7 @@ static void init_zspage(struct size_clas
 			link->next = -1UL << OBJ_TAG_BITS;
 		}
 		kunmap_local(vaddr);
-		page = next_page;
+		zpdesc = next_zpdesc;
 		off %= PAGE_SIZE;
 	}
 
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

