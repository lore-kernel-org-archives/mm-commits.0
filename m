Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECB1C56202
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 05:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D3E224698
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 05:50:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fejpdjh2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgKRFus (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Nov 2020 00:50:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgKRFus (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Nov 2020 00:50:48 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 017602468F;
        Wed, 18 Nov 2020 05:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605678646;
        bh=6pFmzvlivulcdFVZARiz4JW6Otzo8610EP+H1Ajkp74=;
        h=Date:From:To:Subject:From;
        b=fejpdjh26czWDOWsaDNJ7SEqpkAWyelj60WSfKLJ/CqyEISG5TgwQjT7cG5ZZgkNE
         dMCBRT7DdEcAuLj1kMwdrDFubK38O7AmTZ2V8ynj3BL/z3Hwett7nRWQJT4Nmun81j
         a+ET+dMaKuPmdXOtTRPrqPgdhXcRH16Q2nkl8kcQ=
Date:   Tue, 17 Nov 2020 21:50:45 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, corbet@lwn.net,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  +
 mm-mapping_dirty_helpers-enhance-the-kernel-doc-markups.patch added to -mm
 tree
Message-ID: <20201118055045.1DLaKPmO5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mapping_dirty_helpers: enhance the kernel-doc markups
has been added to the -mm tree.  Its filename is
     mm-mapping_dirty_helpers-enhance-the-kernel-doc-markups.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mapping_dirty_helpers-enhance-the-kernel-doc-markups.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mapping_dirty_helpers-enhance-the-kernel-doc-markups.patch

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

mm-filemap-add-static-for-function-__add_to_page_cache_locked.patch
fs-ntfs-remove-unused-varibles.patch
fs-ntfs-remove-unused-varible-attr_len.patch
mm-truncate-add-parameter-explanation-for-invalidate_mapping_pagevec.patch
mm-mapping_dirty_helpers-enhance-the-kernel-doc-markups.patch
mm-vmalloc-add-align-parameter-explanation-for-pvm_determine_end_from_reverse.patch
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
docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch

