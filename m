Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67D9C2BBCF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8094422EBD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgLOX7L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727884AbgLOXWb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:22:31 -0500
Date:   Tue, 15 Dec 2020 15:20:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074416;
        bh=n0MeDgzPebHUKQj4wMTmBn8LRL8jh7S7lrT1D2xRgdU=;
        h=From:To:Subject:From;
        b=hNshtxIMfW0qj4I6b5FFWPcPTnIwUVyMqcQnApEKV1vBJr0iYs4MpdcXCWFR3eQDS
         g3t3B/vZBn6seDykhhqbNKWgz7FpaBuG7Nywd2gt2+nkv84xkxmPbfxBBcRTpIif1+
         +aePL5IAtTEQYRSeZOvvr2r5rS1uO5O0jkwB7OIQ=
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, corbet@lwn.net,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        rientjes@google.com, yang.shi@linux.alibaba.com, ziy@nvidia.com
Subject:  [merged]
 docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch removed
 from -mm tree
Message-ID: <20201215232015.GvPh4jrZ_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs/vm: remove unused 3 items explanation for /proc/vmstat
has been removed from the -mm tree.  Its filename was
     docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: docs/vm: remove unused 3 items explanation for /proc/vmstat

Commit 5647bc293ab1 ("mm: compaction: Move migration fail/success
stats to migrate.c"), removed 3 items in /proc/vmstat. but the docs
still has their explanation. let's remove them.

"compact_blocks_moved",
"compact_pages_moved",
"compact_pagemigrate_failed",

Link: https://lkml.kernel.org/r/1605520282-51993-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~docs-vm-remove-unused-3-items-explanation-for-proc-vmstat
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -401,21 +401,6 @@ compact_fail
 	is incremented if the system tries to compact memory
 	but failed.
 
-compact_pages_moved
-	is incremented each time a page is moved. If
-	this value is increasing rapidly, it implies that the system
-	is copying a lot of data to satisfy the huge page allocation.
-	It is possible that the cost of copying exceeds any savings
-	from reduced TLB misses.
-
-compact_pagemigrate_failed
-	is incremented when the underlying mechanism
-	for moving a page failed.
-
-compact_blocks_moved
-	is incremented each time memory compaction examines
-	a huge page aligned range of pages.
-
 It is possible to establish how long the stalls were using the function
 tracer to record how long was spent in __alloc_pages_nodemask and
 using the mm_page_alloc tracepoint to identify which allocations were
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-use-head-for-head-page-in-lru_add_page_tail.patch
mm-thp-simplify-lru_add_page_tail.patch
mm-thp-narrow-lru-locking.patch
mm-vmscan-remove-unnecessary-lruvec-adding.patch
mm-rmap-stop-store-reordering-issue-on-page-mapping.patch
mm-memcg-add-debug-checking-in-lock_page_memcg.patch
mm-swapc-fold-vm-event-pgrotated-into-pagevec_move_tail_fn.patch
mm-lru-move-lock-into-lru_note_cost.patch
mm-vmscan-remove-lruvec-reget-in-move_pages_to_lru.patch
mm-mlock-remove-lru_lock-on-testclearpagemlocked.patch
mm-mlock-remove-__munlock_isolate_lru_page.patch
mm-lru-introduce-testclearpagelru.patch
mm-compaction-do-page-isolation-first-in-compaction.patch
mm-swapc-serialize-memcg-changes-in-pagevec_lru_move_fn.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock.patch
mm-vmscan-__isolate_lru_page_prepare-clean-up.patch
fs-nilfs2-remove-some-unused-macros-to-tame-gcc.patch
gcov-fix-kernel-doc-markup-issue.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch

