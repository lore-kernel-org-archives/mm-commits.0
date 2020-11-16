Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE650C61DD8
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 18:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DF3722450
	for <mm-commits@archiver.kernel.org>; Mon, 16 Nov 2020 18:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="KLCiB4Xu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgKPSmg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Nov 2020 13:42:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbgKPSlh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 16 Nov 2020 13:41:37 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAB7D20888;
        Mon, 16 Nov 2020 18:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605552097;
        bh=PQCJjtVueW7eRPDdUb6g/VfFEkt2q1VvgIKS7fPnags=;
        h=Date:From:To:Subject:From;
        b=KLCiB4XuVLo2TNcC40Ytqgiy6960VAJTR8T/62ftyeUa0hCgRYvhBawM0vuRd++Yt
         piS3Om3Cpjsi2J46PHEKjn4myYmdSK6h4w0/jxizbwq04xeSFtUHbq9hNyb6+gSEjM
         j58GmxAJbtAnbsGsxt618iM1vlDN0MGrhcbcyex0=
Date:   Mon, 16 Nov 2020 10:41:36 -0800
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        laoar.shao@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, songmuchun@bytedance.com, tj@kernel.org
Subject:  [merged]
 mm-memcontrol-fix-missing-wakeup-polling-thread.patch removed from -mm tree
Message-ID: <20201116184136.ha3gAAwhd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix missing wakeup polling thread
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-missing-wakeup-polling-thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix missing wakeup polling thread

When we poll the swap.events, we can miss being woken up when the swap
event occurs.  Because we didn't notify.

Link: https://lkml.kernel.org/r/20201105161936.98312-1-songmuchun@bytedance.com
Fixes: f3a53a3a1e5b ("mm, memcontrol: implement memory.swap.events")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-fix-missing-wakeup-polling-thread
+++ a/include/linux/memcontrol.h
@@ -900,12 +900,19 @@ static inline void count_memcg_event_mm(
 static inline void memcg_memory_event(struct mem_cgroup *memcg,
 				      enum memcg_memory_event event)
 {
+	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
+			  event == MEMCG_SWAP_FAIL;
+
 	atomic_long_inc(&memcg->memory_events_local[event]);
-	cgroup_file_notify(&memcg->events_local_file);
+	if (!swap_event)
+		cgroup_file_notify(&memcg->events_local_file);
 
 	do {
 		atomic_long_inc(&memcg->memory_events[event]);
-		cgroup_file_notify(&memcg->events_file);
+		if (swap_event)
+			cgroup_file_notify(&memcg->swap_events_file);
+		else
+			cgroup_file_notify(&memcg->events_file);
 
 		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 			break;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcg-slab-fix-root-memcg-vmstats.patch
mm-memcontrol-remove-unused-mod_memcg_obj_state.patch
mm-memcg-slab-fix-return-child-memcg-objcg-for-root-memcg.patch
mm-memcg-slab-fix-use-after-free-in-obj_cgroup_charge.patch

