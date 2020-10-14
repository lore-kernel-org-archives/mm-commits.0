Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2EE1C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 772B022248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709218;
	bh=nJBAC+RH6PdD55g1hdQSpKSfej2d8sgvQrlHIcDl6Fg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=TCwkdTTIaRmgBGrep8ZUpYHYfbGMDyBhqzgsPSGwIEXedtjrYGbINXYbV6cCxSDDK
	 YIn00nFHf6aT15XsLPRhcpgeZog7R8W6ejEyw5DggujpFYtWGMUBtX7S+AOdMmabVu
	 jIGiTkSfXD6ddLXlyCjHgmSwYP1oaXVpU5W+C5EU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgJNVAS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgJNVAS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:00:18 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6C8720725;
        Wed, 14 Oct 2020 21:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709217;
        bh=nJBAC+RH6PdD55g1hdQSpKSfej2d8sgvQrlHIcDl6Fg=;
        h=Date:From:To:Subject:From;
        b=aAQhqf61RMMw8QfWV6H84I/cMZPDZRxYe9+w1J8aXLrznuEWpZWeuZqVWA0uUws5E
         Hets+VDmwjyvCmWIY9bSOJoy/s96zU1TtIxXbpwox2Mh70hLHgma/qPoXed+RwFG57
         6fPuJKp122Cra52ovfaeAC9biXbN4bDpac/1H8SU=
Date:   Wed, 14 Oct 2020 14:00:16 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        laoar.shao@gmail.com, longman@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        vdavydov.dev@gmail.com
Subject:  [merged] mm-memcg-simplify-mem_cgroup_get_max.patch
 removed from -mm tree
Message-ID: <20201014210016.cUTZgtDoy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: simplify mem_cgroup_get_max()
has been removed from the -mm tree.  Its filename was
     mm-memcg-simplify-mem_cgroup_get_max.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from longman@redhat.com are


