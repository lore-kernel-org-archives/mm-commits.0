Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345BDC388F7
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 19:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C39DA20809
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 19:35:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="jzV7JHLn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgKJTfN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 14:35:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbgKJTfN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 14:35:13 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F53420665;
        Tue, 10 Nov 2020 19:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605036912;
        bh=PZ2/B8vg9E+3zKRYNo39u9AXpIx42nMHynZBBu+RmQA=;
        h=Date:From:To:Subject:From;
        b=jzV7JHLn0WYrLFi7UKAhQ95rmaA5XHFU9y29QR/H11/4bwPRJOvCqkZj6eGqi9w6P
         OwgZ+r43557ZIJzNeXlfNNYJVN3dWhI5yPUzuaMxI+OexJJnWMMQIUD/z/59LKRL3B
         p8FKHnUyCaRSy/L9HZ/9mkYjgxk9yzddZ6BolxUI=
Date:   Tue, 10 Nov 2020 11:35:11 -0800
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, christian.brauner@ubuntu.com, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, laoar.shao@gmail.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  +
 mm-memcg-slab-fix-use-after-free-in-obj_cgroup_charge.patch added to -mm
 tree
Message-ID: <20201110193511.wPdoA3vlG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: fix use after free in obj_cgroup_charge
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-fix-use-after-free-in-obj_cgroup_charge.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-fix-use-after-free-in-obj_cgroup_charge.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-fix-use-after-free-in-obj_cgroup_charge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcg/slab: fix use after free in obj_cgroup_charge

The rcu_read_lock/unlock only can guarantee that the memcg will not be
freed, but it cannot guarantee the success of css_get to memcg.

If the whole process of a cgroup offlining is completed between reading a
objcg->memcg pointer and bumping the css reference on another CPU, and
there are exactly 0 external references to this memory cgroup (how we get
to the obj_cgroup_charge() then?), css_get() can change the ref counter
from 0 back to 1.

Link: https://lkml.kernel.org/r/20201028035013.99711-2-songmuchun@bytedance.com
Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-slab-fix-use-after-free-in-obj_cgroup_charge
+++ a/mm/memcontrol.c
@@ -3217,8 +3217,10 @@ int obj_cgroup_charge(struct obj_cgroup
 	 * independently later.
 	 */
 	rcu_read_lock();
+retry:
 	memcg = obj_cgroup_memcg(objcg);
-	css_get(&memcg->css);
+	if (unlikely(!css_tryget(&memcg->css)))
+		goto retry;
 	rcu_read_unlock();
 
 	nr_pages = size >> PAGE_SHIFT;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-missing-wakeup-polling-thread.patch
mm-memcontrol-remove-unused-mod_memcg_obj_state.patch
mm-memcg-slab-fix-return-child-memcg-objcg-for-root-memcg.patch
mm-memcg-slab-fix-use-after-free-in-obj_cgroup_charge.patch

