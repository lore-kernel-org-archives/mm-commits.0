Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A0FC2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8F4E223B0
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:49:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QqMov+te"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgKTXtW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:49:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbgKTXtW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 18:49:22 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAF65208CA;
        Fri, 20 Nov 2020 23:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605916160;
        bh=op0jlaeXIrCgV7UdlHjzRRADj2cs6E8beL/CtOB2p80=;
        h=Date:From:To:Subject:From;
        b=QqMov+teRiEq3MxRf1uH4OffFz0DPulq+4PT4gy799FPzvUrpw3i/18rNTODjaD7Z
         KUoD6OkquMYLIlqWR82NvuWV3/NYHdETnGs8UEc7ht/MFatmCTQ9jS/V+evyvq6f8N
         2C2wOz5TL0PIb7bnJABw6O1jGH8m+iMosjblrqvg=
Date:   Fri, 20 Nov 2020 15:49:19 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, mm-commits@vger.kernel.org,
        oberpar@linux.ibm.com
Subject:  + gcov-fix-kernel-doc-markup-issue.patch added to -mm
 tree
Message-ID: <20201120234919.UOJYdjMc2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: fix kernel-doc markup issue
has been added to the -mm tree.  Its filename is
     gcov-fix-kernel-doc-markup-issue.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/gcov-fix-kernel-doc-markup-issue.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/gcov-fix-kernel-doc-markup-issue.patch

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
Subject: gcov: fix kernel-doc markup issue

Fix the following kernel-doc issue in gcov:
kernel/gcov/gcc_4_7.c:238: warning: Function parameter or member 'dst'
not described in 'gcov_info_add'
kernel/gcov/gcc_4_7.c:238: warning: Function parameter or member 'src'
not described in 'gcov_info_add'
kernel/gcov/gcc_4_7.c:238: warning: Excess function parameter 'dest'
description in 'gcov_info_add'
kernel/gcov/gcc_4_7.c:238: warning: Excess function parameter 'source'
description in 'gcov_info_add'

Link: https://lkml.kernel.org/r/1605252352-63983-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/gcov/gcc_4_7.c~gcov-fix-kernel-doc-markup-issue
+++ a/kernel/gcov/gcc_4_7.c
@@ -227,10 +227,10 @@ int gcov_info_is_compatible(struct gcov_
 
 /**
  * gcov_info_add - add up profiling data
- * @dest: profiling data set to which data is added
- * @source: profiling data set which is added
+ * @dst: profiling data set to which data is added
+ * @src: profiling data set which is added
  *
- * Adds profiling counts of @source to @dest.
+ * Adds profiling counts of @src to @dst.
  */
 void gcov_info_add(struct gcov_info *dst, struct gcov_info *src)
 {
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
gcov-fix-kernel-doc-markup-issue.patch
mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch

