Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63994C2E9
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141657; cv=none; b=ie6WtrOWr4FGtHXHwbRX/IJFjs0yk2Qv/ON6k29HkFr7EC83wxUXBDrw/m76W+7XqKTylFWdwhbp87yo64BkpGe1LECzc8XrFzh2AmDCk7IOg7wpJ/146pamc+h/+H/adA1bk3o3FNc3ekW7J9FaG4oLlPAeLXNwWt6MGUDhZ9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141657; c=relaxed/simple;
	bh=GwDOfS1BB9ZD1fB09vcXCHZ95pRj6WeCEBKat/7H3OQ=;
	h=Date:To:From:Subject:Message-Id; b=HsklMAH3a57Yi7lVS2W3vTeaffjhanNXv2hUwTzXhJ7xlU+ZY3lrN3Wy5DlVuhu1h/Z+1ATTkCe7f07uFSgDSRxxcFH8qmxBpjkjgCqprjfzUZPk7v0lgR1IT3Vj4GYo1Q+iyXT6wiWnciugIDzKrgsGaeFxSKUD1ZwQxjqbxCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J84UKb0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J84UKb0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D867C3277B;
	Fri,  5 Jul 2024 01:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141657;
	bh=GwDOfS1BB9ZD1fB09vcXCHZ95pRj6WeCEBKat/7H3OQ=;
	h=Date:To:From:Subject:From;
	b=J84UKb0F1kTSJ3VzeoA/t57scm4Ba+xMEp5VpMr9l5801Ci2h5JVsmSyinv3N1Yg9
	 gK6xeeow/uU1Hrivib/FLTlGilybjwWo5ZhyGAWu0TEWQd56yjyMMzr4zU/ZeRY6oZ
	 UZkEjSPjdR8/14I1mYlNk4i9XgH2iiVNLxkVUXuA=
Date: Thu, 04 Jul 2024 18:07:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shuah@kernel.org,peterx@redhat.com,osalvador@suse.de,mike.kravetz@oracle.com,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,airlied@redhat.com,vivek.kasireddy@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] udmabuf-pin-the-pages-using-memfd_pin_folios-api.patch removed from -mm tree
Message-Id: <20240705010737.2D867C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: udmabuf: pin the pages using memfd_pin_folios() API
has been removed from the -mm tree.  Its filename was
     udmabuf-pin-the-pages-using-memfd_pin_folios-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: udmabuf: pin the pages using memfd_pin_folios() API
Date: Sun, 23 Jun 2024 23:36:16 -0700

Using memfd_pin_folios() will ensure that the pages are pinned
correctly using FOLL_PIN. And, this also ensures that we don't
accidentally break features such as memory hotunplug as it would
not allow pinning pages in the movable zone.

Using this new API also simplifies the code as we no longer have
to deal with extracting individual pages from their mappings or
handle shmem and hugetlb cases separately.

Link: https://lkml.kernel.org/r/20240624063952.1572359-9-vivek.kasireddy@intel.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Acked-by: Dave Airlie <airlied@redhat.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma-buf/udmabuf.c |  155 ++++++++++++++++++------------------
 1 file changed, 80 insertions(+), 75 deletions(-)

--- a/drivers/dma-buf/udmabuf.c~udmabuf-pin-the-pages-using-memfd_pin_folios-api
+++ a/drivers/dma-buf/udmabuf.c
@@ -30,6 +30,12 @@ struct udmabuf {
 	struct sg_table *sg;
 	struct miscdevice *device;
 	pgoff_t *offsets;
+	struct list_head unpin_list;
+};
+
+struct udmabuf_folio {
+	struct folio *folio;
+	struct list_head list;
 };
 
 static vm_fault_t udmabuf_vm_fault(struct vm_fault *vmf)
@@ -153,17 +159,43 @@ static void unmap_udmabuf(struct dma_buf
 	return put_sg_table(at->dev, sg, direction);
 }
 
