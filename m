Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D34C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FC9120768
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266132;
	bh=fheCIDjV3Uum3PBpNhkh8voqKzkqSON4QIzilvp2YEw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=pWijFWeCCIhpJxueJ8BCaKlcygvLEmHWyPuD9Whv9hhZXBskzAz4ihVpTspzNJxeD
	 7XWSabtuXgvzeN9IS/XSXDP36FMEX5x2mbgn173TQZ1z+ToTatSQFEKv46QTBHzucy
	 bJUhjdsfomhTLheA5U5fnmd7n2a5yLnevWmKobKA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHLVCM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgHLVCL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:11 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91F492078B;
        Wed, 12 Aug 2020 21:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266129;
        bh=fheCIDjV3Uum3PBpNhkh8voqKzkqSON4QIzilvp2YEw=;
        h=Date:From:To:Subject:From;
        b=hmDv98i7JnswhKpLywE+7fzwZTzBlehzGOMNiglLHVgUnUJ+gfq+zKWyFS2zkbNof
         8XA3D+O2Ywacl4vcqeGA/szc6jhe5M2i6+Vi7/iHM61AQZMb1g98CNrQI4jqcrLJcj
         KRHO6kRUSGVH1UQZMWaqNrRf1nmphmEsq1r3Gzvk=
Date:   Wed, 12 Aug 2020 14:02:09 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, daniel.m.jordan@oracle.com,
        hughd@google.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com, willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-vmstat-add-events-for-thp-migration-without-split.patch removed from -mm
 tree
Message-ID: <20200812210209.l8o_BwMMU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: add events for THP migration without split
has been removed from the -mm tree.  Its filename was
     mm-vmstat-add-events-for-thp-migration-without-split.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/vmstat: add events for THP migration without split

Add following new vmstat events which will help in validating THP
migration without split.  Statistics reported through these new VM events
will help in performance debugging.

1. THP_MIGRATION_SUCCESS
2. THP_MIGRATION_FAILURE
3. THP_MIGRATION_SPLIT

In addition, these new events also update normal page migration statistics
appropriately via PGMIGRATE_SUCCESS and PGMIGRATE_FAILURE.  While here,
this updates current trace event 'mm_migrate_pages' to accommodate now
available THP statistics.

[akpm@linux-foundation.org: s/hpage_nr_pages/thp_nr_pages/]
[ziy@nvidia.com: v2]
  Link: http://lkml.kernel.org/r/C5E3C65C-8253-4638-9D3C-71A61858BB8B@nvidia.com
[anshuman.khandual@arm.com: s/thp_nr_pages/hpage_nr_pages/]
  Link: http://lkml.kernel.org/r/1594287583-16568-1-git-send-email-anshuman.khandual@arm.com
Link: http://lkml.kernel.org/r/1594080415-27924-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_migration.rst |   27 +++++++++++++
 include/linux/vm_event_item.h       |    3 +
 include/trace/events/migrate.h      |   17 +++++++-
 mm/migrate.c                        |   52 ++++++++++++++++++++++----
 mm/vmstat.c                         |    3 +
 5 files changed, 91 insertions(+), 11 deletions(-)

--- a/Documentation/vm/page_migration.rst~mm-vmstat-add-events-for-thp-migration-without-split
+++ a/Documentation/vm/page_migration.rst
@@ -253,5 +253,32 @@ which are function pointers of struct ad
      PG_isolated is alias with PG_reclaim flag so driver shouldn't use the flag
      for own purpose.
 
