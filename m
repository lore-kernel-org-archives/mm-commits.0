Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 504B4C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiANWI4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiANWI4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:08:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB2FC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:08:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C188B8262E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32DEC36AED;
        Fri, 14 Jan 2022 22:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198133;
        bh=OEr23vaDxvm6QNKQAFBebrhz6efR0tnYgbOQuxOfUbI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ldadwEOjh9XwSw7AQIVUBDy+R+Kogjb5/jz2EKoHjbGN53kCFljdasINAkyCkHgZL
         8LXOSuwXP0OJsvO83deZ4/1DkgpgW9Z3dUIVutqu9VAHEPj9IxVI6fMSHPIqrp6tzF
         RWIcFejmvED6ff/ey9tgrFjhdK+6YA+Sy2BuyAx4=
Date:   Fri, 14 Jan 2022 14:08:53 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.i.king@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 108/146] mm/migrate: remove redundant variables
 used in a for-loop
Message-ID: <20220114220853.LyjnURLZU%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
