Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9243C43463
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 03:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8850021D42
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 03:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600486538;
	bh=w+KgAQgCFtIp3Vl6A4fiiRKLvsAXp9Z8NAYspbUc/k4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yu+At+43gmrtaG7fhmMshVREgJ80/eCGpEDiHZycUJrB7rQgp1JIPAV5gDZ6lz7L8
	 ddiU0YY0vqFAaHOpENXWWD9R/PVVNsqF3+kGk8dzIHorDjM6LZdHpjsOaEdEp340vb
	 ix6y7Joztp5vD6yNdk31ixnKOapZVDsPM3sFXE8Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgISDfi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 23:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbgISDfi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 23:35:38 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BFB020723;
        Sat, 19 Sep 2020 03:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600486537;
        bh=w+KgAQgCFtIp3Vl6A4fiiRKLvsAXp9Z8NAYspbUc/k4=;
        h=Date:From:To:Subject:From;
        b=i/4Z5mvOAgTr3/fCvMD3ub/XzG+3oGx6vgnq5tlPsykS07LOYUFOqoPCpqZz4gk2D
         lsmMPo0HbTzVfWADZv8XrPwtQD1KhTyBPFZXE09pY4ccrs0zzL/Miryl3pdc1Ae+hb
         Y9IsHON6baNR/5XpJrO+wnGhHtGwaIhQ/OsENIeI=
Date:   Fri, 18 Sep 2020 20:35:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        mhocko@kernel.org, hannes@cmpxchg.org, linmiaohe@huawei.com
Subject:  +
 mm-memcontrol-remove-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch
 added to -mm tree
Message-ID: <20200919033536.VXTE5%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove obsolete comment of mem_cgroup_unmark_under_oom()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-remove-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-remove-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-remove-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch

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
Subject: mm: memcontrol: remove obsolete comment of mem_cgroup_unmark_under_oom()

Since commit 79dfdaccd1d5 ("memcg: make oom_lock 0 and 1 based rather than
counter"), the mem_cgroup_unmark_under_oom() is added and the comment of
the mem_cgroup_oom_unlock() is moved here.  But this comment make no sense
here because mem_cgroup_oom_lock() does not operate on under_oom field.

Link: https://lkml.kernel.org/r/20200917105900.4337-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-remove-obsolete-comment-of-mem_cgroup_unmark_under_oom
+++ a/mm/memcontrol.c
@@ -1825,10 +1825,6 @@ static void mem_cgroup_unmark_under_oom(
 {
 	struct mem_cgroup *iter;
 
-	/*
-	 * When a new child is created while the hierarchy is under oom,
-	 * mem_cgroup_oom_lock() may not be called. Watch for underflow.
-	 */
 	spin_lock(&memcg_oom_lock);
 	for_each_mem_cgroup_tree(iter, memcg)
 		if (iter->under_oom > 0)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch
mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge.patch
mm-memcontrol-remove-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch
mm-use-helper-function-mapping_allow_writable.patch
mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

