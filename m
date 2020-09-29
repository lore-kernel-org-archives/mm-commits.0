Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931CDC2D0A8
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 01:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4787C208FE
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 01:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601341583;
	bh=DavXGwD5yexLSdjMQQCQrBBe43lPqWKkB+CTA5vq6Cw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=syAR6M373n14QUni5TqssKc4gXx59WteEH8htbncPDcsKFMOmsmhOQaHYAe/JlD6N
	 L1ON+DVFzaQf3U0n2YWKvu3QQqB9jyEyi3OWC7LGXSYr/4sXAslV/QrSof3eRyBCz8
	 Ab2truX2qjW7o6SgVRcCAbLfLOYvX2gX4fts1urU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgI2BGW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 21:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbgI2BGW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 21:06:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 281AF207C4;
        Tue, 29 Sep 2020 01:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601341580;
        bh=DavXGwD5yexLSdjMQQCQrBBe43lPqWKkB+CTA5vq6Cw=;
        h=Date:From:To:Subject:From;
        b=otoujcImgYBcBnR6QsR9pHS7QCMsU+r8hnAdTdVS/5rqiaR9BapeOZH1V0EWAXcRx
         hHlI07q3ul08eLvZfci2Cxu8ijoW4NacJS3zJayudbarFpnYjttyOi2i4vq2ZkmCcS
         Uz5tHRQaV4vVmW7UzBLVK3FMNJnCcSqj88c+bvw8=
Date:   Mon, 28 Sep 2020 18:06:19 -0700
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  + ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch
 added to -mm tree
Message-ID: <20200929010619.PWuNzzkJn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ramfs: fix nommu mmap with gaps in the page cache
has been added to the -mm tree.  Its filename is
     ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox (Oracle) <willy@infradead.org>
Subject: ramfs: fix nommu mmap with gaps in the page cache

ramfs needs to check that pages are both physically contiguous and
contiguous in the file.  If the page cache happens to have, eg, page A for
index 0 of the file, no page for index 1, and page A+1 for index 2, then
an mmap of the first two pages of the file will succeed when it should
fail.

Link: https://lkml.kernel.org/r/20200914122239.GO6583@casper.infradead.org
Fixes: 642fb4d1f1dd ("[PATCH] NOMMU: Provide shared-writable mmap support on ramfs")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ramfs/file-nommu.c~ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache
+++ a/fs/ramfs/file-nommu.c
@@ -224,7 +224,7 @@ static unsigned long ramfs_nommu_get_unm
 	if (!pages)
 		goto out_free;
 
-	nr = find_get_pages(inode->i_mapping, &pgoff, lpages, pages);
+	nr = find_get_pages_contig(inode->i_mapping, pgoff, lpages, pages);
 	if (nr != lpages)
 		goto out_free_pages; /* leave if some pages were missing */
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-factor-find_get_incore_page-out-of-mincore_page.patch
mm-use-find_get_incore_page-in-memcontrol.patch
mm-optimise-madvise-willneed.patch
mm-optimise-madvise-willneed-fix.patch
proc-optimise-smaps-for-shmem-entries.patch
i915-use-find_lock_page-instead-of-find_lock_entry.patch
mm-convert-find_get_entry-to-return-the-head-page.patch
mm-convert-find_get_entry-to-return-the-head-page-fix.patch
mm-shmem-return-head-page-from-find_lock_entry.patch
mm-shmem-return-head-page-from-find_lock_entry-fix.patch
mm-add-find_lock_head.patch
mm-filemap-fix-filemap_map_pages-for-thp.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
page_alloc-fix-freeing-non-compound-pages.patch
xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
xarray-add-xas_split-fix-2.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size.patch
mm-page_owner-change-split_page_owner-to-take-a-count.patch
mm-huge_memory-fix-page_trans_huge_mapcount-assumption-of-thp-size.patch
mm-huge_memory-fix-can_split_huge_page-assumption-of-thp-size.patch
mm-rmap-fix-assumptions-of-thp-size.patch
mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch
mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch
mm-vmscan-allow-arbitrary-sized-pages-to-be-paged-out.patch
fs-add-a-filesystem-flag-for-thps.patch
fs-do-not-update-nr_thps-for-mappings-which-support-thps.patch
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch
harden-autofs-ioctl-table.patch

