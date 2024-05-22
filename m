Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A39A7FBD1
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 22:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716415671; cv=none; b=TwMfudxbeAHfA27foR9C2FmhaVYWZIEwOcibn6+6mOfbHWTgeoGT7o1+evglqK23/5Y4DB6cBYGHso+cY0+PWKtWUVgcG1kuIE1C2jkqitKa19xN7jNvCLv7B23iDWmrGCVlqFrFDgqoya1aKiU1DhguK/mCJxzU228xqIW3TJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716415671; c=relaxed/simple;
	bh=wEsKbWBX1QawcdIjhoJEUoxwAGPN5bme+JBSJ74pVTM=;
	h=Date:To:From:Subject:Message-Id; b=g9RI+g6Up9GoInWpiA0Il9v2PKc0/kqAM/YgD1BlTTrm56DM15P48jem/err0eEegaCYqqlDEZMJDGQUK+UfAzr1eD9E2WEGZTUKQlzMzp882ODxNkzSJh8DDnD00UVrUCR1TtI7ktDc7jijgiY74qTlNOqsad6O24rwmiBN7Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wX5pv/ds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wX5pv/ds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4A7C2BBFC;
	Wed, 22 May 2024 22:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716415671;
	bh=wEsKbWBX1QawcdIjhoJEUoxwAGPN5bme+JBSJ74pVTM=;
	h=Date:To:From:Subject:From;
	b=wX5pv/dsoM9Ts0Sc0UVsI27Rm2A5S5E8ud3F8IlSRIEMPxAwCSI2EN4ReG63zPTbZ
	 VpG3GRZLYmjcVv2YCT28PUoq2SuTOkOrTcsNZSUxfsDrPI5Fq5cx9GVJJkWEz9JhqA
	 xmxObpXM9hAkb+jDKFt3yLEEJ+0a9ShBikJSskyw=
Date: Wed, 22 May 2024 15:07:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,peterx@redhat.com,mike.kravetz@oracle.com,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + udmabuf-convert-udmabuf-driver-to-use-folios.patch added to mm-unstable branch
Message-Id: <20240522220750.DD4A7C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: udmabuf: convert udmabuf driver to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     udmabuf-convert-udmabuf-driver-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/udmabuf-convert-udmabuf-driver-to-use-folios.patch

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
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: udmabuf: convert udmabuf driver to use folios
Date: Wed, 10 Apr 2024 23:59:42 -0700

This is mainly a preparatory patch to use memfd_pin_folios() API for
pinning folios.  Using folios instead of pages makes sense as the udmabuf
driver needs to handle both shmem and hugetlb cases.  And, using the
memfd_pin_folios() API makes this easier as we no longer need to
separately handle shmem vs hugetlb cases in the udmabuf driver.

Note that, the function vmap_udmabuf() still needs a list of pages; so, we
collect all the head pages into a local array in this case.

Other changes in this patch include the addition of helpers for checking
the memfd seals and exporting dmabuf.  Moving code from udmabuf_create()
into these helpers improves readability given that udmabuf_create() is a
bit long.

Link: https://lkml.kernel.org/r/20240411070157.3318425-7-vivek.kasireddy@intel.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma-buf/udmabuf.c |  140 +++++++++++++++++++++---------------
 1 file changed, 83 insertions(+), 57 deletions(-)

