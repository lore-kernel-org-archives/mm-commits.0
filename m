Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 834A1C43334
	for <mm-commits@archiver.kernel.org>; Sat, 11 Jun 2022 21:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiFKVSL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Jun 2022 17:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiFKVSL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 11 Jun 2022 17:18:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA7556389
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 14:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCAB5B80B48
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 21:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EBFC34116;
        Sat, 11 Jun 2022 21:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654982287;
        bh=AC0rjSiOwXok4lKaywr1IOrZ/7qbQV6LgvChzG2xBo8=;
        h=Date:To:From:Subject:From;
        b=DVWMRAK09pbmWZwitruw0NdmmuUYR8FNrxiG6/5IyBC0ggSmYlVYKMmkL7yWiky0p
         3cJhECtNuPIGN1HrE9yU4jewM+XzzNSD3szGqA3gNQNoGNPZf/pj9UrI+Li9DxBKiY
         32EGpiMKAU4tHgkBh7uTlXomeL2XwSsuZjvW/utM=
Date:   Sat, 11 Jun 2022 14:18:06 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vbabka@suse.cz, songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, quic_qiancai@quicinc.com,
        pabeni@redhat.com, naresh.kamboju@linaro.org, mkoutny@suse.com,
        mhocko@suse.com, lkft@linaro.org, kuba@kernel.org,
        hannes@cmpxchg.org, fw@strlen.de, edumazet@google.com,
        davem@davemloft.net, vvs@openvz.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + net-set-proper-memcg-for-net_init-hooks-allocations.patch added to mm-unstable branch
Message-Id: <20220611211807.70EBFC34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: net: set proper memcg for net_init hooks allocations
has been added to the -mm mm-unstable branch.  Its filename is
     net-set-proper-memcg-for-net_init-hooks-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/net-set-proper-memcg-for-net_init-hooks-allocations.patch

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
From: Vasily Averin <vvs@openvz.org>
Subject: net: set proper memcg for net_init hooks allocations
Date: Fri, 3 Jun 2022 07:19:43 +0300

__register_pernet_operations() executes init hook of registered
pernet_operation structure in all existing net namespaces.

Typically, these hooks are called by a process associated with the
specified net namespace, and all __GFP_ACCOUNT marked allocation are
accounted for corresponding container/memcg.

However __register_pernet_operations() calls the hooks in the same
context, and as a result all marked allocations are accounted to one memcg
for all processed net namespaces.

This patch adjusts active memcg for each net namespace and helps to
account memory allocated inside ops_init() into the proper memcg.

Link: https://lkml.kernel.org/r/f9394752-e272-9bf9-645f-a18c56d1c4ec@openvz.org
Signed-off-by: Vasily Averin <vvs@openvz.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Linux Kernel Functional Testing <lkft@linaro.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   47 ++++++++++++++++++++++++++++++++++-
 net/core/net_namespace.c   |    7 +++++
 2 files changed, 53 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~net-set-proper-memcg-for-net_init-hooks-allocations
+++ a/include/linux/memcontrol.h
@@ -1777,6 +1777,42 @@ static inline void count_objcg_event(str
 	rcu_read_unlock();
 }
 
+/**
+ * get_mem_cgroup_from_obj - get a memcg associated with passed kernel object.
+ * @p: pointer to object from which memcg should be extracted. It can be NULL.
+ *
+ * Retrieves the memory group into which the memory of the pointed kernel
+ * object is accounted. If memcg is found, its reference is taken.
+ * If a passed kernel object is uncharged, or if proper memcg cannot be found,
+ * as well as if mem_cgroup is disabled, NULL is returned.
+ *
+ * Return: valid memcg pointer with taken reference or NULL.
+ */
+static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	do {
+		memcg = mem_cgroup_from_obj(p);
+	} while (memcg && !css_tryget(&memcg->css));
+	rcu_read_unlock();
+	return memcg;
+}
+
+/**
+ * mem_cgroup_or_root - always returns a pointer to a valid memory cgroup.
+ * @memcg: pointer to a valid memory cgroup or NULL.
+ *
+ * If passed argument is not NULL, returns it without any additional checks
+ * and changes. Otherwise, root_mem_cgroup is returned.
+ *
+ * NOTE: root_mem_cgroup can be NULL during early boot.
+ */
+static inline struct mem_cgroup *mem_cgroup_or_root(struct mem_cgroup *memcg)
+{
+	return memcg ? memcg : root_mem_cgroup;
+}
 #else
 static inline bool mem_cgroup_kmem_disabled(void)
 {
@@ -1820,7 +1856,7 @@ static inline int memcg_kmem_id(struct m
 
 static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
 {
-       return NULL;
+	return NULL;
 }
 
 static inline struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
@@ -1833,6 +1869,15 @@ static inline void count_objcg_event(str
 {
 }
 
+static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
+{
+	return NULL;
+}
+
+static inline struct mem_cgroup *mem_cgroup_or_root(struct mem_cgroup *memcg)
+{
+	return NULL;
+}
 #endif /* CONFIG_MEMCG_KMEM */
 
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
--- a/net/core/net_namespace.c~net-set-proper-memcg-for-net_init-hooks-allocations
+++ a/net/core/net_namespace.c
@@ -18,6 +18,7 @@
 #include <linux/user_namespace.h>
 #include <linux/net_namespace.h>
 #include <linux/sched/task.h>
+#include <linux/sched/mm.h>
 #include <linux/uidgid.h>
 #include <linux/cookie.h>
 
@@ -1143,7 +1144,13 @@ static int __register_pernet_operations(
 		 * setup_net() and cleanup_net() are not possible.
 		 */
 		for_each_net(net) {
+			struct mem_cgroup *old, *memcg;
+
+			memcg = mem_cgroup_or_root(get_mem_cgroup_from_obj(net));
+			old = set_active_memcg(memcg);
 			error = ops_init(ops, net);
+			set_active_memcg(old);
+			mem_cgroup_put(memcg);
 			if (error)
 				goto out_undo;
 			list_add_tail(&net->exit_list, &net_exit_list);
_

Patches currently in -mm which might be from vvs@openvz.org are

net-set-proper-memcg-for-net_init-hooks-allocations.patch

