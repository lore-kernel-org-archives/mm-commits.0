Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7485C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6295F23B87
	for <mm-commits@archiver.kernel.org>; Fri, 18 Dec 2020 22:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgLRWCJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Dec 2020 17:02:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbgLRWCJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Dec 2020 17:02:09 -0500
Date:   Fri, 18 Dec 2020 14:01:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608328889;
        bh=S+FtJ3ySdURLoRj1IigrxxOmVpvlhvou+RKM3lV6+W4=;
        h=From:To:Subject:In-Reply-To:From;
        b=bw9iNG+SVxnG7z0/MrvumB8tDTID7IKTXTo5a1Wpw1AmTVf+rh8CTUGA6XQ4Hbou9
         wokr98ieiaUoUAW805cAD5kOupvrio/vwk1TpaNWiQMmvOxUQIcS7M7yH0YbAc4tFN
         pIaYaxYNpneCMffm96ZpsTYoKIZLGC5zqmIw0tGo=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vdavydov.dev@gmail.com
Subject:  [patch 01/78] mm/memcg: bail early from swap accounting
 if memcg disabled
Message-ID: <20201218220128.vmNwvyXdi%akpm@linux-foundation.org>
In-Reply-To: <20201218140046.497484741326828e5b5d46ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/memcg: bail early from swap accounting if memcg disabled

Patch series "bail out early for memcg disable".

These 2 patches are indepenedent from per memcg lru lock, and may
encounter unexpected warning, so let's move out them from per memcg
lru locking patchset.


This patch (of 2):

We could bail out early when memcg wasn't enabled.

Link: https://lkml.kernel.org/r/1604283436-18880-1-git-send-email-alex.shi@linux.alibaba.com
Link: https://lkml.kernel.org/r/1604283436-18880-2-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-bail-early-from-swap-accounting-if-memcg-disabled
+++ a/mm/memcontrol.c
@@ -7178,6 +7178,9 @@ void mem_cgroup_swapout(struct page *pag
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 	VM_BUG_ON_PAGE(page_count(page), page);
 
+	if (mem_cgroup_disabled())
+		return;
+
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
@@ -7242,6 +7245,9 @@ int mem_cgroup_try_charge_swap(struct pa
 	struct mem_cgroup *memcg;
 	unsigned short oldid;
 
+	if (mem_cgroup_disabled())
+		return 0;
+
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return 0;
 
_
