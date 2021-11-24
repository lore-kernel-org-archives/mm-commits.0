Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A808C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 21:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243804AbhKXVWO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:22:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhKXVWJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 16:22:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63C9A60F41;
        Wed, 24 Nov 2021 21:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637788739;
        bh=zU85i5eVp/YX8QPRoLrIFmaSz1n8tnW8nesFS6/HXLc=;
        h=Date:From:To:Subject:From;
        b=rHLg924A4zWa0LAe0Sum4drnbDyt8LujC+NMWu+vSxDEmm1aJOfuo64CnhLndKrc6
         FgS1iZG3LTOMM4WZwK1Ga9d16Std5USeOEDhCbVfW2wxQkrcMRjXnRA0KkQL9/EdLW
         jZ9sIencaogkzC5iLIyWfQ3zK42kAdSPv3wTiVRE=
Date:   Wed, 24 Nov 2021 13:18:58 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dan.j.williams@intel.com, dave.jiang@intel.com,
        hch@lst.de, jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  +
 memory-failure-fetch-compound_head-after-pgmap_pfn_valid.patch added to -mm
 tree
Message-ID: <20211124211858.nYwrnEgJk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory-failure: fetch compound_head after pgmap_pfn_valid()
has been added to the -mm tree.  Its filename is
     memory-failure-fetch-compound_head-after-pgmap_pfn_valid.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memory-failure-fetch-compound_head-after-pgmap_pfn_valid.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memory-failure-fetch-compound_head-after-pgmap_pfn_valid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: memory-failure: fetch compound_head after pgmap_pfn_valid()

Patch series "mm, device-dax: Introduce compound pages in devmap", v6.

This series converts device-dax to use compound pages, and moves away from
the 'struct page per basepage on PMD/PUD' that is done today.  Doing so,
1) unlocks a few noticeable improvements on unpin_user_pages() and makes
device-dax+altmap case 4x times faster in pinning (numbers below and in
last patch) 2) as mentioned in various other threads it's one important
step towards cleaning up ZONE_DEVICE refcounting.

I've split the compound pages on devmap part from the rest based on recent
discussions on devmap pending and future work planned[5][6].  There is
consensus that device-dax should be using compound pages to represent its
PMD/PUDs just like HugeTLB and THP, and that leads to less specialization
of the dax parts.  I will pursue the rest of the work in parallel once
this part is merged, particular the GUP-{slow,fast} improvements [7] and
the tail struct page deduplication memory savings part[8].

To summarize what the series does:

Patch 1: Prepare hwpoisoning to work with dax compound pages.

Patches 2-3: Split the current utility function of prep_compound_page()
into head and tail and use those two helpers where appropriate to take
advantage of caches being warm after __init_single_page().  This is used
when initializing zone device when we bring up device-dax namespaces.

Patches 4-10: Add devmap support for compound pages in device-dax. 
memmap_init_zone_device() initialize its metadata as compound pages, and
it introduces a new devmap property known as vmemmap_shift which outlines
how the vmemmap is structured (defaults to base pages as done today).  The
property describe the page order of the metadata essentially.  While at it
do a few cleanups in device-dax in patches 5-9.  Finally enable device-dax
usage of devmap @vmemmap_shift to a value based on its own @align
property.  @vmemmap_shift returns 0 by default (which is today's case of
base pages in devmap, like fsdax or the others) and the usage of compound
devmap is optional.  Starting with device-dax (*not* fsdax) we enable it
by default.  There are a few pinning improvements particular on the
unpinning case and altmap, as well as unpin_user_page_range_dirty_lock()
being just as effective as THP/hugetlb[0] pages.

    $ gup_test -f /dev/dax1.0 -m 16384 -r 10 -S -a -n 512 -w
    (pin_user_pages_fast 2M pages) put:~71 ms -> put:~22 ms
    [altmap]
    (pin_user_pages_fast 2M pages) get:~524ms put:~525 ms -> get: ~127ms put:~71ms
    
     $ gup_test -f /dev/dax1.0 -m 129022 -r 10 -S -a -n 512 -w
    (pin_user_pages_fast 2M pages) put:~513 ms -> put:~188 ms
    [altmap with -m 127004]
    (pin_user_pages_fast 2M pages) get:~4.1 secs put:~4.12 secs -> get:~1sec put:~563ms

Tested on x86 with 1Tb+ of pmem (alongside registering it with RDMA with
and without altmap), alongside gup_test selftests with dynamic dax regions
and static dax regions.  Coupled with ndctl unit tests for dynamic dax
devices that exercise all of this.  Note, for dynamic dax regions I had to
revert commit 8aa83e6395 ("x86/setup: Call early_reserve_memory()
earlier"), it is a known issue that this commit broke efi_fake_mem=.


This patch (of 10):

memory_failure_dev_pagemap() at the moment assumes base pages (e.g. 
dax_lock_page()).  For devmap with compound pages fetch the compound_head
in case a tail page memory failure is being handled.

Currently this is a nop, but in the advent of compound pages in
dev_pagemap it allows memory_failure_dev_pagemap() to keep working.

Link: https://lkml.kernel.org/r/20211124191005.20783-1-joao.m.martins@oracle.com
Link: https://lkml.kernel.org/r/20211124191005.20783-2-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reported-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memory-failure.c~memory-failure-fetch-compound_head-after-pgmap_pfn_valid
+++ a/mm/memory-failure.c
@@ -1558,6 +1558,12 @@ static int memory_failure_dev_pagemap(un
 	}
 
 	/*
+	 * Pages instantiated by device-dax (not filesystem-dax)
+	 * may be compound pages.
+	 */
+	page = compound_head(page);
+
+	/*
 	 * Prevent the inode from being freed while we are interrogating
 	 * the address_space, typically this would be handled by
 	 * lock_page(), but dax pages do not use the page lock. This
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

memory-failure-fetch-compound_head-after-pgmap_pfn_valid.patch
mm-page_alloc-split-prep_compound_page-into-head-and-tail-subparts.patch
mm-page_alloc-refactor-memmap_init_zone_device-page-init.patch
mm-memremap-add-zone_device-support-for-compound-pages.patch
device-dax-use-align-for-determining-pgoff.patch
device-dax-use-struct_size.patch
device-dax-ensure-dev_dax-pgmap-is-valid-for-dynamic-devices.patch
device-dax-factor-out-page-mapping-initialization.patch
device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch
device-dax-compound-devmap-support.patch

