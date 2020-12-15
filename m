Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3BFC47437
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50C6C22D74
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgLOX7e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:59816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729224AbgLOXZG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:06 -0500
Date:   Tue, 15 Dec 2020 15:22:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074553;
        bh=YQduArP4MISI96PC4TRlfuod1nahH9VoM2GkacMaS/U=;
        h=From:To:Subject:From;
        b=OyivzGQHkrV3AqGUOJPr4kzKKq3pOPZgKVsVhXsy7uVsofilhejBZijZKHqZm49p5
         xNjvUA2ACoCm70dR4UI0kOSLpoNQmM8pQLt0vR8IZs0bKtsTsa6BgEwgAjf3XzCTKC
         HuLK4uPBxXD9gVQrGt/ruJHk7ax200Fs9EjZgHDA=
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, corbet@lwn.net,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged]
 khugepaged-add-couples-parameter-explanation-for-kernel-doc-markup.patch
 removed from -mm tree
Message-ID: <20201215232233.iUzpf7vFT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: add parameter explanations for kernel-doc markup
has been removed from the -mm tree.  Its filename was
     khugepaged-add-couples-parameter-explanation-for-kernel-doc-markup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: khugepaged: add parameter explanations for kernel-doc markup

Add missed parameter explanation for some kernel-doc warnings:
mm/khugepaged.c:102: warning: Function parameter or member
'nr_pte_mapped_thp' not described in 'mm_slot'
mm/khugepaged.c:102: warning: Function parameter or member
'pte_mapped_thp' not described in 'mm_slot'
mm/khugepaged.c:1424: warning: Function parameter or member 'mm' not
described in 'collapse_pte_mapped_thp'
mm/khugepaged.c:1424: warning: Function parameter or member 'addr' not
described in 'collapse_pte_mapped_thp'
mm/khugepaged.c:1626: warning: Function parameter or member 'mm' not
described in 'collapse_file'
mm/khugepaged.c:1626: warning: Function parameter or member 'file' not
described in 'collapse_file'
mm/khugepaged.c:1626: warning: Function parameter or member 'start' not
described in 'collapse_file'
mm/khugepaged.c:1626: warning: Function parameter or member 'hpage' not
described in 'collapse_file'
mm/khugepaged.c:1626: warning: Function parameter or member 'node' not
described in 'collapse_file'

Link: https://lkml.kernel.org/r/1605597325-25284-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~khugepaged-add-couples-parameter-explanation-for-kernel-doc-markup
+++ a/mm/khugepaged.c
@@ -90,6 +90,8 @@ static struct kmem_cache *mm_slot_cache
  * @hash: hash collision list
  * @mm_node: khugepaged scan list headed in khugepaged_scan.mm_head
  * @mm: the mm that this information is valid for
+ * @nr_pte_mapped_thp: number of pte mapped THP
+ * @pte_mapped_thp: address array corresponding pte mapped THP
  */
 struct mm_slot {
 	struct hlist_node hash;
@@ -1414,7 +1416,11 @@ static int khugepaged_add_pte_mapped_thp
 }
 
 /**
- * Try to collapse a pte-mapped THP for mm at address haddr.
+ * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
+ * address haddr.
+ *
+ * @mm: process address space where collapse happens
+ * @addr: THP collapse address
  *
  * This function checks whether all the PTEs in the PMD are pointing to the
  * right THP. If so, retract the page table so the THP can refault in with
@@ -1605,6 +1611,12 @@ static void retract_page_tables(struct a
 /**
  * collapse_file - collapse filemap/tmpfs/shmem pages into huge one.
  *
+ * @mm: process address space where collapse happens
+ * @file: file that collapse on
+ * @start: collapse start address
+ * @hpage: new allocated huge page for collapse
+ * @node: appointed node the new huge page allocate from
+ *
  * Basic scheme is simple, details are more complex:
  *  - allocate and lock a new huge page;
  *  - scan page cache replacing old pages with the new one
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

