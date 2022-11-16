Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD78C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 22:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbiKPWHs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 17:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiKPWHs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 17:07:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A5D65E44
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 14:07:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0350A61FF5
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 22:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560EBC433C1;
        Wed, 16 Nov 2022 22:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668636461;
        bh=cC+/uZalcW9n3HXEER+l1BWwZ73hFSvd0FcL8dZbuts=;
        h=Date:To:From:Subject:From;
        b=j7Oyc56tR+/DMPPjRg9Rag/PxZJegCNTB4eYJMkGEvwrX1z7Se9kk56VVJGC0WNaf
         81uVPjN4reIzKUiaQBEE1N11mepj55kivrE2Z9ODgrfMCWeRQApSRIwJCahWLnKVmU
         i6dS+G3PBgh6PUfpFV29UUeufqnscDr98s58gVBA=
Date:   Wed, 16 Nov 2022 14:07:40 -0800
To:     mm-commits@vger.kernel.org, rcampbell@nvidia.com,
        mpe@ellerman.id.au, lyude@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, Felix.Kuehling@amd.com, bskeggs@redhat.com,
        alex.sierra@amd.com, apopple@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-return-number-of-migrating-pages-in-args-cpages.patch added to mm-hotfixes-unstable branch
Message-Id: <20221116220741.560EBC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate_device: return number of migrating pages in args->cpages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate_device-return-number-of-migrating-pages-in-args-cpages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-return-number-of-migrating-pages-in-args-cpages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/migrate_device: return number of migrating pages in args->cpages
Date: Fri, 11 Nov 2022 11:51:35 +1100

migrate_vma->cpages originally contained a count of the number of pages
migrating including non-present pages which can be populated directly on
the target.

Commit 241f68859656 ("mm/migrate_device.c: refactor migrate_vma and
migrate_device_coherent_page()") inadvertantly changed this to contain
just the number of pages that were unmapped.  Usage of migrate_vma->cpages
isn't documented, but most drivers use it to see if all the requested
addresses can be migrated so restore the original behaviour.

Link: https://lkml.kernel.org/r/20221111005135.1344004-1-apopple@nvidia.com
Fixes: 241f68859656 ("mm/migrate_device.c: refactor migrate_vma and migrate_deivce_coherent_page()")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reported-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alex Sierra <alex.sierra@amd.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-return-number-of-migrating-pages-in-args-cpages
+++ a/mm/migrate_device.c
@@ -357,7 +357,8 @@ static bool migrate_vma_check_page(struc
 }
 
 /*
- * Unmaps pages for migration. Returns number of unmapped pages.
+ * Unmaps pages for migration. Returns number of source pfns marked as
+ * migrating.
  */
 static unsigned long migrate_device_unmap(unsigned long *src_pfns,
 					  unsigned long npages,
@@ -373,8 +374,11 @@ static unsigned long migrate_device_unma
 		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 		struct folio *folio;
 
-		if (!page)
+		if (!page) {
+			if (src_pfns[i] & MIGRATE_PFN_MIGRATE)
+				unmapped++;
 			continue;
+		}
 
 		/* ZONE_DEVICE pages are not on LRU */
 		if (!is_zone_device_page(page)) {
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-memory-return-vm_fault_t-result-from-migrate_to_ram-callback.patch
mm-migrate_device-return-number-of-migrating-pages-in-args-cpages.patch
mm-khugepaged-refactor-mm_khugepaged_scan_file-tracepoint-to-remove-filename-from-function-call-fix.patch

