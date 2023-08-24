Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10CFBC7113B
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 22:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243713AbjHXWAZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 18:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243837AbjHXWAV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 18:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5C01BE6;
        Thu, 24 Aug 2023 15:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 669A16595F;
        Thu, 24 Aug 2023 22:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BAFC433C8;
        Thu, 24 Aug 2023 22:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692914415;
        bh=MsowCLNjwjW10J2lulJqGbkMNaOkqg8nKi1+Y4IC2aA=;
        h=Date:To:From:Subject:From;
        b=tSJBrAXOYZdM+4EQfpYX/g2sb8CJmoC+5LF59T0c8G8/i6QySknJEYTEU93aj2uxO
         /uh8MtmHDuS9MKorkLboxyx9afKBZsGZIe2nZ0WibH3W8lJdc3dImcYsxWYGjwaTXL
         Xt6b/2pSKAmX0hPaV7cF+8fa++16sJJqQrPbufPs=
Date:   Thu, 24 Aug 2023 15:00:14 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        stable@vger.kernel.org, shy828301@gmail.com, ryan.roberts@arm.com,
        minchan@kernel.org, david@redhat.com, fengwei.yin@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] madvise-madvise_cold_or_pageout_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch removed from -mm tree
Message-Id: <20230824220015.B1BAFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: madvise:madvise_cold_or_pageout_pte_range(): don't use mapcount() against large folio for sharing check
has been removed from the -mm tree.  Its filename was
     madvise-madvise_cold_or_pageout_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: madvise:madvise_cold_or_pageout_pte_range(): don't use mapcount() against large folio for sharing check
Date: Tue, 8 Aug 2023 10:09:15 +0800

Patch series "don't use mapcount() to check large folio sharing", v2.

In madvise_cold_or_pageout_pte_range() and madvise_free_pte_range(),
folio_mapcount() is used to check whether the folio is shared.  But it's
not correct as folio_mapcount() returns total mapcount of large folio.

Use folio_estimated_sharers() here as the estimated number is enough.

This patchset will fix the cases:
User space application call madvise() with MADV_FREE, MADV_COLD and
MADV_PAGEOUT for specific address range. There are THP mapped to the
range. Without the patchset, the THP is skipped. With the patch, the
THP will be split and handled accordingly.

David reported the cow self test skip some cases because of MADV_PAGEOUT
skip THP:
https://lore.kernel.org/linux-mm/9e92e42d-488f-47db-ac9d-75b24cd0d037@intel.com/T/#mbf0f2ec7fbe45da47526de1d7036183981691e81
and I confirmed this patchset make it work again.


This patch (of 3):

Commit 07e8c82b5eff ("madvise: convert madvise_cold_or_pageout_pte_range()
to use folios") replaced the page_mapcount() with folio_mapcount() to
check whether the folio is shared by other mapping.

It's not correct for large folio.  folio_mapcount() returns the total
mapcount of large folio which is not suitable to detect whether the folio
is shared.

Use folio_estimated_sharers() which returns a estimated number of shares. 
That means it's not 100% correct.  It should be OK for madvise case here.

User-visible effects is that the THP is skipped when user call madvise. 
But the correct behavior is THP should be split and processed then.

NOTE: this change is a temporary fix to reduce the user-visible effects
before the long term fix from David is ready.

Link: https://lkml.kernel.org/r/20230808020917.2230692-1-fengwei.yin@intel.com
Link: https://lkml.kernel.org/r/20230808020917.2230692-2-fengwei.yin@intel.com
Fixes: 07e8c82b5eff ("madvise: convert madvise_cold_or_pageout_pte_range() to use folios")
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~madvise-madvise_cold_or_pageout_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check
+++ a/mm/madvise.c
@@ -384,7 +384,7 @@ static int madvise_cold_or_pageout_pte_r
 		folio = pfn_folio(pmd_pfn(orig_pmd));
 
 		/* Do not interfere with other mappings of this folio */
-		if (folio_mapcount(folio) != 1)
+		if (folio_estimated_sharers(folio) != 1)
 			goto huge_unlock;
 
 		if (pageout_anon_only_filter && !folio_test_anon(folio))
@@ -458,7 +458,7 @@ regular_folio:
 		if (folio_test_large(folio)) {
 			int err;
 
-			if (folio_mapcount(folio) != 1)
+			if (folio_estimated_sharers(folio) != 1)
 				break;
 			if (pageout_anon_only_filter && !folio_test_anon(folio))
 				break;
_

Patches currently in -mm which might be from fengwei.yin@intel.com are

filemap-add-filemap_map_folio_range.patch
rmap-add-folio_add_file_rmap_range.patch
mm-convert-do_set_pte-to-set_pte_range.patch
filemap-batch-pte-mappings.patch

