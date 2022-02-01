Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7B3C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 01:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbiBAB6y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 20:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbiBAB6x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 20:58:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899E7C061714
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 17:58:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5449DB82BD1
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 01:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AAFC340E8;
        Tue,  1 Feb 2022 01:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643680731;
        bh=vnRWabfAWE/JJBpzAAhk9X7y3MH7ck4dZEQa32Eh/s0=;
        h=Date:To:From:Subject:From;
        b=iY0GCtV90zYhl8RbzicYcRHRoqzA02236A8KlGxmBO9hFahiYZozGDIAFgsTNeGDj
         29jBgNTeP+mDUedG4kTgMlej9WEvwhtjdzANmklY7/8o52Bzd8oCOjBAELVz8dBXtV
         A808FNxU3sEsi6S2x3Xn3L9y8/1dsGMjosWgnwDk=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 17:58:49 -0800
Date:   Mon, 31 Jan 2022 17:58:49 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        rostedt@goodmis.org, paulus@samba.org, n-horiguchi@ah.jp.nec.com,
        mpe@ellerman.id.au, mingo@redhat.com, jhubbard@nvidia.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migration-add-trace-events-for-thp-migrations.patch added to -mm tree
Message-Id: <20220201015849.C7AAFC340E8@smtp.kernel.org>
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
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
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
@@ -39,6 +39,9 @@
 #include <asm/pgalloc.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/thp.h>
+
 /*
  * By default, transparent hugepage support is disabled in order to avoid
  * risking an increased memory footprint for applications that are not
@@ -3100,6 +3103,7 @@ void set_pmd_migration_entry(struct page
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
 	page_remove_rmap(page, true);
 	put_page(page);
+	trace_set_migration_pmd(address, pmd_val(pmdswp));
 }
 
 void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
@@ -3134,5 +3138,6 @@ void remove_migration_pmd(struct page_vm
 
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache_pmd(vma, address, pvmw->pmd);
+	trace_remove_migration_pmd(address, pmd_val(pmde));
 }
 #endif
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-generalize-arch_has_filter_pgprot.patch
mm-migration-add-trace-events-for-thp-migrations.patch
mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations.patch

