Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E03FEE49A5
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 18:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbjHUSUq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 14:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbjHUSUp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 14:20:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7C8A1
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 11:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B804861757
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 18:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7B5C433C8;
        Mon, 21 Aug 2023 18:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692642043;
        bh=q8NK6y7XtXUXEN6PF28lN+rqUSQdUZTI+5OZZdllPw8=;
        h=Date:To:From:Subject:From;
        b=P+zS6YihPzisSKyosJV8CR0rNCayy8+djJ5di0r7ehb5Y1BTceeBGFUAb7rSIdqFR
         sGJI/7EZdp4dkxNgDmbwj6NaB+Z8C5HBCo3pQx+Uh38jWxBEUzhd9wpuyoD7EnwCDA
         Xm73YTIs7K9GursHBy08mISlmFq8Md0B/omMQl+s=
Date:   Mon, 21 Aug 2023 11:20:42 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, lujialin4@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-removed-duplication-detection-for-mem_cgroup_uncharge_swap.patch added to mm-unstable branch
Message-Id: <20230821182043.0B7B5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove duplication detection for mem_cgroup_uncharge_swap
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-removed-duplication-detection-for-mem_cgroup_uncharge_swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-removed-duplication-detection-for-mem_cgroup_uncharge_swap.patch

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

memcg-removed-duplication-detection-for-mem_cgroup_uncharge_swap.patch

