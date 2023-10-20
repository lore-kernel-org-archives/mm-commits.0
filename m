Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA47FC0032E
	for <mm-commits@archiver.kernel.org>; Fri, 20 Oct 2023 17:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjJTRLT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjJTRLS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2023 13:11:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90710CA
        for <mm-commits@vger.kernel.org>; Fri, 20 Oct 2023 10:11:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A95C433C9;
        Fri, 20 Oct 2023 17:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697821876;
        bh=3WibU6LUMYqfrtcP+KzFrjgqo5gM6WIj3t2AJmyrD5w=;
        h=Date:To:From:Subject:From;
        b=HK9/4ESvv8XGQ9EUL/OENICBl6hKk+0zsAiNgWvdED2Eo4VkO3VK4iHd+xMrkeRRC
         ayOIgOgu9u41d4k/Efrt59AiD2v3SgmjB/4T/Exq305094WrWbLyq6zzhn3hT/bG02
         NKh5wbf8U40TpU9yYHJaKpXE0vZ/9DxH9ByKYGy8=
Date:   Fri, 20 Oct 2023 10:11:15 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        rientjes@google.com, naresh.kamboju@linaro.org,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        dennis@kernel.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmem-reimplement-get_obj_cgroup_from_current.patch added to mm-unstable branch
Message-Id: <20231020171116.27A95C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: reimplement get_obj_cgroup_from_current()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmem-reimplement-get_obj_cgroup_from_current.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmem-reimplement-get_obj_cgroup_from_current.patch

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
Subject: mm: kmem: reimplement get_obj_cgroup_from_current()
Date: Thu, 19 Oct 2023 15:53:46 -0700

Reimplement get_obj_cgroup_from_current() using current_obj_cgroup(). 
get_obj_cgroup_from_current() and current_obj_cgroup() share 80% of the
code, so the new implementation is almost trivial.

get_obj_cgroup_from_current() is a convenient function used by the
bpf subsystem, so there is no reason to get rid of it completely.

Link: https://lkml.kernel.org/r/20231019225346.1822282-7-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   11 ++++++++++-
 mm/memcontrol.c            |   32 --------------------------------
 2 files changed, 10 insertions(+), 33 deletions(-)

--- a/include/linux/memcontrol.h~mm-kmem-reimplement-get_obj_cgroup_from_current
+++ a/include/linux/memcontrol.h
@@ -1805,9 +1805,18 @@ void __memcg_kmem_uncharge_page(struct p
  * needs to be used outside of the local scope.
  */
 struct obj_cgroup *current_obj_cgroup(void);
-struct obj_cgroup *get_obj_cgroup_from_current(void);
 struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio);
 
+static inline struct obj_cgroup *get_obj_cgroup_from_current(void)
+{
+	struct obj_cgroup *objcg = current_obj_cgroup();
+
+	if (objcg)
+		obj_cgroup_get(objcg);
+
+	return objcg;
+}
+
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size);
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
 
--- a/mm/memcontrol.c~mm-kmem-reimplement-get_obj_cgroup_from_current
+++ a/mm/memcontrol.c
@@ -3162,38 +3162,6 @@ static struct obj_cgroup *current_objcg_
 	return objcg;
 }
 
-__always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
-{
-	struct mem_cgroup *memcg;
-	struct obj_cgroup *objcg;
-
-	if (in_task()) {
-		memcg = current->active_memcg;
-		if (unlikely(memcg))
-			goto from_memcg;
-
-		objcg = READ_ONCE(current->objcg);
-		if (unlikely((unsigned long)objcg & CURRENT_OBJCG_UPDATE_FLAG))
-			objcg = current_objcg_update();
-
-		if (objcg) {
-			obj_cgroup_get(objcg);
-			return objcg;
-		}
-	} else {
-		memcg = this_cpu_read(int_active_memcg);
-		if (unlikely(memcg))
-			goto from_memcg;
-	}
-	return NULL;
-
-from_memcg:
-	rcu_read_lock();
-	objcg = __get_obj_cgroup_from_memcg(memcg);
-	rcu_read_unlock();
-	return objcg;
-}
-
 __always_inline struct obj_cgroup *current_obj_cgroup(void)
 {
 	struct mem_cgroup *memcg;
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-kmem-optimize-get_obj_cgroup_from_current.patch
mm-kmem-add-direct-objcg-pointer-to-task_struct.patch
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg.patch
mm-kmem-scoped-objcg-protection.patch
percpu-scoped-objcg-protection.patch
mm-kmem-reimplement-get_obj_cgroup_from_current.patch

