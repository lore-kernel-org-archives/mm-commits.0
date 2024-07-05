Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD95BE58
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141654; cv=none; b=hJZb4BjEdQvLsxaVl5Sep8+MdZt2OpEiegKwggpQ9G8RYrMxlwwkA5VNfUyhkBomnuXrRWdBkFidGBaD44OIHlIog9tvr2QHSeUx7ABQxkoHDykSfNmV8U3hRLggFqOkz9QemsTXoOV5H2FZ/mVgFQvtMsX6GDY5h8Gbie6ucg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141654; c=relaxed/simple;
	bh=tGCAcmfMlQi39f56yZLQZBrP3ESiTwX/E0EeN9eBMWo=;
	h=Date:To:From:Subject:Message-Id; b=MVqKp0ZvIbU3tAJkFcUUzI0SepZbhbQDBtVwJ2D6usEMY3qM/BGe7rDVMgEnhW2aNJhoyDutNPwSiBOaXeDInnTrk9LvADaI3VstjbBP7y/cmOOwYsUwKzxYE/eXACWAYfANNaj24eGvhbV8rcBIwTXIHCIpt8IhqMBzi3SKlDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZzIFG2Hd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZzIFG2Hd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D4CC3277B;
	Fri,  5 Jul 2024 01:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141654;
	bh=tGCAcmfMlQi39f56yZLQZBrP3ESiTwX/E0EeN9eBMWo=;
	h=Date:To:From:Subject:From;
	b=ZzIFG2Hd0634BqjCSV4y7Ud0Jxf06DVNztELODILYpwCoQGxLm+hIazd7QHPJfMBZ
	 hWZQPMEbwfZAzzAwZgw8koxjS2lYLr1qcwOLaHjwNqNh5TvotAgZssbAYD9ZHHGsSS
	 ypbKltaclzJ0bhK7XAh+Uf1QXpsUXtUySqwuOEG4=
Date: Thu, 04 Jul 2024 18:07:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,peterx@redhat.com,osalvador@suse.de,mike.kravetz@oracle.com,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,airlied@redhat.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] udmabuf-add-back-support-for-mapping-hugetlb-pages.patch removed from -mm tree
Message-Id: <20240705010734.52D4CC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: udmabuf: add back support for mapping hugetlb pages
has been removed from the -mm tree.  Its filename was
     udmabuf-add-back-support-for-mapping-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: udmabuf: add back support for mapping hugetlb pages
Date: Sun, 23 Jun 2024 23:36:14 -0700

A user or admin can configure a VMM (Qemu) Guest's memory to be backed by
hugetlb pages for various reasons.  However, a Guest OS would still
allocate (and pin) buffers that are backed by regular 4k sized pages.  In
order to map these buffers and create dma-bufs for them on the Host, we
first need to find the hugetlb pages where the buffer allocations are
located and then determine the offsets of individual chunks (within those
pages) and use this information to eventually populate a scatterlist.

Testcase: default_hugepagesz=2M hugepagesz=2M hugepages=2500 options
were passed to the Host kernel and Qemu was launched with these
relevant options: qemu-system-x86_64 -m 4096m....
-device virtio-gpu-pci,max_outputs=1,blob=true,xres=1920,yres=1080
-display gtk,gl=on
-object memory-backend-memfd,hugetlb=on,id=mem1,size=4096M
-machine memory-backend=mem1

Replacing -display gtk,gl=on with -display gtk,gl=off above would
exercise the mmap handler.

Link: https://lkml.kernel.org/r/20240624063952.1572359-7-vivek.kasireddy@intel.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com> (v2)
Acked-by: Dave Airlie <airlied@redhat.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma-buf/udmabuf.c |  122 +++++++++++++++++++++++++++++-------
 1 file changed, 101 insertions(+), 21 deletions(-)

--- a/drivers/dma-buf/udmabuf.c~udmabuf-add-back-support-for-mapping-hugetlb-pages
+++ a/drivers/dma-buf/udmabuf.c
@@ -10,6 +10,7 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/shmem_fs.h>
+#include <linux/hugetlb.h>
 #include <linux/slab.h>
 #include <linux/udmabuf.h>
 #include <linux/vmalloc.h>
