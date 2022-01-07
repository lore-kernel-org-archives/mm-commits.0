Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C36C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  7 Jan 2022 23:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiAGXki (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Jan 2022 18:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiAGXki (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jan 2022 18:40:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18490C06173E
        for <mm-commits@vger.kernel.org>; Fri,  7 Jan 2022 15:40:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A1BA61E4B
        for <mm-commits@vger.kernel.org>; Fri,  7 Jan 2022 23:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE479C36AED;
        Fri,  7 Jan 2022 23:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1641598836;
        bh=iP8nYlCP24sDBMLzupVznJbFw+4CNOkSCPILOuiWygk=;
        h=Date:From:To:Subject:From;
        b=pyG3zA0gecJItNP5rNIFZKkLXtMWzW5w1RgLKdtS5Z2ruCcvSwnaDvyHpjqcH4aC3
         jbAbzfsUInrDgJ1Dx3sNIrKDwaXvEWe8VKjo9dH+086lmSkz75bZ7v0Q5B7nQMAcHi
         eJZRgsrZ5LHMRtWqUgzC9oLn1k6+ARMUWtm2lN7U=
Date:   Fri, 07 Jan 2022 15:40:35 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, jhubbard@nvidia.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        rostedt@goodmis.org, willy@infradead.org, ziy@nvidia.com
Subject:  + mm-migration-add-trace-events-for-thp-migrations.patch
 added to -mm tree
Message-ID: <20220107234035.hQXyOlUw7%akpm@linux-foundation.org>
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

mm-page_alloc-modify-the-comment-section-for-alloc_contig_pages.patch
mm-migration-add-trace-events-for-thp-migrations.patch
mm-thp-drop-unused-trace-events-hugepage_.patch

