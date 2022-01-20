Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86FCAC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347846AbiATV1m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:27:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58612 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377882AbiATV1l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:27:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFD6EB81E6B
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F42CC340E0;
        Thu, 20 Jan 2022 21:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714058;
        bh=vuDOhu50o/TF5MUVfS+HYXll0sV2qpxo9B7RgqjI+9M=;
        h=Date:From:To:Subject:From;
        b=tG7luQRHej12kFQcLXPkhQepb0V6hIKMipQEP9QUuLc3bFqsnVndtXAfOPgZ6r0aQ
         ZeWNHq8/GCdjORWnuE5TutHEvFiYhPj/Xv2sLuwRAfUjxVP/md9d63wGPfhzFm1VbS
         G6/3G+K+bRRb6Cz/IGT5ahikNSEjcYukFnuvRg+4=
Date:   Thu, 20 Jan 2022 13:27:38 -0800
From:   akpm@linux-foundation.org
To:     colin.i.king@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-migrate-remove-redundant-variables-used-in-a-for-loop.patch removed from
 -mm tree
Message-ID: <20220120212738.O9vUiNlyn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: remove redundant variables used in a for-loop
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-redundant-variables-used-in-a-for-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: mm/migrate: remove redundant variables used in a for-loop

The variable addr is being set and incremented in a for-loop but not
actually being used.  It is redundant and so addr and also variable start
can be removed.

Link: https://lkml.kernel.org/r/20211221185729.609630-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-redundant-variables-used-in-a-for-loop
+++ a/mm/migrate.c
@@ -2481,8 +2481,7 @@ static bool migrate_vma_check_page(struc
 static void migrate_vma_unmap(struct migrate_vma *migrate)
 {
 	const unsigned long npages = migrate->npages;
-	const unsigned long start = migrate->start;
-	unsigned long addr, i, restore = 0;
+	unsigned long i, restore = 0;
 	bool allow_drain = true;
 
 	lru_add_drain();
@@ -2528,7 +2527,7 @@ static void migrate_vma_unmap(struct mig
 		}
 	}
 
-	for (addr = start, i = 0; i < npages && restore; addr += PAGE_SIZE, i++) {
+	for (i = 0; i < npages && restore; i++) {
 		struct page *page = migrate_pfn_to_page(migrate->src[i]);
 
 		if (!page || (migrate->src[i] & MIGRATE_PFN_MIGRATE))
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

kernel-sysctlc-remove-unused-variable-ten_thousand.patch

