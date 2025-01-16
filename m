Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850E77346F
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006229; cv=none; b=g9PHFdaxu6OcPLYa1/7MTg2cj8RicJz1CumD/Dt+erkxQU2Kr2RbhL0pIYcNyibgTnB8t19JJwE5eeEN+0BISw3XhgP7CfcpbCv74ZwSEWdU9nv0oBm2zuJfm6XoUw8fuaRRqQP55S7DHuPIUqAfz4kenrc6GTsv1xvA2W3MjrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006229; c=relaxed/simple;
	bh=NbApBDiKuSvtRiaP5dcyzofNy/xGrXcNqOWuCFjZLuc=;
	h=Date:To:From:Subject:Message-Id; b=Jlvy/biFHKYRCBnk/dd+07a0p2/sJfkS6S34+g03iXodhf7nPLvCiprB88k4j1ckBEasbM3PCNYlPWqoqZ+P2cMlKptXcC1zUG23PzXGRz3SSkf7UprVfpiqm3F+G68Gdl0yQ5T5Whv3sWqCh20EgSuN3wP4hzJEdaE/kErNBJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QGJ62bOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QGJ62bOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BB4C4CED6;
	Thu, 16 Jan 2025 05:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006229;
	bh=NbApBDiKuSvtRiaP5dcyzofNy/xGrXcNqOWuCFjZLuc=;
	h=Date:To:From:Subject:From;
	b=QGJ62bOLgc04vPQeagQXy+yfIZMBjXvUz9WjS40hg80LWe9PtfauzfIbWa00mSoTu
	 e1kllrCt1cF/kDGhETxAwKWWt30emjdlx30UIkQGgp1IWm83fwRERulAFRl/1aR/HI
	 23PmxJR1HA6VbTPfuJXeJlS1CDN9UgmoGxhDguKw=
Date: Wed, 15 Jan 2025 21:43:48 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,42.hyeyoo@gmail.com,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-convert-reset_page-to-reset_zpdesc.patch removed from -mm tree
Message-Id: <20250116054349.58BB4C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: convert reset_page to reset_zpdesc
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-convert-reset_page-to-reset_zpdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alex Shi <alexs@kernel.org>
Subject: mm/zsmalloc: convert reset_page to reset_zpdesc
Date: Tue, 17 Dec 2024 00:04:42 +0900

zpdesc.zspage matches with page.private, zpdesc.next matches with
page.index.  They will be reset in reset_page() which is called prior to
free base pages of a zspage.

Since the fields that need to be initialized are independent of the order
in struct zpdesc, Keep it to use struct page to ensure robustness against
potential rearrangements of struct zpdesc fields in the future.

[42.hyeyoo@gmail.com: reset zpdesc fields in reset_zpdesc()]
  Link: https://lkml.kernel.org/r/Z4Uw136VdG7vlKCL@localhost.localdomain
[42.hyeyoo@gmail.com: keep reset_zpdesc() to use struct page fields]
Link: https://lkml.kernel.org/r/20241216150450.1228021-12-42.hyeyoo@gmail.com
Signed-off-by: Alex Shi <alexs@kernel.org>
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-reset_page-to-reset_zpdesc
+++ a/mm/zsmalloc.c
@@ -843,12 +843,14 @@ static inline bool obj_allocated(struct
 	return true;
 }
 
-static void reset_page(struct page *page)
+static void reset_zpdesc(struct zpdesc *zpdesc)
 {
+	struct page *page = zpdesc_page(zpdesc);
+
 	__ClearPageMovable(page);
 	ClearPagePrivate(page);
-	set_page_private(page, 0);
-	page->index = 0;
+	zpdesc->zspage = NULL;
+	zpdesc->next = NULL;
 	__ClearPageZsmalloc(page);
 }
 
@@ -887,7 +889,7 @@ static void __free_zspage(struct zs_pool
 	do {
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
 		next = get_next_page(page);
-		reset_page(page);
+		reset_zpdesc(page_zpdesc(page));
 		unlock_page(page);
 		dec_zone_page_state(page, NR_ZSPAGES);
 		put_page(page);
@@ -1865,7 +1867,7 @@ static int zs_page_migrate(struct page *
 		zpdesc_inc_zone_page_state(newzpdesc);
 	}
 
-	reset_page(page);
+	reset_zpdesc(zpdesc);
 	zpdesc_put(zpdesc);
 
 	return MIGRATEPAGE_SUCCESS;
_

Patches currently in -mm which might be from alexs@kernel.org are


