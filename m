Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DC5C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Mar 2022 16:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiCAQvt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Mar 2022 11:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiCAQvs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2022 11:51:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91726551
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 08:51:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 614B2B8185A
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 16:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE9BC340EE;
        Tue,  1 Mar 2022 16:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646153460;
        bh=LbOcsbUIAxslOkx4fGPNzOurJIL3a512x+ASEj/BgHQ=;
        h=Date:To:From:Subject:From;
        b=z2wi8ntYKsgU7JmmN/qehorpdRjTKJ0cOBt99hFhSFI4P5BQybM0yn+uGZPkzYuEj
         66gfG+o+MbVMfXB10LZObDIASB0F5DIyLKvkYXuvEYlEnfxzHVr+Xk+G7UaclaOMvV
         S/7lPx/BtxfuuRZ1L9cclQbfNb3oksB33tpLlAr4=
Date:   Tue, 01 Mar 2022 08:51:00 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-migrate-fix-remove_migration_pte-of-hugetlb-entry.patch removed from -mm tree
Message-Id: <20220301165100.DBE9BC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: fix remove_migration_pte() of hugetlb entry
has been removed from the -mm tree.  Its filename was
     mm-migrate-fix-remove_migration_pte-of-hugetlb-entry.patch

This patch was dropped because an alternative patch was merged

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
@@ -183,7 +183,8 @@ static bool remove_migration_pte(struct
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

