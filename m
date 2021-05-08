Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C753C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 828926141D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhEHWmC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWmA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D55D61415;
        Sat,  8 May 2021 22:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513658;
        bh=5l7iT9SERMpOwEopw7NBu0YkZq+QCtvVV/r7AMs/52Q=;
        h=Date:From:To:Subject:From;
        b=D+JCMXyCAtKbWz80U/GQRXcjajBTnIHCGDOwv2QHiZ4NOKgDiRS0MBM639Zn2IbKT
         DyRXb2UcpKDXULnCntMoflbR5H7fGzi+X2H3oTvhlK1Gjg9oKkOSjEeao8cjySnkYS
         IotaC06nKmo2iSzjfr91yzYo2DCfGkLiPC5rzISE=
Date:   Sat, 08 May 2021 15:40:58 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged] memcg-cleanup-root-memcg-checks.patch removed
 from -mm tree
Message-ID: <20210508224058.uf8exWgy0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: cleanup root memcg checks
has been removed from the -mm tree.  Its filename was
     memcg-cleanup-root-memcg-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: cleanup root memcg checks

Replace the implicit checking of root memcg with explicit root memcg
checking i.e.  !css->parent with mem_cgroup_is_root().

Link: https://lkml.kernel.org/r/20210223205625.2792891-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-cleanup-root-memcg-checks
+++ a/mm/memcontrol.c
@@ -4123,7 +4123,7 @@ static int mem_cgroup_swappiness_write(s
 	if (val > 100)
 		return -EINVAL;
 
-	if (css->parent)
+	if (!mem_cgroup_is_root(memcg))
 		memcg->swappiness = val;
 	else
 		vm_swappiness = val;
@@ -4473,7 +4473,7 @@ static int mem_cgroup_oom_control_write(
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
 	/* cannot set to root cgroup and only 0 and 1 are allowed */
-	if (!css->parent || !((val == 0) || (val == 1)))
+	if (mem_cgroup_is_root(memcg) || !((val == 0) || (val == 1)))
 		return -EINVAL;
 
 	memcg->oom_kill_disable = val;
_

Patches currently in -mm which might be from shakeelb@google.com are


