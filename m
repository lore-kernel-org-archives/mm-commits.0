Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839F0C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jan 2022 20:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiAMU6X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jan 2022 15:58:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42026 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiAMU6X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jan 2022 15:58:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96CFAB8239E
        for <mm-commits@vger.kernel.org>; Thu, 13 Jan 2022 20:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B835C36AE3;
        Thu, 13 Jan 2022 20:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642107501;
        bh=DkcW2oupavI45vc983L0s7VUOdYZDEKbOKsB5mc0p8s=;
        h=Date:From:To:Subject:From;
        b=VciXtU4XuDfniSuZ80Mzi/nDKlgG2vITUsLmWm7o9oMcXf8Cz/Wk0INO7i/ydZJPc
         gjij4/f6L2FRcYcPuDRj6jHN6wPyTUJpB3RamzcS7CZZ25WJXbTgOZ5ZVLOe9bs9Zi
         0cwAAOLl0y8bhE8dLlNPk10mqrJVIfue141sNnNQ=
Date:   Thu, 13 Jan 2022 12:58:20 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, jhubbard@nvidia.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        rostedt@goodmis.org, willy@infradead.org, ziy@nvidia.com
Subject:  [to-be-updated]
 mm-migration-add-trace-events-for-thp-migrations.patch removed from -mm
 tree
Message-ID: <20220113205820.IA9FNtvs0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: add trace events for THP migrations
has been removed from the -mm tree.  Its filename was
     mm-migration-add-trace-events-for-thp-migrations.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/migration: add trace events for THP migrations

This adds two trace events for PMD based THP migration without split. 
These events closely follow the implementation details like setting and
removing of PMD migration entries, which are essential operations for THP
migration.

Link: https://lkml.kernel.org/r/1641531575-28524-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/thp.h |   37 +++++++++++++++++++++++++++++++++++
 mm/huge_memory.c           |    5 ++++
 2 files changed, 42 insertions(+)

--- a/include/trace/events/thp.h~mm-migration-add-trace-events-for-thp-migrations
+++ a/include/trace/events/thp.h
@@ -83,6 +83,43 @@ TRACE_EVENT(hugepage_splitting,
 		      __entry->addr, __entry->pte)
 );
 
+TRACE_EVENT(set_migration_pmd,
+
+	TP_PROTO(unsigned long addr, unsigned long pmd),
+
+	TP_ARGS(addr, pmd),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, addr)
+		__field(unsigned long, pmd)
+	),
+
+	TP_fast_assign(
+		__entry->addr = addr;
+		__entry->pmd = pmd;
+	),
+
+	TP_printk("create pmd migration entry addr=%lx, pmd=%lx", __entry->addr, __entry->pmd)
+);
+
+TRACE_EVENT(remove_migration_pmd,
+
+	TP_PROTO(unsigned long addr, unsigned long pmd),
+
+	TP_ARGS(addr, pmd),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, addr)
+		__field(unsigned long, pmd)
+	),
+
+	TP_fast_assign(
+		__entry->addr = addr;
+		__entry->pmd = pmd;
+	),
+
+	TP_printk("remove pmd migration entry addr=%lx, val=%lx", __entry->addr, __entry->pmd)
+);
 #endif /* _TRACE_THP_H */
 
 /* This part must be outside protection */
--- a/mm/huge_memory.c~mm-migration-add-trace-events-for-thp-migrations
+++ a/mm/huge_memory.c
@@ -39,6 +39,9 @@
 #include <asm/pgalloc.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/thp.h>
+
 /*
  * By default, transparent hugepage support is disabled in order to avoid
  * risking an increased memory footprint for applications that are not
@@ -3163,6 +3166,7 @@ void set_pmd_migration_entry(struct page
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
 	page_remove_rmap(page, true);
 	put_page(page);
+	trace_set_migration_pmd(address, pmd_val(pmdswp));
 }
 
 void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
@@ -3196,5 +3200,6 @@ void remove_migration_pmd(struct page_vm
 	if ((vma->vm_flags & VM_LOCKED) && !PageDoubleMap(new))
 		mlock_vma_page(new);
 	update_mmu_cache_pmd(vma, address, pvmw->pmd);
+	trace_remove_migration_pmd(address, pmd_val(pmde));
 }
 #endif
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-update-comments-regarding-migration-swap-entries.patch
mm-page_alloc-modify-the-comment-section-for-alloc_contig_pages.patch
mm-thp-drop-unused-trace-events-hugepage_.patch

