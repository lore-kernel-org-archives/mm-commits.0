Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63924C77B78
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbjDUVxK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbjDUVwv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:52:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6452D4B
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:52:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6760761363
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B66C433D2;
        Fri, 21 Apr 2023 21:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682113966;
        bh=73SDYUwuAWv+nhEoW1MvvTJMIlag94JPZI+R7Ciqh1k=;
        h=Date:To:From:Subject:From;
        b=qRDd0FvRNOWoEd3urY1PoBkfDk7NTUlX2yDVL7RAqcwTciIJ2vwunuM/KOQsdRila
         av98pavD8SNT0Yt9Mkx8eSOJn/DrZEwzkuIOhxZYRgtRen3FBJPsPJbdrtzH0xTjoH
         THGxQxA2wSUC4Io+fAgIVi8GlCB9hD7sMMP1SE2M=
Date:   Fri, 21 Apr 2023 14:52:46 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        apopple@nvidia.com, ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] migrate_pages_batch-fix-statistics-for-longterm-pin-retry.patch removed from -mm tree
Message-Id: <20230421215246.C2B66C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: migrate_pages_batch: fix statistics for longterm pin retry
has been removed from the -mm tree.  Its filename was
     migrate_pages_batch-fix-statistics-for-longterm-pin-retry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: migrate_pages_batch: fix statistics for longterm pin retry
Date: Mon, 17 Apr 2023 07:59:29 +0800

In commit fd4a7ac32918 ("mm: migrate: try again if THP split is failed due
to page refcnt"), if the THP splitting fails due to page reference count,
we will retry to improve migration successful rate.  But the failed
splitting is counted as migration failure and migration retry, which will
cause duplicated failure counting.  So, in this patch, this is fixed via
undoing the failure counting if we decide to retry.  The patch is tested
via failure injection.

Link: https://lkml.kernel.org/r/20230416235929.1040194-1-ying.huang@intel.com
Fixes: fd4a7ac32918 ("mm: migrate: try again if THP split is failed due to page refcnt")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/migrate.c~migrate_pages_batch-fix-statistics-for-longterm-pin-retry
+++ a/mm/migrate.c
@@ -1710,6 +1710,9 @@ static int migrate_pages_batch(struct li
 							large_retry++;
 							thp_retry += is_thp;
 							nr_retry_pages += nr_pages;
+							/* Undo duplicated failure counting. */
+							nr_large_failed--;
+							stats->nr_thp_failed -= is_thp;
 							break;
 						}
 					}
_

Patches currently in -mm which might be from ying.huang@intel.com are

mmunmap-avoid-flushing-tlb-in-batch-if-pte-is-inaccessible.patch

