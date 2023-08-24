Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E25EC83003
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 22:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243789AbjHXWA1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 18:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243840AbjHXWAW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 18:00:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215FF1BF7
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 15:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0D176342E
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 22:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1297DC433C7;
        Thu, 24 Aug 2023 22:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692914417;
        bh=JudMi9YzUpUmPZI11hGYYHRZcRgGKZt34hYMgLwx86Q=;
        h=Date:To:From:Subject:From;
        b=g7Sg4snc3ZEePbfQwb7N9g/GeVwpE8qvDvOZJGkztntmNvQ5BoW1w0mSKBy4JQqo4
         Zt2oQqCe86pun/stabNoqa9eUVgoQqqlcWERyVGhAlz+M+QBSMQq+fTt8W3aL621oM
         DDVsfuZ3k217Q7jlfiTV6C7J1uZ2RkdgAblk/i5Y=
Date:   Thu, 24 Aug 2023 15:00:16 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        shy828301@gmail.com, ryan.roberts@arm.com, minchan@kernel.org,
        david@redhat.com, fengwei.yin@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] madvise-madvise_free_huge_pmd-dont-use-mapcount-against-large-folio-for-sharing-check.patch removed from -mm tree
Message-Id: <20230824220017.1297DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: madvise:madvise_free_huge_pmd(): don't use mapcount() against large folio for sharing check
has been removed from the -mm tree.  Its filename was
     madvise-madvise_free_huge_pmd-dont-use-mapcount-against-large-folio-for-sharing-check.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: madvise:madvise_free_huge_pmd(): don't use mapcount() against large folio for sharing check
Date: Tue, 8 Aug 2023 10:09:16 +0800

Commit fc986a38b670 ("mm: huge_memory: convert madvise_free_huge_pmd to
use a folio") replaced the page_mapcount() with folio_mapcount() to check
whether the folio is shared by other mapping.

It's not correct for large folios. folio_mapcount() returns the total
mapcount of large folio which is not suitable to detect whether the folio
is shared.

Use folio_estimated_sharers() which returns a estimated number of shares.
That means it's not 100% correct. It should be OK for madvise case here.

User-visible effects is that the THP is skipped when user call madvise.
But the correct behavior is THP should be split and processed then.

NOTE: this change is a temporary fix to reduce the user-visible effects
before the long term fix from David is ready.

Link: https://lkml.kernel.org/r/20230808020917.2230692-3-fengwei.yin@intel.com
Fixes: fc986a38b670 ("mm: huge_memory: convert madvise_free_huge_pmd to use a folio")
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~madvise-madvise_free_huge_pmd-dont-use-mapcount-against-large-folio-for-sharing-check
+++ a/mm/huge_memory.c
@@ -1612,7 +1612,7 @@ bool madvise_free_huge_pmd(struct mmu_ga
 	 * If other processes are mapping this folio, we couldn't discard
 	 * the folio unless they all do MADV_FREE so let's skip the folio.
 	 */
-	if (folio_mapcount(folio) != 1)
+	if (folio_estimated_sharers(folio) != 1)
 		goto out;
 
 	if (!folio_trylock(folio))
_

Patches currently in -mm which might be from fengwei.yin@intel.com are

filemap-add-filemap_map_folio_range.patch
rmap-add-folio_add_file_rmap_range.patch
mm-convert-do_set_pte-to-set_pte_range.patch
filemap-batch-pte-mappings.patch

