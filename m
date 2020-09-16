Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09874C43461
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 02:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C28982087D
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 02:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600223435;
	bh=/sUX4QQ9UZOktVcW44ibKN1ZOv4byTm+RrPzNb0Zcug=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=K4v78wCNSTSdqHVoIH2ytCYMm2RDx79WBUbFWdPLsjDkayRhVak7Dk5c7LOjZukPg
	 i/vZ/kpcWsbnu8+QIgBPePyvlp0cl0/fu2DQfUAuMalSndfhU1qWxW2QA5CZJY5Dnr
	 tHV0hOCagIi07lJqeaDHVd+aycA8D8d+S3/Qt/nc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgIPCaf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Sep 2020 22:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbgIPCad (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Sep 2020 22:30:33 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E48CC20735;
        Wed, 16 Sep 2020 02:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600223432;
        bh=/sUX4QQ9UZOktVcW44ibKN1ZOv4byTm+RrPzNb0Zcug=;
        h=Date:From:To:Subject:From;
        b=Js8Z5BtD9zRyZKqsxhgNkYMkJEg4qjRWzoOVY3mmnZordBS+H6etYG5tEUx9xTIlI
         WBL8KmSXz9ASYKm4f9q9Nq0WgPJsjhMT0rD9NN1qISTyNpNtOpPdOn9oOholJy54sp
         YJOyd6q4RfiU0XKvQ0lcDnu08PrXWv865aUCbwy8=
Date:   Tue, 15 Sep 2020 19:30:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        willy@infradead.org
Subject:  + mm-shmem-return-head-page-from-find_lock_entry-fix.patch
 added to -mm tree
Message-ID: <20200916023031.oKfqZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-shmem-return-head-page-from-find_lock_entry-fix
has been added to the -mm tree.  Its filename is
     mm-shmem-return-head-page-from-find_lock_entry-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-return-head-page-from-find_lock_entry-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-return-head-page-from-find_lock_entry-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: mm-shmem-return-head-page-from-find_lock_entry-fix

fix BUG()s


[1] https://lore.kernel.org/linux-mm/20200912032042.GA6583@casper.infradead.org/

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-return-head-page-from-find_lock_entry-fix
+++ a/mm/shmem.c
@@ -1803,7 +1803,7 @@ static int shmem_getpage_gfp(struct inod
 	struct mm_struct *charge_mm;
 	struct page *page;
 	enum sgp_type sgp_huge = sgp;
-	pgoff_t hindex;
+	pgoff_t hindex = index;
 	int error;
 	int once = 0;
 	int alloced = 0;
@@ -1832,6 +1832,8 @@ repeat:
 		return error;
 	}
 
+	if (page)
+		hindex = page->index;
 	if (page && sgp == SGP_WRITE)
 		mark_page_accessed(page);
 
@@ -1842,6 +1844,7 @@ repeat:
 		unlock_page(page);
 		put_page(page);
 		page = NULL;
+		hindex = index;
 	}
 	if (page || sgp == SGP_READ)
 		goto out;
@@ -1992,7 +1995,7 @@ clear:
 		goto unlock;
 	}
 out:
-	*pagep = page + index - page->index;
+	*pagep = page + index - hindex;
 	return 0;
 
 	/*
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
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
harden-autofs-ioctl-table.patch

