Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16277140E50
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249636; cv=none; b=N8CoYNT/t7uYuB1YIHoMIsPKxmJjZHZ9o/Ffx+oecbQlHwvNFHnF/1mRuo/yCi9aX5KkF/NerKgJwjDBxoyJtm/IDkRkx4r0dAC4/83uyMzJAxpZ4aLB7rtsX6mSfJaFRIJSYrnAPcjOql+UK3XnoRUz66kRAAMxcJN4dZr6bUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249636; c=relaxed/simple;
	bh=XZ7UOKSCkT7cQOeYejKVX1QxWaI36JM+6fQq5MAMC4Y=;
	h=Date:To:From:Subject:Message-Id; b=d7YBuOJxLjrBsgZRvbF8GjY0r+eKP+GdqWezUJTnwdA1ncuy2ceaj13F8gHzllKOaD18VppOS3p+WV6vfE7AQyCtMXngTvquuCB4sxlkf20iFWs0H9Bo4f7ynv4uXlGI4UWOtzU9Oc78zc1Ov9NNtW6jDcmQi4ok3PYt5MVsYtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e1+uvzKc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e1+uvzKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D878DC4CED1;
	Thu, 26 Dec 2024 21:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249635;
	bh=XZ7UOKSCkT7cQOeYejKVX1QxWaI36JM+6fQq5MAMC4Y=;
	h=Date:To:From:Subject:From;
	b=e1+uvzKceIM5k61xpr3S9dPJv1sXEXdQ16rDWCZ1eImB50oSdDanXGYuNi10wvd29
	 XLvbIa69YRK2yppB3BymrEgEHCI1QRRcs7DL01cl/6b+0wYbYMvEpx6UOR4udbapPv
	 QH5V3B5eSZ8pEpZQw6CStYhPQGBkT0wy3neheKSc=
Date: Thu, 26 Dec 2024 13:47:15 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-convert-__free_zspage-to-use-zpdesc.patch added to mm-unstable branch
Message-Id: <20241226214715.D878DC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: convert __free_zspage() to use zpdesc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-convert-__free_zspage-to-use-zpdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-convert-__free_zspage-to-use-zpdesc.patch

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
Subject: mm/zsmalloc: convert __free_zspage() to use zpdesc
Date: Tue, 17 Dec 2024 00:04:43 +0900

Introduce zpdesc_is_locked() and convert __free_zspage() to use zpdesc.

Link: https://lkml.kernel.org/r/20241216150450.1228021-13-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Alex Shi <alexs@kernel.org>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpdesc.h   |    4 ++++
 mm/zsmalloc.c |   20 ++++++++++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

--- a/mm/zpdesc.h~mm-zsmalloc-convert-__free_zspage-to-use-zpdesc
+++ a/mm/zpdesc.h
@@ -165,4 +165,8 @@ static inline struct zone *zpdesc_zone(s
 	return page_zone(zpdesc_page(zpdesc));
 }
 
+static inline bool zpdesc_is_locked(struct zpdesc *zpdesc)
+{
+	return folio_test_locked(zpdesc_folio(zpdesc));
+}
 #endif
--- a/mm/zsmalloc.c~mm-zsmalloc-convert-__free_zspage-to-use-zpdesc
+++ a/mm/zsmalloc.c
@@ -878,23 +878,23 @@ unlock:
 static void __free_zspage(struct zs_pool *pool, struct size_class *class,
 				struct zspage *zspage)
 {
-	struct page *page, *next;
+	struct zpdesc *zpdesc, *next;
 
 	assert_spin_locked(&class->lock);
 
 	VM_BUG_ON(get_zspage_inuse(zspage));
 	VM_BUG_ON(zspage->fullness != ZS_INUSE_RATIO_0);
 
-	next = page = get_first_page(zspage);
+	next = zpdesc = get_first_zpdesc(zspage);
 	do {
-		VM_BUG_ON_PAGE(!PageLocked(page), page);
-		next = get_next_page(page);
-		reset_zpdesc(page_zpdesc(page));
-		unlock_page(page);
-		dec_zone_page_state(page, NR_ZSPAGES);
-		put_page(page);
-		page = next;
-	} while (page != NULL);
+		VM_BUG_ON_PAGE(!zpdesc_is_locked(zpdesc), zpdesc_page(zpdesc));
+		next = get_next_zpdesc(zpdesc);
+		reset_zpdesc(zpdesc);
+		zpdesc_unlock(zpdesc);
+		zpdesc_dec_zone_page_state(zpdesc);
+		zpdesc_put(zpdesc);
+		zpdesc = next;
+	} while (zpdesc != NULL);
 
 	cache_free_zspage(pool, zspage);
 
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

