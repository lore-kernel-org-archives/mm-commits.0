Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B6C6C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Feb 2022 20:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353399AbiBKUuL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 15:50:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353391AbiBKUuC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 15:50:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C055ECEC
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 12:50:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6911BB82D02
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 20:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFC4C340E9;
        Fri, 11 Feb 2022 20:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644612598;
        bh=BWC5m2zYHqyMWQHLay5sc3aJi9uAW8O6MqWJPwt2atE=;
        h=Date:To:From:Subject:From;
        b=el5zNsbVGDOX0VG5oj0HKGpAadOpx2IC99N1yAAYWt5x39DgrRDKxUqDhiJcz5SIw
         19+WZ1bWVRwtAEhOCcNkCvNkhntrQGmCbjVXhE7fF85OPmOjKPFkCYFh5PBganO6nD
         13IVkq+nfV332l18/figRFZA/jY6xcmYxzcF2QEI=
Date:   Fri, 11 Feb 2022 12:49:57 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        songmuchun@bytedance.com, rcampbell@nvidia.com, lyude@redhat.com,
        logang@deltatee.com, linmiaohe@huawei.com, kherbst@redhat.com,
        kch@nvidia.com, jgg@nvidia.com, hch@lst.de, Felix.Kuehling@amd.com,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        bskeggs@redhat.com, alex.sierra@amd.com, alexander.deucher@amd.com,
        apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-vma-check-in-migrate_vma_setup.patch added to -mm tree
Message-Id: <20220211204957.ECFC4C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove the vma check in migrate_vma_setup()
has been added to the -mm tree.  Its filename is
     mm-remove-the-vma-check-in-migrate_vma_setup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-the-vma-check-in-migrate_vma_setup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-the-vma-check-in-migrate_vma_setup.patch

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
Subject: mm: remove the vma check in migrate_vma_setup()

migrate_vma_setup() checks that a valid vma is passed so that the page
tables can be walked to find the pfns associated with a given address
range.  However in some cases the pfns are already known, such as when
migrating device coherent pages during pin_user_pages() meaning a valid
vma isn't required.

Link: https://lkml.kernel.org/r/20220210072828.2930359-26-hch@lst.de
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Tested-by: "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Christian Knig <christian.koenig@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate_device.c~mm-remove-the-vma-check-in-migrate_vma_setup
+++ a/mm/migrate_device.c
@@ -462,24 +462,24 @@ int migrate_vma_setup(struct migrate_vma
 
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
+		    (args->vma->vm_flags & VM_SPECIAL) || vma_is_dax(args->vma))
+			return -EINVAL;
+		if (args->start < args->vma->vm_start ||
+		    args->start >= args->vma->vm_end)
+			return -EINVAL;
+		if (args->end <= args->vma->vm_start ||
+		    args->end > args->vma->vm_end)
+			return -EINVAL;
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
@@ -661,7 +661,7 @@ void migrate_vma_pages(struct migrate_vm
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