+static void unpin_all_folios(struct list_head *unpin_list)
+{
+	struct udmabuf_folio *ubuf_folio;
+
+	while (!list_empty(unpin_list)) {
+		ubuf_folio = list_first_entry(unpin_list,
+					      struct udmabuf_folio, list);
+		unpin_folio(ubuf_folio->folio);
+
+		list_del(&ubuf_folio->list);
+		kfree(ubuf_folio);
+	}
+}
+
+static int add_to_unpin_list(struct list_head *unpin_list,
+			     struct folio *folio)
+{
+	struct udmabuf_folio *ubuf_folio;
+
+	ubuf_folio = kzalloc(sizeof(*ubuf_folio), GFP_KERNEL);
+	if (!ubuf_folio)
+		return -ENOMEM;
+
+	ubuf_folio->folio = folio;
+	list_add_tail(&ubuf_folio->list, unpin_list);
+	return 0;
+}
+
 static void release_udmabuf(struct dma_buf *buf)
 {
 	struct udmabuf *ubuf = buf->priv;
 	struct device *dev = ubuf->device->this_device;
-	pgoff_t pg;
 
 	if (ubuf->sg)
 		put_sg_table(dev, ubuf->sg, DMA_BIDIRECTIONAL);
 
-	for (pg = 0; pg < ubuf->pagecount; pg++)
-		folio_put(ubuf->folios[pg]);
+	unpin_all_folios(&ubuf->unpin_list);
 	kfree(ubuf->offsets);
 	kfree(ubuf->folios);
 	kfree(ubuf);
@@ -218,64 +250,6 @@ static const struct dma_buf_ops udmabuf_
 #define SEALS_WANTED (F_SEAL_SHRINK)
 #define SEALS_DENIED (F_SEAL_WRITE)
 
-static int handle_hugetlb_pages(struct udmabuf *ubuf, struct file *memfd,
-				pgoff_t offset, pgoff_t pgcnt,
-				pgoff_t *pgbuf)
-{
-	struct hstate *hpstate = hstate_file(memfd);
-	pgoff_t mapidx = offset >> huge_page_shift(hpstate);
-	pgoff_t subpgoff = (offset & ~huge_page_mask(hpstate)) >> PAGE_SHIFT;
-	pgoff_t maxsubpgs = huge_page_size(hpstate) >> PAGE_SHIFT;
-	struct folio *folio = NULL;
-	pgoff_t pgidx;
-
-	mapidx <<= huge_page_order(hpstate);
-	for (pgidx = 0; pgidx < pgcnt; pgidx++) {
-		if (!folio) {
-			folio = __filemap_get_folio(memfd->f_mapping,
-						    mapidx,
-						    FGP_ACCESSED, 0);
-			if (IS_ERR(folio))
-				return PTR_ERR(folio);
-		}
-
-		folio_get(folio);
-		ubuf->folios[*pgbuf] = folio;
-		ubuf->offsets[*pgbuf] = subpgoff << PAGE_SHIFT;
-		(*pgbuf)++;
-		if (++subpgoff == maxsubpgs) {
-			folio_put(folio);
-			folio = NULL;
-			subpgoff = 0;
-			mapidx += pages_per_huge_page(hpstate);
-		}
-	}
-
-	if (folio)
-		folio_put(folio);
-
-	return 0;
-}
-
-static int handle_shmem_pages(struct udmabuf *ubuf, struct file *memfd,
-			      pgoff_t offset, pgoff_t pgcnt,
-			      pgoff_t *pgbuf)
-{
-	pgoff_t pgidx, pgoff = offset >> PAGE_SHIFT;
-	struct folio *folio = NULL;
-
-	for (pgidx = 0; pgidx < pgcnt; pgidx++) {
-		folio = shmem_read_folio(memfd->f_mapping, pgoff + pgidx);
-		if (IS_ERR(folio))
-			return PTR_ERR(folio);
-
-		ubuf->folios[*pgbuf] = folio;
-		(*pgbuf)++;
-	}
-
-	return 0;
-}
-
 static int check_memfd_seals(struct file *memfd)
 {
 	int seals;
@@ -321,16 +295,19 @@ static long udmabuf_create(struct miscde
 			   struct udmabuf_create_list *head,
 			   struct udmabuf_create_item *list)
 {
-	pgoff_t pgcnt, pgbuf = 0, pglimit;
+	pgoff_t pgoff, pgcnt, pglimit, pgbuf = 0;
+	long nr_folios, ret = -EINVAL;
 	struct file *memfd = NULL;
+	struct folio **folios;
 	struct udmabuf *ubuf;
-	int ret = -EINVAL;
-	u32 i, flags;
+	u32 i, j, k, flags;
+	loff_t end;
 
 	ubuf = kzalloc(sizeof(*ubuf), GFP_KERNEL);
 	if (!ubuf)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&ubuf->unpin_list);
 	pglimit = (size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
 	for (i = 0; i < head->count; i++) {
 		if (!IS_ALIGNED(list[i].offset, PAGE_SIZE))
@@ -366,17 +343,46 @@ static long udmabuf_create(struct miscde
 			goto err;
 
 		pgcnt = list[i].size >> PAGE_SHIFT;
-		if (is_file_hugepages(memfd))
-			ret = handle_hugetlb_pages(ubuf, memfd,
-						   list[i].offset,
-						   pgcnt, &pgbuf);
-		else
-			ret = handle_shmem_pages(ubuf, memfd,
-						 list[i].offset,
-						 pgcnt, &pgbuf);
-		if (ret < 0)
+		folios = kmalloc_array(pgcnt, sizeof(*folios), GFP_KERNEL);
+		if (!folios) {
+			ret = -ENOMEM;
 			goto err;
+		}
+
+		end = list[i].offset + (pgcnt << PAGE_SHIFT) - 1;
+		ret = memfd_pin_folios(memfd, list[i].offset, end,
+				       folios, pgcnt, &pgoff);
+		if (ret <= 0) {
+			kfree(folios);
+			if (!ret)
+				ret = -EINVAL;
+			goto err;
+		}
+
+		nr_folios = ret;
+		pgoff >>= PAGE_SHIFT;
+		for (j = 0, k = 0; j < pgcnt; j++) {
+			ubuf->folios[pgbuf] = folios[k];
+			ubuf->offsets[pgbuf] = pgoff << PAGE_SHIFT;
+
+			if (j == 0 || ubuf->folios[pgbuf-1] != folios[k]) {
+				ret = add_to_unpin_list(&ubuf->unpin_list,
+							folios[k]);
+				if (ret < 0) {
+					kfree(folios);
+					goto err;
+				}
+			}
+
+			pgbuf++;
+			if (++pgoff == folio_nr_pages(folios[k])) {
+				pgoff = 0;
+				if (++k == nr_folios)
+					break;
+			}
+		}
 
+		kfree(folios);
 		fput(memfd);
 		memfd = NULL;
 	}
@@ -389,10 +395,9 @@ static long udmabuf_create(struct miscde
 	return ret;
 
 err:
-	while (pgbuf > 0)
-		folio_put(ubuf->folios[--pgbuf]);
 	if (memfd)
 		fput(memfd);
+	unpin_all_folios(&ubuf->unpin_list);
 	kfree(ubuf->offsets);
 	kfree(ubuf->folios);
 	kfree(ubuf);
_

Patches currently in -mm which might be from vivek.kasireddy@intel.com are


