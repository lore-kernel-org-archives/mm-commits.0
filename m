Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF681C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 04:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbiA0EHu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jan 2022 23:07:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38564 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiA0EHt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jan 2022 23:07:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90982617AE
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 04:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF0CC340E4;
        Thu, 27 Jan 2022 04:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643256469;
        bh=UHHJdikuo+gxCt8G4/ssU+ky7QFGpRO3+VDJILRcUkU=;
        h=Date:From:To:Subject:From;
        b=ZY9Zw/0w0CR46FYLy5ptUIBdYiXUSxwvJNxE1oXevRzW1EXQMFvOkGq6PZ0hLK8WW
         wr2wy+ujuHn6ypBP2JOOq2V4qwOPgofgrE+TIFlHGZLosf7JYPqB5xBPqyYcESbCIm
         fG4ffBsUz2P5Fxca5+13KHyNPffEy4sGMaRzY7+8=
Date:   Wed, 26 Jan 2022 20:07:48 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, jhubbard@nvidia.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        rostedt@goodmis.org, willy@infradead.org, ziy@nvidia.com
Subject:  [failures]
 mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations.patch
 removed from -mm tree
Message-ID: <20220127040748.NKSvqyUMJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: add trace events for base page and HugeTLB migrations
has been removed from the -mm tree.  Its filename was
     mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/migration: add trace events for base page and HugeTLB migrations

This adds two trace events for base page and HugeTLB page migrations. 
These events, closely follow the implementation details like setting and
removing of PTE migration entries, which are essential operations for
migration.

Link: https://lkml.kernel.org/r/1643080105-11416-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/migrate.h |   31 +++++++++++++++++++++++++++++++
 mm/migrate.c                   |    3 +++
 mm/rmap.c                      |    5 +++++
 3 files changed, 39 insertions(+)

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
@@ -257,6 +257,9 @@ static bool remove_migration_pte(struct
 		if (PageTransHuge(page) && PageMlocked(page))
 			clear_page_mlock(page);
 
+		trace_remove_migration_pte(pvmw.address, pte_val(pte),
+					   compound_order(new));
+
 		/* No need to invalidate - it was non-present before */
 		update_mmu_cache(vma, pvmw.address, pvmw.pte);
 	}
--- a/mm/rmap.c~mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations
+++ a/mm/rmap.c
@@ -77,6 +77,7 @@
 #include <asm/tlbflush.h>
 
 #include <trace/events/tlb.h>
+#include <trace/events/migrate.h>
 
 #include "internal.h"
 
@@ -1861,6 +1862,8 @@ static bool try_to_migrate_one(struct pa
 			if (pte_swp_uffd_wp(pteval))
 				swp_pte = pte_swp_mkuffd_wp(swp_pte);
 			set_pte_at(mm, pvmw.address, pvmw.pte, swp_pte);
+			trace_set_migration_pte(pvmw.address, pte_val(swp_pte),
+						compound_order(page));
 			/*
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
@@ -1929,6 +1932,8 @@ static bool try_to_migrate_one(struct pa
 			if (pte_uffd_wp(pteval))
 				swp_pte = pte_swp_mkuffd_wp(swp_pte);
 			set_pte_at(mm, address, pvmw.pte, swp_pte);
+			trace_set_migration_pte(address, pte_val(swp_pte),
+						compound_order(page));
 			/*
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-generalize-arch_has_filter_pgprot.patch
mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations-fix.patch

