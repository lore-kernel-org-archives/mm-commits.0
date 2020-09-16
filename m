Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7338C43461
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 01:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D8C0208E4
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 01:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600218519;
	bh=tPNuDBYev0YNqnp6KUi4M7Tyl+SUPPqUAj4cyWXRZ5M=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HaWwA1OFO7JKcWwX3dXyMxgItvaRPQmZKEovtHIVjuxEo3jC+YeteLD2yfMncz93Z
	 nhEFr6U84WB8kFMwqCfQi7gyVQQOWk3GPlthrHIafJRJijfa1x1BObZens0t9gyzYN
	 uejXf/Vhpy0cY0ZX1oPpgRJnRfKvjsdDi1FT4wkk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgIPBIh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Sep 2020 21:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgIPBIh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Sep 2020 21:08:37 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F5FA20715;
        Wed, 16 Sep 2020 01:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600218517;
        bh=tPNuDBYev0YNqnp6KUi4M7Tyl+SUPPqUAj4cyWXRZ5M=;
        h=Date:From:To:Subject:From;
        b=actB+xx1hP7Z4FzWMfUIE/qj/qiPS63yBwp8Rkp5AABsia11h4+Uinem/UVf5cTjS
         oFRKE+WM/uAAKfOc5l0m/aH0Lnrf4YVyMnnGQ6V0QkBi32pWKVDZ6VwZ8PsnxmPihr
         ubcnvOPdOz3lVfya1z49DUkqBNeLjHDOYrh+uqDo=
Date:   Tue, 15 Sep 2020 18:08:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, cai@redhat.com, willy@infradead.org
Subject:  + mm-optimise-madvise-willneed-fix.patch added to -mm tree
Message-ID: <20200916010836.pwUBS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-optimise-madvise-willneed-fix
has been added to the -mm tree.  Its filename is
     mm-optimise-madvise-willneed-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-optimise-madvise-willneed-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-optimise-madvise-willneed-fix.patch

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
Subject: mm-optimise-madvise-willneed-fix

On Mon, Sep 14, 2020 at 12:17:07PM -0400, Qian Cai wrote:
> Reverting the "Return head pages from find_*_entry" patchset [1] up to this
> patch fixed the issue that LTP madvise06 test [2] would trigger endless soft-
> lockups below. It does not help after applied patches fixed other separate
> issues in the patchset [3][4].

Link: https://lkml.kernel.org/r/20200914165032.GS6583@casper.infradead.org
Reported-by: Qian Cai <cai@redhat.com>
Tested-by: Qian Cai <cai@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-optimise-madvise-willneed-fix
+++ a/mm/madvise.c
@@ -234,6 +234,7 @@ static void force_shm_swapin_readahead(s
 
 		if (!xa_is_value(page))
 			continue;
+		xas_pause(&xas);
 		rcu_read_unlock();
 
 		swap = radix_to_swp_entry(page);
@@ -243,7 +244,6 @@ static void force_shm_swapin_readahead(s
 			put_page(page);
 
 		rcu_read_lock();
-		xas_reset(&xas);
 	}
 	rcu_read_unlock();
 
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
mm-shmem-return-head-page-from-find_lock_entry.patch
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

