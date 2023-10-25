Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E1CC25B6B
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbjJYXu1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbjJYXtI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:49:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86A8199
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BC4C433C9;
        Wed, 25 Oct 2023 23:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277739;
        bh=L/WQ1PmjPhafU/WYGyjBXfHGJyqUYok8xdbjHVwWPB4=;
        h=Date:To:From:Subject:From;
        b=hdHQcttrtvFZ4+9aC0X+lJXKhxIHJfxRXrhBLdmgpnGrbeW4hmKkmExQn8yEwFvlH
         /rQNyeflmX9AnCbg8FS/8fMwh3ZlXPsEf0spPKXsT8sMkfrbsJUAxinYKAs6nhxvCM
         hLumVeGOLYSBe5uFT+ygZFRbIH7n3yddGOvT54jY=
Date:   Wed, 25 Oct 2023 16:48:58 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats.patch removed from -mm tree
Message-Id: <20231025234859.84BC4C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate: add nr_split to trace_mm_migrate_pages stats.
has been removed from the -mm tree.  Its filename was
     mm-migrate-add-nr_split-to-trace_mm_migrate_pages-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/migrate: add nr_split to trace_mm_migrate_pages stats.
Date: Tue, 17 Oct 2023 12:31:29 -0400

Add nr_split to trace_mm_migrate_pages for large folio (including THP)
split events.

[akpm@linux-foundation.org: cleanup per Huang, Ying]
Link: https://lkml.kernel.org/r/20231017163129.2025214-2-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/migrate.h |   24 ++++++++++++++----------
 mm/migrate.c                   |    5 +++--
 2 files changed, 17 insertions(+), 12 deletions(-)

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
@@ -1686,7 +1686,7 @@ static int migrate_pages_batch(struct li
 
 					if (!ret) {
 						stats->nr_thp_split += is_thp;
-						stats->nr_split += is_large;
+						stats->nr_split++;
 						break;
 					} else if (reason == MR_LONGTERM_PIN &&
 						   ret == -EAGAIN) {
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


