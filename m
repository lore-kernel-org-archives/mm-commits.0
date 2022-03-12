Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63545C433FE
	for <mm-commits@archiver.kernel.org>; Sat, 12 Mar 2022 20:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiCLUfc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Mar 2022 15:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbiCLUfb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Mar 2022 15:35:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BB71DEA9A
        for <mm-commits@vger.kernel.org>; Sat, 12 Mar 2022 12:34:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9CEDB8074D
        for <mm-commits@vger.kernel.org>; Sat, 12 Mar 2022 20:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80021C340EB;
        Sat, 12 Mar 2022 20:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647117262;
        bh=8GBa3n6qdxFRAEzlBiNjML49c4iXy7Crxjhh8GIOlCo=;
        h=Date:To:From:Subject:From;
        b=PSCTLa7qVfNIRnt2qH1yH8Xt8aKxvFk4gmN3w1uYHSc4WHKavGZ3aQqIYAJaIPnu8
         JtETsIC2OXguO9jdFYHXwog1KS79KKIhbxN9kGo9VZbQAasw30Mr2jIh/3paX8M2ku
         +eetgxLbudsOJQYSTjKgU5ocnU9NujamnGXwHY/M=
Date:   Sat, 12 Mar 2022 12:34:21 -0800
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        richard.weiyang@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-add-next_mz-back-to-soft-limit-tree-if-not-reclaimed-yet.patch added to -mm tree
Message-Id: <20220312203422.80021C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: add next_mz back to soft limit tree if not reclaimed yet
has been added to the -mm tree.  Its filename is
     mm-memcg-add-next_mz-back-to-soft-limit-tree-if-not-reclaimed-yet.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-add-next_mz-back-to-soft-limit-tree-if-not-reclaimed-yet.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-add-next_mz-back-to-soft-limit-tree-if-not-reclaimed-yet.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memcg: add next_mz back to soft limit tree if not reclaimed yet

When memory reclaim failed for a maximum number of attempts and we bail
out of the reclaim loop, we forgot to put the target mem_cgroup chosen for
next reclaim back to the soft limit tree.  This prevented pages in the
mem_cgroup from being reclaimed in the future even though the mem_cgroup
exceeded its soft limit.

Let's say there are two mem_cgroup and both of them exceed the soft limit,
while the first one is more active then the second.  Since we add a
mem_cgroup to soft limit tree every 1024 event, the second one just get a
rare chance to be put on soft limit tree even it exceeds the limit.

As time goes on, the first mem_cgroup was kept close to its soft limit due
to reclaim activities, while the memory usage of the second mem_cgroup
keeps growing over the soft limit for a long time due to its relatively
rare occurrence.

This patch adds next_mz back to prevent this scenario.

Link: https://lkml.kernel.org/r/20220312071623.19050-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-add-next_mz-back-to-soft-limit-tree-if-not-reclaimed-yet
+++ a/mm/memcontrol.c
@@ -3453,8 +3453,13 @@ unsigned long mem_cgroup_soft_limit_recl
 			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
 			break;
 	} while (!nr_reclaimed);
-	if (next_mz)
+	if (next_mz) {
+		spin_lock_irq(&mctz->lock);
+		excess = soft_limit_excess(next_mz->memcg);
+		__mem_cgroup_insert_exceeded(next_mz, mctz, excess);
+		spin_unlock_irq(&mctz->lock);
 		css_put(&next_mz->memcg->css);
+	}
 	return nr_reclaimed;
 }
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memcg-mem_cgroup_per_node-is-already-set-to-0-on-allocation.patch
mm-memcg-retrieve-parent-memcg-from-cssparent.patch
mm-memcg-set-memcg-after-css-verified-and-got-reference.patch
mm-memcg-set-pos-to-prev-unconditionally.patch
mm-memcg-move-generation-assignment-and-comparison-together.patch
mm-memcg-mz-already-removed-from-rb_tree-in-mem_cgroup_largest_soft_limit_node.patch
mm-memcg-__mem_cgroup_remove_exceeded-could-handle-a-on-tree-mz-properly.patch
mm-memcg-add-next_mz-back-to-soft-limit-tree-if-not-reclaimed-yet.patch
mm-page_alloc-add-same-penalty-is-enough-to-get-round-robin-order.patch
mm-page_alloc-add-penalty-to-local_node.patch
memcg-do-not-tweak-node-in-alloc_mem_cgroup_per_node_info.patch

