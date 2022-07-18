Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C044DC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbiGRASw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbiGRARn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6540F13D5B
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 018B960F16
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DB8C3411E;
        Mon, 18 Jul 2022 00:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103442;
        bh=MVkv9l31HbB0gDiRAcDvTK5aKz44W0rJ21BdWeOtXd4=;
        h=Date:To:From:Subject:From;
        b=YW9H6L+tnMJJgUYCZynWoBKWFFofFMJZujqr/gCOcIsgg5m7AhHJohbmnc6OR5bgs
         9j1z7/b5SgQxe9qWbbgcy3TEyPI0Eq5+kCQPSe9Fospr40PrO80zg/Mp/RoBnzYCYq
         CGvx4E/iPfviDnG3PPChUiwwhBDZgsuwPT9S1Q+E=
Date:   Sun, 17 Jul 2022 17:17:21 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@kernel.org,
        jrdr.linux@gmail.com, hannes@cmpxchg.org, xiangyang3@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrolc-replace-cgroup_memory_nokmem-with-mem_cgroup_kmem_disabled.patch removed from -mm tree
Message-Id: <20220718001722.58DB8C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcontrol.c: replace cgroup_memory_nokmem with mem_cgroup_kmem_disabled()
has been removed from the -mm tree.  Its filename was
     mm-memcontrolc-replace-cgroup_memory_nokmem-with-mem_cgroup_kmem_disabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiang Yang <xiangyang3@huawei.com>
Subject: mm/memcontrol.c: replace cgroup_memory_nokmem with mem_cgroup_kmem_disabled()
Date: Sat, 25 Jun 2022 14:18:44 +0800

mem_cgroup_kmem_disabled() checks whether the kmem accounting is off. 
Therefore, replace cgroup_memory_nokmem with mem_cgroup_kmem_disabled(),
which is the same work in percpu.c and slab_common.c.

Link: https://lkml.kernel.org/r/20220625061844.226764-1-xiangyang3@huawei.com
Signed-off-by: Xiang Yang <xiangyang3@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrolc-replace-cgroup_memory_nokmem-with-mem_cgroup_kmem_disabled
+++ a/mm/memcontrol.c
@@ -3653,7 +3653,7 @@ static int memcg_online_kmem(struct mem_
 {
 	struct obj_cgroup *objcg;
 
-	if (cgroup_memory_nokmem)
+	if (mem_cgroup_kmem_disabled())
 		return 0;
 
 	if (unlikely(mem_cgroup_is_root(memcg)))
@@ -3677,7 +3677,7 @@ static void memcg_offline_kmem(struct me
 {
 	struct mem_cgroup *parent;
 
-	if (cgroup_memory_nokmem)
+	if (mem_cgroup_kmem_disabled())
 		return;
 
 	if (unlikely(mem_cgroup_is_root(memcg)))
_

Patches currently in -mm which might be from xiangyang3@huawei.com are


