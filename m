Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655C7C001DE
	for <mm-commits@archiver.kernel.org>; Fri, 28 Jul 2023 17:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjG1Rlo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jul 2023 13:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjG1Rln (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2023 13:41:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C018510CB
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 10:41:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49CBD621C4
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 17:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E12EC433C7;
        Fri, 28 Jul 2023 17:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690566098;
        bh=tja2iK4lF+WBnFw6OJZAhUTUvKeE7sHLOu+3SzEMCRE=;
        h=Date:To:From:Subject:From;
        b=JMz8L1lpdR9OER9OkfFIrK9C8kDIWn/nYN5wxtz+cLfMxlojp0cw/oFRgOjURcoyr
         HiCrxIr3lTTlf6eS4NThrg6rV2FJ2Ofdgk8RBMOawMoEDgSFmSfeNZfYhYdZnB6W1X
         zTctxmAk1ioVjyXIvwYbWxLSiO3rvq5Fxa/QpVXw=
Date:   Fri, 28 Jul 2023 10:41:38 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        shy828301@gmail.com, ryan.roberts@arm.com, minchan@kernel.org,
        david@redhat.com, fengwei.yin@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + madvise-madvise_free_huge_pmd-dont-use-mapcount-against-large-folio-for-sharing-check.patch added to mm-unstable branch
Message-Id: <20230728174138.9E12EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: madvise:madvise_free_huge_pmd(): don't use mapcount() against large folio for sharing check
has been added to the -mm mm-unstable branch.  Its filename is
     madvise-madvise_free_huge_pmd-dont-use-mapcount-against-large-folio-for-sharing-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/madvise-madvise_free_huge_pmd-dont-use-mapcount-against-large-folio-for-sharing-check.patch

This patch will later appear in the mm-unstable branch at
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
Date: Sat, 29 Jul 2023 00:13:56 +0800

Commit fc986a38b670 ("mm: huge_memory: convert madvise_free_huge_pmd to
use a folio") replaced the page_mapcount() with folio_mapcount() to check
whether the folio is shared by other mapping.

But it's not correct for large folios.  folio_mapcount() returns the total
mapcount of large folio which is not suitable to detect whether the folio
is shared.

Use folio_estimated_sharers() which returns a estimated number of shares. 
That means it's not 100% correct.  But it should be OK for madvise case
here.

Link: https://lkml.kernel.org/r/20230728161356.1784568-3-fengwei.yin@intel.com
Fixes: fc986a38b670 ("mm: huge_memory: convert madvise_free_huge_pmd to use a folio")
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Yu Zhao <yuzhao@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~madvise-madvise_free_huge_pmd-dont-use-mapcount-against-large-folio-for-sharing-check
+++ a/mm/huge_memory.c
@@ -1613,7 +1613,7 @@ bool madvise_free_huge_pmd(struct mmu_ga
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

