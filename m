Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432017346F
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006227; cv=none; b=OQGsDcXrkYViBIBpUMW5uIyRWDbUpIh7q7SsIrmBQ7w9zjNesHSEuhv90+oMdisdBaB3K/56QNsO9QCF5t6IspKxDqj+X0B3OxFQHuEgt78VPMD2JDfhVS5mp+6jNI750TRGOW5sFLtQce+HL4CGTzPbpHOqz8Bi7mAr0cV+ZF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006227; c=relaxed/simple;
	bh=dVQUwJulqy5jMvplkdKmm2TUzDJcLfI7IqdpMWqP3wk=;
	h=Date:To:From:Subject:Message-Id; b=eqFq2H6/b72imhclQLS0ZYmOxJb4YM4u1Ic6koUq4MKBkwiIj4NdDjGpfGgie3YEtDf3RkGtIAxYCDLsjyJWNf1mrr4IXNviOL775frXMv+Sa0lKJLsR/+L0+S6T5nXp8aI1xPvr4xPacOZGerlv6CuPUjEZumteIzc3IxCzLdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=duW2mRTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="duW2mRTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DB7C4CED6;
	Thu, 16 Jan 2025 05:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006227;
	bh=dVQUwJulqy5jMvplkdKmm2TUzDJcLfI7IqdpMWqP3wk=;
	h=Date:To:From:Subject:From;
	b=duW2mRTG6Du/gClzobZsOc21EhVIKqILYWb2Y4JA/bns1L/fXeU8wy/1NwXzly42C
	 11Ec1FrWQUaJj3eh4vhrNl0UAAjcvXyClLqZgcWlq4eKHJnlAEB8yqLYDaHq863F/y
	 sA61sZxxdtKg0jBA2m4gzhx4GXiM8B4Y/fEHYB+8=
Date: Wed, 15 Jan 2025 21:43:46 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-convert-obj_to_page-and-zs_free-to-use-zpdesc.patch removed from -mm tree
Message-Id: <20250116054347.11DB7C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: convert obj_to_page() and zs_free() to use zpdesc
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-convert-obj_to_page-and-zs_free-to-use-zpdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


