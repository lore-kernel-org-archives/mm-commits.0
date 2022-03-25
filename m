Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B52C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244616AbiCYBdj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357360AbiCYBcW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:32:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EF0BD7C3
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFE4FB8272E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FCCC340ED;
        Fri, 25 Mar 2022 01:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171842;
        bh=9GoZWEcEHOk1Vm2oUpncFPXvlT6BWEz/6t8f8Xon8Gk=;
        h=Date:To:From:Subject:From;
        b=Wqm4vh72LmhqtxB1j7T86gSGjXx+49TwPazAvJwX/CmG6COxHlvUgSXvY/NuD2wtU
         L5AmKj1fNdNgQ8Pxz3R3+dzYBv3j1fhXtSnQCFxQSMed8ojJkjaPlZln1UW3Cyb/j1
         r7gMMvkRoEtsSWgFgpXl5+D1cET59kuNnrM891lk=
Date:   Thu, 24 Mar 2022 18:30:41 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, vdavydov.dev@gmail.com, vbabka@suse.cz,
        tytso@mit.edu, trond.myklebust@hammerspace.com,
        shy828301@gmail.com, shakeelb@google.com, roman.gushchin@linux.dev,
        richard.weiyang@gmail.com, mhocko@kernel.org,
        kari.argillander@gmail.com, jaegeuk@kernel.org, hannes@cmpxchg.org,
        fam.zheng@bytedance.com, duanxiongchun@bytedance.com,
        david@fromorbit.com, chao@kernel.org, Anna.Schumaker@Netapp.com,
        alexs@kernel.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memcontrol-fix-cannot-alloc-the-maximum-memcg-id.patch removed from -mm tree
Message-Id: <20220325013042.85FCCC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix cannot alloc the maximum memcg ID
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-cannot-alloc-the-maximum-memcg-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix cannot alloc the maximum memcg ID

The idr_alloc() does not include @max ID.  So in the current
implementation, the maximum memcg ID is 65534 instead of 65535.  It seems
a bug.  So fix this.

Link: https://lkml.kernel.org/r/20220228122126.37293-15-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kari Argillander <kari.argillander@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-cannot-alloc-the-maximum-memcg-id
+++ a/mm/memcontrol.c
@@ -5088,8 +5088,7 @@ static struct mem_cgroup *mem_cgroup_all
 		return ERR_PTR(error);
 
 	memcg->id.id = idr_alloc(&mem_cgroup_idr, NULL,
-				 1, MEM_CGROUP_ID_MAX,
-				 GFP_KERNEL);
+				 1, MEM_CGROUP_ID_MAX + 1, GFP_KERNEL);
 	if (memcg->id.id < 0) {
 		error = memcg->id.id;
 		goto fail;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


