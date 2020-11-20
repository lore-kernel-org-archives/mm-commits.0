Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20939C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 22:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F7EC22464
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 22:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VB9Q0LQx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgKTW3a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 17:29:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728282AbgKTW3a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 17:29:30 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B32A2245F;
        Fri, 20 Nov 2020 22:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605911369;
        bh=8dNOP5U3SNEMDFIo91jLuXzIwMkIXD2EjigzCDn+cW8=;
        h=Date:From:To:Subject:From;
        b=VB9Q0LQxfqtC4VWr+wOdvWi1xIpawpi9lqvR93hzgbut2i+LZNTdZROdvYY5bP29C
         Kn8oveMNkh+VTxiuZyg5GJWOQ0pvSTxOExfdOLFx6FZbx3Hf5aPGvZ6RBVUqudcJYz
         2DNCIKn5uQ4SMuxag7lxkbxYE2NP9vbq/gqiCGik=
Date:   Fri, 20 Nov 2020 14:29:28 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, alexander.h.duyck@linux.intel.com,
        guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, sh_def@163.com, shakeelb@google.com
Subject:  + mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch
 added to -mm tree
Message-ID: <20201120222928.LUs3YgRPs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: add missed warning in mem_cgroup_lruvec
has been added to the -mm tree.  Its filename is
     mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch

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
Subject: mm/memcg: add missed warning in mem_cgroup_lruvec

commit "(mm/memcontrol:rewrite mem_cgroup_page_lruvec())" on mm tree use
mem_cgroup_lruvec to rewrite mem_cgroup_page_lruvec, but it missed a
DEBUG_VM warning as following, since we always charge a page before
return from allocation. Add back this warning is helpful:

	VM_WARN_ON_ONCE(!memcg);

Link: https://lkml.kernel.org/r/94f17bb7-ec61-5b72-3555-fabeb5a4d73b@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Hui Su <sh_def@163.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/memcontrol.h~mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix
+++ a/include/linux/memcontrol.h
@@ -618,6 +618,7 @@ static inline struct lruvec *mem_cgroup_
 		goto out;
 	}
 
+	VM_WARN_ON_ONCE(!memcg);
 	if (!memcg)
 		memcg = root_mem_cgroup;
 
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
mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch

