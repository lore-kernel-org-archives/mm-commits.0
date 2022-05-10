Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E10C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbiEJEPW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbiEJEOo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0361A827
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08FF861737
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58754C385C2;
        Tue, 10 May 2022 04:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155847;
        bh=M32dkEkeu8j35kHFbdFDUKmWANmDNc7/+XyfB0Np7C0=;
        h=Date:To:From:Subject:From;
        b=QBpDXa0VrQIupnCRquofpPdg+8qvvL+fL8VUKyb9jiTV0D0C3KZmrnFYleVw0/4Rc
         CUcFtM/3JG78IRJgLYuwoLzt+vO16txOWRk+YGtx3jFDdZXXrntqYiRry8/jCUD13x
         Jp+pLfdLl5u2GtwsFdZ8CtPbhU0ONsNGMlWsUTOg=
Date:   Mon, 09 May 2022 21:10:46 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, lujialin4@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrolc-make-cgroup_memory_noswap-static.patch removed from -mm tree
Message-Id: <20220510041047.58754C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcontrol.c: make cgroup_memory_noswap static
has been removed from the -mm tree.  Its filename was
     mm-memcontrolc-make-cgroup_memory_noswap-static.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Lu Jialin <lujialin4@huawei.com>
Subject: mm/memcontrol.c: make cgroup_memory_noswap static

cgroup_memory_noswap is only used in mm/memcontrol.c, therefore just make
it static, and remove export in include/linux/memcontrol.h

Link: https://lkml.kernel.org/r/20220421124736.62180-1-lujialin4@huawei.com
Signed-off-by: Lu Jialin <lujialin4@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ----
 mm/memcontrol.c            |    2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrolc-make-cgroup_memory_noswap-static
+++ a/include/linux/memcontrol.h
@@ -937,10 +937,6 @@ struct mem_cgroup *mem_cgroup_get_oom_gr
 					    struct mem_cgroup *oom_domain);
 void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 
-#ifdef CONFIG_MEMCG_SWAP
-extern bool cgroup_memory_noswap;
-#endif
-
 void folio_memcg_lock(struct folio *folio);
 void folio_memcg_unlock(struct folio *folio);
 void lock_page_memcg(struct page *page);
--- a/mm/memcontrol.c~mm-memcontrolc-make-cgroup_memory_noswap-static
+++ a/mm/memcontrol.c
@@ -89,7 +89,7 @@ static bool cgroup_memory_nokmem __ro_af
 
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
-bool cgroup_memory_noswap __ro_after_init;
+static bool cgroup_memory_noswap __ro_after_init;
 #else
 #define cgroup_memory_noswap		1
 #endif
_

Patches currently in -mm which might be from lujialin4@huawei.com are


