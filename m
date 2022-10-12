Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DCF2C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJLW6r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJLW55 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:57:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A18A12793A
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C90A261695
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4F4C433D6;
        Wed, 12 Oct 2022 22:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615458;
        bh=y5M5tdwAuMRreS4F1ya2WkWr3BNrQD89EiOZKhpjHRo=;
        h=Date:To:From:Subject:From;
        b=nU76SmOTOihUWt/Ahn+eQK6gE/qoHBXGyDNPGRN1sKOlwuzHZONK/DlBlAdOpiSE1
         0pD+tZ2zkwEB/bdcHw5ZvwvwjmFCDY5ddkwBx8+q/rrLiylzPGfoJUBtNqOnZ3r1PW
         x2kUw3WxY+G3ey6Pcn2iETVZMht2avCQjDKSENh4=
Date:   Wed, 12 Oct 2022 15:57:37 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, shy828301@gmail.com, rcampbell@nvidia.com,
        mpe@ellerman.id.au, lyude@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, Felix.Kuehling@amd.com, david@redhat.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, alex.sierra@amd.com, alexander.deucher@amd.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hmm-tests-add-test-for-migrate_device_range.patch removed from -mm tree
Message-Id: <20221012225738.2A4F4C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hmm-tests: add test for migrate_device_range()
has been removed from the -mm tree.  Its filename was
     hmm-tests-add-test-for-migrate_device_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: hmm-tests: add test for migrate_device_range()
Date: Wed, 28 Sep 2022 22:01:22 +1000

Link: https://lkml.kernel.org/r/a73cf109de0224cfd118d22be58ddebac3ae2897.1664366292.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c                         |  120 ++++++++++++++++++-----
 lib/test_hmm_uapi.h                    |    1 
 tools/testing/selftests/vm/hmm-tests.c |   49 +++++++++
 3 files changed, 149 insertions(+), 21 deletions(-)

