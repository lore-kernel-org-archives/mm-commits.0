Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578EB7346F
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006226; cv=none; b=Y1+EutFXVdOQHr5oE0c8s0gGJtXMoOf8v62NamuCcJkecdaxcvKh6aqv/+1xSHFmz8O0Z1943HGDe/MBoDyqJ9oSc6AmIvVkFVXucqad+JWJXJKIV1pJymG6i6cktE5i4JcWMHeq8ohelrlUzgiy43gpv8L13yQLBhC9EFy2T/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006226; c=relaxed/simple;
	bh=yIBeHSfKjTSac8o2Uj9D8hFy+MQU5kehiFii6i+0rcU=;
	h=Date:To:From:Subject:Message-Id; b=a25X0N2BvPMIS3S9hjyTWT9VoEiV83h7udvH/fRohVh0rOSpxnHt1+Y25vCcArQJA2iMG9qzHlEM8w67TiMU8Pnakc3N1DTvSn6Gh4yEMZpZ8hRKlj8OlhEjpvR5l2MvOBtUXA30AkTh+zXpY4+E6DPT2jkX5uoG52CpfE0ZqXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hOMwzFt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hOMwzFt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E5CC4CED6;
	Thu, 16 Jan 2025 05:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006226;
	bh=yIBeHSfKjTSac8o2Uj9D8hFy+MQU5kehiFii6i+0rcU=;
	h=Date:To:From:Subject:From;
	b=hOMwzFt6gbZ9Rr5qpAertoFTqGRcSZ1Mw/UB4baEnAkn+5bbeFBbbg9oaM0hNhQCg
	 WWJF7UDLfYJ1Xa7Dw8PoKthOcaydWGuTSRgooaIcs2te0L6Sba4JjwI3crY84BQY+I
	 qgJ/GqOhz4oI74ajGXHyuJT5YgHpKHMKxY2Fli4U=
Date: Wed, 15 Jan 2025 21:43:45 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-convert-init_zspage-to-use-zpdesc.patch removed from -mm tree
Message-Id: <20250116054345.E1E5CC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: convert init_zspage() to use zpdesc
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-convert-init_zspage-to-use-zpdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


