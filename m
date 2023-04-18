Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5925DC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 01:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjDRBU5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Apr 2023 21:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjDRBU4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Apr 2023 21:20:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58013AA2
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 18:20:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41BA960FCB
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 01:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962A7C433D2;
        Tue, 18 Apr 2023 01:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681780854;
        bh=A6VxnOTEAfLboMrYaV0C1UuSi5Dvz3UzfhsxzjmbwDk=;
        h=Date:To:From:Subject:From;
        b=b3EL4ZlIXomwHGcZ2xOjn9DUtHHf+KKWKqn1Fu8TibmSf2sXunH7NZ7MgHC7VhaYg
         Ox7UjbclwWHTxkLgtl8fAebDMYkNgRXAD+dYz2Op/kpIGsn1DKl5zykV5obno1W/9y
         /6iPoiJvM29reMH7Dp+2R3hIy0xeFU+HGEOe7KYg=
Date:   Mon, 17 Apr 2023 18:20:53 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, shy828301@gmail.com,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        apopple@nvidia.com, ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages_batch-fix-statistics-for-longterm-pin-retry.patch added to mm-unstable branch
Message-Id: <20230418012054.962A7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages_batch: fix statistics for longterm pin retry
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages_batch-fix-statistics-for-longterm-pin-retry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages_batch-fix-statistics-for-longterm-pin-retry.patch

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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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

migrate_pages_batch-fix-statistics-for-longterm-pin-retry.patch

