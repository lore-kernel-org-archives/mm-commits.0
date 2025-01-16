Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F031D7346F
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006225; cv=none; b=FY2cKbV5JY2LQpCNcWDsMxEn4l/AcuuzzdSEE1jbb6SiOHzfL48wkCAFXUNhSyIIGJcDvyEyMlADA0TjDitBRsSX/TZDPg2l/Ury+DfVFfqz8GRxTLw5BdRNOHCqdU0VicQx/7BEWecUzPa5niMmRelQfDlkmJMsDsLj5E7Sfq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006225; c=relaxed/simple;
	bh=8y4llD4LrNoawAikGEhWjOtJKXTPV7fl05XablbB7TI=;
	h=Date:To:From:Subject:Message-Id; b=qYG9RQP2hMsXCT1VkjtB+iVqTrHTrTxugzUIdNuY2rvuEkh7gBjDBmDwIVuNH9gdHnXgKo5D3LtvbaNsFzJ435N/hJFbqlK9OlszHdaFNE6rKVuC54r52fEpWztWl/kd2tfEb+yTIgPQU4vCgvTcmtUHfStFtRrGkk72nd/dWXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N0dkrTXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N0dkrTXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29A0C4CEE2;
	Thu, 16 Jan 2025 05:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006224;
	bh=8y4llD4LrNoawAikGEhWjOtJKXTPV7fl05XablbB7TI=;
	h=Date:To:From:Subject:From;
	b=N0dkrTXZeXMPNOU3nG7Q3JQrIqpjWoIILSTJV1OIKa25I93eucrXUKJaJU1xGtRx+
	 0P37j/sabqZLyN7sxmzMJ2jp+CbEf7CAN4uTVhi0c1K5ClwVDEA49CVt5Ld39fcQjc
	 tCJ3aWmrdgfuKmtAtjba7DHt/OQ8+YBUu+s28rvQ=
Date: Wed, 15 Jan 2025 21:43:44 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-convert-obj_allocated-and-related-helpers-to-use-zpdesc.patch removed from -mm tree
Message-Id: <20250116054344.C29A0C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: convert obj_allocated() and related helpers to use zpdesc
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-convert-obj_allocated-and-related-helpers-to-use-zpdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


