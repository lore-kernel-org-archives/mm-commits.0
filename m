Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45DC8C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 20:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09BA42388E
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 20:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgLRUGj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:06:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgLRUGj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 15:06:39 -0500
Date:   Fri, 18 Dec 2020 12:05:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608321959;
        bh=2Uew3lYLwfxQwgA0gZu0jhXf5/xzWOwEq121o0MwZB8=;
        h=From:To:Subject:From;
        b=REmCtyNaIR0u+i2piHzV2BwBGGQCloRhZKboHJg+dgdxVHXQxwlAANw4FCrdRuwFq
         /ebF+HYhGECGtSFmHnqNpKagQj2zkJHaIfBmi3B8WIV+HJP3Oslz0afRbnq7Tlfa1p
         VudgPVjAPNm2MDPJWwkdphLdSd4LBBHcJwuFTCdg=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sh_def@163.com, shakeelb@google.com,
        sfr@canb.auug.org.au, richard.weiyang@gmail.com, mhocko@suse.com,
        laoar.shao@gmail.com, hannes@cmpxchg.org, guro@fb.com,
        alex.shi@linux.alibaba.com, alexander.h.duyck@linux.intel.com,
        lstoakes@gmail.com
Subject:  [folded-merged]
 mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix-fix.patch removed from -mm
 tree
Message-ID: <20201218200558.6RuZ6%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: warn on missing memcg on mem_cgroup_page_lruvec()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix-fix.patch

This patch was dropped because it was folded into mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/memcg: warn on missing memcg on mem_cgroup_page_lruvec()

Move memcg check to mem_cgroup_page_lruvec() as there are callers which
may invoke this with !memcg in mem_cgroup_lruvec(), whereas they should
not in mem_cgroup_page_lruvec().

We expect that we have always charged a page to the memcg before
mem_cgroup_page_lruvec() is invoked, so add a warning to assert that this
is the case.

Link: https://lkml.kernel.org/r/20201125112202.387009-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reported-by: syzbot+ce635500093181f39c1c@syzkaller.appspotmail.com
Acked-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
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

 include/linux/memcontrol.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix-fix
+++ a/include/linux/memcontrol.h
@@ -613,8 +613,6 @@ static inline struct lruvec *mem_cgroup_
 	struct mem_cgroup_per_node *mz;
 	struct lruvec *lruvec;
 
-	VM_WARN_ON_ONCE(!memcg);
-
 	if (mem_cgroup_disabled()) {
 		lruvec = &pgdat->__lruvec;
 		goto out;
@@ -646,7 +644,10 @@ out:
 static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
 						struct pglist_data *pgdat)
 {
-	return mem_cgroup_lruvec(page_memcg(page), pgdat);
+	struct mem_cgroup *memcg = page_memcg(page);
+
+	VM_WARN_ON_ONCE_PAGE(!memcg, page);
+	return mem_cgroup_lruvec(memcg, pgdat);
 }
 
 static inline bool lruvec_holds_page_lru_lock(struct page *page,
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

