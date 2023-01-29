Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95AF9C05027
	for <mm-commits@archiver.kernel.org>; Sun, 29 Jan 2023 21:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbjA2Vtm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 29 Jan 2023 16:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjA2Vtm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 29 Jan 2023 16:49:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71767193DE
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 13:49:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C01960E0B
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 21:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D03C433EF;
        Sun, 29 Jan 2023 21:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675028980;
        bh=6IUUlE0fmtirQhZxPCqbLGa7eHWi10z9YGAy6Bj/E78=;
        h=Date:To:From:Subject:From;
        b=nIj5Q3ZwWSn1Iq7Doe++W5faUJ5kooAKTdO71afWVvSRbAUEzw66fBsVOtvYx1JPK
         8s/365AQ+ZDgKoPEwCK4ZJosdgVHxwLr7DQIeaiNy6E8FbZhvTmoR99A6MhmW/eu9P
         +DXYBLEnNz6eGAlnuhwvBTEa25kJVPYGibhGulJU=
Date:   Sun, 29 Jan 2023 13:49:39 -0800
To:     mm-commits@vger.kernel.org, tj@kernel.org, shakeelb@google.com,
        naoya.horiguchi@nec.com, mhocko@suse.com, mawupeng1@huawei.com,
        jack@suse.cz, axboe@kernel.dk, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-fix-null-pointer-in-mem_cgroup_track_foreign_dirty_slowpath.patch added to mm-hotfixes-unstable branch
Message-Id: <20230129214940.54D03C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: fix NULL pointer in mem_cgroup_track_foreign_dirty_slowpath()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcg-fix-null-pointer-in-mem_cgroup_track_foreign_dirty_slowpath.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-fix-null-pointer-in-mem_cgroup_track_foreign_dirty_slowpath.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memcg: fix NULL pointer in mem_cgroup_track_foreign_dirty_slowpath()
Date: Sun, 29 Jan 2023 12:09:45 +0800

As commit 18365225f044 ("hwpoison, memcg: forcibly uncharge LRU pages"),
hwpoison will forcibly uncharg a LRU hwpoisoned page, the folio_memcg
could be NULl, then, mem_cgroup_track_foreign_dirty_slowpath() could
occurs a NULL pointer dereference, let's do not record the foreign
writebacks for folio memcg is null in mem_cgroup_track_foreign_dirty() to
fix it.

Link: https://lkml.kernel.org/r/20230129040945.180629-1-wangkefeng.wang@huawei.com
Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reported-by: Ma Wupeng <mawupeng1@huawei.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/memcontrol.h~mm-memcg-fix-null-pointer-in-mem_cgroup_track_foreign_dirty_slowpath
+++ a/include/linux/memcontrol.h
@@ -1666,10 +1666,13 @@ void mem_cgroup_track_foreign_dirty_slow
 static inline void mem_cgroup_track_foreign_dirty(struct folio *folio,
 						  struct bdi_writeback *wb)
 {
+	struct mem_cgroup *memcg;
+
 	if (mem_cgroup_disabled())
 		return;
 
-	if (unlikely(&folio_memcg(folio)->css != wb->memcg_css))
+	memcg = folio_memcg(folio);
+	if (unlikely(memcg && &memcg->css != wb->memcg_css))
 		mem_cgroup_track_foreign_dirty_slowpath(folio, wb);
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-memcg-fix-null-pointer-in-mem_cgroup_track_foreign_dirty_slowpath.patch
mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch

