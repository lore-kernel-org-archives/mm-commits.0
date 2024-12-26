Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E22615CD52
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249638; cv=none; b=OrWGN4b45k9tSqFCtcZIMWxSQqgELJSYgy9jdToD4XBuYq/aG7UjwObe8lzfsvqmZL5t+rn57Yp/J60Plz24fWOZUUV9H/vcN4ySpmpHTv2xYo2HpNF3/rf9kkUQARq4P5kKNSeWOdAsOnNGY0/bU+cxMToZkBIIFKafZBgG808=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249638; c=relaxed/simple;
	bh=08Xhk/cx9Asr0wgWiGgooxDaoj4MIqUva1wQ9/pgRL8=;
	h=Date:To:From:Subject:Message-Id; b=HzSpI3fAKzUHGk/4l5mDFfu9Y/RVaCdiWArERm2x8fxnr3m2u5quvYFAKY0PDaoUvLiZTIDBwpYoS/ptMCSQS4QCePRCSbRGDgzkrYfwZlczflnI+Gmz9xrGy8W6uSKqomu+9ft1LkoxW70ihuyy+5HGdnriV5EMI+6XK2WyEwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2uzxKN3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2uzxKN3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFAAC4CED1;
	Thu, 26 Dec 2024 21:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249638;
	bh=08Xhk/cx9Asr0wgWiGgooxDaoj4MIqUva1wQ9/pgRL8=;
	h=Date:To:From:Subject:From;
	b=2uzxKN3E5iGnmKh1dXbVjGFKoJKe0Uf3CaM/HpLhvvwGwPT8+c32T498K+z5nn6iP
	 bIonqHmKN3lU8NF6zgkQA4qxQY8ywXM/jAzqiJ9bdJcs/3bTwyoZ/jJepKH+zwY4ac
	 94Jo2uewstzKJHhElPnw16UxEw7FPmev7BCTN6Lw=
Date: Thu, 26 Dec 2024 13:47:17 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-convert-location_to_obj-to-take-zpdesc.patch added to mm-unstable branch
Message-Id: <20241226214718.2FFAAC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: convert location_to_obj() to take zpdesc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-convert-location_to_obj-to-take-zpdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-convert-location_to_obj-to-take-zpdesc.patch

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
Subject: mm/zsmalloc: convert location_to_obj() to take zpdesc
Date: Tue, 17 Dec 2024 00:04:44 +0900

As all users of location_to_obj() now use zpdesc, convert
location_to_obj() to take zpdesc.

Link: https://lkml.kernel.org/r/20241216150450.1228021-14-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-location_to_obj-to-take-zpdesc
+++ a/mm/zsmalloc.c
@@ -804,15 +804,15 @@ static void obj_to_zpdesc(unsigned long
 }
 
 /**
- * location_to_obj - get obj value encoded from (<page>, <obj_idx>)
- * @page: page object resides in zspage
+ * location_to_obj - get obj value encoded from (<zpdesc>, <obj_idx>)
+ * @zpdesc: zpdesc object resides in zspage
  * @obj_idx: object index
  */
-static unsigned long location_to_obj(struct page *page, unsigned int obj_idx)
+static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int obj_idx)
 {
 	unsigned long obj;
 
-	obj = page_to_pfn(page) << OBJ_INDEX_BITS;
+	obj = zpdesc_pfn(zpdesc) << OBJ_INDEX_BITS;
 	obj |= obj_idx & OBJ_INDEX_MASK;
 
 	return obj;
@@ -1358,7 +1358,7 @@ static unsigned long obj_malloc(struct z
 	kunmap_local(vaddr);
 	mod_zspage_inuse(zspage, 1);
 
-	obj = location_to_obj(zpdesc_page(m_zpdesc), obj);
+	obj = location_to_obj(m_zpdesc, obj);
 	record_obj(handle, obj);
 
 	return obj;
@@ -1845,8 +1845,7 @@ static int zs_page_migrate(struct page *
 
 			old_obj = handle_to_obj(handle);
 			obj_to_location(old_obj, &dummy, &obj_idx);
-			new_obj = (unsigned long)location_to_obj(zpdesc_page(newzpdesc),
-								obj_idx);
+			new_obj = (unsigned long)location_to_obj(newzpdesc, obj_idx);
 			record_obj(handle, new_obj);
 		}
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

