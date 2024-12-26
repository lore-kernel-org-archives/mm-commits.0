Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3279619341F
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249642; cv=none; b=Rr+7gqrRG326POwb8h8LY36KJ+MX5YEf9fo6DVXQeQ4fE3bbmpAE/QuEvQeT1tFQ070TcDkfq3li8+oZ2elaQw7BNj15vrMqxBxsbSoAUPUAMSoGWprqeP0ZuO+YEo5QqzbB7Phl840N6thoINgpDutkPqGyPBofvMG8dpFEVoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249642; c=relaxed/simple;
	bh=IZ75hlJDkyiUsWbjgWVo/k5ITsE/K9HAIT4vCaHC3VU=;
	h=Date:To:From:Subject:Message-Id; b=WP0wcmkwULH2390UJokv0w9+F7o8tIAYXA4tvbzpIpMB8srTzPdBW23lJ/cKlk64EY65UxvEY0sGo6lpmJ6lw8m1gXbiwWj4jLv8KWr9V9PSfZq3PXsnO76pG8dg8LIxJ1lvYOtx9meYEo15+j0G/hcp9N2nK4vhMByTlTLUh84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vzxeaa2B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vzxeaa2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07850C4CED1;
	Thu, 26 Dec 2024 21:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249642;
	bh=IZ75hlJDkyiUsWbjgWVo/k5ITsE/K9HAIT4vCaHC3VU=;
	h=Date:To:From:Subject:From;
	b=vzxeaa2BvzeWBceHOwZsVUYNlSreLfEFOHFtc3GH73/lYeOxB57LDq4sAXw7HKpaN
	 265zgMCVW28VLHyhDkARb/Bm5T2671Ry/BWu4FxnqKwBNsgcCnzbQz58v63g24AFFL
	 1xjDpxPohdST52mJd7v8eytd6EbnQpQ40BCdwqkI=
Date: Thu, 26 Dec 2024 13:47:21 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-convert-get_zspage-to-take-zpdesc.patch added to mm-unstable branch
Message-Id: <20241226214722.07850C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: convert get_zspage() to take zpdesc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-convert-get_zspage-to-take-zpdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-convert-get_zspage-to-take-zpdesc.patch

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
Subject: mm/zsmalloc: convert get_zspage() to take zpdesc
Date: Tue, 17 Dec 2024 00:04:46 +0900

Now that all users except get_next_page() (which will be removed in later
patch) use zpdesc, convert get_zspage() to take zpdesc instead of page.

Link: https://lkml.kernel.org/r/20241216150450.1228021-16-42.hyeyoo@gmail.com
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

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-get_zspage-to-take-zpdesc
+++ a/mm/zsmalloc.c
@@ -757,9 +757,9 @@ out:
 	return newfg;
 }
 
-static struct zspage *get_zspage(struct page *page)
+static struct zspage *get_zspage(struct zpdesc *zpdesc)
 {
-	struct zspage *zspage = (struct zspage *)page_private(page);
+	struct zspage *zspage = zpdesc->zspage;
 
 	BUG_ON(zspage->magic != ZSPAGE_MAGIC);
 	return zspage;
@@ -767,7 +767,7 @@ static struct zspage *get_zspage(struct
 
 static struct page *get_next_page(struct page *page)
 {
-	struct zspage *zspage = get_zspage(page);
+	struct zspage *zspage = get_zspage(page_zpdesc(page));
 
 	if (unlikely(ZsHugePage(zspage)))
 		return NULL;
@@ -777,7 +777,7 @@ static struct page *get_next_page(struct
 
 static struct zpdesc *get_next_zpdesc(struct zpdesc *zpdesc)
 {
-	struct zspage *zspage = get_zspage(zpdesc_page(zpdesc));
+	struct zspage *zspage = get_zspage(zpdesc);
 
 	if (unlikely(ZsHugePage(zspage)))
 		return NULL;
@@ -827,7 +827,7 @@ static inline bool obj_allocated(struct
 				 unsigned long *phandle)
 {
 	unsigned long handle;
-	struct zspage *zspage = get_zspage(zpdesc_page(zpdesc));
+	struct zspage *zspage = get_zspage(zpdesc);
 
 	if (unlikely(ZsHugePage(zspage))) {
 		VM_BUG_ON_PAGE(!is_first_zpdesc(zpdesc), zpdesc_page(zpdesc));
@@ -1232,7 +1232,7 @@ void *zs_map_object(struct zs_pool *pool
 	read_lock(&pool->migrate_lock);
 	obj = handle_to_obj(handle);
 	obj_to_location(obj, &zpdesc, &obj_idx);
-	zspage = get_zspage(zpdesc_page(zpdesc));
+	zspage = get_zspage(zpdesc);
 
 	/*
 	 * migration cannot move any zpages in this zspage. Here, class->lock
@@ -1282,7 +1282,7 @@ void zs_unmap_object(struct zs_pool *poo
 
 	obj = handle_to_obj(handle);
 	obj_to_location(obj, &zpdesc, &obj_idx);
-	zspage = get_zspage(zpdesc_page(zpdesc));
+	zspage = get_zspage(zpdesc);
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
 
@@ -1445,7 +1445,7 @@ static void obj_free(int class_size, uns
 
 	obj_to_location(obj, &f_zpdesc, &f_objidx);
 	f_offset = offset_in_page(class_size * f_objidx);
-	zspage = get_zspage(zpdesc_page(f_zpdesc));
+	zspage = get_zspage(f_zpdesc);
 
 	vaddr = kmap_local_zpdesc(f_zpdesc);
 	link = (struct link_free *)(vaddr + f_offset);
@@ -1479,7 +1479,7 @@ void zs_free(struct zs_pool *pool, unsig
 	read_lock(&pool->migrate_lock);
 	obj = handle_to_obj(handle);
 	obj_to_zpdesc(obj, &f_zpdesc);
-	zspage = get_zspage(zpdesc_page(f_zpdesc));
+	zspage = get_zspage(f_zpdesc);
 	class = zspage_class(pool, zspage);
 	spin_lock(&class->lock);
 	read_unlock(&pool->migrate_lock);
@@ -1812,7 +1812,7 @@ static int zs_page_migrate(struct page *
 	__SetPageZsmalloc(zpdesc_page(newzpdesc));
 
 	/* The page is locked, so this pointer must remain valid */
-	zspage = get_zspage(zpdesc_page(zpdesc));
+	zspage = get_zspage(zpdesc);
 	pool = zspage->pool;
 
 	/*
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

