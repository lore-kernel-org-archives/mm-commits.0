Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C929C4363D
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 093DA20888
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 21:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601502967;
	bh=M07D8S+zdMn3CMW9xZv+pl/TWiSsZiFiBIyl76mTYxU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=wCRGl+lheXmyr2S8vRD7ZdIDnr/HbPe12qzC+OYqxM6g0pZm6PWRmLZ/xIQcxuVD2
	 9Z3jlxKkBTj9dkeJN0G2bu/YTZwTrgVoaIkTm/DM/LRBkgjqeexK9IDrZk2uLYrwnk
	 LOCBRVU8yL/XF0AbNCJnVp5iR+eftGjIQi97YMb8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730873AbgI3V4G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 17:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730817AbgI3V4G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 17:56:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96D362064E;
        Wed, 30 Sep 2020 21:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601502965;
        bh=M07D8S+zdMn3CMW9xZv+pl/TWiSsZiFiBIyl76mTYxU=;
        h=Date:From:To:Subject:From;
        b=fspMmeWrLUFI/KdwPbsMv3/9p1JlumV05GtoV3YHuMN/gmnbuoKb/zJic9IyemAvO
         lafAHuLHgxGovoogxFI+tmbXTgonnILuaFOWaqghf8yNMzd3sFDE8rMS0IkVcEB38V
         bOUf/XgD6I1trT2eZfMzok/MYIz0uUvrks/pGsrs=
Date:   Wed, 30 Sep 2020 14:56:05 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, linmiaohe@huawei.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  +
 mm-memcontrol-reword-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch
 added to -mm tree
Message-ID: <20200930215605.DNH_ycLdp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: reword obsolete comment of mem_cgroup_unmark_under_oom()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-reword-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-reword-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-reword-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memcontrol: reword obsolete comment of mem_cgroup_unmark_under_oom()

Since commit 79dfdaccd1d5 ("memcg: make oom_lock 0 and 1 based rather than
counter"), the mem_cgroup_unmark_under_oom() is added and the comment of
the mem_cgroup_oom_unlock() is moved here.  But this comment make no sense
here because mem_cgroup_oom_lock() does not operate on under_oom field. 
So we reword the comment as this would be helpful.  [Thanks Michal Hocko
for rewording this comment.]

Link: https://lkml.kernel.org/r/20200930095336.21323-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-reword-obsolete-comment-of-mem_cgroup_unmark_under_oom
+++ a/mm/memcontrol.c
@@ -1826,8 +1826,8 @@ static void mem_cgroup_unmark_under_oom(
 	struct mem_cgroup *iter;
 
 	/*
-	 * When a new child is created while the hierarchy is under oom,
-	 * mem_cgroup_oom_lock() may not be called. Watch for underflow.
+	 * Be careful about under_oom underflows becase a child memcg
+	 * could have been added after mem_cgroup_mark_under_oom.
 	 */
 	spin_lock(&memcg_oom_lock);
 	for_each_mem_cgroup_tree(iter, memcg)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache.patch
mm-remove-useless-out-label-in-__swap_writepage.patch
mm-fix-incomplete-comment-in-lru_cache_add_inactive_or_unevictable.patch
mm-remove-unnecessary-goto-out-in-_swap_info_get.patch
mm-fix-potential-memory-leak-in-sys_swapon.patch
mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch
mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge.patch
mm-memcontrol-reword-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch
mm-use-helper-function-mapping_allow_writable.patch
mm-mmap-use-helper-function-allow_write_access-in-__remove_shared_vm_struct.patch
mm-mempool-add-else-to-split-mutually-exclusive-case.patch
mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

