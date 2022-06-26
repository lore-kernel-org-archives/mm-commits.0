Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6A0C43334
	for <mm-commits@archiver.kernel.org>; Sun, 26 Jun 2022 20:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiFZUgt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Jun 2022 16:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiFZUgs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Jun 2022 16:36:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C75111F
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 13:36:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08E60B80DF6
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 20:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F39C34114;
        Sun, 26 Jun 2022 20:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656275804;
        bh=mKzmH2pxbq0Um5Bh6wUAWChfeE0/ev1Xb50gm9BbFig=;
        h=Date:To:From:Subject:From;
        b=2FAak5Ny9TNLWgttDQdFEtqXv9XGF8fUVjDtzWzGyKlhYSl4ePqKqzF+EcRDfOzk/
         Y6mDoNGvS/d0xPMBH9XQRClrxvClhQ6Cg/nVplXNtQaomcL8rno/keuWRKPpJrF4Kt
         qAFVTE7BtjnxAlwjdUtSAyU3jwGB4eij/mFfyS78=
Date:   Sun, 26 Jun 2022 13:36:44 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, xiangyang3@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrolc-replace-cgroup_memory_nokmem-with-mem_cgroup_kmem_disabled.patch added to mm-unstable branch
Message-Id: <20220626203644.A3F39C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: replace cgroup_memory_nokmem with mem_cgroup_kmem_disabled()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrolc-replace-cgroup_memory_nokmem-with-mem_cgroup_kmem_disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrolc-replace-cgroup_memory_nokmem-with-mem_cgroup_kmem_disabled.patch

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrolc-replace-cgroup_memory_nokmem-with-mem_cgroup_kmem_disabled
+++ a/mm/memcontrol.c
@@ -3783,7 +3783,7 @@ static u64 mem_cgroup_read_u64(struct cg
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
-	if (cgroup_memory_nokmem)
+	if (mem_cgroup_kmem_disabled())
 		return 0;
 
 	if (unlikely(mem_cgroup_is_root(memcg)))
@@ -3798,7 +3798,7 @@ static int memcg_online_kmem(struct mem_
 
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
-	if (cgroup_memory_nokmem)
+	if (mem_cgroup_kmem_disabled())
 		return;
 
 	if (unlikely(mem_cgroup_is_root(memcg)))
_

Patches currently in -mm which might be from xiangyang3@huawei.com are

mm-memcontrolc-replace-cgroup_memory_nokmem-with-mem_cgroup_kmem_disabled.patch

