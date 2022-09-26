Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EA0C32771
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 20:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiIZUDL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 16:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiIZUDK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 16:03:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786CC92F79
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 13:03:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2BF6611C6
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 20:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C961C433B5;
        Mon, 26 Sep 2022 20:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664222588;
        bh=q5yBpyabgBKjhy/nqvRYZ6INiTTZ6YdlsHrTWaghW/k=;
        h=Date:To:From:Subject:From;
        b=oBmgDXi7aVqCu/vjR7ViX0sgVUicDAtfQzSfII2cHr/XbwstkQuUXFhMaszIBaUwa
         l/ICCpoFjDOrmrf2sWu91CPxjnzD74yToVBgn2AjaAMvX4gRucDA9QSmxyglwODNIv
         8mijAhuD+26nvww/ETnO1+BO3H3fz+odJUvfDakA=
Date:   Mon, 26 Sep 2022 13:03:06 -0700
To:     mm-commits@vger.kernel.org, vvs@openvz.org, mkoutny@suse.com,
        matorola@gmail.com, kuba@kernel.org, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-net-set-proper-memcg-for-net_init-hooks-allocations.patch added to mm-hotfixes-unstable branch
Message-Id: <20220926200308.1C961C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "net: set proper memcg for net_init hooks allocations"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-net-set-proper-memcg-for-net_init-hooks-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-net-set-proper-memcg-for-net_init-hooks-allocations.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Shakeel Butt <shakeelb@google.com>
Subject: Revert "net: set proper memcg for net_init hooks allocations"
Date: Mon, 26 Sep 2022 19:59:31 +0000

This reverts commit 1d0403d20f6c281cb3d14c5f1db5317caeec48e9.

Anatoly Pugachev reported that the commit 1d0403d20f6c ("net: set proper
memcg for net_init hooks allocations") is somehow causing the sparc64 VMs
failed to boot and the VMs boot fine with that patch reverted.  So, revert
the patch for now and later we can debug the issue.

Link: https://lkml.kernel.org/r/20220926195931.2497968-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Anatoly Pugachev <matorola@gmail.com>
Cc: Vasily Averin <vvs@openvz.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/memcontrol.h~revert-net-set-proper-memcg-for-net_init-hooks-allocations
+++ a/include/linux/memcontrol.h
@@ -1788,42 +1788,6 @@ static inline void count_objcg_event(str
 	rcu_read_unlock();
 }
 
-/**
- * get_mem_cgroup_from_obj - get a memcg associated with passed kernel object.
- * @p: pointer to object from which memcg should be extracted. It can be NULL.
- *
- * Retrieves the memory group into which the memory of the pointed kernel
- * object is accounted. If memcg is found, its reference is taken.
- * If a passed kernel object is uncharged, or if proper memcg cannot be found,
- * as well as if mem_cgroup is disabled, NULL is returned.
- *
- * Return: valid memcg pointer with taken reference or NULL.
- */
-static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
-{
-	struct mem_cgroup *memcg;
-
-	rcu_read_lock();
-	do {
-		memcg = mem_cgroup_from_obj(p);
-	} while (memcg && !css_tryget(&memcg->css));
-	rcu_read_unlock();
-	return memcg;
-}
-
-/**
- * mem_cgroup_or_root - always returns a pointer to a valid memory cgroup.
- * @memcg: pointer to a valid memory cgroup or NULL.
- *
- * If passed argument is not NULL, returns it without any additional checks
- * and changes. Otherwise, root_mem_cgroup is returned.
- *
- * NOTE: root_mem_cgroup can be NULL during early boot.
- */
-static inline struct mem_cgroup *mem_cgroup_or_root(struct mem_cgroup *memcg)
-{
-	return memcg ? memcg : root_mem_cgroup;
-}
 #else
 static inline bool mem_cgroup_kmem_disabled(void)
 {
@@ -1880,15 +1844,6 @@ static inline void count_objcg_event(str
 {
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
-{
-	return NULL;
-}
-
-static inline struct mem_cgroup *mem_cgroup_or_root(struct mem_cgroup *memcg)
-{
-	return NULL;
-}
 #endif /* CONFIG_MEMCG_KMEM */
 
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
--- a/net/core/net_namespace.c~revert-net-set-proper-memcg-for-net_init-hooks-allocations
+++ a/net/core/net_namespace.c
@@ -18,7 +18,6 @@
 #include <linux/user_namespace.h>
 #include <linux/net_namespace.h>
 #include <linux/sched/task.h>
-#include <linux/sched/mm.h>
 #include <linux/uidgid.h>
 #include <linux/cookie.h>
 
@@ -1144,13 +1143,7 @@ static int __register_pernet_operations(
 		 * setup_net() and cleanup_net() are not possible.
 		 */
 		for_each_net(net) {
-			struct mem_cgroup *old, *memcg;
-
-			memcg = mem_cgroup_or_root(get_mem_cgroup_from_obj(net));
-			old = set_active_memcg(memcg);
 			error = ops_init(ops, net);
-			set_active_memcg(old);
-			mem_cgroup_put(memcg);
 			if (error)
 				goto out_undo;
 			list_add_tail(&net->exit_list, &net_exit_list);
_

Patches currently in -mm which might be from shakeelb@google.com are

revert-net-set-proper-memcg-for-net_init-hooks-allocations.patch
mm-deduplicate-cacheline-padding-code.patch
memcg-extract-memcg_vmstats-from-struct-mem_cgroup.patch
memcg-rearrange-code.patch
memcg-reduce-size-of-memcg-vmstats-structures.patch