+Monitoring Migration
+=====================
+
+The following events (counters) can be used to monitor page migration.
+
+1. PGMIGRATE_SUCCESS: Normal page migration success. Each count means that a
+   page was migrated. If the page was a non-THP page, then this counter is
+   increased by one. If the page was a THP, then this counter is increased by
+   the number of THP subpages. For example, migration of a single 2MB THP that
+   has 4KB-size base pages (subpages) will cause this counter to increase by
+   512.
+
+2. PGMIGRATE_FAIL: Normal page migration failure. Same counting rules as for
+   _SUCCESS, above: this will be increased by the number of subpages, if it was
+   a THP.
+
+3. THP_MIGRATION_SUCCESS: A THP was migrated without being split.
+
+4. THP_MIGRATION_FAIL: A THP could not be migrated nor it could be split.
+
+5. THP_MIGRATION_SPLIT: A THP was migrated, but not as such: first, the THP had
+   to be split. After splitting, a migration retry was used for it's sub-pages.
+
+THP_MIGRATION_* events also update the appropriate PGMIGRATE_SUCCESS or
+PGMIGRATE_FAIL events. For example, a THP migration failure will cause both
+THP_MIGRATION_FAIL and PGMIGRATE_FAIL to increase.
+
 Christoph Lameter, May 8, 2006.
 Minchan Kim, Mar 28, 2016.
--- a/include/linux/vm_event_item.h~mm-vmstat-add-events-for-thp-migration-without-split
+++ a/include/linux/vm_event_item.h
@@ -56,6 +56,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #endif
 #ifdef CONFIG_MIGRATION
 		PGMIGRATE_SUCCESS, PGMIGRATE_FAIL,
+		THP_MIGRATION_SUCCESS,
+		THP_MIGRATION_FAIL,
+		THP_MIGRATION_SPLIT,
 #endif
 #ifdef CONFIG_COMPACTION
 		COMPACTMIGRATE_SCANNED, COMPACTFREE_SCANNED,
--- a/include/trace/events/migrate.h~mm-vmstat-add-events-for-thp-migration-without-split
+++ a/include/trace/events/migrate.h
@@ -46,13 +46,18 @@ MIGRATE_REASON
 TRACE_EVENT(mm_migrate_pages,
 
 	TP_PROTO(unsigned long succeeded, unsigned long failed,
-		 enum migrate_mode mode, int reason),
+		 unsigned long thp_succeeded, unsigned long thp_failed,
+		 unsigned long thp_split, enum migrate_mode mode, int reason),
 
-	TP_ARGS(succeeded, failed, mode, reason),
+	TP_ARGS(succeeded, failed, thp_succeeded, thp_failed,
+		thp_split, mode, reason),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,		succeeded)
 		__field(	unsigned long,		failed)
+		__field(	unsigned long,		thp_succeeded)
+		__field(	unsigned long,		thp_failed)
+		__field(	unsigned long,		thp_split)
 		__field(	enum migrate_mode,	mode)
 		__field(	int,			reason)
 	),
