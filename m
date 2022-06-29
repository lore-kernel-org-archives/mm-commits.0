Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5665BC43334
	for <mm-commits@archiver.kernel.org>; Wed, 29 Jun 2022 23:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbiF2Xem (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Jun 2022 19:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiF2XeS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jun 2022 19:34:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B813B0
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 16:33:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3001E61E20
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 23:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8383EC34114;
        Wed, 29 Jun 2022 23:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656545630;
        bh=5g/QnEqE66fuxrJ76qMSBBXHc64ntgJ0WOu42AcVHrU=;
        h=Date:To:From:Subject:From;
        b=wqmJ8rN/6r22lbXXY5urJ4UttwubUsJ8JqSXWfbRHuD8AkuO7jFsJ4hTH0z6R9bTa
         psHp5MYEqRoxi/1yjCS0jZLsooKtcPwrqNybx7RCQUR+BweW7U+6YnyM749gVi/lp4
         krSnCHxZzOIe1Ha4K/tg2Q35dMUwgRT9vHEkfup0=
Date:   Wed, 29 Jun 2022 16:33:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, david@redhat.com,
        apopple@nvidia.com, alex.sierra@amd.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch added to mm-unstable branch
Message-Id: <20220629233350.8383EC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix
Date: Wed Jun 29 04:27:39 PM PDT 2022

fix comment typo, per David.  Re-layout comment

Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/memory.c~mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix
+++ a/mm/memory.c
@@ -632,16 +632,16 @@ struct page *vm_normal_page(struct vm_ar
 			return NULL;
 		if (is_zero_pfn(pfn))
 			return NULL;
+		/*
+		 * NOTE: New users of ZONE_DEVICE will not set pte_devmap()
+		 * and will have refcounts incremented on their struct pages
+		 * when they are inserted into PTEs, thus they are safe to
+		 * return here. Legacy ZONE_DEVICE pages that set pte_devmap()
+		 * do not have refcounts. Example of legacy ZONE_DEVICE is
+		 * MEMORY_DEVICE_FS_DAX type in pmem or virtio_fs drivers.
+		 */
 		if (pte_devmap(pte))
-/*
- * NOTE: New uers of ZONE_DEVICE will not set pte_devmap() and will have
- * refcounts incremented on their struct pages when they are inserted into
- * PTEs, thus they are safe to return here. Legacy ZONE_DEVICE pages that set
- * pte_devmap() do not have refcounts. Example of legacy ZONE_DEVICE is
- * MEMORY_DEVICE_FS_DAX type in pmem or virtio_fs drivers.
- */
 			return NULL;
-
 		print_bad_pte(vma, addr, pte, NULL);
 		return NULL;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-thp-kill-transparent_hugepage_active-fix.patch
mm-thp-kill-transparent_hugepage_active-fix-fix.patch
mm-convert-destroy_compound_page-to-destroy_large_folio-fix.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry-fix.patch
mm-docs-fix-comments-that-mention-mem_hotplug_end-fix.patch

