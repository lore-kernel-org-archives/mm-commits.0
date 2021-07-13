Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A100DC07E95
	for <mm-commits@archiver.kernel.org>; Tue, 13 Jul 2021 22:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8715861284
	for <mm-commits@archiver.kernel.org>; Tue, 13 Jul 2021 22:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236702AbhGMWof (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jul 2021 18:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236696AbhGMWof (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Jul 2021 18:44:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FA4861279;
        Tue, 13 Jul 2021 22:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626216103;
        bh=3V5e0q1xqeLdldBeL8PzBEkmOHE/n8fUiCzHjuUDpUk=;
        h=Date:From:To:Subject:From;
        b=kvJxnmigba4mTDmEUp4UOKFM1Q/krlcgNrvfDHLkUjtlcc9NQAmymtXGh9N8BD4To
         6AjOa0mnTH3A3/tVxaf14LVCBvhNmw2APWXZPDpxBQZ3/cPA8ABch2fkBQtAQN4LkN
         LkI9ec210+w9tArxa3Gy82P65vPJ1j3GdaoBE6uo=
Date:   Tue, 13 Jul 2021 15:41:43 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hch@lst.de, hughd@google.com, jgg@nvidia.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, shakeelb@google.com, shy828301@gmail.com
Subject:  [merged]
 mm-rmap-try_to_migrate-skip-zone_device-device_private.patch removed from
 -mm tree
Message-ID: <20210713224143.DvRoj48Gl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: try_to_migrate() skip zone_device !device_private
has been removed from the -mm tree.  Its filename was
     mm-rmap-try_to_migrate-skip-zone_device-device_private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/rmap: try_to_migrate() skip zone_device !device_private

I know nothing about zone_device pages and !device_private pages; but if
try_to_migrate_one() will do nothing for them, then it's better that
try_to_migrate() filter them first, than trawl through all their vmas.

Link: https://lkml.kernel.org/r/1241d356-8ec9-f47b-a5ec-9b2bf66d242@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/rmap.c~mm-rmap-try_to_migrate-skip-zone_device-device_private
+++ a/mm/rmap.c
@@ -1702,9 +1702,6 @@ static bool try_to_migrate_one(struct pa
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 
-	if (is_zone_device_page(page) && !is_device_private_page(page))
-		return true;
-
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
 	 * in between its ptep_get_and_clear_full() and page_remove_rmap(),
@@ -1943,6 +1940,9 @@ void try_to_migrate(struct page *page, e
 					TTU_SYNC)))
 		return;
 
+	if (is_zone_device_page(page) && !is_device_private_page(page))
+		return;
+
 	/*
 	 * During exec, a temporary VMA is setup and later moved.
 	 * The VMA is moved under the anon_vma lock but not the
_

Patches currently in -mm which might be from hughd@google.com are

fs-mm-fix-race-in-unlinking-swapfile.patch

