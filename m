Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5936C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 22:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236291AbiBGWYB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 17:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233002AbiBGWYA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 17:24:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9629CC0612A4
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 14:23:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 571B8B81709
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 22:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5E6C004E1;
        Mon,  7 Feb 2022 22:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644272637;
        bh=VDl7KEk9KOL/qQ4iQEfaj66b8zXA8aIkkIKVsRYia/s=;
        h=Date:To:From:Subject:From;
        b=MqTGvi19INNIVq3h0G2cLuhBQdj7Y01fyvXtaL9WFe1Gzzx4C+oL2DpT727o7ztcN
         wIzLoIlR8VZ0xZctH4gjJj47MFjLjHOiRUR/TfCnLDn/Txq1Ncoa/cKk8oJbmnokj8
         QfOEUTZbvEyQLhq4+iMvwtFt88azT4pO2bj4+w/4=
Date:   Mon, 07 Feb 2022 14:23:56 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jhubbard@nvidia.com, jglisse@redhat.com,
        jgg@nvidia.com, hch@lst.de, Felix.Kuehling@amd.com,
        Alex.Sierra@amd.com, apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migratec-remove-vma-check-in-migrate_vma_setup.patch added to -mm tree
Message-Id: <20220207222356.EF5E6C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate.c: remove vma check in migrate_vma_setup()
has been added to the -mm tree.  Its filename is
     migratec-remove-vma-check-in-migrate_vma_setup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/migratec-remove-vma-check-in-migrate_vma_setup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/migratec-remove-vma-check-in-migrate_vma_setup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2609,24 +2609,24 @@ int migrate_vma_setup(struct migrate_vma
 
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
@@ -2811,7 +2811,7 @@ void migrate_vma_pages(struct migrate_vm
 			continue;
 		}
 
-		if (!page) {
+		if (!page && migrate->vma) {
 			if (!(migrate->src[i] & MIGRATE_PFN_MIGRATE))
 				continue;
 			if (!notified) {
_

Patches currently in -mm which might be from apopple@nvidia.com are

migratec-remove-vma-check-in-migrate_vma_setup.patch
mm-gupc-migrate-device-coherent-pages-when-pinning-instead-of-failing.patch

