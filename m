Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C81EC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 20:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353343AbiBKUrL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 15:47:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiBKUrJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 15:47:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94028CF9
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 12:47:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46470B82CA7
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 20:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA985C340E9;
        Fri, 11 Feb 2022 20:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644612425;
        bh=uOJw7viZlOuN46tRb1tABhrHcxL7rPLnRAjWV9fSuP4=;
        h=Date:To:From:Subject:From;
        b=H9rbsoqIk/GMO1GgskHmng9cQs9x17pEKLioe3uqlV9g1pM2gUzBF/EcUjWCUU4oG
         3q/zU4tAQYk2je895lq2l4rjsFujaI6J6Bc83tNgHbf9IysbH085s1N2YFJps4b/bp
         CDTVJxGPiPs0XDdR5ika+1PkZNlTJcP26OVgQPD0=
Date:   Fri, 11 Feb 2022 12:47:04 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, hch@lst.de, Felix.Kuehling@amd.com,
        Alex.Sierra@amd.com, apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] migratec-remove-vma-check-in-migrate_vma_setup.patch removed from -mm tree
Message-Id: <20220211204704.DA985C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate.c: remove vma check in migrate_vma_setup()
has been removed from the -mm tree.  Its filename was
     migratec-remove-vma-check-in-migrate_vma_setup.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: migrate.c: remove vma check in migrate_vma_setup()

Patch series "Migrate device coherent pages on get_user_pages()", v2.

Device coherent pages represent memory on a coherently attached device
such as a GPU which is usually under the control of a driver.  These pages
should not be pinned as the driver needs to be able to move pages as
required.  Currently this is enforced by failing any attempt to pin a
device coherent page.

A similar problem exists for ZONE_MOVABLE pages.  In that case though the
pages are migrated instead of causing failure.  There is no reason the
kernel can't migrate device coherent pages so this series implements
migration for device coherent pages so the same strategy of migrate and
pin can be used.

This series depends on the series "Add MEMORY_DEVICE_COHERENT for coherent
device memory mapping"[1] which is in linux-next-20220204 and should apply
cleanly to that.

[1] - https://lore.kernel.org/linux-mm/20220128200825.8623-1-alex.sierra@amd.com/


This patch (of 2):

migrate_vma_setup() checks that a valid vma is passed so that the page
tables can be walked to find the pfns associated with a given address
range.  However in some cases the pfns are already known, such as when
migrating device coherent pages during pin_user_pages() meaning a valid
vma isn't required.

Link: https://lkml.kernel.org/r/cover.0d3c846b1c6c294e055ff7ebe221fab9964c1436.1644207242.git-series.apopple@nvidia.com
Link: https://lkml.kernel.org/r/6831bf69f7c7699be83b31c9c56212b5fb07f873.1644207242.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alex Sierra <Alex.Sierra@amd.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/mm/migrate.c~migratec-remove-vma-check-in-migrate_vma_setup
+++ a/mm/migrate.c
@@ -2613,24 +2613,24 @@ int migrate_vma_setup(struct migrate_vma
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
-	if (!args->vma || is_vm_hugetlb_page(args->vma) ||
-	    (args->vma->vm_flags & VM_SPECIAL) || vma_is_dax(args->vma))
-		return -EINVAL;
-	if (nr_pages <= 0)
-		return -EINVAL;
-	if (args->start < args->vma->vm_start ||
-	    args->start >= args->vma->vm_end)
-		return -EINVAL;
-	if (args->end <= args->vma->vm_start || args->end > args->vma->vm_end)
-		return -EINVAL;
 	if (!args->src || !args->dst)
 		return -EINVAL;
+	if (args->vma) {
+		if (is_vm_hugetlb_page(args->vma) ||
+			(args->vma->vm_flags & VM_SPECIAL) || vma_is_dax(args->vma))
+			return -EINVAL;
+		if (args->start < args->vma->vm_start ||
+			args->start >= args->vma->vm_end)
+			return -EINVAL;
+		if (args->end <= args->vma->vm_start || args->end > args->vma->vm_end)
+			return -EINVAL;
+
+		memset(args->src, 0, sizeof(*args->src) * nr_pages);
+		args->cpages = 0;
+		args->npages = 0;
 
-	memset(args->src, 0, sizeof(*args->src) * nr_pages);
-	args->cpages = 0;
-	args->npages = 0;
-
-	migrate_vma_collect(args);
+		migrate_vma_collect(args);
+	}
 
 	if (args->cpages)
 		migrate_vma_unmap(args);
@@ -2815,7 +2815,7 @@ void migrate_vma_pages(struct migrate_vm
 			continue;
 		}
 
-		if (!page) {
+		if (!page && migrate->vma) {
 			if (!(migrate->src[i] & MIGRATE_PFN_MIGRATE))
 				continue;
 			if (!notified) {
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-remove-the-vma-check-in-migrate_vma_setup.patch
mm-gup-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch
mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch

