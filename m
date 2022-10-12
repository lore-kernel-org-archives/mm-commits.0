Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF07C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJLW61 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJLW5z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:57:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85994125705
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A239EB81CAB
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D2FC433C1;
        Wed, 12 Oct 2022 22:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615454;
        bh=NqWLQPlmG38LVFIXpT9syBuDbgUWGTU/gUUbAENMoxk=;
        h=Date:To:From:Subject:From;
        b=CTwHeOZhS9Ilq4uNX58LG0r8RwtGMZ6q8nzg72Ng5ZC75IE+PC2qhvvLF7lbcoTZR
         MdDQ6bzvoL0+yvd6nRQ29/GRHul9kVmNcweI15FKX7IumbN4Ps4iO4Yx0EmdH4DX2O
         zuD86Ynd1jRl9dTfhna2p7bp14ouNOZcIW7aclns=
Date:   Wed, 12 Oct 2022 15:57:33 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, shy828301@gmail.com, rcampbell@nvidia.com,
        mpe@ellerman.id.au, lyude@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, Felix.Kuehling@amd.com, david@redhat.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, alex.sierra@amd.com, alexander.deucher@amd.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_devicec-add-migrate_device_range.patch removed from -mm tree
Message-Id: <20221012225734.56D2FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate_device.c: add migrate_device_range()
has been removed from the -mm tree.  Its filename was
     mm-migrate_devicec-add-migrate_device_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/migrate_device.c: add migrate_device_range()
Date: Wed, 28 Sep 2022 22:01:19 +1000

Device drivers can use the migrate_vma family of functions to migrate
existing private anonymous mappings to device private pages.  These pages
are backed by memory on the device with drivers being responsible for
copying data to and from device memory.

Device private pages are freed via the pgmap->page_free() callback when
they are unmapped and their refcount drops to zero.  Alternatively they
may be freed indirectly via migration back to CPU memory in response to a
pgmap->migrate_to_ram() callback called whenever the CPU accesses an
address mapped to a device private page.

In other words drivers cannot control the lifetime of data allocated on
the devices and must wait until these pages are freed from userspace. 
This causes issues when memory needs to reclaimed on the device, either
because the device is going away due to a ->release() callback or because
another user needs to use the memory.

Drivers could use the existing migrate_vma functions to migrate data off
the device.  However this would require them to track the mappings of each
page which is both complicated and not always possible.  Instead drivers
need to be able to migrate device pages directly so they can free up
device memory.

To allow that this patch introduces the migrate_device family of functions
which are functionally similar to migrate_vma but which skips the initial
lookup based on mapping.

Link: https://lkml.kernel.org/r/868116aab70b0c8ee467d62498bb2cf0ef907295.1664366292.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    7 ++
 mm/migrate_device.c     |   89 +++++++++++++++++++++++++++++++++++---
 2 files changed, 89 insertions(+), 7 deletions(-)

--- a/include/linux/migrate.h~mm-migrate_devicec-add-migrate_device_range
+++ a/include/linux/migrate.h
@@ -210,6 +210,13 @@ struct migrate_vma {
 int migrate_vma_setup(struct migrate_vma *args);
 void migrate_vma_pages(struct migrate_vma *migrate);
 void migrate_vma_finalize(struct migrate_vma *migrate);
+int migrate_device_range(unsigned long *src_pfns, unsigned long start,
+			unsigned long npages);
+void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
+			unsigned long npages);
+void migrate_device_finalize(unsigned long *src_pfns,
+			unsigned long *dst_pfns, unsigned long npages);
+
 #endif /* CONFIG_MIGRATION */
 
 #endif /* _LINUX_MIGRATE_H */
--- a/mm/migrate_device.c~mm-migrate_devicec-add-migrate_device_range
+++ a/mm/migrate_device.c
@@ -693,7 +693,7 @@ abort:
 	*src &= ~MIGRATE_PFN_MIGRATE;
 }
 
