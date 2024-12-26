Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E8515CD52
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249640; cv=none; b=W93LjExYUJVl7L/NxCsXJ+tevhRY+GRbvLgS+CcQAI3Rmt4PqhBf2AW2Xghjx2HLx15Gadf3F+gN6SEwETRi2YAn3k5T2amnnm0SxrjYcuTiZWpax7YtvQT+MqGkfUrW3zcd4i9vWP+whD16toosLxEbpZPhaLRtCbOvW5UAESQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249640; c=relaxed/simple;
	bh=h1/EExEmFyKKkb1xFhuQncrHJ24qic5iDn+rM1gp0BY=;
	h=Date:To:From:Subject:Message-Id; b=Yh1KksW6XxsqJR7rfqSB7FjmZ8/GlPuDbwrAHhrufcYgF4anMJuZOr3suXzaDhwKEJVTRtCWE7DhO1S6P/113mVOtpxaTbOfdeWxddK2y3uQl7f5ffO7f1ldWRWrMTsRkk/lOsUeS23rb8RLXAp3nnxViX+gVeMB6W+s3j+8KUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GsEPtGj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GsEPtGj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8F0C4CED1;
	Thu, 26 Dec 2024 21:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249640;
	bh=h1/EExEmFyKKkb1xFhuQncrHJ24qic5iDn+rM1gp0BY=;
	h=Date:To:From:Subject:From;
	b=GsEPtGj4UvLACmZo3J2Vf7RQ59GpKVxIqdwbuYWIEPF3NW6us4+4IIm/rJII28yYf
	 Zy1JGrh98wqUohtBUi4Gg/b95ErBMvn9q2vZ8YEKTs7aSnTASYAAY7A5ATwTdn3MZX
	 3tiNVK6Nk+XlWm/KWO82ElqjcBzoIi6Sa484yZPo=
Date: Thu, 26 Dec 2024 13:47:19 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-convert-migrate_zspage-to-use-zpdesc.patch added to mm-unstable branch
Message-Id: <20241226214720.1E8F0C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: convert migrate_zspage() to use zpdesc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-convert-migrate_zspage-to-use-zpdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-convert-migrate_zspage-to-use-zpdesc.patch

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
Subject: mm/zsmalloc: convert migrate_zspage() to use zpdesc
Date: Tue, 17 Dec 2024 00:04:45 +0900

Use get_first_zpdesc/get_next_zpdesc to replace get_first/next_page. No
functional change.

Link: https://lkml.kernel.org/r/20241216150450.1228021-15-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-migrate_zspage-to-use-zpdesc
+++ a/mm/zsmalloc.c
@@ -1602,14 +1602,14 @@ static void migrate_zspage(struct zs_poo
 	unsigned long used_obj, free_obj;
 	unsigned long handle;
 	int obj_idx = 0;
-	struct page *s_page = get_first_page(src_zspage);
+	struct zpdesc *s_zpdesc = get_first_zpdesc(src_zspage);
 	struct size_class *class = pool->size_class[src_zspage->class];
 
 	while (1) {
-		handle = find_alloced_obj(class, page_zpdesc(s_page), &obj_idx);
+		handle = find_alloced_obj(class, s_zpdesc, &obj_idx);
 		if (!handle) {
-			s_page = get_next_page(s_page);
-			if (!s_page)
+			s_zpdesc = get_next_zpdesc(s_zpdesc);
+			if (!s_zpdesc)
 				break;
 			obj_idx = 0;
 			continue;
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

