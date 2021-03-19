Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FA7C433E4
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 17:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE6C26191E
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 17:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCSRLu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 13:11:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230379AbhCSRLg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 13:11:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BE9661986;
        Fri, 19 Mar 2021 17:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616173896;
        bh=DSZY3oGtevbTjSbhL0As5j5h0s9YaEKI3gGc/8aQjqY=;
        h=Date:From:To:Subject:From;
        b=oRor4V5X93vvMdryZhWa64bCYBXycZWmbhyyHSyGfv1ucMrsJIr8O2aAPohDSwAxH
         uPtpU7V7EOqo/oWzntH0Yjvj1TDLifoVx8X5pVKKWSy0IEv0D07OyTS2EY9NUuusZh
         WTlwUUB6pRZfq//aFYFkMv7nVqqCQQmIIgSr1Vus=
Date:   Fri, 19 Mar 2021 10:11:35 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, duanxiongchun@bytedance.com,
        guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  +
 mm-memcontrol-slab-fix-obtain-a-reference-to-a-freeing-memcg.patch added to
 -mm tree
Message-ID: <20210319171135.CP7tdu6yD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: slab: fix obtain a reference to a freeing memcg
has been added to the -mm tree.  Its filename is
     mm-memcontrol-slab-fix-obtain-a-reference-to-a-freeing-memcg.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-slab-fix-obtain-a-reference-to-a-freeing-memcg.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-slab-fix-obtain-a-reference-to-a-freeing-memcg.patch

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
Subject: mm: memcontrol: slab: fix obtain a reference to a freeing memcg

Patch series "Use obj_cgroup APIs to charge kmem pages", v5.

Since Roman's series "The new cgroup slab memory controller" applied.  All
slab objects are charged with the new APIs of obj_cgroup.  The new APIs
introduce a struct obj_cgroup to charge slab objects.  It prevents
long-living objects from pinning the original memory cgroup in the memory.
But there are still some corner objects (e.g.  allocations larger than
order-1 page on SLUB) which are not charged with the new APIs.  Those
objects (include the pages which are allocated from buddy allocator
directly) are charged as kmem pages which still hold a reference to the
memory cgroup.

E.g.  We know that the kernel stack is charged as kmem pages because the
size of the kernel stack can be greater than 2 pages (e.g.  16KB on x86_64
or arm64).  If we create a thread (suppose the thread stack is charged to
memory cgroup A) and then move it from memory cgroup A to memory cgroup B.
Because the kernel stack of the thread hold a reference to the memory
cgroup A.  The thread can pin the memory cgroup A in the memory even if we
remove the cgroup A.  If we want to see this scenario by using the
following script.  We can see that the system has added 500 dying cgroups
(This is not a real world issue, just a script to show that the large
kmallocs are charged as kmem pages which can pin the memory cgroup in the
memory).

	#!/bin/bash

	cat /proc/cgroups | grep memory

	cd /sys/fs/cgroup/memory
	echo 1 > memory.move_charge_at_immigrate

	for i in range{1..500}
	do
		mkdir kmem_test
		echo $$ > kmem_test/cgroup.procs
		sleep 3600 &
		echo $$ > cgroup.procs
		echo `cat kmem_test/cgroup.procs` > cgroup.procs
		rmdir kmem_test
	done

	cat /proc/cgroups | grep memory

This patchset aims to make those kmem pages to drop the reference to
memory cgroup by using the APIs of obj_cgroup.  Finally, we can see that
the number of the dying cgroups will not increase if we run the above test
script.


This patch (of 7):

The rcu_read_lock/unlock only can guarantee that the memcg will not be
freed, but it cannot guarantee the success of css_get (which is in the
refill_stock when cached memcg changed) to memcg.

  rcu_read_lock()
  memcg = obj_cgroup_memcg(old)
  __memcg_kmem_uncharge(memcg)
      refill_stock(memcg)
          if (stock->cached != memcg)
              // css_get can change the ref counter from 0 back to 1.
              css_get(&memcg->css)
  rcu_read_unlock()

This fix is very like the commit:

  eefbfa7fd678 ("mm: memcg/slab: fix use after free in obj_cgroup_charge")

Fix this by holding a reference to the memcg which is passed to the
__memcg_kmem_uncharge() before calling __memcg_kmem_uncharge().

Link: https://lkml.kernel.org/r/20210319163821.20704-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20210319163821.20704-2-songmuchun@bytedance.com
Fixes: 3de7d4f25a74 ("mm: memcg/slab: optimize objcg stock draining")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-slab-fix-obtain-a-reference-to-a-freeing-memcg
+++ a/mm/memcontrol.c
@@ -3150,9 +3150,17 @@ static void drain_obj_stock(struct memcg
 		unsigned int nr_bytes = stock->nr_bytes & (PAGE_SIZE - 1);
 
 		if (nr_pages) {
+			struct mem_cgroup *memcg;
+
 			rcu_read_lock();
-			__memcg_kmem_uncharge(obj_cgroup_memcg(old), nr_pages);
+retry:
+			memcg = obj_cgroup_memcg(old);
+			if (unlikely(!css_tryget(&memcg->css)))
+				goto retry;
 			rcu_read_unlock();
+
+			__memcg_kmem_uncharge(memcg, nr_pages);
+			css_put(&memcg->css);
 		}
 
 		/*
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-kernel-stack-account.patch
mm-memcontrol-slab-fix-obtain-a-reference-to-a-freeing-memcg.patch
mm-memcontrol-introduce-obj_cgroup_uncharge_pages.patch
mm-memcontrol-directly-access-page-memcg_data-in-mm-page_allocc.patch
mm-memcontrol-change-ug-dummy_page-only-if-memcg-changed.patch
mm-memcontrol-use-obj_cgroup-apis-to-charge-kmem-pages.patch
mm-memcontrol-inline-__memcg_kmem_uncharge-into-obj_cgroup_uncharge_pages.patch
mm-memcontrol-move-pagememcgkmem-to-the-scope-of-config_memcg_kmem.patch

