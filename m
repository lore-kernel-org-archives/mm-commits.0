Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E390CD8CAC
	for <mm-commits@archiver.kernel.org>; Tue, 10 Oct 2023 18:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbjJJSVK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Oct 2023 14:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjJJSVK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2023 14:21:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C03494
        for <mm-commits@vger.kernel.org>; Tue, 10 Oct 2023 11:21:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AB3C433C9;
        Tue, 10 Oct 2023 18:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696962068;
        bh=n/uUcWvSXPLat4vkS9QKo8w1gV9ZdFD/PxhG6TmS1c0=;
        h=Date:To:From:Subject:From;
        b=p9cXXRC6UCww6AsH/z8rtEBcGPBqjQ/aV2jOZue80i2kzHCFGN5wEM7/nJ7n5WK00
         NzVif7/2A7JdxeNg3wg0GExl6vWz2/Ll72s0HxR/moBmZe64aubyGEziOPe8DarJNB
         UtnuBA83VtByHQDFgDsmpCE/3aP59UygFveoSerI=
Date:   Tue, 10 Oct 2023 11:20:50 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        rientjes@google.com, naresh.kamboju@linaro.org,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        dennis@kernel.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg.patch added to mm-unstable branch
Message-Id: <20231010182105.B5AB3C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: make memcg keep a reference to the original objcg
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg.patch

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: kmem: make memcg keep a reference to the original objcg
Date: Mon, 9 Oct 2023 17:09:27 -0700

Keep a reference to the original objcg object for the entire life
of a memcg structure.

This allows to simplify the synchronization on the kernel memory
allocation paths: pinning a (live) memcg will also pin the
corresponding objcg.

The memory overhead of this change is minimal because object cgroups
usually outlive their corresponding memory cgroups even without this
change, so it's only an additional pointer per memcg.

Link: https://lkml.kernel.org/r/20231010000929.450702-4-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    8 +++++++-
 mm/memcontrol.c            |    5 +++++
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg
+++ a/include/linux/memcontrol.h
@@ -290,7 +290,13 @@ struct mem_cgroup {
 
 #ifdef CONFIG_MEMCG_KMEM
 	int kmemcg_id;
-	struct obj_cgroup __rcu *objcg;
+	/*
+	 * memcg->objcg is wiped out as a part of the objcg repaprenting
+	 * process. memcg->orig_objcg preserves a pointer (and a reference)
+	 * to the original objcg until the end of live of memcg.
+	 */
+	struct obj_cgroup __rcu	*objcg;
+	struct obj_cgroup	*orig_objcg;
 	/* list of inherited objcgs, protected by objcg_lock */
 	struct list_head objcg_list;
 #endif
--- a/mm/memcontrol.c~mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg
+++ a/mm/memcontrol.c
@@ -3914,6 +3914,8 @@ static int memcg_online_kmem(struct mem_
 
 	objcg->memcg = memcg;
 	rcu_assign_pointer(memcg->objcg, objcg);
+	obj_cgroup_get(objcg);
+	memcg->orig_objcg = objcg;
 
 	static_branch_enable(&memcg_kmem_online_key);
 
@@ -5421,6 +5423,9 @@ static void __mem_cgroup_free(struct mem
 {
 	int node;
 
+	if (memcg->orig_objcg)
+		obj_cgroup_put(memcg->orig_objcg);
+
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
 	kfree(memcg->vmstats);
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-kmem-optimize-get_obj_cgroup_from_current.patch
mm-kmem-add-direct-objcg-pointer-to-task_struct.patch
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg.patch
mm-kmem-scoped-objcg-protection.patch
percpu-scoped-objcg-protection.patch