-static void migrate_device_pages(unsigned long *src_pfns,
+static void __migrate_device_pages(unsigned long *src_pfns,
 				unsigned long *dst_pfns, unsigned long npages,
 				struct migrate_vma *migrate)
 {
@@ -715,6 +715,9 @@ static void migrate_device_pages(unsigne
 		if (!page) {
 			unsigned long addr;
 
+			if (!(src_pfns[i] & MIGRATE_PFN_MIGRATE))
+				continue;
+
 			/*
 			 * The only time there is no vma is when called from
 			 * migrate_device_coherent_page(). However this isn't
@@ -722,8 +725,6 @@ static void migrate_device_pages(unsigne
 			 */
 			VM_BUG_ON(!migrate);
 			addr = migrate->start + i*PAGE_SIZE;
-			if (!(src_pfns[i] & MIGRATE_PFN_MIGRATE))
-				continue;
 			if (!notified) {
 				notified = true;
 
@@ -779,6 +780,22 @@ static void migrate_device_pages(unsigne
 }
 
 /**
+ * migrate_device_pages() - migrate meta-data from src page to dst page
+ * @src_pfns: src_pfns returned from migrate_device_range()
+ * @dst_pfns: array of pfns allocated by the driver to migrate memory to
+ * @npages: number of pages in the range
+ *
+ * Equivalent to migrate_vma_pages(). This is called to migrate struct page
+ * meta-data from source struct page to destination.
+ */
+void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
+			unsigned long npages)
+{
+	__migrate_device_pages(src_pfns, dst_pfns, npages, NULL);
+}
+EXPORT_SYMBOL(migrate_device_pages);
+
+/**
  * migrate_vma_pages() - migrate meta-data from src page to dst page
  * @migrate: migrate struct containing all migration information
  *
@@ -788,12 +805,22 @@ static void migrate_device_pages(unsigne
  */
 void migrate_vma_pages(struct migrate_vma *migrate)
 {
-	migrate_device_pages(migrate->src, migrate->dst, migrate->npages, migrate);
+	__migrate_device_pages(migrate->src, migrate->dst, migrate->npages, migrate);
 }
 EXPORT_SYMBOL(migrate_vma_pages);
 
-static void migrate_device_finalize(unsigned long *src_pfns,
-				unsigned long *dst_pfns, unsigned long npages)
+/*
+ * migrate_device_finalize() - complete page migration
+ * @src_pfns: src_pfns returned from migrate_device_range()
+ * @dst_pfns: array of pfns allocated by the driver to migrate memory to
+ * @npages: number of pages in the range
+ *
+ * Completes migration of the page by removing special migration entries.
+ * Drivers must ensure copying of page data is complete and visible to the CPU
+ * before calling this.
+ */
+void migrate_device_finalize(unsigned long *src_pfns,
+			unsigned long *dst_pfns, unsigned long npages)
 {
 	unsigned long i;
 
@@ -837,6 +864,7 @@ static void migrate_device_finalize(unsi
 		}
 	}
 }
+EXPORT_SYMBOL(migrate_device_finalize);
 
 /**
  * migrate_vma_finalize() - restore CPU page table entry
@@ -855,6 +883,53 @@ void migrate_vma_finalize(struct migrate
 }
 EXPORT_SYMBOL(migrate_vma_finalize);
 
+/**
+ * migrate_device_range() - migrate device private pfns to normal memory.
+ * @src_pfns: array large enough to hold migrating source device private pfns.
+ * @start: starting pfn in the range to migrate.
+ * @npages: number of pages to migrate.
+ *
+ * migrate_vma_setup() is similar in concept to migrate_vma_setup() except that
+ * instead of looking up pages based on virtual address mappings a range of
+ * device pfns that should be migrated to system memory is used instead.
+ *
+ * This is useful when a driver needs to free device memory but doesn't know the
+ * virtual mappings of every page that may be in device memory. For example this
+ * is often the case when a driver is being unloaded or unbound from a device.
+ *
+ * Like migrate_vma_setup() this function will take a reference and lock any
+ * migrating pages that aren't free before unmapping them. Drivers may then
+ * allocate destination pages and start copying data from the device to CPU
+ * memory before calling migrate_device_pages().
+ */
+int migrate_device_range(unsigned long *src_pfns, unsigned long start,
+			unsigned long npages)
+{
+	unsigned long i, pfn;
+
+	for (pfn = start, i = 0; i < npages; pfn++, i++) {
+		struct page *page = pfn_to_page(pfn);
+
+		if (!get_page_unless_zero(page)) {
+			src_pfns[i] = 0;
+			continue;
+		}
+
+		if (!trylock_page(page)) {
+			src_pfns[i] = 0;
+			put_page(page);
+			continue;
+		}
+
+		src_pfns[i] = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
+	}
+
+	migrate_device_unmap(src_pfns, npages, NULL);
+
+	return 0;
+}
+EXPORT_SYMBOL(migrate_device_range);
+
 /*
  * Migrate a device coherent page back to normal memory. The caller should have
  * a reference on page which will be copied to the new page if migration is
@@ -885,7 +960,7 @@ int migrate_device_coherent_page(struct
 		dst_pfn = migrate_pfn(page_to_pfn(dpage));
 	}
 
-	migrate_device_pages(&src_pfn, &dst_pfn, 1, NULL);
+	migrate_device_pages(&src_pfn, &dst_pfn, 1);
 	if (src_pfn & MIGRATE_PFN_MIGRATE)
 		copy_highpage(dpage, page);
 	migrate_device_finalize(&src_pfn, &dst_pfn, 1);
_

Patches currently in -mm which might be from apopple@nvidia.com are

nouveau-dmem-refactor-nouveau_dmem_fault_copy_one.patch
nouveau-dmem-evict-device-private-memory-during-release.patch
hmm-tests-add-test-for-migrate_device_range.patch

