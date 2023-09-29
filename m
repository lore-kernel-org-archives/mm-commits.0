Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F299E728CF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 18:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbjI2SnE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 14:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbjI2SnB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 14:43:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD211A5
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 11:42:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29973C433C9;
        Fri, 29 Sep 2023 18:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696012977;
        bh=PlZRiXdjykt7pAF9CKHjQQQCCwgiXc/ogQSPQr0oSXc=;
        h=Date:To:From:Subject:From;
        b=qDdiA7H/anMdbIiWcmcM+GETdihmBtcv4/qXG1JX7iRwisTCUlsDtndr1jGBPpHlr
         basgGapvh7Sga/SB9+R2su0mkL6SpWlJLdy47Bipm4Z8vt6s80nr6gm+3Onn0KKcu6
         iVBR1zH0RuOodWYliWVu3rK84TSYjMExj5yLrzbA=
Date:   Fri, 29 Sep 2023 11:42:56 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        rientjes@google.com, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, dennis@kernel.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-scoped-objcg-protection.patch added to mm-unstable branch
Message-Id: <20230929184257.29973C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: percpu: scoped objcg protection
has been added to the -mm mm-unstable branch.  Its filename is
     percpu-scoped-objcg-protection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-scoped-objcg-protection.patch

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
Subject: percpu: scoped objcg protection
Date: Fri, 29 Sep 2023 11:00:55 -0700

Similar to slab and kmem, switch to a scope-based protection of the
objcg pointer to avoid.

Link: https://lkml.kernel.org/r/20230929180056.1122002-6-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/percpu.c~percpu-scoped-objcg-protection
+++ a/mm/percpu.c
@@ -1628,14 +1628,12 @@ static bool pcpu_memcg_pre_alloc_hook(si
 	if (!memcg_kmem_online() || !(gfp & __GFP_ACCOUNT))
 		return true;
 
-	objcg = get_obj_cgroup_from_current();
+	objcg = current_obj_cgroup();
 	if (!objcg)
 		return true;
 
-	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size))) {
-		obj_cgroup_put(objcg);
+	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size)))
 		return false;
-	}
 
 	*objcgp = objcg;
 	return true;
@@ -1649,6 +1647,7 @@ static void pcpu_memcg_post_alloc_hook(s
 		return;
 
 	if (likely(chunk && chunk->obj_cgroups)) {
+		obj_cgroup_get(objcg);
 		chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT] = objcg;
 
 		rcu_read_lock();
@@ -1657,7 +1656,6 @@ static void pcpu_memcg_post_alloc_hook(s
 		rcu_read_unlock();
 	} else {
 		obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
-		obj_cgroup_put(objcg);
 	}
 }
 
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-kmem-optimize-get_obj_cgroup_from_current.patch
mm-kmem-add-direct-objcg-pointer-to-task_struct.patch
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg.patch
mm-kmem-scoped-objcg-protection.patch
percpu-scoped-objcg-protection.patch

