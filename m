Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B419C46CA1
	for <mm-commits@archiver.kernel.org>; Mon, 18 Sep 2023 19:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjIRT1W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 15:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjIRT1T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 15:27:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FA1F7
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 12:27:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB58C433C7;
        Mon, 18 Sep 2023 19:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695065233;
        bh=D+8Wk08hSLy2iLFx3qm/g4FzbTeIBdgW22JuZQeFpyY=;
        h=Date:To:From:Subject:From;
        b=XcbhaFds+P2G43flzkii/VGfgVhjBbWxTlMCKV+cg3gG5Oba97mQu7Om2UvGxKvRv
         3sIBN+MxOmqrgVHI0vq29uR05lHmAxcsZ0UAxBaDzgD4Pmg9LfVC9G1y1DbZGgksXT
         uR9Z40dwkTNOgGoLq93seRB+x5jz208gpeVG1cSk=
Date:   Mon, 18 Sep 2023 12:27:12 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        wangkefeng.wang@huawei.com, tj@kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-unused-do_memsw_account-in-memcg1_stat_format.patch added to mm-unstable branch
Message-Id: <20230918192713.9CB58C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove unused do_memsw_account in memcg1_stat_format
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-remove-unused-do_memsw_account-in-memcg1_stat_format.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-unused-do_memsw_account-in-memcg1_stat_format.patch

This patch will later appear in the mm-unstable branch at
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
From: Liu Shixin <liushixin2@huawei.com>
Subject: memcg: remove unused do_memsw_account in memcg1_stat_format
Date: Fri, 15 Sep 2023 18:58:45 +0800

Since commit b25806dcd3d5("mm: memcontrol: deprecate swapaccounting=0
mode") do_memsw_account() is synonymous with
!cgroup_subsys_on_dfl(memory_cgrp_subsys), It always equals true in
memcg1_stat_format().  Remove the unused code.

Link: https://lkml.kernel.org/r/20230915105845.3199656-3-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Suggested-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Tejun heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~memcg-remove-unused-do_memsw_account-in-memcg1_stat_format
+++ a/mm/memcontrol.c
@@ -4106,8 +4106,6 @@ static void memcg1_stat_format(struct me
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
 
-		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
-			continue;
 		nr = memcg_page_state_local(memcg, memcg1_stats[i]);
 		seq_buf_printf(s, "%s %lu\n", memcg1_stat_names[i],
 			   nr * memcg_page_state_unit(memcg1_stats[i]));
@@ -4130,15 +4128,12 @@ static void memcg1_stat_format(struct me
 	}
 	seq_buf_printf(s, "hierarchical_memory_limit %llu\n",
 		       (u64)memory * PAGE_SIZE);
-	if (do_memsw_account())
-		seq_buf_printf(s, "hierarchical_memsw_limit %llu\n",
-			       (u64)memsw * PAGE_SIZE);
+	seq_buf_printf(s, "hierarchical_memsw_limit %llu\n",
+		       (u64)memsw * PAGE_SIZE);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
 
-		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
-			continue;
 		nr = memcg_page_state(memcg, memcg1_stats[i]);
 		seq_buf_printf(s, "total_%s %llu\n", memcg1_stat_names[i],
 			   (u64)nr * memcg_page_state_unit(memcg1_stats[i]));
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space.patch
mm-vmscan-try-to-reclaim-swapcache-pages-if-no-swap-space-v6.patch
memcg-expose-swapcache-stat-for-memcg-v1.patch
memcg-remove-unused-do_memsw_account-in-memcg1_stat_format.patch

