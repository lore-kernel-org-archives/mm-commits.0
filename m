Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DDBFC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 19:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbiBATx6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 14:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbiBATx6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 14:53:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15388C061714
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 11:53:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B188F61682
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 19:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21F0C340EB;
        Tue,  1 Feb 2022 19:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643745237;
        bh=ydD9+doDhU/z9tO9w7spV+7S24TmAF/I8Ng+UXSuVOE=;
        h=Date:To:From:Subject:From;
        b=nI5S8c5X8kdnIbmMIgb3G5W66roeX45LgxcPBAsgPHOJ5Xfkfy5uXVgV8Utplm99d
         Zog0kBge9ylnJv13gHJZQYb1i38FuZvUMzAoURk6VNjkbNpCPm/S4Oove4RUa0KAW6
         Ke1pjzovg4fup4J8rM5a6mKBwubCSBfKcOMCFdzM=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 11:53:55 -0800
Date:   Tue, 01 Feb 2022 11:53:55 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, apopple@nvidia.com,
        alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-amdkfd-coherent-type-as-sys-mem-on-migration-to-ram.patch added to -mm tree
Message-Id: <20220201195355.D21F0C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm/amdkfd: coherent type as sys mem on migration to ram
has been added to the -mm tree.  Its filename is
     drm-amdkfd-coherent-type-as-sys-mem-on-migration-to-ram.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/drm-amdkfd-coherent-type-as-sys-mem-on-migration-to-ram.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/drm-amdkfd-coherent-type-as-sys-mem-on-migration-to-ram.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Sierra <alex.sierra@amd.com>
Subject: drm/amdkfd: coherent type as sys mem on migration to ram

Coherent device type memory on VRAM to RAM migration, has similar access
as System RAM from the CPU.  This flag sets the source from the sender. 
Which in Coherent type case, should be set as
MIGRATE_VMA_SELECT_DEVICE_COHERENT.

Link: https://lkml.kernel.org/r/20220201154901.7921-6-alex.sierra@amd.com
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~drm-amdkfd-coherent-type-as-sys-mem-on-migration-to-ram
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -659,9 +659,12 @@ svm_migrate_vma_to_ram(struct amdgpu_dev
 	migrate.vma = vma;
 	migrate.start = start;
 	migrate.end = end;
-	migrate.flags = MIGRATE_VMA_SELECT_DEVICE_PRIVATE;
 	migrate.pgmap_owner = SVM_ADEV_PGMAP_OWNER(adev);
 
+	if (adev->gmc.xgmi.connected_to_cpu)
+		migrate.flags = MIGRATE_VMA_SELECT_DEVICE_COHERENT;
+	else
+		migrate.flags = MIGRATE_VMA_SELECT_DEVICE_PRIVATE;
 	size = 2 * sizeof(*migrate.src) + sizeof(uint64_t) + sizeof(dma_addr_t);
 	size *= npages;
 	buf = kvmalloc(size, GFP_KERNEL | __GFP_ZERO);
_

Patches currently in -mm which might be from alex.sierra@amd.com are

mm-add-zone-device-coherent-type-memory-support.patch
mm-add-device-coherent-vma-selection-for-memory-migration.patch
mm-gup-fail-get_user_pages-for-longterm-dev-coherent-type.patch
drm-amdkfd-add-spm-support-for-svm.patch
drm-amdkfd-coherent-type-as-sys-mem-on-migration-to-ram.patch
lib-test_hmm-add-ioctl-to-get-zone-device-type.patch
lib-test_hmm-add-module-param-for-zone-device-type.patch
lib-add-support-for-device-coherent-type-in-test_hmm.patch
tools-update-hmm-test-to-support-device-coherent-type.patch
tools-update-test_hmm-script-to-support-sp-config.patch

