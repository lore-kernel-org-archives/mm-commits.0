Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8883C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B50FB61C7A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhGFTOS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:14:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231857AbhGFTOS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:14:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D17E61C6D;
        Tue,  6 Jul 2021 19:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598698;
        bh=KIBgp0owr4QlZsHMQPlNlXmh0VHQYAkq47BjGj0L7RA=;
        h=Date:From:To:Subject:From;
        b=yF1I1VjLO3ANT6tB63A8bqfbA3FyDJgc4YdmLv0sbbtdrqLn3qrowy+ciBX2S+px4
         jx0TaA+QMXbORKlhljVIMkwBGPTaXTZFiwlY/jrI+djlEZh39p2MZ1HWsBwpVvtBQZ
         FF4HHMbzBaLziKii58W12TWUvYnAXrAHDSijDxis=
Date:   Tue, 06 Jul 2021 12:11:38 -0700
From:   akpm@linux-foundation.org
To:     duanxiongchun@bytedance.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-bail-out-early-when-mm-in-get_mem_cgroup_from_mm.patch
 removed from -mm tree
Message-ID: <20210706191138.T7eSoMmEI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: bail out early when !mm in get_mem_cgroup_from_mm
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-bail-out-early-when-mm-in-get_mem_cgroup_from_mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: bail out early when !mm in get_mem_cgroup_from_mm

When mm is NULL, we do not need to hold rcu lock and call css_tryget for
the root memcg.  And we also do not need to check !mm in every loop of
while.  So bail out early when !mm.

Link: https://lkml.kernel.org/r/20210417043538.9793-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-bail-out-early-when-mm-in-get_mem_cgroup_from_mm
+++ a/mm/memcontrol.c
@@ -919,20 +919,23 @@ struct mem_cgroup *get_mem_cgroup_from_m
 	if (mem_cgroup_disabled())
 		return NULL;
 
+	/*
+	 * Page cache insertions can happen without an
+	 * actual mm context, e.g. during disk probing
+	 * on boot, loopback IO, acct() writes etc.
+	 *
+	 * No need to css_get on root memcg as the reference
+	 * counting is disabled on the root level in the
+	 * cgroup core. See CSS_NO_REF.
+	 */
+	if (unlikely(!mm))
+		return root_mem_cgroup;
+
 	rcu_read_lock();
 	do {
-		/*
-		 * Page cache insertions can happen without an
-		 * actual mm context, e.g. during disk probing
-		 * on boot, loopback IO, acct() writes etc.
-		 */
-		if (unlikely(!mm))
+		memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
+		if (unlikely(!memcg))
 			memcg = root_mem_cgroup;
-		else {
-			memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
-			if (unlikely(!memcg))
-				memcg = root_mem_cgroup;
-		}
 	} while (!css_tryget(&memcg->css));
 	rcu_read_unlock();
 	return memcg;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


