Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5965FC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 18:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiJUSpd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 14:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiJUSpb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 14:45:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69DE19A237
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 11:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6047D61F48
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 18:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE00C433C1;
        Fri, 21 Oct 2022 18:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666377929;
        bh=d8IX7cZpVK+TTn67HT3brFMl6lZ+xbwJvX/bPCSsMxw=;
        h=Date:To:From:Subject:From;
        b=IfwexCETpxDdpgoJfgoYQRjpvY2sohIQRCKgRszGREefdHdoCMWr/sAsOmJzn3T3i
         YdCpUEBZvBHJl9MDo4ItlKl26pL67y3ClXnL5ApdO8bLZRT3FwSqgfL4qGUsaF/kab
         D7WJu7rPkUc64ou0oluwzwy0i0Fl3g+N63J5MK00=
Date:   Fri, 21 Oct 2022 11:45:29 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        shy828301@gmail.com, david@redhat.com, apopple@nvidia.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-try-again-if-thp-split-is-failed-due-to-page-refcnt.patch added to mm-unstable branch
Message-Id: <20221021184529.BCE00C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: try again if THP split is failed due to page refcnt
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-try-again-if-thp-split-is-failed-due-to-page-refcnt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-try-again-if-thp-split-is-failed-due-to-page-refcnt.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: migrate: try again if THP split is failed due to page refcnt
Date: Fri, 21 Oct 2022 18:16:24 +0800

When creating a virtual machine, we will use memfd_create() to get a file
descriptor which can be used to create shared memory mappings using
mmap().  The mmap() will set the MAP_POPULATE flag to allocate physical
pages for the virtual machine.

When allocating physical pages for the guest, the host can fall back to
allocate some CMA pages for the guest when over half of the zone's free
memory is in the CMA area.

In guest os, when the application wants to do some data transaction with
DMA, our QEMU will call VFIO_IOMMU_MAP_DMA ioctl to do longterm-pin and
create IOMMU mappings for the DMA pages.  However, when calling
VFIO_IOMMU_MAP_DMA ioctl to pin the physical pages, we found it will fail
to longterm-pin sometimes.

After some invetigation, we found the pages used to do DMA mapping can
contain some CMA pages, and these CMA pages will cause a possible failure
of the longterm-pin, due to failure to migrate the CMA pages.  The reason
for migration failure may be a temporary reference count or memory
allocation failure.  So that will cause the VFIO_IOMMU_MAP_DMA ioctl to
return an error, which makes the application fail to start.

I observed one migration failure case (which is not easy to reproduce) is
that, the 'thp_migration_fail' count is 1 and the 'thp_split_page_failed'
count is also 1.

That means when migrating a THP which is in a CMA area, but cannot
allocate a new THP due to memory fragmentation, it will split the THP. 
However THP split also fails, probably the reason is a temporary reference
count of this THP.  And the temporary reference count can be caused by
dropping page caches (I observed the drop caches operation in the system),
but we cannot drop the shmem page caches because they are already dirty at
that time.

Especially for THP split failure, which is caused by temporary reference
count, we can try again to mitigate the failure of migration in this case
according to previous discussion [1].

[1] https://lore.kernel.org/all/470dc638-a300-f261-94b4-e27250e42f96@redhat.com/

Link: https://lkml.kernel.org/r/88831f1764c8fbd5b5fdad27cd5ae3d2ca796e44.1666335603.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 mm/migrate.c     |   19 ++++++++++++++++---
 2 files changed, 18 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-migrate-try-again-if-thp-split-is-failed-due-to-page-refcnt
+++ a/mm/huge_memory.c
@@ -2666,7 +2666,7 @@ int split_huge_page_to_list(struct page
 	 * split PMDs
 	 */
 	if (!can_split_folio(folio, &extra_pins)) {
-		ret = -EBUSY;
+		ret = -EAGAIN;
 		goto out_unlock;
 	}
 
@@ -2716,7 +2716,7 @@ fail:
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

mm-migrate-fix-return-value-if-all-subpages-of-thps-are-migrated-successfully.patch
mm-migrate-try-again-if-thp-split-is-failed-due-to-page-refcnt.patch

