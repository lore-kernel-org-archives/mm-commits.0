Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF68C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379839AbiFQCtr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379821AbiFQCtm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA2C64D0B
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77DF461D19
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A52C3411A;
        Fri, 17 Jun 2022 02:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434179;
        bh=gZjMjOoutHq/aNwVQVyYg2O3Ndc6hAzC/0gl8wZ5zsE=;
        h=Date:To:From:Subject:From;
        b=FWKycW84DPTx0v5f84pFW6GByxDM8B7e/e0EDtCTt58ZNrXj1SDhXzVqmdjsbn5R/
         YHyiXQxrP+fwyzV34ayi86oe9sNRUb1aYFJ50n2cmr1EiE+MZL1ml05KHjI14p+hrP
         N4Q4W+WJIwMfz7tlxHpremIAdsmwierIP0WqxL6w=
Date:   Thu, 16 Jun 2022 19:49:39 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vbabka@suse.cz, songmuchun@bytedance.com, shakeelb@google.com,
        roman.gushchin@linux.dev, quic_qiancai@quicinc.com,
        pabeni@redhat.com, naresh.kamboju@linaro.org, mkoutny@suse.com,
        mhocko@suse.com, lkft@linaro.org, kuba@kernel.org,
        hannes@cmpxchg.org, fw@strlen.de, edumazet@google.com,
        davem@davemloft.net, vvs@openvz.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] net-set-proper-memcg-for-net_init-hooks-allocations.patch removed from -mm tree
Message-Id: <20220617024939.D0A52C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: net: set proper memcg for net_init hooks allocations
has been removed from the -mm tree.  Its filename was
     net-set-proper-memcg-for-net_init-hooks-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1756,6 +1756,42 @@ static inline void count_objcg_event(str
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
@@ -1799,7 +1835,7 @@ static inline int memcg_kmem_id(struct m
 
 static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
 {
-       return NULL;
+	return NULL;
 }
 
 static inline struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
@@ -1812,6 +1848,15 @@ static inline void count_objcg_event(str
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


