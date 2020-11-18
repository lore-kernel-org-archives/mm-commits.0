Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62782C5519F
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 05:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04CBE24695
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 05:50:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fi+6VcP3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgKRFuo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Nov 2020 00:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgKRFuo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Nov 2020 00:50:44 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 322B324655;
        Wed, 18 Nov 2020 05:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605678643;
        bh=VBhjMPS6WlntxcxhnQXVZPp4PX3BmsFOzlNmqor30NM=;
        h=Date:From:To:Subject:From;
        b=Fi+6VcP35xMWCd4laU3RbW/pxVjrl+B8fO1736VW8ngToh7AkDZ/sBUOkOcR+2Jb0
         V4fUAP1+MvA1+QH5W8R+UCHhik/Et3Q9HwmZb4go7P0Ddo93+7xc42iNcYZpJRwBSV
         p02agBFYInsNZXEuoXPZxyUTdNCzOkaempDz/W9I=
Date:   Tue, 17 Nov 2020 21:50:41 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, corbet@lwn.net,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  +
 mm-truncate-add-parameter-explanation-for-invalidate_mapping_pagevec.patch
 added to -mm tree
Message-ID: <20201118055041.UNwtcfI7-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/truncate: add parameter explanation for invalidate_mapping_pagevec
has been added to the -mm tree.  Its filename is
     mm-truncate-add-parameter-explanation-for-invalidate_mapping_pagevec.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-truncate-add-parameter-explanation-for-invalidate_mapping_pagevec.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-truncate-add-parameter-explanation-for-invalidate_mapping_pagevec.patch

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
Subject: mm/truncate: add parameter explanation for invalidate_mapping_pagevec

To fix a kernel-doc markups issue:
mm/truncate.c:646: warning: Function parameter or member 'mapping' not
described in 'invalidate_mapping_pagevec'
mm/truncate.c:646: warning: Function parameter or member 'start' not
described in 'invalidate_mapping_pagevec'
mm/truncate.c:646: warning: Function parameter or member 'end' not
described in 'invalidate_mapping_pagevec'
mm/truncate.c:646: warning: Function parameter or member 'nr_pagevec'
not described in 'invalidate_mapping_pagevec'

Link: https://lkml.kernel.org/r/1605605088-30668-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/truncate.c~mm-truncate-add-parameter-explanation-for-invalidate_mapping_pagevec
+++ a/mm/truncate.c
@@ -637,9 +637,15 @@ unsigned long invalidate_mapping_pages(s
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
 /**
- * This helper is similar with the above one, except that it accounts for pages
- * that are likely on a pagevec and count them in @nr_pagevec, which will used by
- * the caller.
+ * invalidate_mapping_pagevec - Invalidate all the unlocked pages of one inode
+ * @mapping: the address_space which holds the pages to invalidate
+ * @start: the offset 'from' which to invalidate
+ * @end: the offset 'to' which to invalidate (inclusive)
+ * @nr_pagevec: invalidate failed page number for caller
+ *
+ * This helper is similar with invalidate_mapping_pages, except that it accounts
+ * for pages that failed to invalidate on a pagevec and count them in
+ * @nr_pagevec, which will used by the caller.
  */
 void invalidate_mapping_pagevec(struct address_space *mapping,
 		pgoff_t start, pgoff_t end, unsigned long *nr_pagevec)
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

