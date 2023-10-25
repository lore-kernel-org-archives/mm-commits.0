Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00587C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjJYXh3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjJYXh2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:37:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93512181
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:37:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313E2C433C7;
        Wed, 25 Oct 2023 23:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277046;
        bh=7ROIrOzik2tUKLF6P+Dmm63EULoA0pp+o5EUqw8mEHw=;
        h=Date:To:From:Subject:From;
        b=db3zcgsHcHMXdhnDUD0NuGws95E+CSs2uzmHvYMsehpZgWDJjSXnv40BFNiC5s5lG
         ANLmAcdQPJH7wXtuBZTppPOHZQL2eHT/fD79Wqy4CzotuohrehvQqMmQGcESmbM0fV
         I1JKxf3f6zrtAnGyHzXID+UZGcYlxtgoX/Y3v/jw=
Date:   Wed, 25 Oct 2023 16:37:25 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix.patch removed from -mm tree
Message-Id: <20231025233726.313E2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix
has been removed from the -mm tree.  Its filename was
     mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix.patch

This patch was dropped because it was folded into mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix
Date: Wed Oct 18 09:17:30 AM PDT 2023

cleanup per Huang, Ying

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats-fix
+++ a/mm/migrate.c
@@ -1686,7 +1686,7 @@ static int migrate_pages_batch(struct li
 
 					if (!ret) {
 						stats->nr_thp_split += is_thp;
-						stats->nr_split += is_large;
+						stats->nr_split++;
 						break;
 					} else if (reason == MR_LONGTERM_PIN &&
 						   ret == -EAGAIN) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats.patch

