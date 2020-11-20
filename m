Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73FF7C8300F
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 22:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21CD32245F
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 22:21:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PlxlRQqV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgKTWVo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 17:21:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728174AbgKTWVo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 17:21:44 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E43842240C;
        Fri, 20 Nov 2020 22:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605910903;
        bh=X9ZNgVo9fs8z/MrjQJ/cGCRcKcR3hdl65XcbBnntMSA=;
        h=Date:From:To:Subject:From;
        b=PlxlRQqVI2ggJgOjia2pnH1/lOer8gJqCAjnHiAa08Wamv5hDBw3mbS1M86yvOyLL
         JzA6KtZKjTOtQwzeWFiJAFwqbsIjkXyI5ejUOnKY9tsga/oFkH4QiI+3vWMNjl/Ib2
         fy3xHxYY87DZs4YuUmjImQNdtRHxL1PIbLrT7Eq8=
Date:   Fri, 20 Nov 2020 14:21:42 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  + mm-memcg-remove-incorrect-comments.patch added to -mm
 tree
Message-ID: <20201120222142.SU6Nowv67%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: remove incorrect comment
has been added to the -mm tree.  Its filename is
     mm-memcg-remove-incorrect-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-remove-incorrect-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-remove-incorrect-comments.patch

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
Subject: mm/memcg: remove incorrect comment

Swapcache readahead pages are charged before being used, so it is unlikely
that they will be migrated before charging.  Remove the incorrect comment.

Link: https://lkml.kernel.org/r/1605864930-49405-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-remove-incorrect-comments
+++ a/mm/memcontrol.c
@@ -6981,7 +6981,6 @@ void mem_cgroup_migrate(struct page *old
 	if (newpage->mem_cgroup)
 		return;
 
-	/* Swapcache readahead pages can get replaced before being charged */
 	memcg = oldpage->mem_cgroup;
 	if (!memcg)
 		return;
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
mm-memcg-remove-incorrect-comments.patch
mm-mapping_dirty_helpers-enhance-the-kernel-doc-markups.patch
mm-add-colon-to-fix-kernel-doc-markups-error-for-check_pte.patch
mm-vmalloc-add-align-parameter-explanation-for-pvm_determine_end_from_reverse.patch
docs-vm-remove-unused-3-items-explanation-for-proc-vmstat.patch
khugepaged-add-couples-parameter-explanation-for-kernel-doc-markup.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch

