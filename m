Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFBCC4361B
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 20:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDEB22343F
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 20:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgLRUGg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:06:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:43998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgLRUGg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 15:06:36 -0500
Date:   Fri, 18 Dec 2020 12:05:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608321955;
        bh=lo37o1+aEqbFBdKF+BwXvAjJnkBqf42zHE1KJnJO5HA=;
        h=From:To:Subject:From;
        b=rMKi+/9ai3XrO+US3i89+X55rjau8Kk7bBDNB0br/fic9cffMAFvxhhCnTYYU9M0L
         TT3g3IxV/0pzAHLH9WfYEeVnhNJdt1UxQqwi5RjIGTEthYOVyeseeO6sSyO3bQ44n8
         O/Tf+D9B24/rFiN4Kp7RJNukCgbb+4G4ahAh56vA=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sh_def@163.com, shakeelb@google.com,
        richard.weiyang@gmail.com, mhocko@suse.com, laoar.shao@gmail.com,
        hannes@cmpxchg.org, guro@fb.com, alexander.h.duyck@linux.intel.com,
        alex.shi@linux.alibaba.com
Subject:  [folded-merged]
 mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch removed from -mm tree
Message-ID: <20201218200554.jYxUg%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: add missed warning in mem_cgroup_lruvec
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix.patch

This patch was dropped because it was folded into mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/memcg: add missed warning in mem_cgroup_lruvec

commit "(mm/memcontrol:rewrite mem_cgroup_page_lruvec())" on mm tree use
mem_cgroup_lruvec to rewrite mem_cgroup_page_lruvec, but it missed a
DEBUG_VM warning as following, since we always charge a page before
return from allocation. Add back this warning is helpful:

	VM_WARN_ON_ONCE(!memcg);

Link: https://lkml.kernel.org/r/94f17bb7-ec61-5b72-3555-fabeb5a4d73b@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Hui Su <sh_def@163.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/memcontrol.h~mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix
+++ a/include/linux/memcontrol.h
@@ -613,6 +613,8 @@ static inline struct lruvec *mem_cgroup_
 	struct mem_cgroup_per_node *mz;
 	struct lruvec *lruvec;
 
+	VM_WARN_ON_ONCE(!memcg);
+
 	if (mem_cgroup_disabled()) {
 		lruvec = &pgdat->__lruvec;
 		goto out;
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled.patch
mm-memcg-warning-on-memcg-after-readahead-page-charged.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

