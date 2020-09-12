Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2080C43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 18:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61C9C2158C
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 18:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599935972;
	bh=Ugwo+prF896w6UqB7bFwajNYehp2dmoj8teB8eIUE0s=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=I/e4VPebaJQG/9pJRNCL0cBqb+EDE6muq7KqsWmvumB7qrrr0J/t0GvAKGY4xwvEy
	 dNomgCttyT3ACXM2oX3bqlrt3hIMO5JHcTjpHeen/0wfb6cjVhrrboLgSZ1JArT25l
	 XJxQmFSmgLpBDUur+YLuP2D85spg7Aoe/hXA3Mzg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbgILSjb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 14:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgILSja (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 14:39:30 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4E3621531;
        Sat, 12 Sep 2020 18:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599935969;
        bh=Ugwo+prF896w6UqB7bFwajNYehp2dmoj8teB8eIUE0s=;
        h=Date:From:To:Subject:From;
        b=PUyUaA0tl6esN9A6/Vg5bsKdi9+6XWZoVfR7ZclA04zoBuoVyizVNCqoEwxwVuC8j
         HtJ8lrKz0kweISBdgj3OvLOGJhojnjOV001v624e/99sf9Z3oChF1b3ZgyoQq9QK5y
         IGx1F77oeotMJuAdM09JLmNRfacdI7fPfSOEhBcU=
Date:   Sat, 12 Sep 2020 11:39:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vgoyal@redhat.com,
        roger.pau@citrix.com, sfr@canb.auug.org.au
Subject:  + mm-memremap_pages-convert-to-struct-range-fix.patch added
 to -mm tree
Message-ID: <20200912183929.lynbB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: merge fix up for "mm/memremap_pages: convert to 'struct range'"
has been added to the -mm tree.  Its filename is
     mm-memremap_pages-convert-to-struct-range-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memremap_pages-convert-to-struct-range-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memremap_pages-convert-to-struct-range-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memremap_pages-convert-to-struct-range-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix.patch

