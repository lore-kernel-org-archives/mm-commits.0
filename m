Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B23CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 23 Dec 2021 00:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344934AbhLWAGQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Dec 2021 19:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbhLWAGQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Dec 2021 19:06:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A03CC061574
        for <mm-commits@vger.kernel.org>; Wed, 22 Dec 2021 16:06:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E48B961D2F
        for <mm-commits@vger.kernel.org>; Thu, 23 Dec 2021 00:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001A6C36AE5;
        Thu, 23 Dec 2021 00:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640217974;
        bh=fyTsw0TrRaYzImcT2ozzbHmGWhc+cwv3lPXQ6mi+9ZY=;
        h=Date:From:To:Subject:From;
        b=oKqjOCp2TjY6gMg2S6dv0K/XJlsctE+zKM+QYdCrSRqNEpQAAg0l7R9HhyZgSndyQ
         fKGyqDk8DqP8l/FoU0jUTwVr66r0tQXajmT3JnjBr+jjnqfjHoQkiFxYve8JOLU9Wn
         EUv7gRy3PsBmZAZyRvktxZHCIoFKVTivrJk/WQv0=
Date:   Wed, 22 Dec 2021 16:06:12 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mhocko@kernel.org, hannes@cmpxchg.org, guro@fb.com,
        shakeelb@google.com
Subject:  + memcg-add-per-memcg-vmalloc-stat-v2.patch added to -mm
 tree
Message-ID: <20211223000612.htHl1%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-add-per-memcg-vmalloc-stat-v2
has been added to the -mm tree.  Its filename is
     memcg-add-per-memcg-vmalloc-stat-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-add-per-memcg-vmalloc-stat-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-add-per-memcg-vmalloc-stat-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
memcg-add-per-memcg-vmalloc-stat-v2.patch

