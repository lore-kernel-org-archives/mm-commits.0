Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36FB2CDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 20:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbjJRU10 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 16:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbjJRU1O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 16:27:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FE3A4
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 13:27:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132D1C433D9;
        Wed, 18 Oct 2023 20:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697660832;
        bh=aXRBeRiywNgyqTL+BINZ1CPWWJ2U3dO7fHeOmrO8OTA=;
        h=Date:To:From:Subject:From;
        b=CXSPoAZvzuYlnLbkWsuORotqf3KIS1ell9dOP/N5juJ11KCG1omv7dygDWHbDM8jc
         E7e/PPJGNYNPcTmj53OoV6lkZtwG2xPgZfF3h/sxUXo4lxeV7SeojIqEOLKUQ7CbGV
         H9ZfN2ytQtBoeCBIcCJOokAS5iU16hfNANuKGsBE=
Date:   Wed, 18 Oct 2023 13:27:11 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, peterx@redhat.com,
        mike.kravetz@oracle.com, kraxel@redhat.com,
        junxiao.chang@intel.com, jgg@nvidia.com, hughd@google.com,
        dongwon.kim@intel.com, david@redhat.com, daniel.vetter@ffwll.ch,
        vivek.kasireddy@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] udmabuf-pin-the-pages-using-pin_user_pages_fd-api.patch removed from -mm tree
Message-Id: <20231018202712.132D1C433D9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: udmabuf: pin the pages using pin_user_pages_fd() API
has been removed from the -mm tree.  Its filename was
     udmabuf-pin-the-pages-using-pin_user_pages_fd-api.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: udmabuf: pin the pages using pin_user_pages_fd() API
Date: Tue, 3 Oct 2023 00:44:46 -0700

Using pin_user_pages_fd() will ensure that the pages are pinned correctly
using FOLL_PIN.  And, this also ensures that we don't accidentally break
features such as memory hotunplug as it would not allow pinning pages in
the movable zone.

This patch also adds back support for mapping hugetlbfs pages by noting
the subpage offsets within the huge pages and uses this information while
populating the scatterlist.

Link: https://lkml.kernel.org/r/20231003074447.3245729-3-vivek.kasireddy@intel.com
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma-buf/udmabuf.c |   82 ++++++++++++++++++++++++++----------
 1 file changed, 61 insertions(+), 21 deletions(-)

--- a/drivers/dma-buf/udmabuf.c~udmabuf-pin-the-pages-using-pin_user_pages_fd-api
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
+	pgoff_t *subpgoff;
 };
 
 static vm_fault_t udmabuf_vm_fault(struct vm_fault *vmf)
@@ -88,23 +90,31 @@ static struct sg_table *get_sg_table(str
 {
 	struct udmabuf *ubuf = buf->priv;
 	struct sg_table *sg;
+	struct scatterlist *sgl;
+	pgoff_t offset;
+	unsigned long i = 0;
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
+	for_each_sg(sg->sgl, sgl, ubuf->pagecount, i) {
+		offset = ubuf->subpgoff ? ubuf->subpgoff[i] : 0;
+		sg_set_page(sgl, ubuf->pages[i], PAGE_SIZE, offset);
+	}
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
@@ -140,7 +150,9 @@ static void release_udmabuf(struct dma_b
 		put_sg_table(dev, ubuf->sg, DMA_BIDIRECTIONAL);
 
 	for (pg = 0; pg < ubuf->pagecount; pg++)
-		put_page(ubuf->pages[pg]);
+		unpin_user_page(ubuf->pages[pg]);
+
+	kfree(ubuf->subpgoff);
 	kfree(ubuf->pages);
 	kfree(ubuf);
 }
@@ -200,12 +212,13 @@ static long udmabuf_create(struct miscde
 {
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
 	struct file *memfd = NULL;
-	struct address_space *mapping = NULL;
 	struct udmabuf *ubuf;
 	struct dma_buf *buf;
-	pgoff_t pgoff, pgcnt, pgidx, pgbuf = 0, pglimit;
-	struct page *page;
-	int seals, ret = -EINVAL;
+	pgoff_t pgoff, pgcnt, pgbuf = 0, pglimit, nr_pages;
+	pgoff_t subpgoff, maxsubpgs;
+	struct hstate *hpstate;
+	long ret = -EINVAL;
+	int seals;
 	u32 i, flags;
 
 	ubuf = kzalloc(sizeof(*ubuf), GFP_KERNEL);
@@ -239,8 +252,7 @@ static long udmabuf_create(struct miscde
 		memfd = fget(list[i].memfd);
 		if (!memfd)
 			goto err;
-		mapping = memfd->f_mapping;
-		if (!shmem_mapping(mapping))
+		if (!shmem_file(memfd) && !is_file_hugepages(memfd))
 			goto err;
 		seals = memfd_fcntl(memfd, F_GET_SEALS, 0);
 		if (seals == -EINVAL)
@@ -251,14 +263,41 @@ static long udmabuf_create(struct miscde
 			goto err;
 		pgoff = list[i].offset >> PAGE_SHIFT;
 		pgcnt = list[i].size   >> PAGE_SHIFT;
-		for (pgidx = 0; pgidx < pgcnt; pgidx++) {
-			page = shmem_read_mapping_page(mapping, pgoff + pgidx);
-			if (IS_ERR(page)) {
-				ret = PTR_ERR(page);
-				goto err;
+		if (is_file_hugepages(memfd)) {
+			if (!ubuf->subpgoff) {
+				ubuf->subpgoff = kmalloc_array(ubuf->pagecount,
+							       sizeof(*ubuf->subpgoff),
+							       GFP_KERNEL);
+				if (!ubuf->subpgoff) {
+					ret = -ENOMEM;
+					goto err;
+				}
 			}
-			ubuf->pages[pgbuf++] = page;
+			hpstate = hstate_file(memfd);
+			pgoff = list[i].offset >> huge_page_shift(hpstate);
+			subpgoff = (list[i].offset &
+				    ~huge_page_mask(hpstate)) >> PAGE_SHIFT;
+			maxsubpgs = huge_page_size(hpstate) >> PAGE_SHIFT;
 		}
+
+		do {
+			nr_pages = shmem_file(memfd) ? pgcnt : 1;
+			ret = pin_user_pages_fd(list[i].memfd, pgoff,
+						nr_pages, FOLL_LONGTERM,
+						ubuf->pages + pgbuf);
+			if (ret < 0)
+				goto err;
+
+			if (is_file_hugepages(memfd)) {
+				ubuf->subpgoff[pgbuf] = subpgoff << PAGE_SHIFT;
+				if (++subpgoff == maxsubpgs) {
+					subpgoff = 0;
+					pgoff++;
+				}
+			}
+			pgbuf += nr_pages;
+			pgcnt -= nr_pages;
+		} while (pgcnt > 0);
 		fput(memfd);
 		memfd = NULL;
 	}
@@ -281,10 +320,11 @@ static long udmabuf_create(struct miscde
 	return dma_buf_fd(buf, flags);
 
 err:
-	while (pgbuf > 0)
-		put_page(ubuf->pages[--pgbuf]);
+	while (pgbuf > 0 && ubuf->pages[--pgbuf])
+		unpin_user_page(ubuf->pages[pgbuf]);
 	if (memfd)
 		fput(memfd);
+	kfree(ubuf->subpgoff);
 	kfree(ubuf->pages);
 	kfree(ubuf);
 	return ret;
_

Patches currently in -mm which might be from vivek.kasireddy@intel.com are

selftests-dma-buf-udmabuf-add-tests-to-verify-data-after-page-migration.patch

