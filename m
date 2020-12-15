Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788FBC2BBCF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46A6322D05
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgLOX65 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:58:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729198AbgLOXUA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:20:00 -0500
Date:   Tue, 15 Dec 2020 15:19:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074359;
        bh=AkmPFtpJGCYpLQGvsMlbYkKShJhTQ/E9X/Z+jbJ01/k=;
        h=From:To:Subject:From;
        b=ojBcNFNCh2gKv8mllFCYduORcZljFBHivsd7u+3gZ5G0VdnETWuCysOY9JHU+4kvJ
         ataTfNr85TZHZNJwa2W8Os1seP+RhvMHBoSjs09mtNcaGxuspvjEgFRO8ejOf4C30W
         YOdpwAbkr3HK1+OV7pnPcmh3F3tWf9UVjpEESj1E=
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, corbet@lwn.net,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged]
 mm-add-colon-to-fix-kernel-doc-markups-error-for-check_pte.patch removed
 from -mm tree
Message-ID: <20201215231919.HFhFp4_fd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_vma_mapped.c: add colon to fix kernel-doc markups error for check_pte
has been removed from the -mm tree.  Its filename was
     mm-add-colon-to-fix-kernel-doc-markups-error-for-check_pte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/page_vma_mapped.c: add colon to fix kernel-doc markups error for check_pte

check_pte() needs a correct colon for kernel-doc markup, otherwise, gcc
has the following warning for W=1, mm/page_vma_mapped.c:86: warning:
Function parameter or member 'pvmw' not described in 'check_pte'

Link: https://lkml.kernel.org/r/1605597167-25145-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/page_vma_mapped.c~mm-add-colon-to-fix-kernel-doc-markups-error-for-check_pte
+++ a/mm/page_vma_mapped.c
@@ -66,18 +66,19 @@ static inline bool pfn_is_match(struct p
 
 /**
  * check_pte - check if @pvmw->page is mapped at the @pvmw->pte
+ * @pvmw: page_vma_mapped_walk struct, includes a pair pte and page for checking
  *
  * page_vma_mapped_walk() found a place where @pvmw->page is *potentially*
  * mapped. check_pte() has to validate this.
  *
- * @pvmw->pte may point to empty PTE, swap PTE or PTE pointing to arbitrary
- * page.
+ * pvmw->pte may point to empty PTE, swap PTE or PTE pointing to
+ * arbitrary page.
  *
  * If PVMW_MIGRATION flag is set, returns true if @pvmw->pte contains migration
  * entry that points to @pvmw->page or any subpage in case of THP.
  *
- * If PVMW_MIGRATION flag is not set, returns true if @pvmw->pte points to
- * @pvmw->page or any subpage in case of THP.
+ * If PVMW_MIGRATION flag is not set, returns true if pvmw->pte points to
+ * pvmw->page or any subpage in case of THP.
  *
  * Otherwise, return false.
  *
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

