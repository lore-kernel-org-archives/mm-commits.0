Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3C0C4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB26F20936
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601088089;
	bh=B9ww7JefpWKzkR0u5IHZPAeTRw+80MwlnLudGs4Q8wU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wKDiBelhAf1v5a7wBqpm1SMzck5XjPkFIMaJiO/1fupbSq7X4+bLL7htOmdY51afC
	 748Pxg+v3x/TQ9bxBhMljC56pYMmFYapaVo2dDBbYalYiITc1tQGpG0BoLP0NMpo6I
	 gHxjogjF2ExfgzTe0B0CPAJcTC0s8u8GtM3f8jis=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgIZCl3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgIZCl2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:41:28 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD7E020878;
        Sat, 26 Sep 2020 02:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601088088;
        bh=B9ww7JefpWKzkR0u5IHZPAeTRw+80MwlnLudGs4Q8wU=;
        h=Date:From:To:Subject:From;
        b=Frg5JkcebcuYPagB9hCVFue8H19OO0IDyk146JbJ0QzP5qNTrUIyC8bOMve7HzpgT
         RUjTujmOj8MSPd1VbHpQj4xm/Fv8Xdyi6WpwmCsvTIWjB0jRI6su6GfiiQu5UQ/u2I
         lfw7E98Olm40rIxVgH2FsqH4+UPuvhDS2dGV8RL4=
Date:   Fri, 25 Sep 2020 19:41:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com,
        roger.pau@citrix.com, sfr@canb.auug.org.au
Subject:  [obsolete]
 mm-memremap_pages-convert-to-struct-range-fix.patch removed from -mm tree
Message-ID: <20200926024127.0JWrU%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: merge fix up for "mm/memremap_pages: convert to 'struct range'"
has been removed from the -mm tree.  Its filename was
     mm-memremap_pages-convert-to-struct-range-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: merge fix up for "mm/memremap_pages: convert to 'struct range'"

Link: https://lkml.kernel.org/r/20200908200950.1368e71b@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Roger Pau Monn <roger.pau@citrix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/unpopulated-alloc.c |   15 +++++++++------
 fs/fuse/virtio_fs.c             |    3 +--
 2 files changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/xen/unpopulated-alloc.c~mm-memremap_pages-convert-to-struct-range-fix
+++ a/drivers/xen/unpopulated-alloc.c
@@ -18,6 +18,7 @@ static unsigned int list_count;
 static int fill_list(unsigned int nr_pages)
 {
 	struct dev_pagemap *pgmap;
+	struct resource res;
 	void *vaddr;
 	unsigned int i, alloc_pages = round_up(nr_pages, PAGES_PER_SECTION);
 	int ret;
@@ -27,10 +28,10 @@ static int fill_list(unsigned int nr_pag
 		return -ENOMEM;
 
 	pgmap->type = MEMORY_DEVICE_GENERIC;
-	pgmap->res.name = "Xen scratch";
-	pgmap->res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+	res.name = "Xen scratch";
+	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 
-	ret = allocate_resource(&iomem_resource, &pgmap->res,
+	ret = allocate_resource(&iomem_resource, &res,
 				alloc_pages * PAGE_SIZE, 0, -1,
 				PAGES_PER_SECTION * PAGE_SIZE, NULL, NULL);
 	if (ret < 0) {
@@ -38,6 +39,8 @@ static int fill_list(unsigned int nr_pag
 		kfree(pgmap);
 		return ret;
 	}
+	pgmap->range.start = res.start;
+	pgmap->range.end = res.end;
 
 #ifdef CONFIG_XEN_HAVE_PVMMU
         /*
@@ -50,12 +53,12 @@ static int fill_list(unsigned int nr_pag
          * conflict with any devices.
          */
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
-		xen_pfn_t pfn = PFN_DOWN(pgmap->res.start);
+		xen_pfn_t pfn = PFN_DOWN(res.start);
 
 		for (i = 0; i < alloc_pages; i++) {
 			if (!set_phys_to_machine(pfn + i, INVALID_P2M_ENTRY)) {
 				pr_warn("set_phys_to_machine() failed, no memory added\n");
-				release_resource(&pgmap->res);
+				release_resource(&res);
 				kfree(pgmap);
 				return -ENOMEM;
 			}
@@ -66,7 +69,7 @@ static int fill_list(unsigned int nr_pag
 	vaddr = memremap_pages(pgmap, NUMA_NO_NODE);
 	if (IS_ERR(vaddr)) {
 		pr_err("Cannot remap memory range\n");
-		release_resource(&pgmap->res);
+		release_resource(&res);
 		kfree(pgmap);
 		return PTR_ERR(vaddr);
 	}
--- a/fs/fuse/virtio_fs.c~mm-memremap_pages-convert-to-struct-range-fix
+++ a/fs/fuse/virtio_fs.c
@@ -835,8 +835,7 @@ static int virtio_fs_setup_dax(struct vi
 	 * initialize a struct resource from scratch (only the start
 	 * and end fields will be used).
 	 */
-	pgmap->res = (struct resource){
-		.name = "virtio-fs dax window",
+	pgmap->range = (struct range){
 		.start = (phys_addr_t) cache_reg.addr,
 		.end = (phys_addr_t) cache_reg.addr + cache_reg.len - 1,
 	};
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix.patch

