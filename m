Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24B0C76196
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjC1XQg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjC1XQg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:16:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1802716
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:16:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B3A4B81F4E
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DE6C433D2;
        Tue, 28 Mar 2023 23:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045389;
        bh=TOl8sCB34Dz+VQ9FDhpfYO26EqjxoKvrgWpCij1TJl0=;
        h=Date:To:From:Subject:From;
        b=tg0mhY0o9kn7yYrfg546PQclVneN1hK1zqOX8yGjLbA92uoOn8+I2500UKmGXppBs
         iIOg1R4IEOZsvEF7dXVUy+syfOrlJXyCY9vbDL+jVrozxjl0lcB/D1pkGlrt6LE4Wh
         vXjnLeGRPTHR/AQ4m7GnQs7GEtQmhtbHM3yLX4FY=
Date:   Tue, 28 Mar 2023 16:16:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tangyeechou@gmail.com, shakeelb@google.com,
        roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, findns94@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcg-prevent-memoryoom_control-load-store-tearing-v3.patch removed from -mm tree
Message-Id: <20230328231629.B2DE6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memcg-prevent-memoryoom_control-load-store-tearing-v3
has been removed from the -mm tree.  Its filename was
     mm-memcg-prevent-memoryoom_control-load-store-tearing-v3.patch

This patch was dropped because it was folded into mm-memcg-prevent-memoryoom_control-load-store-tearing.patch

------------------------------------------------------
From: Yue Zhao <findns94@gmail.com>
Subject: mm-memcg-prevent-memoryoom_control-load-store-tearing-v3
Date: Thu, 9 Mar 2023 00:25:54 +0800

Add [WRITE|READ]_ONCE for all occurrences of memcg->oom_kill_disable,
memcg->swappiness and memcg->soft_limit

Link: https://lkml.kernel.org/r/20230308162555.14195-4-findns94@gmail.com
Signed-off-by: Yue Zhao <findns94@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tang Yizhou <tangyeechou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-prevent-memoryoom_control-load-store-tearing-v3
+++ a/mm/memcontrol.c
@@ -1929,7 +1929,7 @@ static bool mem_cgroup_oom(struct mem_cg
 	 * Please note that mem_cgroup_out_of_memory might fail to find a
 	 * victim and then we have to bail out from the charge path.
 	 */
-	if (memcg->oom_kill_disable) {
+	if (READ_ONCE(memcg->oom_kill_disable)) {
 		if (current->in_user_fault) {
 			css_get(&memcg->css);
 			current->memcg_in_oom = memcg;
@@ -1999,7 +1999,7 @@ bool mem_cgroup_oom_synchronize(bool han
 	if (locked)
 		mem_cgroup_oom_notify(memcg);
 
-	if (locked && !memcg->oom_kill_disable) {
+	if (locked && !READ_ONCE(memcg->oom_kill_disable)) {
 		mem_cgroup_unmark_under_oom(memcg);
 		finish_wait(&memcg_oom_waitq, &owait.wait);
 		mem_cgroup_out_of_memory(memcg, current->memcg_oom_gfp_mask,
@@ -5354,7 +5354,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
-		memcg->oom_kill_disable = parent->oom_kill_disable;
+		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 
 		page_counter_init(&memcg->memory, &parent->memory);
 		page_counter_init(&memcg->swap, &parent->swap);
_

Patches currently in -mm which might be from findns94@gmail.com are

mm-memcg-prevent-memoryoomgroup-load-store-tearing.patch
mm-memcg-prevent-memoryswappiness-load-store-tearing.patch
mm-memcg-prevent-memoryoom_control-load-store-tearing.patch
mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing.patch
mm-memcg-prevent-memorysoft_limit_in_bytes-load-store-tearing-v3.patch

