Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF65ECDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 16:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjJRQSn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 12:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjJRQSm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 12:18:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A50B8
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 09:18:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C17C433C8;
        Wed, 18 Oct 2023 16:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697645920;
        bh=o6nHCTgjeggWPgs+n8Zd4QS+xeYaEQBUOWij6B2LNtQ=;
        h=Date:To:From:Subject:From;
        b=AfEvqMh8c+zq5HoFxvSEB3JC4A65+KC0Rs4wMfbxc/9RSzvMEW5v5cHLKo5+S0trR
         IDF24Rz7dRSkq1I9vmdE9iaBV4OJworH32sWI2sDKZ5zuupAcF5Zg9i4QIUFl7HPRm
         R766YbtIfGsl9qU8+gSW/Gs5w3ljK7M1e73C06Tk=
Date:   Wed, 18 Oct 2023 09:18:40 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats.patch added to mm-unstable branch
Message-Id: <20231018161840.91C17C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: add nr_split to trace_mm_migrate_pages stats.
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/migrate: add nr_split to trace_mm_migrate_pages stats.
Date: Tue, 17 Oct 2023 12:31:29 -0400

Add nr_split to trace_mm_migrate_pages for large folio (including THP)
split events.

Link: https://lkml.kernel.org/r/20231017163129.2025214-2-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/migrate.h |   24 ++++++++++++++----------
 mm/migrate.c                   |    3 ++-
 2 files changed, 16 insertions(+), 11 deletions(-)

--- a/include/trace/events/migrate.h~mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats
+++ a/include/trace/events/migrate.h
@@ -49,10 +49,11 @@ TRACE_EVENT(mm_migrate_pages,
 
 	TP_PROTO(unsigned long succeeded, unsigned long failed,
 		 unsigned long thp_succeeded, unsigned long thp_failed,
-		 unsigned long thp_split, enum migrate_mode mode, int reason),
+		 unsigned long thp_split, unsigned long large_folio_split,
+		 enum migrate_mode mode, int reason),
 
 	TP_ARGS(succeeded, failed, thp_succeeded, thp_failed,
-		thp_split, mode, reason),
+		thp_split, large_folio_split, mode, reason),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,		succeeded)
@@ -60,26 +61,29 @@ TRACE_EVENT(mm_migrate_pages,
 		__field(	unsigned long,		thp_succeeded)
 		__field(	unsigned long,		thp_failed)
 		__field(	unsigned long,		thp_split)
+		__field(	unsigned long,		large_folio_split)
 		__field(	enum migrate_mode,	mode)
 		__field(	int,			reason)
 	),
 
 	TP_fast_assign(
-		__entry->succeeded	= succeeded;
-		__entry->failed		= failed;
-		__entry->thp_succeeded	= thp_succeeded;
-		__entry->thp_failed	= thp_failed;
-		__entry->thp_split	= thp_split;
-		__entry->mode		= mode;
-		__entry->reason		= reason;
+		__entry->succeeded			= succeeded;
+		__entry->failed				= failed;
+		__entry->thp_succeeded		= thp_succeeded;
+		__entry->thp_failed			= thp_failed;
+		__entry->thp_split			= thp_split;
+		__entry->large_folio_split	= large_folio_split;
+		__entry->mode				= mode;
+		__entry->reason				= reason;
 	),
 
-	TP_printk("nr_succeeded=%lu nr_failed=%lu nr_thp_succeeded=%lu nr_thp_failed=%lu nr_thp_split=%lu mode=%s reason=%s",
+	TP_printk("nr_succeeded=%lu nr_failed=%lu nr_thp_succeeded=%lu nr_thp_failed=%lu nr_thp_split=%lu nr_split=%lu mode=%s reason=%s",
 		__entry->succeeded,
 		__entry->failed,
 		__entry->thp_succeeded,
 		__entry->thp_failed,
 		__entry->thp_split,
+		__entry->large_folio_split,
 		__print_symbolic(__entry->mode, MIGRATE_MODE),
 		__print_symbolic(__entry->reason, MIGRATE_REASON))
 );
--- a/mm/migrate.c~mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats
+++ a/mm/migrate.c
@@ -1979,7 +1979,8 @@ out:
 	count_vm_events(THP_MIGRATION_SPLIT, stats.nr_thp_split);
 	trace_mm_migrate_pages(stats.nr_succeeded, stats.nr_failed_pages,
 			       stats.nr_thp_succeeded, stats.nr_thp_failed,
-			       stats.nr_thp_split, mode, reason);
+			       stats.nr_thp_split, stats.nr_split, mode,
+			       reason);
 
 	if (ret_succeeded)
 		*ret_succeeded = stats.nr_succeeded;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-migrate-correct-nr_failed-in-migrate_pages_sync.patch
mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats.patch

