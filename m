Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D90DC41513
	for <mm-commits@archiver.kernel.org>; Mon,  7 Aug 2023 16:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjHGQoI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Aug 2023 12:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbjHGQoH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Aug 2023 12:44:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2FF172B
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 09:44:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4711361F6D
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 16:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D754C433C7;
        Mon,  7 Aug 2023 16:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691426644;
        bh=+7f/aOx+aLmPATpJtC+ui9Kx6tJWzYPgI3faHUqK7yA=;
        h=Date:To:From:Subject:From;
        b=IgiYxiHsZaZ7nyK7/WCd06cbsHLa0BqncyXovJS9uAfvHQywy8n8Sn2Zu2/fCqf+Q
         lTycark6vlvUpDGU8SRyiuaPTgcJQRBjujMS7v+fZzswgOeB7ypcm5RUQQ3U0C/dVT
         lCqPtjqMDbpDMXKrpBLqbp2wxAGD1VWCVel6dDWg=
Date:   Mon, 07 Aug 2023 09:44:03 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        shy828301@gmail.com, ryan.roberts@arm.com, minchan@kernel.org,
        david@redhat.com, fengwei.yin@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] madvise-madvise_cold_or_pageout_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch removed from -mm tree
Message-Id: <20230807164404.9D754C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: madvise:madvise_cold_or_pageout_pte_range(): don't use mapcount() against large folio for sharing check
has been removed from the -mm tree.  Its filename was
     madvise-madvise_cold_or_pageout_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: madvise:madvise_cold_or_pageout_pte_range(): don't use mapcount() against large folio for sharing check
Date: Sat, 29 Jul 2023 00:13:55 +0800

Patch series "don't use mapcount() to check large folio sharing".

In madvise_cold_or_pageout_pte_range() and madvise_free_pte_range(),
folio_mapcount() is used to check whether the folio is shared.  But it's
not correct as folio_mapcount() returns total mapcount of large folio.

Use folio_estimated_sharers() here as the estimated number is enough.


This patch (of 3):

Commit 07e8c82b5eff ("madvise: convert madvise_cold_or_pageout_pte_range()
to use folios") replaced the page_mapcount() with folio_mapcount() to
check whether the folio is shared by other mapping.

But it's not correct for large folio.  folio_mapcount() returns the total
mapcount of large folio which is not suitable to detect whether the folio
is shared.

Use folio_estimated_sharers() which returns a estimated number of shares. 
That means it's not 100% correct.  But it should be OK for madvise case
here.

Link: https://lkml.kernel.org/r/20230728161356.1784568-1-fengwei.yin@intel.com
Link: https://lkml.kernel.org/r/20230728161356.1784568-2-fengwei.yin@intel.com
Fixes: 07e8c82b5eff ("madvise: convert madvise_cold_or_pageout_pte_range() to use folios")
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
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
@@ -460,7 +460,7 @@ regular_folio:
 		if (folio_test_large(folio)) {
 			int err;
 
-			if (folio_mapcount(folio) != 1)
+			if (folio_estimated_sharers(folio) != 1)
 				break;
 			if (pageout_anon_only_filter && !folio_test_anon(folio))
 				break;
_

Patches currently in -mm which might be from fengwei.yin@intel.com are

madvise-madvise_free_huge_pmd-dont-use-mapcount-against-large-folio-for-sharing-check.patch
madvise-madvise_free_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch
filemap-add-filemap_map_folio_range.patch
rmap-add-folio_add_file_rmap_range.patch
mm-convert-do_set_pte-to-set_pte_range.patch
filemap-batch-pte-mappings.patch

