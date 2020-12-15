Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AEA9C47434
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2943022D2B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgLOX7D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbgLOXWF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:22:05 -0500
Date:   Tue, 15 Dec 2020 15:20:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074408;
        bh=vq2R3/+WVn5IwV5yMUgvpSu76qW5ydivRL1sTcsjJ5w=;
        h=From:To:Subject:From;
        b=Ax80ZyAjQi1zWqwmzoy/AsqX6tTN9tznuXk3q1hWyZyVDFuiFbU/eivyRT+1L+Etw
         MmtPqaLPGpy5Ejr2TJ6/9QezBj7encK4ZvAA/++vn1gRZs1a8ahxD+zUbMLxU5iKj1
         rTBpVNBVwQKmX4vKR7XtBLrB6iuWs7cNWog9xBYc=
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, corbet@lwn.net,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged]
 =?US-ASCII?Q?mm-vmalloc-add-align-parameter-explanation-for-pvm=5Fdete?=
 =?US-ASCII?Q?rmine=5Fend=5Ffrom=5Freverse.patch?= removed from -mm tree
Message-ID: <20201215232008.nucaIxZEb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: add 'align' parameter explanation for pvm_determine_end_from_reverse
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-add-align-parameter-explanation-for-pvm_determine_end_from_reverse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/vmalloc: add 'align' parameter explanation for pvm_determine_end_from_reverse

Kernel-doc markup has a issue on pvm_determine_end_from_reverse:
mm/vmalloc.c:3145: warning: Function parameter or member 'align' not
described in 'pvm_determine_end_from_reverse'
Add a explanation for it to remove the warning.

Link: https://lkml.kernel.org/r/1605605088-30668-3-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-vmalloc-add-align-parameter-explanation-for-pvm_determine_end_from_reverse
+++ a/mm/vmalloc.c
@@ -3151,6 +3151,7 @@ pvm_find_va_enclose_addr(unsigned long a
  * @va:
  *   in - the VA we start the search(reverse order);
  *   out - the VA with the highest aligned end address.
+ * @align: alignment for required highest address
  *
  * Returns: determined end address within vmap_area
  */
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

