Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF46C3526F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A486D22D2B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgLOX64 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:58:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:59056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729147AbgLOXT6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:19:58 -0500
Date:   Tue, 15 Dec 2020 15:19:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074357;
        bh=exoxrmdCLwFeIS6i7cA1Msb0WnxnyBU3BogGlZvG+M8=;
        h=From:To:Subject:From;
        b=DMVeHWSx8TnUtkIBmkigzvila7rD+z1c4cOp2Qa9dqlYk/vOOZKibGGqHZZKSgGEq
         YOEt6zG+r39pmqMlxW6k5R2nN4mJRerATChR8IKdg9nqEtONqqsnaa3KSzjrVHBmWY
         ebvAMyEWIvn/PvxVWZM0bHCeEyQvGG134NkUIekw=
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, corbet@lwn.net,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged]
 mm-mapping_dirty_helpers-enhance-the-kernel-doc-markups.patch removed from
 -mm tree
Message-ID: <20201215231917.DjAxfnQ1D%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mapping_dirty_helpers: enhance the kernel-doc markups
has been removed from the -mm tree.  Its filename was
     mm-mapping_dirty_helpers-enhance-the-kernel-doc-markups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/mapping_dirty_helpers: enhance the kernel-doc markups

Add and change parameter explanation for wp_pte and clean_record_pte, to
avoid W1 warning:
mm/mapping_dirty_helpers.c:34: warning: Function parameter or member
'end' not described in 'wp_pte'
mm/mapping_dirty_helpers.c:88: warning: Function parameter or member
'end' not described in 'clean_record_pte'

Link: https://lkml.kernel.org/r/1605605088-30668-2-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mapping_dirty_helpers.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/mapping_dirty_helpers.c~mm-mapping_dirty_helpers-enhance-the-kernel-doc-markups
+++ a/mm/mapping_dirty_helpers.c
@@ -23,7 +23,8 @@ struct wp_walk {
 /**
  * wp_pte - Write-protect a pte
  * @pte: Pointer to the pte
- * @addr: The virtual page address
+ * @addr: The start of protecting virtual address
+ * @end: The end of protecting virtual address
  * @walk: pagetable walk callback argument
  *
  * The function write-protects a pte and records the range in
@@ -74,7 +75,8 @@ struct clean_walk {
  * clean_record_pte - Clean a pte and record its address space offset in a
  * bitmap
  * @pte: Pointer to the pte
- * @addr: The virtual page address
+ * @addr: The start of virtual address to be clean
+ * @end: The end of virtual address to be clean
  * @walk: pagetable walk callback argument
  *
  * The function cleans a pte and records the range in
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