--- a/lib/test_hmm.c~hmm-tests-add-test-for-migrate_device_range
+++ a/lib/test_hmm.c
@@ -100,6 +100,7 @@ struct dmirror {
 struct dmirror_chunk {
 	struct dev_pagemap	pagemap;
 	struct dmirror_device	*mdevice;
+	bool remove;
 };
 
 /*
@@ -192,11 +193,15 @@ static int dmirror_fops_release(struct i
 	return 0;
 }
 
+static struct dmirror_chunk *dmirror_page_to_chunk(struct page *page)
+{
+	return container_of(page->pgmap, struct dmirror_chunk, pagemap);
+}
+
 static struct dmirror_device *dmirror_page_to_device(struct page *page)
 
 {
-	return container_of(page->pgmap, struct dmirror_chunk,
-			    pagemap)->mdevice;
+	return dmirror_page_to_chunk(page)->mdevice;
 }
 
 static int dmirror_do_fault(struct dmirror *dmirror, struct hmm_range *range)
@@ -1218,6 +1223,85 @@ static int dmirror_snapshot(struct dmirr
 	return ret;
 }
 
+static void dmirror_device_evict_chunk(struct dmirror_chunk *chunk)
+{
+	unsigned long start_pfn = chunk->pagemap.range.start >> PAGE_SHIFT;
+	unsigned long end_pfn = chunk->pagemap.range.end >> PAGE_SHIFT;
+	unsigned long npages = end_pfn - start_pfn + 1;
+	unsigned long i;
+	unsigned long *src_pfns;
+	unsigned long *dst_pfns;
+
+	src_pfns = kcalloc(npages, sizeof(*src_pfns), GFP_KERNEL);
+	dst_pfns = kcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL);
+
+	migrate_device_range(src_pfns, start_pfn, npages);
+	for (i = 0; i < npages; i++) {
+		struct page *dpage, *spage;
+
+		spage = migrate_pfn_to_page(src_pfns[i]);
+		if (!spage || !(src_pfns[i] & MIGRATE_PFN_MIGRATE))
+			continue;
+
+		if (WARN_ON(!is_device_private_page(spage) &&
+			    !is_device_coherent_page(spage)))
+			continue;
+		spage = BACKING_PAGE(spage);
+		dpage = alloc_page(GFP_HIGHUSER_MOVABLE | __GFP_NOFAIL);
+		lock_page(dpage);
+		copy_highpage(dpage, spage);
+		dst_pfns[i] = migrate_pfn(page_to_pfn(dpage));
+		if (src_pfns[i] & MIGRATE_PFN_WRITE)
+			dst_pfns[i] |= MIGRATE_PFN_WRITE;
+	}
+	migrate_device_pages(src_pfns, dst_pfns, npages);
+	migrate_device_finalize(src_pfns, dst_pfns, npages);
+	kfree(src_pfns);
+	kfree(dst_pfns);
+}
+
+/* Removes free pages from the free list so they can't be re-allocated */
+static void dmirror_remove_free_pages(struct dmirror_chunk *devmem)
+{
+	struct dmirror_device *mdevice = devmem->mdevice;
+	struct page *page;
+
+	for (page = mdevice->free_pages; page; page = page->zone_device_data)
+		if (dmirror_page_to_chunk(page) == devmem)
+			mdevice->free_pages = page->zone_device_data;
+}
+
+static void dmirror_device_remove_chunks(struct dmirror_device *mdevice)
+{
+	unsigned int i;
+
+	mutex_lock(&mdevice->devmem_lock);
+	if (mdevice->devmem_chunks) {
+		for (i = 0; i < mdevice->devmem_count; i++) {
+			struct dmirror_chunk *devmem =
+				mdevice->devmem_chunks[i];
+
+			spin_lock(&mdevice->lock);
+			devmem->remove = true;
+			dmirror_remove_free_pages(devmem);
+			spin_unlock(&mdevice->lock);
+
+			dmirror_device_evict_chunk(devmem);
+			memunmap_pages(&devmem->pagemap);
+			if (devmem->pagemap.type == MEMORY_DEVICE_PRIVATE)
+				release_mem_region(devmem->pagemap.range.start,
+						   range_len(&devmem->pagemap.range));
+			kfree(devmem);
+		}
+		mdevice->devmem_count = 0;
+		mdevice->devmem_capacity = 0;
+		mdevice->free_pages = NULL;
+		kfree(mdevice->devmem_chunks);
+		mdevice->devmem_chunks = NULL;
+	}
+	mutex_unlock(&mdevice->devmem_lock);
+}
+
 static long dmirror_fops_unlocked_ioctl(struct file *filp,
 					unsigned int command,
 					unsigned long arg)
@@ -1272,6 +1356,11 @@ static long dmirror_fops_unlocked_ioctl(
 		ret = dmirror_snapshot(dmirror, &cmd);
 		break;
 
+	case HMM_DMIRROR_RELEASE:
+		dmirror_device_remove_chunks(dmirror->mdevice);
+		ret = 0;
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -1326,9 +1415,13 @@ static void dmirror_devmem_free(struct p
 
 	mdevice = dmirror_page_to_device(page);
 	spin_lock(&mdevice->lock);
-	mdevice->cfree++;
-	page->zone_device_data = mdevice->free_pages;
-	mdevice->free_pages = page;
+
+	/* Return page to our allocator if not freeing the chunk */
+	if (!dmirror_page_to_chunk(page)->remove) {
+		mdevice->cfree++;
+		page->zone_device_data = mdevice->free_pages;
+		mdevice->free_pages = page;
+	}
 	spin_unlock(&mdevice->lock);
 }
 
@@ -1408,22 +1501,7 @@ static int dmirror_device_init(struct dm
 
 static void dmirror_device_remove(struct dmirror_device *mdevice)
 {
-	unsigned int i;
-
-	if (mdevice->devmem_chunks) {
-		for (i = 0; i < mdevice->devmem_count; i++) {
-			struct dmirror_chunk *devmem =
-				mdevice->devmem_chunks[i];
-
-			memunmap_pages(&devmem->pagemap);
-			if (devmem->pagemap.type == MEMORY_DEVICE_PRIVATE)
-				release_mem_region(devmem->pagemap.range.start,
-						   range_len(&devmem->pagemap.range));
-			kfree(devmem);
-		}
-		kfree(mdevice->devmem_chunks);
-	}
-
+	dmirror_device_remove_chunks(mdevice);
 	cdev_device_del(&mdevice->cdevice, &mdevice->device);
 }
 
--- a/lib/test_hmm_uapi.h~hmm-tests-add-test-for-migrate_device_range
+++ a/lib/test_hmm_uapi.h
@@ -36,6 +36,7 @@ struct hmm_dmirror_cmd {
 #define HMM_DMIRROR_SNAPSHOT		_IOWR('H', 0x04, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_EXCLUSIVE		_IOWR('H', 0x05, struct hmm_dmirror_cmd)
 #define HMM_DMIRROR_CHECK_EXCLUSIVE	_IOWR('H', 0x06, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_RELEASE		_IOWR('H', 0x07, struct hmm_dmirror_cmd)
 
 /*
  * Values returned in hmm_dmirror_cmd.ptr for HMM_DMIRROR_SNAPSHOT.
--- a/tools/testing/selftests/vm/hmm-tests.c~hmm-tests-add-test-for-migrate_device_range
+++ a/tools/testing/selftests/vm/hmm-tests.c
@@ -1054,6 +1054,55 @@ TEST_F(hmm, migrate_fault)
 	hmm_buffer_free(buffer);
 }
 
+TEST_F(hmm, migrate_release)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	int *ptr;
+	int ret;
+
+	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
+	ASSERT_NE(npages, 0);
+	size = npages << self->page_shift;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+
+	buffer->ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS, buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/* Migrate memory to device. */
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	/* Release device memory. */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_RELEASE, buffer, npages);
+	ASSERT_EQ(ret, 0);
+
+	/* Fault pages back to system memory and check them. */
+	for (i = 0, ptr = buffer->ptr; i < size / (2 * sizeof(*ptr)); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	hmm_buffer_free(buffer);
+}
+
 /*
  * Migrate anonymous shared memory to device private memory.
  */
_

Patches currently in -mm which might be from apopple@nvidia.com are


