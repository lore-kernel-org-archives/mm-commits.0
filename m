Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4279C001DE
	for <mm-commits@archiver.kernel.org>; Fri, 28 Jul 2023 17:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbjG1Rlw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jul 2023 13:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjG1Rlq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jul 2023 13:41:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D1E35B6
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 10:41:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BED7621C6
        for <mm-commits@vger.kernel.org>; Fri, 28 Jul 2023 17:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3DCC433C7;
        Fri, 28 Jul 2023 17:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690566100;
        bh=qbY1p6icda0Um7aNqlNaYmYeZFn16uIf3M6M09JHNnk=;
        h=Date:To:From:Subject:From;
        b=d6HfVJQZ3Yy5Czfe6ayC+5jdmlihHl96BHXwlfb0zKRmlRlS038HFYvfxJZDEi2YH
         Bi0F5b1wUG0sF5GRQZ+DpCGC6YHtNNoZP8i40R+EhKXzk4MY1DYT2mbFhRaLupnqOw
         AYC0xHyOLe5ITHZhy7BAsYPrzdx2R2ZG5THTZVeA=
Date:   Fri, 28 Jul 2023 10:41:39 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, vishal.moola@gmail.com,
        shy828301@gmail.com, ryan.roberts@arm.com, minchan@kernel.org,
        david@redhat.com, fengwei.yin@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + madvise-madvise_free_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch added to mm-unstable branch
Message-Id: <20230728174140.9E3DCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: madvise:madvise_free_pte_range(): don't use mapcount() against large folio for sharing check
has been added to the -mm mm-unstable branch.  Its filename is
     madvise-madvise_free_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/madvise-madvise_free_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch

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
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~madvise-madvise_free_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check
+++ a/mm/madvise.c
@@ -682,7 +682,7 @@ static int madvise_free_pte_range(pmd_t
 		if (folio_test_large(folio)) {
 			int err;
 
-			if (folio_mapcount(folio) != 1)
+			if (folio_estimated_sharers(folio) != 1)
 				break;
 			if (!folio_trylock(folio))
 				break;
_

Patches currently in -mm which might be from fengwei.yin@intel.com are

madvise-madvise_cold_or_pageout_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch
madvise-madvise_free_huge_pmd-dont-use-mapcount-against-large-folio-for-sharing-check.patch
madvise-madvise_free_pte_range-dont-use-mapcount-against-large-folio-for-sharing-check.patch

