Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833D2C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiANVZj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiANVZi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:25:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F59BC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 13:25:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 171E3B82A34
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9B5C36AE5;
        Fri, 14 Jan 2022 21:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642195535;
        bh=PfPr3KgsOAdCOR0bYC6FwIBlyDaXmZ8mCzd9RkokM9A=;
        h=Date:From:To:Subject:From;
        b=kJGX4AMWSLEc+bWrpLVWH734tJeCkCHnpzqGeL/pYYGo35pZg2/Ep36vaF6/xahs3
         eemE/BuGPazdKGUHSt8O6FPirnXIphxBqyO/LaSgRKQksB1LVfL4HM4yZHEAhluR/w
         4HLV65CzCicDwz0q0scJNwTGOdbg8x1KT1Wrus4U=
Date:   Fri, 14 Jan 2022 13:25:35 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com
Subject:  [folded-merged] memcg-add-per-memcg-vmalloc-stat-v2.patch
 removed from -mm tree
Message-ID: <20220114212535.z6avPVXLe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-add-per-memcg-vmalloc-stat-v2
has been removed from the -mm tree.  Its filename was
     memcg-add-per-memcg-vmalloc-stat-v2.patch

This patch was dropped because it was folded into memcg-add-per-memcg-vmalloc-stat.patch

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg-add-per-memcg-vmalloc-stat-v2

page_memcg() within rcu lock, per Muchun

Link: https://lkml.kernel.org/r/20211222052457.1960701-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~memcg-add-per-memcg-vmalloc-stat-v2
+++ a/include/linux/memcontrol.h
@@ -996,10 +996,16 @@ static inline void mod_memcg_state(struc
 static inline void mod_memcg_page_state(struct page *page,
 					int idx, int val)
 {
-	struct mem_cgroup *memcg = page_memcg(page);
+	struct mem_cgroup *memcg;
 
-	if (!mem_cgroup_disabled() && memcg)
+	if (mem_cgroup_disabled())
+		return;
+
+	rcu_read_lock();
+	memcg = page_memcg(page);
+	if (memcg)
 		mod_memcg_state(memcg, idx, val);
+	rcu_read_unlock();
 }
 
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-better-bounds-on-the-memcg-stats-updates.patch
memcg-add-per-memcg-vmalloc-stat.patch
memcg-add-per-memcg-vmalloc-stat-v4.patch

