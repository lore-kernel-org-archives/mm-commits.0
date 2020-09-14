Return-Path: <SRS0=BOB0=CX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42759C433E2
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 03:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C291221E7
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 03:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600052646;
	bh=zM0l0YVhO6M5w/EO1TAx1kdTHG35HIUPGNLGCXVX7WY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ipWitZnqk0fbWOjZQ/CfJgTuVoOvVZP3cTNRBnc2glFAQOxh9MgAKMzY22nLd1coK
	 wBQ7MTEUEiS5uCBiVP/AtJgK6BFlwPkx6PO7C5LW5mq3IeFJFnakeSWJQAnaUKJLMK
	 /Oy6IfE7A206wj5gbkFMhS5+zDvFkYuqf/O8jTcA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgINDEE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Sep 2020 23:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbgINDD5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Sep 2020 23:03:57 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A33B921D91;
        Mon, 14 Sep 2020 03:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600052636;
        bh=zM0l0YVhO6M5w/EO1TAx1kdTHG35HIUPGNLGCXVX7WY=;
        h=Date:From:To:Subject:From;
        b=bm35lKfCrMe47jTLwo+X/V9ItEayLuVCX/sGYWDFZ5zxeVhvDI4zqTuPrJ5j7Iomt
         FcOB4Is4GlxLd1i3712ZoHJjaw0VmnOnCoViB0QK9zd6g9s4/xVUdDuZTsda2Vd0fL
         FbTJ0W7B0DbDjedf46YJEmE55scB1ZDIq7Dvrux4=
Date:   Sun, 13 Sep 2020 20:03:56 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, tj@kernel.org,
        shakeelb@google.com, mhocko@kernel.org, laoar.shao@gmail.com,
        hannes@cmpxchg.org, guro@fb.com, chris@chrisdown.name,
        longman@redhat.com
Subject:  + mm-memcg-simplify-mem_cgroup_get_max.patch added to -mm
 tree
Message-ID: <20200914030356.RkWtF%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: simplify mem_cgroup_get_max()
has been added to the -mm tree.  Its filename is
     mm-memcg-simplify-mem_cgroup_get_max.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-simplify-mem_cgroup_get_max.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-simplify-mem_cgroup_get_max.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/memcg: simplify mem_cgroup_get_max()

mem_cgroup_get_max() used to get memory+swap max from both the v1 memsw
and v2 memory+swap page counters & return the maximum of these 2 values. 
This is redundant and it is more efficient to just get either the v1 or
the v2 values depending on which one is currently in use.

Link: https://lkml.kernel.org/r/20200914024452.19167-3-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-simplify-mem_cgroup_get_max
+++ a/mm/memcontrol.c
@@ -1635,17 +1635,15 @@ void mem_cgroup_print_oom_meminfo(struct
  */
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 {
-	unsigned long max;
+	unsigned long max = READ_ONCE(memcg->memory.max);
 
-	max = READ_ONCE(memcg->memory.max);
-	if (mem_cgroup_swappiness(memcg)) {
-		unsigned long memsw_max;
-		unsigned long swap_max;
-
-		memsw_max = memcg->memsw.max;
-		swap_max = READ_ONCE(memcg->swap.max);
-		swap_max = min(swap_max, (unsigned long)total_swap_pages);
-		max = min(max + swap_max, memsw_max);
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		if (mem_cgroup_swappiness(memcg))
+			max += min(READ_ONCE(memcg->swap.max),
+				   (unsigned long)total_swap_pages);
+	} else { /* v1 */
+		if (mem_cgroup_swappiness(memcg))
+			max = memcg->memsw.max;
 	}
 	return max;
 }
_

Patches currently in -mm which might be from longman@redhat.com are

mm-memcg-clean-up-obsolete-enum-charge_type.patch
mm-memcg-simplify-mem_cgroup_get_max.patch
mm-memcg-unify-swap-and-memsw-page-counters.patch

