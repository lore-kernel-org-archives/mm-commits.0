Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F55BC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5233961029
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhEEBiL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231459AbhEEBiJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91E9A61182;
        Wed,  5 May 2021 01:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178633;
        bh=qQZBRrvIBD+ajcs7sSqwygx5I7fVvZxfys1rL/DvC04=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=StutO2z3NeAiv5whm0LzsWHzq8K4H7cJGR0qTo6Itt3Jdvp9rew2dehl2q7m5398O
         H3PWDke9DsXY9EKqyPTz4TLg7dqZcluYqALd4PTl8ZtnZhrBg9XjEPrs/MuKbPQi8m
         Q7riJF7Pdlz5RN2U6KJNrPQOai93tvORfd9q+Vn0=
Date:   Tue, 04 May 2021 18:37:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, aquini@redhat.com,
        david@redhat.com, jglisse@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        shy828301@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 083/143] mm/migrate.c: use helper
 migrate_vma_collect_skip() in migrate_vma_collect_hole()
Message-ID: <20210505013713.JMP8b9Uib%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/migrate.c: use helper migrate_vma_collect_skip() in migrate_vma_collect_hole()

It's more recommended to use helper function migrate_vma_collect_skip() to
skip the unexpected case and it also helps remove some duplicated codes. 
Move migrate_vma_collect_skip() above migrate_vma_collect_hole() to avoid
compiler warning.

Link: https://lkml.kernel.org/r/20210325131524.48181-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

--- a/mm/migrate.c~mm-migratec-use-helper-migrate_vma_collect_skip-in-migrate_vma_collect_hole
+++ a/mm/migrate.c
@@ -2290,44 +2290,38 @@ out:
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_DEVICE_PRIVATE
-static int migrate_vma_collect_hole(unsigned long start,
+static int migrate_vma_collect_skip(unsigned long start,
 				    unsigned long end,
-				    __always_unused int depth,
 				    struct mm_walk *walk)
 {
 	struct migrate_vma *migrate = walk->private;
 	unsigned long addr;
 
-	/* Only allow populating anonymous memory. */
-	if (!vma_is_anonymous(walk->vma)) {
-		for (addr = start; addr < end; addr += PAGE_SIZE) {
-			migrate->src[migrate->npages] = 0;
-			migrate->dst[migrate->npages] = 0;
-			migrate->npages++;
-		}
-		return 0;
-	}
-
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
 		migrate->dst[migrate->npages] = 0;
-		migrate->npages++;
-		migrate->cpages++;
+		migrate->src[migrate->npages++] = 0;
 	}
 
 	return 0;
 }
 
-static int migrate_vma_collect_skip(unsigned long start,
+static int migrate_vma_collect_hole(unsigned long start,
 				    unsigned long end,
+				    __always_unused int depth,
 				    struct mm_walk *walk)
 {
 	struct migrate_vma *migrate = walk->private;
 	unsigned long addr;
 
+	/* Only allow populating anonymous memory. */
+	if (!vma_is_anonymous(walk->vma))
+		return migrate_vma_collect_skip(start, end, walk);
+
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
+		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
 		migrate->dst[migrate->npages] = 0;
-		migrate->src[migrate->npages++] = 0;
+		migrate->npages++;
+		migrate->cpages++;
 	}
 
 	return 0;
_
