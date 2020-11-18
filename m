Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B93B1C5519F
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 05:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43CF02469D
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 05:56:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ewB36c43"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgKRF4E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Nov 2020 00:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:40384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbgKRF4D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Nov 2020 00:56:03 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 658CE24695;
        Wed, 18 Nov 2020 05:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605678962;
        bh=BbrgLHRmELm3AI/xtV2jFUd+sXNI+ufCtOkqLTV1u80=;
        h=Date:From:To:Subject:From;
        b=ewB36c43Xet/BkBuHJd+LYfsqagGluy2+mcupIrA+gwGJ/wVXY/YkyaUfWbPvA44d
         bGr1ZDox3LeyoRGUNadwVAcQX/ynT4+lHVs6dMmU9NZ/AJZOQMKiFUiO594qNEvcT7
         Ldm1PuEzansn8h6gJDw4fexXh4NOwvzmT0nhFajQ=
Date:   Tue, 17 Nov 2020 21:56:01 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, corbet@lwn.net,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  +
 mm-add-colon-to-fix-kernel-doc-markups-error-for-check_pte.patch added to
 -mm tree
Message-ID: <20201118055601.yz1Q8LDjM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_vma_mapped.c: add colon to fix kernel-doc markups error for check_pte
has been added to the -mm tree.  Its filename is
     mm-add-colon-to-fix-kernel-doc-markups-error-for-check_pte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-colon-to-fix-kernel-doc-markups-error-for-check_pte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-colon-to-fix-kernel-doc-markups-error-for-check_pte.patch

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
mm-add-colon-to-fix-kernel-doc-markups-error-for-check_pte.patch
mm-vmalloc-add-align-parameter-explanation-for-pvm_determine_end_from_reverse.patch
docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch
khugepaged-add-couples-parameter-explanation-for-kernel-doc-markup.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch

