Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FC5140E50
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249629; cv=none; b=G4KAaTrw2bxqvexqrYyIXLqrD/0w656CI2QebtKTGzwJFcO9oKHzfjOP5Gheev19fnxVCOM+3jHQe+icH9toohngkbgh5cjWcIzpIJ7y8uloHPouE9w3GF6uHAQw6yOlbuR9njnmsSn+2OPUbZ7sDE6YObJR3xpDrw73HQXt96Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249629; c=relaxed/simple;
	bh=6spVTUCF19ydt6NT+7oxadVcFjK7OeV0PjxMpoaXhQQ=;
	h=Date:To:From:Subject:Message-Id; b=cl8ZBdZJ1p3JB9n2RtH0BLzWNulgGoMq7Der+GGFYzL5YEUKQ/bwhiyCMaLdoXvOf6EC2TAui8uVJ8v25WZFVmxP2TLJhaWwZnZ5v7Vef9g+ZxQzhHj5h95Eoy7/ksbZ6oOmtNHrFV2FZ5emTVGzE/rzcXxFop2XNEg0aUSuYgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BB5muwR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BB5muwR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C38C4CED1;
	Thu, 26 Dec 2024 21:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249629;
	bh=6spVTUCF19ydt6NT+7oxadVcFjK7OeV0PjxMpoaXhQQ=;
	h=Date:To:From:Subject:From;
	b=BB5muwR5RS+723fPjiNfOoUQAXjKaVuYxGA2QzySbAcST9WPq8+s5fI4ptlBbqGYp
	 iQgIGn7UEnH2udImqGdHfn0O0+TH/JypvhaYqRkzqXqpWT6msp6PCN1lulRPqlvUTO
	 C320fxH93X3JJDPBEQwPHl4SxKIh/e0D/DZPTzP0=
Date: Thu, 26 Dec 2024 13:47:09 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-convert-obj_to_page-and-zs_free-to-use-zpdesc.patch added to mm-unstable branch
Message-Id: <20241226214709.98C38C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: convert obj_to_page() and zs_free() to use zpdesc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-convert-obj_to_page-and-zs_free-to-use-zpdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-convert-obj_to_page-and-zs_free-to-use-zpdesc.patch

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
Subject: mm/zsmalloc: convert obj_to_page() and zs_free() to use zpdesc
Date: Tue, 17 Dec 2024 00:04:40 +0900

Rename obj_to_page() to obj_to_zpdesc() and also convert it and its user
zs_free() to use zpdesc.

Link: https://lkml.kernel.org/r/20241216150450.1228021-10-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-obj_to_page-and-zs_free-to-use-zpdesc
+++ a/mm/zsmalloc.c
@@ -798,9 +798,9 @@ static void obj_to_location(unsigned lon
 	*obj_idx = (obj & OBJ_INDEX_MASK);
 }
 
-static void obj_to_page(unsigned long obj, struct page **page)
+static void obj_to_zpdesc(unsigned long obj, struct zpdesc **zpdesc)
 {
-	*page = pfn_to_page(obj >> OBJ_INDEX_BITS);
+	*zpdesc = pfn_zpdesc(obj >> OBJ_INDEX_BITS);
 }
 
 /**
@@ -1462,7 +1462,7 @@ static void obj_free(int class_size, uns
 void zs_free(struct zs_pool *pool, unsigned long handle)
 {
 	struct zspage *zspage;
-	struct page *f_page;
+	struct zpdesc *f_zpdesc;
 	unsigned long obj;
 	struct size_class *class;
 	int fullness;
@@ -1476,8 +1476,8 @@ void zs_free(struct zs_pool *pool, unsig
 	 */
 	read_lock(&pool->migrate_lock);
 	obj = handle_to_obj(handle);
-	obj_to_page(obj, &f_page);
-	zspage = get_zspage(f_page);
+	obj_to_zpdesc(obj, &f_zpdesc);
+	zspage = get_zspage(zpdesc_page(f_zpdesc));
 	class = zspage_class(pool, zspage);
 	spin_lock(&class->lock);
 	read_unlock(&pool->migrate_lock);
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

