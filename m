Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2505EC43381
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA6D964ED9
	for <mm-commits@archiver.kernel.org>; Mon,  1 Feb 2021 23:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhBAXAX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Feb 2021 18:00:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229927AbhBAXAQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Feb 2021 18:00:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A7C364D9E;
        Mon,  1 Feb 2021 22:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612220375;
        bh=WaD4HdyS/lDoQRaNYH2jhd49b8VQvASVDaaHWxUPcYc=;
        h=Date:From:To:Subject:From;
        b=C4A4wSli2FaUIe2IjYPPWttvWTS7L/H/1pT0e5JI1dZPuka+2p6zGNZawQqwWgzIh
         uwbS2jyC0f0VLLXoV/fLdzIoFkEWEHsJmYgZrI9SZmbuKgEoHBbgrn+/mca9CR9EHA
         ArYLcTCgBkvJK822akG0OOYyi+WfmkmyKYu9gvTM=
Date:   Mon, 01 Feb 2021 14:59:33 -0800
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, david@redhat.com, iamjoonsoo.kim@lge.com,
        ira.weiny@intel.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, jmorris@namei.org, mgorman@suse.de,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pasha.tatashin@soleen.com, peterz@infradead.org,
        rientjes@google.com, rostedt@goodmis.org, sashal@kernel.org,
        tyhicks@linux.microsoft.com, vbabka@suse.cz, willy@infradead.org
Subject:  +
 mm-gup-dont-pin-migrated-cma-pages-in-movable-zone.patch added to -mm tree
Message-ID: <20210201225933.RGVPgI0JZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: don't pin migrated cma pages in movable zone
has been added to the -mm tree.  Its filename is
     mm-gup-dont-pin-migrated-cma-pages-in-movable-zone.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-dont-pin-migrated-cma-pages-in-movable-zone.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-dont-pin-migrated-cma-pages-in-movable-zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: mm/gup: don't pin migrated cma pages in movable zone

Patch series "prohibit pinning pages in ZONE_MOVABLE", v9.

When page is pinned it cannot be moved and its physical address stays the
same until pages is unpinned.

This is useful functionality to allows userland to implementation DMA
access.  For example, it is used by vfio in vfio_pin_pages().

However, this functionality breaks memory hotplug/hotremove assumptions
that pages in ZONE_MOVABLE can always be migrated.

This patch series fixes this issue by forcing new allocations during page
pinning to omit ZONE_MOVABLE, and also to migrate any existing pages from
ZONE_MOVABLE during pinning.

It uses the same scheme logic that is currently used by CMA, and extends
the functionality for all allocations.

For more information read the discussion [1] about this problem.

[1] https://lore.kernel.org/lkml/CA+CK2bBffHBxjmb9jmSKacm0fJMinyt3Nhk8Nx6iudcQSj80_w@mail.gmail.com


This patch (of 14):

In order not to fragment CMA the pinned pages are migrated.  However, they
are migrated to ZONE_MOVABLE, which also should not have pinned pages.

Remove __GFP_MOVABLE, so pages can be migrated to zones where pinning is
allowed.

Link: https://lkml.kernel.org/r/20210201153827.444374-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20210201153827.444374-2-pasha.tatashin@soleen.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-dont-pin-migrated-cma-pages-in-movable-zone
+++ a/mm/gup.c
@@ -1556,7 +1556,7 @@ static long check_and_migrate_cma_pages(
 	long ret = nr_pages;
 	struct migration_target_control mtc = {
 		.nid = NUMA_NO_NODE,
-		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_NOWARN,
+		.gfp_mask = GFP_USER | __GFP_NOWARN,
 	};
 
 check_again:
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-gup-dont-pin-migrated-cma-pages-in-movable-zone.patch
mm-gup-check-every-subpage-of-a-compound-page-during-isolation.patch
mm-gup-return-an-error-on-migration-failure.patch
mm-gup-check-for-isolation-errors.patch
mm-cma-rename-pf_memalloc_nocma-to-pf_memalloc_pin.patch
mm-apply-per-task-gfp-constraints-in-fast-path.patch
mm-honor-pf_memalloc_pin-for-all-movable-pages.patch
mm-gup-do-not-migrate-zero-page.patch
mm-gup-migrate-pinned-pages-out-of-movable-zone.patch
memory-hotplugrst-add-a-note-about-zone_movable-and-page-pinning.patch
mm-gup-change-index-type-to-long-as-it-counts-pages.patch
mm-gup-longterm-pin-migration-cleanup.patch
selftests-vm-gup_test-fix-test-flag.patch
selftests-vm-gup_test-test-faulting-in-kernel-and-verify-pinnable-pages.patch

