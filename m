Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B546FC56202
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 06:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EBE322275
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 06:52:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="yolKLRx3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgKNGwP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Nov 2020 01:52:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgKNGwP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Nov 2020 01:52:15 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE7A82073C;
        Sat, 14 Nov 2020 06:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605336734;
        bh=txYzGlXLa5mPXDnjMFwIXgMd5cjv6DsXtkBsMH3Cf0w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yolKLRx35tFNzKgHsH/EIQwaGyB4eOK6FMMEaQuOeZtOusPZBUgeQGSRzrFBP1gWw
         9Cj2Fs47xgX5l/a+JWpYxNTuI0WGq8i/MikbPl34hDvC7cTxPDZPUk5tf4AlBSiF2u
         uINyE5Oi+O4Va/n4ea2o3+s+bNDQ4cLWTlMwy1Nc=
Date:   Fri, 13 Nov 2020 22:52:13 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com,
        hannes@cmpxchg.org, laoar.shao@gmail.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 11/14] mm: memcontrol: fix missing wakeup polling
 thread
Message-ID: <20201114065213.9dBGa4C_W%akpm@linux-foundation.org>
In-Reply-To: <20201113225115.b24faebc85f710d5aff55aa7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
