Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90990C727C2
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244147AbjHXXWl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244115AbjHXXWK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86F4A8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BEEA63A67
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D50BC433C8;
        Thu, 24 Aug 2023 23:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919327;
        bh=3WOUdPV9GLQzsYe+ZzKvEK8l1wYCG1jP+aQWLE4rh6A=;
        h=Date:To:From:Subject:From;
        b=cnViFFLxQC/KzqfjqMSLCX0sCs46kLpuzjlmXWT6Id03kt9NojE1HshXMvStj1dil
         /HyB9HoZ3cWezxxDPyvezuzckA5M3uMeW8AzZYGJ2t6IeVQFRwsWWzTKmCXuXAorMd
         ndntGZ/P4+FfKW0v1Q9oHNGOppnLz4ufal5d3148=
Date:   Thu, 24 Aug 2023 16:22:07 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, lujialin4@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-removed-duplication-detection-for-mem_cgroup_uncharge_swap.patch removed from -mm tree
Message-Id: <20230824232207.8D50BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: remove duplication detection for mem_cgroup_uncharge_swap
has been removed from the -mm tree.  Its filename was
     memcg-removed-duplication-detection-for-mem_cgroup_uncharge_swap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lu Jialin <lujialin4@huawei.com>
Subject: memcg: remove duplication detection for mem_cgroup_uncharge_swap
Date: Sat, 19 Aug 2023 08:13:02 +0000

__mem_cgroup_uncharge_swap is only called in mem_cgroup_uncharge_swap, if
mem cgroup is disabled, __mem_cgroup_uncharge_swap cannot be called. 
Therefore, there is no need to judge whether mem_cgroup is disabled or
not.

Link: https://lkml.kernel.org/r/20230819081302.1217098-1-lujialin4@huawei.com
Signed-off-by: Lu Jialin <lujialin4@huawei.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memcontrol.c~memcg-removed-duplication-detection-for-mem_cgroup_uncharge_swap
+++ a/mm/memcontrol.c
@@ -7535,9 +7535,6 @@ void __mem_cgroup_uncharge_swap(swp_entr
 	struct mem_cgroup *memcg;
 	unsigned short id;
 
-	if (mem_cgroup_disabled())
-		return;
-
 	id = swap_cgroup_record(entry, 0, nr_pages);
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
_

Patches currently in -mm which might be from lujialin4@huawei.com are


