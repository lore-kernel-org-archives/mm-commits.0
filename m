Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 937F8C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7910A61476
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhD3F4y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:56:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230215AbhD3F4x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:56:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A576261476;
        Fri, 30 Apr 2021 05:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762165;
        bh=hGEwIJBktLsk9Ez2TwB9RJVVkoujpdUbhQ9YSjHc/lI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xDwtqVFvI9QS8+E7nZTAVvM0hDwwtFhTGcni1AL6THeA/YD/zeiR8/am2DwnkZleJ
         BiJXl1WlxTqwJGnuF9MW0s7dJuZYz9T3c3OkzM06DjpTRyBexN9aOwxFwk8aVGkY9W
         EFiX40Cwaufv1Lk1eZGjA8n39qbYsnw0qZv+Zc5E=
Date:   Thu, 29 Apr 2021 22:56:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, torvalds@linux-foundation.org
Subject:  [patch 057/178] memcg: cleanup root memcg checks
Message-ID: <20210430055605.GZJjrVveZ%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
