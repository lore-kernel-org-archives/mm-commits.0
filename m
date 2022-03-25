Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1414C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbiCYWn5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbiCYWn2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDDC209A6C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D1E0614DE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734F1C004DD;
        Fri, 25 Mar 2022 22:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248112;
        bh=h9lhknYYzD7XK83kNZmGKqsCKGhwN7+weknTR3X4dao=;
        h=Date:To:From:Subject:From;
        b=onctMkZhRK12DcOytE4ZIpOJ66oNvVO5HmoZBK2Hy5QJ+FNUzv3jya/1Aj5dUj6g3
         auQhN+6YLazUMYQ16TIIECZFMQzGAt9dihFPoAHVCsS412JCsxfWb7EkzVsAgxN+1W
         /TCjlWxWYptxqlCL93afRZkXC7rJ56Fp0EmqXqgI=
Date:   Fri, 25 Mar 2022 15:41:51 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        rostedt@goodmis.org, paulus@samba.org, naoya.horiguchi@nec.com,
        mpe@ellerman.id.au, mingo@redhat.com, jhubbard@nvidia.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-migration-add-trace-events-for-thp-migrations.patch removed from -mm tree
Message-Id: <20220325224152.734F1C004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: add trace events for THP migrations
has been removed from the -mm tree.  Its filename was
     mm-migration-add-trace-events-for-thp-migrations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/migration: add trace events for THP migrations

Patch series "mm/migration: Add trace events", v3.

This adds trace events for all migration scenarios including base page,
THP and HugeTLB.


This patch (of 3):

This adds two trace events for PMD based THP migration without split. 
These events closely follow the implementation details like setting and
removing of PMD migration entries, which are essential operations for THP
migration.  This moves CREATE_TRACE_POINTS into generic THP from powerpc
for these new trace events to be available on other platforms as well.

Link: https://lkml.kernel.org/r/1643368182-9588-1-git-send-email-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/1643368182-9588-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/trace.c |    1 -
 include/trace/events/thp.h       |   27 +++++++++++++++++++++++++++
 mm/huge_memory.c                 |    5 +++++
 3 files changed, 32 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/book3s64/trace.c~mm-migration-add-trace-events-for-thp-migrations
+++ a/arch/powerpc/mm/book3s64/trace.c
@@ -3,6 +3,5 @@
  * This file is for defining trace points and trace related helpers.
  */
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define CREATE_TRACE_POINTS
 #include <trace/events/thp.h>
 #endif
--- a/include/trace/events/thp.h~mm-migration-add-trace-events-for-thp-migrations
+++ a/include/trace/events/thp.h
@@ -48,6 +48,33 @@ TRACE_EVENT(hugepage_update,
 	    TP_printk("hugepage update at addr 0x%lx and pte = 0x%lx clr = 0x%lx, set = 0x%lx", __entry->addr, __entry->pte, __entry->clr, __entry->set)
 );
 
+DECLARE_EVENT_CLASS(migration_pmd,
+
+		TP_PROTO(unsigned long addr, unsigned long pmd),
+
+		TP_ARGS(addr, pmd),
+
+		TP_STRUCT__entry(
+			__field(unsigned long, addr)
+			__field(unsigned long, pmd)
+		),
+
+		TP_fast_assign(
+			__entry->addr = addr;
+			__entry->pmd = pmd;
+		),
+		TP_printk("addr=%lx, pmd=%lx", __entry->addr, __entry->pmd)
+);
+
+DEFINE_EVENT(migration_pmd, set_migration_pmd,
+	TP_PROTO(unsigned long addr, unsigned long pmd),
+	TP_ARGS(addr, pmd)
+);
+
+DEFINE_EVENT(migration_pmd, remove_migration_pmd,
+	TP_PROTO(unsigned long addr, unsigned long pmd),
+	TP_ARGS(addr, pmd)
+);
 #endif /* _TRACE_THP_H */
 
 /* This part must be outside protection */
--- a/mm/huge_memory.c~mm-migration-add-trace-events-for-thp-migrations
+++ a/mm/huge_memory.c
@@ -40,6 +40,9 @@
 #include <asm/pgalloc.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/thp.h>
+
 /*
  * By default, transparent hugepage support is disabled in order to avoid
  * risking an increased memory footprint for applications that are not
@@ -3131,6 +3134,7 @@ void set_pmd_migration_entry(struct page
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
 	page_remove_rmap(page, vma, true);
 	put_page(page);
+	trace_set_migration_pmd(address, pmd_val(pmdswp));
 }
 
 void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
@@ -3163,5 +3167,6 @@ void remove_migration_pmd(struct page_vm
 
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache_pmd(vma, address, pvmw->pmd);
+	trace_remove_migration_pmd(address, pmd_val(pmde));
 }
 #endif
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


