Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792BDC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3422D22228
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633202;
	bh=GsqS/Xwtlrvn7edcABt4EEtI1PvfH5Sex6icl7pulKI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=jgt5JuPzJ/999PoikqUq5icUV1L7eVmJ21V+8U/LfDRdYdDhokxiXwKP3E66+yt5F
	 5jjpmmymqS4J7zqQFQgGJ8SbstZ1FSjPEElINhLWxMYwiK1L7X5RMZt/8L2KqI3S+Z
	 8X5vDnkzepJy7Ee/x8FIaCPlG1pKEeTBFPHhqG3o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbgJMXxV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729175AbgJMXwx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2042D21D7B;
        Tue, 13 Oct 2020 23:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633173;
        bh=GsqS/Xwtlrvn7edcABt4EEtI1PvfH5Sex6icl7pulKI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nVeFpm0beENY8LC79h2dgI8eHLCcgo8Dee0tNUb/BhgWWM2VSF6/f/HHMagBXc+jZ
         EP5zr0NtC/GDP5gJ8uEd3LBBMTsIVZb7QTDvXaRhJyrhoyb3oiJiYmCkdCTJrArtv9
         GwUrdA5m26ys1tfMzUS6ogjUtL9VdztmoifHgZ58=
Date:   Tue, 13 Oct 2020 16:52:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com,
        hannes@cmpxchg.org, laoar.shao@gmail.com, linux-mm@kvack.org,
        longman@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, tj@kernel.org, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 083/181] mm/memcg: simplify mem_cgroup_get_max()
Message-ID: <20201013235252.ZUa46-9eO%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Waiman Long <longman@redhat.com>
Subject: mm/memcg: simplify mem_cgroup_get_max()

mem_cgroup_get_max() used to get memory+swap max from both the v1 memsw
and v2 memory+swap page counters & return the maximum of these 2 values. 
This is redundant and it is more efficient to just get either the v1 or
the v2 values depending on which one is currently in use.

[longman@redhat.com: v4]
  Link: https://lkml.kernel.org/r/20200914150928.7841-1-longman@redhat.com
Link: https://lkml.kernel.org/r/20200914024452.19167-3-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-simplify-mem_cgroup_get_max
+++ a/mm/memcontrol.c
@@ -1633,17 +1633,19 @@ void mem_cgroup_print_oom_meminfo(struct
  */
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 {
-	unsigned long max;
+	unsigned long max = READ_ONCE(memcg->memory.max);
 
-	max = READ_ONCE(memcg->memory.max);
-	if (mem_cgroup_swappiness(memcg)) {
-		unsigned long memsw_max;
-		unsigned long swap_max;
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		if (mem_cgroup_swappiness(memcg))
+			max += min(READ_ONCE(memcg->swap.max),
+				   (unsigned long)total_swap_pages);
+	} else { /* v1 */
+		if (mem_cgroup_swappiness(memcg)) {
+			/* Calculate swap excess capacity from memsw limit */
+			unsigned long swap = READ_ONCE(memcg->memsw.max) - max;
 
-		memsw_max = memcg->memsw.max;
-		swap_max = READ_ONCE(memcg->swap.max);
-		swap_max = min(swap_max, (unsigned long)total_swap_pages);
-		max = min(max + swap_max, memsw_max);
+			max += min(swap, (unsigned long)total_swap_pages);
+		}
 	}
 	return max;
 }
_