--- a/drivers/dma-buf/udmabuf.c~udmabuf-convert-udmabuf-driver-to-use-folios
+++ a/drivers/dma-buf/udmabuf.c
@@ -26,7 +26,7 @@ MODULE_PARM_DESC(size_limit_mb, "Max siz
 
 struct udmabuf {
 	pgoff_t pagecount;
-	struct page **pages;
+	struct folio **folios;
 	struct sg_table *sg;
 	struct miscdevice *device;
 	pgoff_t *offsets;
@@ -42,7 +42,7 @@ static vm_fault_t udmabuf_vm_fault(struc
 	if (pgoff >= ubuf->pagecount)
 		return VM_FAULT_SIGBUS;
 
-	pfn = page_to_pfn(ubuf->pages[pgoff]);
+	pfn = folio_pfn(ubuf->folios[pgoff]);
 	pfn += ubuf->offsets[pgoff] >> PAGE_SHIFT;
 
 	return vmf_insert_pfn(vma, vmf->address, pfn);
@@ -68,11 +68,21 @@ static int mmap_udmabuf(struct dma_buf *
 static int vmap_udmabuf(struct dma_buf *buf, struct iosys_map *map)
 {
 	struct udmabuf *ubuf = buf->priv;
+	struct page **pages;
 	void *vaddr;
+	pgoff_t pg;
 
 	dma_resv_assert_held(buf->resv);
 
-	vaddr = vm_map_ram(ubuf->pages, ubuf->pagecount, -1);
+	pages = kmalloc_array(ubuf->pagecount, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	for (pg = 0; pg < ubuf->pagecount; pg++)
+		pages[pg] = &ubuf->folios[pg]->page;
+
+	vaddr = vm_map_ram(pages, ubuf->pagecount, -1);
+	kfree(pages);
 	if (!vaddr)
 		return -EINVAL;
 
@@ -107,7 +117,8 @@ static struct sg_table *get_sg_table(str
 		goto err_alloc;
 
 	for_each_sg(sg->sgl, sgl, ubuf->pagecount, i)
-		sg_set_page(sgl, ubuf->pages[i], PAGE_SIZE, ubuf->offsets[i]);
+		sg_set_folio(sgl, ubuf->folios[i], PAGE_SIZE,
+			     ubuf->offsets[i]);
 
 	ret = dma_map_sgtable(dev, sg, direction, 0);
 	if (ret < 0)
@@ -152,9 +163,9 @@ static void release_udmabuf(struct dma_b
 		put_sg_table(dev, ubuf->sg, DMA_BIDIRECTIONAL);
 
 	for (pg = 0; pg < ubuf->pagecount; pg++)
-		put_page(ubuf->pages[pg]);
+		folio_put(ubuf->folios[pg]);
 	kfree(ubuf->offsets);
-	kfree(ubuf->pages);
+	kfree(ubuf->folios);
 	kfree(ubuf);
 }
 
@@ -215,36 +226,33 @@ static int handle_hugetlb_pages(struct u
 	pgoff_t mapidx = offset >> huge_page_shift(hpstate);
 	pgoff_t subpgoff = (offset & ~huge_page_mask(hpstate)) >> PAGE_SHIFT;
 	pgoff_t maxsubpgs = huge_page_size(hpstate) >> PAGE_SHIFT;
-	struct page *hpage = NULL;
-	struct folio *folio;
+	struct folio *folio = NULL;
 	pgoff_t pgidx;
 
 	mapidx <<= huge_page_order(hpstate);
 	for (pgidx = 0; pgidx < pgcnt; pgidx++) {
-		if (!hpage) {
+		if (!folio) {
 			folio = __filemap_get_folio(memfd->f_mapping,
 						    mapidx,
 						    FGP_ACCESSED, 0);
 			if (IS_ERR(folio))
 				return PTR_ERR(folio);
-
-			hpage = &folio->page;
 		}
 
-		get_page(hpage);
-		ubuf->pages[*pgbuf] = hpage;
+		folio_get(folio);
+		ubuf->folios[*pgbuf] = folio;
 		ubuf->offsets[*pgbuf] = subpgoff << PAGE_SHIFT;
 		(*pgbuf)++;
 		if (++subpgoff == maxsubpgs) {
-			put_page(hpage);
-			hpage = NULL;
+			folio_put(folio);
+			folio = NULL;
 			subpgoff = 0;
 			mapidx += pages_per_huge_page(hpstate);
 		}
 	}
 
-	if (hpage)
-		put_page(hpage);
+	if (folio)
+		folio_put(folio);
 
 	return 0;
 }
@@ -254,31 +262,69 @@ static int handle_shmem_pages(struct udm
 			      pgoff_t *pgbuf)
 {
 	pgoff_t pgidx, pgoff = offset >> PAGE_SHIFT;
-	struct page *page;
+	struct folio *folio = NULL;
 
 	for (pgidx = 0; pgidx < pgcnt; pgidx++) {
-		page = shmem_read_mapping_page(memfd->f_mapping,
-					       pgoff + pgidx);
-		if (IS_ERR(page))
-			return PTR_ERR(page);
+		folio = shmem_read_folio(memfd->f_mapping, pgoff + pgidx);
+		if (IS_ERR(folio))
+			return PTR_ERR(folio);
 
-		ubuf->pages[*pgbuf] = page;
+		ubuf->folios[*pgbuf] = folio;
 		(*pgbuf)++;
 	}
 
 	return 0;
 }
 
+static int check_memfd_seals(struct file *memfd)
+{
+	int seals;
+
+	if (!memfd)
+		return -EBADFD;
+
+	if (!shmem_file(memfd) && !is_file_hugepages(memfd))
+		return -EBADFD;
+
+	seals = memfd_fcntl(memfd, F_GET_SEALS, 0);
+	if (seals == -EINVAL)
+		return -EBADFD;
+
+	if ((seals & SEALS_WANTED) != SEALS_WANTED ||
+	    (seals & SEALS_DENIED) != 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int export_udmabuf(struct udmabuf *ubuf,
+			  struct miscdevice *device,
+			  u32 flags)
+{
+	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
+	struct dma_buf *buf;
+
+	ubuf->device = device;
+	exp_info.ops  = &udmabuf_ops;
+	exp_info.size = ubuf->pagecount << PAGE_SHIFT;
+	exp_info.priv = ubuf;
+	exp_info.flags = O_RDWR;
+
+	buf = dma_buf_export(&exp_info);
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
+	return dma_buf_fd(buf, flags);
+}
+
 static long udmabuf_create(struct miscdevice *device,
 			   struct udmabuf_create_list *head,
 			   struct udmabuf_create_item *list)
 {
-	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
+	pgoff_t pgcnt, pgbuf = 0, pglimit;
 	struct file *memfd = NULL;
 	struct udmabuf *ubuf;
-	struct dma_buf *buf;
-	pgoff_t pgcnt, pgbuf = 0, pglimit;
-	int seals, ret = -EINVAL;
+	int ret = -EINVAL;
 	u32 i, flags;
 
 	ubuf = kzalloc(sizeof(*ubuf), GFP_KERNEL);
@@ -299,9 +345,9 @@ static long udmabuf_create(struct miscde
 	if (!ubuf->pagecount)
 		goto err;
 
-	ubuf->pages = kmalloc_array(ubuf->pagecount, sizeof(*ubuf->pages),
+	ubuf->folios = kmalloc_array(ubuf->pagecount, sizeof(*ubuf->folios),
 				    GFP_KERNEL);
-	if (!ubuf->pages) {
+	if (!ubuf->folios) {
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -314,18 +360,9 @@ static long udmabuf_create(struct miscde
 
 	pgbuf = 0;
 	for (i = 0; i < head->count; i++) {
-		ret = -EBADFD;
 		memfd = fget(list[i].memfd);
-		if (!memfd)
-			goto err;
-		if (!shmem_file(memfd) && !is_file_hugepages(memfd))
-			goto err;
-		seals = memfd_fcntl(memfd, F_GET_SEALS, 0);
-		if (seals == -EINVAL)
-			goto err;
-		ret = -EINVAL;
-		if ((seals & SEALS_WANTED) != SEALS_WANTED ||
-		    (seals & SEALS_DENIED) != 0)
+		ret = check_memfd_seals(memfd);
+		if (ret < 0)
 			goto err;
 
 		pgcnt = list[i].size >> PAGE_SHIFT;
@@ -341,33 +378,22 @@ static long udmabuf_create(struct miscde
 			goto err;
 
 		fput(memfd);
-		memfd = NULL;
 	}
 
-	exp_info.ops  = &udmabuf_ops;
-	exp_info.size = ubuf->pagecount << PAGE_SHIFT;
-	exp_info.priv = ubuf;
-	exp_info.flags = O_RDWR;
-
-	ubuf->device = device;
-	buf = dma_buf_export(&exp_info);
-	if (IS_ERR(buf)) {
-		ret = PTR_ERR(buf);
+	flags = head->flags & UDMABUF_FLAGS_CLOEXEC ? O_CLOEXEC : 0;
+	ret = export_udmabuf(ubuf, device, flags);
+	if (ret < 0)
 		goto err;
-	}
 
-	flags = 0;
-	if (head->flags & UDMABUF_FLAGS_CLOEXEC)
-		flags |= O_CLOEXEC;
-	return dma_buf_fd(buf, flags);
+	return ret;
 
 err:
 	while (pgbuf > 0)
-		put_page(ubuf->pages[--pgbuf]);
+		folio_put(ubuf->folios[--pgbuf]);
 	if (memfd)
 		fput(memfd);
 	kfree(ubuf->offsets);
-	kfree(ubuf->pages);
+	kfree(ubuf->folios);
 	kfree(ubuf);
 	return ret;
 }
_

Patches currently in -mm which might be from vivek.kasireddy@intel.com are

mm-gup-introduce-unpin_folio-unpin_folios-helpers.patch
mm-gup-introduce-check_and_migrate_movable_folios.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios.patch
udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap.patch
udmabuf-add-back-support-for-mapping-hugetlb-pages.patch
udmabuf-convert-udmabuf-driver-to-use-folios.patch
udmabuf-pin-the-pages-using-memfd_pin_folios-api.patch
selftests-udmabuf-add-tests-to-verify-data-after-page-migration.patch

