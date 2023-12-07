Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C51D5C4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjLGAHd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjLGAHd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:07:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FD3D3
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:07:39 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F1CC433C7;
        Thu,  7 Dec 2023 00:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701907659;
        bh=KD+zGtED27jQ12xjunrd3AJO5BmI3SEWOERF4HkFSzE=;
        h=Date:To:From:Subject:From;
        b=aNogJhn2DqlfjWR8/K/xyj2xL4J+nhogKqpTt2F96E79IN9VNratU/iZfbxnz9ZXU
         8P+GMHmqVfhWZDYJEG49cykQyowtj2NOuZCMR2zFsBlFLMyuIg5EfLyoI/Yb3eA5Fb
         0ET57KUjC1WUS5CQQ5FgZ8h30aVw8xBTZPmmd5BA=
Date:   Wed, 06 Dec 2023 16:07:38 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, rientjes@google.com,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        erhard_f@mailbox.org, dennis@kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup-fix.patch removed from -mm tree
Message-Id: <20231207000739.51F1CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup-fix
has been removed from the -mm tree.  Its filename was
     mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup-fix.patch

This patch was dropped because it was folded into mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup-fix
Date: Thu, 16 Nov 2023 08:04:18 +0100

remove redundant assignment

Link: https://lkml.kernel.org/r/4bd106d5-c3e3-6731-9a74-cff81e2392de@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Erhard Furtner <erhard_f@mailbox.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memcontrol.c~mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup-fix
+++ a/mm/memcontrol.c
@@ -3177,7 +3177,6 @@ from_memcg:
 		objcg = rcu_dereference_check(memcg->objcg, 1);
 		if (likely(objcg))
 			break;
-		objcg = NULL;
 	}
 
 	return objcg;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup.patch

