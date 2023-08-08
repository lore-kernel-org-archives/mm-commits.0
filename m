Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3512C001B0
	for <mm-commits@archiver.kernel.org>; Tue,  8 Aug 2023 19:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236476AbjHHTef (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Aug 2023 15:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236486AbjHHTeU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Aug 2023 15:34:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3452C997
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 11:00:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38B7162941
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 18:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89076C433C7;
        Tue,  8 Aug 2023 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691517638;
        bh=K0gczjoRhD3zwuQrIskZabtSfmUmFiZge/SmyHCSr/s=;
        h=Date:To:From:Subject:From;
        b=ta88tm9bmVOeRRqIPR1fTzGn4sYouqQ/l+RZq9NIBG6o8FwcY7MLgNZ1X/mgVY1SE
         2QF4OgHvKfwMgfmmViejXx9skcuDCvfvYz1y1oC+UalsvsFfzQAy8+TZ8eAtDqBYT0
         EOoAoO49kGhjINJgwowxQ9JZzPZeqHF3o8hQaBmw=
Date:   Tue, 08 Aug 2023 11:00:37 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        shy828301@gmail.com, ryan.roberts@arm.com, minchan@kernel.org,
        david@redhat.com, fengwei.yin@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + madvise-madvise_free_huge_pmd-dont-use-mapcount-against-large-folio-for-sharing-check.patch added to mm-hotfixes-unstable branch
Message-Id: <20230808180038.89076C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: madvise:madvise_free_huge_pmd(): don't use mapcount() against large folio for sharing check
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     madvise-madvise_free_huge_pmd-dont-use-mapcount-against-large-folio-for-sharing-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/madvise-madvise_free_huge_pmd-dont-use-mapcount-against-large-folio-for-sharing-check.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

madvise-madvise_cold_or_pageout_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch
madvise-madvise_free_huge_pmd-dont-use-mapcount-against-large-folio-for-sharing-check.patch
madvise-madvise_free_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch
filemap-add-filemap_map_folio_range.patch
rmap-add-folio_add_file_rmap_range.patch
mm-convert-do_set_pte-to-set_pte_range.patch
filemap-batch-pte-mappings.patch

