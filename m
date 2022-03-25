Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D423C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbiCYWn5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233924AbiCYWn4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4461920A394
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0F05B82A1E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAEDC340F0;
        Fri, 25 Mar 2022 22:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248113;
        bh=wdd3y4We0IF4QLWbKglRSB36ch+RFYWJanW7ifW1+38=;
        h=Date:To:From:Subject:From;
        b=l69IMUVsNZYnlq2CZ90ZbWqdlXzRS3xYfcmmgJl+B8AEALklFGXiWT6ibH49E6sqE
         RIZ3WTSw877sA+zQ3M81L0JURiHLsQfKujS0y05kQhG+3dX+132lDTURqQ9CoToxNl
         oxP0Xhc6+i3M73DgUDKzO1cwdSr5CrApdso6G0Rs=
Date:   Fri, 25 Mar 2022 15:41:52 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        rostedt@goodmis.org, naoya.horiguchi@nec.com, mingo@redhat.com,
        lkp@intel.com, jhubbard@nvidia.com, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations.patch removed from -mm tree
Message-Id: <20220325224153.8AAEDC340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: add trace events for base page and HugeTLB migrations
has been removed from the -mm tree.  Its filename was
     mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/migration: add trace events for base page and HugeTLB migrations

This adds two trace events for base page and HugeTLB page migrations. 
These events, closely follow the implementation details like setting and
removing of PTE migration entries, which are essential operations for
migration.  The new CREATE_TRACE_POINTS in <mm/rmap.c> covers both
<events/migration.h> and <events/tlb.h> based trace events.  Hence drop
redundant CREATE_TRACE_POINTS from other places which could have otherwise
conflicted during build.

Link: https://lkml.kernel.org/r/1643368182-9588-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c             |    1 -
 include/trace/events/migrate.h |   31 +++++++++++++++++++++++++++++++
 mm/migrate.c                   |    4 +++-
 mm/rmap.c                      |    6 ++++++
 4 files changed, 40 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/init.c~mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations
+++ a/arch/x86/mm/init.c
@@ -31,7 +31,6 @@
  * We need to define the tracepoints somewhere, and tlb.c
  * is only compiled when SMP=y.
  */
-#define CREATE_TRACE_POINTS
 #include <trace/events/tlb.h>
 
 #include "mm_internal.h"
--- a/include/trace/events/migrate.h~mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations
+++ a/include/trace/events/migrate.h
@@ -105,6 +105,37 @@ TRACE_EVENT(mm_migrate_pages_start,
 		  __print_symbolic(__entry->reason, MIGRATE_REASON))
 );
 
+DECLARE_EVENT_CLASS(migration_pte,
+
+		TP_PROTO(unsigned long addr, unsigned long pte, int order),
+
+		TP_ARGS(addr, pte, order),
+
+		TP_STRUCT__entry(
+			__field(unsigned long, addr)
+			__field(unsigned long, pte)
+			__field(int, order)
+		),
+
+		TP_fast_assign(
+			__entry->addr = addr;
+			__entry->pte = pte;
+			__entry->order = order;
+		),
+
+		TP_printk("addr=%lx, pte=%lx order=%d", __entry->addr, __entry->pte, __entry->order)
+);
+
+DEFINE_EVENT(migration_pte, set_migration_pte,
+	TP_PROTO(unsigned long addr, unsigned long pte, int order),
+	TP_ARGS(addr, pte, order)
+);
+
+DEFINE_EVENT(migration_pte, remove_migration_pte,
+	TP_PROTO(unsigned long addr, unsigned long pte, int order),
+	TP_ARGS(addr, pte, order)
+);
+
 #endif /* _TRACE_MIGRATE_H */
 
 /* This part must be outside protection */
--- a/mm/migrate.c~mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations
+++ a/mm/migrate.c
@@ -53,7 +53,6 @@
 
 #include <asm/tlbflush.h>
 
-#define CREATE_TRACE_POINTS
 #include <trace/events/migrate.h>
 
 #include "internal.h"
@@ -249,6 +248,9 @@ static bool remove_migration_pte(struct
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_page_drain(smp_processor_id());
 
+		trace_remove_migration_pte(pvmw.address, pte_val(pte),
+					   compound_order(new));
+
 		/* No need to invalidate - it was non-present before */
 		update_mmu_cache(vma, pvmw.address, pvmw.pte);
 	}
--- a/mm/rmap.c~mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations
+++ a/mm/rmap.c
@@ -76,7 +76,9 @@
 
 #include <asm/tlbflush.h>
 
+#define CREATE_TRACE_POINTS
 #include <trace/events/tlb.h>
+#include <trace/events/migrate.h>
 
 #include "internal.h"
 
@@ -1849,6 +1851,8 @@ static bool try_to_migrate_one(struct fo
 			if (pte_swp_uffd_wp(pteval))
 				swp_pte = pte_swp_mkuffd_wp(swp_pte);
 			set_pte_at(mm, pvmw.address, pvmw.pte, swp_pte);
+			trace_set_migration_pte(pvmw.address, pte_val(swp_pte),
+						compound_order(&folio->page));
 			/*
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
@@ -1917,6 +1921,8 @@ static bool try_to_migrate_one(struct fo
 			if (pte_uffd_wp(pteval))
 				swp_pte = pte_swp_mkuffd_wp(swp_pte);
 			set_pte_at(mm, address, pvmw.pte, swp_pte);
+			trace_set_migration_pte(address, pte_val(swp_pte),
+						compound_order(&folio->page));
 			/*
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


