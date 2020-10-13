Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38538C43467
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E70A522201
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633201;
	bh=9OjnVqTbjR3zE+/OgtAFul/0ZWu3KIYj0sbrX/HM/Hc=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=SjfTDwnCCphhkMgLrzCbxzbyU9F2q8/IhO00ClnGIiWPnzpxkZ6qMs24dwAHByEI9
	 j+SklatHrBIadCnGM/d/p4EKTy0oet8jwy7xjDidOsmDLno8dPvYY4M0PHp+ep78zW
	 imAlIO6LMhWRH8Xd+SkJND2RK+cHC2/MiDravT4U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgJMXxU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729373AbgJMXxG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:53:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D187206D5;
        Tue, 13 Oct 2020 23:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633186;
        bh=9OjnVqTbjR3zE+/OgtAFul/0ZWu3KIYj0sbrX/HM/Hc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GpOg8gU75N/GtHGK12piUG1HhREXBDhGCtyhQmInMdq8qy5XrZYaVwHVOY3CWTeum
         30Ru+18aol0cQn0zuTleW8WY/ZzjnB/3+rbNIfMQYlFFbJrLUTGfbR15R4M7mP71kp
         F6ugGYpXhE8yrlcFVVHoMi20ettyiu4EJGHhT2QQ=
Date:   Tue, 13 Oct 2020 16:53:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org,
        linmiaohe@huawei.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 087/181] mm: memcontrol: reword obsolete comment
 of mem_cgroup_unmark_under_oom()
Message-ID: <20201013235305.5-1oHu1qh%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memcontrol: reword obsolete comment of mem_cgroup_unmark_under_oom()

Since commit 79dfdaccd1d5 ("memcg: make oom_lock 0 and 1 based rather than
counter"), the mem_cgroup_unmark_under_oom() is added and the comment of
the mem_cgroup_oom_unlock() is moved here.  But this comment make no sense
here because mem_cgroup_oom_lock() does not operate on under_oom field. 
So we reword the comment as this would be helpful.  [Thanks Michal Hocko
for rewording this comment.]

Link: https://lkml.kernel.org/r/20200930095336.21323-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-reword-obsolete-comment-of-mem_cgroup_unmark_under_oom
+++ a/mm/memcontrol.c
@@ -1826,8 +1826,8 @@ static void mem_cgroup_unmark_under_oom(
 	struct mem_cgroup *iter;
 
 	/*
-	 * When a new child is created while the hierarchy is under oom,
-	 * mem_cgroup_oom_lock() may not be called. Watch for underflow.
+	 * Be careful about under_oom underflows becase a child memcg
+	 * could have been added after mem_cgroup_mark_under_oom.
 	 */
 	spin_lock(&memcg_oom_lock);
 	for_each_mem_cgroup_tree(iter, memcg)
_
