Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61383C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 05:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiB1FQc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 00:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiB1FQb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 00:16:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE039517E7
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 21:15:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 677AF60F26
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 05:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B831CC340E7;
        Mon, 28 Feb 2022 05:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646025352;
        bh=7ARO1DXXEINEYKv7aFxUrhCoK+QJpC2/Dzokmw2q710=;
        h=Date:To:From:Subject:From;
        b=Mdpk86zJpNdyXomvR0p4xd8R53toDcmpsXaytia1iVCpitkj2IYzJAdH18WyZyjLp
         GanInTyQ5SmAwwjYl+DSiriUGL2JvHLmoRYsFJUYHM/dpMipbpIur2E6V0yvUI40UD
         BFmbz1og8GUrQA8HhmBTUhfy8Hzx3azbyY7p1+kI=
Date:   Sun, 27 Feb 2022 21:15:52 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-fix-collapse_files-try_to_unmapfolio.patch added to -mm tree
Message-Id: <20220228051552.B831CC340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: fix collapse_file()'s try_to_unmap(folio,)
has been added to the -mm tree.  Its filename is
     mm-thp-fix-collapse_files-try_to_unmapfolio.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-fix-collapse_files-try_to_unmapfolio.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-fix-collapse_files-try_to_unmapfolio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: fix collapse_file()'s try_to_unmap(folio,)

The foliation of THP collapse_file()'s call to try_to_unmap() is currently
wrong, crashing on a test in rmap_walk() when xas_next() delivered a value
(after which page has been loaded independently).

Link: https://lkml.kernel.org/r/3f187b6c-e5e8-e66d-e0c0-7455ca6abb4c@google.com
Fixes: c3b522d9a698 ("mm/rmap: Convert try_to_unmap() to take a folio")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-thp-fix-collapse_files-try_to_unmapfolio
+++ a/mm/khugepaged.c
@@ -1835,7 +1835,8 @@ static void collapse_file(struct mm_stru
 		}
 
 		if (page_mapped(page))
-			try_to_unmap(folio, TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
+			try_to_unmap(page_folio(page),
+				     TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
 
 		xas_lock_irq(&xas);
 		xas_set(&xas, index);
_

Patches currently in -mm which might be from hughd@google.com are

memfd-fix-f_seal_write-after-shmem-huge-page-allocated.patch
tmpfs-support-for-file-creation-time-fix.patch
mm-thp-fix-collapse_files-try_to_unmapfolio.patch
mm-migrate-fix-remove_migration_pte-of-hugetlb-entry.patch

