Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA52C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 20 Jul 2022 16:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiGTQnI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Jul 2022 12:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiGTQnH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jul 2022 12:43:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BC361D63
        for <mm-commits@vger.kernel.org>; Wed, 20 Jul 2022 09:43:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ADD9B820CC
        for <mm-commits@vger.kernel.org>; Wed, 20 Jul 2022 16:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8960C3411E;
        Wed, 20 Jul 2022 16:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658335383;
        bh=mUsPlctKfIOGAJpMY0aUDiBWbuUg1SNxuN+eNe1JY4w=;
        h=Date:To:From:Subject:From;
        b=uzHgNYyKJF/uZb7uahoq0UV/JNQh3KTuqSCiwkdgb2ygsLXwuq/racfVl3THS1wpV
         YxsePhXl+8XVLYFKja/KbOQc+JON8JXFRP0TYTMfJ84k9rmcsjQpEWfEVfi0bnQK8d
         C0uJ+N5/LlTkOF5aS2UHIxJ+JGlcM6fL449IzfOE=
Date:   Wed, 20 Jul 2022 09:43:03 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tsbogend@alpha.franken.de, songliubraving@fb.com,
        sj@kernel.org, shy828301@gmail.com, rongwei.wang@linux.alibaba.com,
        rientjes@google.com, peterx@redhat.com, pasha.tatashin@soleen.com,
        minchan@kernel.org, mhocko@suse.com, mattst88@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, James.Bottomley@HansenPartnership.com,
        ink@jurassic.park.msu.ru, hughd@google.com, deller@gmx.de,
        david@redhat.com, ckennelly@google.com, chris@zankel.net,
        axelrasmussen@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        arnd@arndb.de, alex.shi@linux.alibaba.com, aarcange@redhat.com,
        zokeefe@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-madvise-add-huge_memory-mm_madvise_collapse-tracepoint.patch removed from -mm tree
Message-Id: <20220720164303.A8960C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/madvise: add huge_memory:mm_madvise_collapse tracepoint
has been removed from the -mm tree.  Its filename was
     mm-madvise-add-huge_memory-mm_madvise_collapse-tracepoint.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/madvise: add huge_memory:mm_madvise_collapse tracepoint
Date: Wed, 6 Jul 2022 16:59:29 -0700

Add a tracepoint to expose mm, address, and enum scan_result of each
hugepage attempted to be collapsed by call to madvise(MADV_COLLAPSE).

Link: https://lkml.kernel.org/r/20220706235936.2197195-12-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |   22 ++++++++++++++++++++++
 mm/khugepaged.c                    |    2 ++
 2 files changed, 24 insertions(+)

--- a/include/trace/events/huge_memory.h~mm-madvise-add-huge_memory-mm_madvise_collapse-tracepoint
+++ a/include/trace/events/huge_memory.h
@@ -167,5 +167,27 @@ TRACE_EVENT(mm_collapse_huge_page_swapin
 		__entry->ret)
 );
 
+TRACE_EVENT(mm_madvise_collapse,
+
+	TP_PROTO(struct mm_struct *mm, unsigned long addr, int result),
+
+	TP_ARGS(mm, addr, result),
+
+	TP_STRUCT__entry(__field(struct mm_struct *, mm)
+			 __field(unsigned long, addr)
+			 __field(int, result)
+	),
+
+	TP_fast_assign(__entry->mm = mm;
+		       __entry->addr = addr;
+		       __entry->result = result;
+	),
+
+	TP_printk("mm=%p addr=%#lx result=%s",
+		  __entry->mm,
+		  __entry->addr,
+		  __print_symbolic(__entry->result, SCAN_STATUS))
+);
+
 #endif /* __HUGE_MEMORY_H */
 #include <trace/define_trace.h>
--- a/mm/khugepaged.c~mm-madvise-add-huge_memory-mm_madvise_collapse-tracepoint
+++ a/mm/khugepaged.c
@@ -2438,6 +2438,8 @@ int madvise_collapse(struct vm_area_stru
 		if (!mmap_locked)
 			*prev = NULL;  /* Tell caller we dropped mmap_lock */
 
+		trace_mm_madvise_collapse(mm, addr, result);
+
 		switch (result) {
 		case SCAN_SUCCEED:
 		case SCAN_PMD_MAPPED:
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-remove-redundant-transhuge_vma_suitable-check.patch
mm-khugepaged-add-struct-collapse_control.patch
mm-khugepaged-add-struct-collapse_control-fix.patch
mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch
mm-khugepaged-pipe-enum-scan_result-codes-back-to-callers.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch
mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior-fix.patch
mm-khugepaged-record-scan_pmd_mapped-when-scan_pmd-finds-hugepage.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-2.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-3.patch
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch

