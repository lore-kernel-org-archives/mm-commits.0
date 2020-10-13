Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0056C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E0D321D7F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630555;
	bh=CWl1mhGu+/ULT7yR1MJsms7vjF86Uf+8Yp4MurKhFAY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Nds0FtyayOiNyO4PQw72U3Umnn/NpY3JHH06NZUTQHHM0Q0HBVrqqkBVNwAtKbu3d
	 NlKBoazqlVk1o+ZX8U00ACxqxVnlrL9vN/BvZkenC9GMLJUp2LRuMIjJS9+Vf/FiWW
	 yvP7X1SKmnl+StDguCbOeOlLFX1dJu2uMiRIO+8g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgJMXJP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgJMXJP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:09:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04C2521D40;
        Tue, 13 Oct 2020 23:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630554;
        bh=CWl1mhGu+/ULT7yR1MJsms7vjF86Uf+8Yp4MurKhFAY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Me6XK1mQ2CoAFt8aX+QA/nmO5XnADq2gHiyAgX+/ivqJSKfzN0dfxqHOrP3tlsYjf
         EZSxJlt2IMDKZrJUmUi1W7GQOVg7qh3F77t7+GxIsBIULM7XPY9zMHQxJ8IxqLMejh
         rRP+SagFMWv7fFYcGDrGouPrl5coPRK6h5C4soWo=
Date:   Tue, 13 Oct 2020 16:09:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        laoar.shao@gmail.com, longman@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        vdavydov.dev@gmail.com
Subject:  [folded-merged]
 mm-memcg-simplify-mem_cgroup_get_max-v4.patch removed from -mm tree
Message-ID: <20201013230913.qh6iD1EGl%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-simplify-mem_cgroup_get_max-v4
has been removed from the -mm tree.  Its filename was
     mm-memcg-simplify-mem_cgroup_get_max-v4.patch

This patch was dropped because it was folded into mm-memcg-simplify-mem_cgroup_get_max.patch

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm-memcg-simplify-mem_cgroup_get_max-v4

Link: https://lkml.kernel.org/r/20200914150928.7841-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-simplify-mem_cgroup_get_max-v4
+++ a/mm/memcontrol.c
@@ -1640,8 +1640,12 @@ unsigned long mem_cgroup_get_max(struct
 			max += min(READ_ONCE(memcg->swap.max),
 				   (unsigned long)total_swap_pages);
 	} else { /* v1 */
-		if (mem_cgroup_swappiness(memcg))
-			max = memcg->memsw.max;
+		if (mem_cgroup_swappiness(memcg)) {
+			/* Calculate swap excess capacity from memsw limit */
+			unsigned long swap = READ_ONCE(memcg->memsw.max) - max;
+
+			max += min(swap, (unsigned long)total_swap_pages);
+		}
 	}
 	return max;
 }
_

Patches currently in -mm which might be from longman@redhat.com are

mm-memcg-clean-up-obsolete-enum-charge_type.patch
mm-memcg-simplify-mem_cgroup_get_max.patch
mm-memcg-unify-swap-and-memsw-page-counters.patch

