Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D3321832F
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731019114; cv=none; b=JoFyQeV/DoE42tT9w/NtCRDEOoowL79D9ja66sIo44TFAZueNZdgL9Uvu4YRwjINfS/ZJChZI9T4LLUIzVxAC00x6jv1xLcD7GLFVxDdAajQByoNhcqmGw77905RKHt6jhwPAwo7oWcs3uTJ/5eIULPyjTmUlw62Av7SBct2HOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731019114; c=relaxed/simple;
	bh=wd1u+F1zsdQZb0oM7Z5i1LUQAYqD1x3375D9CGOwBuo=;
	h=Date:To:From:Subject:Message-Id; b=ktjoWCVf6V39LWu92gHrlMg2rJKgs1KPf1Fs5w4yl12wWrcgW9DNkqADZIIVnW2j7SNuYsuYkP9lNgSfRi2B3Vh+tv2SsD7E6Tst959265753JNlV1OdpxgOSmHOAiqn1FHNEhyO2jnbF4zdFh3OF0Mtd083PKB6Ob8MX4cGRGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XXKupP9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XXKupP9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DEDC4CECC;
	Thu,  7 Nov 2024 22:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731019114;
	bh=wd1u+F1zsdQZb0oM7Z5i1LUQAYqD1x3375D9CGOwBuo=;
	h=Date:To:From:Subject:From;
	b=XXKupP9pWs1VhGuD8aovDm/wrQTRmpH0ch74jgQ1LURE68Kh49Mb3w4wp1AXMnZ9k
	 uT/d5a0RZiXYsea0CiAtkjJMrb4ywKE7hoA84TC+iBvVt7pBQka+17inxD6fSU53hS
	 hDAs9hRuEpOu2xLXx64ddmm0kxrRfMLuke861D7s=
Date: Thu, 07 Nov 2024 14:38:33 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,senozhatsky@chromium.org,pintu.ping@gmail.com,minchan@kernel.org,joe@perches.com,quic_pintu@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-replace-kmap_atomic-with-kmap_local_page.patch removed from -mm tree
Message-Id: <20241107223834.53DEDC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: replace kmap_atomic with kmap_local_page
has been removed from the -mm tree.  Its filename was
     zsmalloc-replace-kmap_atomic-with-kmap_local_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pintu Kumar <quic_pintu@quicinc.com>
Subject: zsmalloc: replace kmap_atomic with kmap_local_page
Date: Tue, 1 Oct 2024 23:23:58 +0530

The use of kmap_atomic/kunmap_atomic is deprecated.  Replace it will
kmap_local_page/kunmap_local all over the place.  Also fix SPDX missing
license header.

WARNING: Missing or malformed SPDX-License-Identifier tag in line 1

WARNING: Deprecated use of 'kmap_atomic', prefer 'kmap_local_page' instead
+               vaddr = kmap_atomic(page);

Link: https://lkml.kernel.org/r/20241001175358.12970-1-quic_pintu@quicinc.com
Signed-off-by: Pintu Kumar <quic_pintu@quicinc.com>
Cc: Joe Perches <joe@perches.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pintu Agarwal <pintu.ping@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   66 ++++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 32 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-replace-kmap_atomic-with-kmap_local_page
+++ a/mm/zsmalloc.c
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
 /*
  * zsmalloc memory allocator
  *
@@ -898,7 +900,7 @@ static void init_zspage(struct size_clas
 
 		set_first_obj_offset(page, off);
 
-		vaddr = kmap_atomic(page);
+		vaddr = kmap_local_page(page);
 		link = (struct link_free *)vaddr + off / sizeof(*link);
 
 		while ((off += class->size) < PAGE_SIZE) {
@@ -921,7 +923,7 @@ static void init_zspage(struct size_clas
 			 */
 			link->next = -1UL << OBJ_TAG_BITS;
 		}
-		kunmap_atomic(vaddr);
+		kunmap_local(vaddr);
 		page = next_page;
 		off %= PAGE_SIZE;
 	}
@@ -1059,12 +1061,12 @@ static void *__zs_map_object(struct mapp
 	sizes[1] = size - sizes[0];
 
 	/* copy object to per-cpu buffer */
-	addr = kmap_atomic(pages[0]);
+	addr = kmap_local_page(pages[0]);
 	memcpy(buf, addr + off, sizes[0]);
-	kunmap_atomic(addr);
-	addr = kmap_atomic(pages[1]);
+	kunmap_local(addr);
+	addr = kmap_local_page(pages[1]);
 	memcpy(buf + sizes[0], addr, sizes[1]);
-	kunmap_atomic(addr);
+	kunmap_local(addr);
 out:
 	return area->vm_buf;
 }
