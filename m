Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46489C43331
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jan 2021 00:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 214C923131
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jan 2021 00:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbhAMAms (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 19:42:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391937AbhALXtx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Jan 2021 18:49:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FE9423133;
        Tue, 12 Jan 2021 23:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610495352;
        bh=8koHiLzr5itWHBQjzON8eFAiTv4vMLkrNnLaFsHT9XY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lvXeWdYGaZjPsNQua6b0I/SrPqjOlXOMOSbc4SSJ5y3fgoy912qIodtDGyb0YU1bi
         zeBUIy/iJxOm0/sQl8fQt/8zI+wXmqrXhZ4k+6awc8FaEm2eT1u0esMXL19rvNxbT6
         SQ8iwPzepdSWuLj/FBlwrJbZtdbHsqfTUORb/t4Q=
Date:   Tue, 12 Jan 2021 15:49:11 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        bhe@redhat.com, chris@chrisdown.name, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com, linux-mm@kvack.org,
        lstoakes@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        sh_def@163.com, shakeelb@google.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 03/10] mm/memcontrol: fix warning in
 mem_cgroup_page_lruvec()
Message-ID: <20210112234911.PDWRysjU0%akpm@linux-foundation.org>
In-Reply-To: <20210112154839.abeb6e57de79480059fd9b0e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: mm/memcontrol: fix warning in mem_cgroup_page_lruvec()

Boot a CONFIG_MEMCG=y kernel with "cgroup_disabled=memory" and you are met
by a series of warnings from the VM_WARN_ON_ONCE_PAGE(!memcg, page)
recently added to the inline mem_cgroup_page_lruvec().

An earlier attempt to place that warning, in mem_cgroup_lruvec(), had been
careful to do so after weeding out the mem_cgroup_disabled() case; but was
itself invalid because of the mem_cgroup_lruvec(NULL, pgdat) in
clear_pgdat_congested() and age_active_anon().

Warning in mem_cgroup_page_lruvec() was once useful in detecting a KSM
charge bug, so may be worth keeping: but skip if mem_cgroup_disabled().

Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2101032056260.1093@eggly.anvils
Fixes: 9a1ac2288cf1 ("mm/memcontrol:rewrite mem_cgroup_page_lruvec()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hui Su <sh_def@163.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-fix-warning-in-mem_cgroup_page_lruvec
+++ a/include/linux/memcontrol.h
@@ -665,7 +665,7 @@ static inline struct lruvec *mem_cgroup_
 {
 	struct mem_cgroup *memcg = page_memcg(page);
 
-	VM_WARN_ON_ONCE_PAGE(!memcg, page);
+	VM_WARN_ON_ONCE_PAGE(!memcg && !mem_cgroup_disabled(), page);
 	return mem_cgroup_lruvec(memcg, pgdat);
 }
 
_
