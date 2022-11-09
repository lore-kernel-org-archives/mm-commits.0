Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A86FC43217
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiKIBly (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiKIBkN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53816828E
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50A7361803
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36A0C433C1;
        Wed,  9 Nov 2022 01:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957968;
        bh=fQoImvGKIg90ayrKQ6PGF/GlpPpEo49VEh20K2QQZOA=;
        h=Date:To:From:Subject:From;
        b=FEaan7ZVYJauEhFMSm1SZ2k9wib+DpMKnjhALx++w7m6nSVxfyiqNT3/TxCCN0Yzv
         zkJ8+0bBS60cLPwTN1/1bf8t+C48AFRwouT7+Fw0UMvYXhkZyhmfXLcRTRo6sKseLk
         gbOgnKU9KD9iWvqFhexCFPVhzMPaDzpsvkq2tx+w=
Date:   Tue, 08 Nov 2022 17:39:28 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        shy828301@gmail.com, david@redhat.com, apopple@nvidia.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-try-again-if-thp-split-is-failed-due-to-page-refcnt.patch removed from -mm tree
Message-Id: <20221109013928.A36A0C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: migrate: try again if THP split is failed due to page refcnt
has been removed from the -mm tree.  Its filename was
     mm-migrate-try-again-if-thp-split-is-failed-due-to-page-refcnt.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: try again if THP split is failed due to page refcnt
Date: Mon, 24 Oct 2022 16:34:22 +0800

When creating a virtual machine, we will use memfd_create() to get a file
descriptor which can be used to create share memory mappings using the
mmap function, meanwhile the mmap() will set the MAP_POPULATE flag to
allocate physical pages for the virtual machine.

When allocating physical pages for the guest, the host can fallback to
allocate some CMA pages for the guest when over half of the zone's free
memory is in the CMA area.

In guest os, when the application wants to do some data transaction with
DMA, our QEMU will call VFIO_IOMMU_MAP_DMA ioctl to do longterm-pin and
create IOMMU mappings for the DMA pages.  However, when calling
VFIO_IOMMU_MAP_DMA ioctl to pin the physical pages, we found it will be
failed to longterm-pin sometimes.

After some invetigation, we found the pages used to do DMA mapping can
contain some CMA pages, and these CMA pages will cause a possible failure
of the longterm-pin, due to failed to migrate the CMA pages.  The reason
of migration failure may be temporary reference count or memory allocation
failure.  So that will cause the VFIO_IOMMU_MAP_DMA ioctl returns error,
which makes the application failed to start.

I observed one migration failure case (which is not easy to reproduce) is
that, the 'thp_migration_fail' count is 1 and the 'thp_split_page_failed'
count is also 1.

That means when migrating a THP which is in CMA area, but can not allocate
a new THP due to memory fragmentation, so it will split the THP.  However
THP split is also failed, probably the reason is temporary reference count
of this THP.  And the temporary reference count can be caused by dropping
page caches (I observed the drop caches operation in the system), but we
can not drop the shmem page caches due to they are already dirty at that
time.

Especially for THP split failure, which is caused by temporary reference
count, we can try again to mitigate the failure of migration in this case
according to previous discussion [1].

[1] https://lore.kernel.org/all/470dc638-a300-f261-94b4-e27250e42f96@redhat.com/
Link: https://lkml.kernel.org/r/6784730480a1df82e8f4cba1ed088e4ac767994b.1666599848.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 mm/migrate.c     |   19 ++++++++++++++++---
 2 files changed, 18 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-migrate-try-again-if-thp-split-is-failed-due-to-page-refcnt
+++ a/mm/huge_memory.c
@@ -2712,7 +2712,7 @@ int split_huge_page_to_list(struct page
 	 * split PMDs
 	 */
 	if (!can_split_folio(folio, &extra_pins)) {
-		ret = -EBUSY;
+		ret = -EAGAIN;
 		goto out_unlock;
 	}
 
@@ -2762,7 +2762,7 @@ fail:
 			xas_unlock(&xas);
 		local_irq_enable();
 		remap_page(folio, folio_nr_pages(folio));
-		ret = -EBUSY;
+		ret = -EAGAIN;
 	}
 
 out_unlock:
--- a/mm/migrate.c~mm-migrate-try-again-if-thp-split-is-failed-due-to-page-refcnt
+++ a/mm/migrate.c
@@ -1506,9 +1506,22 @@ thp_subpage_migration:
 				if (is_thp) {
 					nr_thp_failed++;
 					/* THP NUMA faulting doesn't split THP to retry. */
-					if (!nosplit && !try_split_thp(page, &thp_split_pages)) {
-						nr_thp_split++;
-						break;
+					if (!nosplit) {
+						int ret = try_split_thp(page, &thp_split_pages);
+
+						if (!ret) {
+							nr_thp_split++;
+							break;
+						} else if (reason == MR_LONGTERM_PIN &&
+							   ret == -EAGAIN) {
+							/*
+							 * Try again to split THP to mitigate
+							 * the failure of longterm pinning.
+							 */
+							thp_retry++;
+							nr_retry_pages += nr_subpages;
+							break;
+						}
 					}
 				} else if (!no_subpage_counting) {
 					nr_failed++;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


