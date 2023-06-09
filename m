Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19504C83005
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjFIX1S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjFIX1E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F5A30FE
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D13F665CD7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A9BC433D2;
        Fri,  9 Jun 2023 23:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353222;
        bh=xq/Y4bpSYOwl3cSRRo89vib5F6WKTuH9iMb/xLAjgLQ=;
        h=Date:To:From:Subject:From;
        b=BSeQxc/IFZAPwihqSsZc78jb5ltnygvYkXB4mIx76JhXe6SKogl8sMmCW3a5Ak53f
         C9q9BbkQ6e95Kl8NK5PeOFyP0/Hlh4yNuOJDj6HCN/C8qyu4JgRdWBBhc5Fnl+Om80
         nrF1PHLJJHdwEhWG3ydvO7tFKXGuvowC+HIRVbOY=
Date:   Fri, 09 Jun 2023 16:27:01 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, mhocko@suse.com, hannes@cmpxchg.org,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-oom-remove-unnecessary-check-in-mem_cgroup_oom_synchronize.patch removed from -mm tree
Message-Id: <20230609232702.31A9BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg, oom: remove unnecessary check in mem_cgroup_oom_synchronize()
has been removed from the -mm tree.  Its filename was
     memcg-oom-remove-unnecessary-check-in-mem_cgroup_oom_synchronize.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: memcg, oom: remove unnecessary check in mem_cgroup_oom_synchronize()
Date: Wed, 19 Apr 2023 03:07:38 +0000

mem_cgroup_oom_synchronize() is only used when the memcg oom handling is
handed over to the edge of the #PF path.  Since commit 29ef680ae7c2
("memcg, oom: move out_of_memory back to the charge path") this is the
case only when the kernel memcg oom killer is disabled
(current->memcg_in_oom is only set if memcg->oom_kill_disable).  Therefore
a check for oom_kill_disable in mem_cgroup_oom_synchronize() is not
required.

Link: https://lkml.kernel.org/r/20230419030739.115845-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~memcg-oom-remove-unnecessary-check-in-mem_cgroup_oom_synchronize
+++ a/mm/memcontrol.c
@@ -2024,16 +2024,9 @@ bool mem_cgroup_oom_synchronize(bool han
 	if (locked)
 		mem_cgroup_oom_notify(memcg);
 
-	if (locked && !READ_ONCE(memcg->oom_kill_disable)) {
-		mem_cgroup_unmark_under_oom(memcg);
-		finish_wait(&memcg_oom_waitq, &owait.wait);
-		mem_cgroup_out_of_memory(memcg, current->memcg_oom_gfp_mask,
-					 current->memcg_oom_order);
-	} else {
-		schedule();
-		mem_cgroup_unmark_under_oom(memcg);
-		finish_wait(&memcg_oom_waitq, &owait.wait);
-	}
+	schedule();
+	mem_cgroup_unmark_under_oom(memcg);
+	finish_wait(&memcg_oom_waitq, &owait.wait);
 
 	if (locked) {
 		mem_cgroup_oom_unlock(memcg);
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

mm-mm_initc-drop-nid-parameter-from-check_for_memory.patch
mm-memory_hotplug-remove-reset_node_managed_pages-in-hotadd_init_pgdat.patch
mm-mm_initc-remove-reset_node_present_pages.patch
fork-optimize-memcg_charge_kernel_stack-a-bit.patch

