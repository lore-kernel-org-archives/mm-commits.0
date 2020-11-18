Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA69C5519F
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 05:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B60B24698
	for <mm-commits@archiver.kernel.org>; Wed, 18 Nov 2020 05:50:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zIHh9hIB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgKRFuw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Nov 2020 00:50:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgKRFuw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Nov 2020 00:50:52 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CEC624695;
        Wed, 18 Nov 2020 05:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605678650;
        bh=Lj65MCsYyyL8xGmertAaNoDaQ73sygqyUly/9+//V2w=;
        h=Date:From:To:Subject:From;
        b=zIHh9hIBImlVQ8B0trts0wmuOw5T2gkoY8ikGGa+6TdHdkboO9xjMk52ps46v3IY6
         71z3pMwGZpqZtiQPKWuDmYHlGtE9nnCFtKPsA3ahR/SYf8qYmXgyhsBboArPUYghqc
         z8BQ/5HlwqMmObfrrHWPmePPP2Drgtq9yaopnFqw=
Date:   Tue, 17 Nov 2020 21:50:49 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, corbet@lwn.net,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  +
 =?US-ASCII?Q?mm-vmalloc-add-align-parameter-explanation-for-pvm=5Fdete?=
 =?US-ASCII?Q?rmine=5Fend=5Ffrom=5Freverse.patch?= added to -mm tree
Message-ID: <20201118055049.ipQ3oS_uO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: add 'align' parameter explanation for pvm_determine_end_from_reverse
has been added to the -mm tree.  Its filename is
     mm-vmalloc-add-align-parameter-explanation-for-pvm_determine_end_from_reverse.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-add-align-parameter-explanation-for-pvm_determine_end_from_reverse.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-add-align-parameter-explanation-for-pvm_determine_end_from_reverse.patch

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
@@ -3134,6 +3134,7 @@ pvm_find_va_enclose_addr(unsigned long a
  * @va:
  *   in - the VA we start the search(reverse order);
  *   out - the VA with the highest aligned end address.
+ * @align: alignment for required highest address
  *
  * Returns: determined end address within vmap_area
  */
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

