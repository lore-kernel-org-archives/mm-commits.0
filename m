Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51042C5DF62
	for <mm-commits@archiver.kernel.org>; Wed, 26 Jan 2022 00:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbiAZAeW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 19:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235306AbiAZAeW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 19:34:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E915FC06161C
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 16:34:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91A73614BB
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 00:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D0FC340E0;
        Wed, 26 Jan 2022 00:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643157261;
        bh=6pDoU873kelvr7iunvC0aH4LnxW8ns4ujc1VH80Uk2s=;
        h=Date:From:To:Subject:From;
        b=YdRJUXajZg2ZQ4fS4p9+5Jgp9uPDVTtSGudklPnKMc+eg39OE3+EqEM64SGYshBQh
         clV0lSa/pRbhbI9gSiy0tbospCsheobHE3AHbY6q6SObpD7EE9ibuU7+2FMmJEKCr2
         gps/hDJWTP84bK30qha6vsu1JvJ31MZx9pM8zCHQ=
Date:   Tue, 25 Jan 2022 16:34:20 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, jhubbard@nvidia.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        rostedt@goodmis.org, willy@infradead.org, ziy@nvidia.com
Subject:  + mm-migration-add-trace-events-for-thp-migrations.patch
 added to -mm tree
Message-ID: <20220126003420.rNxzVg09g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migration: add trace events for THP migrations
has been added to the -mm tree.  Its filename is
     mm-migration-add-trace-events-for-thp-migrations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migration-add-trace-events-for-thp-migrations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migration-add-trace-events-for-thp-migrations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/migration: add trace events for THP migrations

Patch series "mm/migration: Add trace events".

This adds trace events for all migration scenarios including base page,
THP and HugeTLB.


This patch (of 2):

This adds two trace events for PMD based THP migration without split. 
These events closely follow the implementation details like setting and
removing of PMD migration entries, which are essential operations for THP
migration.

Link: https://lkml.kernel.org/r/1643080105-11416-1-git-send-email-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/1643080105-11416-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/thp.h |   27 +++++++++++++++++++++++++++
 mm/huge_memory.c           |    5 +++++
 2 files changed, 32 insertions(+)

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
@@ -39,6 +39,9 @@
 #include <asm/pgalloc.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/thp.h>
+
 /*
  * By default, transparent hugepage support is disabled in order to avoid
  * risking an increased memory footprint for applications that are not
@@ -3173,6 +3176,7 @@ void set_pmd_migration_entry(struct page
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
 	page_remove_rmap(page, true);
 	put_page(page);
+	trace_set_migration_pmd(address, pmd_val(pmdswp));
 }
 
 void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
@@ -3206,5 +3210,6 @@ void remove_migration_pmd(struct page_vm
 	if ((vma->vm_flags & VM_LOCKED) && !PageDoubleMap(new))
 		mlock_vma_page(new);
 	update_mmu_cache_pmd(vma, address, pvmw->pmd);
+	trace_remove_migration_pmd(address, pmd_val(pmde));
 }
 #endif
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-generalize-arch_has_filter_pgprot.patch
mm-migration-add-trace-events-for-thp-migrations.patch
mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations.patch
mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations-fix.patch

