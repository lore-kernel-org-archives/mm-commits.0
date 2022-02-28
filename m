Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EFF7C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 05:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbiB1FQi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Feb 2022 00:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiB1FQd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Feb 2022 00:16:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CBB517E7
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 21:15:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13D9C60F26
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 05:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68718C340E7;
        Mon, 28 Feb 2022 05:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646025354;
        bh=uo7NJH8QQagRnCcByixhMjqkQMinhjPLas8d4rEtewM=;
        h=Date:To:From:Subject:From;
        b=xABMYcWaNqg+HYS7nTr2RoFRqeIfDjcKiOMoXmF4cc5Fn1XSuVuHkTCgvK38Dg3GL
         plpdWaBALogF67DQKDBdb9nf8kQ7OTU3jdv2XfmQJ12S4aoxCVgzgKQmijafiWY3jA
         zFUqBMcGYQDymnMDXrfSh28Kp9KAAn/kR0qu0trA=
Date:   Sun, 27 Feb 2022 21:15:53 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-fix-remove_migration_pte-of-hugetlb-entry.patch added to -mm tree
Message-Id: <20220228051554.68718C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: fix remove_migration_pte() of hugetlb entry
has been added to the -mm tree.  Its filename is
     mm-migrate-fix-remove_migration_pte-of-hugetlb-entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-fix-remove_migration_pte-of-hugetlb-entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-fix-remove_migration_pte-of-hugetlb-entry.patch

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
Subject: mm/migrate: fix remove_migration_pte() of hugetlb entry

The foliation of remove_migration_pte() is currently wrong on hugetlb anon
entries, causing LTP move_pages12 to crash on BUG_ON(!PageLocked) in
hugepage_add_anon_rmap().

Link: https://lkml.kernel.org/r/bd28ebcf-4d42-7184-8189-ffed6fe7d4dc@google.com
Fixes: b4010e88f071 ("mm/migrate: Convert remove_migration_ptes() to folios")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-fix-remove_migration_pte-of-hugetlb-entry
+++ a/mm/migrate.c
@@ -182,7 +182,8 @@ static bool remove_migration_pte(struct
 		struct page *new;
 		unsigned long idx = 0;
 
-		if (!folio_test_ksm(folio))
+		/* Skip call in common case, plus .pgoff is invalid for KSM */
+		if (pvmw.nr_pages != 1 && !folio_test_hugetlb(folio))
 			idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
 		new = folio_page(folio, idx);
 
_

Patches currently in -mm which might be from hughd@google.com are

memfd-fix-f_seal_write-after-shmem-huge-page-allocated.patch
tmpfs-support-for-file-creation-time-fix.patch
mm-thp-fix-collapse_files-try_to_unmapfolio.patch
mm-migrate-fix-remove_migration_pte-of-hugetlb-entry.patch

