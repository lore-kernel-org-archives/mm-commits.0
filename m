Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E19BC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 19:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbiBATxu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 14:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbiBATxu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 14:53:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E73C061714
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 11:53:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65154B82F7A
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 19:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E3EC340EC;
        Tue,  1 Feb 2022 19:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643745227;
        bh=U8tNhGnd7z+B37xnMdIX/PX7GF9cI/xwPQvCBNqOB/M=;
        h=Date:To:From:Subject:From;
        b=iCdjiuq8SSq2u9Cs2H5aj74K1CELyA/h+cQM5K2QrrL5GB2EW1cuQxCb8Aj+waxxF
         IPilu2d6BT5fuD6lp0CTSgiMqHHsJSD1JRpCMW6ThZNRkUW3ocpuTsgYk3ISdosWsz
         e0Q/Gkkbn58Pwm2KFdw2ApvfK83uuNSHbRJwycXA=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 11:53:45 -0800
Date:   Tue, 01 Feb 2022 11:53:45 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, apopple@nvidia.com,
        alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-device-coherent-vma-selection-for-memory-migration.patch added to -mm tree
Message-Id: <20220201195345.D2E3EC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add device coherent vma selection for memory migration
has been added to the -mm tree.  Its filename is
     mm-add-device-coherent-vma-selection-for-memory-migration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-device-coherent-vma-selection-for-memory-migration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-device-coherent-vma-selection-for-memory-migration.patch

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
Subject: mm: add device coherent vma selection for memory migration

This case is used to migrate pages from device memory, back to system
memory.  Device coherent type memory is cache coherent from device and CPU
point of view.

Link: https://lkml.kernel.org/r/20220201154901.7921-3-alex.sierra@amd.com
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Alistair Poppple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    1 +
 mm/migrate.c            |   12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/include/linux/migrate.h~mm-add-device-coherent-vma-selection-for-memory-migration
+++ a/include/linux/migrate.h
@@ -130,6 +130,7 @@ static inline unsigned long migrate_pfn(
 enum migrate_vma_direction {
 	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
+	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
 };
 
 struct migrate_vma {
--- a/mm/migrate.c~mm-add-device-coherent-vma-selection-for-memory-migration
+++ a/mm/migrate.c
@@ -2265,15 +2265,21 @@ again:
 			if (is_writable_device_private_entry(entry))
 				mpfn |= MIGRATE_PFN_WRITE;
 		} else {
-			if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM))
-				goto next;
 			pfn = pte_pfn(pte);
-			if (is_zero_pfn(pfn)) {
+			if (is_zero_pfn(pfn) &&
+			    (migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
 				mpfn = MIGRATE_PFN_MIGRATE;
 				migrate->cpages++;
 				goto next;
 			}
 			page = vm_normal_page(migrate->vma, addr, pte);
+			if (page && !is_zone_device_page(page) &&
+			    !(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM))
+				goto next;
+			else if (page && is_device_coherent_page(page) &&
+			    (!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
+			     page->pgmap->owner != migrate->pgmap_owner))
+				goto next;
 			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
 			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
 		}
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

