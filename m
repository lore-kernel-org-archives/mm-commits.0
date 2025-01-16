Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7F07346F
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006223; cv=none; b=PwNCt2F3dcSu9h2KvPy2WB6492Z2FS4QvMzJr+X00rNoOfehrtmC6jwukhis7/sdezrQa4nBjMZvHJxtNzXQRzGKey0KNYIMCyVScXgpkjqQfJeKOF5CpqQXbFcPE66AjHbd59zRHWyjF5o8FAlgpT2dac86W/7fjWluvQOOMqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006223; c=relaxed/simple;
	bh=DgWqZRUd96a0bcmlnhqtL4uQxkPCv/a7h2Sc+qAVbJc=;
	h=Date:To:From:Subject:Message-Id; b=P6ZHm00ZztNFEfYy9j+i4WBWJPaTmr+c5BH7GhKzyhcHyOxbqETS3eKas7DITnLtUazIvCWwFNUrcR/Xr32TeU7fRdYoMpBEKbUAsqdgNXQhgIMJWoZB6Iqi0g3hwsWDuoQpLzwm04st3lFxIAPzlzE32yewyhsrw7aExupQ8Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VUAdFbKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VUAdFbKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E6CC4CED6;
	Thu, 16 Jan 2025 05:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006222;
	bh=DgWqZRUd96a0bcmlnhqtL4uQxkPCv/a7h2Sc+qAVbJc=;
	h=Date:To:From:Subject:From;
	b=VUAdFbKZTkMbIhkSJJEGugsV8Cg2s1Rf2OuzNhSAHj9lBFsdwbP9Hs8AI/Q5PfFQ+
	 AQdZVw+xsV0Jzp+vEDcQbBNV9DEK1+UkqFMkxLNsK33teNuFz3M+2URX3YE5oweZQ1
	 e5fpiE/ueULOOim4A5yRUbuMWrXeewydODkfjOhI=
Date: Wed, 15 Jan 2025 21:43:41 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,senozhatsky@chromium.org,minchan@kernel.org,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-convert-obj_malloc-to-use-zpdesc.patch removed from -mm tree
Message-Id: <20250116054342.79E6CC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: convert obj_malloc() to use zpdesc
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-convert-obj_malloc-to-use-zpdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/zsmalloc: convert obj_malloc() to use zpdesc
Date: Tue, 17 Dec 2024 00:04:36 +0900

Use get_first_zpdesc/get_next_zpdesc to replace
get_first_page/get_next_page.  no functional change.

Link: https://lkml.kernel.org/r/20241216150450.1228021-6-42.hyeyoo@gmail.com
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

--- a/mm/zsmalloc.c~mm-zsmalloc-convert-obj_malloc-to-use-zpdesc
+++ a/mm/zsmalloc.c
@@ -1295,12 +1295,12 @@ EXPORT_SYMBOL_GPL(zs_huge_class_size);
 static unsigned long obj_malloc(struct zs_pool *pool,
 				struct zspage *zspage, unsigned long handle)
 {
-	int i, nr_page, offset;
+	int i, nr_zpdesc, offset;
 	unsigned long obj;
 	struct link_free *link;
 	struct size_class *class;
 
-	struct page *m_page;
+	struct zpdesc *m_zpdesc;
 	unsigned long m_offset;
 	void *vaddr;
 
@@ -1308,14 +1308,14 @@ static unsigned long obj_malloc(struct z
 	obj = get_freeobj(zspage);
 
 	offset = obj * class->size;
-	nr_page = offset >> PAGE_SHIFT;
+	nr_zpdesc = offset >> PAGE_SHIFT;
 	m_offset = offset_in_page(offset);
-	m_page = get_first_page(zspage);
+	m_zpdesc = get_first_zpdesc(zspage);
 
-	for (i = 0; i < nr_page; i++)
-		m_page = get_next_page(m_page);
+	for (i = 0; i < nr_zpdesc; i++)
+		m_zpdesc = get_next_zpdesc(m_zpdesc);
 
-	vaddr = kmap_local_page(m_page);
+	vaddr = kmap_local_zpdesc(m_zpdesc);
 	link = (struct link_free *)vaddr + m_offset / sizeof(*link);
 	set_freeobj(zspage, link->next >> OBJ_TAG_BITS);
 	if (likely(!ZsHugePage(zspage)))
@@ -1327,7 +1327,7 @@ static unsigned long obj_malloc(struct z
 	kunmap_local(vaddr);
 	mod_zspage_inuse(zspage, 1);
 
-	obj = location_to_obj(m_page, obj);
+	obj = location_to_obj(zpdesc_page(m_zpdesc), obj);
 	record_obj(handle, obj);
 
 	return obj;
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are


