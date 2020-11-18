Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED604C5519F
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 05:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8701124698
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 05:54:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s2O0axy/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgKRFyg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Nov 2020 00:54:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgKRFyg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Nov 2020 00:54:36 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 059EF2468F;
        Wed, 18 Nov 2020 05:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605678875;
        bh=BgPq5mjMtUPFDShJGQax0mJTrg2Ors+CwQk3DgMSFDI=;
        h=Date:From:To:Subject:From;
        b=s2O0axy/YBcAaQXxm0f1RUEwZ6dacUhHa6x5e93C6qKIzEWCWExslNLuBr9JIHgnZ
         maz9zi45mu5UpyBc6viwF084a6elokmy+7jZe9cEbfN2wwnbQ+c9q4fm1KFjjNfIYS
         LCVD1qc9rIxAvZ/I32AnveaY82N05VxuuuAg9ILI=
Date:   Tue, 17 Nov 2020 21:54:34 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, corbet@lwn.net,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  +
 khugepaged-add-couples-parameter-explanation-for-kernel-doc-markup.patch
 added to -mm tree
Message-ID: <20201118055434.WzwREc-KU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: add parameter explanations for kernel-doc markup
has been added to the -mm tree.  Its filename is
     khugepaged-add-couples-parameter-explanation-for-kernel-doc-markup.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/khugepaged-add-couples-parameter-explanation-for-kernel-doc-markup.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-add-couples-parameter-explanation-for-kernel-doc-markup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
fs-ntfs-remove-unused-varibles.patch
fs-ntfs-remove-unused-varible-attr_len.patch
mm-truncate-add-parameter-explanation-for-invalidate_mapping_pagevec.patch
mm-memcg-update-page-struct-member-in-comments.patch
mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-use-head-for-head-page-in-lru_add_page_tail.patch
mm-thp-simplify-lru_add_page_tail.patch
mm-thp-narrow-lru-locking.patch
mm-vmscan-remove-unnecessary-lruvec-adding.patch
mm-rmap-stop-store-reordering-issue-on-page-mapping.patch
mm-rmap-stop-store-reordering-issue-on-page-mapping-fix.patch
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
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix.patch
mm-lru-replace-pgdat-lru_lock-with-lruvec-lock-fix-2.patch
mm-lru-introduce-the-relock_page_lruvec-function-fix.patch
mm-mapping_dirty_helpers-enhance-the-kernel-doc-markups.patch
mm-vmalloc-add-align-parameter-explanation-for-pvm_determine_end_from_reverse.patch
docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch
khugepaged-add-couples-parameter-explanation-for-kernel-doc-markup.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch

