Return-Path: <SRS0=9IPz=EN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5836BC2D0A3
	for <mm-commits@archiver.kernel.org>; Sat,  7 Nov 2020 01:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E939E20825
	for <mm-commits@archiver.kernel.org>; Sat,  7 Nov 2020 01:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604713040;
	bh=lDpeCMZ620LzgWpwE1D+vYdnn4cUE2qjyKnLdsQ1Vbw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=bT0wFwuuA5RJrArcElpPsoudjL6lM6IF+xFmgDXrUOOE8akjtI2P84XEd6lZsbcJg
	 GFue6+XNNkrWjYkD4gr/r7c25jTQiTkyl/bW2nW0AFydZheA+pmAmaykepqqRowTXH
	 +POL69Yib35MAI9G3zSCwtghgCjcU/eIx/gMZb4c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgKGBhT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Nov 2020 20:37:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727129AbgKGBhT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Nov 2020 20:37:19 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 096C92078B;
        Sat,  7 Nov 2020 01:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604713038;
        bh=lDpeCMZ620LzgWpwE1D+vYdnn4cUE2qjyKnLdsQ1Vbw=;
        h=Date:From:To:Subject:From;
        b=u54zJCjBLyv50Jg01IBhqQzktax7WHEIne/2ukIQcM1Od7OYdob1Riu7BLhEB1xkX
         6Lx+lWuFn4c8xzISpTy+ckJ9o9HuP7zgy2UqTcvIdQoL7wQO82/Ayb31fydag03E6Z
         RvdeOaOTfBMWE1xPkUySF+DCPARq4kC6faFZhTbg=
Date:   Fri, 06 Nov 2020 17:37:17 -0800
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        laoar.shao@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, songmuchun@bytedance.com, tj@kernel.org
Subject:  + mm-memcontrol-fix-missing-wakeup-polling-thread.patch
 added to -mm tree
Message-ID: <20201107013717.xM0c5wNf0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix missing wakeup polling thread
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-missing-wakeup-polling-thread.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-missing-wakeup-polling-thread.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-missing-wakeup-polling-thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcontrol-fix-missing-wakeup-polling-thread.patch
mm-memcontrol-remove-unused-mod_memcg_obj_state.patch
mm-memcg-slab-fix-return-child-memcg-objcg-for-root-memcg.patch