@@ -60,13 +65,19 @@ TRACE_EVENT(mm_migrate_pages,
 	TP_fast_assign(
 		__entry->succeeded	= succeeded;
 		__entry->failed		= failed;
+		__entry->thp_succeeded	= thp_succeeded;
+		__entry->thp_failed	= thp_failed;
+		__entry->thp_split	= thp_split;
 		__entry->mode		= mode;
 		__entry->reason		= reason;
 	),
 
-	TP_printk("nr_succeeded=%lu nr_failed=%lu mode=%s reason=%s",
+	TP_printk("nr_succeeded=%lu nr_failed=%lu nr_thp_succeeded=%lu nr_thp_failed=%lu nr_thp_split=%lu mode=%s reason=%s",
 		__entry->succeeded,
 		__entry->failed,
+		__entry->thp_succeeded,
+		__entry->thp_failed,
+		__entry->thp_split,
 		__print_symbolic(__entry->mode, MIGRATE_MODE),
 		__print_symbolic(__entry->reason, MIGRATE_REASON))
 );
--- a/mm/migrate.c~mm-vmstat-add-events-for-thp-migration-without-split
+++ a/mm/migrate.c
@@ -1418,22 +1418,35 @@ int migrate_pages(struct list_head *from
 		enum migrate_mode mode, int reason)
 {
 	int retry = 1;
+	int thp_retry = 1;
 	int nr_failed = 0;
 	int nr_succeeded = 0;
+	int nr_thp_succeeded = 0;
+	int nr_thp_failed = 0;
+	int nr_thp_split = 0;
 	int pass = 0;
+	bool is_thp = false;
 	struct page *page;
 	struct page *page2;
 	int swapwrite = current->flags & PF_SWAPWRITE;
-	int rc;
+	int rc, nr_subpages;
 
 	if (!swapwrite)
 		current->flags |= PF_SWAPWRITE;
 
-	for(pass = 0; pass < 10 && retry; pass++) {
+	for (pass = 0; pass < 10 && (retry || thp_retry); pass++) {
 		retry = 0;
+		thp_retry = 0;
 
 		list_for_each_entry_safe(page, page2, from, lru) {
 retry:
+			/*
+			 * THP statistics is based on the source huge page.
+			 * Capture required information that might get lost
+			 * during migration.
+			 */
+			is_thp = PageTransHuge(page);
+			nr_subpages = hpage_nr_pages(page);
 			cond_resched();
 
 			if (PageHuge(page))
@@ -1464,15 +1477,30 @@ retry:
 					unlock_page(page);
 					if (!rc) {
 						list_safe_reset_next(page, page2, lru);
+						nr_thp_split++;
 						goto retry;
 					}
 				}
+				if (is_thp) {
+					nr_thp_failed++;
+					nr_failed += nr_subpages;
+					goto out;
+				}
 				nr_failed++;
 				goto out;
 			case -EAGAIN:
+				if (is_thp) {
+					thp_retry++;
+					break;
+				}
 				retry++;
 				break;
 			case MIGRATEPAGE_SUCCESS:
+				if (is_thp) {
+					nr_thp_succeeded++;
+					nr_succeeded += nr_subpages;
+					break;
+				}
 				nr_succeeded++;
 				break;
 			default:
@@ -1482,19 +1510,27 @@ retry:
 				 * removed from migration page list and not
 				 * retried in the next outer loop.
 				 */
+				if (is_thp) {
+					nr_thp_failed++;
+					nr_failed += nr_subpages;
+					break;
+				}
 				nr_failed++;
 				break;
 			}
 		}
 	}
-	nr_failed += retry;
+	nr_failed += retry + thp_retry;
+	nr_thp_failed += thp_retry;
 	rc = nr_failed;
 out:
-	if (nr_succeeded)
-		count_vm_events(PGMIGRATE_SUCCESS, nr_succeeded);
-	if (nr_failed)
-		count_vm_events(PGMIGRATE_FAIL, nr_failed);
-	trace_mm_migrate_pages(nr_succeeded, nr_failed, mode, reason);
+	count_vm_events(PGMIGRATE_SUCCESS, nr_succeeded);
+	count_vm_events(PGMIGRATE_FAIL, nr_failed);
+	count_vm_events(THP_MIGRATION_SUCCESS, nr_thp_succeeded);
+	count_vm_events(THP_MIGRATION_FAIL, nr_thp_failed);
+	count_vm_events(THP_MIGRATION_SPLIT, nr_thp_split);
+	trace_mm_migrate_pages(nr_succeeded, nr_failed, nr_thp_succeeded,
+			       nr_thp_failed, nr_thp_split, mode, reason);
 
 	if (!swapwrite)
 		current->flags &= ~PF_SWAPWRITE;
--- a/mm/vmstat.c~mm-vmstat-add-events-for-thp-migration-without-split
+++ a/mm/vmstat.c
@@ -1277,6 +1277,9 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_MIGRATION
 	"pgmigrate_success",
 	"pgmigrate_fail",
+	"thp_migration_success",
+	"thp_migration_fail",
+	"thp_migration_split",
 #endif
 #ifdef CONFIG_COMPACTION
 	"compact_migrate_scanned",
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