@@ -28,6 +29,7 @@ struct udmabuf {
 	struct page **pages;
 	struct sg_table *sg;
 	struct miscdevice *device;
+	pgoff_t *offsets;
 };
 
 static vm_fault_t udmabuf_vm_fault(struct vm_fault *vmf)
@@ -41,6 +43,8 @@ static vm_fault_t udmabuf_vm_fault(struc
 		return VM_FAULT_SIGBUS;
 
 	pfn = page_to_pfn(ubuf->pages[pgoff]);
+	pfn += ubuf->offsets[pgoff] >> PAGE_SHIFT;
+
 	return vmf_insert_pfn(vma, vmf->address, pfn);
 }
 
@@ -90,23 +94,29 @@ static struct sg_table *get_sg_table(str
 {
 	struct udmabuf *ubuf = buf->priv;
 	struct sg_table *sg;
+	struct scatterlist *sgl;
+	unsigned int i = 0;
 	int ret;
 
 	sg = kzalloc(sizeof(*sg), GFP_KERNEL);
 	if (!sg)
 		return ERR_PTR(-ENOMEM);
-	ret = sg_alloc_table_from_pages(sg, ubuf->pages, ubuf->pagecount,
-					0, ubuf->pagecount << PAGE_SHIFT,
-					GFP_KERNEL);
+
+	ret = sg_alloc_table(sg, ubuf->pagecount, GFP_KERNEL);
 	if (ret < 0)
-		goto err;
+		goto err_alloc;
+
+	for_each_sg(sg->sgl, sgl, ubuf->pagecount, i)
+		sg_set_page(sgl, ubuf->pages[i], PAGE_SIZE, ubuf->offsets[i]);
+
 	ret = dma_map_sgtable(dev, sg, direction, 0);
 	if (ret < 0)
-		goto err;
+		goto err_map;
 	return sg;
 
-err:
+err_map:
 	sg_free_table(sg);
+err_alloc:
 	kfree(sg);
 	return ERR_PTR(ret);
 }
@@ -143,6 +153,7 @@ static void release_udmabuf(struct dma_b
 
 	for (pg = 0; pg < ubuf->pagecount; pg++)
 		put_page(ubuf->pages[pg]);
+	kfree(ubuf->offsets);
 	kfree(ubuf->pages);
 	kfree(ubuf);
 }
@@ -196,17 +207,77 @@ static const struct dma_buf_ops udmabuf_
 #define SEALS_WANTED (F_SEAL_SHRINK)
 #define SEALS_DENIED (F_SEAL_WRITE)
 
+static int handle_hugetlb_pages(struct udmabuf *ubuf, struct file *memfd,
+				pgoff_t offset, pgoff_t pgcnt,
+				pgoff_t *pgbuf)
+{
+	struct hstate *hpstate = hstate_file(memfd);
+	pgoff_t mapidx = offset >> huge_page_shift(hpstate);
+	pgoff_t subpgoff = (offset & ~huge_page_mask(hpstate)) >> PAGE_SHIFT;
+	pgoff_t maxsubpgs = huge_page_size(hpstate) >> PAGE_SHIFT;
+	struct page *hpage = NULL;
+	struct folio *folio;
+	pgoff_t pgidx;
+
+	mapidx <<= huge_page_order(hpstate);
+	for (pgidx = 0; pgidx < pgcnt; pgidx++) {
+		if (!hpage) {
+			folio = __filemap_get_folio(memfd->f_mapping,
+						    mapidx,
+						    FGP_ACCESSED, 0);
+			if (IS_ERR(folio))
+				return PTR_ERR(folio);
+
+			hpage = &folio->page;
+		}
+
+		get_page(hpage);
+		ubuf->pages[*pgbuf] = hpage;
+		ubuf->offsets[*pgbuf] = subpgoff << PAGE_SHIFT;
+		(*pgbuf)++;
+		if (++subpgoff == maxsubpgs) {
+			put_page(hpage);
+			hpage = NULL;
+			subpgoff = 0;
+			mapidx += pages_per_huge_page(hpstate);
+		}
+	}
+
+	if (hpage)
+		put_page(hpage);
+
+	return 0;
+}
+
+static int handle_shmem_pages(struct udmabuf *ubuf, struct file *memfd,
+			      pgoff_t offset, pgoff_t pgcnt,
+			      pgoff_t *pgbuf)
+{
+	pgoff_t pgidx, pgoff = offset >> PAGE_SHIFT;
+	struct page *page;
+
+	for (pgidx = 0; pgidx < pgcnt; pgidx++) {
+		page = shmem_read_mapping_page(memfd->f_mapping,
+					       pgoff + pgidx);
+		if (IS_ERR(page))
+			return PTR_ERR(page);
+
+		ubuf->pages[*pgbuf] = page;
+		(*pgbuf)++;
+	}
+
+	return 0;
+}
+
 static long udmabuf_create(struct miscdevice *device,
 			   struct udmabuf_create_list *head,
 			   struct udmabuf_create_item *list)
 {
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
 	struct file *memfd = NULL;
-	struct address_space *mapping = NULL;
 	struct udmabuf *ubuf;
 	struct dma_buf *buf;
-	pgoff_t pgoff, pgcnt, pgidx, pgbuf = 0, pglimit;
-	struct page *page;
+	pgoff_t pgcnt, pgbuf = 0, pglimit;
 	int seals, ret = -EINVAL;
 	u32 i, flags;
 
@@ -234,6 +305,12 @@ static long udmabuf_create(struct miscde
 		ret = -ENOMEM;
 		goto err;
 	}
+	ubuf->offsets = kcalloc(ubuf->pagecount, sizeof(*ubuf->offsets),
+				GFP_KERNEL);
+	if (!ubuf->offsets) {
+		ret = -ENOMEM;
+		goto err;
+	}
 
 	pgbuf = 0;
 	for (i = 0; i < head->count; i++) {
@@ -241,8 +318,7 @@ static long udmabuf_create(struct miscde
 		memfd = fget(list[i].memfd);
 		if (!memfd)
 			goto err;
-		mapping = memfd->f_mapping;
-		if (!shmem_mapping(mapping))
+		if (!shmem_file(memfd) && !is_file_hugepages(memfd))
 			goto err;
 		seals = memfd_fcntl(memfd, F_GET_SEALS, 0);
 		if (seals == -EINVAL)
@@ -251,16 +327,19 @@ static long udmabuf_create(struct miscde
 		if ((seals & SEALS_WANTED) != SEALS_WANTED ||
 		    (seals & SEALS_DENIED) != 0)
 			goto err;
-		pgoff = list[i].offset >> PAGE_SHIFT;
-		pgcnt = list[i].size   >> PAGE_SHIFT;
-		for (pgidx = 0; pgidx < pgcnt; pgidx++) {
-			page = shmem_read_mapping_page(mapping, pgoff + pgidx);
-			if (IS_ERR(page)) {
-				ret = PTR_ERR(page);
-				goto err;
-			}
-			ubuf->pages[pgbuf++] = page;
-		}
+
+		pgcnt = list[i].size >> PAGE_SHIFT;
+		if (is_file_hugepages(memfd))
+			ret = handle_hugetlb_pages(ubuf, memfd,
+						   list[i].offset,
+						   pgcnt, &pgbuf);
+		else
+			ret = handle_shmem_pages(ubuf, memfd,
+						 list[i].offset,
+						 pgcnt, &pgbuf);
+		if (ret < 0)
+			goto err;
+
 		fput(memfd);
 		memfd = NULL;
 	}
@@ -287,6 +366,7 @@ err:
 		put_page(ubuf->pages[--pgbuf]);
 	if (memfd)
 		fput(memfd);
+	kfree(ubuf->offsets);
 	kfree(ubuf->pages);
 	kfree(ubuf);
 	return ret;
_

Patches currently in -mm which might be from vivek.kasireddy@intel.com are


