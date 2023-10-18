Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B11DCDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 18:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjJRShS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 14:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjJRShR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 14:37:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59DEF7
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 11:37:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32814C433C8;
        Wed, 18 Oct 2023 18:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697654235;
        bh=5u5+Ff/sAP09HxbsEEiFI2hrd1/5PQhyAGRKJ2Lzis4=;
        h=Date:To:From:Subject:From;
        b=WRoXfB+8kOjwatxP+6z8TqPEAphb0wdQXkDKh8yd26sh0tVN3dBjuOE34eUksrawX
         lARcp269oeuGkkMSJadwHsOID2V8A+wwx14Mx/VbyUGy/WcCATZXCccsmF+W4iVh+j
         pEvMNep/2rEIm/UUpLiv+VnRY52l/bYl8O3Iz+Gg=
Date:   Wed, 18 Oct 2023 11:37:14 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        rientjes@google.com, naresh.kamboju@linaro.org,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        dennis@kernel.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmem-add-direct-objcg-pointer-to-task_struct-v4.patch added to mm-unstable branch
Message-Id: <20231018183715.32814C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kmem-add-direct-objcg-pointer-to-task_struct-v4
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmem-add-direct-objcg-pointer-to-task_struct-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmem-add-direct-objcg-pointer-to-task_struct-v4.patch

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
Subject: mm-kmem-add-direct-objcg-pointer-to-task_struct-v4
Date: Wed, 18 Oct 2023 11:08:20 -0700

add comment, s/0/CURRENT_OBJCG_UPDATE_BIT/

Link: https://lkml.kernel.org/r/ZTAfFOsvlbqPI0Uk@P9FQF9L96D.corp.robot.car
Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-kmem-add-direct-objcg-pointer-to-task_struct-v4
+++ a/mm/memcontrol.c
@@ -249,7 +249,8 @@ struct mem_cgroup *vmpressure_to_memcg(s
 	return container_of(vmpr, struct mem_cgroup, vmpressure);
 }
 
-#define CURRENT_OBJCG_UPDATE_FLAG 0x1UL
+#define CURRENT_OBJCG_UPDATE_BIT 0
+#define CURRENT_OBJCG_UPDATE_FLAG (1UL << CURRENT_OBJCG_UPDATE_BIT)
 
 #ifdef CONFIG_MEMCG_KMEM
 static DEFINE_SPINLOCK(objcg_lock);
@@ -3126,6 +3127,13 @@ static struct obj_cgroup *current_objcg_
 			old = NULL;
 		}
 
+		/*
+		 * Release the objcg pointer from the previous iteration,
+		 * if try_cmpxcg() below fails.
+		 */
+		if (unlikely(objcg))
+			obj_cgroup_put(objcg);
+
 		/* Obtain the new objcg pointer. */
 		rcu_read_lock();
 		memcg = mem_cgroup_from_task(current);
@@ -6598,7 +6606,7 @@ static void mem_cgroup_kmem_attach(struc
 
 	cgroup_taskset_for_each(task, css, tset) {
 		/* atomically set the update bit */
-		set_bit(0, (unsigned long *)&task->objcg);
+		set_bit(CURRENT_OBJCG_UPDATE_BIT, (unsigned long *)&task->objcg);
 	}
 }
 #else
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-kmem-optimize-get_obj_cgroup_from_current.patch
mm-kmem-add-direct-objcg-pointer-to-task_struct.patch
mm-kmem-add-direct-objcg-pointer-to-task_struct-v4.patch
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg.patch
mm-kmem-scoped-objcg-protection.patch
percpu-scoped-objcg-protection.patch