@@ -1089,12 +1091,12 @@ static void __zs_unmap_object(struct map
 	sizes[1] = size - sizes[0];
 
 	/* copy per-cpu buffer to object */
-	addr = kmap_atomic(pages[0]);
+	addr = kmap_local_page(pages[0]);
 	memcpy(addr + off, buf, sizes[0]);
-	kunmap_atomic(addr);
-	addr = kmap_atomic(pages[1]);
+	kunmap_local(addr);
+	addr = kmap_local_page(pages[1]);
 	memcpy(addr, buf + sizes[0], sizes[1]);
-	kunmap_atomic(addr);
+	kunmap_local(addr);
 
 out:
 	/* enable page faults to match kunmap_atomic() return conditions */
@@ -1223,7 +1225,7 @@ void *zs_map_object(struct zs_pool *pool
 	area->vm_mm = mm;
 	if (off + class->size <= PAGE_SIZE) {
 		/* this object is contained entirely within a page */
-		area->vm_addr = kmap_atomic(page);
+		area->vm_addr = kmap_local_page(page);
 		ret = area->vm_addr + off;
 		goto out;
 	}
@@ -1260,7 +1262,7 @@ void zs_unmap_object(struct zs_pool *poo
 
 	area = this_cpu_ptr(&zs_map_area);
 	if (off + class->size <= PAGE_SIZE)
-		kunmap_atomic(area->vm_addr);
+		kunmap_local(area->vm_addr);
 	else {
 		struct page *pages[2];
 
@@ -1318,7 +1320,7 @@ static unsigned long obj_malloc(struct z
 	for (i = 0; i < nr_page; i++)
 		m_page = get_next_page(m_page);
 
-	vaddr = kmap_atomic(m_page);
+	vaddr = kmap_local_page(m_page);
 	link = (struct link_free *)vaddr + m_offset / sizeof(*link);
 	set_freeobj(zspage, link->next >> OBJ_TAG_BITS);
 	if (likely(!ZsHugePage(zspage)))
@@ -1328,7 +1330,7 @@ static unsigned long obj_malloc(struct z
 		/* record handle to page->index */
 		zspage->first_page->index = handle | OBJ_ALLOCATED_TAG;
 
-	kunmap_atomic(vaddr);
+	kunmap_local(vaddr);
 	mod_zspage_inuse(zspage, 1);
 
 	obj = location_to_obj(m_page, obj);
@@ -1419,7 +1421,7 @@ static void obj_free(int class_size, uns
 	f_offset = offset_in_page(class_size * f_objidx);
 	zspage = get_zspage(f_page);
 
-	vaddr = kmap_atomic(f_page);
+	vaddr = kmap_local_page(f_page);
 	link = (struct link_free *)(vaddr + f_offset);
 
 	/* Insert this object in containing zspage's freelist */
@@ -1429,7 +1431,7 @@ static void obj_free(int class_size, uns
 		f_page->index = 0;
 	set_freeobj(zspage, f_objidx);
 
-	kunmap_atomic(vaddr);
+	kunmap_local(vaddr);
 	mod_zspage_inuse(zspage, -1);
 }
 
@@ -1492,8 +1494,8 @@ static void zs_object_copy(struct size_c
 	if (d_off + class->size > PAGE_SIZE)
 		d_size = PAGE_SIZE - d_off;
 
-	s_addr = kmap_atomic(s_page);
-	d_addr = kmap_atomic(d_page);
+	s_addr = kmap_local_page(s_page);
+	d_addr = kmap_local_page(d_page);
 
 	while (1) {
 		size = min(s_size, d_size);
@@ -1516,26 +1518,26 @@ static void zs_object_copy(struct size_c
 		 * Documentation/mm/highmem.rst.
 		 */
 		if (s_off >= PAGE_SIZE) {
-			kunmap_atomic(d_addr);
-			kunmap_atomic(s_addr);
+			kunmap_local(d_addr);
+			kunmap_local(s_addr);
 			s_page = get_next_page(s_page);
-			s_addr = kmap_atomic(s_page);
-			d_addr = kmap_atomic(d_page);
+			s_addr = kmap_local_page(s_page);
+			d_addr = kmap_local_page(d_page);
 			s_size = class->size - written;
 			s_off = 0;
 		}
 
 		if (d_off >= PAGE_SIZE) {
-			kunmap_atomic(d_addr);
+			kunmap_local(d_addr);
 			d_page = get_next_page(d_page);
-			d_addr = kmap_atomic(d_page);
+			d_addr = kmap_local_page(d_page);
 			d_size = class->size - written;
 			d_off = 0;
 		}
 	}
 
-	kunmap_atomic(d_addr);
-	kunmap_atomic(s_addr);
+	kunmap_local(d_addr);
+	kunmap_local(s_addr);
 }
 
 /*
@@ -1548,7 +1550,7 @@ static unsigned long find_alloced_obj(st
 	unsigned int offset;
 	int index = *obj_idx;
 	unsigned long handle = 0;
-	void *addr = kmap_atomic(page);
+	void *addr = kmap_local_page(page);
 
 	offset = get_first_obj_offset(page);
 	offset += class->size * index;
@@ -1561,7 +1563,7 @@ static unsigned long find_alloced_obj(st
 		index++;
 	}
 
-	kunmap_atomic(addr);
+	kunmap_local(addr);
 
 	*obj_idx = index;
 
@@ -1798,14 +1800,14 @@ static int zs_page_migrate(struct page *
 	migrate_write_lock(zspage);
 
 	offset = get_first_obj_offset(page);
-	s_addr = kmap_atomic(page);
+	s_addr = kmap_local_page(page);
 
 	/*
 	 * Here, any user cannot access all objects in the zspage so let's move.
 	 */
-	d_addr = kmap_atomic(newpage);
+	d_addr = kmap_local_page(newpage);
 	copy_page(d_addr, s_addr);
-	kunmap_atomic(d_addr);
+	kunmap_local(d_addr);
 
 	for (addr = s_addr + offset; addr < s_addr + PAGE_SIZE;
 					addr += class->size) {
@@ -1818,7 +1820,7 @@ static int zs_page_migrate(struct page *
 			record_obj(handle, new_obj);
 		}
 	}
-	kunmap_atomic(s_addr);
+	kunmap_local(s_addr);
 
 	replace_sub_page(class, zspage, newpage, page);
 	/*
_

Patches currently in -mm which might be from quic_pintu@quicinc.com are


