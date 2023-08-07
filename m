Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8192C001DB
	for <mm-commits@archiver.kernel.org>; Mon,  7 Aug 2023 16:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjHGQoN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Aug 2023 12:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbjHGQoJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Aug 2023 12:44:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021D6171E
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 09:44:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78F8261F6B
        for <mm-commits@vger.kernel.org>; Mon,  7 Aug 2023 16:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D258FC433C7;
        Mon,  7 Aug 2023 16:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691426646;
        bh=qjIaekSSD2hlmeED5/fJs0piCnSqUKP4+HEyQOQkvk8=;
        h=Date:To:From:Subject:From;
        b=SaJXpCf36DKAhBsStq8lF35pF+Na1Vc8LyQBXyv+0Zp9juETR6+zyukgYbNCdd54g
         m4MXV15Pzwo+I2G3WQy5o6qhqoScbbqFg4ZXftKDC2HWpVRyPHFgBknm2sV1ySJMKG
         87dXbw+NaaTBr8EZEkBJneP9cp+JY3JjSs2VcPh8=
Date:   Mon, 07 Aug 2023 09:44:06 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        shy828301@gmail.com, ryan.roberts@arm.com, minchan@kernel.org,
        david@redhat.com, fengwei.yin@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] madvise-madvise_free_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch removed from -mm tree
Message-Id: <20230807164406.D258FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: madvise:madvise_free_pte_range(): don't use mapcount() against large folio for sharing check
has been removed from the -mm tree.  Its filename was
     madvise-madvise_free_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: madvise:madvise_free_pte_range(): don't use mapcount() against large folio for sharing check
Date: Sat, 29 Jul 2023 00:13:56 +0800

Commit 98b211d6415f ("madvise: convert madvise_free_pte_range() to use a
folio") replaced the page_mapcount() with folio_mapcount() to check
whether the folio is shared by other mapping.

But it's not correct for large folios.  folio_mapcount() returns the total
mapcount of large folio which is not suitable to detect whether the folio
is shared.

Use folio_estimated_sharers() which returns a estimated number of shares. 
That means it's not 100% correct.  But it should be OK for madvise case
here.

Link: https://lkml.kernel.org/r/20230728161356.1784568-3-fengwei.yin@intel.com
Fixes: 98b211d6415f ("madvise: convert madvise_free_pte_range() to use a folio")
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

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~madvise-madvise_free_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check
+++ a/mm/madvise.c
@@ -684,7 +684,7 @@ static int madvise_free_pte_range(pmd_t
 		if (folio_test_large(folio)) {
 			int err;
 
-			if (folio_mapcount(folio) != 1)
+			if (folio_estimated_sharers(folio) != 1)
 				break;
 			if (!folio_trylock(folio))
 				break;
_

Patches currently in -mm which might be from fengwei.yin@intel.com are

filemap-add-filemap_map_folio_range.patch
rmap-add-folio_add_file_rmap_range.patch
mm-convert-do_set_pte-to-set_pte_range.patch
filemap-batch-pte-mappings.patch

