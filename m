Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98BA0C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 19:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236446AbiDYTFd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 15:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244845AbiDYTFc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 15:05:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF4012C8DF
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 12:02:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29BF46170C
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 19:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A26C385A7;
        Mon, 25 Apr 2022 19:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650913336;
        bh=Wio5EEHaz834SX7dCvDp8E/f6HDW+71s0Jc0WcAekl0=;
        h=Date:To:From:Subject:From;
        b=1F9OEio6x6+OsVGQxxmT2WwaF+kHs5La+Y5fSDVguc3r/QvadnJruOYFiRyX0glXu
         dPbYkQ5jWBCL6ynA9+CFJWeHhx9Wzwtf5xHQAV216CZMWwhwTbR9Xa7H5YSPMXaTnV
         m9TNFu2geijH+445OLesLsTzBwtk3gHLU4wsE/Y8=
Date:   Mon, 25 Apr 2022 12:02:15 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        renzhengeek@gmail.com, osalvador@suse.de, minchan@kernel.org,
        mgorman@techsingularity.net, lkp@intel.com, david@redhat.com,
        christophe.leroy@csgroup.eu, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-virtio_mem-use-pageblock-size-as-the-minimum-virtio_mem-size.patch added to -mm tree
Message-Id: <20220425190216.80A26C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers: virtio_mem: use pageblock size as the minimum virtio_mem size.
has been added to the -mm tree.  Its filename is
     drivers-virtio_mem-use-pageblock-size-as-the-minimum-virtio_mem-size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/drivers-virtio_mem-use-pageblock-size-as-the-minimum-virtio_mem-size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/drivers-virtio_mem-use-pageblock-size-as-the-minimum-virtio_mem-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: drivers: virtio_mem: use pageblock size as the minimum virtio_mem size.

alloc_contig_range() now only needs to be aligned to pageblock_nr_pages,
drop virtio_mem size requirement that it needs to be MAX_ORDER_NR_PAGES.

Link: https://lkml.kernel.org/r/20220425143118.2850746-7-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Ren <renzhengeek@gmail.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_mem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/virtio/virtio_mem.c~drivers-virtio_mem-use-pageblock-size-as-the-minimum-virtio_mem-size
+++ a/drivers/virtio/virtio_mem.c
@@ -2476,10 +2476,10 @@ static int virtio_mem_init_hotplug(struc
 				      VIRTIO_MEM_DEFAULT_OFFLINE_THRESHOLD);
 
 	/*
-	 * TODO: once alloc_contig_range() works reliably with pageblock
-	 * granularity on ZONE_NORMAL, use pageblock_nr_pages instead.
+	 * alloc_contig_range() works reliably with pageblock
+	 * granularity on ZONE_NORMAL, use pageblock_nr_pages.
 	 */
-	sb_size = PAGE_SIZE * MAX_ORDER_NR_PAGES;
+	sb_size = PAGE_SIZE * pageblock_nr_pages;
 	sb_size = max_t(uint64_t, vm->device_block_size, sb_size);
 
 	if (sb_size < memory_block_size_bytes() && !force_bbm) {
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch
mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch
mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation-v4.patch
mm-page_isolation-move-has_unmovable_pages-to-mm-page_isolationc.patch
mm-page_isolation-check-specified-range-for-unmovable-pages.patch
mm-make-alloc_contig_range-work-at-pageblock-granularity.patch
mm-page_isolation-enable-arbitrary-range-page-isolation.patch
mm-cma-use-pageblock_order-as-the-single-alignment.patch
drivers-virtio_mem-use-pageblock-size-as-the-minimum-virtio_mem-size.patch

